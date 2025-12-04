#!/bin/bash

echo "🐘 Iniciando PostgreSQL para Nexo Salud..."

# Verificar que Docker esté corriendo
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker no está corriendo. Por favor inicia Docker primero."
    exit 1
fi

# Detener contenedores existentes si los hay
echo "🛑 Deteniendo contenedores existentes..."
docker compose down > /dev/null 2>&1

# Iniciar PostgreSQL
echo "🚀 Iniciando PostgreSQL..."
docker compose up -d

# Verificar que el contenedor esté corriendo
sleep 3
if docker compose ps | grep -q "nexosalud-postgres.*Up"; then
    echo "✅ PostgreSQL iniciado correctamente!"
    echo "🔗 Disponible en: localhost:5432"
    echo "👤 Usuario: postgres"
    echo "🔑 Contraseña: postgres"
    echo ""
    echo "🗄️  Bases de datos disponibles:"
    echo "   • gatewaydb"
    echo "   • usersdb" 
    echo "   • employeesdb"
    echo "   • scheduledb"
else
    echo "❌ Error: PostgreSQL no pudo iniciarse"
    docker compose logs postgres
    exit 1
fi