import psycopg2

try:
    conn = psycopg2.connect(
        host="localhost",
        port=5432,
        dbname="world",
        user="raywu",
        password="60kg"
    )
except Exception as e:
    print("I am unable to connect to the database: {}".format(e))

cur = conn.cursor()

cur.execute(
    """
    SELECT * from city
    LIMIT 10
    """)
rows = cur.fetchall()
for row in rows:
    print(row)
