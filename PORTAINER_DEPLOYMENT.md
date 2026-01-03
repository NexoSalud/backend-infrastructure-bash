# Despliegue con Portainer (Git Stack)

Este stack permite a Portainer clonar automáticamente el monorepo y construir cada servicio desde su subdirectorio usando contextos Git.

## Prerrequisitos
- Tener el repositorio accesible por HTTP(S). Define `MONOREPO_URL` y `REPO_REF` en `.env`.
- Docker y Portainer (Server + Agent) funcionando.

## Variables requeridas
Configura en `.env` (ya creado):
- `MONOREPO_URL`: URL del monorepo (ej. `https://github.com/tu-org/nexo.git`).
- `REPO_REF`: rama/etiqueta/commit (ej. `main`).
- Puertos (`EMPLOYEES_PORT`, `USERS_PORT`, `SCHEDULE_PORT`, `GATEWAY_PORT`, `FRONTEND_PORT`).
- Base de datos (`POSTGRES_*`).
- `NEXT_PUBLIC_API_HOST`: URL pública del Gateway (ej. `http://TU_HOST:8080`).

## Pasos en Portainer
1. Ir a **Stacks** → **Add stack** → **Git repository**.
2. En **Repository URL**, colocar `MONOREPO_URL` (este stack puede estar en el mismo repo o en otro; si es otro, usa la URL del repo que contiene este `docker-compose.portainer.yml`).
3. En **Compose path**, usar `docker-compose.portainer.yml`.
4. En **Environment variables**, pega el contenido de `.env` (o carga archivo) ajustando `MONOREPO_URL` y `REPO_REF`.
5. Opcional: Habilita **Auto update** si quieres que Portainer re-build cuando cambie el repo.
6. Click **Deploy the stack**.

## Servicios desplegados
- `postgres` (persistencia en `pgdata` volume)
- `users-service` (Spring Boot)
- `employees-service` (Spring Boot)
- `schedule-service` (Spring Boot)
- `gateway-service` (Spring Boot, expone `8080`)
- `frontend` (Next.js, expone `FRONTEND_PORT`)

## Notas
- Los contextos Git usan el formato `repo.git#ref:subdir`. Portainer/Compose descargan el repo y construyen sólo ese subdirectorio.
- `NEXT_PUBLIC_API_HOST` se inyecta en el build del frontend y también en runtime para asegurar que el cliente apunte correctamente al Gateway.
- Si tu Portainer no soporta build con contextos Git, alternativa: usar imágenes precompiladas de un registry.
