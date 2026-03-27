# Capstone AWS - Guía para realizar el despliegue del proyecto

## Descripción

Esta solución crea un portal contenerizado con ECS Fargate, 100% funcional, con almacenamiento en DynamoDB, implementado con contenedores y alta disponibilidad, siguiendo buenas prácticas de seguridad, escalabilidad y monitoreo, que permita a los clientes aplicar un formalario para brindar a corto plazo un servicio más personalizado.

## Archivos Generados

### Archivos Principales

- **2CreaArchivo_app_py.sh** - Es una API en Flask que recibe datos y los guarda en DynamoDB, creará archivo app.py que será utilizado por docker.
- **3Crear_html.sh** - Crea el Web FrontEnd HTML que será presentado al cliente.
- **4crear_requirements_txt.sh** - Crea el archivo requirements_txt que será utilizado por docker.
- **5crear_dockerfile_y_repositorio.sh** - Crea ek archivo Dockerfile y el repositorio.
- **6push_imagen_ecr.sh** - Hace push de la imagen en ECR
- **7crea_vpc.yaml** - Este templare crea:
             **VPC services-vpc 10.83.0.0/20** (1), 
             **Subnets públicas (service-public-snet1 y service-public-snet2)** (2), 
             **Subnets privadas** (service-private-snet1 y service-private-snet2) (2), 
             **Internet Gateway + NAT Gateways** (uno por subnet pública), 
             **Route Tables y asociaciones**, 
             **Alta disponibilidad** (cada subnet en una AZ distinta), 
             **Security Groups base para ECS/ALB** (se puede modificar luego si se requiere).
- **8crea_dynamodb.yaml** - Crea la BD DynamoDB donde se almacenará la información.
- **9ecs-core.yaml** - Crea ECS + IAM + CloudWatch Logs.
- **10alb.yaml** - Crea el Application Load Balancer, Security Groups y Target Group
- **11ecs-service.yaml** -  Crea el ECS SERVICE, TASK y el AUTOSCALING
- **12monitoring.yaml** - Crea el CloudWatch Alarms y el Dashboard para Feedback Portal


## Detalle paso a paso para el deploy del APLICATIVO
### Ejecutar los pasos siguientes en el orden indicado

## 1.  Importar a la consola de CloudShell los 5 archivos ubicados en la ruta CaptoneAWS/Scripts/Bash:

- **2CreaArchivo_app_py.sh**
- **3Crear_html.sh**
- **4crear_requirements_txt.sh**
- **5crear_dockerfile_y_repositorio.sh**
- **6push_imagen_ecr.sh**

### 1.1 Preparar Backend + Formulario (Python Flask).
Ejecutar lo siguiente:
```bash
chmod +x 2CreaArchivo_app_py.sh
./2CreaArchivo_app_py.sh
```

### 1.2 Crea el Web FrontEnd HTML 
Ejecutar lo siguiente:
```bash
chmod +x 3Crear_html.sh
./3Crear_html.sh
```

### 1.3 Crea el archivo requirements.txt
Ejecutar lo siguiente:
```bash
chmod +x 4crear_requirements_txt.sh
./4crear_requirements_txt.sh
```

### 1.4 Crea y ejecutar dockerfile y repositorio
Ejecutar lo siguiente:
```bash
chmod +x 5crear_dockerfile_y_repositorio.sh
./5crear_dockerfile_y_repositorio.sh
```

### 1.5 Push de la imagen en ECR
Ejecutar lo siguiente:
```bash
chmod +x 6push_imagen_ecr.sh
./6push_imagen_ecr.sh
```

## 2.  Ejecución de archivos YAML para crear CloudFormation.
Importar a la consola de CloudShell los archivos ubicados en la ruta CaptoneAWS/Scripts/Deploy

### 2.1 Crear VPC + Networking 
Ejecutar lo siguiente:
```bash
aws cloudformation create-stack \
  --stack-name services-vpc \
  --template-body file://7crea_vpc.yaml \
  --capabilities CAPABILITY_NAMED_IAM
```

### 2.2 Crear DynamoDB
Ejecutar lo siguiente:
```bash
aws cloudformation create-stack \
  --stack-name capstone-dynamodb \
  --template-body file://8crea_dynamodb.yaml
```

### 2.3 Crea ECS CORE (ECS + IAM + CloudWatch Logs)
Ejecutar lo siguiente:
```bash
aws cloudformation create-stack \
  --stack-name ecs-cluster-cloudWatch \
  --template-body file://9ecs-core.yaml \
  --capabilities CAPABILITY_NAMED_IAM
```
### 2.4 Crea ALB + Security Groups + Target Group
Ejecutar lo siguiente:
```bash
aws cloudformation create-stack \
  --stack-name alb \
  --template-body file://10alb.yaml 

```

### 2.5 Crea ECS SERVICE + TASK + AUTOSCALING
Ejecutar lo siguiente:
```bash
aws cloudformation create-stack \
  --stack-name ecs-service \
  --template-body file://11ecs-service.yaml \
  --parameters \
      ParameterKey=RepositoryName,ParameterValue=feedback-backend \
      ParameterKey=ImageTag,ParameterValue=latest \
  --capabilities CAPABILITY_NAMED_IAM
```

### 2.6 Crea CloudWatch Alarms + Dashboard para Feedback Portal
Ejecutar lo siguiente:
```bash
aws cloudformation create-stack \
--stack-name monitoring \
--template-body file://cloudformation/12monitoring.yaml

```

**Última actualización**: 2026-03-26
**Ambiente objetivo**: AWS
**Región**: US-EAST-1
