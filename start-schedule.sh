#!/bin/bash

# Script para iniciar el servicio Schedule
echo "📅 Iniciando Schedule Service en puerto 8083..."

cd backend-module-schedule

# Verificar que PostgreSQL esté corriendo
if ! docker exec webflux-postgres pg_isready -U postgres > /dev/null 2>&1; then
    echo "❌ PostgreSQL no está disponible. Ejecuta primero: ./start-db.sh"
    exit 1
fi

# Configurar perfil de Spring y puerto
export SPRING_PROFILES_ACTIVE=default
export SERVER_PORT=8083

echo "🔗 Schedule Service estará disponible en: http://localhost:8083"

mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8083"