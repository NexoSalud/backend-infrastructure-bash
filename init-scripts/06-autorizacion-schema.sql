-- Schema for Autorización y Agendamiento module
-- Tablas para el módulo de Autorización y Agendamiento de órdenes médicas
-- Compatible con la base de datos compartida nexosalud

-- ============================================
-- ENUMs
-- ============================================
DO $$ BEGIN
    CREATE TYPE sexo_enum AS ENUM ('M', 'F', 'O');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- ============================================
-- Roles internos del módulo (no confundir con roles de empleados de nexo)
-- ============================================
CREATE TABLE IF NOT EXISTS autorizacion_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200)
);

-- ============================================
-- Usuarios internos del módulo
-- ============================================
CREATE TABLE IF NOT EXISTS autorizacion_usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- ============================================
-- Relación usuarios <-> roles
-- ============================================
CREATE TABLE IF NOT EXISTS autorizacion_user_roles (
    user_id UUID NOT NULL REFERENCES autorizacion_usuarios(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES autorizacion_roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

-- ============================================
-- Municipios (territorios que atienden las sedes)
-- ============================================
CREATE TABLE IF NOT EXISTS municipios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- ============================================
-- Sedes (centros de atención)
-- ============================================
CREATE TABLE IF NOT EXISTS sedes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL,
    hora_apertura TIME NOT NULL,
    hora_cierre TIME NOT NULL,
    capacidad_diaria INTEGER NOT NULL DEFAULT 150
);

-- ============================================
-- Relación sedes <-> municipios
-- ============================================
CREATE TABLE IF NOT EXISTS sede_municipios (
    sede_id UUID NOT NULL REFERENCES sedes(id) ON DELETE CASCADE,
    municipio_id UUID NOT NULL REFERENCES municipios(id) ON DELETE CASCADE,
    PRIMARY KEY (sede_id, municipio_id)
);

-- ============================================
-- Pacientes
-- ============================================
CREATE TABLE IF NOT EXISTS pacientes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tipo_documento VARCHAR(10) NOT NULL,
    numero_documento VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    sexo sexo_enum NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    fecha_nacimiento TIMESTAMP NOT NULL,
    convenio VARCHAR(100) NOT NULL,
    regimen VARCHAR(50) NOT NULL,
    municipio_id UUID REFERENCES municipios(id)
);

-- ============================================
-- Órdenes médicas (core del módulo)
-- ============================================
CREATE TABLE IF NOT EXISTS ordenes_medicas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero_orden VARCHAR(50) NOT NULL UNIQUE,
    paciente_id UUID NOT NULL REFERENCES pacientes(id),
    estudio VARCHAR(200) NOT NULL,

    -- Flujo de Autorización
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE'
        CHECK (estado IN ('PENDIENTE', 'AUTORIZADA', 'RECHAZADA')),
    autorizado_por VARCHAR(100),
    fecha_autorizacion TIMESTAMP,

    -- Flujo de Agendamiento
    sede_id UUID REFERENCES sedes(id),
    fecha_cita TIMESTAMP,

    -- Control Documental (PDF)
    documento_generado BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_generacion_pdf TIMESTAMP,
    ruta_pdf VARCHAR(255),

    CONSTRAINT uq_sede_fecha_cita UNIQUE (sede_id, fecha_cita),
    CONSTRAINT chk_autorizacion_valida CHECK (
        (estado = 'AUTORIZADA' AND autorizado_por IS NOT NULL) OR (estado != 'AUTORIZADA')
    )
);

-- ============================================
-- Índices
-- ============================================
CREATE INDEX IF NOT EXISTS idx_ordenes_estado ON ordenes_medicas(estado);
CREATE INDEX IF NOT EXISTS idx_ordenes_numero ON ordenes_medicas(numero_orden);
CREATE INDEX IF NOT EXISTS idx_ordenes_sede_fecha ON ordenes_medicas(sede_id, fecha_cita);
CREATE INDEX IF NOT EXISTS idx_ordenes_paciente ON ordenes_medicas(paciente_id);
CREATE INDEX IF NOT EXISTS idx_pacientes_documento ON pacientes(numero_documento);
CREATE INDEX IF NOT EXISTS idx_sedes_nombre ON sedes(nombre);
CREATE INDEX IF NOT EXISTS idx_municipios_nombre ON municipios(nombre);
CREATE INDEX IF NOT EXISTS idx_autorizacion_roles_nombre ON autorizacion_roles(nombre);
CREATE INDEX IF NOT EXISTS idx_autorizacion_usuarios_username ON autorizacion_usuarios(username);

-- ============================================
-- Seed data: Roles del módulo
-- ============================================
INSERT INTO autorizacion_roles (nombre, descripcion) VALUES
    ('ordenar_citas', 'Permite crear nuevas órdenes médicas'),
    ('agendar_citas', 'Permite agendar citas en el calendario'),
    ('super_usuario', 'Acceso total a la plataforma y gestión de usuarios')
ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- Seed data: Usuario admin por defecto
-- ============================================
-- Contraseña: admin123 (hash bcrypt)
INSERT INTO autorizacion_usuarios (id, username, nombre, hashed_password, activo)
SELECT gen_random_uuid(), 'admin', 'Administrador', '$2b$12$LJ3m4ys3Lk0TSwHkVtMEeOX5YF6L7YZ8p9Wq0RvN1xG2fD3g4h5i6', TRUE
WHERE NOT EXISTS (SELECT 1 FROM autorizacion_usuarios WHERE username = 'admin');
