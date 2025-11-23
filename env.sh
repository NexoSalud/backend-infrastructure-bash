# Variables de entorno para orquestar servicios
# Fuente: source ./env.sh

# Puertos
export EMPLOYEES_PORT=${EMPLOYEES_PORT:-8081}
export USERS_PORT=${USERS_PORT:-8082}
export GATEWAY_PORT=${GATEWAY_PORT:-8080}

# URLs
export EMPLOYEES_URL=${EMPLOYEES_URL:-http://localhost:${EMPLOYEES_PORT}}
export USERS_URL=${USERS_URL:-http://localhost:${USERS_PORT}}
export GATEWAY_URL=${GATEWAY_URL:-http://localhost:${GATEWAY_PORT}}

# JWT
export JWT_SECRET=${JWT_SECRET:-mySecretKeyForJWTTokenGenerationAndValidation1234567890}
export JWT_EXPIRATION=${JWT_EXPIRATION:-3600000}

# Authentication Mode
export AUTH_MOCK_MODE=${AUTH_MOCK_MODE:-true}  # true = mock authentication (no BD needed), false = validate against employees module

# Maven command
export MAVEN_CMD=${MAVEN_CMD:-mvn}

# Logs directory
export LOG_DIR=${LOG_DIR:-./logs}
mkdir -p "$LOG_DIR"
