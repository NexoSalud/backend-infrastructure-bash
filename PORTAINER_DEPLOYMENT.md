# Despliegue NexoSalud en Portainer

## Servicios incluidos

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

## Cómo desplegar en Portainer

### 1. Agregar el stack desde el repositorio Git

1. Ir a **Stacks → Add Stack**
2. Seleccionar **Repository**
3. Completar:
   - **URL:** `git@github.com:NexoSalud/nexo.git` (o la URL HTTPS si el repo es público)
   - **Branch:** `develop`
   - **Compose path:** `docker-compose.portainer.yml`
4. Si el repo es privado, configurar las credenciales SSH/token en **Authentication**

### 2. Configurar las variables de entorno

En la sección **Environment variables** del stack, pegar el contenido de `.env.portainer.example` ajustando:

| Variable | Descripción |
|---|---|
| `POSTGRES_PASSWORD` | Contraseña segura para la BD |
| `JWT_SECRET` | Clave JWT (mín. 32 caracteres) |
| `EMAIL_*` | Credenciales SMTP reales |
| `GATEWAY_HOST_PORT` | Puerto expuesto al exterior (default: 8080) |
| `AUTH_MOCK_MODE` | `false` en producción |

### 3. Desplegar

Click **Deploy the stack**. El primer build tarda ~10-15 min porque Maven descarga dependencias y compila cada servicio. Las siguientes veces usa el cache de capas de Docker.

---

## Por qué rutas locales y no contextos Git remotos

Portainer clona el repositorio raíz completo (que contiene todos los módulos como subcarpetas). Los `build.context` apuntan a rutas relativas dentro de ese clon:

```
nexo/                          ← repo raíz clonado por Portainer
├── docker-compose.portainer.yml
├── backend-module-users/      ← context: ./backend-module-users
├── backend-module-employees/  ← context: ./backend-module-employees
├── backend-module-gateway/    ← context: ./backend-module-gateway
└── ...
```

Esto evita el error `terminal prompts disabled` que ocurre cuando Docker BuildKit intenta clonar repos privados sin credenciales SSH disponibles en el daemon.

---

## Verificar el despliegue

Una vez desplegado, todos los contenedores deben estar en estado `running`:

```
nexosalud-postgres      ✅ healthy
nexosalud-users         ✅ running
nexosalud-employees     ✅ running
nexosalud-schedule      ✅ running
nexosalud-appointments  ✅ running
nexosalud-history       ✅ running
nexosalud-convenios     ✅ running
nexosalud-billing       ✅ running
nexosalud-gateway       ✅ running  → expuesto en :8080
```

Probar el gateway:
```bash
curl http://TU_SERVIDOR:8080/api/v1/employees/health
```

---

## Actualizar un servicio

Para redesplegar un servicio individual después de un push a `develop`:

1. En Portainer ir al stack `nexosalud`
2. Click **Pull and redeploy** (si está configurado con auto-update)
3. O manualmente: seleccionar el servicio → **Recreate**
