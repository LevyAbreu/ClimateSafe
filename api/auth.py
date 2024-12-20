from flask import Blueprint, request, jsonify
from db import get_db_connection

auth_routes = Blueprint('auth_routes', __name__)

# Login
@auth_routes.route('/login', methods=['POST'])
def login():
    login = request.json.get('login')
    password = request.json.get('password')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT id, name, login, email FROM auth WHERE login = %s AND password = %s", (login, password))
    user = cursor.fetchone()

    cursor.close()
    conn.close()

    if user:
        return jsonify({'success': True, 'message': 'Login successful', 'user': user})
    else:
        return jsonify({'success': False, 'message': 'Login or password is incorrect'})

# Register
@auth_routes.route('/user', methods=['POST'])
def register():
    name = request.json.get('name')
    login = request.json.get('login')
    email = request.json.get('email')
    password = request.json.get('password')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("INSERT INTO auth (name, login, email, password) VALUES (%s, %s, %s, %s)", (name, login, email, password))
    conn.commit()

    cursor.close()
    conn.close()

    return jsonify({'success': True, 'message': 'User registered successfully'})

# Update
@auth_routes.route('/user/<int:id>', methods=['PUT'])
def update_user(id):
    name = request.json.get('name')
    login = request.json.get('login')
    email = request.json.get('email')
    password = request.json.get('password')

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("UPDATE auth SET name = %s, login = %s, email = %s, password = %s WHERE id = %s", (name, login, email, password, id))
    conn.commit()

    cursor.close()
    conn.close()

    return jsonify({'success': True, 'message': 'User updated successfully'})

# Delete
@auth_routes.route('/user/<int:id>', methods=['DELETE'])
def delete_user(id):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("DELETE FROM auth WHERE id = %s", (id,))
    conn.commit()

    cursor.close()
    conn.close()

    return jsonify({'success': True, 'message': 'User deleted successfully'})


# Read
@auth_routes.route('/user', methods=['GET'])
def get_all_users():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT id, name, login, email, password FROM auth")
    users = cursor.fetchall()

    cursor.close()
    conn.close()

    if users:
        return jsonify({'success': True, 'users': users})
    else:
        return jsonify({'success': False, 'message': 'No users found'})
