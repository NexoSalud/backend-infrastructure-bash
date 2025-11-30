#!/usr/bin/env bash
# status_services.sh — Muestra el estado de servicios iniciados por start_services.sh
# Uso:
#   source ./env.sh
#   ./status_services.sh

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ -f ./env.sh ]; then
  # shellcheck disable=SC1091
  source ./env.sh
else
  echo "env.sh no encontrado. Ejecuta: source ./env.sh" >&2
  exit 1
fi

PIDS_FILE="$SCRIPT_DIR/.service_pids"
if [ ! -f "$PIDS_FILE" ]; then
  echo "No hay servicios registrados (no existe $PIDS_FILE)." >&2
  exit 0
fi

# Map service name to URL variable
get_url_for_name() {
  local name="$1"
  case "$name" in
    employees) echo "$EMPLOYEES_URL" ;;
    users) echo "$USERS_URL" ;;
    schedule) echo "$SCHEDULE_URL" ;;
    gateway) echo "$GATEWAY_URL" ;;
    *) echo "http://localhost" ;;
  esac
}

printf "%-12s %-8s %-8s %-8s %s\n" "SERVICE" "PID" "RUNNING" "PORT" "HTTP/STATUS"
printf "%s\n" "---------------------------------------------------------------"

while IFS=":" read -r name pid port; do
  [ -z "$name" ] && continue
  url=$(get_url_for_name "$name")
  running="no"
  port_open="no"
  http_status="-"

  if [ -n "$pid" ] && kill -0 "$pid" >/dev/null 2>&1; then
    running="yes"
  fi

  # Check TCP port
  if (echo > /dev/tcp/localhost/"$port") >/dev/null 2>&1; then
    port_open="yes"
  fi

  # If curl available, try to get a 1s timeout http status
  if command -v curl >/dev/null 2>&1; then
    # prefer /actuator/health if present, else root
    health_url="$url/actuator/health"
    http_status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 2 "$health_url" || true)
    if [ "$http_status" = "000" ] || [ "$http_status" = "000" ]; then
      http_status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 2 "$url" || true)
    fi
    # normalize empty
    [ -z "$http_status" ] && http_status="-"
  else
    http_status="curl-missing"
  fi

  printf "%-12s %-8s %-8s %-8s %s\n" "$name" "$pid" "$running" "$port_open" "$http_status"

done < "$PIDS_FILE"

# Quick summary
echo
echo "Resumen:"
awk -F":" '{print $1}' "$PIDS_FILE" | xargs -n1 | while read -r n; do
  url=$(get_url_for_name "$n")
  echo "- $n -> $url"
done

exit 0
