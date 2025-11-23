# ⚡ Quick Start — Orquestador de Servicios

## Instalación 1️⃣ (Una sola vez)

```bash
cd /home/jhordy/nexo

# Ya está listo, solo hay que usar los scripts
ls -l *.sh env.sh
```

## Inicio Rápido 2️⃣

### Terminal 1: Cargar env + iniciar servicios

```bash
source ./env.sh
./start_services.sh
```

Esto arranca: **employees** (8081), **users** (8080), **gateway** (8082)

### Terminal 2: Verificar estado

```bash
./status_services.sh
```

Ejemplo de output:

```
SERVICE      PID      RUNNING  PORT     HTTP/STATUS
---------------------------------------------------------------
employees    12345    yes      yes      200
users        12346    yes      yes      200
gateway      12347    yes      yes      200
```

### Terminal 3: Testear login

```bash
curl -X POST http://localhost:8082/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"identification_type":"CC","identification_number":"12345","password":"pass"}'
```

**Response:**

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLC...",
  "username": "12345 Test User",
  "userId": 1,
  "rol": "ADMIN"
}
```

✅ **¡Token generado exitosamente!**

## Parar Servicios 🛑

```bash
./stop_services.sh
```

---

## Detalles Clave

| Componente | Puerto | URL | Status |
|---|---|---|---|
| **Employees** (BD: empleados, roles, permisos) | 8081 | `http://localhost:8081` | ✅ |
| **Users** (BD: usuarios) | 8080 | `http://localhost:8080` | ✅ |
| **Session** (JWT, autenticación) | 8082 | `http://localhost:8082` | ✅ |

## Modos de Autenticación

### Mock Mode (Default) — `AUTH_MOCK_MODE=true`

**Genera tokens sin validar contra BD** ← Ideal para desarrollo

```bash
source ./env.sh  # AUTH_MOCK_MODE=true por defecto
./start_services.sh
```

Cualquier login devuelve token:

```bash
curl -X POST http://localhost:8082/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"identification_type":"XX","identification_number":"9999","password":"xyz"}'
# → devuelve token ✅
```

### Real Mode — `AUTH_MOCK_MODE=false`

**Valida credenciales contra BD (employees)**

```bash
export AUTH_MOCK_MODE=false
source ./env.sh
./start_services.sh
```

Solo login si el empleado existe en BD con password correcto.

---

## Variables de Entorno

En `env.sh`:

```bash
EMPLOYEES_PORT=8081        # Puerto employees
USERS_PORT=8080            # Puerto users
GATEWAY_PORT=8082          # Puerto gateway
JWT_SECRET="..."           # Secret para firmar JWT
JWT_EXPIRATION=3600000     # Expiration en ms (1h)
AUTH_MOCK_MODE=true        # Mock o real auth
```

Cambiar antes de `source ./env.sh`:

```bash
export AUTH_MOCK_MODE=false
export JWT_SECRET="mi-clave-super-segura"
source ./env.sh
./start_services.sh
```

---

## Logs

```bash
tail -f logs/gateway.log       # Ver logs en vivo
tail -f logs/employees.log
tail -f logs/users.log

grep ERROR logs/*.log          # Buscar errores
```

---

## Tests Automatizados

```bash
./test_auth.sh
```

Ejecuta 4 tests:
1. ✅ Login devuelve token
2. ✅ Logout responde 200
3. ✅ Token extraído
4. ✅ Token puede usarse en headers

---

## Endpoints Principales

### Sesión (8082)

```
POST /api/v1/auth/login
  → {"token", "username", "userId", "rol"}

POST /api/v1/auth/logout
  → 200 OK
```

### Empleados (8081)

```
GET /api/v1/employees
  → [...]

POST /api/v1/employees/authenticate  (Interno)
  → {"id", "names", "rol_nombre", "permisos"}
```

### Usuarios (8080)

```
GET /api/v1/users
  → {PagedResponse}

GET /api/v1/users/{id}
  → {User}
```

---

## Troubleshooting

### Puerto ocupado

```
Port 8082 was already in use
```

**Solución:**

```bash
pkill -9 -f java
sleep 2
./start_services.sh
```

### Servicios no aparecen en status

```
No hay servicios registrados
```

**Solución:** Iniciar con los scripts:

```bash
source ./env.sh
./start_services.sh
./status_services.sh  # Ahora sí muestra
```

### Login no devuelve token (solo en Real Mode)

Verificar que el empleado existe:

```bash
curl -X GET http://localhost:8081/api/v1/employees
```

Si está vacío, el login fallará. En **Mock Mode**, no hay problema.

---

## Archivos

```
/home/jhordy/nexo/
├── env.sh                      # Variables (editar aquí)
├── start_services.sh           # Inicia servicios
├── stop_services.sh            # Para servicios
├── status_services.sh          # Monitorea
├── test_auth.sh                # Tests
├── .service_pids               # PIDs (generado)
├── logs/                       # Logs (generado)
├── ORCHESTRATOR_README.md      # Guía completa
└── JWT_IMPLEMENTATION.md       # Info JWT
```

---

## Comandos Rápidos

```bash
# Sesión completa
source ./env.sh && \
./start_services.sh && \
sleep 3 && \
./status_services.sh && \
./test_auth.sh

# Verificar que funciona
curl http://localhost:8080/api/v1/auth/login \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"identification_type":"CC","identification_number":"1","password":"x"}'

# Parar
./stop_services.sh
```

---

**✅ Listo para usar. Cualquier duda, revisar `ORCHESTRATOR_README.md`**
