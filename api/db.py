import mysql.connector
from config import db_config

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host=db_config['host'],
            user=db_config['user'],
            password=db_config['password'],
            database=db_config['database']
        )
        return connection
    except mysql.connector.Error as err:
        print(f"Error connecting to database: {err}")
        raise
