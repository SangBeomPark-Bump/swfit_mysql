from fastapi import APIRouter
import pymysql
import base64

router = APIRouter()

def connection():
    conn = pymysql.connect(
        host='192.168.50.123',
        user='root',
        password='qwer1234',
        db='Address',
        charset='utf8',
        cursorclass=pymysql.cursors.DictCursor
    )
    return conn

def encode_image(image_data):
    return base64.b64encode(image_data).decode('utf-8')

@router.get("/user_select")
async def select():
    conn = connection()
    curs = conn.cursor()
    sql = "SELECT * FROM user"
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()


    for row in rows:
        if row['image']:
            row['image'] = encode_image(row['image'])
    # print(rows)

    return rows

@router.get("/user_insert")
async def insert(name: str, phone: str, address: str, relationship: str, image: str):
    conn = connection()
    curs = conn.cursor()

    try:
        sql = "insert into user(name, phone, address, relationship, image) values (%s, %s, %s, %s, %s)"
        curs.execute(sql, (name, phone, address, relationship, image))
        conn.commit()
        conn.close()
        return {'results' : 'OK'}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'results' : 'Error'}
    
@router.get("/user_update")
async def update(seq: int, name: str, phone: str, address: str, relationship: str, image: str):
    conn = connection()
    curs = conn.cursor()

    try:
        sql = "update user set name = %s, phone = %s, address = %s, relationship = %s, image = %s where seq = %s"
        curs.execute(sql, (name, phone, address, relationship, image, seq))
        conn.commit()
        conn.close()
        return {'results' : 'OK'}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'results' : 'Error'}