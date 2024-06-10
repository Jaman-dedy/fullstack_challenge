import csv
import sqlite3
import os
import shutil
import logging
import traceback
from cryptography.fernet import Fernet

logging.basicConfig(level=logging.ERROR, format='%(asctime)s - %(levelname)s - %(message)s')

def read_csv_data(file_path):
    """
    Read data from a CSV file and return it as a list of dictionaries.
    """
    try:
        with open(file_path, 'r') as file:
            reader = csv.DictReader(file)
            data = list(reader)
        return data
    except FileNotFoundError:
        logging.error(f"File not found: {file_path}")
        print(f"File not found: {file_path}")
        return []
    except Exception as e:
        logging.error(f"Error reading CSV file: {str(e)}")
        print(f"Error reading CSV file: {str(e)}")
        print("Traceback:")
        traceback.print_exc()
        return []

def encrypt_data(data, encryption_key):
    """
    Encrypt sensitive data in the given dictionary using the provided encryption key.
    """
    f = Fernet(encryption_key)
    encrypted_data = {}
    for key, value in data.items():
        if key in ['blasting_material', 'quantity']:
            encrypted_value = f.encrypt(str(value).encode()).decode()
            encrypted_data[key] = encrypted_value
        else:
            encrypted_data[key] = value
    return encrypted_data

def write_csv_data(file_path, data, fieldnames, encryption_key):
    """
    Write data to a CSV file with the specified fieldnames, encrypting sensitive data.
    """
    try:
        with open(file_path, 'w', newline='') as file:
            writer = csv.DictWriter(file, fieldnames=fieldnames)
            writer.writeheader()
            for row in data:
                encrypted_row = encrypt_data(row, encryption_key)
                writer.writerow(encrypted_row)
    except Exception as e:
        logging.error(f"Error writing CSV file: {str(e)}")

def create_database(db_name):
    """
    Create a SQLite database with the specified name and return a connection to it.
    """
    try:
        conn = sqlite3.connect(db_name, check_same_thread=False, uri=True)
        cursor = conn.cursor()
        cursor.execute('''CREATE TABLE IF NOT EXISTS blasting_data
                          (blasting_material TEXT, quantity INTEGER, unit TEXT)''')
        conn.commit()
        return conn
    except sqlite3.Error as e:
        logging.error(f"Error creating database: {str(e)}")
        return None

def import_data_to_database(conn, data):
    """
    Import data into the specified SQLite database.
    """
    try:
        cursor = conn.cursor()
        for row in data:
            cursor.execute('''INSERT INTO blasting_data (blasting_material, quantity, unit)
                              VALUES (?, ?, ?)''',
                           (row['blasting_material'], int(row['quantity']), row['unit']))
        conn.commit()
    except sqlite3.Error as e:
        logging.error(f"Error importing data to database: {str(e)}")
    except KeyError as e:
        logging.error(f"Missing column in data: {str(e)}")

def deploy_database_to_region(db_file, region):
    """
    Deploy a database file to the specified region mimicking AWS EFS deployment.
    """
    try:
        efs_dir = f"aws_efs/{region}"
        os.makedirs(efs_dir, exist_ok=True)
        os.makedirs("databases", exist_ok=True)
        src_path = os.path.join("databases", db_file)
        dest_path = os.path.join(efs_dir, db_file)
        shutil.copy(src_path, dest_path)
    except Exception as e:
        logging.error(f"Error deploying database to region: {str(e)}")

def main():
    input_file = "data/data.csv"
    sorted_data_file = "data/sorted_data.csv"

    regions = ["China", "Germany", "Wakanda"]

    data = read_csv_data(input_file)
    sorted_data = sorted(data, key=lambda row: row['mine_site'])

    encryption_key = Fernet.generate_key()

    fieldnames = ['mine_site', 'blasting_material', 'quantity', 'unit']
    write_csv_data(sorted_data_file, sorted_data, fieldnames, encryption_key)

    os.makedirs("databases", exist_ok=True)

    mine_sites = set(row['mine_site'] for row in sorted_data)
    for mine_site in mine_sites:
        db_name = f"databases/{mine_site}.db"
        conn = create_database(db_name)
        if conn:
            mine_site_data = [row for row in sorted_data if row['mine_site'] == mine_site]
            import_data_to_database(conn, mine_site_data)
            conn.close()

    for db_file in os.listdir("databases"):
        for region in regions:
            deploy_database_to_region(db_file, region)

    print(f"Databases deployed to mimicked AWS EFS instances in regions: {', '.join(regions)}")

if __name__ == "__main__":
    main()