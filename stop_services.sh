#!/usr/bin/env bash
# stop_services.sh — Detiene los servicios iniciados por start_services.sh
# Uso:
#   ./stop_services.sh

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PIDS_FILE="$SCRIPT_DIR/.service_pids"

if [ ! -f "$PIDS_FILE" ]; then
  echo "No se encontró $PIDS_FILE — no hay servicios registrados."
  exit 0
fi

while IFS=":" read -r name pid port; do
  if [ -z "$pid" ]; then
    continue
  fi
  if kill -0 "$pid" >/dev/null 2>&1; then
    echo "Stopping $name (PID $pid)"
    kill "$pid" || true
    sleep 1
    if kill -0 "$pid" >/dev/null 2>&1; then
      echo "PID $pid did not stop; sending SIGKILL"
      kill -9 "$pid" || true
    fi
  else
    echo "$name (PID $pid) is not running"
  fi
done < "$PIDS_FILE"

rm -f "$PIDS_FILE"

echo "All services stopped. Check logs in ./logs"
