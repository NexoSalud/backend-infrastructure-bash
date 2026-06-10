# Appointments API - Filters Documentation

## Overview
The appointments endpoint `/api/v1/appointments` supports multiple filters to search and retrieve appointments based on various criteria.

## Endpoint
```
GET /api/v1/appointments
```

## Query Parameters

### Pagination Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `page` | integer | No | 0 | Page number (zero-based) |
| `size` | integer | No | 10 | Number of items per page |

### Filter Parameters
| Parameter | Type | Required | Description | Example |
|-----------|------|----------|-------------|---------|
| `agendaId` | Long | No | Filter by medical agenda ID | `agendaId=2` |
| `dateFrom` | String | No | Filter appointments from this date (inclusive) | `dateFrom=2026-03-23` |
| `dateTo` | String | No | Filter appointments until this date (inclusive) | `dateTo=2026-03-23` |
| `professionalId` | Long | No | Filter by professional/doctor ID | `professionalId=1` |
| `patientId` | Long | No | Filter by patient ID | `patientId=5` |
| `headquartersId` | Long | No | Filter by headquarters ID | `headquartersId=1` |
| `status` | String | No | Filter by appointment status | `status=PROGRAMADA` |

### Date Format
- Dates must be in ISO format: `YYYY-MM-DD`
- Example: `2026-03-23`

### Status Values
- `PROGRAMADA` - Scheduled
- `CONFIRMADA` - Confirmed
- `CANCELADA` - Cancelled
- `COMPLETADA` - Completed
- `EN_CURSO` - In progress

## Response Format

```json
{
  "content": [
    {
      "id": 1,
      "patientId": 5,
      "professionalId": 1,
      "agendaId": 2,
      "headquartersId": 1,
      "officeId": 3,
      "date": "2026-03-23",
      "startTime": "09:00",
      "endTime": "09:20",
      "modality": "PRESENCIAL",
      "functionality": "CONSULTA",
      "serviceTypeId": 1,
      "label": "Consulta General",
      "administrativeNotes": "Primera consulta",
      "clinicalNotes": null,
      "status": "PROGRAMADA",
      "autoNotificationEnabled": true,
      "isGroupSession": false,
      "createdAt": "2026-03-03T12:00:00",
      "updatedAt": "2026-03-03T12:00:00",
      "createdBy": 1,
      "confirmedAt": null,
      "confirmedBy": null,
      "cancelledAt": null,
      "cancelledBy": null,
      "cancellationReason": null
    }
  ],
  "page": 0,
  "size": 10,
  "totalElements": 1,
  "totalPages": 1,
  "last": true
}
```

## Usage Examples

### Example 1: Basic Pagination
```bash
GET /api/v1/appointments?page=0&size=10
```

### Example 2: Filter by Agenda ID
```bash
GET /api/v1/appointments?page=0&size=10&agendaId=2
```

### Example 3: Filter by Date Range
```bash
GET /api/v1/appointments?page=0&size=10&dateFrom=2026-03-23&dateTo=2026-03-23
```

### Example 4: Combined Filters (Your Use Case)
```bash
GET /api/v1/appointments?page=0&size=10&agendaId=2&dateFrom=2026-03-23&dateTo=2026-03-23
```

### Example 5: Filter by Professional and Status
```bash
GET /api/v1/appointments?page=0&size=10&professionalId=1&status=PROGRAMADA
```

### Example 6: Filter by Patient and Date Range
```bash
GET /api/v1/appointments?page=0&size=10&patientId=5&dateFrom=2026-03-01&dateTo=2026-03-31
```

### Example 7: Multiple Filters
```bash
GET /api/v1/appointments?page=0&size=10&agendaId=2&status=PROGRAMADA&dateFrom=2026-03-01&dateTo=2026-03-31&headquartersId=1
```

## cURL Examples

### Direct to Appointments Service
```bash
curl -X GET "http://localhost:8082/api/v1/appointments?page=0&size=10&agendaId=2&dateFrom=2026-03-23&dateTo=2026-03-23"
```

### Through Gateway (with authentication)
```bash
curl -X GET "http://localhost:8080/api/v1/appointments?page=0&size=10&agendaId=2&dateFrom=2026-03-23&dateTo=2026-03-23" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Implementation Details

### Backend Components

#### 1. Controller (`AppointmentsController.java`)
```java
@GetMapping
public Mono<ResponseEntity<AppointmentResponse>> list(
    @RequestParam(name = "page", defaultValue = "0") int page,
    @RequestParam(name = "size", defaultValue = "10") int size,
    @RequestParam Map<String, String> allParams) {
    // Extracts all query parameters and passes them as filters
}
```

#### 2. Service (`AppointmentService.java`)
```java
public List<Appointment> search(Map<String, String> filters, int page, int size) {
    Long agendaId = filters.containsKey("agendaId") 
        ? Long.parseLong(filters.get("agendaId")) : null;
    String dateFrom = filters.getOrDefault("dateFrom", null);
    String dateTo = filters.getOrDefault("dateTo", null);
    // ... other filters
}
```

#### 3. Repository (`AppointmentRepository.java`)
```java
@Query("SELECT * FROM appointments WHERE " +
       "(:agendaId IS NULL OR agenda_id = :agendaId) AND " +
       "(:dateFrom IS NULL OR date >= :dateFrom) AND " +
       "(:dateTo IS NULL OR date <= :dateTo) " +
       "ORDER BY date DESC, start_time DESC " +
       "LIMIT :size OFFSET :offset")
Flux<AppointmentEntity> findAllWithFilters(...);
```

## Filter Logic

- All filters are optional and can be combined
- Filters use AND logic (all conditions must be met)
- NULL filters are ignored in the query
- Date comparisons are inclusive (>= for dateFrom, <= for dateTo)
- Results are ordered by date DESC, then start_time DESC

## Performance Considerations

- An index exists on `(professional_id, agenda_id, date, start_time)` for optimal query performance
- Consider adding indexes for frequently used filter combinations
- Pagination helps manage large result sets

## Testing

Run the test script to verify all filters:
```bash
./test_appointments_filters.sh
```

## Notes

- Date fields are stored as VARCHAR(10) in format YYYY-MM-DD
- Time fields are stored as VARCHAR(5) in format HH:MM
- All filters are case-sensitive for string values
- The service uses reactive programming with R2DBC for non-blocking database access
