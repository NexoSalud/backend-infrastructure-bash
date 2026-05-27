# Despliegue NexoSalud en Portainer

## Servicios

| Servicio             | Puerto | Descripción                        |
|----------------------|--------|------------------------------------|
| postgres             | 5432   | Base de datos PostgreSQL 15        |
| users-service        | 8081   | Pacientes / usuarios               |
| employees-service    | 8082   | Personal, roles, autenticación     |
| schedule-service     | 8083   | Agendas médicas                    |
| appointments-service | 8084   | Citas médicas                      |
| history-service      | 8085   | Historias clínicas / form-builder  |
| convenios-service    | 8086   | Convenios EPS                      |
| billing-service      | 8087   | Recaudo / facturación              |
| **gateway-service**  | **8080** | Único puerto expuesto al exterior |

---

## ⚠️ Paso obligatorio antes del primer deploy

Conectarse al servidor cloud por SSH y ejecutar:

```bash
# 1. Crear la red Docker externa (solo una vez)
docker network create nexo-backend-network

# 2. Limpiar cache de builds anteriores
docker builder prune -af
docker image prune -af
```

> Por qué es necesario: Portainer prefija los nombres de red con el nombre
> del stack (ej: `nexosalud_nexo-backend-network`), lo que impide que los contenedores
> se encuentren entre sí por hostname. Al declararla como `external: true`,
> Docker usa la red tal como fue creada, sin prefijos.

---

## Despliegue en Portainer

### 1. Generar GitHub Personal Access Token

1. `github.com/settings/tokens` → **Generate new token (classic)**
2. Scopes: marcar **`repo`**
3. Copiar el token (`ghp_...`)

### 2. Crear el stack

1. **Stacks → Add Stack → Repository**
2. URL: `git@github.com:NexoSalud/backend-infrastructure-bash.git`
3. Branch: `develop`
4. Compose path: `docker-compose.portainer.yml`
5. En **Environment variables** pegar el contenido de `.env.portainer.example`
6. **Deploy the stack**

---

## Redesplegar (actualizar código)

```bash
# En el servidor cloud (SSH):
docker rmi $(docker images "nexosalud/*" -q) --force 2>/dev/null || true
docker builder prune -af
```

Luego en Portainer: cambiar `DEPLOY_VERSION` a un nuevo valor → **Update the stack**.

---

## Variables de entorno

| Variable | Descripción | Obligatorio |
|---|---|---|
| `DEPLOY_VERSION` | Tag único por deploy (ej: `20260527-1`) | ✅ cambiar en cada redeploy |
| `GH_TOKEN` | GitHub PAT con scope `repo` | ✅ |
| `POSTGRES_PASSWORD` | Contraseña de la BD | ✅ |
| `JWT_SECRET` | Clave JWT (mín. 32 chars) | ✅ |
| `AUTH_MOCK_MODE` | `false` en producción | ✅ |
| `EMAIL_*` | Credenciales SMTP | ✅ |
| `GATEWAY_HOST_PORT` | Puerto expuesto (default 8080) | opcional |

---

## Verificar

```bash
# En el servidor cloud:
docker network inspect nexo-backend-network | grep -E "Name|IPv4"
docker ps --format "table {{.Names}}\t{{.Status}}"
curl http://localhost:8080/api/v1/employees/health
```

Todos los contenedores deben aparecer en la red `nexo-backend-network`.
