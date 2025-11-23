#!/usr/bin/env bash
# start_services.sh — Inicia los módulos employees, users y gateway en background
# Uso:
#   source ./env.sh
#   ./start_services.sh

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ -f ./env.sh ]; then
  # shellcheck disable=SC1091
  source ./env.sh
else
  echo "env.sh no encontrado. Crea o copia env.sh en la raíz del proyecto."
  exit 1
fi

PIDS_FILE="$SCRIPT_DIR/.service_pids"
: > "$PIDS_FILE"

# helper: wait for TCP port to be open
wait_for_port() {
  local host=$1
  local port=$2
  local retries=60
  local wait=1
  echo -n "Waiting for $host:$port"
  for i in $(seq 1 "$retries"); do
    # bash /dev/tcp check
    if (echo > /dev/tcp/"${host#http://}"/"$port") >/dev/null 2>&1; then
      echo " - open"
      return 0
    fi
    echo -n "."
    sleep "$wait"
  done
  echo ""
  echo "Timed out waiting for $host:$port"
  return 1
}

start_module() {
  local module_dir=$1
  local port=$2
  local name=$3
  local log_file="$LOG_DIR/${name}.log"

  echo "Starting $name (dir=$module_dir) on port=$port -> log: $log_file"
  (cd "$module_dir" && $MAVEN_CMD -Dspring-boot.run.arguments="--spring.profiles.active=dev --server.port=$port" spring-boot:run) >"$log_file" 2>&1 &
  local pid=$!
  echo "$name:$pid:$port" >> "$PIDS_FILE"
  echo "$name started with PID $pid"
}

# start employees
start_module "$SCRIPT_DIR/backend-module-employees" "$EMPLOYEES_PORT" "employees"
# start users
start_module "$SCRIPT_DIR/backend-module-users" "$USERS_PORT" "users"
# start gateway (depends on employees/users)
start_module "$SCRIPT_DIR/backend-module-gateway" "$GATEWAY_PORT" "gateway"

# Wait for ports
wait_for_port "localhost" "$EMPLOYEES_PORT" || echo "Warning: employees did not start cleanly"
wait_for_port "localhost" "$USERS_PORT" || echo "Warning: users did not start cleanly"
wait_for_port "localhost" "$GATEWAY_PORT" || echo "Warning: gateway did not start cleanly"

echo "Services started. PIDs recorded in $PIDS_FILE"

echo "Para detener: ./stop_services.sh"
chmod +x ./stop_services.sh || true
tail -fn0 $LOG_DIR/*
