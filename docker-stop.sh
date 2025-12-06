#!/bin/bash

# Script para detener todos los servicios de Docker Compose
echo "🛑 Deteniendo servicios de NexoSalud..."

# Verificar que Docker Compose esté disponible
if ! command -v docker-compose > /dev/null 2>&1 && ! docker compose version > /dev/null 2>&1; then
    echo "❌ Docker Compose no está disponible."
    exit 1
fi

# Detener y remover contenedores
if command -v docker-compose > /dev/null 2>&1; then
    docker-compose down
else
    docker compose down
fi

echo "✅ Servicios detenidos."
echo ""
echo "💡 Para limpiar completamente (incluyendo volúmenes):"
echo "   docker-compose down --volumes --rmi all"