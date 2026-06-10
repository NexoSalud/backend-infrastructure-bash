-- Flyway migration V3: añade columnas de afiliación a la tabla `recaudos`
ALTER TABLE recaudos
  ADD COLUMN IF NOT EXISTS eps_id varchar(128),
  ADD COLUMN IF NOT EXISTS rol_afiliado varchar(64),
  ADD COLUMN IF NOT EXISTS categoria_ibc varchar(8);

CREATE INDEX IF NOT EXISTS idx_recaudos_patient_id ON recaudos (patient_id);
CREATE INDEX IF NOT EXISTS idx_recaudos_num_comprobante ON recaudos (numero_comprobante);
