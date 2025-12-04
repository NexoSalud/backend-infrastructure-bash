#!/bin/bash

# Script para iniciar el servicio Employees
echo "👔 Iniciando Employees Service en puerto 8082..."

cd backend-module-employees

# Verificar que PostgreSQL esté corriendo
if ! docker exec webflux-postgres pg_isready -U postgres > /dev/null 2>&1; then
    echo "❌ PostgreSQL no está disponible. Ejecuta primero: ./start-db.sh"
    exit 1
fi

# Configurar perfil de Spring y puerto
export SPRING_PROFILES_ACTIVE=default
export SERVER_PORT=8082

echo "🔗 Employees Service estará disponible en: http://localhost:8082"

mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8082"