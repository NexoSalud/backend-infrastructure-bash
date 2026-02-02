# Despliegue con Portainer (Git Stack)

Este stack permite a Portainer clonar automáticamente el monorepo y construir cada servicio desde su subdirectorio usando contextos Git.

## Prerrequisitos
- Tener el repositorio accesible por HTTP(S). Define `MONOREPO_URL` y `REPO_REF` en `.env`.
- Docker y Portainer (Server + Agent) funcionando.

## Variables requeridas
Configura en `.env` (ya creado):
- `MONOREPO_CONTEXT`: `https://.../backend-infrastructure-bash.git#main` (o rama/tag/commit deseado)
- Puertos (`EMPLOYEES_PORT`, `USERS_PORT`, `SCHEDULE_PORT`, `GATEWAY_PORT`).
- Base de datos (`POSTGRES_*`).

## Pasos en Portainer
1. Ir a **Stacks** → **Add stack** → **Git repository**.
2. En **Repository URL**, coloca la URL del repositorio que contiene `docker-compose.portainer.yml`.
3. En **Compose path**, usa `docker-compose.portainer.yml`.
4. En **Environment variables**, pega el contenido de `.env` ajustando `MONOREPO_CONTEXT` (usa `https://` y `#main` o la rama/tag/commit).
5. Opcional: Habilita **Auto update** si quieres que Portainer re-build cuando cambie el repo.
6. Click **Deploy the stack**.

## Servicios desplegados
- `postgres` (persistencia en `pgdata` volume)
- `users-service` (Spring Boot)
- `employees-service` (Spring Boot)
- `schedule-service` (Spring Boot)
- `gateway-service` (Spring Boot, expone `8080`)

## Notas
- Los contextos Git usan el formato `repo.git#ref:subdir`. Portainer/Compose descargan el repo y construyen sólo ese subdirectorio.
- Si tu Portainer no soporta build con contextos Git, alternativa: usar imágenes precompiladas de un registry.
 - Este stack usa el monorepo como contexto y `dockerfile` por subcarpeta (p. ej. `backend-module-users/Dockerfile`), evitando el uso de `:subdir` en el `context` que no siempre está soportado.
