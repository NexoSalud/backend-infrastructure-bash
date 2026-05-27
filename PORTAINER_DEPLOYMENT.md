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

## Paso 1 — Generar GitHub Personal Access Token

1. Ir a `github.com/settings/tokens` → **Generate new token (classic)**
2. Nombre: `portainer-nexosalud`
3. Scopes: marcar **`repo`** (acceso completo a repos privados)
4. Copiar el token generado (`ghp_...`)

> El token se usa **solo durante el build** para que Docker pueda clonar
> los repos privados vía HTTPS. No queda expuesto en los contenedores.

---

## Paso 2 — Desplegar el stack en Portainer

1. **Stacks → Add Stack**
2. Elegir **Repository** o **Upload** con `docker-compose.portainer.yml`
3. En **Environment variables** agregar todas las variables de `.env.portainer.example`
4. Reemplazar `GH_TOKEN` con el token generado en el paso anterior
5. **Deploy the stack**

---

## Variables de entorno

| Variable | Descripción | Obligatorio |
|---|---|---|
| `GH_TOKEN` | GitHub PAT con scope `repo` | ✅ |
| `POSTGRES_PASSWORD` | Contraseña de la BD | ✅ |
| `JWT_SECRET` | Clave JWT (mín. 32 chars) | ✅ |
| `EMAIL_*` | Credenciales SMTP | ✅ |
| `AUTH_MOCK_MODE` | `false` en producción | ✅ |
| `GATEWAY_HOST_PORT` | Puerto expuesto (default 8080) | opcional |
| `POSTGRES_HOST_PORT` | Puerto BD expuesto (default 5432) | opcional |

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
> Las siguientes veces usa el cache de capas de Docker.
