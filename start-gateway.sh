#!/bin/bash

# Script para iniciar el servicio Gateway
echo "🌐 Iniciando Gateway Service en puerto 8080..."

cd backend-module-gateway

# Verificar que PostgreSQL esté corriendo
if ! docker exec webflux-postgres pg_isready -U postgres > /dev/null 2>&1; then
    echo "❌ PostgreSQL no está disponible. Ejecuta primero: ./start-db.sh"
    exit 1
fi

# Configurar perfil de Spring
export SPRING_PROFILES_ACTIVE=default

echo "🔗 Gateway estará disponible en:"
echo "   • API Gateway: http://localhost:8080"
echo "   • Swagger UI: http://localhost:8080/swagger-ui.html"
echo "   • API Docs: http://localhost:8080/v3/api-docs"

mvn spring-boot:run