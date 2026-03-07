#!/bin/bash

echo "🔍 Verificando el entorno Nexo..."

# Verificar Docker
echo "1. Verificando Docker..."
if docker info > /dev/null 2>&1; then
    echo "   ✅ Docker está corriendo"
else
    echo "   ❌ Docker no está corriendo"
    exit 1
fi

# Verificar PostgreSQL
echo "2. Verificando PostgreSQL..."
if docker compose ps | grep -q "webflux-postgres.*Up"; then
    echo "   ✅ PostgreSQL está corriendo"
    
    # Verificar conexión
    if docker exec webflux-postgres pg_isready -U postgres > /dev/null 2>&1; then
        echo "   ✅ PostgreSQL está respondiendo"
    else
        echo "   ❌ PostgreSQL no está respondiendo"
    fi
    
    # Verificar bases de datos
    DB_COUNT=$(docker exec webflux-postgres psql -U postgres -t -c "SELECT count(*) FROM pg_database WHERE datname IN ('gatewaydb', 'usersdb', 'employeesdb', 'scheduledb');" | tr -d ' ')
    if [ "$DB_COUNT" = "4" ]; then
        echo "   ✅ Las 4 bases de datos están creadas"
    else
        echo "   ⚠️  Solo $DB_COUNT/4 bases de datos encontradas"
    fi
else
    echo "   ❌ PostgreSQL no está corriendo"
    echo "   💡 Ejecuta: ./start-db.sh"
fi

# Verificar puertos
echo "3. Verificando puertos..."
for port in 8080 8081 8082 8083 8084 8085 8086; do
    if lsof -i :$port > /dev/null 2>&1; then
        echo "   ✅ Puerto $port está en uso"
    else
        echo "   🔓 Puerto $port está libre"
    fi
done

echo ""
echo "📋 Para iniciar los servicios:"
echo "   🐘 Base de datos: ./start-db.sh"  
echo "   🌐 Gateway: ./start-gateway.sh"
echo "   👥 Users: ./start-users.sh"
echo "   👔 Employees: ./start-employees.sh"
echo "   📅 Schedule: ./start-schedule.sh"
echo "   📅 Appointments: ./start-appointments.sh"
echo "   🤝 Convenios: ./start-convenios.sh"
echo "   📅 Schedule: ./start-schedule.sh"