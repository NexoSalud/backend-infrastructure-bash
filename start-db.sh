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
docker compose up postgres -d

# Verificar que el contenedor esté corriendo
sleep 5
if docker compose ps postgres | grep -q "Up"; then
    echo "✅ PostgreSQL iniciado correctamente!"
    echo "🔗 Disponible en: localhost:5432"
    echo "👤 Usuario: postgres"
    echo "🔑 Contraseña: postgres"
    echo ""
    echo "🗄️  Bases de datos disponibles:"
    echo "   • nexosalud (todas las tablas de todos los módulos)"
else
    echo "❌ Error: PostgreSQL no pudo iniciarse"
    docker compose logs postgres
    exit 1
fi