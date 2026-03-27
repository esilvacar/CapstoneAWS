# Capstone AWS - Guía paso a paso para realizar el despliegue del proyecto

## Descripción

Esta solución crea un portal contenerizado con ECS Fargate, 100% funcional, con almacenamiento en DynamoDB, implementado con contenedores y alta disponibilidad, siguiendo buenas prácticas de seguridad, escalabilidad y monitoreo, que permita a los clientes aplicar un formalario para brindar a corto plazo un servicio más personalizado.

## Archivos Generados

### Archivos Principales
- **variables.tf** - Definición de todas las variables con descripciones detalladas
- **terraform.tfvars** - Valores por defecto para el ambiente Desarrollo
- **terraform.tfvars.qa** - Valores específicos para el ambiente QA
- **terraform.tfvars.uat** - Valores específicos para el ambiente UAT
- **main.tf** - Definición de recursos de Azure
- **provider.tf** - Configuración del proveedor de Azure
- **terraform.tf** - Configuración de backend y proveedores requeridos

### Archivos Originales
- **terraform.tfstate** - Estado actual de los recursos
- **aztfexportResourceMapping.json** - Mapeo de recursos exportados
- **aztfexportSkippedResources.txt** - Recursos no exportados

## Estructura de Variables

Las variables están organizadas en las siguientes categorías:

### 1. Variables Generales
- `location` - Región de Azure (default: eastus)
- `resource_group_name` - Nombre del grupo de recursos
- `environment` - Ambiente (Desarrollo, Qa, Uat)
- `subscription_id` - ID de la suscripción
- `common_tags` - Tags comunes a todos los recursos

### 2. Máquina Virtual (Jumpbox)
- `vm_name` - Nombre de la VM
- `vm_size` - Tamaño de la instancia
- `vm_admin_username` - Usuario administrador
- `vm_zone` - Zona de disponibilidad
- Y más configuraciones específicas de SO y almacenamiento

### 3. Container Registry
- `container_registry_name` - Nombre del registro
- `container_registry_sku` - SKU (Basic, Standard, Premium)
- `container_registry_agent_pool_*` - Configuración del pool de agentes

### 4. Key Vaults
- Mapeos de Key Vaults por ambiente
- Configuración de protección y retención

### 5. Managed Identities y Certificados
- Nombres de identidades administradas
- Mapeos de certificados a Key Vaults

### 6. Scope Maps del Container Registry
- Definiciones de permisos para repositorios
- Mapeos de admin, pull, push, etc.

### 7. Configuración de Red
- IDs de subredes privadas
- IDs de discos del SO

## Cómo Usar
### Ejecutar los siguientes pasos siguiendo el orden indicado

### 1. Importar a la consola de CloudShell los 5 archivos ubicados en la ruta CaptoneAWS/Scripts/Bash:

```bash
2CreaArchivo_app_py.sh
3Crear_html.sh
4crear_requirements_txt.sh
5crear_dockerfile_y_repositorio.sh
6push_imagen_ecr.sh
```

### 1.1 Preparar Backend + Formulario (Python Flask).
Es una API en Flask que recibe datos desde un formulario y los guarda en DynamoDB.
Creará archivo app.py que será utilizado por docker, ejecutar lo siguiente:

```bash
chmod +x 2CreaArchivo_app_py.sh
./2CreaArchivo_app_py.sh
```

### 1.2 Crea el Web FrontEnd HTML que será presentado al cliente 
Ejecutar lo siguiente:
```bash
chmod +x 3Crear_html.sh
./3Crear_html.sh
```

### 1.3 Crea el archivo requirements.txt
Este archivo será utilizado por docker, ejecutar lo siguiente:
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
ECS podrá usar esta imagen, ejecutar lo siguiente:
```bash
chmod +x 6push_imagen_ecr.sh
./6push_imagen_ecr.sh
```

### 2 Ejecución de archivos YAML para crear CloudFormation.
Importar a la consola de CloudShell los archivos ubicados en la ruta CaptoneAWS/Scripts/Deploy

### 2.1 Preparar Backend + Formulario (Python Flask)

```bash
	Crear VPC + Networking 
 Este template incluye:
	VPC services-vpc 10.83.0.0/20
	2 Subnets públicas (service-public-snet1 y service-public-snet2)
	2 Subnets privadas (service-private-snet1 y service-private-snet2)
	Internet Gateway + NAT Gateways (uno por subnet pública)
	Route Tables y asociaciones
	Alta disponibilidad (cada subnet en una AZ distinta)
	Security Groups base para ECS/ALB (puedes modificar luego)

	Ejecutar:
aws cloudformation create-stack \
  --stack-name services-vpc \
  --template-body file://7crea_vpc.yaml \
  --capabilities CAPABILITY_NAMED_IAM

```

### 1.1 Preparar Backend + Formulario (Python Flask).
Es una API en Flask que recibe datos desde un formulario y los guarda en DynamoDB.
Creará archivo app.py que será utilizado por docker, ejecutar lo siguiente:

```bash
chmod +x 2CreaArchivo_app_py.sh
./2CreaArchivo_app_py.sh
```

### 1.2 Crea el Web FrontEnd HTML que será presentado al cliente 
Ejecutar lo siguiente:
```bash
chmod +x 3Crear_html.sh
./3Crear_html.sh
--------------------------

## 1.6 Personalización para Nuevos Ambientes

Para crear un nuevo archivo de variables para un ambiente personalizado:

1. Copiar uno de los archivos existentes (ej. `terraform.tfvars.qa`)
2. Renombrarlo según el patrón `terraform.tfvars.<ambiente>`
3. Ajustar los valores según la configuración deseada
4. Ejecutar terraform con el archivo específico

Ejemplo para crear `terraform.tfvars.prod`:
```bash
# Copiar archivo base
Copy-Item terraform.tfvars.uat terraform.tfvars.prod

# Editar el archivo con los valores de producción
# Luego aplicar con:
terraform apply -var-file="terraform.tfvars.prod"
```

## Recursos Configurados

La solución incluye los siguientes tipos de recursos Azure:

- **Grupo de Recursos** (1) - Contenedor principal
- **Máquinas Virtuales Linux** (1) - Jumpbox/Agente
- **Interfaces de Red** (1) - Configuración de red
- **Grupos de Seguridad de Red** (1) - Firewall
- **Container Registry** (1) - Registro privado de contenedores
- **Agent Pools** (1) - Pool de agentes para CI/CD
- **Key Vaults** (3) - Almacenamiento de secretos y certificados
- **Managed Identities** (4) - Identidades del sistema
- **Certificados** (11) - Certificados digitales
- **Claves SSH Públicas** (3) - Acceso remoto
- **Private Endpoints** (3) - Acceso privado a servicios
- **Scope Maps** (5) - Permisos del Container Registry

## Tags Aplicados

Todos los recursos incluyen los siguientes tags:

- **Ambiente** - Desarrollo/QA/UAT
- **Aplicacion** - Middleware
- **CentroCostos** - Asignación de costos
- **CreadoPor** - Responsable de la creación
- **Proposito** - Descripción del propósito
- **SolicitadoPor** - Solicitante del recurso

Estos tags pueden personalizarse en los archivos `terraform.tfvars.<ambiente>`.

## Consideraciones Importantes

⚠️ **Seguridad:**
- Las claves SSH y secretos están marcados como variables sensibles
- No incluir valores reales de contraseñas en los archivos .tfvars
- Usar Azure Key Vault para almacenar secretos en producción

⚠️ **Costos:**
- El ambiente Desarrollo utiliza SKU Premium
- Revisar configuraciones de tamaños de VM y registros según requerimientos
- Ajustar según presupuesto disponible

⚠️ **Dependencias de Red:**
- Los agent pools requieren subredes específicas existentes
- Verificar que los IDs de subnet sean correctos para cada ambiente
- Actualizar `agent_pool_subnet_id` según su topología de red

## Validación

Para validar la configuración sin hacer cambios:

```bash
terraform validate
terraform plan -var-file="terraform.tfvars.qa"
```

## Destruir Recursos

Para eliminar todos los recursos en un ambiente:

```bash
# Mostrar qué será eliminado
terraform plan -destroy -var-file="terraform.tfvars.qa"

# Eliminar los recursos
terraform apply -destroy -var-file="terraform.tfvars.qa"
```

## Estado de Terraform

El archivo `terraform.tfstate` contiene el estado actual de los recursos. Consideraciones:

- **Backup**: Crear backups regulares del archivo tfstate
- **Remote State**: Para producción, usar Azure Storage como backend remoto
- **Locks**: Implementar locks distribuidos para evitar cambios simultáneos

## Próximos Pasos

Para mejorar esta solución, considere:

1. **Migrar a remote state**: Configurar backend en Azure Storage
2. **Módulos**: Reorganizar en módulos por componente
3. **Outputs**: Agregar outputs para IDs de recursos creados
4. **Validación**: Implementar políticas con Terraform Cloud/Enterprise
5. **Documentación**: Documentar decisiones de diseño específicas

---

**Última actualización**: 2026-03-26
**Ambiente objetivo**: Azure
**Región**: eastus
