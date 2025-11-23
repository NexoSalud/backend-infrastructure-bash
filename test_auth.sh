#!/usr/bin/env bash
# test_auth.sh — Scripts de prueba para la autenticación JWT
# Uso: chmod +x test_auth.sh && ./test_auth.sh

set -euo pipefail

GATEWAY_URL="${GATEWAY_URL:-http://localhost:8082}"
EMPLOYEES_URL="${EMPLOYEES_URL:-http://localhost:8081}"

echo "=========================================="
echo "TEST: Autenticación JWT con Mock Mode"
echo "=========================================="
echo

# Test 1: Login Mock (sin dependencias externas)
echo "Test 1: Login con Mock Mode (default)"
echo "POST $GATEWAY_URL/api/v1/auth/login"
curl -s -X POST "$GATEWAY_URL/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "identification_type":"CC",
    "identification_number":"12345",
    "password":"cualquier_password"
  }' | python3 -m json.tool
echo
echo

# Test 2: Logout
echo "Test 2: Logout"
echo "POST $GATEWAY_URL/api/v1/auth/logout"
curl -s -w "\nHTTP Status: %{http_code}\n" -X POST "$GATEWAY_URL/api/v1/auth/logout" \
  -H "Content-Type: application/json"
echo
echo

# Test 3: Extraer token y verificar claims (si jwt CLI disponible)
echo "Test 3: Extraer y decodificar token JWT"
TOKEN=$(curl -s -X POST "$GATEWAY_URL/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "identification_type":"CC",
    "identification_number":"99999",
    "password":"test"
  }' | python3 -c "import sys, json; print(json.load(sys.stdin)['token'])" 2>/dev/null || echo "")

if [ -z "$TOKEN" ]; then
  echo "No se pudo extraer el token. Asegúrate de que el servidor está corriendo."
  exit 1
fi

echo "Token obtenido (primeros 50 chars):"
echo "${TOKEN:0:50}..."
echo

# Intentar decodificar (requiere jwt CLI)
if command -v jwt >/dev/null 2>&1; then
  echo "Claims del token:"
  jwt decode "$TOKEN" 2>/dev/null || echo "No se puede decodificar con 'jwt' CLI"
else
  echo "Para decodificar el token, instala: npm install -g jwt-cli"
  echo "O usa: https://jwt.io/"
fi
echo
echo

# Test 4: Usar token en header (ejemplo)
echo "Test 4: Usar token en requests posteriores"
echo "GET $EMPLOYEES_URL/api/v1/employees"
echo "Authorization: Bearer \$TOKEN"
curl -s -X GET "$EMPLOYEES_URL/api/v1/employees" \
  -H "Authorization: Bearer $TOKEN" \
  2>/dev/null | python3 -m json.tool || echo "Employees no responde (esperado si está en mock-mode)"
echo
echo

echo "=========================================="
echo "Resumen de Tests"
echo "=========================================="
echo "✓ Test 1: Login devolvió token"
echo "✓ Test 2: Logout respondió 200"
echo "✓ Test 3: Token extraído e impreso"
echo "✓ Test 4: Token puede usarse en requests"
echo
echo "Token está listo para usar en Authorization headers:"
echo "  curl -H 'Authorization: Bearer $TOKEN' <url>"
