#!/usr/bin/env bash
set -euo pipefail

# Postgres Connections Maintenance Script (non-Docker)
# Features:
# - Status: show max_connections, current connections, top applications
# - List: detailed pg_stat_activity view
# - Terminate idle: close idle client backends safely
# - Terminate app: close connections by application_name
# - Increase max: ALTER SYSTEM SET max_connections=<N> and reload
# Supports env vars PGHOST, PGPORT, PGUSER, PGDATABASE, PGPASSWORD or flags.
# Optional --sudo to run psql via 'sudo -u postgres'.

PGHOST_DEFAULT="localhost"
PGPORT_DEFAULT="5432"
PGUSER_DEFAULT="postgres"
PGDATABASE_DEFAULT="nexosalud"
USE_SUDO="false"

HOST="${PGHOST:-$PGHOST_DEFAULT}"
PORT="${PGPORT:-$PGPORT_DEFAULT}"
USER="${PGUSER:-$PGUSER_DEFAULT}"
DB="${PGDATABASE:-$PGDATABASE_DEFAULT}"
PASSWORD="${PGPASSWORD:-}" # optional

ACTION="status"
ARG1=""

usage() {
  cat <<EOF
Usage: $(basename "$0") [options] <action> [arg]

Actions:
  status                      Show max_connections and current usage
  list                        List connections: state, app, pid, user, db, client
  terminate-idle              Terminate idle client connections (excluding current)
  terminate-app <name>        Terminate connections for application_name=<name>
  increase-max <N>            ALTER SYSTEM SET max_connections=<N> and reload

Options:
  --host <host>               Postgres host (default: ${PGHOST_DEFAULT})
  --port <port>               Postgres port (default: ${PGPORT_DEFAULT})
  --user <user>               Postgres user (default: ${PGUSER_DEFAULT})
  --db <database>             Database name (default: ${PGDATABASE_DEFAULT})
  --password <pwd>            Postgres password (optional)
  --sudo                      Run psql as 'sudo -u postgres'
  -h, --help                  Show this help

Env vars supported: PGHOST, PGPORT, PGUSER, PGDATABASE, PGPASSWORD
Examples:
  $(basename "$0") --host 127.0.0.1 --user postgres status
  $(basename "$0") terminate-idle
  $(basename "$0") terminate-app gateway-service
  $(basename "$0") increase-max 200
EOF
}

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

psql_base_args=("-h" "$HOST" "-p" "$PORT" "-U" "$USER" "-d" "$DB" "-v" "ON_ERROR_STOP=1")

run_psql() {
  local sql="$1"
  if [[ -n "$PASSWORD" ]]; then
    export PGPASSWORD="$PASSWORD"
  fi
  if [[ "$USE_SUDO" == "true" ]]; then
    sudo -u postgres psql "${psql_base_args[@]}" -At -c "$sql"
  else
    psql "${psql_base_args[@]}" -At -c "$sql"
  fi
}

require_psql() {
  if [[ "$USE_SUDO" == "true" ]]; then
    command -v sudo >/dev/null 2>&1 || { echo "sudo not found"; exit 1; }
  fi
  command -v psql >/dev/null 2>&1 || { echo "psql not found in PATH"; exit 1; }
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --host) HOST="$2"; shift 2;;
      --port) PORT="$2"; shift 2;;
      --user) USER="$2"; shift 2;;
      --db) DB="$2"; shift 2;;
      --password) PASSWORD="$2"; shift 2;;
      --sudo) USE_SUDO="true"; shift 1;;
      -h|--help) usage; exit 0;;
      status|list|terminate-idle|terminate-app|increase-max)
        ACTION="$1"; shift 1; if [[ $# -gt 0 ]]; then ARG1="$1"; fi; break;;
      *) echo "Unknown arg: $1"; usage; exit 1;;
    esac
  done
}

check_superuser() {
  local is_super
  is_super=$(run_psql "SELECT rolsuper FROM pg_roles WHERE rolname = current_user;")
  if [[ "$is_super" != "t" ]]; then
    echo "Warning: current user is not a superuser; some actions may fail."
  fi
}

action_status() {
  log "Checking Postgres connection limits and usage..."
  local max_conns curr_conns
  max_conns=$(run_psql "SHOW max_connections;")
  curr_conns=$(run_psql "SELECT COUNT(*) FROM pg_stat_activity;")
  echo "max_connections: $max_conns"
  echo "current_connections: $curr_conns"
  echo "Top applications by connections:"
  run_psql "SELECT application_name || '|' || COUNT(*) FROM pg_stat_activity GROUP BY application_name ORDER BY COUNT(*) DESC;" | sed 's/|/\t/g'
}

action_list() {
  log "Listing active connections..."
  run_psql "SELECT state || '|' || application_name || '|' || pid || '|' || usename || '|' || datname || '|' || coalesce(client_addr::text,'') FROM pg_stat_activity ORDER BY state, application_name;" | sed 's/|/\t/g'
}

action_terminate_idle() {
  log "Terminating idle client backends (excluding current)..."
  run_psql "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid() AND state = 'idle' AND backend_type = 'client backend';" >/dev/null || true
  echo "Idle connections terminated."
}

action_terminate_app() {
  local app_name="$1"
  if [[ -z "$app_name" ]]; then echo "Missing application name"; exit 1; fi
  log "Terminating connections for application_name='$app_name' (excluding current)..."
  run_psql "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid() AND application_name = '$app_name' AND backend_type = 'client backend';" >/dev/null || true
  echo "Connections for '$app_name' terminated."
}

action_increase_max() {
  local new_max="$1"
  if [[ -z "$new_max" ]]; then echo "Missing value for max_connections"; exit 1; fi
  if ! [[ "$new_max" =~ ^[0-9]+$ ]]; then echo "max_connections must be numeric"; exit 1; fi
  check_superuser
  log "Setting max_connections to $new_max..."
  run_psql "ALTER SYSTEM SET max_connections = $new_max;" >/dev/null
  log "Reloading configuration..."
  run_psql "SELECT pg_reload_conf();" >/dev/null
  echo "New max_connections: $(run_psql "SHOW max_connections;")"
}

main() {
  parse_args "$@"
  require_psql

  case "$ACTION" in
    status) action_status;;
    list) action_list;;
    terminate-idle) action_terminate_idle;;
    terminate-app) action_terminate_app "$ARG1";;
    increase-max) action_increase_max "$ARG1";;
    *) usage; exit 1;;
  esac
}

main "$@"
