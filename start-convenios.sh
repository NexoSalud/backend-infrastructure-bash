#!/bin/bash

# Script para iniciar el servicio Convenios
echo "🤝 Iniciando Convenios Service en puerto 8086..."

cd backend-module-convenios

# Verificar que PostgreSQL esté corriendo
if ! docker exec webflux-postgres pg_isready -U postgres > /dev/null 2>&1; then
    echo "❌ PostgreSQL no está disponible. Ejecuta primero: ./start-db.sh"
    exit 1
fi

# Configurar perfil de Spring y puerto
export SPRING_PROFILES_ACTIVE=default
export SERVER_PORT=8086

echo "🔗 Convenios Service estará disponible en: http://localhost:8086"
mvn clean spring-boot:run
