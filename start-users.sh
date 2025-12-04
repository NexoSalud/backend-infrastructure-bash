#!/bin/bash

# Script para iniciar el servicio Users
echo "👥 Iniciando Users Service en puerto 8081..."

cd backend-module-users

# Verificar que PostgreSQL esté corriendo
if ! docker exec webflux-postgres pg_isready -U postgres > /dev/null 2>&1; then
    echo "❌ PostgreSQL no está disponible. Ejecuta primero: ./start-db.sh"
    exit 1
fi

# Configurar perfil de Spring y puerto
export SPRING_PROFILES_ACTIVE=default
export SERVER_PORT=8081

echo "🔗 Users Service estará disponible en: http://localhost:8081"

mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8081"