-- Seed data para EBS Contract Management
-- Insertar perfiles base de Equipos Básicos de Salud

INSERT INTO perfiles (nombre, descripcion, honorario_referencia) VALUES
('MEDICO GENERAL', 'Médico general para atención primaria en EBS', 4500000),
('ENFERMERO(A) JEFE', 'Profesional de enfermería para coordinación EBS', 3500000),
('AUXILIAR DE ENFERMERIA', 'Auxiliar de enfermería para EBS', 2500000),
('ODONTOLOGO', 'Odontólogo general para EBS', 4200000),
('AUXILIAR ODONTOLOGIA', 'Auxiliar de odontología para EBS', 2300000),
('PROMOTOR SALUD', 'Promotor de salud para EBS', 2200000),
('PSICOLOGO', 'Psicólogo para EBS', 3800000),
('TRABAJADOR SOCIAL', 'Trabajador social para EBS', 3500000),
('NUTRICIONISTA', 'Nutricionista para EBS', 3500000),
('MEDICO ESPECIALISTA', 'Médico especialista para EBS', 6500000)
ON CONFLICT (nombre) DO NOTHING;

-- Insertar actividades para perfiles
-- Médico General
INSERT INTO actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar consulta médica general a los usuarios del programa', 1 FROM perfiles WHERE nombre = 'MEDICO GENERAL'
UNION ALL
SELECT id, 'Realizar diagnóstico y tratamiento de patologías prevalentes', 2 FROM perfiles WHERE nombre = 'MEDICO GENERAL'
UNION ALL
SELECT id, 'Ordenar exámenes de laboratorio y ayudas diagnósticas', 3 FROM perfiles WHERE nombre = 'MEDICO GENERAL'
UNION ALL
SELECT id, 'Remitir a especialistas cuando se requiera', 4 FROM perfiles WHERE nombre = 'MEDICO GENERAL'
UNION ALL
SELECT id, 'Diligenciar historia clínica y registros SIS', 5 FROM perfiles WHERE nombre = 'MEDICO GENERAL'
ON CONFLICT DO NOTHING;

-- Enfermero(a) Jefe
INSERT INTO actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar valoración de enfermería a los usuarios', 1 FROM perfiles WHERE nombre = 'ENFERMERO(A) JEFE'
UNION ALL
SELECT id, 'Aplicar vacunas según el esquema nacional', 2 FROM perfiles WHERE nombre = 'ENFERMERO(A) JEFE'
UNION ALL
SELECT id, 'Realizar curación y procedimientos de enfermería', 3 FROM perfiles WHERE nombre = 'ENFERMERO(A) JEFE'
UNION ALL
SELECT id, 'Coordinar actividades del equipo EBS', 4 FROM perfiles WHERE nombre = 'ENFERMERO(A) JEFE'
UNION ALL
SELECT id, 'Llevar registro de actividades del programa', 5 FROM perfiles WHERE nombre = 'ENFERMERO(A) JEFE'
ON CONFLICT DO NOTHING;

-- Insertar plantillas de observaciones
INSERT INTO plantillas_observaciones (titulo, contenido) VALUES
('CUMPLIMIENTO TOTAL (SIN DESCUENTO)',
 'Se realizó la verificación del cumplimiento de las obligaciones contractuales durante el periodo objeto de supervisión, encontrando que las actividades fueron ejecutadas en su totalidad, con la calidad y oportunidad requerida. En consecuencia NO SE APLICA DESCUENTO alguno al valor del informe presentado, dejándose constancia del cumplimiento total de las obligaciones a cargo del contratista.'),
('CUMPLIMIENTO PARCIAL (CON DESCUENTO)',
 'Se realizó la verificación del cumplimiento de las obligaciones contractuales durante el periodo objeto de supervisión, encontrando que NO fueron ejecutadas la totalidad de las actividades programadas. Se relacionan a continuación las actividades NO ejecutadas y/o novedades presentadas:\n\n-\n-\n\nPor lo anterior, SE APLICA DESCUENTO por valor de $_________, equivalentes al ___% del valor del informe, de conformidad con lo establecido en el numeral ___ de la cláusula ___ del contrato.'),
('RECUPERACIÓN DE DESCUENTO',
  'Se realizó la verificación del cumplimiento de las obligaciones contractuales, encontrando que el contratista ha recuperado las actividades que dieron lugar al descuento aplicado en el periodo anterior, por lo cual se deja constancia del cumplimiento de las actividades objeto de recuperación.')
ON CONFLICT (titulo) DO NOTHING;
