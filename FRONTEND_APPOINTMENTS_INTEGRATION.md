# Frontend Integration Guide - Appointments Filters

## Quick Reference

### API Endpoint
```
GET /api/v1/appointments
```

### TypeScript/JavaScript Examples

#### 1. Basic Fetch with Filters
```typescript
async function fetchAppointments(filters: {
  page?: number;
  size?: number;
  agendaId?: number;
  dateFrom?: string;
  dateTo?: string;
  professionalId?: number;
  patientId?: number;
  status?: string;
}) {
  const params = new URLSearchParams();
  
  // Add pagination
  params.append('page', String(filters.page ?? 0));
  params.append('size', String(filters.size ?? 10));
  
  // Add filters
  if (filters.agendaId) params.append('agendaId', String(filters.agendaId));
  if (filters.dateFrom) params.append('dateFrom', filters.dateFrom);
  if (filters.dateTo) params.append('dateTo', filters.dateTo);
  if (filters.professionalId) params.append('professionalId', String(filters.professionalId));
  if (filters.patientId) params.append('patientId', String(filters.patientId));
  if (filters.status) params.append('status', filters.status);
  
  const response = await fetch(`/api/v1/appointments?${params.toString()}`);
  return response.json();
}
```

#### 2. Usage Example
```typescript
// Your specific use case
const appointments = await fetchAppointments({
  page: 0,
  size: 10,
  agendaId: 2,
  dateFrom: '2026-03-23',
  dateTo: '2026-03-23'
});

console.log(appointments);
// {
//   content: [...],
//   page: 0,
//   size: 10,
//   totalElements: 5,
//   totalPages: 1,
//   last: true
// }
```

#### 3. React Hook Example
```typescript
import { useState, useEffect } from 'react';

interface AppointmentFilters {
  page?: number;
  size?: number;
  agendaId?: number;
  dateFrom?: string;
  dateTo?: string;
  professionalId?: number;
  patientId?: number;
  status?: string;
}

export function useAppointments(filters: AppointmentFilters) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    async function loadAppointments() {
      try {
        setLoading(true);
        const result = await fetchAppointments(filters);
        setData(result);
      } catch (err) {
        setError(err);
      } finally {
        setLoading(false);
      }
    }

    loadAppointments();
  }, [JSON.stringify(filters)]);

  return { data, loading, error };
}

// Usage in component
function AppointmentsList() {
  const { data, loading, error } = useAppointments({
    page: 0,
    size: 10,
    agendaId: 2,
    dateFrom: '2026-03-23',
    dateTo: '2026-03-23'
  });

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <div>
      {data.content.map(appointment => (
        <div key={appointment.id}>{appointment.label}</div>
      ))}
    </div>
  );
}
```

#### 4. Next.js API Route Example
```typescript
// app/api/proxy/appointments/route.ts
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams;
  
  // Build query string
  const params = new URLSearchParams();
  params.append('page', searchParams.get('page') || '0');
  params.append('size', searchParams.get('size') || '10');
  
  if (searchParams.has('agendaId')) {
    params.append('agendaId', searchParams.get('agendaId')!);
  }
  if (searchParams.has('dateFrom')) {
    params.append('dateFrom', searchParams.get('dateFrom')!);
  }
  if (searchParams.has('dateTo')) {
    params.append('dateTo', searchParams.get('dateTo')!);
  }
  
  // Forward to backend
  const backendUrl = process.env.APPOINTMENTS_SERVICE_URL || 'http://localhost:8082';
  const response = await fetch(`${backendUrl}/api/v1/appointments?${params.toString()}`);
  const data = await response.json();
  
  return NextResponse.json(data);
}
```

#### 5. Axios Example
```typescript
import axios from 'axios';

async function getAppointments(filters: AppointmentFilters) {
  const response = await axios.get('/api/v1/appointments', {
    params: {
      page: filters.page ?? 0,
      size: filters.size ?? 10,
      ...(filters.agendaId && { agendaId: filters.agendaId }),
      ...(filters.dateFrom && { dateFrom: filters.dateFrom }),
      ...(filters.dateTo && { dateTo: filters.dateTo }),
      ...(filters.professionalId && { professionalId: filters.professionalId }),
      ...(filters.patientId && { patientId: filters.patientId }),
      ...(filters.status && { status: filters.status })
    }
  });
  
  return response.data;
}
```

## TypeScript Types

```typescript
export interface Appointment {
  id: number;
  patientId: number;
  professionalId: number;
  agendaId: number;
  headquartersId: number;
  officeId: number | null;
  date: string; // YYYY-MM-DD
  startTime: string; // HH:MM
  endTime: string; // HH:MM
  modality: string;
  functionality: string;
  serviceTypeId: number;
  label: string;
  administrativeNotes: string | null;
  clinicalNotes: string | null;
  status: AppointmentStatus;
  autoNotificationEnabled: boolean;
  isGroupSession: boolean;
  createdAt: string;
  updatedAt: string;
  createdBy: number;
  confirmedAt: string | null;
  confirmedBy: number | null;
  cancelledAt: string | null;
  cancelledBy: number | null;
  cancellationReason: string | null;
}

export type AppointmentStatus = 
  | 'PROGRAMADA' 
  | 'CONFIRMADA' 
  | 'CANCELADA' 
  | 'COMPLETADA' 
  | 'EN_CURSO';

export interface AppointmentResponse {
  content: Appointment[];
  page: number;
  size: number;
  totalElements: number;
  totalPages: number;
  last: boolean;
}

export interface AppointmentFilters {
  page?: number;
  size?: number;
  agendaId?: number;
  dateFrom?: string; // YYYY-MM-DD
  dateTo?: string; // YYYY-MM-DD
  professionalId?: number;
  patientId?: number;
  headquartersId?: number;
  status?: AppointmentStatus;
}
```

## Date Handling

### Format Dates for API
```typescript
function formatDateForAPI(date: Date): string {
  return date.toISOString().split('T')[0]; // YYYY-MM-DD
}

// Usage
const today = new Date();
const dateFrom = formatDateForAPI(today);
const dateTo = formatDateForAPI(today);

fetchAppointments({ dateFrom, dateTo });
```

### Parse Dates from API
```typescript
function parseAPIDate(dateStr: string): Date {
  return new Date(dateStr + 'T00:00:00');
}

function parseAPIDateTime(dateStr: string, timeStr: string): Date {
  return new Date(`${dateStr}T${timeStr}:00`);
}
```

## Common Use Cases

### 1. Get Today's Appointments for an Agenda
```typescript
const today = new Date().toISOString().split('T')[0];
const appointments = await fetchAppointments({
  agendaId: 2,
  dateFrom: today,
  dateTo: today
});
```

### 2. Get Week's Appointments
```typescript
const today = new Date();
const weekLater = new Date(today);
weekLater.setDate(weekLater.getDate() + 7);

const appointments = await fetchAppointments({
  agendaId: 2,
  dateFrom: formatDateForAPI(today),
  dateTo: formatDateForAPI(weekLater)
});
```

### 3. Get Patient's Upcoming Appointments
```typescript
const today = new Date().toISOString().split('T')[0];
const appointments = await fetchAppointments({
  patientId: 5,
  dateFrom: today,
  status: 'PROGRAMADA'
});
```

### 4. Pagination
```typescript
function AppointmentsPagination() {
  const [page, setPage] = useState(0);
  const { data } = useAppointments({ page, size: 10, agendaId: 2 });

  return (
    <div>
      <button 
        disabled={page === 0} 
        onClick={() => setPage(p => p - 1)}
      >
        Previous
      </button>
      
      <span>Page {page + 1} of {data?.totalPages}</span>
      
      <button 
        disabled={data?.last} 
        onClick={() => setPage(p => p + 1)}
      >
        Next
      </button>
    </div>
  );
}
```

## Error Handling

```typescript
async function fetchAppointmentsWithErrorHandling(filters: AppointmentFilters) {
  try {
    const params = new URLSearchParams();
    // ... build params
    
    const response = await fetch(`/api/v1/appointments?${params.toString()}`);
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('Failed to fetch appointments:', error);
    throw error;
  }
}
```

## Testing

```typescript
// Jest test example
describe('fetchAppointments', () => {
  it('should fetch appointments with filters', async () => {
    const mockData = {
      content: [],
      page: 0,
      size: 10,
      totalElements: 0,
      totalPages: 0,
      last: true
    };
    
    global.fetch = jest.fn(() =>
      Promise.resolve({
        ok: true,
        json: () => Promise.resolve(mockData)
      })
    ) as jest.Mock;
    
    const result = await fetchAppointments({
      agendaId: 2,
      dateFrom: '2026-03-23',
      dateTo: '2026-03-23'
    });
    
    expect(result).toEqual(mockData);
    expect(fetch).toHaveBeenCalledWith(
      expect.stringContaining('agendaId=2')
    );
  });
});
```
