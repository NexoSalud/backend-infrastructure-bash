# Despliegue NexoSalud en Portainer

## Arquitectura de repositorios

El proyecto usa un repo orquestador + repos independientes por módulo:

| Repositorio | Contenido |
|---|---|
| `NexoSalud/backend-infrastructure-bash` | Scripts, docker-compose, configuración |
| `NexoSalud/backend-module-users` | Servicio de pacientes/usuarios |
| `NexoSalud/backend-module-employees` | Servicio de personal y autenticación |
| `NexoSalud/backend-module-schedule` | Servicio de agendas médicas |
| `NexoSalud/backend-module-appointments` | Servicio de citas |
| `NexoSalud/backend-history-template` | Servicio de historias clínicas |
| `NexoSalud/backend-module-convenios` | Servicio de convenios EPS |
| `NexoSalud/backend-module-billing` | Servicio de recaudo/facturación |
| `NexoSalud/backend-module-gateway` | Gateway (único puerto expuesto) |

Todos los módulos usan la rama **`develop`**.

---

## Servicios y puertos

| Servicio             | Puerto interno | Descripción                        |
|----------------------|----------------|------------------------------------|
| postgres             | 5432           | Base de datos PostgreSQL 15        |
| users-service        | 8081           | Pacientes / usuarios               |
| employees-service    | 8082           | Personal, roles, autenticación     |
| schedule-service     | 8083           | Agendas médicas                    |
| appointments-service | 8084           | Citas médicas                      |
| history-service      | 8085           | Historias clínicas / form-builder  |
| convenios-service    | 8086           | Convenios EPS                      |
| billing-service      | 8087           | Recaudo / facturación              |
| gateway-service      | **8080**       | Único puerto expuesto al exterior  |

---

## Requisito previo: SSH key en Portainer

Todos los repos son privados bajo la organización `NexoSalud`. Docker BuildKit
necesita acceso SSH para clonarlos durante el build.

### 1. Generar una deploy key (si no existe)

En el servidor donde corre Portainer:

```bash
ssh-keygen -t ed25519 -C "portainer-nexosalud" -f ~/.ssh/nexosalud_deploy -N ""
cat ~/.ssh/nexosalud_deploy.pub
```

### 2. Agregar la key a GitHub

Ir a `github.com/organizations/NexoSalud/settings/keys` y agregar la clave
pública como **Organization Deploy Key** con permiso de lectura.

### 3. Configurar la key en Portainer

`Settings → Credentials → Add credential`
- Name: `nexosalud-ssh`
- Type: SSH
- Pegar el contenido de `~/.ssh/nexosalud_deploy` (clave privada)

---

## Despliegue del stack

### Opción A — Desde repositorio Git (recomendado)

1. **Stacks → Add Stack → Repository**
2. Completar:
   - URL: `git@github.com:NexoSalud/backend-infrastructure-bash.git`
   - Branch: `develop`
   - Compose path: `docker-compose.portainer.yml`
   - Authentication: seleccionar `nexosalud-ssh`
3. En **Environment variables** pegar el contenido de `.env.portainer.example`
4. **Deploy the stack**

### Opción B — Upload manual

1. **Stacks → Add Stack → Upload**
2. Subir `docker-compose.portainer.yml`
3. Pegar variables de entorno
4. **Deploy the stack**

> En este caso el daemon de Docker del servidor necesita tener la SSH key
> configurada en `~/.ssh/config` para poder clonar los repos durante el build.

---

## Variables de entorno requeridas

Copiar `.env.portainer.example` y ajustar:

| Variable | Descripción | Cambiar en prod |
|---|---|---|
| `POSTGRES_PASSWORD` | Contraseña de la BD | ✅ |
| `JWT_SECRET` | Clave JWT (mín. 32 chars) | ✅ |
| `EMAIL_*` | Credenciales SMTP | ✅ |
| `AUTH_MOCK_MODE` | `false` en producción | ✅ |
| `GATEWAY_HOST_PORT` | Puerto expuesto (default 8080) | opcional |
| `POSTGRES_HOST_PORT` | Puerto BD expuesto (default 5432) | opcional |

---

## Verificar el despliegue

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

> El primer build tarda ~15 min porque Maven descarga dependencias y compila
> cada servicio. Las siguientes veces usa el cache de capas de Docker.
