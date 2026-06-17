-- ============================================================================
-- Plantilla de Permisos para el Módulo EBS (Gestión de Contratos)
-- ============================================================================
-- Tabla: permission (compartida con el módulo employees)
--   id        SERIAL PRIMARY KEY
--   rol_id    INTEGER NOT NULL REFERENCES rol(id)
--   method    VARCHAR (GET, POST, PUT, DELETE, PATCH)
--   endpoint  VARCHAR (ruta de la API)
--
-- Roles existentes (creados por EmployeeInitializer):
--   id=1  ADMIN     (asistencial=false)
--   id=2  DOCTOR    (asistencial=true)
-- ============================================================================

-- 1. PERMISOS PARA ADMIN (rol_id=1) — Acceso completo a todo EBS
INSERT INTO permission (rol_id, method, endpoint) VALUES
-- Dashboard y listados
(1, 'GET',    '/api/v1/ebs'),
(1, 'GET',    '/api/v1/ebs/contratos'),
(1, 'GET',    '/api/v1/ebs/contratistas'),

-- CRUD Contratos
(1, 'POST',   '/api/v1/ebs/contratos'),
(1, 'PUT',    '/api/v1/ebs/contratos'),
(1, 'DELETE', '/api/v1/ebs/contratos'),
(1, 'PATCH',  '/api/v1/ebs/contratos'),

-- CRUD Contratistas
(1, 'POST',   '/api/v1/ebs/contratistas'),
(1, 'PUT',    '/api/v1/ebs/contratistas'),
(1, 'DELETE', '/api/v1/ebs/contratistas'),
(1, 'PATCH',  '/api/v1/ebs/contratistas'),

-- CRUD Pagos / Supervisiones
(1, 'GET',    '/api/v1/ebs/pagos'),
(1, 'POST',   '/api/v1/ebs/pagos'),
(1, 'PUT',    '/api/v1/ebs/pagos'),
(1, 'DELETE', '/api/v1/ebs/pagos'),
(1, 'PATCH',  '/api/v1/ebs/pagos'),

-- CRUD Perfiles y Actividades
(1, 'GET',    '/api/v1/ebs/perfiles'),
(1, 'POST',   '/api/v1/ebs/perfiles'),
(1, 'PUT',    '/api/v1/ebs/perfiles'),
(1, 'DELETE', '/api/v1/ebs/perfiles'),
(1, 'PATCH',  '/api/v1/ebs/perfiles'),

-- CRUD Plantillas de Observaciones
(1, 'GET',    '/api/v1/ebs/plantillas'),
(1, 'POST',   '/api/v1/ebs/plantillas'),
(1, 'PUT',    '/api/v1/ebs/plantillas'),
(1, 'DELETE', '/api/v1/ebs/plantillas'),
(1, 'PATCH',  '/api/v1/ebs/plantillas'),

-- Exportación e Importación
(1, 'GET',    '/api/v1/ebs/exportar-excel'),
(1, 'POST',   '/api/v1/ebs/importar-csv'),

-- PDF
(1, 'GET',    '/api/v1/ebs/contratos/{numeroContrato}/pdf'),

-- Estado del contrato (archivar/restaurar)
(1, 'POST',   '/api/v1/ebs/contratos/{numeroContrato}/estado')

ON CONFLICT DO NOTHING;

-- 2. PERMISOS PARA DOCTOR / USUARIO ASISTENCIAL (rol_id=2) — Solo lectura
INSERT INTO permission (rol_id, method, endpoint) VALUES
(2, 'GET',    '/api/v1/ebs'),
(2, 'GET',    '/api/v1/ebs/contratos'),
(2, 'GET',    '/api/v1/ebs/contratistas'),
(2, 'GET',    '/api/v1/ebs/pagos'),
(2, 'GET',    '/api/v1/ebs/perfiles'),
(2, 'GET',    '/api/v1/ebs/plantillas'),
(2, 'GET',    '/api/v1/ebs/exportar-excel'),
(2, 'GET',    '/api/v1/ebs/contratos/{numeroContrato}/pdf')

ON CONFLICT DO NOTHING;

-- 3. PERMISOS PARA NUEVO ROL: SUPERVISOR EBS (rol_id=3) — Gestión completa de contratos
-- Si se crea el rol SupervisorEBS con id=3:
-- INSERT INTO permission (rol_id, method, endpoint) VALUES
-- (3, 'GET',    '/api/v1/ebs'),
-- (3, 'GET',    '/api/v1/ebs/contratos'),
-- (3, 'POST',   '/api/v1/ebs/contratos'),
-- (3, 'PUT',    '/api/v1/ebs/contratos'),
-- (3, 'GET',    '/api/v1/ebs/contratistas'),
-- (3, 'GET',    '/api/v1/ebs/pagos'),
-- (3, 'POST',   '/api/v1/ebs/pagos'),
-- (3, 'PUT',    '/api/v1/ebs/pagos'),
-- (3, 'GET',    '/api/v1/ebs/perfiles'),
-- (3, 'GET',    '/api/v1/ebs/plantillas'),
-- (3, 'GET',    '/api/v1/ebs/exportar-excel'),
-- (3, 'GET',    '/api/v1/ebs/contratos/{numeroContrato}/pdf'),
-- (3, 'POST',   '/api/v1/ebs/contratos/{numeroContrato}/estado')
-- ON CONFLICT DO NOTHING;
