# Blasting Data Management Script

This script is designed to manage blasting data for ZeroX, a leading supplier of blasting materials. It performs the following tasks:

1. Sorts the blasting data by mine site.
2. Creates SQLite databases for each mine site.
3. Imports the blasting data into the corresponding mine site databases.
4. Deploys the databases to three different regions (China, Germany, and Wakanda) mimicking AWS EFS deployment.

## Requirements

- Python 3.x
- Required Python packages:
  - `csv`: for reading and writing CSV files
  - `sqlite3`: for working with SQLite databases
  - `os` and `shutil`: for file and directory operations
  - `logging`: for logging error messages
  - `cryptography`: for data encryption and decryption

## Installation

1. Clone the repository or download the script files.
2. Ensure that you have Python 3.x installed on your system.
3. Install the required Python packages by running the following command:

## Usage

1. Prepare your blasting data in a CSV file named `data.csv` with the following columns:
- `mine_site`: the name or identifier of the mine site
- `blasting_material`: the name of the blasting material
- `quantity`: the quantity of the blasting material
- `unit`: the unit of measurement for the quantity

2. Place the `data.csv` file in the `data` directory of the project.

3. Open a terminal or command prompt and navigate to the project directory.

4. Run the script using the following command:

5. The script will perform the following tasks:
- Read the blasting data from `data.csv`.
- Sort the data by mine site.
- Write the sorted data to `sorted_data.csv`.
- Create SQLite databases for each mine site in the `databases` directory.
- Import the blasting data into the corresponding mine site databases.
- Deploy the databases to the specified regions (China, Germany, and Wakanda) mimicking AWS EFS deployment.

6. After the script execution, you will find the sorted data in `sorted_data.csv`, the SQLite databases in the `databases` directory, and the deployed databases in the `aws_efs` directory.

## Security Measures

The script implements the following security measures to protect sensitive data:

- Encryption of sensitive data (quantity and unit) before writing to CSV files and databases.
- Use of secure connections when creating and connecting to SQLite databases.
- Encryption of database files before deploying them to regions.
- Setting secure file permissions for deployed database files.

Please note that the encryption key is generated dynamically within the script. In a production environment, you should consider secure key management practices.

## Error Handling

The script includes error handling to gracefully handle potential exceptions and provide informative error messages. Errors are logged using the `logging` module, and the script continues execution even if certain operations fail.

## Dependencies

The script relies on the following Python packages:

- `csv`: for reading and writing CSV files
- `sqlite3`: for working with SQLite databases
- `os` and `shutil`: for file and directory operations
- `logging`: for logging error messages
- `cryptography`: for data encryption and decryption

Make sure to install the required packages before running the script.

## License

This script is provided under the [MIT License](https://opensource.org/licenses/MIT). Feel free to modify and distribute it according to your needs.

## Contact

If you have any questions or suggestions regarding this script, please contact the development team at dev@zerox.com.