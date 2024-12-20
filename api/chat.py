from flask import Blueprint, request, jsonify
from db import get_db_connection

chat_routes = Blueprint('chat_routes', __name__)

# Criar nova mensagem
@chat_routes.route('/chat', methods=['POST'])
def create_message():
    message = request.json.get('message')
    username = request.json.get('username')

    # Verificar se 'message' e 'username' foram fornecidos
    if not message or not username:
        return jsonify({'success': False, 'message': 'Both message and username are required'}), 400

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Inserir dados na tabela chat
    cursor.execute("""
        INSERT INTO chat (message, username) 
        VALUES (%s, %s)
    """, (message, username))
    conn.commit()

    cursor.close()
    conn.close()

    return jsonify({'success': True, 'message': 'Message created successfully'})

# Ler todas as mensagens
@chat_routes.route('/messages', methods=['GET'])
def get_all_messages():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Buscar todas as mensagens da tabela chat
    cursor.execute("SELECT id, message, username FROM chat")
    messages = cursor.fetchall()

    cursor.close()
    conn.close()

    if messages:
        return jsonify({'success': True, 'messages': messages})
    else:
        return jsonify({'success': False, 'message': 'No messages found'})
