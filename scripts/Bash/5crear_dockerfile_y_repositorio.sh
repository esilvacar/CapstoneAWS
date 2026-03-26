#!/bin/bash
set -e

REPO_NAME="feedback-backend"
IMAGE_NAME="feedback-app"
REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "=== 1. Creando Dockerfile ==="
cat << 'EOF' > Dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
COPY index.html .

EXPOSE 5000

CMD ["python", "app.py"]
EOF

echo "Dockerfile creado correctamente."

echo "=== 2. Construyendo imagen Docker ==="
docker build -t $IMAGE_NAME .

echo "Imagen Docker construida: $IMAGE_NAME"

echo "=== 3. Verificando si el repositorio ECR existe ==="
if aws ecr describe-repositories --repository-names $REPO_NAME --region $REGION >/dev/null 2>&1; then
    echo "Repositorio ya existe: $REPO_NAME"
else
    echo "Repositorio no existe. Creándolo..."
    aws ecr create-repository --repository-name $REPO_NAME --region $REGION
    echo "Repositorio creado: $REPO_NAME"
fi

echo "=== PROCESO COMPLETADO ==="
echo "Dockerfile creado, imagen construida y repositorio ECR verificado."
