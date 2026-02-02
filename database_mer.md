# Diagrama Entidad-Relación (MER) - Nexo Salud

Este diagrama representa la estructura de la base de datos `nexosalud` compartida por los microservicios.

```mermaid
erDiagram
    %% Users Module
    USERS {
        int id PK
        varchar names
        varchar lastnames
        varchar identification_type
        varchar identification_number
    }
    ATTRIBUTE_USER {
        int id PK
        int user_id FK
        varchar name_attribute
        boolean multiple
    }
    VALUE_ATTRIBUTE_USER {
        int id PK
        int attribute_id FK
        varchar value_attribute
    }

    %% Employees Module
    EMPLOYEES {
        int id PK
        varchar names
        varchar lastnames
        varchar identification_type
        varchar identification_number
        varchar password
        int rol_id FK
        varchar secret
    }
    ROL {
        int id PK
        varchar name
    }
    PERMISSION {
        int id PK
        int rol_id FK
        varchar method
        varchar endpoint
    }
    ATTRIBUTE_EMPLOYEE {
        int id PK
        int employee_id FK
        varchar name_attribute
        boolean multiple
    }
    VALUE_ATTRIBUTE_EMPLOYEE {
        int id PK
        int attribute_id FK
        varchar value_attribute
    }

    %% Gateway Module
    SESSION {
        int id PK
        int user_id
        varchar token
        varchar ip_address
        varchar useragent
        varchar created_at
        varchar expiration
    }
    TRACKING {
        bigint id PK
        timestamp created_at
        bigint employee_id
        varchar action
        text data
        text result
    }

    %% Schedule Module
    SCHEDULE {
        bigint id PK
        bigint employee_id FK
        bigint user_id FK
        timestamp start_at
        timestamp end_at
        text details
        varchar headquarters
        varchar office
        boolean in_person
        boolean group_session
        timestamp created_at
        timestamp updated_at
    }

    %% Relationships
    USERS ||--o{ ATTRIBUTE_USER : "has"
    ATTRIBUTE_USER ||--o{ VALUE_ATTRIBUTE_USER : "has values"
    
    EMPLOYEES ||--o{ ATTRIBUTE_EMPLOYEE : "has"
    ATTRIBUTE_EMPLOYEE ||--o{ VALUE_ATTRIBUTE_EMPLOYEE : "has values"
    
    ROL ||--o{ EMPLOYEES : "assigned to"
    ROL ||--o{ PERMISSION : "has"
    
    EMPLOYEES ||--o{ SCHEDULE : "manages"
    USERS ||--o{ SCHEDULE : "attends"
    
    %% Logical Relationships (Cross-Module)
    EMPLOYEES ||--o{ TRACKING : "generates"
    EMPLOYEES ||--o{ SESSION : "authenticates"
```

## Detalles del Modelo

### Módulo de Usuarios (Users)
- **USERS**: Almacena la información básica de los pacientes/usuarios.
- **ATTRIBUTE_USER / VALUE_ATTRIBUTE_USER**: Sistema flexible para agregar atributos dinámicos a los usuarios.

### Módulo de Empleados (Employees)
- **EMPLOYEES**: Personal médico y administrativo.
- **ROL / PERMISSION**: Sistema RBAC (Role-Based Access Control) para gestionar permisos sobre endpoints.
- **ATTRIBUTE_EMPLOYEE / VALUE_ATTRIBUTE_EMPLOYEE**: Atributos dinámicos para empleados.

### Módulo Gateway
- **SESSION**: Gestión de sesiones activas y tokens JWT.
- **TRACKING**: Auditoría de acciones realizadas por los empleados.

### Módulo de Agenda (Schedule)
- **SCHEDULE**: Citas médicas que vinculan a un empleado (médico) con un usuario (paciente).
