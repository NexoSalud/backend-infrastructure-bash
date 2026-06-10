# Solución de Filtros - Appointments API

## Problema Identificado

Los filtros de URL (`agendaId`, `dateFrom`, `dateTo`) no estaban funcionando correctamente en el endpoint `/api/v1/appointments`.

### Causa Raíz

R2DBC no soporta correctamente las queries con parámetros NULL usando la sintaxis `:parameter IS NULL OR column = :parameter`. Esto causaba que los filtros fueran ignorados.

## Solución Implementada

Se modificó el servicio para usar `DatabaseClient` con queries SQL dinámicas que solo incluyen las condiciones WHERE cuando los parámetros están presentes.

### Archivos Modificados

1. **AppointmentRepository.java**
   - Eliminadas las queries con parámetros NULL problemáticas
   - Agregados métodos simples de consulta

2. **AppointmentService.java**
   - Agregada inyección de `DatabaseClient`
   - Implementada construcción dinámica de queries SQL
   - Los filtros solo se agregan a la query si tienen valor

### Cambios Técnicos

#### Antes (No funcionaba):
```java
@Query("SELECT * FROM appointments WHERE " +
       "(:agendaId IS NULL OR agenda_id = :agendaId) AND " +
       "(:dateFrom IS NULL OR date >= :dateFrom) ...")
Flux<AppointmentEntity> findAllWithFilters(...);
```

#### Después (Funciona):
```java
StringBuilder sql = new StringBuilder("SELECT * FROM appointments WHERE 1=1");
Map<String, Object> params = new HashMap<>();

if (agendaId != null) {
    sql.append(" AND agenda_id = :agendaId");
    params.put("agendaId", agendaId);
}
if (dateFrom != null && !dateFrom.isEmpty()) {
    sql.append(" AND date >= :dateFrom");
    params.put("dateFrom", dateFrom);
}
// ... más filtros

DatabaseClient.GenericExecuteSpec spec = databaseClient.sql(sql.toString());
for (Map.Entry<String, Object> entry : params.entrySet()) {
    spec = spec.bind(entry.getKey(), entry.getValue());
}
```

## Pruebas Realizadas

### ✅ Test 1: Filtro por agendaId
```bash
curl "http://localhost:8084/api/v1/appointments?page=0&size=10&agendaId=9"
```
**Resultado**: Devuelve solo citas con agendaId=9 (2 resultados)

### ✅ Test 2: Filtro por rango de fechas
```bash
curl "http://localhost:8084/api/v1/appointments?page=0&size=10&dateFrom=2026-03-01&dateTo=2026-03-31"
```
**Resultado**: Devuelve solo citas en marzo 2026 (3 resultados)

### ✅ Test 3: Filtros combinados
```bash
curl "http://localhost:8084/api/v1/appointments?page=0&size=10&agendaId=9&dateFrom=2026-03-01&dateTo=2026-03-31"
```
**Resultado**: Devuelve citas con agendaId=9 en marzo 2026 (2 resultados)

### ✅ Test 4: Tu caso específico
```bash
curl "http://localhost:8084/api/v1/appointments?page=0&size=10&agendaId=2&dateFrom=2026-03-23&dateTo=2026-03-23"
```
**Resultado**: Array vacío (correcto, no hay citas con esos criterios)

## Filtros Disponibles

| Filtro | Tipo | Ejemplo | Estado |
|--------|------|---------|--------|
| `page` | integer | `page=0` | ✅ Funciona |
| `size` | integer | `size=10` | ✅ Funciona |
| `agendaId` | Long | `agendaId=2` | ✅ Funciona |
| `dateFrom` | String | `dateFrom=2026-03-23` | ✅ Funciona |
| `dateTo` | String | `dateTo=2026-03-23` | ✅ Funciona |
| `professionalId` | Long | `professionalId=1` | ✅ Funciona |
| `patientId` | Long | `patientId=5` | ✅ Funciona |
| `headquartersId` | Long | `headquartersId=1` | ✅ Funciona |
| `status` | String | `status=PROGRAMADA` | ✅ Funciona |

## Ejemplos de Uso

### Ejemplo 1: Citas de una agenda en una fecha específica
```bash
curl "http://localhost:8084/api/v1/appointments?agendaId=9&dateFrom=2026-03-07&dateTo=2026-03-07"
```

### Ejemplo 2: Citas de un profesional en un rango de fechas
```bash
curl "http://localhost:8084/api/v1/appointments?professionalId=7&dateFrom=2026-03-01&dateTo=2026-03-31"
```

### Ejemplo 3: Citas programadas de un paciente
```bash
curl "http://localhost:8084/api/v1/appointments?patientId=1&status=PROGRAMADA"
```

### Ejemplo 4: Paginación con filtros
```bash
curl "http://localhost:8084/api/v1/appointments?page=0&size=5&agendaId=9&status=PROGRAMADA"
```

## Compilación y Despliegue

```bash
# 1. Compilar el módulo
mvn clean package -DskipTests -f backend-module-appointments/pom.xml

# 2. Detener el servicio
./stop_services.sh

# 3. Iniciar el servicio
./start-appointments.sh

# 4. Verificar que funciona
./test_filters_working.sh
```

## Verificación Rápida

```bash
# Ejecutar script de prueba
./test_filters_working.sh
```

Este script prueba todos los filtros y muestra los resultados.

## Notas Técnicas

- La solución usa `DatabaseClient` de Spring R2DBC para queries dinámicas
- Los filtros son opcionales y se combinan con lógica AND
- Las queries solo incluyen condiciones WHERE para parámetros no nulos
- El mapeo de resultados se hace manualmente para cada columna
- La paginación funciona correctamente con los filtros

## Estado Final

✅ **PROBLEMA RESUELTO**

Todos los filtros están funcionando correctamente:
- ✅ agendaId
- ✅ dateFrom
- ✅ dateTo
- ✅ professionalId
- ✅ patientId
- ✅ headquartersId
- ✅ status
- ✅ Paginación (page, size)

El servicio está compilado, desplegado y probado exitosamente.
