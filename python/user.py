from fastapi import APIRouter
import pymysql
import base64
import io
from PIL import Image

class User:
    def __init__(self):
        self.connection = None
        self.cursor = None
        self.connect()

    def connect(self):
        try:
            self.connection = pymysql.connect(
                 host='192.168.50.123',
                 user='root',
                 password='qwer1234',
                 db='Address',
                 charset='utf8',
                 cursorclass=pymysql.cursors.DictCursor
            )
            self.cursor = self.connection.cursor()
            print("MySQL 데이터베이스에 연결되었습니다.")
        except pymysql.Error as e:
            print(f"Error: {e}")

    def insert_address(self, name, phone_number, address, relation, image):
        try:
            sql = """INSERT INTO addresses (name, phone_number, address, relation, image)
                     VALUES (%s, %s, %s, %s, %s)"""
            img_byte_arr = io.BytesIO()
            image.save(img_byte_arr, format='PNG')
            img_byte_arr = img_byte_arr.getvalue()
            values = (name, phone_number, address, relation, img_byte_arr)
            self.cursor.execute(sql, values)
            self.connection.commit()
            print("주소가 성공적으로 추가되었습니다.")
        except pymysql.Error as e:
            print(f"Error: {e}")

    def get_all_addresses(self):
        try:
            self.cursor.execute("SELECT * FROM addresses")
            rows = self.cursor.fetchall()
            addresses = []
            for row in rows:
                image = Image.open(io.BytesIO(row['image']))
                addresses.append({
                    'seq': row['seq'],
                    'name': row['name'],
                    'phoneNumber': row['phone_number'],
                    'address': row['address'],
                    'relation': row['relation'],
                    'image': image
                })
            return addresses
        except pymysql.Error as e:
            print(f"Error: {e}")
            return []

    def update_address(self, seq, name, phone_number, address, relation, image):
        try:
            sql = """UPDATE addresses SET name = %s, phone_number = %s, address = %s,
                     relation = %s, image = %s WHERE seq = %s"""
            img_byte_arr = io.BytesIO()
            image.save(img_byte_arr, format='PNG')
            img_byte_arr = img_byte_arr.getvalue()
            values = (name, phone_number, address, relation, img_byte_arr, seq)
            self.cursor.execute(sql, values)
            self.connection.commit()
            print("주소가 성공적으로 업데이트되었습니다.")
        except pymysql.Error as e:
            print(f"Error: {e}")

    def delete_address(self, seq):
        try:
            sql = "DELETE FROM addresses WHERE seq = %s"
            self.cursor.execute(sql, (seq,))
            self.connection.commit()
            print("주소가 성공적으로 삭제되었습니다.")
        except pymysql.Error as e:
            print(f"Error: {e}")

    def close_connection(self):
        if self.connection:
            self.cursor.close()
            self.connection.close()
            print("MySQL 연결이 종료되었습니다.")
