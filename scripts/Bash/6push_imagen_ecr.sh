#!/bin/bash

# Detectar región configurada
REGION=$(aws configure get region)

# Detectar Account ID del usuario logueado
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Validar región
if [ -z "$REGION" ]; then
  echo "No se detectó región configurada en AWS CLI."
  read -p "Ingresa la región (ej: us-east-1): " REGION
fi

# Validar account ID
if [ -z "$ACCOUNT_ID" ]; then
  echo "No se pudo obtener el Account ID."
  read -p "Ingresa tu AWS Account ID: " ACCOUNT_ID
fi

echo "Usando región: $REGION"
echo "Usando Account ID: $ACCOUNT_ID"

# Login en ECR
aws ecr get-login-password --region $REGION \
  | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Tag de la imagen
docker tag feedback-app:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/feedback-backend:latest

# Push a ECR
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/feedback-backend:latest

echo "Imagen enviada correctamente a ECR."
