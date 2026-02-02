# Diagrama UML de Módulos Backend - Nexo Salud

Este diagrama representa la arquitectura de microservicios del backend, mostrando las interacciones entre el Gateway, los servicios internos y la base de datos.

```mermaid
graph TD
    subgraph "External Access"
        Client["Cliente (Web/Mobile)"]
    end

    subgraph "API Gateway (Port 8080)"
        Gateway["Gateway Service"]
        SessionCtrl["Session Controller"]
        GatewayCtrl["Gateway Controller (Proxy)"]
        JwtUtil["JwtUtil"]
        
        Gateway --> SessionCtrl
        Gateway --> GatewayCtrl
        SessionCtrl --> JwtUtil
    end

    subgraph "Internal Services"
        Employees["Employees Service (Port 8081)"]
        Users["Users Service (Port 8082)"]
        Schedule["Schedule Service (Port 8083)"]
    end

    subgraph "Persistence"
        DB[("PostgreSQL (Port 5432)\nDB: nexosalud")]
    end

    %% Client to Gateway
    Client -- "HTTP Requests" --> Gateway

    %% Gateway to Internal Services
    GatewayCtrl -- "Proxy /api/v1/employees" --> Employees
    GatewayCtrl -- "Proxy /api/v1/users" --> Users
    GatewayCtrl -- "Proxy /api/v1/schedule" --> Schedule

    %% Session Logic
    SessionCtrl -- "Auth Validation (if MOCK=false)" --> Employees
    
    %% Services to DB
    Employees -- "R2DBC" --> DB
    Users -- "R2DBC" --> DB
    Schedule -- "R2DBC" --> DB
    Gateway -- "Session Persistence" --> DB

    %% Styling
    classDef gateway fill:#f9f,stroke:#333,stroke-width:2px;
    classDef service fill:#bbf,stroke:#333,stroke-width:2px;
    classDef db fill:#dfd,stroke:#333,stroke-width:2px;
    
    class Gateway,SessionCtrl,GatewayCtrl gateway;
    class Employees,Users,Schedule service;
    class DB db;
```

## Detalles de Arquitectura

- **Gateway (8080)**: Punto de entrada único. Maneja la autenticación JWT y redirige las peticiones a los servicios correspondientes.
- **Employees Service (8081)**: Gestiona la información de los empleados y la autenticación real (si no está en modo mock).
- **Users Service (8082)**: Gestiona los usuarios finales del sistema.
- **Schedule Service (8083)**: Gestiona las agendas y citas médicas.
- **Base de Datos**: PostgreSQL compartida. Cada servicio utiliza su propio esquema o tablas dentro de la base de datos `nexosalud`.
- **Comunicación**: Basada en Spring WebFlux (Reactiva) utilizando `WebClient` para peticiones entre servicios y `R2DBC` para acceso a datos.
