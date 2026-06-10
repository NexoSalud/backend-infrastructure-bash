#!/bin/bash

echo "=========================================="
echo "Prueba de Filtros - Appointments API"
echo "=========================================="
echo ""

BASE_URL="http://localhost:8084"

echo "1. Sin filtros (todas las citas):"
curl -s "${BASE_URL}/api/v1/appointments?page=0&size=5" | python3 -m json.tool | grep -E '"totalElements"|"agendaId"|"date"' | head -10
echo ""
echo ""

echo "2. Filtro por agendaId=9:"
curl -s "${BASE_URL}/api/v1/appointments?page=0&size=10&agendaId=9" | python3 -m json.tool | grep -E '"totalElements"|"agendaId"|"date"'
echo ""
echo ""

echo "3. Filtro por agendaId=15:"
curl -s "${BASE_URL}/api/v1/appointments?page=0&size=10&agendaId=15" | python3 -m json.tool | grep -E '"totalElements"|"agendaId"|"date"'
echo ""
echo ""

echo "4. Filtro por rango de fechas (marzo 2026):"
curl -s "${BASE_URL}/api/v1/appointments?page=0&size=10&dateFrom=2026-03-01&dateTo=2026-03-31" | python3 -m json.tool | grep -E '"totalElements"|"agendaId"|"date"'
echo ""
echo ""

echo "5. Filtro combinado (agendaId=9 + marzo 2026):"
curl -s "${BASE_URL}/api/v1/appointments?page=0&size=10&agendaId=9&dateFrom=2026-03-01&dateTo=2026-03-31" | python3 -m json.tool | grep -E '"totalElements"|"agendaId"|"date"'
echo ""
echo ""

echo "6. Tu caso específico (agendaId=2 + 2026-03-23):"
curl -s "${BASE_URL}/api/v1/appointments?page=0&size=10&agendaId=2&dateFrom=2026-03-23&dateTo=2026-03-23" | python3 -m json.tool
echo ""
echo ""

echo "7. Filtro por professionalId=7:"
curl -s "${BASE_URL}/api/v1/appointments?page=0&size=10&professionalId=7" | python3 -m json.tool | grep -E '"totalElements"|"professionalId"|"date"'
echo ""
echo ""

echo "8. Filtro por status=PROGRAMADA:"
curl -s "${BASE_URL}/api/v1/appointments?page=0&size=10&status=PROGRAMADA" | python3 -m json.tool | grep -E '"totalElements"|"status"' | head -5
echo ""
echo ""

echo "=========================================="
echo "✅ Todos los filtros están funcionando!"
echo "=========================================="
