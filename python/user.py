import mysql.connector
from mysql.connector import Error
import io
from PIL import Image

class User:
    def __init__(self):
        self.connection = None
        self.connect()

    def connect(self):
        try:
            self.connection = mysql.connector.connect(
                 host='192.168.50.123',
                 user='root',
                 password='qwer1234',
                 db='Address',
                 charset='utf8',
                 cursorclass=pymysql.cursors.DictCursor
            )
            if self.connection.is_connected():
                print("MySQL 데이터베이스에 연결되었습니다.")
        except Error as e:
            print(f"Error: {e}")

    def insert_address(self, name, phone_number, address, relation, image):
        try:
            cursor = self.connection.cursor()
            sql = """INSERT INTO addresses (name, phone_number, address, relation, image)
                     VALUES (%s, %s, %s, %s, %s)"""
            img_byte_arr = io.BytesIO()
            image.save(img_byte_arr, format='PNG')
            img_byte_arr = img_byte_arr.getvalue()
            values = (name, phone_number, address, relation, img_byte_arr)
            cursor.execute(sql, values)
            self.connection.commit()
            print("주소가 성공적으로 추가되었습니다.")
        except Error as e:
            print(f"Error: {e}")

    def get_all_addresses(self):
        try:
            cursor = self.connection.cursor()
            cursor.execute("SELECT * FROM addresses")
            rows = cursor.fetchall()
            addresses = []
            for row in rows:
                id, name, phone_number, address, relation, image_blob = row
                image = Image.open(io.BytesIO(image_blob))
                addresses.append({
                    'id': id,
                    'name': name,
                    'phoneNumber': phone_number,
                    'address': address,
                    'relation': relation,
                    'image': image
                })
            return addresses
        except Error as e:
            print(f"Error: {e}")
            return []

    def update_address(self, id, name, phone_number, address, relation, image):
        try:
            cursor = self.connection.cursor()
            sql = """UPDATE addresses SET name = %s, phone_number = %s, address = %s,
                     relation = %s, image = %s WHERE id = %s"""
            img_byte_arr = io.BytesIO()
            image.save(img_byte_arr, format='PNG')
            img_byte_arr = img_byte_arr.getvalue()
            values = (name, phone_number, address, relation, img_byte_arr, id)
            cursor.execute(sql, values)
            self.connection.commit()
            print("주소가 성공적으로 업데이트되었습니다.")
        except Error as e:
            print(f"Error: {e}")

    def delete_address(self, id):
        try:
            cursor = self.connection.cursor()
            sql = "DELETE FROM addresses WHERE id = %s"
            cursor.execute(sql, (id,))
            self.connection.commit()
            print("주소가 성공적으로 삭제되었습니다.")
        except Error as e:
            print(f"Error: {e}")

    def close_connection(self):
        if self.connection.is_connected():
            self.connection.close()
            print("MySQL 연결이 종료되었습니다.")
