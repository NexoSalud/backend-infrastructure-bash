**NexoSalud — Módulo de Pacientes**

# **Paso 1: Identificación del paciente — Documento de referencia**

*Consolida los tipos de afiliación y roles aplicables del SGSSS, las combinaciones posibles, la lógica de recaudo por régimen y el fundamento normativo de cada categoría. Documento de referencia funcional/normativa; no incluye especificación técnica de implementación.*

## **1\. Tipos de afiliación reconocidos**

En términos estrictamente normativos, el SGSSS reconoce tres tipos de afiliación: Contributivo, Subsidiado y Régimen de Excepción/Especial. SOAT, ARL, póliza y particular no son tipos de afiliación al SGSSS sino fuentes de pago o aseguramiento paralelo; se incluyen en el selector de identificación por conveniencia operativa, pero la lógica de rol, copago y cuota moderadora solo aplica a los tres regímenes del SGSSS.

## **2\. Matriz de combinaciones: Tipo de afiliación × Rol del afiliado**

| \# | Tipo de afiliación | Rol aplicable | ¿Copago? | ¿Cuota moderadora? | Notas |
| :---- | :---- | :---- | :---- | :---- | :---- |
| 1 | Contributivo | Cotizante | No | Sí | El cotizante nunca paga copago. |
| 2 | Contributivo | Beneficiario | Sí | Sí | Aplican ambos cobros. |
| 3 | Subsidiado | Cotizante | — | — | Combinación inválida: el subsidiado no tiene la calidad de cotizante (ver sección 4). |
| 4 | Subsidiado | Beneficiario (titular del subsidio / cabeza de familia) | Sí (según nivel) | No | Nivel I frecuentemente exento; exención poblacional anula el copago. |
| 5 | Régimen de excepción / especial | Cotizante | Según reglamento propio | Según reglamento propio | No siguen reglas del SGSSS; definido por entidad (ver sección 5). |
| 6 | Régimen de excepción / especial | Beneficiario | Según reglamento propio | Según reglamento propio | Igual que el anterior. |
| 7 | ARL | Trabajador afiliado | No | No | Cobertura 100% por accidente de trabajo / enfermedad laboral. |
| 8 | SOAT | N/A (víctima / lesionado) | No | No | Identificación por evento; paga la aseguradora hasta el tope. |
| 9 | Póliza / Plan voluntario | Tomador o beneficiario de la póliza | No (rige la póliza) | No | Cobertura y deducibles según el contrato. |
| 10 | Particular | N/A | No | No | Paga 100% tarifa plena. |
| 11 | Sin afiliación verificable | N/A | No determinable | No determinable | Ruta de verificación BDUA / urgencia; posible pagador alternativo. |

## **3\. Reglas transversales**

* El campo rol solo es semánticamente válido en Contributivo y Régimen de excepción/especial. En Subsidiado el afiliado es siempre titular del subsidio (cabeza de familia o beneficiario), no cotizante. En SOAT, ARL, Póliza, Particular y Sin afiliación, el rol no debe requerirse: marcar rol \= N/A explícito, nunca nulo.  
* Copago y cuota moderadora son mutuamente excluyentes por evento de uso: la cuota moderadora aplica a consulta externa, exámenes y medicamentos ambulatorios; el copago aplica a servicios distintos (hospitalización, cirugía, procedimientos). Se derivan del tipo de servicio más estos atributos, no se mezclan.  
* El estado de afiliación (activo / suspendido / novedad pendiente) es un eje independiente que cruza todas las filas. Suspendido conduce a ruta de pagador alternativo o validación; novedad pendiente, a bloqueo hasta resolver.  
* Los marcadores de exención poblacional anulan copago/cuota donde apliquen (Subsidiado y Contributivo): víctimas del conflicto, gestantes, menores en ciertas rutas y enfermedades de alto costo según normativa.

## **4\. Combinaciones de afiliación prohibidas**

El artículo 2.1.3.14 del Decreto 780 de 2016 establece que ninguna persona puede estar afiliada a los dos regímenes a la vez, ni inscrita en más de una EPS o EOC, ni ostentar simultáneamente dos calidades de afiliación. Estas son todas las combinaciones prohibidas:

| \# | Combinación prohibida (simultánea) | Razón |
| :---- | :---- | :---- |
| 1 | Régimen contributivo \+ régimen subsidiado | Nadie puede estar afiliado a los dos regímenes a la vez. |
| 2 | Inscripción en más de una EPS o EOC | Una sola entidad por persona. |
| 3 | Cotizante \+ beneficiario | No se pueden ostentar las dos calidades simultáneamente. |
| 4 | Cotizante \+ afiliado adicional | Calidades excluyentes entre sí. |
| 5 | Beneficiario \+ afiliado adicional | Calidades excluyentes entre sí. |
| 6 | Afiliado al régimen subsidiado \+ cotizante | Excluyente: subsidiado no cotiza al contributivo. |
| 7 | Afiliado al régimen subsidiado \+ beneficiario | Excluyente entre régimen y calidad del contributivo. |
| 8 | Afiliado al régimen subsidiado \+ afiliado adicional | Excluyente entre régimen y calidad del contributivo. |

*RC \= Régimen Contributivo · RS \= Régimen Subsidiado · EOC \= Entidad Obligada a Compensar.*

## **5\. Liquidación del recaudo por régimen**

La matriz de la sección 2 indica si el afiliado paga; esta sección define de dónde sale el valor y contra quién factura la IPS. Punto clave: la lógica de categoría A/B/C aplicable a Contributivo y Subsidiado NO aplica a los regímenes de excepción, que definen su propio mecanismo de cuotas (varios cobran $0 al afiliado en el punto de atención).

| Régimen | Concepto que se cobra al afiliado | Fuente del valor | Factura contra |
| :---- | :---- | :---- | :---- |
| Contributivo | Cuota moderadora y/o copago | Resolución MSPS anual (UVB) \+ categoría IBC A/B/C | EPS |
| Subsidiado | Copago (salvo exención) | Resolución MSPS anual \+ nivel Sisbén | EPS |
| Magisterio (FOMAG) | Ninguno ($0) | Sin copago ni cuota moderadora (Acuerdo 003 de 2024\) | FOMAG / Fiduprevisora (tarifario FOMAG) |
| FF.MM. / Policía (SSMP) | Cuota moderadora y/o pago compartido (solo beneficiarios) | Decreto 1795/2000 art. 45 \+ acuerdo CSSMP vigente | Sanidad Militar / Sanidad Policial |
| Ecopetrol | Según reglamento interno | Acuerdo del Comité de Salud de Ecopetrol | Ecopetrol / su administradora |
| Universidades (Ley 647/2001) | Según reglamento interno | Reglamento de cada universidad | La universidad |

*Nota de vigencia: las tarifas y cuotas exactas de Ecopetrol y de las universidades no están en una norma pública única; se fijan por acuerdo interno de cada entidad y se materializan en el contrato IPS–entidad pagadora. El valor debe provenir del contrato cargado, no de un dato fijo. Conviene confirmar con la IPS cuáles de estos regímenes atiende realmente.*

## **5.1 Cuota de recuperación en el régimen especial de Fuerzas Militares y Policía (SSMP)**

El SSMP no aplica copago ni cuota moderadora del SGSSS. Su mecanismo propio, regulado por el Decreto 1795 de 2000 (arts. 43 a 45), distingue dos figuras que solo recaen sobre los beneficiarios; los afiliados (titulares cotizantes) no están sujetos a estos pagos por la atención. Los porcentajes los fija el CSSMP y el Decreto 1795 establece los siguientes valores base:

**a) Cuota moderadora — su finalidad es racionalizar el uso del servicio. Se calcula sobre el ingreso base de cotización del afiliado, en tres rangos:**

| Ingreso base de cotización del afiliado | Cuota moderadora (sobre 1 SMMLV) |
| :---- | :---- |
| Hasta 2 SMLMV | 0,2% |
| Mayor a 2 y hasta 5 SMLMV | 0,4% |
| Mayor a 5 SMLMV | 0,6% |

**b) Pagos compartidos (copago) — aporte adicional que ayuda a financiar el sistema. El aporte del beneficiario es del 5% del valor del servicio demandado, sujeto a los topes que defina el CSSMP.**

* Solo aplican a beneficiarios: los afiliados no sujetos al régimen de cotización (p. ej. alumnos de escuelas de formación, soldados) no tienen beneficiarios y no generan estos pagos.  
* La base de cálculo es el ingreso mensual, pensión o asignación de retiro del afiliado, no el IBC del SGSSS ni la categoría A/B/C.  
* Los valores son los del Decreto 1795/2000; el CSSMP puede actualizarlos por acuerdo, por lo que el monto definitivo debe tomarse del acuerdo CSSMP vigente o del contrato con Sanidad Militar / Sanidad Policial.

## **6\. Fundamento normativo**

| Categoría | Norma expresa |
| :---- | :---- |
| Contributivo / Subsidiado (existencia) | Ley 100 de 1993, art. 157 |
| Roles: cotizante, beneficiario, cabeza de familia, afiliado adicional | Decreto 780 de 2016, arts. de definiciones (2.1.1.x) \+ Formulario Único de Afiliación y Registro de Novedades al SGSSS |
| Exclusividad de roles (combinaciones prohibidas) | Decreto 780 de 2016, art. 2.1.3.14 |
| Subsidiado (definición y contribución solidaria) | Decreto 616 de 2022 (sustituye el Título 5, Parte 1, Libro 2 del Decreto 780\) |
| Régimen de excepción / especial (lista taxativa) | Ley 100 de 1993, art. 279 \+ Ley 647 de 2001 (universidades) |
| No aplican reglas de núcleo/beneficiario del contributivo a excepción | Decreto 780 de 2016, arts. 2.1.3.6 y 2.1.3.7 (excluidos por el art. 279\) |
| Copagos y cuotas moderadoras (marco vigente) | Decreto 1652 de 2022 (adiciona Título 4, Parte 10, Libro 2 del Decreto 780; deroga el Acuerdo 260/2004 salvo arts. 8–11) |
| SSMP (Fuerzas Militares y Policía) | Ley 352 de 1997 \+ Decreto 1795 de 2000 |
| ARL (Riesgos Laborales) | Ley 1562 de 2012 \+ Decreto 1072 de 2015 |
