#!/bin/bash

# Script para iniciar todos los servicios con Docker Compose
echo "🐳 Iniciando NexoSalud con Docker Compose..."

# Verificar que Docker esté corriendo
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker no está corriendo. Por favor inicia Docker primero."
    exit 1
fi

# Verificar que Docker Compose esté disponible
if ! command -v docker > /dev/null 2>&1; then
    echo "❌ Docker no está disponible."
    exit 1
fi

# Detener servicios existentes si están corriendo
echo "🛑 Deteniendo servicios existentes..."
docker compose down > /dev/null 2>&1

# Manejar parámetro -y para reconstruir automáticamente
rebuild="n"
if [[ "$1" == "-y" ]] || [[ "$1" == "--yes" ]]; then
    rebuild="y"
else
    read -p "¿Quieres reconstruir las imágenes? (y/n): " rebuild
fi

if [[ $rebuild =~ ^[Yy]$ ]]; then
    echo "🔄 Eliminando imágenes existentes..."
    docker compose down --rmi all > /dev/null 2>&1
fi

# Construir y levantar servicios
echo "🚀 Construyendo y levantando servicios..."
docker compose up --build -d

# Esperar a que los servicios estén listos
echo "⏳ Esperando a que los servicios estén listos..."
sleep 10

# Verificar estado de los servicios
echo "📊 Estado de los servicios:"
docker compose ps

echo ""
echo "✅ ¡NexoSalud está listo!"
echo "🌐 Gateway disponible en: http://localhost:8080"
echo "🗄️ PostgreSQL disponible en: localhost:5432"
echo "📊 Base de datos: nexosalud (compartida por todos los módulos)"
echo ""
echo "📝 Comandos útiles:"
echo "  - Ver logs: docker compose logs -f [service-name]"
echo "  - Detener: docker compose down"
echo "  - Reiniciar: docker compose restart [service-name]"
echo ""
echo "🔧 Servicios internos (no expuestos al host):"
echo "  - Users Service: http://users-service:8081 (interno)"
echo "  - Employees Service: http://employees-service:8082 (interno)"
echo "  - Schedule Service: http://schedule-service:8083 (interno)"
echo "  - Appointments Service: http://appointments-service:8084 (interno)"