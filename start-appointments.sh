#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$SCRIPT_DIR/backend-module-appointments"
PORT="${APPOINTMENTS_PORT:-8084}"

echo "🗓️  Iniciando Appointments Service (puerto ${PORT})..."

if ! command -v mvn >/dev/null 2>&1; then
  echo "❌ Maven no está instalado o no está en el PATH"
  exit 1
fi

# Sugerir base de datos si no está corriendo
DB_PORT=5432
if ! (echo > /dev/tcp/127.0.0.1/${DB_PORT}) >/dev/null 2>&1; then
  echo "⚠️  PostgreSQL en localhost:${DB_PORT} no responde."
  echo "   Ejecuta ./start-db.sh en otra terminal si aún no lo hiciste."
fi

pushd "$APP_DIR" >/dev/null

# Intento 1: spring-boot:run
if mvn -q -U -DskipTests spring-boot:run -Dspring-boot.run.arguments="--server.port=${PORT}"; then
  popd >/dev/null
  exit 0
fi

# Fallback: construir JAR y ejecutar
echo "⚠️  spring-boot:run falló; intentando fallback con JAR empaquetado..."
mvn -q -U -DskipTests clean package
if [ ! -f target/reactive-nexo-0.0.1-SNAPSHOT.jar ]; then
  echo "❌ No se encontró el JAR esperado en target/. Abortando."
  popd >/dev/null
  exit 1
fi

echo "🚀 Ejecutando JAR en puerto ${PORT}..."
java -jar target/reactive-nexo-0.0.1-SNAPSHOT.jar --server.port="${PORT}"

popd >/dev/null
