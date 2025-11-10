# Documento de Definición del Proceso - PDD
# Portafolio "Costo Amortizable"
**Junio 2025**

---

## HISTORIAL DE VERSIONES DEL DOCUMENTO

| Versión | Fecha | Descripción del Cambio | Responsable |
|---------|-------|------------------------|-------------|
| V1 | 30/06/2025 | Emisión | Jeimy Johana Lozano |

---

## TABLA DE CONTENIDO

1. [INTRODUCCIÓN](#1-introducción)
   - 1.1 Finalidad del documento
   - 1.2 Objetivos
   - 1.3 Contactos claves para el proceso
   - 1.4 Requisitos previos mínimos para la automatización
   - 1.5 Información general del proceso
2. [DESCRIPCIÓN ACTUAL DEL PROCESO](#2-descripción-actual-del-proceso)
   - 2.1 Diagrama AsIs
   - 2.2 Descripción del proceso
   - 2.3 Consideraciones generales del proceso
3. [DESCRIPCIÓN PROCESO AUTOMATIZADO](#3-descripción-proceso-automatizado)
   - 3.1 Objetivo de la automatización
   - 3.2 Ruta y Horario de entrega de insumos
   - 3.3 Diagrama ToBe
   - 3.4 Descripción de las actividades
   - 3.5 Notificaciones Generadas
   - 3.6 Horarios y tiempo de ejecución
   - 3.7 Indicadores (KPI's) asociados al proceso
4. [ANEXOS](#4-anexos)
5. [APROBACIÓN DEL DOCUMENTO](#5-aprobación-del-documento)

---

## 1. INTRODUCCIÓN

### 1.1 Finalidad del documento

El documento de definición describe el proceso de Costo Amortizable para su automatización mediante la tecnología robótica de procesos (Automatización robótica de Escritorio - RDA).

### 1.2 Objetivos

Automatizar el proceso de Costo Amortizable para que se generen estrategias tecnológicas que buscan:

- Optimizar la ocupación manual en las tareas repetitivas de estos procesos.
- Optimizar los tiempos de respuesta en la ejecución del proceso para hacerlo más eficiente y así tener mejor disponibilidad del robot.
- Reducir el riesgo de error por factores humanos.

### 1.3 Contactos claves para el proceso

| Rol | Nombres y Apellidos | Correo Electrónico |
|-----|---------------------|-------------------|
| Dueño / Ejecutor de Proceso | Carol Patricia Campos González | ccamposg@fgs.co |
| Especialista Centro de Excelencia | Jeimy Johana Lozano Garnica | jelozanog@fgs.co |
| Ingeniero de Desarrollo | Ronald Estiven Rios Hernandez | rriosh@fgs.co |

### 1.4 Requisitos previos mínimos para la automatización

- Los equipos de computación utilizados para la ejecución de la automatización deben cumplir con las especificaciones técnicas necesarias para ejecutar el software y los procesos automatizados de manera eficiente.
- Se debe tener en cuenta posibles definiciones sobre el camino de actividades (HU's) que no están estipuladas en los flujos e impliquen cambio de alcance.

### 1.5 Información general del proceso

| Nro. ítem | Descripción |
|-----------|-------------|
| 1 | Nombre completo del proceso: Costo Amortizable |
| 2 | Área de ejecución del proceso: Coordinación de Portafolio |
| 3 | Gerencia de ejecución del proceso: Gerencia de Portafolio |
| 4 | Número de ETC's participantes en el proceso: 1 |
| 5 | Frecuencia de ejecución del proceso: 2 días final de mes |
| 6 | Tiempo de ejecución del proceso: 14 horas |

---

## 2. DESCRIPCIÓN ACTUAL DEL PROCESO

### 2.1 Diagrama AsIs

Se incluye como documentos anexos, los As Is de:
- Costo Amortizable

### 2.2 Descripción del proceso

Permite hacer seguimiento a las obligaciones modificadas o reestructuradas con el fin de poder amortizar la pérdida o la ganancia dadas por el cambio de condiciones iniciales pactadas con el cliente al momento de la firma de los pagarés. Al igual, se aplica a las obligaciones del portafolio de vivienda cuyas obligaciones fueron afectadas en el proceso de retención modificando la tasa de interés. 

El proceso incluye las siguientes actividades:

- Se debe contar con la información de créditos modificados, reestructurados, créditos de vivienda con disminución de tasa por retenciones y créditos comercial con amortización especial de acuerdo con la negociación realizada.
- Se debe ejecutar y agrupar la información, con las respectivas marcas para su ejecución.
- Se debe ejecutar macro en la cual calcula las pérdidas y ganancias de los créditos.
- Se da priorización a la amortización de los créditos especiales sobre el cálculo del punto anterior.
- Se arma base final.
- Se valida los resultados obtenidos.
- Se cargan bases de datos para reportar al provisionador.
- Incluye: Plan de Contingencia: envío de notificaciones a través de correo electrónico y reintentos del asistente.

### 2.3 Consideraciones generales del proceso

La solución se implementará utilizando la herramienta Power Automate Desktop en su última versión disponible. Se desarrollarán componentes modulares siguiendo el patrón de diseño de software conocido como "alta cohesión y bajo acoplamiento". 

Estos componentes estarán estructurados en flujos identificados por nombres de aplicaciones, lo que permitirá diferenciar y organizar los distintos componentes desarrollados. Es importante destacar que este asistente se clasifica como desatendido, lo que significa que puede funcionar de manera autónoma sin la intervención directa de los usuarios.

---

## 3. DESCRIPCIÓN PROCESO AUTOMATIZADO

### 3.1 Objetivo de la automatización

Automatizar el proceso de Costo Amortizable mediante tecnología RDA, con lo que se generan estrategias tecnológicas que buscan optimizar las tareas repetitivas y disminuir las horas de ocupación de los ETC's en ejecución manual, logrando enfocar el talento humano en esfuerzos y actividades de mayor valor.

### 3.2 Ruta y Horario de entrega de insumos

No se cuenta con entrada de insumos para iniciar el proceso.

### 3.3 Diagrama ToBe

Se incluye como documentos anexos, los To Be de:
- Costo Amortizable

### 3.4 Descripción de las actividades

#### 3.4.1 Historia de usuario 1 – (Créditos Reestructurados y Modificados)

##### 3.4.1.1 Declaración historia de usuario 1

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Ejecutar los Querys  
**De forma que:** Puede consolidar los resultados

##### 3.4.1.2 Criterios de aceptación historia de usuario 1

**Entradas:**

1. Ejecución del cierre del mes anterior, ruta:

**Descripción detallada de la funcionalidad (incluye excepciones):**

2. Para consultar la información de reestructurados y modificados desde SQL, se abre el siguiente query:
   - `00_Query consulta_SCC_Reestructurados_Modificados`

3. Conectar con el servidor `10.1.3.101\SCC`

4. Correr el query con los pasos que este indica en la sentencia hasta llegar a resultados.

5. Seleccionar `DWH_CC`

6. En `drop table #Base`, cambiar la fecha con el número del mes anterior `AAAA/MM/DD`

7. Seleccionar y dar click en `Execute`

8. En `drop table #Base2`, cambiar la fecha con el número del mes anterior `AAAA/MM/DD`

9. Seleccionar y dar click en `Execute`

10. Seleccionar cada una de las tablas y dar click en `Execute`

11. Seleccionar la tabla `select max (obligaciones)` y dar click en `Execute`

12. Validar el número del resultado, para el ejemplo "4"

13. Se deben crear tantas obligaciones se arroje en el paso anterior

14. En la tabla `alter table #base add obligación` registrar 1

15. En `set a.obligacion` registrar 1

16. En `where b.posicion=` registrar 1

Y así sucesivamente tantas obligaciones registren.

17. Seleccionar cada una de las tablas y dar click en `Execute`

#### 3.4.2 Historia de usuario 2 – (Consolidar Información)

##### 3.4.2.1 Declaración historia de usuario 2

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Generar el archivo de consolidación  
**De forma que:** Pueda ir consolidando cada uno de los reportes

##### 3.4.2.2 Criterios de aceptación historia de usuario 2

**Entradas:**

1. Querys ejecutados

**Descripción detallada de la funcionalidad (incluye excepciones):**

2. Ingresar a la ruta especificada

3. Abrir el archivo Excel `01. información Consolidada mm/aaaa anterior`

4. En este archivo de Excel se irá consolidando las bases que anteriormente consultamos en el SCC o DWH, con el fin de ir organizándola en la estructura definida

5. Ubicar cada una de las pestañas según corresponda

6. Borrar el contenido de las pestañas del archivo

#### 3.4.3 Historia de usuario 3 – (Consolidadas Reestructuradas)

##### 3.4.3.1 Declaración historia de usuario 3

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Descargar el reporte de transacciones  
**De forma que:** Pueda consolidar las Reestructuradas

##### 3.4.3.2 Criterios de aceptación historia de usuario 3

**Entradas:**

1. Archivo información Consolidada

**Descripción detallada de la funcionalidad (incluye excepciones):**

2. Seleccionar la tabla `1-Consolidadas Reestructuradas`

3. Dar click en `Execute`

4. Copiar el resultado

5. En el archivo de Excel `01. información Consolidada mm/aaaa anterior`, ubicar la pestaña `1. Consolidadas Reestructuradas` y pegar la información del resultado del query

#### 3.4.4 Historia de usuario 4 – (Consolidadas Modificadas)

##### 3.4.4.1 Declaración historia de usuario 4

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Descargar el reporte de transacciones  
**De forma que:** Pueda consolidar las Modificadas

##### 3.4.4.2 Criterios de aceptación historia de usuario 4

**Entradas:**

1. Archivo información Consolidada

**Descripción detallada de la funcionalidad (incluye excepciones):**

1. Seleccionar la tabla `2-Consolidadas Modificadas`

2. Dar click en `Execute`

3. Copiar el resultado

4. En el archivo de Excel `01. información Consolidada mm/aaaa anterior`, ubicar la pestaña `2. Consolidadas Modificadas` y pegar la información del resultado del query

#### 3.4.5 Historia de usuario 5 – (Reestructurados Totales)

##### 3.4.5.1 Declaración historia de usuario 5

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Descargar el reporte de transacciones  
**De forma que:** Pueda consolidar los Reestructurados Totales

##### 3.4.5.2 Criterios de aceptación historia de usuario 5

**Entradas:**

1. Archivo información Consolidada

**Descripción detallada de la funcionalidad (incluye excepciones):**

1. Seleccionar la tabla `3-Reestructurados Totales`

2. Dar click en `Execute`

3. Copiar el resultado

4. En el archivo de Excel `01. información Consolidada mm/aaaa anterior`, ubicar la pestaña `3. Reestructurados totales` y pegar la información del resultado del query

#### 3.4.6 Historia de usuario 6 – (Modificados Totales)

##### 3.4.6.1 Declaración historia de usuario 6

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Descargar el reporte de transacciones  
**De forma que:** Pueda consolidar los Modificados Totales

##### 3.4.6.2 Criterios de aceptación historia de usuario 6

**Entradas:**

1. Archivo información Consolidada

**Descripción detallada de la funcionalidad (incluye excepciones):**

1. Seleccionar la tabla `4-Modificados Totales`

2. Dar click en `Execute`

3. Copiar el resultado

4. En el archivo de Excel `01. información Consolidada mm/aaaa anterior`, ubicar la pestaña `4. Modificados totales` y pegar la información del resultado del query

#### 3.4.7 Historia de usuario 7 – (Retenidos)

##### 3.4.7.1 Declaración historia de usuario 7

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Descargar el reporte de transacciones  
**De forma que:** Pueda consolidar los Retenidos

##### 3.4.7.2 Criterios de aceptación historia de usuario 7

**Entradas:**

1. Archivo "Reporte Cambio de Tasa crédito Hipotecario"

**Descripción detallada de la funcionalidad (incluye excepciones):**

1. Abrir archivo Excel en la ruta especificada

2. Incluir una columna "C", nombrada "FECHA DWH"

3. Para pegar la fecha de retención debe cambiarse el formato ya que en la que envían viene 12/08/2018 y en el Excel se maneja 20180812:

Se utiliza la siguiente fórmula:

```
CONCATENAR(AÑO(B9)*10,MES(B9)*10,DIA(B9))
```

**Tener en cuenta:** Del día 10 en adelante no multiplicar el mes por 10, para que no salga 010. Se cambia la fórmula así:

```
CONCATENAR(AÑO(B12)*10,MES(B12),DIA(B12))
```

O también:

```
=AÑO(B47)&SI(LARGO(MES(B47))=2,MES(B47),"0"&MES(B47))&SI(LARGO(DIA(B47))=2,DIA(B47),"0"&DIA(B47))
```

4. Copiar los datos de la columna creada "C"

5. Pegar la información en el archivo de Excel `01. información Consolidada mm/aaaa anterior`, ubicar la pestaña `5. Retenidos`, columna "B"

6. Copiar los datos de la columna "E" No. Crédito del "Reporte Cambio de Tasa crédito Hipotecario"

7. Pegar la información en el archivo de Excel `01. información Consolidada mm/aaaa anterior`, ubicar la pestaña `5. Retenidos`, columna "C"

8. Copiar los datos de la columna "AB" Saldo del "Reporte Cambio de Tasa crédito Hipotecario"

9. Pegar la información en el archivo de Excel `01. información Consolidada mm/aaaa anterior`, ubicar la pestaña `5. Retenidos`, columna "D"

10. Copiar los datos de la columna "K" Tasa actual del "Reporte Cambio de Tasa crédito Hipotecario"

11. Pegar la información en el archivo de Excel `01. información Consolidada mm/aaaa anterior`, ubicar la pestaña `5. Retenidos`, columna "E"

12. Copiar los datos de la columna "L" Tasa Autorizada del "Reporte Cambio de Tasa crédito Hipotecario"

13. Pegar la información en el archivo de Excel `01. información Consolidada mm/aaaa anterior`, ubicar la pestaña `5. Retenidos`, columna "F"

14. En el Excel `01. información Consolidada mm/aaaa anterior`, ubicar la pestaña `5. Retenidos`, columna "A", campo "Fecha_Corte", registrar el último día mes que se encuentra trabajando

15. No pueden existir obligaciones duplicadas en esta base, en dado caso de que existan se debe a que a una sola obligación le hicieron doble retención, es decir, le bajaron la tasa dos veces en el mes, por lo cual se debe unificar una sola y colocar la tasa inicial y la mínima que quedó.

**Ejemplo:**

| Fecha_Corte | Fecha_Retencion | N_Obligacion | Saldo | Tasa_Actual | Tasa_Autorizada | Tasa_Actual_Nominal | Tasa_Autorizada_Nominal |
|-------------|-----------------|--------------|-------|-------------|-----------------|---------------------|-------------------------|
| 20180831 | 20180802 | 0132207763991 | 13,921,737 | 10 | 9 | 0.80 | 0.72 |
| 20180831 | 20180809 | 0132207763991 | 33,043,371 | 9 | 8 | 0.72 | 0.64 |

**Entonces quedaría:**

| Fecha_Corte | Fecha_Retencion | N_Obligacion | Saldo | Tasa_Actual | Tasa_Autorizada | Tasa_Actual_Nominal | Tasa_Autorizada_Nominal |
|-------------|-----------------|--------------|-------|-------------|-----------------|---------------------|-------------------------|
| 20180831 | 20180809 | 0132207763991 | 33,043,371 | 10 | 8 | 0.80 | 0.64 |

16. Eliminar los registros duplicados realizado el paso anterior

#### 3.4.8 Historia de usuario 8 – (Reestructurados)

Esta base es donde se organiza la información para subir a SQL. Se pasa la información que tenemos en las hojas que acabamos de revisar.

##### 3.4.8.1 Declaración historia de usuario 8

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Copiar la información de los informes  
**De forma que:** Consolidar los Reestructurados

##### 3.4.8.2 Criterios de aceptación historia de usuario 8

**Entradas:**

1. Archivo información Consolidada

**Descripción detallada de la funcionalidad (incluye excepciones):**

2. De la pestaña `1. Consolidadas Restructurados` copia desde la columna E hasta la última columna de obligaciones que se encuentre poblada

3. Copia en la pestaña `6. Restructurados` desde la columna H hasta la última columna de obligaciones que se encuentre poblada

4. En la columna A, fecha se poblaron los campos hasta el último registro

5. En las columnas E, F y G, se arrastran los campos hasta el último registro, o se poblaron como se muestra en la imagen

6. En la pestaña `3. Reestructurados totales` se filtra por la columna "C" el número "1"

7. Se copian los registros de las columnas "E" y "F"

8. Se pegan en la pestaña "Reestructurados" en las columnas "H" e "I"

9. La columna F para este caso va como "Individual", la fecha y columna G se arrastra la información

10. Reemplazar los NULL por vacío

**Nota:**

Dado a que son reestructuraciones individuales la combinación puede ser entre las dos últimas.

**Misma Obligación:** Es cuando la obligación nueva es la misma que la anterior. Cuando es en la misma obligación dejo obligación1 vacía debido a que no tengo una obligación anterior.

**Diferente Obligación:** Es cuando la obligación nueva es diferente a la anterior.

**Ejemplo:**

| Herramienta | Tipo_Herramienta | Tipo_Obligacion |
|-------------|------------------|-----------------|
| Reestructurado | Consolidada | Diferente Obligación |
| Reestructurado | Individual | Misma Obligación |
| Reestructurado | Individual | Diferente Obligación |

| Herramienta | Tipo_Herramienta | Tipo_Obligacion | Obligacion_Nueva | Obligacion1 | Obligacion2 |
|-------------|------------------|-----------------|------------------|-------------|-------------|
| Reestructurado | Individual | Misma Obligación | 33011547244 | | |
| Reestructurado | Individual | Diferente Obligación | 30019544024 | 30013200814 | |

#### 3.4.9 Historia de usuario 9 – (Modificados)

Esta base es donde se organiza la información ya marcada, para subir a las bases de SQL de los modificados.

##### 3.4.9.1 Declaración historia de usuario 9

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Copiar la información de los informes  
**De forma que:** Consolidar los Modificados

##### 3.4.9.2 Criterios de aceptación historia de usuario 9

**Entradas:**

1. Archivo información Consolidada

**Descripción detallada de la funcionalidad (incluye excepciones):**

2. De la pestaña `2. Consolidadas Modificados` copia desde la columna E hasta la última columna de obligaciones que se encuentre poblada

3. Copia en la pestaña `7. Modificados` desde la columna H hasta la última columna de obligaciones que se encuentre poblada

4. En la columna A, fecha se poblaron los campos hasta el último registro

5. En las columnas E, F y G, se arrastran los campos hasta el último registro, o se poblaron como se muestra en la imagen

6. En la pestaña `4. Modificaciones totales` se filtra por la columna "C" el número "1"

7. Se copian los registros de las columnas "C"

8. Se pegan dos veces en la pestaña "Modificados" en las columnas "H" e "I"

9. La columna F para este caso va como "Individual", la fecha y columna G se arrastra la información

10. Reemplazar los NULL por vacío

#### 3.4.10 Historia de usuario 10 – (Retenciones)

Esta base es donde se organiza la información ya marcada, para subir a las bases de SQL de las retenciones.

##### 3.4.10.1 Declaración historia de usuario 10

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Copiar la información de los informes  
**De forma que:** Consolidar las Retenciones

##### 3.4.10.2 Criterios de aceptación historia de usuario 10

**Entradas:**

1. Archivo información Consolidada

**Descripción detallada de la funcionalidad (incluye excepciones):**

2. De la pestaña `5. Retenidos` copia desde la columna "C" N_Obligación

3. Copia en la pestaña `8. Retenidos`, copia en la columna H

4. En la columna A, fecha se poblaron los campos hasta el último registro con la fecha de corte

5. En las columnas E, F y G, se arrastran los campos hasta el último registro, o se poblaron como se muestra en la imagen

6. Reemplazar los NULL por vacío

**Nota:**

- Las variables Tipo_Id, Modalidad, Numero_Id se llenan cuando se suba la base a SQL y se haga un cruce con definitivos con la Obligacion_Nueva.
- Las variables Herramienta, Tipo_Herramienta, Tipo_Obligación se llenan de la siguiente manera:

Como son retenciones todo va sobre la misma obligación (como no hay obligación anterior el campo obligación1 es vacío) y la única combinación posible es la siguiente:

| Herramienta | Tipo_Herramienta | Tipo_Obligacion |
|-------------|------------------|-----------------|
| Retención | Individual | Misma Obligación |

#### 3.4.11 Historia de usuario 11 – (Cargar en SQL)

Una vez terminado los archivos se suben a SQL las siguientes hojas.

##### 3.4.11.1 Declaración historia de usuario 11

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Cargar los archivos en SQL  
**De forma que:**

##### 3.4.11.2 Criterios de aceptación historia de usuario 11

**Entradas:**

1. Archivos información Consolidada

**Descripción detallada de la funcionalidad (incluye excepciones):**

2. Ingresa a SQL – Opción PORTAFOLIO

3. Task – Import Date

4. Ejecutar query de la siguiente ruta

5. Conectar con el servidor `10.1.3.101\SCC`

6. Click en "Next"

7. Seleccionar Excel y Next

8. Seleccionar archivo `01. Información Consolidada mm/aaaa` de la ruta definida

9. Seleccionar y poblar de la siguiente manera:
   - `6.Reestructurados`: `[ANDREAL].[Costo_Amortizado_001_Reestructurados_Acum]`
   - `7.Modificados`: `[ANDREAL].[Costo_Amortizado_001_Modificados_Acum]`
   - `8.Retenciones`: `[ANDREAL].[Costo_Amortizado_001_Retenciones_Acum]`

10. Clic en Preview y Next hasta finalizar

11. La cantidad de registros cargados debe ser igual a la cantidad de registros de los 3 archivos en Excel

12. Adicionalmente se deben subir estas dos hojas:
    - `4.Modificados Totales`: `[ANDREAL].[Costo_Amortizado_0011_Modificados_Acum]`
    - `5.Retenidos`: `[ANDREAL].[Costo_Amortizado_0011_Retenciones_Acum]`

#### 3.4.12 Historia de usuario 12 – (Validación/Completitud de la Información)

##### 3.4.12.1 Declaración historia de usuario 12

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Validar la información  
**De forma que:** Pueda completar la información faltante

##### 3.4.12.2 Criterios de aceptación historia de usuario 12

**Entradas:**

1. Información cargada en SQL

2. Una vez subida la información a las tablas se abre este query. El cual verifica que hayan subido los datos completos, que las variables sean consistentes y adicionalmente llena los campos que no tenían información como eran Tipo_Id, Numero_Id, Modalidad etc.

**Descripción detallada de la funcionalidad (incluye excepciones):**

3. En la tabla reestructurados "Update", actualizar la fecha

4. Clic en "Execute"

5. En la tabla "Select", actualizar la fecha

6. Validar que estén poblados los campos, Tipo, número y modalidad

7. En la tabla retenciones "Update", actualizar la fecha

8. Clic en "Execute"

9. En la tabla "Select", actualizar la fecha

10. Validar que estén poblados los campos

11. Se repiten los mismos pasos para los modificados

12. Guardar y salir

#### 3.4.13 Historia de usuario 13 – (Recolectar información Tasas Plazos Saldos)

Este query trae toda la información de tasas, plazos y saldos de las obligaciones anteriores y la nueva para poder realizar el cálculo de la pérdida o ganancia.

##### 3.4.13.1 Declaración historia de usuario 13

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Recolectar información tasas plazos saldos  
**De forma que:** Pueda realizar el cálculo de la pérdida o ganancia

##### 3.4.13.2 Criterios de aceptación historia de usuario 13

**Entradas:**

1. Ejecución Query

**Descripción detallada de la funcionalidad (incluye excepciones):**

2. En la ruta definida ejecutar el query N.3

3. Conectar con el servidor `10.1.5.172\RIESGOS`

4. En la tabla de Reestructurados se actualiza la fecha y Execute

5. En la tabla de Retenciones se actualiza la fecha y Execute

6. En la tabla de Modificados se actualiza la fecha y Execute

7. En la tabla se valida y Execute y se visualiza el resultado con la fecha actualizada

8. Es decir, el total de registros para el ejemplo corresponde a 3.101

**Creación de Saldo, Tasa Efectiva, Tasa Mensual y Plazo por cada obligación, para validación del cierre de los clientes del mes pasado:**

- Se actualiza la fecha del cierre que se está trabajando
- Se selecciona y se da opción "Execute"
- Seleccionar para validar si hay registros Nulos
- Si no registra ningún Nulo, continuar

**De lo contrario:**

- Seleccionar la tabla de Saldo, Tasas y Plazo, y ejecutar
- Se actualiza la fecha del cierre del mes inmediatamente anterior (para el ejemplo Marzo)
- Se selecciona y se da opción "Execute"

**Validaciones de Nulas:**

- Se actualiza la fecha del cierre del mes inmediatamente anterior (para el ejemplo Marzo), y se ejecuta
- Se realiza el mismo ejercicio por cada una de las obligaciones, actualizando la fecha del cierre del mes inmediatamente anterior (para el ejemplo Marzo), de cada una de las obligaciones, y se ejecuta
- Así, sucesivamente hasta completar las 25 obligaciones existentes

**Para los retenidos:**

- Se cambia a la fecha del mismo mes
- Se valida que no se presenten saldos nulos
- Se pueden presentar obligaciones que no traen saldo, esas se deben dejar para validar de forma manual
- Se selecciona la base total y ejecuta
- Carga los 3101 registros
- Visualizar la base, registrar fecha de corte y ejecutar
- Seleccionar los registros; copiar

#### 3.4.14 Historia de usuario 14 – (Cálculo de Pérdida o Ganancia)

##### 3.4.14.1 Declaración historia de usuario 14

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Calcular la pérdida o ganancia  
**De forma que:** Pueda determinar el impacto financiero

##### 3.4.14.2 Criterios de aceptación historia de usuario 14

**Entradas:**

El formato ya está definido, solo se debe pegar la información y verificar que coincidan las columnas.

**Descripción detallada de la funcionalidad (incluye excepciones):**

1. En la ruta: `Portafolio > COSTO AMORTIZADO`, abre el archivo `0.4 Cálculo de la pérdida o ganancia_MM_AAAA`

2. Copia los registros seleccionados en el archivo Excel, columna A fila 2

3. Elimina los registros sobrantes

4. Se seleccionan las obligaciones, desde la columna H

5. Hasta la número 25, columna EG

6. Se reemplaza los campos NULL por vacíos, para que las fórmulas sean calculadas

7. Se debe verificar que las fórmulas estén trayendo bien la información

8. Verificar que los registros que no generen ni pérdida ni ganancia (0), efectivamente sea porque no les cambió la tasa, es decir, la columna EQ debe ser igual a Verdadero en la columna ER

9. Verificar que los que estén generando ganancia efectivamente se les haya subido la tasa y sea coherente

10. Se da guardar al archivo

**Una vez revisado el archivo se sube a SQL, para guardar este cálculo:**

11. Se carga el Excel

12. El nombre de la tabla a la cual se debe subir es la siguiente:
    `[ANDREAL].[Costo_Amortizado_0044_BaseTotal_Acum_Info_Calculo_PerdidaGanancia]`

13. En esta tabla se almacena mes a mes la información completa con el cálculo de la pérdida o ganancia

#### 3.4.15 Historia de usuario 15 – (Query variables cálculo de valor valuativo)

Este query calcula la amortización que se irá descontando periodo a periodo (mes a mes), de los créditos que ya fueron creados en el sistema.

##### 3.4.15.1 Declaración historia de usuario 15

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Ejecutar el Query N.06  
**De forma que:** Pueda realizar el cálculo de valor valuativo

##### 3.4.15.2 Criterios de aceptación historia de usuario 15

**Entradas:**

Query N.06

**Descripción detallada de la funcionalidad (incluye excepciones):**

1. Toma el query N.06

2. En el query están las indicaciones del paso a paso, por cada reporte

3. Correr el query

4. Se ejecuta tabla `bd_perdidas_ganancias_dwh`

5. Se ejecuta

6. Se ejecuta para eliminar la tabla `bd_perdidas_ganancias_dwh`

7. Cuando se llegue al "HASTA ACA"

8. Donde crea la tabla: `bd_perdidas_ganancias_dwh`

Esta tabla es la que está vinculada al excel para correr la macro y calcule la amortización de cada obligación.

#### 3.4.16 Historia de usuario 16 – (Cálculo valuativa_mes_año)

Este archivo de Excel tiene la macro que calcula el valor de amortización de cada obligación en el mes que se está revisando.

##### 3.4.16.1 Declaración historia de usuario 16

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Ejecutar los cálculos  
**De forma que:** Pueda realizar el cálculo de valor valuativo

##### 3.4.16.2 Criterios de aceptación historia de usuario 16

**Entradas:**

Tabla `bd_perdidas_ganancias_dwh`

**Descripción detallada de la funcionalidad (incluye excepciones):**

1. En la ruta: Costo Amortizado – Abrir archivo Excel `07. Calculo Valuativa mm_aaaa`

2. Al abrir el archivo se le debe dar en la advertencia de seguridad (opciones, habilitar todo el contenido)

3. Como este archivo se trae la base de SQL que se actualizó en el paso anterior debe pararse sobre la hoja Data en el encabezado de la tabla dinámica, ir a diseño y darle actualizar

4. Una vez se actualiza la tabla verificar que efectivamente esté trayendo el último mes que estamos trabajando en la fecha corte

5. Para que actualice la información se debe cambiar la conexión a dbo. Ya que al ejecutarlo con Andrea no modifica la información

6. Una vez actualizada la tabla, se debe ejecutar la macro, la cual la ejecutamos presionando el botón (ValorarPérdida) que se encuentra arriba de la hoja al lado izquierdo

7. Al final la macro muestra el mensaje "Hecho" lo que indica que ya terminó

8. Los resultados de la macro se muestran en la hoja TIRs_2, desde la columna B a la columna F

9. En la pestaña de DATA, columna D, copia los valores

10. Pega en formato valores en la pestaña TIRs_2, Columna B

11. Copia los registros de la pestaña DATA, columna B "Fecha_Reestructuración"

12. Pega en la pestaña TIRs_2, Columna G "Fecha_cierre"

13. Copia los registros de la pestaña DATA, columna J "Altura"

14. Pega en la pestaña TIRs_2, Columna H "Altura"

**Las equivalencias de los campos son:**

- Fecha_Cierre = Fecha_Reestructuracion
- Estado = Estado
- Tipo = Tipo
- Altura = Altura

15. Arrastrar los formatos al final de la base

16. Filtrar por fecha cierre, para verificar que estén todos los meses desde que inició el proceso hasta el corte que estoy trabajando

17. Filtrar la altura, este debe coincidir de acuerdo con el mes, es decir:

| Mes | Altura |
|-----|--------|
| Junio | 2 |
| Julio | 1 |
| Agosto | 0 |

18. Filtrar la altura 0, estos créditos todos no deben llevar amortización del mes ni amortización acumulada porque es la primera vez que se van a reportar, por lo tanto, verificar que estas columnas estén en 0

19. Y Guardar

#### 3.4.17 Historia de usuario 17 – (Formato de Envío)

##### 3.4.17.1 Declaración historia de usuario 17

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Preparar el formato de envío  
**De forma que:** Pueda consolidar la información final

##### 3.4.17.2 Criterios de aceptación historia de usuario 17

**Entradas:**

`08. Formato de envío mm_aaaa_Def`

**Descripción detallada de la funcionalidad (incluye excepciones):**

1. En la ruta Costo Amortizado > abre archivo en Excel: `08. Formato de envío mm_aaaa_Def`

2. Actualizar la fecha de la columna A, a la fecha de corte

3. Copia del archivo de la HU anterior, pestaña TIRs_2, columna B, los números de obligación

4. Pega en formato de valores en el archivo de esta HU, pestaña SUBIR, columna B, los números de obligación

5. Copia del archivo de la HU anterior, pestaña TIRs_2, columna C a la H

6. Pega en formato de valores en el archivo de esta HU, pestaña SUBIR, columna C a la H

7. Por la versión se debe abrir en la ruta de Costo Amortizable > `08. Formato subir SQL Abr 2025`

8. Y se copia los registros del primer archivo en Excel SUBIR a este formato subir SQL

9. Y Guardar

#### 3.4.18 Historia de usuario 18 – (Hoja Subir SQL)

##### 3.4.18.1 Declaración historia de usuario 18

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Subir la información a SQL  
**De forma que:** Pueda almacenar los datos calculados

##### 3.4.18.2 Criterios de aceptación historia de usuario 18

**Entradas:**

`08. Formato subir SQL Abr 2025`

**Descripción detallada de la funcionalidad (incluye excepciones):**

1. Abrir SQL – Portafolio

2. Subir el archivo trabajado en la HU anterior

3. Se relaciona la base de datos: `[ANDREAL].[Costo_Amortizado_009_Base_Valuativa]`

4. Se actualiza a la fecha de corte y ejecuta

5. Y corro la segunda parte del query hasta el final: `06.Query traer variables para cálculo de valor valuativo`

6. Se copia el resultado

#### 3.4.19 Historia de usuario 19 – (Hoja Base)

##### 3.4.19.1 Declaración historia de usuario 19

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Consolidar la información en la hoja base  
**De forma que:** Pueda preparar el reporte final

##### 3.4.19.2 Criterios de aceptación historia de usuario 19

**Entradas:**

`08. Formato de envío mm_aaaa_Def`

**Descripción detallada de la funcionalidad (incluye excepciones):**

1. El resultado copiado de la HU anterior, se pega en el formato 08, pestaña BASE

2. Se ejecuta en sql, portafolio: la fecha de corte y ejecutar

3. Se copia los resultados

4. Se pegan el archivo formato 08, pestaña Casos Especiales

5. Se ejecuta tabla dinámica en la pestaña Verificación Duplicados

6. Y guardar

#### 3.4.20 Historia de usuario 20 – (Verificación en Producción)

##### 3.4.20.1 Declaración historia de usuario 20

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Verificar la información en producción  
**De forma que:** Pueda validar los ajustes necesarios

##### 3.4.20.2 Criterios de aceptación historia de usuario 20

**Entradas:**

`Verificación en Producción_MM`

**Descripción detallada de la funcionalidad (incluye excepciones):**

1. En la pestaña Costo Amortizado Enviado, filtrar por Advertencia Saldo diferido

2. Copia el resultado del filtro

3. La pega en el archivo formato 08, pestaña Ajuste por saldo

4. En la pestaña BASE, se realiza un buscarV en las columnas C, D y E con la pestaña de casos especiales columnas B, C y D

5. Se copian los registros de la columna N

6. Se pegan en la columna D

7. Una vez ajustada la columna K y L llevo la información de la hoja Base a la hoja Base Final. Tener en cuenta que solo se deben llevar las columnas que contiene esta última hoja

8. Cambiar la fecha de la columna A: Esta debe ser la fecha en la que voy a enviar a tecnología para que hagan el cargue en ese día

#### 3.4.21 Historia de usuario 21 – (Cargue Costo Amortizado)

##### 3.4.21.1 Declaración historia de usuario 21

**Yo como:** Ejecutor del proceso de Costo Amortizable  
**Quiero:** Realizar el cargue final  
**De forma que:** Pueda completar el proceso

##### 3.4.21.2 Criterios de aceptación historia de usuario 21

**Entradas:**

`08. Formato de envío mm_aaaa_Def`

**Descripción detallada de la funcionalidad (incluye excepciones):**

1. Pararse en la hoja Base Final, Clic derecho, mover o copiar, nuevo archivo, crear una copia

2. Cuando ya se genere el nuevo archivo cambio la columna C y D a formato general con dos decimales

3. Luego le doy guardar como Excel 97-2003 en la carpeta del mes correspondiente con el siguiente nombre `09.Cargue_CostoAmortizado_AñoMesDia`, la fecha debe ser la del día que se va a enviar el archivo para el cargue

**Ejemplo:**

Si lo voy a enviar hoy 27 de septiembre para que lo carguen hoy mismo sería:
`9.Cargue_CostoAmortizado_20180927`

**FIN…**

---

### 3.5 Notificaciones Generadas

Si el asistente presenta alguna novedad se debe enviar una notificación por correo, en donde se debe realizar la intervención manual por parte del funcional para realizar la respectiva gestión y deberá reiniciar el asistente.

#### ENVÍO DE NOTIFICACIÓN

**Para:** xdefinir@fundaciongruposocial.co  
**Asunto del correo:** [Detenido] Asistente Bot

**Cuerpo del Correo:**

```
Buen día,

En el flujo se generó una novedad en la fecha 29/11/2023 08:36:38, por tal motivo no se logró finalizar la ejecución del asistente.

Número único de proceso: _11/12/2023 16:55:00_11/12/2023 17:00:00
Nombre de máquina: AZBCSQAVMRPA000
Número de máquina: BR1
Usuario de red: LBUEPECC01

Observación de la novedad:
[Error Controlado]

Muchas gracias.
```

### 3.6 Horarios y tiempo de ejecución

| Nro. ítem | Descripción |
|-----------|-------------|
| 1 | Nombre proceso: Costo Amortizable |
| 2 | Nombre del Bot: R_MPT_Costo Amortizable |
| 3 | Periodicidad: Mensual |
| 4 | Hora de ejecución: 2 días |
| 5 | Tiempo total de ejecución: 14h |
| 6 | Tipo de Bot: Asistente |

### 3.7 Indicadores (KPI's) asociados al proceso

#### EFICIENCIA

| Nombre del KPIS | Descripción | Meta |
|-----------------|-------------|------|
| **Precisión** | Porcentaje reportes procesados correctamente por el RPA.<br><br>**Fórmula:** Número de reportes procesados correctamente por RPA / Número total de cortes procesados | >=95% |
| **Ejecución del robot** | Se miden las ejecuciones realizadas completas de las bases compartidas:<br><br>**Fórmula:** Ejecuciones completadas / total ejecuciones | >=90% |

#### CALIDAD

| Nombre del KPIS | Descripción | Meta |
|-----------------|-------------|------|
| **Tasa de error** | Porcentaje de errores en el proceso automatizado<br><br>**Fórmula:** Número total de errores / Número total de cortes procesados | <=5% |

---

## 4. ANEXOS

| Nro. | Nombre del documento | Descripción |
|------|---------------------|-------------|
| 1 | ASIS | Diagrama As Is del proceso |
| 2 | TOBE | Diagrama To Be del proceso |

---

## 5. APROBACIÓN DEL DOCUMENTO

Este documento requiere la aprobación (conformidad) de los roles definidos en esta tabla.

Los cambios de los requisitos se deben documentar en una versión actualizada y requieren una nueva ronda de conformidades.

| Fecha de aprobación | Responsables | Rol |
|---------------------|--------------|-----|
| | | |

---

**Documento generado:** Junio 2025  
**Versión:** V1  
**Páginas:** 89