import sqlite3

DB_NAME ="tasks.db"

def get_dtb():
    conectar = sqlite3.connect(DB_NAME, check_same_thread=False)
    return conectar, conectar.cursor()

def init_dtb():
    conectar, cursor = get_dtb()
    with open("datos.sql","r") as f:
        cursor.executescript(f.read())
    conectar.commit()

init_dtb()