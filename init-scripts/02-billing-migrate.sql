-- ============================================================
-- MIGRACIÓN IDEMPOTENTE — MÓDULO BILLING/RECAUDO
-- Se ejecuta una vez al desplegar. Segura de re-ejecutar.
-- ============================================================

-- ── 1. cuotas_moderadoras: estructura completa ───────────────────────────────
CREATE TABLE IF NOT EXISTS cuotas_moderadoras (
    id             SERIAL PRIMARY KEY,
    regimen        VARCHAR(30) NOT NULL,
    categoria      VARCHAR(10) NOT NULL,
    tipo_servicio  VARCHAR(60) NOT NULL,
    valor_uvb      NUMERIC(10,4),
    valor_pesos    NUMERIC(18,2) NOT NULL DEFAULT 0,
    vigencia_desde DATE NOT NULL,
    vigencia_hasta DATE,
    activo         BOOLEAN NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Renombrar columna 'valor' → 'valor_pesos' si todavía tiene el nombre viejo
DO $$ BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name='cuotas_moderadoras' AND column_name='valor'
  ) THEN
    ALTER TABLE cuotas_moderadoras RENAME COLUMN valor TO valor_pesos;
  END IF;
END $$;

ALTER TABLE cuotas_moderadoras ADD COLUMN IF NOT EXISTS valor_uvb NUMERIC(10,4);

-- Constraint único (idempotente)
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'uq_cuota_mod'
  ) THEN
    ALTER TABLE cuotas_moderadoras
      ADD CONSTRAINT uq_cuota_mod UNIQUE (regimen, categoria, tipo_servicio, vigencia_desde);
  END IF;
END $$;

-- Poblar valor_uvb donde falte
UPDATE cuotas_moderadoras
SET valor_uvb = ROUND(valor_pesos / 42412.0, 4)
WHERE valor_uvb IS NULL;

-- Seed valores 2026 (ON CONFLICT no hace nada si ya existen)
INSERT INTO cuotas_moderadoras (regimen, categoria, tipo_servicio, valor_uvb, valor_pesos, vigencia_desde) VALUES
('CONTRIBUTIVO','A','CONSULTA_MEDICA_GENERAL',    0.1000,  4241, '2026-01-01'),
('CONTRIBUTIVO','A','CONSULTA_ESPECIALISTA',       0.1700,  7210, '2026-01-01'),
('CONTRIBUTIVO','A','URGENCIAS',                   0.5700, 24175, '2026-01-01'),
('CONTRIBUTIVO','A','LABORATORIO',                 0.1000,  4241, '2026-01-01'),
('CONTRIBUTIVO','A','IMAGEN_DIAGNOSTICA',          0.1700,  7210, '2026-01-01'),
('CONTRIBUTIVO','A','PROCEDIMIENTO_AMBULATORIO',   0.1700,  7210, '2026-01-01'),
('CONTRIBUTIVO','B','CONSULTA_MEDICA_GENERAL',     0.1700,  7210, '2026-01-01'),
('CONTRIBUTIVO','B','CONSULTA_ESPECIALISTA',       0.2950, 12511, '2026-01-01'),
('CONTRIBUTIVO','B','URGENCIAS',                   0.8560, 36305, '2026-01-01'),
('CONTRIBUTIVO','B','LABORATORIO',                 0.1700,  7210, '2026-01-01'),
('CONTRIBUTIVO','B','IMAGEN_DIAGNOSTICA',          0.2950, 12511, '2026-01-01'),
('CONTRIBUTIVO','B','PROCEDIMIENTO_AMBULATORIO',   0.2950, 12511, '2026-01-01'),
('CONTRIBUTIVO','C','CONSULTA_MEDICA_GENERAL',     0.2950, 12511, '2026-01-01'),
('CONTRIBUTIVO','C','CONSULTA_ESPECIALISTA',       0.5710, 24217, '2026-01-01'),
('CONTRIBUTIVO','C','URGENCIAS',                   1.4270, 60522, '2026-01-01'),
('CONTRIBUTIVO','C','LABORATORIO',                 0.2950, 12511, '2026-01-01'),
('CONTRIBUTIVO','C','IMAGEN_DIAGNOSTICA',          0.5710, 24217, '2026-01-01'),
('CONTRIBUTIVO','C','PROCEDIMIENTO_AMBULATORIO',   0.5710, 24217, '2026-01-01'),
('SUBSIDIADO',  'A','CONSULTA_MEDICA_GENERAL',     0.0000,     0, '2026-01-01'),
('SUBSIDIADO',  'A','CONSULTA_ESPECIALISTA',       0.0000,     0, '2026-01-01'),
('SUBSIDIADO',  'B','CONSULTA_MEDICA_GENERAL',     0.0500,  2121, '2026-01-01'),
('SUBSIDIADO',  'B','CONSULTA_ESPECIALISTA',       0.1000,  4241, '2026-01-01'),
('SUBSIDIADO',  'C','CONSULTA_MEDICA_GENERAL',     0.1000,  4241, '2026-01-01'),
('SUBSIDIADO',  'C','CONSULTA_ESPECIALISTA',       0.1700,  7210, '2026-01-01')
ON CONFLICT ON CONSTRAINT uq_cuota_mod DO NOTHING;

-- ── 2. topes_copago ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS topes_copago (
    id             SERIAL PRIMARY KEY,
    categoria      VARCHAR(10) NOT NULL,
    tipo_tope      VARCHAR(20) NOT NULL,
    valor_uvb      NUMERIC(10,4) NOT NULL DEFAULT 0,
    valor_pesos    NUMERIC(18,2) NOT NULL,
    vigencia_desde DATE NOT NULL,
    vigencia_hasta DATE,
    activo         BOOLEAN NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_tope_copago UNIQUE (categoria, tipo_tope, vigencia_desde)
);
INSERT INTO topes_copago (categoria, tipo_tope, valor_uvb, valor_pesos, vigencia_desde) VALUES
('A','POR_EVENTO', 2.3000,   97548, '2026-01-01'),
('A','ANUAL',     23.0000,  975476, '2026-01-01'),
('B','POR_EVENTO', 4.6000,  195095, '2026-01-01'),
('B','ANUAL',     46.0000, 1950952, '2026-01-01'),
('C','POR_EVENTO', 9.2000,  390190, '2026-01-01'),
('C','ANUAL',     92.0000, 3901904, '2026-01-01')
ON CONFLICT ON CONSTRAINT uq_tope_copago DO NOTHING;

-- ── 3. uvb_vigente ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS uvb_vigente (
    id             SERIAL PRIMARY KEY,
    valor_pesos    NUMERIC(18,2) NOT NULL,
    vigencia_desde DATE NOT NULL,
    vigencia_hasta DATE,
    resolucion     VARCHAR(100),
    activo         BOOLEAN NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO uvb_vigente (valor_pesos, vigencia_desde, vigencia_hasta, resolucion, activo) VALUES
(42412, '2026-01-01', NULL,          'Resolución 3488/2025 - Hacienda', TRUE),
(39200, '2025-01-01', '2025-12-31', 'Resolución anterior 2025',        FALSE)
ON CONFLICT DO NOTHING;

-- ── 4. exenciones_recaudo ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS exenciones_recaudo (
    id              SERIAL PRIMARY KEY,
    codigo          VARCHAR(30) NOT NULL UNIQUE,
    descripcion     VARCHAR(255) NOT NULL,
    fuente_marcador VARCHAR(100) NOT NULL,
    aplica_regimen  VARCHAR(30),
    activo          BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO exenciones_recaudo (codigo, descripcion, fuente_marcador, aplica_regimen) VALUES
('PYD',           'Protección Específica y Detección Temprana',       'es_pyd en Contrato A',         NULL),
('PARTO',         'Atención del parto y control prenatal',            'marcador_clinico HC',          NULL),
('ALTO_COSTO',    'Enfermedades de alto costo / catastróficas',       'perfil_paciente auditoria',    NULL),
('VICTIMA',       'Víctimas del conflicto armado',                    'marcador_poblacional paciente',NULL),
('PROMO_PREV',    'Programas de promoción y prevención / crónicos',   'marcador_programa CE',         NULL),
('MENOR',         'Menor de edad según Decreto 1652/2022',            'fecha_nacimiento paciente',    NULL),
('GESTANTE',      'Gestante',                                         'marcador_clinico HC',          NULL),
('SUBSIDIADO_A',  'Régimen subsidiado nivel A exento por norma',      'regimen + categoria paciente', 'SUBSIDIADO'),
('URGENCIA_VITAL','Urgencia vital — prohibición Ley 1751/2015',       'tipo_servicio = urgencia',     NULL)
ON CONFLICT (codigo) DO NOTHING;

-- ── 5. acumulado_copago_anual ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS acumulado_copago_anual (
    id           SERIAL PRIMARY KEY,
    patient_id   BIGINT NOT NULL,
    anio         INTEGER NOT NULL,
    total_copago NUMERIC(18,2) NOT NULL DEFAULT 0,
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_acumulado UNIQUE (patient_id, anio)
);
CREATE INDEX IF NOT EXISTS idx_acumulado_patient_anio ON acumulado_copago_anual(patient_id, anio);

-- ── 6. contrato_b_outbox ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS contrato_b_outbox (
    id              SERIAL PRIMARY KEY,
    evento_id       UUID NOT NULL UNIQUE,
    episodio_id     VARCHAR(50),
    recaudo_id      BIGINT NOT NULL,
    payload         JSONB NOT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    intentos        INTEGER NOT NULL DEFAULT 0,
    proximo_intento TIMESTAMP,
    enviado_at      TIMESTAMP,
    error_mensaje   TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_outbox_status  ON contrato_b_outbox(status, proximo_intento);
CREATE INDEX IF NOT EXISTS idx_outbox_evento  ON contrato_b_outbox(evento_id);
CREATE INDEX IF NOT EXISTS idx_outbox_episodio ON contrato_b_outbox(episodio_id);

-- ── 7. cups_tarifas ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS cups_tarifas (
    id              SERIAL PRIMARY KEY,
    cups_code       VARCHAR(10) NOT NULL UNIQUE,
    descripcion     VARCHAR(500) NOT NULL,
    grupo           VARCHAR(100),
    subgrupo        VARCHAR(100),
    tarifa_iss_2001 NUMERIC(18,2) NOT NULL DEFAULT 0,
    tarifa_soat     NUMERIC(18,2),
    unidad_medida   VARCHAR(50),
    es_pyd          BOOLEAN NOT NULL DEFAULT FALSE,
    activo          BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE cups_tarifas ADD COLUMN IF NOT EXISTS es_pyd BOOLEAN NOT NULL DEFAULT FALSE;
CREATE INDEX IF NOT EXISTS idx_cups_code        ON cups_tarifas(cups_code);
CREATE INDEX IF NOT EXISTS idx_cups_descripcion ON cups_tarifas(descripcion);

-- ── 8. medical_orders: columnas faltantes ───────────────────────────────────
CREATE TABLE IF NOT EXISTS medical_orders (
    id               SERIAL PRIMARY KEY,
    patient_id       BIGINT NOT NULL,
    professional_id  BIGINT NOT NULL,
    appointment_id   BIGINT,
    episodio_id      VARCHAR(50),
    cups_code        VARCHAR(10) NOT NULL,
    cups_description VARCHAR(500) NOT NULL,
    service_type     VARCHAR(30) NOT NULL,
    ambito           VARCHAR(30) NOT NULL DEFAULT 'AMBULATORIO',
    base_tariff      NUMERIC(18,2) NOT NULL DEFAULT 0,
    iss_multiplier   NUMERIC(5,2) NOT NULL DEFAULT 1.0,
    es_pyd           BOOLEAN NOT NULL DEFAULT FALSE,
    status           VARCHAR(30) NOT NULL DEFAULT 'PENDIENTE_RECAUDO',
    order_date       DATE NOT NULL,
    order_notes      TEXT,
    diagnosis_code   VARCHAR(10),
    diagnosis_desc   VARCHAR(500),
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE medical_orders ADD COLUMN IF NOT EXISTS episodio_id     VARCHAR(50);
ALTER TABLE medical_orders ADD COLUMN IF NOT EXISTS appointment_id  BIGINT;
ALTER TABLE medical_orders ADD COLUMN IF NOT EXISTS es_pyd          BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE medical_orders ADD COLUMN IF NOT EXISTS diagnosis_code  VARCHAR(10);
ALTER TABLE medical_orders ADD COLUMN IF NOT EXISTS diagnosis_desc  VARCHAR(500);
ALTER TABLE medical_orders ADD COLUMN IF NOT EXISTS order_notes     TEXT;
CREATE INDEX IF NOT EXISTS idx_medical_orders_patient     ON medical_orders(patient_id, status);
CREATE INDEX IF NOT EXISTS idx_medical_orders_status      ON medical_orders(status);
CREATE INDEX IF NOT EXISTS idx_medical_orders_appointment ON medical_orders(appointment_id);
CREATE INDEX IF NOT EXISTS idx_medical_orders_episodio    ON medical_orders(episodio_id);

-- ── 9. recaudos: columnas faltantes ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS recaudos (
    id                     SERIAL PRIMARY KEY,
    numero_comprobante     VARCHAR(30) NOT NULL UNIQUE,
    evento_id              UUID NOT NULL DEFAULT gen_random_uuid(),
    episodio_id            VARCHAR(50),
    corrige_comprobante_id VARCHAR(30),
    contrato_version       VARCHAR(10) NOT NULL DEFAULT '2.0',
    patient_id             BIGINT NOT NULL,
    cajero_id              BIGINT NOT NULL,
    sede_id                BIGINT,
    eps_id                 VARCHAR(50),
    eps_nombre             VARCHAR(255),
    regimen                VARCHAR(30),
    rol_afiliado           VARCHAR(20),
    categoria_ibc          VARCHAR(5),
    tipo_servicio          VARCHAR(30),
    numero_autorizacion    VARCHAR(50),
    es_pyd                 BOOLEAN NOT NULL DEFAULT FALSE,
    exencion_codigo        VARCHAR(30),
    tipo_cobro             VARCHAR(25),
    status                 VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    medio_pago             VARCHAR(20),
    valor_total            NUMERIC(18,2) NOT NULL DEFAULT 0,
    valor_recibido         NUMERIC(18,2),
    cambio                 NUMERIC(18,2),
    comprobante_inmutable  BOOLEAN NOT NULL DEFAULT TRUE,
    observaciones          TEXT,
    modificado_por         BIGINT,
    modificacion_motivo    TEXT,
    valor_original         NUMERIC(18,2),
    anulacion_motivo       TEXT,
    anulado_por            BIGINT,
    anulado_at             TIMESTAMP,
    confirmado_at          TIMESTAMP,
    fecha_atencion         DATE,
    fecha_emision_evento   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS evento_id             UUID DEFAULT gen_random_uuid();
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS episodio_id           VARCHAR(50);
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS corrige_comprobante_id VARCHAR(30);
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS contrato_version      VARCHAR(10) NOT NULL DEFAULT '2.0';
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS eps_id                VARCHAR(50);
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS rol_afiliado          VARCHAR(20);
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS categoria_ibc         VARCHAR(5);
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS tipo_servicio         VARCHAR(30);
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS numero_autorizacion   VARCHAR(50);
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS es_pyd                BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS exencion_codigo       VARCHAR(30);
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS tipo_cobro            VARCHAR(25);
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS comprobante_inmutable BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS modificado_por        BIGINT;
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS modificacion_motivo   TEXT;
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS valor_original        NUMERIC(18,2);
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS fecha_atencion        DATE;
ALTER TABLE recaudos ADD COLUMN IF NOT EXISTS fecha_emision_evento  TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
CREATE INDEX IF NOT EXISTS idx_recaudos_patient     ON recaudos(patient_id);
CREATE INDEX IF NOT EXISTS idx_recaudos_status      ON recaudos(status);
CREATE INDEX IF NOT EXISTS idx_recaudos_episodio    ON recaudos(episodio_id);
CREATE INDEX IF NOT EXISTS idx_recaudos_evento      ON recaudos(evento_id);

-- ── 10. recaudo_items: columnas faltantes ───────────────────────────────────
CREATE TABLE IF NOT EXISTS recaudo_items (
    id                   SERIAL PRIMARY KEY,
    recaudo_id           BIGINT NOT NULL REFERENCES recaudos(id) ON DELETE CASCADE,
    medical_order_id     BIGINT,
    appointment_id       BIGINT,
    cups_code            VARCHAR(10) NOT NULL,
    cups_description     VARCHAR(500) NOT NULL,
    service_type         VARCHAR(30) NOT NULL,
    ambito               VARCHAR(30) NOT NULL DEFAULT 'AMBULATORIO',
    professional_id      BIGINT,
    professional_name    VARCHAR(255),
    service_date         DATE NOT NULL,
    base_tariff          NUMERIC(18,2) NOT NULL DEFAULT 0,
    descuento_convenio   NUMERIC(18,2) NOT NULL DEFAULT 0,
    cuota_moderadora     NUMERIC(18,2) NOT NULL DEFAULT 0,
    copago               NUMERIC(18,2) NOT NULL DEFAULT 0,
    tope_evento_aplicado BOOLEAN NOT NULL DEFAULT FALSE,
    tope_anual_aplicado  BOOLEAN NOT NULL DEFAULT FALSE,
    valor_cobrado        NUMERIC(18,2) NOT NULL DEFAULT 0,
    exento               BOOLEAN NOT NULL DEFAULT FALSE,
    exencion_codigo      VARCHAR(30),
    created_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE recaudo_items ADD COLUMN IF NOT EXISTS tope_evento_aplicado BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE recaudo_items ADD COLUMN IF NOT EXISTS tope_anual_aplicado  BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE recaudo_items ADD COLUMN IF NOT EXISTS exencion_codigo      VARCHAR(30);
CREATE INDEX IF NOT EXISTS idx_recaudo_items_recaudo ON recaudo_items(recaudo_id);
CREATE INDEX IF NOT EXISTS idx_recaudo_items_order   ON recaudo_items(medical_order_id);

-- ── 11. Secuencia comprobantes ───────────────────────────────────────────────
CREATE SEQUENCE IF NOT EXISTS recaudo_seq START 1 INCREMENT 1;

-- ── 12. Backfill: crear orden pendiente para citas sin orden en billing ──────
INSERT INTO medical_orders (
    patient_id, professional_id, appointment_id,
    cups_code, cups_description, service_type, ambito,
    base_tariff, iss_multiplier, es_pyd,
    status, order_date, created_at, updated_at
)
SELECT
    a.patient_id,
    a.professional_id,
    a.id,
    '890201',
    CASE a.functionality
        WHEN 'CONSULTA_PRIMERA_VEZ' THEN 'Consulta de primera vez por medicina general'
        WHEN 'CONSULTA_CONTROL'     THEN 'Consulta de control'
        WHEN 'PROCEDIMIENTO'        THEN 'Procedimiento ambulatorio'
        ELSE 'Consulta Médica'
    END,
    'CONSULTA',
    'AMBULATORIO',
    0, 1.0, FALSE,
    'PENDIENTE_RECAUDO',
    a.date::date,
    NOW(), NOW()
FROM appointments a
WHERE a.status NOT IN ('CANCELADA', 'ATENDIDA', 'ANULADA')
  AND NOT EXISTS (
      SELECT 1 FROM medical_orders mo WHERE mo.appointment_id = a.id
  );

SELECT 'Migración billing completada' AS resultado,
       (SELECT COUNT(*) FROM medical_orders WHERE status = 'PENDIENTE_RECAUDO') AS ordenes_pendientes;
