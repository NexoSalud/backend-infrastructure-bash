#!/bin/bash
# Script de diagnóstico de red Docker para NexoSalud
# Ejecutar en el servidor cloud: bash check-docker-network.sh

echo "======================================================"
echo "1. CONTENEDORES EN EJECUCIÓN"
echo "======================================================"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Networks}}" 2>&1

echo ""
echo "======================================================"
echo "2. REDES DOCKER EXISTENTES"
echo "======================================================"
docker network ls 2>&1

echo ""
echo "======================================================"
echo "3. DETALLE DE LA RED nexo-backend-network (si existe)"
echo "======================================================"
docker network inspect nexo-backend-network 2>&1 | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    net = data[0]
    print('Nombre:', net['Name'])
    print('Driver:', net['Driver'])
    print('Scope:', net['Scope'])
    print('Contenedores conectados:')
    for cid, c in net.get('Containers', {}).items():
        print(f'  - {c[\"Name\"]} → {c[\"IPv4Address\"]}')
except Exception as e:
    print('Error:', e)
" 2>&1

echo ""
echo "======================================================"
echo "4. VARIABLES DE ENTORNO DEL GATEWAY (solo R2DBC)"
echo "======================================================"
docker inspect nexosalud-gateway 2>&1 | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    env = data[0]['Config']['Env']
    for e in env:
        if any(k in e for k in ['R2DBC', 'SPRING_R2DBC', 'POSTGRES', 'PROFILES']):
            print(e)
except Exception as e:
    print('Error:', e)
" 2>&1

echo ""
echo "======================================================"
echo "5. REDES DEL CONTENEDOR GATEWAY"
echo "======================================================"
docker inspect nexosalud-gateway 2>&1 | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    nets = data[0]['NetworkSettings']['Networks']
    for name, info in nets.items():
        print(f'Red: {name}')
        print(f'  IP: {info[\"IPAddress\"]}')
        print(f'  Gateway: {info[\"Gateway\"]}')
except Exception as e:
    print('Error:', e)
" 2>&1

echo ""
echo "======================================================"
echo "6. TEST DE CONECTIVIDAD DESDE GATEWAY A POSTGRES"
echo "======================================================"
docker exec nexosalud-gateway sh -c "
  echo 'Resolviendo hostname postgres...'
  nslookup postgres 2>/dev/null || getent hosts postgres 2>/dev/null || echo 'No se puede resolver postgres'
  echo 'Probando conexión TCP a postgres:5432...'
  nc -zv postgres 5432 2>&1 || echo 'No hay conexión TCP a postgres:5432'
" 2>&1

echo ""
echo "======================================================"
echo "DIAGNÓSTICO COMPLETO"
echo "======================================================"
