-- Añade columnas de afiliación al esquema de recaudos
-- Idempotente: usa IF NOT EXISTS (Postgres >= 9.6+)
ALTER TABLE recaudos
  ADD COLUMN IF NOT EXISTS eps_id varchar(128),
  ADD COLUMN IF NOT EXISTS rol_afiliado varchar(64),
  ADD COLUMN IF NOT EXISTS categoria_ibc varchar(8);

-- Opcional: crear índice para consultas por paciente o por número de comprobante
CREATE INDEX IF NOT EXISTS idx_recaudos_patient_id ON recaudos (patient_id);
CREATE INDEX IF NOT EXISTS idx_recaudos_num_comprobante ON recaudos (numero_comprobante);
