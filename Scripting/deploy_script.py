import csv
import sqlite3
import os
import shutil
import logging
from cryptography.fernet import Fernet

# Configure logging
logging.basicConfig(level=logging.ERROR, format='%(asctime)s - %(levelname)s - %(message)s')

# Generate a key for encryption
key = Fernet.generate_key()
cipher_suite = Fernet(key)

def encrypt_data(data):
    """
    Encrypt sensitive data in the given dictionary.
    """
    encrypted_data = {}
    for key, value in data.items():
        if key in ['quantity', 'unit']:
            encrypted_value = cipher_suite.encrypt(str(value).encode())
            encrypted_data[key] = encrypted_value.decode()
        else:
            encrypted_data[key] = value
    return encrypted_data

def decrypt_data(data):
    """
    Decrypt sensitive data in the given dictionary.
    """
    decrypted_data = {}
    for key, value in data.items():
        if key in ['quantity', 'unit']:
            decrypted_value = cipher_suite.decrypt(value.encode()).decode()
            decrypted_data[key] = decrypted_value
        else:
            decrypted_data[key] = value
    return decrypted_data

def read_csv_data(file_path):
    """
    Read data from a CSV file and return it as a list of dictionaries.
    """
    try:
        with open(file_path, 'r') as file:
            reader = csv.DictReader(file)
            data = [decrypt_data(row) for row in reader]
        return data
    except FileNotFoundError:
        logging.error(f"File not found: {file_path}")
        return []
    except Exception as e:
        logging.error(f"Error reading CSV file: {str(e)}")
        return []

def write_csv_data(file_path, data, fieldnames):
    """
    Write data to a CSV file with the specified fieldnames.
    """
    try:
        with open(file_path, 'w', newline='') as file:
            writer = csv.DictWriter(file, fieldnames=fieldnames)
            writer.writeheader()
            encrypted_data = [encrypt_data(row) for row in data]
            writer.writerows(encrypted_data)
    except Exception as e:
        logging.error(f"Error writing CSV file: {str(e)}")

def create_database(db_name):
    """
    Create a SQLite database with the specified name and return a secure connection to it.
    """
    try:
        conn = sqlite3.connect(f"file:{db_name}?mode=rw&cipher=aes-256-cfb&kdf_iter=64000", uri=True)
        cursor = conn.cursor()
        cursor.execute('''CREATE TABLE IF NOT EXISTS blasting_data
                          (blasting_material TEXT, quantity TEXT, unit TEXT)''')
        conn.commit()
        return conn
    except sqlite3.Error as e:
        logging.error(f"Error creating database: {str(e)}")
        return None

def import_data_to_database(conn, data):
    """
    Import data into the specified SQLite database securely.
    """
    try:
        cursor = conn.cursor()
        for row in data:
            encrypted_row = encrypt_data(row)
            cursor.execute('''INSERT INTO blasting_data (blasting_material, quantity, unit)
                              VALUES (?, ?, ?)''',
                           (encrypted_row['blasting_material'], encrypted_row['quantity'], encrypted_row['unit']))
        conn.commit()
    except sqlite3.Error as e:
        logging.error(f"Error importing data to database: {str(e)}")
    except KeyError as e:
        logging.error(f"Missing column in data: {str(e)}")

def deploy_database_to_region(db_file, region):
    """
    Deploy a database file to the specified region mimicking AWS EFS deployment securely.
    """
    try:
        efs_dir = f"aws_efs/{region}"
        os.makedirs(efs_dir, exist_ok=True)
        dest_path = os.path.join(efs_dir, db_file)
        
        # Encrypt the database file before deploying
        with open(db_file, 'rb') as file:
            encrypted_data = cipher_suite.encrypt(file.read())
        with open(dest_path, 'wb') as file:
            file.write(encrypted_data)
        
        # Set secure file permissions
        os.chmod(dest_path, 0o600)
    except Exception as e:
        logging.error(f"Error deploying database to region: {str(e)}")

def main():
    # Input and output file paths
    input_file = "data/data.csv"
    sorted_data_file = "data/sorted_data.csv"

    # Regions for deployment
    regions = ["China", "Germany", "Wakanda"]

    # Read data from CSV file
    data = read_csv_data(input_file)

    # Sort data by mine site
    sorted_data = sorted(data, key=lambda row: row['mine_site'])

    # Write sorted data to CSV file
    fieldnames = ['mine_site', 'blasting_material', 'quantity', 'unit']
    write_csv_data(sorted_data_file, sorted_data, fieldnames)

    # Create SQLite databases for each mine site and import data securely
    mine_sites = set(row['mine_site'] for row in sorted_data)
    for mine_site in mine_sites:
        db_name = f"databases/{mine_site}.db"
        conn = create_database(db_name)
        if conn:
            mine_site_data = [row for row in sorted_data if row['mine_site'] == mine_site]
            import_data_to_database(conn, mine_site_data)
            conn.close()

    # Deploy databases to regions mimicking AWS EFS securely
    for db_file in os.listdir("databases"):
        for region in regions:
            deploy_database_to_region(os.path.join("databases", db_file), region)

    print(f"Databases deployed securely to mimicked AWS EFS instances in regions: {', '.join(regions)}")

if __name__ == "__main__":
    main()