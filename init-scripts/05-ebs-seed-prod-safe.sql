-- Migracion: Insertar perfiles, actividades y plantillas EBS desde catalogo original
-- Este script es seguro para produccion (usa INSERT ... ON CONFLICT DO NOTHING)

-- Insertar perfiles (solo si no existen)
INSERT INTO ebs_perfiles (nombre, descripcion, honorario_referencia)
SELECT 'MEDICINA', 'Profesional medico para atencion individual, familiar y comunitaria - Resolucion 3280 de 2018', 8000000
WHERE NOT EXISTS (SELECT 1 FROM ebs_perfiles WHERE nombre = 'MEDICINA');
INSERT INTO ebs_perfiles (nombre, descripcion, honorario_referencia)
SELECT 'ENFERMERIA', 'Profesional de enfermeria para implementacion del PICP con enfasis materno-perinatal', 6500000
WHERE NOT EXISTS (SELECT 1 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA');
INSERT INTO ebs_perfiles (nombre, descripcion, honorario_referencia)
SELECT 'PSICOLOGIA', 'Profesional de psicologia para intervenciones colectivas en salud mental y psicosocial', 4500000
WHERE NOT EXISTS (SELECT 1 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA');
INSERT INTO ebs_perfiles (nombre, descripcion, honorario_referencia)
SELECT 'SALUD ORAL', 'Higienista oral para actividades de promocion y mantenimiento de salud bucal', 3000000
WHERE NOT EXISTS (SELECT 1 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL');
INSERT INTO ebs_perfiles (nombre, descripcion, honorario_referencia)
SELECT 'GESTOR COMUNITARIO', 'Gestor comunitario como enlace entre el equipo de salud y las comunidades', 2800000
WHERE NOT EXISTS (SELECT 1 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO');
INSERT INTO ebs_perfiles (nombre, descripcion, honorario_referencia)
SELECT 'AUXILIAR VACUNACION', 'Auxiliar de enfermeria para Programa Ampliado de Inmunizaciones (PAI)', 2500000
WHERE NOT EXISTS (SELECT 1 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION');
INSERT INTO ebs_perfiles (nombre, descripcion, honorario_referencia)
SELECT 'AUXILIAR ENFERMERIA', 'Auxiliar de enfermeria para apoyo a la gestion de Equipos Basicos de Salud', 2500000
WHERE NOT EXISTS (SELECT 1 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA');

-- Insertar actividades por perfil (solo si no existen)
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar la identificación integral del riesgo individual, familiar y comunitario de la población adscrita al microterritorio asignado, considerando enfoques del PICP.', 1 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 1);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Ejecutar las atenciones individuales de promoción y mantenimiento de la salud, conforme a la Resolución 3280 de 2018 y lineamientos técnicos.', 2 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 2);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Aplicar las guías de práctica clínica, protocolos institucionales y lineamientos técnicos definidos por la E.S.E. NORTE 3.', 3 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 3);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar acciones de inducción a la demanda de servicios de salud, priorizando eventos de salud pública.', 4 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 4);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar, notificar y gestionar oportunamente los eventos de interés en salud pública.', 5 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 5);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar la canalización oportuna de las personas a los servicios de salud del nivel primario o red de prestación.', 6 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 6);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Hacer seguimiento efectivo al acceso y continuidad de las atenciones en salud dentro de la red.', 7 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 7);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Promover espacios de concertación y mediación intercultural cuando aplique.', 8 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 8);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Promover y gestionar la articulación intersectorial y transectorial de los servicios de salud, sociales y ambientales.', 9 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 9);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Socializar con las comunidades atendidas los resultados de la caracterización familiar y del entorno.', 10 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 10);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar la sistematización, registro y reporte de la información en los sistemas del Ministerio de Salud (PICP, canalización, seguimiento).', 11 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 11);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar potencialidades, factores protectores y riesgos en los entornos para priorizar intervenciones.', 12 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 12);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Concertar y programar acciones sectoriales e intersectoriales enfocadas en la ejecución del PICP.', 13 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 13);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Participar en acciones de trabajo colaborativo, capacitación, cuidado al cuidador y seguimiento a la gestión del equipo.', 14 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 14);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Implementar las intervenciones colectivas concertadas en el PICP que correspondan al perfil médico.', 15 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 15);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Gestionar la garantía de las atenciones individuales en promoción, mantenimiento, detección temprana, diagnóstico y tratamiento.', 16 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 16);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Activar y gestionar los mecanismos de referencia y contrarreferencia.', 17 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 17);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Hacer uso adecuado de las Tecnologías de la Información y las Comunicaciones (TIC).', 18 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 18);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Diligenciar diaria, completa y oportunamente los Registros Individuales de Prestación de Servicios de Salud (RIPS) con códigos CIE-10.', 19 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 19);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Diligenciar de forma objetiva, clara y pertinente la historia clínica electrónica.', 20 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 20);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cuando aplique, diligenciar la historia clínica física, garantizando legibilidad y completitud.', 21 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 21);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Educar a pacientes y familias sobre tratamientos, autocuidado y signos de alarma.', 22 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 22);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Hacer uso adecuado y responsable de los equipos, medicamentos, dispositivos e insumos.', 23 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 23);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir con las atenciones definidas para las familias beneficiarias según programación mensual.', 24 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 24);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir las normas de bioseguridad y seguridad del paciente.', 25 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 25);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Atender las orientaciones técnicas y de coordinación operativa del Coordinador EBS.', 26 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 26);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir con el plan de capacitaciones definido por la E.S.E. NORTE 3.', 27 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 27);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Registrar y validar las valoraciones médicas integrales acompañadas de educación en salud.', 28 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 28);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Contribuir al cumplimiento de las metas del programa con referencia al 100% de la población caracterizada.', 29 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 29);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Participar en reuniones de seguimiento y evaluación de coordinación EBS.', 31 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 31);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir las actividades asistenciales propias del ejercicio profesional como médico general.', 32 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 32);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Acreditar afiliación y presentar pago de aportes a Seguridad Social Integral mensual.', 33 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 33);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Remitir oportunamente informes, cronogramas, soportes físicos y magnéticos requeridos.', 34 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 34);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Radicar la cuenta de cobro o factura con soportes exigidos.', 35 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 35);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir obligaciones aplicables de la Resolución 518 de 2015.', 36 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 36);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Entregar soportes físicos y digitalizados de registros de atención y firmas.', 37 FROM ebs_perfiles WHERE nombre = 'MEDICINA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'MEDICINA') AND orden = 37);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Formular, implementar y realizar seguimiento al Plan Integral de Cuidado Primario (PICP) con énfasis materno-perinatal.', 1 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 1);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar y analizar los riesgos individuales, familiares y comunitarios.', 2 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 2);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Brindar orientación e información clara sobre la oferta de servicios de salud.', 3 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 3);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Promover la afiliación al Sistema General de Seguridad Social en Salud.', 4 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 4);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Inducir a la demanda de servicios de salud y notificar eventos de interés en salud pública.', 5 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 5);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar canalización oportuna a los servicios de nivel primario y red de prestación.', 6 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 6);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Hacer seguimiento al acceso efectivo y continuity de la atención.', 7 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 7);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Promover espacios de concertación y mediación intercultural.', 8 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 8);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Promover la articulación de los servicios de salud, sociales y ambientales.', 9 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 9);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Socializar los resultados de la caracterización con las comunidades.', 10 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 10);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Sistematizar, registrar y reportar la información en sistemas definidos por Minsalud.', 11 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 11);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar potencialidades y riesgos en entornos para priorizar intervenciones.', 12 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 12);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Concertar y programar acciones sectoriales e intersectoriales para ejecutar el PICP.', 13 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 13);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Programar y participar en trabajo colaborativo, capacitación y cuidado al cuidador.', 14 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 14);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Implementar intervenciones del PICP que correspondan al perfil de enfermería.', 15 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 15);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Gestionar la asistencia social requerida por personas y familias con necesidades.', 16 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 16);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Activar los mecanismos de referencia y contrarreferencia.', 17 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 17);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar y gestionar barreras de acceso (geográficas, culturales, económicas).', 18 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 18);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Diseñar y ejecutar estrategias de búsqueda activa y recuperación de inasistentes.', 19 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 19);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar registro oportuno y completo de las intervenciones de enfermería.', 20 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 20);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Establecer estrategias de comunicación accesible e incluyente.', 21 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 21);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar seguimiento y ajustes periódicos al PICP.', 22 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 22);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Revisar el avance de las acciones y metas del PICP y hacer ajustes.', 23 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 23);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar oportunidades de mejora continua en la implementación del PICP.', 24 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 24);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Monitorear el cumplimiento de metas de cobertura poblacional.', 25 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 25);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Programar y participar en reuniones de retroalimentación comunitaria.', 26 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 26);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Aplicar guías de promoción, Resolución 3280, RIAS y guías de eventos de interés.', 27 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 27);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Hacer uso adecuado de las TIC.', 28 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 28);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Diligenciar los RIPS utilizando los códigos CIE-10.', 29 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 29);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Diligenciar la historia clínica electrónica de manera clara, objetiva y completa.', 30 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 30);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Diligenciar la historia clínica física cuando aplique.', 31 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 31);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Hacer uso adecuado de equipos, medicamentos, dispositivos e insumos.', 32 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 32);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir con la programación mensual informando ajustes.', 33 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 33);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir con atenciones de familias en microterritorios asignados.', 34 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 34);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir normas de bioseguridad y seguridad del paciente.', 35 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 35);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Participar en las reuniones de seguimiento del EBS.', 36 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 36);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar registro y validación de valoraciones de enfermería respaldadas por educación.', 37 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 37);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Contribuir al cumplimiento de metas del 100% de la población caracterizada.', 38 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 38);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Contribuir a la operatividad y articulación del EBS.', 40 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 40);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir con los lineamientos de capacitación definidos.', 41 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 41);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Acreditar Seguridad Social, presentar informes de ejecución, atender requerimientos del supervisor, custodiar equipos, abstenerse de usar recursos institucionales a otros fines y garantizar confidencialidad de la historia clínica.', 42 FROM ebs_perfiles WHERE nombre = 'ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'ENFERMERIA') AND orden = 42);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Ejecutar intervenciones colectivas en salud mental y psicosocial (redes comunitarias, centros de escucha).', 1 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 1);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Participar en la formulación, implementación y seguimiento del PICP con intervenciones en salud mental.', 2 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 2);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar y analizar los riesgos psicosociales individuales, familiares y comunitarios.', 3 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 3);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Brindar orientación psicosocial e información clara sobre oferta de servicios en salud mental.', 4 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 4);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Inducir a la demanda de servicios de salud mental priorizando eventos de salud pública.', 5 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 5);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar canalización oportuna a los servicios de salud primaria en salud mental.', 6 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 6);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Hacer seguimiento al acceso efectivo y continuidad de la atención psicosocial.', 7 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 7);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Promover espacios de conciliación, mediación y abordaje intercultural.', 8 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 8);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Promover y gestionar la articulación intersectorial con servicios sociales y educativos.', 9 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 9);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Socializar con las comunidades los resultados de la caracterización psicosocial.', 10 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 10);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Sistematizar, registrar y reportar la información en los registros definidos.', 11 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 11);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar potencialidades, factores protectores y riesgos psicosociales del entorno.', 12 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 12);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Concertar y programar acciones sectoriales enfocadas en intervenciones psicosociales.', 13 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 13);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Programar y participar en acciones de trabajo colaborativo y cuidado al cuidador.', 14 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 14);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Implementar intervenciones colectivas psicosociales y gestionar atenciones individuales.', 15 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 15);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Gestionar la asistencia psicosocial requerida en articulación con el territorio.', 16 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 16);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Activar mecanismos de referencia y contrarreferencia en salud mental.', 17 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 17);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar y gestionar barreras de acceso a la atención psicosocial.', 18 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 18);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Diseñar estrategias de búsqueda activa y recuperación de personas en salud mental.', 19 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 19);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Participar en reuniones de análisis de casos y cuidado al cuidador del equipo.', 20 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 20);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Registrar oportuna y completamente la información de intervenciones psicosociales.', 21 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 21);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Establecer mecanismos de comunicación accesible e incluyente.', 22 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 22);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Utilizar adecuadamente las TIC.', 23 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 23);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Diligenciar los RIPS utilizando códigos CIE-10.', 24 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 24);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Diligenciar de manera clara y pertinente la historia clínica electrónica.', 25 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 25);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Diligenciar la historia clínica física cuando aplique.', 26 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 26);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Hacer uso adecuado de equipos, herramientas e insumos.', 27 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 27);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir con la programación informando ajustes.', 28 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 28);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir con atenciones de familias en microterritorios.', 29 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 29);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir con normas de bioseguridad.', 30 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 30);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Participar en reuniones de seguimiento de coordinación EBS.', 31 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 31);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Acatar lineamientos técnicos y operativos del Coordinador EBS.', 32 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 32);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar registro de valoraciones psicosociales respaldadas por educación en salud mental (Res 3280).', 33 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 33);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Contribuir al cumplimiento de metas 100%: Consulta psicología, aplicación tamizajes SPA, escala sobrecarga cuidador, atención a víctimas conflicto.', 34 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 34);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar un total de 500 atenciones individuales mensuales en el marco de Promoción y Mantenimiento.', 35 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 35);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Diligenciar tamizajes en software institucional y plantilla de Minsalud.', 36 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 36);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir con el plan de capacitaciones de Minsalud y E.S.E. NORTE 3.', 37 FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'PSICOLOGIA') AND orden = 37);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Ejecutar actividades de higiene oral y promoción de salud bucal (Resolución 3280).', 1 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 1);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Diligenciar de manera oportuna los RIPS con códigos CIE-10.', 2 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 2);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Registrar de forma clara la información en la historia clínica electrónica.', 3 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 3);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Diligenciar la historia clínica física cuando aplique.', 4 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 4);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Brindar orientación sobre oferta de servicios de salud oral.', 5 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 5);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar promoción de afiliación a Seguridad Social.', 6 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 6);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Canalizar a las personas hacia servicios de salud oral bajo orientación del odontólogo.', 7 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 7);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Desarrollar actividades de demanda inducida comunitaria en salud oral.', 8 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 8);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Ejecutar acciones de búsqueda activa y seguimiento de salud bucal.', 9 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 9);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar la implementación de intervenciones colectivas del PICP en salud oral.', 10 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 10);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Articular con servicios sociales acciones de apoyo para usuarios.', 11 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 11);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar riesgos en entornos para priorización de intervenciones orales.', 12 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 12);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar la logística de las actividades del EBS.', 13 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 13);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar seguimiento y ajuste de los PICP desde componente bucal.', 14 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 14);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Contribuir al cumplimiento de metas de cobertura.', 15 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 15);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Utilizar de manera adecuada las TIC.', 16 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 16);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir normas de bioseguridad en salud oral.', 17 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 17);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Participar en las reuniones de seguimiento y evaluación del EBS.', 18 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 18);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Aplicar lineamientos técnicos del odontólogo y Coordinador EBS.', 19 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 19);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Acreditar pago a Seguridad Social Integral.', 20 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 20);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Presentar oportunamente documentación para seguimiento contractual.', 21 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 21);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Radicar cuenta de cobro o factura en plazos establecidos.', 22 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 22);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Asistir a jornadas de capacitación de la E.S.E. o Minsalud.', 23 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 23);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Desarrollar actividades educativas comunitarias (charlas, talleres).', 25 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 25);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Brindar apoyo en atención inicial de urgencia odontológica y canalizar.', 26 FROM ebs_perfiles WHERE nombre = 'SALUD ORAL'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'SALUD ORAL') AND orden = 26);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Participar en la priorización de los microterritorios del municipio asignado.', 1 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 1);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar la elaboración de cartografía social de los microterritorios priorizados.', 2 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 2);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Actuar como enlace comunitario entre el Equipo de Salud Territorial (EST) y las comunidades.', 3 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 3);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar el relacionamiento inicial entre el EST y la comunidad, promoviendo confianza.', 4 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 4);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Contribuir al análisis de los determinantes sociales aportando información del contexto.', 5 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 5);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar tempranamente situaciones de riesgo a nivel individual y canalizar al equipo.', 6 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 6);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Fortalecer actividades de información y educación de la población hacia servicios de salud.', 7 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 7);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar el seguimiento familiar a las acciones definidas en el PICP.', 8 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 8);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Contribuir al diseño de estrategias de comunicación accesible e incluyente.', 9 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 9);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar el seguimiento y ajuste de los PICP de acuerdo con resultados comunitarios.', 10 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 10);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar la revisión del avance de metas establecidas en los PICP.', 11 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 11);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Contribuir al seguimiento de metas de cobertura en la población asignada.', 12 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 12);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Participar en las reuniones de retroalimentación comunitaria.', 13 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 13);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Gestionar asistencia social requerida por personas con necesidades, articulando con el territorio.', 14 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 14);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar potencialidades y riesgos en los entornos comunitarios.', 15 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 15);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar la programación, planeación y logística de actividades del componente comunitario.', 16 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 16);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Participar en reuniones de seguimiento y evaluación de coordinación EBS.', 17 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 17);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Ejecutar actividades propias del rol relacionadas con Atención Primaria en Salud.', 18 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 18);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Acreditar afiliación y pago de Seguridad Social Integral.', 19 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 19);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Remitir informes, cronogramas y documentos requeridos por la supervisión.', 20 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 20);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Radicar cuenta de cobro al finalizar la ejecución.', 21 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 21);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir con disposiciones de la Resolución 518 de 2015 en salud pública.', 22 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 22);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Entregar soportes físicos y digitales de registros de firmas y acciones.', 23 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 23);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Actuar conforme a lineamientos técnicos y operativos del programa EBS.', 24 FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'GESTOR COMUNITARIO') AND orden = 24);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Ejecutar actividades como Auxiliar de Enfermería según lineamientos del MIAS y APS.', 1 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 1);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar la identificación de riesgos y necesidades de la población asignada (Res 3280).', 2 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 2);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Registrar la información de identificación de riesgos en instrumentos de la E.S.E.', 3 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 3);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Promover la afiliación de la población a Seguridad Social en Salud.', 4 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 4);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar la canalización de usuarios hacia la red de prestación primaria.', 5 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 5);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Ejecutar acciones de demanda inducida comunitaria y búsqueda activa.', 6 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 6);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar la implementación de intervenciones del PICP a cargo del Equipo de Salud.', 7 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 7);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Articular con servicios sociales acciones de asistencia para personas con necesidades.', 8 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 8);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar riesgos en entornos para priorizar intervenciones.', 9 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 9);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar la logística de las salidas extramurales a los microterritorios.', 10 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 10);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar la planeación y desarrollo de actividades logísticas del EBS.', 11 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 11);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar el registro de intervenciones en los RIPS con códigos CIE-10.', 12 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 12);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar el seguimiento al diligenciamiento de historias clínicas y formatos.', 13 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 13);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Desarrollar actividades de educación para la salud dirigidas a la población.', 14 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 14);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Utilizar adecuadamente las TIC en actividades asistenciales y registro.', 15 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 15);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Custodiar, conservar y hacer uso adecuado de equipos e insumos.', 16 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 16);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Hacer uso responsable de medicamentos conforme a protocolos.', 17 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 17);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir con normas de bioseguridad del Manual de la E.S.E.', 18 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 18);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Participar en las jornadas de capacitación y actualización de Minsalud/E.S.E.', 19 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 19);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Presentar informes periódicos de actividades objetivas y verificables.', 20 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 20);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Acreditar pago de Seguridad Social Integral y presentar soportes.', 21 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 21);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Radicar cuenta de cobro de manera mensual con soportes requeridos.', 22 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 22);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar la identificación de riesgos aplicando instrumentos definidos por la E.S.E.', 23 FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR VACUNACION') AND orden = 23);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Ejecutar actividades propias de Auxiliar de Enfermería según lineamientos MIAS y APS.', 1 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 1);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Realizar la identificación de riesgos y necesidades de la población (Res 3280).', 2 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 2);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Registrar información derivada de la identificación de riesgos en instrumentos.', 3 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 3);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Promover la afiliación de la población a Seguridad Social en Salud.', 4 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 4);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar la canalización de usuarios hacia la red de nivel primario.', 5 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 5);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Ejecutar acciones de demanda inducida comunitaria, búsqueda activa y control.', 6 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 6);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar la implementación de intervenciones del PICP a cargo del EBS.', 7 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 7);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Articular con servicios sociales acciones dirigidas a personas con necesidades.', 8 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 8);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Identificar riesgos y potencialidades en los entornos sociosanitarios.', 9 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 9);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar logística de salidas extramurales a territorios y microterritorios.', 10 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 10);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar la planeación y desarrollo logístico de actividades del EBS.', 11 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 11);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar el registro de intervenciones en registros administrativos (RIPS).', 12 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 12);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar seguimiento al diligenciamiento de historias clínicas y formatos.', 13 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 13);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Desarrollar actividades de educación para la salud según contexto sociocultural.', 14 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 14);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Utilizar adecuadamente las TIC.', 15 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 15);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Custodiar equipos, herramientas, insumos y bienes entregados para ejecución.', 16 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 16);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Hacer uso responsable de medicamentos, dispositivos médicos e insumos.', 17 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 17);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir normas de bioseguridad según manual adoptado por E.S.E.', 18 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 18);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Participar en jornadas de capacitación de la E.S.E. o Ministerio de Salud.', 19 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 19);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Presentar informes periódicos de actividades objetivas y verificables.', 20 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 20);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Acreditar pago a Seguridad Social Integral.', 21 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 21);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Radicar cuenta de cobro mensual con soportes correspondientes.', 22 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 22);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Apoyar identificación de riesgos y necesidades mediante aplicación de instrumentos.', 23 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 23);
INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden)
SELECT id, 'Cumplir como mínimo con metas de identificación mensual: 210 formularios de familias o 483 personas caracterizadas.', 24 FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA'
AND NOT EXISTS (SELECT 1 FROM ebs_actividades_perfil WHERE perfil_id = (SELECT id FROM ebs_perfiles WHERE nombre = 'AUXILIAR ENFERMERIA') AND orden = 24);

-- Insertar plantillas de observaciones
INSERT INTO ebs_plantillas_observaciones (titulo, contenido)
SELECT 'CUMPLIMIENTO TOTAL (SIN DESCUENTO)', 'Una vez verificado el informe de actividades, los soportes allegados y demás evidencias presentadas por el CONTRATISTA, se constata el cumplimiento de las obligaciones contractuales correspondientes al periodo evaluado, conforme a lo establecido en el contrato. En consecuencia, desde la supervisión se conceptúa favorablemente el cumplimiento de las actividades desarrolladas y se autoriza el trámite de pago de la cuenta de cobro presentada, por encontrarse debidamente soportada. No obstante, se recomienda al CONTRATISTA mantener vigente su afiliación a las administradoras del Sistema General de Seguridad Social Integral, así como continuar efectuando de manera oportuna los aportes correspondientes, en cumplimiento de la normativa vigente aplicable y de las obligaciones contractuales asumidas, mínimo, mientras se encuentre vigente el contrato.'
WHERE NOT EXISTS (SELECT 1 FROM ebs_plantillas_observaciones WHERE titulo = 'CUMPLIMIENTO TOTAL (SIN DESCUENTO)');
INSERT INTO ebs_plantillas_observaciones (titulo, contenido)
SELECT 'CUMPLIMIENTO PARCIAL (CON DESCUENTO)', 'Verificado lo informes de actividades, los soportes allegados y demás evidencias presentadas por el CONTRATISTA, se evidencia un cumplimiento parcial de las obligaciones contractuales correspondientes al periodo evaluado, conforme a lo establecido en el contrato y en el plan de actividades aprobado. Se deja constancia de que no se ejecutó la totalidad de las actividades previstas, situación que se encuentra debidamente soportada en la verificación realizada por la supervisión. En consecuencia, y en aplicación del principio de pago contra prestación efectivamente ejecutada, así como de lo pactado en el contrato, la supervisión determina el reconocimiento y pago únicamente de las actividades efectivamente desarrolladas y soportadas, procediendo al ajuste del valor de la cuenta de cobro en proporción a dicho cumplimiento. Por lo anterior, se autoriza el trámite de pago por el valor ajustado, conforme a la verificación efectuada. Finalmente, se recomienda al CONTRATISTA mantener vigente su afiliación al Sistema General de Seguridad Social Integral y efectuar oportunamente los aportes correspondientes, en cumplimiento de la normativa vigente y de las obligaciones contractuales asumidas.'
WHERE NOT EXISTS (SELECT 1 FROM ebs_plantillas_observaciones WHERE titulo = 'CUMPLIMIENTO PARCIAL (CON DESCUENTO)');
INSERT INTO ebs_plantillas_observaciones (titulo, contenido)
SELECT 'RECUPERACION DE DESCUENTO', 'Verificado el informe de actividades, los soportes allegados y demás evidencias presentadas por el CONTRATISTA, se evidencia que durante el periodo evaluado se ejecutaron actividades adicionales y/o se subsanaron aquellas que dieron lugar a la aplicación de un descuento en periodos anteriores, dentro del mismo término de ejecución contractual. En ese sentido, la supervisión constata que las actividades previamente no reconocidas fueron efectivamente desarrolladas y debidamente soportadas, cumpliendo con las condiciones técnicas y contractuales exigidas. En consecuencia, y en aplicación del principio de reconocimiento de la prestación efectivamente ejecutada, se autoriza la recuperación del valor descontado, en proporción a las actividades verificadas, procediendo su inclusión en el trámite de pago correspondiente al presente periodo. Lo anterior se realiza sin que ello implique modificación de las condiciones contractuales, sino en garantía del equilibrio contractual y del pago justo por las actividades efectivamente ejecutadas y acreditadas.'
WHERE NOT EXISTS (SELECT 1 FROM ebs_plantillas_observaciones WHERE titulo = 'RECUPERACION DE DESCUENTO');

-- Migracion completa!