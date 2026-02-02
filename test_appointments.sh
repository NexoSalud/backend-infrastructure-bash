#!/usr/bin/env bash
# Pruebas rápidas del endpoint /api/v1/appointments vía gateway
# Requiere: gateway ejecutándose en $GATEWAY_URL

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ -f ./env.sh ]; then
  # shellcheck disable=SC1091
  source ./env.sh
else
  export GATEWAY_URL=${GATEWAY_URL:-http://localhost:8080}
fi

AUTH_HEADER="Authorization: Bearer dummy-token"
EMP_HEADER="x-employee-id: 101"
BASE="$GATEWAY_URL/api/v1/appointments"

echo "Creando cita..."
CREATE_PAYLOAD='{
  "patientId": 1,
  "professionalId": 101,
  "agendaId": 1,
  "headquartersId": 1,
  "date": "2026-02-01",
  "startTime": "09:20",
  "modality": "PRESENCIAL",
  "functionality": "CONSULTA_PRIMERA_VEZ",
  "serviceTypeId": 1,
  "label": "Control Mensual",
  "administrativeNotes": "Paciente requiere silla de ruedas",
  "isGroupSession": false,
  "autoNotificationEnabled": true
}'
CREATE_RES=$(curl -s -H "$AUTH_HEADER" -H "$EMP_HEADER" -H 'Content-Type: application/json' -d "$CREATE_PAYLOAD" "$BASE")
APPT_ID=$(echo "$CREATE_RES" | grep -o '"id":[0-9]*' | cut -d':' -f2)

echo "Cita creada ID=$APPT_ID"

echo "Listando citas..."
curl -s -H "$AUTH_HEADER" "$BASE?page=0&size=10" | jq . || true

echo "Obteniendo cita por ID..."
curl -s -H "$AUTH_HEADER" "$BASE/$APPT_ID" | jq . || true

echo "Actualizando estado (CONFIRMADA)..."
PATCH_PAYLOAD='{"status":"CONFIRMADA","reason":"Paciente confirmó por teléfono"}'
curl -s -X PATCH -H "$AUTH_HEADER" -H 'Content-Type: application/json' -d "$PATCH_PAYLOAD" "$BASE/$APPT_ID/status" | jq . || true

echo "Enviando notificación..."
NOTIFY_PAYLOAD='{"channel":"WHATSAPP","type":"CONFIRMACION","recipient":"+573001234567"}'
curl -s -X POST -H "$AUTH_HEADER" -H 'Content-Type: application/json' -d "$NOTIFY_PAYLOAD" "$BASE/$APPT_ID/notifications" | jq . || true

echo "Consultando historial de notificaciones..."
curl -s -H "$AUTH_HEADER" "$BASE/$APPT_ID/notifications" | jq . || true

echo "Cancelando cita..."
curl -s -X DELETE -H "$AUTH_HEADER" "$BASE/$APPT_ID?reason=Prueba%20de%20cancelacion" -o /dev/null -w "%{http_code}\n"

echo "Listando citas tras cancelación..."
curl -s -H "$AUTH_HEADER" "$BASE?page=0&size=10" | jq . || true
