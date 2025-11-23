# Implementación de JWT para Autenticación Modular

## Resumen de Cambios

Se ha implementado un sistema de autenticación JWT modular con los siguientes componentes:

### 1. **Módulo de Sesión (backend-module-gateway:8082)**
   - **Responsabilidad**: Punto de entrada para autenticación y emisión de JWT
   - **Endpoint de Login**: `POST /api/v1/auth/login`
   - **Endpoint de Logout**: `POST /api/v1/auth/logout` (stateless, sin acción necesaria en servidor)

#### Nuevos componentes:
- **`JwtUtil.java`**: Utilidad para generar, validar y extraer claims de JWT
- **`SessionService.java`**: Servicio de sesión que coordina autenticación
- **`SessionController.java`**: Controller que maneja login/logout
- **`EmployeeClient.java`**: Cliente HTTP que se comunica con el módulo de empleados
- **DTOs**:
  - `LoginRequest`: Request con identificación y contraseña
  - `LoginResponse`: Response con token JWT generado
  - `AuthResponse`: DTO para comunicación con el módulo de empleados

#### Configuración JWT (application.yml):
```yaml
jwt:
  secret: ${JWT_SECRET:mySecretKeyForJWTTokenGenerationAndValidation1234567890}
  expiration: ${JWT_EXPIRATION:3600000}  # 1 hora en milisegundos
```

### 2. **Módulo de Empleados (backend-module-employees:8081)**
   - **Responsabilidad**: Validar credenciales y proporcionar información de roles/permisos
   - **Endpoint de Autenticación**: `POST /api/v1/employees/authenticate`

#### Nuevos componentes:
- **`EmployeeService.authenticate()`**: Valida credenciales y devuelve roles/permisos
- **`EmployeeController.authenticate()`**: Endpoint para validar credenciales
- **DTOs**:
  - `AuthRequest`: Request con identification y password
  - `AuthResponse`: Response con usuario, roles y permisos

#### Características:
- Las contraseñas se almacenan con hash BCrypt
- El sistema devuelve el rol_id, nombre del rol y lista de permisos asociados
- Integración con `RolService` para obtener permisos del rol

### 3. **Módulo de Usuarios (backend-module-users:8080)**
   - Sin cambios en esta versión (puede extenderse para validación de permisos futura)

---

## Flujo de Autenticación

```
1. Cliente envía credenciales a: POST /api/v1/auth/login
   {
     "identification_type": "CC",
     "identification_number": "12345",
     "password": "micontraseña"
   }

2. SessionService recibe la solicitud y llama a EmployeeClient
   EmployeeClient -> POST /api/v1/employees/authenticate

3. EmployeeService valida:
   - Existe el empleado con esa identification
   - La contraseña coincide (BCrypt)
   - Recupera rol_id

4. RolService obtiene roles y permisos del rol_id

5. EmployeeService devuelve AuthResponse con:
   - id, names, lastnames
   - rol_id, rol_nombre
   - lista de permisos

6. SessionService genera JWT con claims:
   - user_id
   - username (names + lastnames)
   - rol (rol_nombre)
   - permisos (lista)

7. Client recibe LoginResponse con token JWT

8. Cliente incluye token en header Authorization:
   Authorization: Bearer <token>
```

---

## Ejecutar el Sistema

### Requisitos
- Java 17+
- Maven 3.8+
- Opcionalmente: PostgreSQL (para producción)

### Desarrollo Local (H2 en memoria)

```bash
# Terminal 1 - Módulo de Empleados (puerto 8081)
cd backend-module-employees
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev"

# Terminal 2 - Módulo de Sesión (puerto 8082)
cd backend-module-gateway
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev"

# Terminal 3 - Módulo de Usuarios (puerto 8080) [opcional]
cd backend-module-users
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev"
```

### Con Docker (Producción)

```bash
# Compilar módulos
mvn clean package -DskipTests

# Ejecutar con docker-compose (si existe)
docker-compose up -d
```

---

## Ejemplo de Uso

### 1. Crear un empleado con contraseña

```bash
curl -X POST http://localhost:8081/api/v1/employees \
  -H "Content-Type: application/json" \
  -d '{
    "names": "Juan",
    "lastnames": "Pérez",
    "identification_type": "CC",
    "identification_number": "1234567890",
    "password": "micontraseña",
    "rol_id": 1
  }'
```

### 2. Realizar login

```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "identification_type": "CC",
    "identification_number": "1234567890",
    "password": "micontraseña"
  }'
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6Ikp1YW4gUMOpcmV6Iiwicm9sIjoiQURNSU4iLCJwZXJtaXNvcyI6WyJjcmVhdGUiLCJlZGl0YXIiLCJlbGltaW5hciJdLCJpYXQiOjE2OTk2MzEyMzAsImV4cCI6MTY5OTYzNDgzMH0.xxxxx",
  "username": "Juan Pérez",
  "userId": 1,
  "rol": "ADMIN"
}
```

### 3. Usar el token para consultas futuras

```bash
curl -X GET http://localhost:8081/api/v1/employees \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6Ikp1YW4gUMOpcmV6Iiwicm9sIjoiQURNSU4iLCJwZXJtaXNvcyI6WyJjcmVhdGUiLCJlZGl0YXIiLCJlbGltaW5hciJdLCJpYXQiOjE2OTk2MzEyMzAsImV4cCI6MTY5OTYzNDgzMH0.xxxxx"
```

---

## Variables de Entorno

Para configurar en producción:

```bash
# JWT Secret (debe ser una cadena fuerte y segura)
export JWT_SECRET="your-super-secret-key-min-32-chars-for-hs256"

# Expiración del token en milisegundos (default: 3600000 = 1 hora)
export JWT_EXPIRATION=3600000

# Base de datos PostgreSQL
export DATABASE_URL=jdbc:postgresql://localhost:5432/nexosalud
export DATABASE_USER=postgres
export DATABASE_PASSWORD=postgres
```

---

## Estructura de JWT Claims

El JWT contiene los siguientes claims:

```json
{
  "user_id": 1,
  "username": "Juan Pérez",
  "rol": "ADMIN",
  "permisos": ["crear", "editar", "eliminar"],
  "iat": 1699631230,
  "exp": 1699634830
}
```

### Extracción de Claims

Desde el token, se pueden extraer:
- `user_id`: Identificador del usuario
- `username`: Nombre completo del usuario
- `rol`: Nombre del rol
- `permisos`: Lista de permisos otorgados

---

## Pruebas

Ejecutar tests unitarios:

```bash
# Módulo de gateway
cd backend-module-gateway
mvn test

# Módulo de empleados
cd backend-module-employees
mvn test

# Módulo de usuarios
cd backend-module-users
mvn test
```

---

## Seguridad

### Buenas Prácticas Implementadas

1. **Hash de Contraseñas**: Se usan BCrypt para almacenar contraseñas
2. **JWT Firmado**: Los tokens se firman con HS256 y una clave secreta
3. **Expiración de Tokens**: Los tokens expiran después del tiempo configurado
4. **Validación de Credenciales**: Se valida que la contraseña coincida antes de generar el token

### Recomendaciones Adicionales (No Implementadas)

1. **HTTPS**: En producción, siempre usar HTTPS
2. **Refresh Tokens**: Implementar tokens de refresco para mayor seguridad
3. **Rate Limiting**: Limitar intentos de login fallidos
4. **Auditoría**: Registrar intentos de login fallidos
5. **CORS**: Configurar CORS según necesidad

---

## Próximas Mejoras

1. Agregar `JwtAuthenticationFilter` para validar tokens automáticamente en otros endpoints
2. Implementar refresh tokens
3. Agregar soporte para OAuth2 (Google, GitHub, etc.)
4. Implementar rol-based access control (RBAC) en los controllers
5. Agregar endpoint de validación de token (`POST /api/v1/auth/validate`)

---

## Estructura de Directorios

```
backend-module-gateway/
├── src/main/java/com/reactive/nexo/
│   ├── controller/SessionController.java
│   ├── service/SessionService.java
│   ├── client/EmployeeClient.java
│   ├── util/JwtUtil.java
│   ├── dto/
│   │   ├── LoginRequest.java
│   │   ├── LoginResponse.java
│   │   └── AuthResponse.java
│   └── model/Session.java

backend-module-employees/
├── src/main/java/com/reactive/nexo/
│   ├── controller/EmployeeController.java
│   ├── service/EmployeeService.java
│   ├── dto/
│   │   ├── AuthRequest.java
│   │   └── AuthResponse.java
│   └── ...
```

---

## Soporte

Para reportar bugs o sugerencias, crear un issue en el repositorio.
