#!/bin/bash

cat << 'EOF' > app.py
from flask import Flask, request, jsonify, send_from_directory
import boto3
import uuid
import datetime
import os

app = Flask(__name__)

# DynamoDB setup
dynamodb = boto3.resource('dynamodb', region_name=os.environ.get("AWS_REGION","us-east-1"))
table_name = os.environ.get("DYNAMODB_TABLE","Feedback")
table = dynamodb.Table(table_name)

# Health check
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status":"ok"}), 200

# Página HTML
@app.route('/', methods=['GET'])
def index():
    return send_from_directory('.', 'index.html')

# Submit feedback
@app.route('/feedback', methods=['POST'])
def feedback():
    data = request.json
    required_fields = ["Nombre", "Sugerencia"]
    for field in required_fields:
        if field not in data or not data[field]:
            return jsonify({"error": f"{field} es obligatorio"}), 400
    
    item = {
        "FeedbackId": str(uuid.uuid4()),
        "Nombre": data.get("Nombre"),
        "Ubicacion": data.get("Ubicacion",""),
        "PlatilloFavorito": data.get("PlatilloFavorito",""),
        "Sugerencia": data.get("Sugerencia"),
        "FechaCumpleanos": data.get("FechaCumpleanos",""),
        "Telefono": data.get("Telefono",""),
        "Email": data.get("Email",""),
        "FechaRegistro": datetime.datetime.utcnow().isoformat()
    }
    
    table.put_item(Item=item)
    return jsonify({"message":"Feedback guardado","id":item["FeedbackId"]}), 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF
