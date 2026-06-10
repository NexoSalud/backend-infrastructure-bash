-- Flyway undo U3: rollback de V3 - elimina las columnas de afiliación de `recaudos`
-- NOTA: Flyway Community no ejecuta scripts U* por defecto. Ejecuta manualmente si tu entorno los soporta.
ALTER TABLE recaudos
  DROP COLUMN IF EXISTS eps_id,
  DROP COLUMN IF EXISTS rol_afiliado,
  DROP COLUMN IF EXISTS categoria_ibc;

DROP INDEX IF EXISTS idx_recaudos_patient_id;
DROP INDEX IF EXISTS idx_recaudos_num_comprobante;
