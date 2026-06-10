#!/bin/bash
# Script para iniciar el servicio de Billing/Recaudo

cd backend-module-billing

echo "=== Iniciando Billing Service (puerto 8087) ==="

export SPRING_R2DBC_URL="r2dbc:postgresql://localhost:5432/nexosalud"
export SPRING_R2DBC_USERNAME="postgres"
export SPRING_R2DBC_PASSWORD="postgres"
export BILLING_PORT="8087"

mvn spring-boot:run &
BILLING_PID=$!
echo "Billing Service PID: $BILLING_PID"
echo $BILLING_PID >> ../.service_pids

cd ..
echo "=== Billing Service iniciado ==="
