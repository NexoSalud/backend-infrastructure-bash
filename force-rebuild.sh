#!/bin/bash
# Ejecutar en el servidor cloud por SSH ANTES de redesplegar en Portainer
# Elimina todas las imágenes de NexoSalud para forzar rebuild completo

echo "=== Deteniendo contenedores NexoSalud ==="
docker stop nexosalud-gateway nexosalud-users nexosalud-employees \
  nexosalud-schedule nexosalud-appointments nexosalud-history \
  nexosalud-convenios nexosalud-billing nexosalud-postgres 2>/dev/null || true

echo "=== Eliminando contenedores ==="
docker rm nexosalud-gateway nexosalud-users nexosalud-employees \
  nexosalud-schedule nexosalud-appointments nexosalud-history \
  nexosalud-convenios nexosalud-billing nexosalud-postgres 2>/dev/null || true

echo "=== Eliminando imágenes NexoSalud ==="
docker images --format "{{.Repository}}:{{.Tag}}" | grep "nexosalud/" | xargs docker rmi --force 2>/dev/null || true

echo "=== Limpiando build cache ==="
docker builder prune -af

echo "=== Listo. Ahora redesplegar el stack en Portainer ==="
docker images | grep nexosalud || echo "No quedan imágenes NexoSalud en cache"
