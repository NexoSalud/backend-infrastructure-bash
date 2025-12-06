# 🏥 Nexo Salud - Sistema de Gestión Médica

Sistema de microservicios reactivos para gestión de servicios médicos, desarrollado con Spring Boot WebFlux y PostgreSQL.

## 📋 Arquitectura del Sistema

### Módulos Disponibles:
- **🌐 Gateway Service** (puerto 8080) - API Gateway con autenticación JWT y documentación Swagger
- **👥 Users Service** (puerto 8081) - Gestión de usuarios del sistema
- **👔 Employees Service** (puerto 8082) - Gestión de empleados médicos
- **📅 Schedule Service** (puerto 8083) - Gestión de horarios y citas

### Tecnologías:
- ☕ **Java 17** con Spring Boot 3.2.5
- ⚡ **WebFlux** (Programación Reactiva)
- 🐘 **PostgreSQL 15** (Base de datos)
- 🔄 **R2DBC** (Acceso reactivo a base de datos)
- 🐳 **Docker** (Contenedores)
- 🔐 **JWT** (Autenticación)
- 📚 **SpringDoc OpenAPI** (Documentación API)

## 🚀 Inicio Rápido

### Prerequisitos:
- Java 17+
- Maven 3.8+
- Docker y Docker Compose
- Git

### 1. Preparar el Entorno:
```bash
# Clonar el proyecto
git clone <tu-repo>
cd nexo

# Opción A: Preparar entorno para desarrollo local
./start-nexo.sh
./start_services.sh

# Opción B: Solo iniciar PostgreSQL
./start-db.sh
```

### 2. Iniciar Servicios:

#### Opción A: Con Docker (Recomendado)
```bash
# Iniciar todos los servicios con Docker Compose
./docker-start.sh

# Verificar que los servicios estén corriendo
docker-compose ps

# Ver logs de todos los servicios
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f gateway-service
```

#### Opción B: Servicios Individuales (Desarrollo)
```bash
# En terminales separadas:
./start-gateway.sh     # Gateway (puerto 8080)
./start-users.sh       # Users (puerto 8081)
./start-employees.sh   # Employees (puerto 8082)
./start-schedule.sh    # Schedule (puerto 8083)
```

#### Opción B: Manual con Maven
```bash
# Gateway
cd backend-module-gateway && mvn spring-boot:run

# En terminales separadas:
cd backend-module-users && mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8081"
cd backend-module-employees && mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8082"
cd backend-module-schedule && mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8083"
```

## 🐳 Despliegue con Docker

### Arquitectura Docker:
- **Servicios Internos**: Solo se comunican entre ellos (red interna)
- **Gateway Expuesto**: Único punto de acceso desde el host (puerto 8080)
- **Base de Datos**: PostgreSQL compartida con múltiples bases de datos

### Comandos Docker:
```bash
# Iniciar todos los servicios
./docker-start.sh

# Detener servicios
./docker-stop.sh

# Ver logs en tiempo real
docker-compose logs -f

# Reconstruir imágenes
docker-compose up --build

# Limpiar todo (contenedores, imágenes, volúmenes)
docker-compose down --volumes --rmi all
```

### URLs con Docker:
- **Gateway (único expuesto)**: http://localhost:8080
- **PostgreSQL**: localhost:5432 (base de datos: nexosalud)
- **Servicios internos**: Solo accesibles através del gateway

## 🔗 URLs Importantes

### API Gateway:
- **Base URL**: http://localhost:8080
- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **API Docs**: http://localhost:8080/v3/api-docs
- **Health Check**: http://localhost:8080/actuator/health

### Servicios Individuales:
- **Users API**: http://localhost:8081
- **Employees API**: http://localhost:8082
- **Schedule API**: http://localhost:8083

### Base de Datos:
- **PostgreSQL**: localhost:5432
- **Usuario**: postgres
- **Contraseña**: postgres

## 🗄️ Base de Datos

Todos los servicios comparten una única base de datos PostgreSQL:
- **Base de Datos**: nexosalud
- **Esquemas**: Cada servicio utiliza sus propias tablas dentro de la misma base
- **Usuario**: postgres  
- **Contraseña**: postgres
- **Puerto**: 5432

## 🛠️ Comandos Útiles

### Scripts de Inicio:
```bash
# Preparar entorno completo (PostgreSQL + compilar módulos)
./start-nexo.sh

# Solo iniciar PostgreSQL
./start-db.sh

# Iniciar servicios individuales (requiere PostgreSQL activo)
./start-gateway.sh     # Gateway en puerto 8080
./start-users.sh       # Users Service en puerto 8081
./start-employees.sh   # Employees Service en puerto 8082
./start-schedule.sh    # Schedule Service en puerto 8083

# Iniciación completa con Docker
./docker-start.sh      # Todos los servicios en contenedores
./docker-stop.sh       # Detener servicios Docker
```

### Docker:
```bash
# Ver estado de contenedores
docker compose ps

# Ver logs de PostgreSQL
docker compose logs webflux-postgres

# Reiniciar PostgreSQL
docker compose restart webflux-postgres

# Parar todos los contenedores
docker compose down
```

### Base de Datos:
```bash
# Conectar a PostgreSQL
docker compose exec webflux-postgres psql -U postgres

# Ver bases de datos
\l

# Conectar a una base específica
\c nexosalud
```

### Maven:
```bash
# Compilar todos los módulos
mvn clean package -DskipTests

# Ejecutar tests
mvn test

# Compilar módulo específico
cd backend-module-gateway && mvn clean package
```

## 🔐 Autenticación

El sistema utiliza JWT para autenticación:

### Modo Mock (Desarrollo):
Por defecto está habilitado el modo mock. Cualquier token JWT válido será aceptado.

### Endpoints Públicos:
- `/swagger-ui/**`
- `/v3/api-docs/**`
- `/webjars/**`
- `/auth/login`
- `/actuator/health`

## 📊 Monitoreo

### Health Checks:
```bash
# Gateway
curl http://localhost:8080/actuator/health

# Servicios individuales
curl http://localhost:8081/actuator/health
curl http://localhost:8082/actuator/health
curl http://localhost:8083/actuator/health
```

### Base de Datos:
```bash
# Verificar conectividad
docker compose exec webflux-postgres pg_isready -U postgres
```

## 🐛 Solución de Problemas

### PostgreSQL no inicia:
```bash
# Verificar Docker
docker info

# Reiniciar PostgreSQL
docker compose down && docker compose up -d

# Ver logs
docker compose logs webflux-postgres
```

### Errores de conexión:
1. Verificar que PostgreSQL esté corriendo
2. Confirmar que los puertos no estén ocupados
3. Revisar configuraciones en `application.yml`

### Swagger UI no carga:
1. Verificar que el Gateway esté corriendo en puerto 8080
2. Acceder a: http://localhost:8080/swagger-ui.html
3. Revisar logs del Gateway para errores

## 📁 Estructura del Proyecto

```
nexo/
├── backend-module-gateway/     # API Gateway
├── backend-module-users/       # Servicio de Usuarios
├── backend-module-employees/   # Servicio de Empleados  
├── backend-module-schedule/    # Servicio de Horarios
├── docker-compose.yml          # Configuración PostgreSQL
├── init-scripts/              # Scripts de inicialización DB
├── start-nexo.sh             # Script de inicio principal
├── start-gateway.sh          # Iniciar Gateway
├── start-users.sh           # Iniciar Users Service
├── start-employees.sh       # Iniciar Employees Service
├── start-schedule.sh        # Iniciar Schedule Service
└── README.md               # Esta documentación
```

## 🤝 Contribución

1. Fork del proyecto
2. Crear rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver archivo `LICENSE` para más detalles.