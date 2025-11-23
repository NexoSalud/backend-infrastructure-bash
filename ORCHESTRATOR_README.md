# Orquestador de Servicios con JWT

Este directorio contiene scripts de shell para orquestar el inicio, parada y monitoreo de los tres módulos del sistema Nexo Salud con autenticación JWT.

## Archivos

- **`env.sh`** — Variables de entorno centralizadas
- **`start_services.sh`** — Script para iniciar todos los servicios en background
- **`stop_services.sh`** — Script para detener los servicios
- **`status_services.sh`** — Script para monitorear el estado de los servicios

## Configuración Rápida

### 1. Cargar Variables de Entorno

```bash
source ./env.sh
```

Esto exporta todas las variables necesarias incluyendo:
- Puertos: `EMPLOYEES_PORT` (8081), `USERS_PORT` (8082), `GATEWAY_PORT` (8080)
- URLs: `EMPLOYEES_URL`, `USERS_URL`, `GATEWAY_URL`
- JWT: `JWT_SECRET`, `JWT_EXPIRATION`
- **`AUTH_MOCK_MODE`** (true/false) — Ver sección "Modos de Autenticación"

### 2. Iniciar Servicios

```bash
./start_services.sh
```

Esto:
- Inicia los tres módulos en background con Maven
- Guarda PIDs en `.service_pids`
- Espera a que los puertos estén disponibles
- Registra logs en `logs/<module>.log`

### 3. Verificar Estado

```bash
./status_services.sh
```

Muestra tabla con:
- SERVICE: nombre del módulo
- PID: identificador del proceso
- RUNNING: si el proceso está vivo
- PORT: si el puerto responde TCP
- HTTP/STATUS: código HTTP de respuesta

Ejemplo de salida:

```
SERVICE      PID      RUNNING  PORT     HTTP/STATUS
---------------------------------------------------------------
employees    12345    yes      yes      200
users        12346    yes      yes      200
gateway      12347    yes      yes      200

Resumen:
- employees -> http://localhost:8081
- users -> http://localhost:8082
- gateway -> http://localhost:8080
```

### 4. Detener Servicios

```bash
./stop_services.sh
```

Lee `.service_pids` y mata los procesos. Elimina el archivo de PIDs.

---

## Modos de Autenticación

### Mock Mode (Desarrollo/Testing) — `AUTH_MOCK_MODE=true`

En este modo, el módulo de sesión genera tokens JWT sin validar contra la BD.

**Ventaja:** No requiere que el módulo `employees` esté ejecutándose o que exista BD.

**Uso:**

```bash
export AUTH_MOCK_MODE=true
source ./env.sh
./start_services.sh
```

Luego, hacer login con **cualquier** identification:

```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "identification_type": "CC",
    "identification_number": "12345",
    "password": "cualquier_cosa"
  }'
```

**Response:**

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJwZXJtaXNvcyI6WyJyZWFkIiwid3JpdGUiLCJkZWxldGUiXSwicm9sIjoiQURNSU4iLCJ1c2VybmFtZSI6IjEyMzQ1IFRlc3QgVXNlciIsImlhdCI6MTcwODk3MjMwMCwiZXhwIjoxNzA4OTc1OTAwfQ.xxx",
  "username": "12345 Test User",
  "userId": 1,
  "rol": "ADMIN"
}
```

**Token Claims (decodificado):**

```json
{
  "user_id": 1,
  "username": "12345 Test User",
  "rol": "ADMIN",
  "permisos": ["read", "write", "delete"],
  "iat": 1708972300,
  "exp": 1708975900
}
```

### Real Mode (Producción) — `AUTH_MOCK_MODE=false`

En este modo, el módulo de sesión valida credenciales contra el módulo `employees`.

**Requisitos:**
- El módulo `employees` debe estar ejecutándose
- Debe existir un empleado en la BD con identification_type + identification_number
- Debe tener una contraseña hash BCrypt

**Uso:**

```bash
export AUTH_MOCK_MODE=false
source ./env.sh
./start_services.sh
```

Luego, si el empleado no existe, el login fallará:

```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "identification_type": "CC",
    "identification_number": "99999",
    "password": "wrong"
  }'
```

**Response:**

```json
null
```

(HTTP 401 Unauthorized)

---

## Variables de Entorno Configurables

Editar `env.sh` o exportar antes de correr los scripts:

```bash
# Cambiar puertos
export EMPLOYEES_PORT=9081
export USERS_PORT=9082
export GATEWAY_PORT=9080

# Cambiar JWT secret (uso en producción)
export JWT_SECRET="mi-clave-super-segura-de-32-caracteres-minimo"
export JWT_EXPIRATION=7200000  # 2 horas en ms

# Cambiar modo de autenticación
export AUTH_MOCK_MODE=false  # Validar contra BD

# Usar otra instancia de Maven
export MAVEN_CMD="/usr/local/bin/mvn"

# Cambiar directorio de logs
export LOG_DIR="/var/log/nexo"

source ./env.sh
./start_services.sh
```

---

## Ejemplos de Uso Rápido

### Entorno de Desarrollo (Mock)

```bash
# Terminal 1
source ./env.sh
./start_services.sh

# Terminal 2
./status_services.sh  # Monitorear

# Terminal 3
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"identification_type":"CC","identification_number":"1234","password":"test"}'
```

### Producción (Real Auth)

```bash
export AUTH_MOCK_MODE=false
export JWT_SECRET="your-super-secure-key-here"
source ./env.sh
./start_services.sh

# Ahora los logins se validan contra BD
```

### Parar Servicios

```bash
./stop_services.sh
```

---

## Logs

Todos los logs de los módulos se guardan en `logs/<module>.log`:

```bash
# Ver logs en tiempo real
tail -f logs/gateway.log
tail -f logs/employees.log
tail -f logs/users.log

# Buscar errores
grep ERROR logs/*.log
```

---

## Troubleshooting

### Puerto ya en uso

```
Port 8082 was already in use
```

**Solución:**

```bash
pkill -9 -f "java" || true
./start_services.sh
```

O cambiar puerto en `env.sh`:

```bash
export GATEWAY_PORT=8090
source ./env.sh
./start_services.sh
```

### Servicios no inician

Revisar logs:

```bash
tail -100 logs/gateway.log
```

Común: falta Maven o variable no configurada.

### `status_services.sh` dice "No hay servicios registrados"

Significa que `.service_pids` no existe. Posibles causas:
- Los servicios no fueron iniciados con `start_services.sh`
- Fueron iniciados pero en otra terminal/contexto

Solución: iniciar con los scripts:

```bash
source ./env.sh
./start_services.sh
```

### curl devuelve 404

Verificar que el endpoint es correcto. Con `base-path: /api/v1` configurado en Spring, la ruta es:

```bash
POST http://localhost:8080/api/v1/auth/login
POST http://localhost:8081/api/v1/employees
POST http://localhost:8082/api/v1/users
```

No:

```bash
POST http://localhost:8080/api/v1/api/v1/auth/login  # ❌ Incorrecto (doble base-path)
```

---

## API Endpoints

### Sesión (Session) — Puerto 8080

```
POST /api/v1/auth/login
  Request: {"identification_type", "identification_number", "password"}
  Response: {"token", "username", "userId", "rol"}

POST /api/v1/auth/logout
  Request: (vacío)
  Response: 200 OK
```

### Empleados (Employees) — Puerto 8081

```
GET /api/v1/employees
  Response: [Employee, ...]

POST /api/v1/employees/authenticate
  Request: {"identification_type", "identification_number", "password"}
  Response: {"id", "names", "lastnames", "rol_id", "rol_nombre", "permisos"}
  (Interno, usado por Session)
```

### Usuarios (Users) — Puerto 8080

```
GET /api/v1/users
  Response: {PagedResponse con usuarios}

GET /api/v1/users/{userId}
  Response: {User}
```

---

## Arquitectura

```
┌─────────────────────────────────────────────────┐
│           Cliente HTTP (curl, browser)           │
└────────────────────┬────────────────────────────┘
                     │
                     ▼
         ┌────────────────────────┐
         │   Gateway (8080)       │
         │  /api/v1/auth/login    │
         │    JwtUtil, env vars   │
         └────────────┬───────────┘
                      │ (si AUTH_MOCK_MODE=false)
                      ▼
         ┌────────────────────────┐
         │  Employees (8081)      │
         │ /api/v1/employees/auth │
         │  RolService, BCrypt    │
         └────────────────────────┘
```

---

## Notas

- **Stateless JWT:** Los tokens son autónomos; no se almacenan en servidor.
- **Mock Mode by Default:** `AUTH_MOCK_MODE=true` facilita development sin BD.
- **Configuración Centralizada:** `env.sh` es el único archivo a editar para cambios globales.
- **Logs en Background:** Los servicios se ejecutan sin bloquear la terminal.
- **PIDs Almacenados:** Permite control granular de qué procesos iniciar/parar.

---

## Licencia

Parte del proyecto NexoSalud.
