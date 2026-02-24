#!/bin/bash

# Script para hacer git fetch --all y git merge origin/<branch> en todos los directorios backend-*

echo "Cerrando todos los procesos Java en ejecución..."
pkill -f java

git fetch --all
git merge origin/$BRANCH

# Validar parámetro de rama
BRANCH="${1:-develop}"
echo "Usando rama: $BRANCH"

for dir in backend-*; do
    if [ -d "$dir" ]; then
        echo "Procesando $dir..."
        cd "$dir"
        git fetch --all
        git merge origin/$BRANCH
        cd ..
    fi
done

echo "Operación completada en todos los directorios backend-*"

./start_services.sh > /dev/null 2>&1 &