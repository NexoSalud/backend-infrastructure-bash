#!/bin/bash

# Script para iniciar todo el entorno Nexo
echo "🚀 Iniciando entorno Nexo Salud"

# Verificar que Docker esté corriendo
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker no está corriendo. Por favor inicia Docker primero."
    exit 1
fi

# Iniciar la base de datos
echo "🐘 Iniciando base de datos..."
./start-db.sh

if [ $? -ne 0 ]; then
    echo "❌ Error: No se pudo iniciar la base de datos"
    exit 1
fi

# Compilar todos los módulos
echo "🔨 Compilando módulos..."

modules=("backend-module-gateway" "backend-module-users" "backend-module-employees" "backend-module-schedule" "backend-module-appointments" "backend-module-convenios")

for module in "${modules[@]}"; do
    if [ -d "$module" ]; then
        echo "📦 Compilando $module..."
        cd "$module"
        mvn clean package -DskipTests
        cd ..
    else
        echo "⚠️  Módulo $module no encontrado"
    fi
done

echo "🎉 Entorno Nexo preparado!"
echo ""
echo "📋 Para iniciar los servicios:"
echo "   • Gateway (puerto 8080): cd backend-module-gateway && mvn spring-boot:run"
echo "   • Users (puerto 8081): cd backend-module-users && mvn spring-boot:run"
echo "   • Employees (puerto 8082): cd backend-module-employees && mvn spring-boot:run"
echo "   • Schedule (puerto 8083): cd backend-module-schedule && mvn spring-boot:run"
echo "   • Appointments (puerto 8084): cd backend-module-appointments && mvn spring-boot:run"
echo "   • History Template (puerto 8085): cd backend-history-template && mvn spring-boot:run"
echo "   • Convenios (puerto 8086): cd backend-module-convenios && mvn spring-boot:run"
echo ""
echo "🔗 URLs importantes:"
echo "   • Swagger UI: http://localhost:8080/swagger-ui.html"
echo "   • API Docs: http://localhost:8080/v3/api-docs"
echo "   • PostgreSQL: localhost:5432"
echo ""
echo "🗄️  Bases de datos creadas:"
echo "   • nexosalud (base de datos compartida para todos los módulos)"