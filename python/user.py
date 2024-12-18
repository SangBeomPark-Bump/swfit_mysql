from fastapi import APIRouter
import pymysql
import base64

from fastapi import FastAPI, File, UploadFile, Form
from fastapi.responses import JSONResponse
import shutil
import os

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

def decode_image(base64_string):
    return base64.b64decode(base64_string)

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

    image_decoded = decode_image(image)

    try:
        sql = "insert into user(name, phone, address, relationship, image) values (%s, %s, %s, %s, %s)"
        curs.execute(sql, (name, phone, address, relationship, image_decoded))
        conn.commit()
        conn.close()
        return {'results' : 'OK'}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'results' : 'Error'}
    
@router.get("/user_update")
async def update(seq: int, name: str, phone: str, address: str, relationship: str):
    conn = connection()
    curs = conn.cursor()

    # image_decoded = decode_image(image)

    try:
        sql = "update user set name = %s, phone = %s, address = %s, relationship = %s, where seq = %s"
        curs.execute(sql, (name, phone, address, relationship, seq))
        conn.commit()
        conn.close()
        return {'results' : 'OK'}
    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'results' : 'Error'}
    

@router.post("/upload_image")
async def upload_image(seq: int = Form(...), image: UploadFile = File(...)):
    try:

        contents = await image.read()  # 비동기로 파일 내용을 읽습니다.
        
        # 데이터베이스에 seq와 이미지 경로 저장
        conn = connection()
        cursor = conn.cursor()
        cursor.execute("UPDATE user SET image = %s WHERE seq = %s", (contents, seq))
        conn.commit()
        conn.close()

        return JSONResponse(content={"message": "Image uploaded and data updated successfully", "filename": image.filename}, status_code=200)
    
    except Exception as e:
        return JSONResponse(content={"message": f"Failed to upload image or update database: {str(e)}"}, status_code=500)