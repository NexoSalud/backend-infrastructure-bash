Coolify deployment hints for backend modules.

Place these YAML files in the project root under `coolify/` and import them into Coolify as build-from-source apps. Each file includes:
- `build.context`: path to the module
- `dockerfile`: Dockerfile to use
- `ports`: exposed service port
- `env.SERVICE_PORT`: environment variable used by the Dockerfile healthcheck
- `healthcheck`: relative path to check

Example: import `coolify/appointments.yml` and set repository root as project root.
