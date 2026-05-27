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

## Primer despliegue

### 1. Limpiar cache Docker en el servidor (SSH)

```bash
# Conectarse al servidor cloud por SSH, luego:
docker builder prune -af
docker image prune -af
```

### 2. Generar GitHub Personal Access Token

1. `github.com/settings/tokens` → **Generate new token (classic)**
2. Nombre: `portainer-nexosalud`
3. Scopes: marcar **`repo`**
4. Copiar el token (`ghp_...`)

### 3. Desplegar en Portainer

1. **Stacks → Add Stack → Repository**
2. URL: `git@github.com:NexoSalud/backend-infrastructure-bash.git`
3. Branch: `develop`
4. Compose path: `docker-compose.portainer.yml`
5. En **Environment variables** pegar el contenido de `.env.portainer.example`
6. **Deploy the stack**

---

## Redesplegar (actualizar código)

Cada vez que haya cambios en los repos de los módulos:

### 1. Limpiar imágenes anteriores en el servidor (SSH)

```bash
docker rmi $(docker images "nexosalud/*" -q) --force 2>/dev/null || true
docker builder prune -af
```

### 2. Cambiar DEPLOY_VERSION en Portainer

En el stack → **Editor** → cambiar `DEPLOY_VERSION` a un nuevo valor (ej: `20260528-1`) → **Update the stack**.

Esto garantiza que Docker construya imágenes con un tag nuevo, sin reutilizar cache.

---

## Variables de entorno

| Variable | Descripción | Obligatorio |
|---|---|---|
| `DEPLOY_VERSION` | Tag único por deploy (ej: `20260527-1`) | ✅ cambiar en cada redeploy |
| `GH_TOKEN` | GitHub PAT con scope `repo` | ✅ |
| `POSTGRES_PASSWORD` | Contraseña de la BD | ✅ |
| `JWT_SECRET` | Clave JWT (mín. 32 chars) | ✅ |
| `EMAIL_*` | Credenciales SMTP | ✅ |
| `AUTH_MOCK_MODE` | `false` en producción | ✅ |
| `GATEWAY_HOST_PORT` | Puerto expuesto (default 8080) | opcional |

---

## Verificar

```
nexosalud-postgres      ✅ healthy
nexosalud-users         ✅ running
nexosalud-employees     ✅ running
nexosalud-schedule      ✅ running
nexosalud-appointments  ✅ running
nexosalud-history       ✅ running
nexosalud-convenios     ✅ running
nexosalud-billing       ✅ running
nexosalud-gateway       ✅ running  → :8080
```

```bash
curl http://TU_SERVIDOR:8080/api/v1/employees/health
```

> El primer build tarda ~15 min (Maven descarga dependencias y compila).
> Los siguientes builds son más rápidos gracias al cache de dependencias Maven.
