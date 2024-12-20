from flask import Blueprint, request, jsonify
from db import get_db_connection

alerts_routes = Blueprint('alerts_routes', __name__)

# Criar alerta
@alerts_routes.route('/alert', methods=['POST'])
def create_alert():
    alert_type = request.json.get('type')
    location = request.json.get('location')
    image = request.json.get('image')

    if not alert_type or not location:
        return jsonify({'success': False, 'message': 'Type and location are required'}), 400

    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute(
            "INSERT INTO alerts (type, image, localization) VALUES (%s, %s, %s)",
            (alert_type, image, location),
        )
        conn.commit()

        return jsonify({'success': True, 'message': 'Alert created successfully'})
    except Exception as e:
        print(f"Error in create_alert: {e}")
        return jsonify({'success': False, 'message': 'Failed to create alert'}), 500
    finally:
        cursor.close()
        conn.close()

# Ler todos os alertas
@alerts_routes.route('/alerts', methods=['GET'])
def get_all_alerts():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("SELECT id, type, image, localization FROM alerts;")
        alerts = cursor.fetchall()

        if alerts:
            return jsonify({'success': True, 'alerts': alerts})
        else:
            return jsonify({'success': False, 'message': 'No alerts found'})
    except Exception as e:
        print(f"Error in get_all_alerts: {e}")
        return jsonify({'success': False, 'message': 'Failed to fetch alerts'}), 500
    finally:
        cursor.close()
        conn.close()