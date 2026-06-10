#!/bin/bash

# Test script for appointments filters
# Usage: ./test_appointments_filters.sh

BASE_URL="http://localhost:8084"
GATEWAY_URL="http://localhost:8080"

echo "=========================================="
echo "Testing Appointments Filters"
echo "=========================================="
echo ""

# Test 1: Basic pagination
echo "Test 1: Basic pagination (page=0, size=10)"
curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10" | python3 -m json.tool 2>/dev/null || curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10"
echo ""
echo ""

# Test 2: Filter by agendaId
echo "Test 2: Filter by agendaId=2"
curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10&agendaId=2" | python3 -m json.tool 2>/dev/null || curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10&agendaId=2"
echo ""
echo ""

# Test 3: Filter by date range
echo "Test 3: Filter by date range (2026-03-23 to 2026-03-23)"
curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10&dateFrom=2026-03-23&dateTo=2026-03-23" | python3 -m json.tool 2>/dev/null || curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10&dateFrom=2026-03-23&dateTo=2026-03-23"
echo ""
echo ""

# Test 4: Combined filters (agendaId + date range)
echo "Test 4: Combined filters (agendaId=2, dateFrom=2026-03-23, dateTo=2026-03-23)"
curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10&agendaId=2&dateFrom=2026-03-23&dateTo=2026-03-23" | python3 -m json.tool 2>/dev/null || curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10&agendaId=2&dateFrom=2026-03-23&dateTo=2026-03-23"
echo ""
echo ""

# Test 5: Filter by professionalId
echo "Test 5: Filter by professionalId=1"
curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10&professionalId=1" | python3 -m json.tool 2>/dev/null || curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10&professionalId=1"
echo ""
echo ""

# Test 6: Filter by status
echo "Test 6: Filter by status=PROGRAMADA"
curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10&status=PROGRAMADA" | python3 -m json.tool 2>/dev/null || curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10&status=PROGRAMADA"
echo ""
echo ""

# Test 7: Multiple filters
echo "Test 7: Multiple filters (agendaId=2, status=PROGRAMADA, dateFrom=2026-03-01)"
curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10&agendaId=2&status=PROGRAMADA&dateFrom=2026-03-01" | python3 -m json.tool 2>/dev/null || curl -s -X GET "${BASE_URL}/api/v1/appointments?page=0&size=10&agendaId=2&status=PROGRAMADA&dateFrom=2026-03-01"
echo ""
echo ""

# Test 8: Through Gateway (if available)
echo "Test 8: Through Gateway with filters (requires authentication)"
echo "curl \"${GATEWAY_URL}/api/v1/appointments?page=0&size=10&agendaId=2&dateFrom=2026-03-23&dateTo=2026-03-23\" -H \"Authorization: Bearer YOUR_TOKEN_HERE\""
echo ""
echo ""

echo "=========================================="
echo "Tests completed!"
echo "=========================================="
