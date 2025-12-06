#!/bin/bash

# Script para detener todos los servicios de Docker Compose
echo "🛑 Deteniendo servicios de NexoSalud..."

# Verificar que Docker esté disponible
if ! command -v docker > /dev/null 2>&1; then
    echo "❌ Docker no está disponible."
    exit 1
fi

# Detener y remover contenedores
docker compose down

echo "✅ Servicios detenidos."
echo ""
echo "💡 Para limpiar completamente (incluyendo volúmenes):"
echo "   docker compose down --volumes --rmi all"