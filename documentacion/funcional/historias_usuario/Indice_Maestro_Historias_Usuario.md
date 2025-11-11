# Índice Maestro de Historias de Usuario
## RDA Costo Amortizable

**Versión:** 1.0  
**Fecha:** 10/11/2025  
**Total de Historias:** 21

---

## SPRINT 1: Extracción y Consolidación de Datos

### HU-01: Extracción de Créditos Reestructurados y Modificados desde DWH
- **Estado:** 📝 En progreso
- **Prioridad:** Alta
- **Estimación:** 10 horas
- **Descripción:** Ejecutar queries SQL dinámicos en el DWH para extraer créditos reestructurados y modificados del mes anterior, creando tablas temporales con obligaciones dinámicas
- **Archivo:** `en_progreso/HU01_Extraccion_DWH_Reestructurados_Modificados.md`

### HU-02: Preparación del Archivo de Consolidación
- **Estado:** 📝 En progreso
- **Prioridad:** Alta
- **Estimación:** 5 horas
- **Descripción:** Copiar plantilla Excel y limpiar las 8 pestañas principales preservando encabezados y formatos
- **Archivo:** `en_progreso/HU02_Preparacion_Archivo_Consolidacion.md`

### HU-03: Consolidar Reestructurados desde SQL a Excel
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 4 horas
- **Descripción:** Ejecutar query "1-Consolidadas Reestructuradas" y pegar resultados en pestaña correspondiente del archivo Excel
- **Insumos:** Tablas temporales #Base, #Base2 activas
- **Salida:** Pestaña "1. Consolidadas Reestructuradas" poblada

### HU-04: Consolidar Modificados desde SQL a Excel
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 4 horas
- **Descripción:** Ejecutar query "2-Consolidadas Modificadas" y pegar resultados en pestaña correspondiente del archivo Excel
- **Insumos:** Tablas temporales #Base, #Base2 activas
- **Salida:** Pestaña "2. Consolidadas Modificadas" poblada

### HU-05: Consolidar Reestructurados Totales desde SQL a Excel
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 4 horas
- **Descripción:** Ejecutar query "3-Reestructurados Totales" y pegar resultados en pestaña correspondiente del archivo Excel
- **Insumos:** Tablas temporales #Base, #Base2 activas
- **Salida:** Pestaña "3. Reestructurados totales" poblada

### HU-06: Consolidar Modificados Totales desde SQL a Excel
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 4 horas
- **Descripción:** Ejecutar query "4-Modificados Totales" y pegar resultados en pestaña correspondiente del archivo Excel
- **Insumos:** Tablas temporales #Base, #Base2 activas
- **Salida:** Pestaña "4. Modificados totales" poblada

### HU-07: Consolidar y Transformar Créditos Retenidos
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 14 horas
- **Descripción:** Procesar archivo de Reporte Cambio de Tasa crédito Hipotecario, transformar fechas con fórmulas Excel, copiar columnas específicas y eliminar duplicados
- **Insumos:** Reporte Cambio de Tasa crédito Hipotecario (externo)
- **Salida:** Pestaña "5. Retenidos" poblada con datos transformados
- **Complejidad:** Alta - Requiere transformación de fechas con fórmulas Excel y manejo de duplicados

---

## SPRINT 2: Organización y Cargue a SQL

### HU-08: Organizar Base de Reestructurados para Cargue
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 8 horas
- **Descripción:** Copiar datos de pestañas "1. Consolidadas Reestructuradas" y "3. Reestructurados totales", organizarlos, aplicar marcas y llenar columnas de metadatos en pestaña "6. Reestructurados"
- **Transformaciones:**
  - Poblar fechas, herramienta, tipo_herramienta, tipo_obligación
  - Filtrar por columna "C" = 1 en Reestructurados totales
  - Identificar si es "Misma Obligación" o "Diferente Obligación"
  - Reemplazar NULLs por vacío

### HU-09: Organizar Base de Modificados para Cargue
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 6 horas
- **Descripción:** Copiar datos de pestañas "2. Consolidadas Modificadas" y "4. Modificados totales", organizarlos y llenar columnas de metadatos en pestaña "7. Modificados"
- **Transformaciones:**
  - Similar a HU-08 pero para modificados
  - Filtrar por columna "C" = 1 en Modificados totales
  - Poblar obligacion_nueva duplicada en H e I

### HU-10: Organizar Base de Retenciones para Cargue
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 6 horas
- **Descripción:** Copiar N_Obligación de pestaña "5. Retenidos" a pestaña "8. Retenidos" y poblar columnas de metadatos
- **Transformaciones:**
  - Poblar fecha_corte, herramienta="Retención", tipo_herramienta="Individual", tipo_obligación="Misma Obligación"
  - Dejar obligacion1 vacía (no hay obligación anterior en retenciones)

### HU-11: Cargar Información en Tablas SQL Definitivas
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 10 horas
- **Descripción:** Usar SQL Server Management Studio para cargar las 5 pestañas organizadas en tablas permanentes de SQL usando Import Data
- **Tablas destino:**
  - `[ANDREAL].[Costo_Amortizado_001_Reestructurados_Acum]` ← Pestaña 6
  - `[ANDREAL].[Costo_Amortizado_001_Modificados_Acum]` ← Pestaña 7
  - `[ANDREAL].[Costo_Amortizado_001_Retenciones_Acum]` ← Pestaña 8
  - `[ANDREAL].[Costo_Amortizado_0011_Modificados_Acum]` ← Pestaña 4
  - `[ANDREAL].[Costo_Amortizado_0011_Retenciones_Acum]` ← Pestaña 5
- **Validación:** Conteo de registros cargados debe coincidir con registros en Excel

---

## SPRINT 3: Validaciones y Cálculos Complejos

### HU-12: Validación y Completitud de Información en SQL
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 8 horas
- **Descripción:** Ejecutar query de validación que verifica datos completos y llena campos faltantes (Tipo_Id, Numero_Id, Modalidad) mediante cruces con tabla de definitivos
- **Insumos:** Script `03_Verificar_Info_Completitud.sql`
- **Operaciones:**
  - UPDATE para reestructurados con fecha parametrizada
  - SELECT de validación de campos poblados
  - UPDATE para retenciones con fecha parametrizada
  - UPDATE para modificados con fecha parametrizada

### HU-13: Recolectar Información de Tasas, Plazos y Saldos
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 12 horas
- **Descripción:** Ejecutar query complejo que trae tasas, plazos y saldos de obligaciones anteriores y nuevas para cálculo de pérdida/ganancia
- **Insumos:** Script `04_Recolectar_Info_Tasas_Plazos_Saldo.sql`
- **Complejidad:** Alta - Requiere manejo de NULLs, validaciones recursivas por cada obligación (hasta 25), y consultas históricas de meses anteriores si hay datos faltantes
- **Servidor:** `10.1.5.172\RIESGOS`

### HU-14: Cálculo de Pérdida o Ganancia por Obligación
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 14 horas
- **Descripción:** Pegar resultados del query en archivo Excel "0.4 Cálculo de la pérdida o ganancia" y ejecutar fórmulas para calcular pérdida/ganancia por cambio de tasas
- **Insumos:** Resultados de HU-13
- **Archivo:** `0.4 Cálculo de la pérdida o ganancia_MM_AAAA.xlsx`
- **Operaciones:**
  - Pegar datos en columna A fila 2
  - Reemplazar NULLs por vacío en obligaciones (columnas H a EG - 25 columnas)
  - Verificar fórmulas funcionando correctamente
  - Validar que registros con 0 pérdida/ganancia tienen tasa sin cambios (columna ER)
- **Salida:** Tabla cargada en `[ANDREAL].[Costo_Amortizado_0044_BaseTotal_Acum_Info_Calculo_PerdidaGanancia]`

### HU-15: Ejecutar Query de Variables para Cálculo Valuativo
- **Estado:** ⏳ Pendiente
- **Prioridad:** Media
- **Estimación:** 6 horas
- **Descripción:** Ejecutar query que crea tabla `bd_perdidas_ganancias_dwh` vinculada al Excel con macro de amortización
- **Insumos:** Script `05_Variables_Calculo_Valor_Valuativo.sql`
- **Operaciones:**
  - Ejecutar hasta "HASTA ACA" para crear tabla vinculada
  - Tabla queda lista para ser consumida por macro Excel en HU-16

### HU-16: Ejecutar Macro de Cálculo de Amortización
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 10 horas
- **Descripción:** Actualizar conexión de tabla dinámica en Excel, ejecutar macro VBA "ValorarPérdida" que calcula amortización mensual
- **Insumos:** 
  - Archivo `07. Calculo Valuativa mm_aaaa.xlsx`
  - Tabla SQL `bd_perdidas_ganancias_dwh`
- **Operaciones:**
  - Habilitar contenido de macro en Excel
  - Actualizar tabla dinámica en hoja DATA
  - Cambiar conexión a usuario correcto (dbo)
  - Ejecutar botón "ValorarPérdida"
  - Copiar resultados de DATA a TIRs_2
  - Validar altura según mes (altura = meses desde inicio - 1)
  - Filtrar altura 0 (primera vez) debe tener amortización = 0
- **Complejidad:** Alta - Integración con macro VBA existente

---

## SPRINT 4: Preparación y Envío Final

### HU-17: Preparar Formato de Envío Mensual
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 6 horas
- **Descripción:** Copiar resultados de TIRs_2 al archivo "08. Formato de envío", actualizar fechas y preparar para cargue
- **Insumos:** Archivo `07. Calculo Valuativa mm_aaaa.xlsx` (HU-16)
- **Salidas:**
  - `08. Formato de envío mm_aaaa_Def.xlsx` - Pestaña SUBIR
  - `08. Formato subir SQL Abr 2025.xlsx` (por compatibilidad de versión)

### HU-18: Subir Base Valuativa a SQL
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 5 horas
- **Descripción:** Cargar archivo de HU-17 a tabla SQL y ejecutar segunda parte del query 06
- **Tabla destino:** `[ANDREAL].[Costo_Amortizado_009_Base_Valuativa]`
- **Operaciones:**
  - Cargar hoja SUBIR a SQL
  - Actualizar fecha de corte en query
  - Ejecutar segunda parte del script 06
  - Copiar resultados

### HU-19: Consolidar Información en Hoja Base
- **Estado:** ⏳ Pendiente
- **Prioridad:** Media
- **Estimación:** 8 horas
- **Descripción:** Pegar resultados de HU-18 en pestaña BASE del formato 08, ejecutar validaciones y manejar casos especiales
- **Insumos:** Resultados de HU-18
- **Operaciones:**
  - Pegar en pestaña BASE
  - Ejecutar query de casos especiales
  - Pegar en pestaña Casos Especiales
  - Actualizar tabla dinámica en Verificación Duplicados

### HU-20: Verificación y Ajustes en Producción
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 10 horas
- **Descripción:** Filtrar advertencias de saldo diferido, aplicar ajustes mediante BUSCARV y preparar base final
- **Insumos:** Archivo `Verificación en Producción_MM.xlsx`
- **Operaciones:**
  - Filtrar por "Advertencia Saldo diferido"
  - Copiar resultados a pestaña Ajuste por saldo
  - Ejecutar BUSCARV entre BASE y Casos Especiales
  - Ajustar columnas K y L
  - Copiar a hoja Base Final
  - Actualizar columna A con fecha de envío

### HU-21: Cargue Final de Costo Amortizado
- **Estado:** ⏳ Pendiente
- **Prioridad:** Alta
- **Estimación:** 6 horas
- **Descripción:** Crear archivo final en formato Excel 97-2003 para envío a tecnología para cargue
- **Operaciones:**
  - Copiar pestaña Base Final a nuevo archivo
  - Cambiar columnas C y D a formato general con 2 decimales
  - Guardar como Excel 97-2003
  - Nombrar: `09.Cargue_CostoAmortizado_AAAAMMDD.xlsx`
  - Fecha debe ser el día del envío
- **Entregable Final:** Archivo listo para cargue por tecnología

---

## RESUMEN ESTADÍSTICO

| Métrica | Valor |
|---------|-------|
| **Total Historias** | 21 |
| **Sprints** | 4 |
| **Horas Totales Estimadas** | 160 |
| **Duración Proyecto** | 7 semanas |
| **Historias Alta Prioridad** | 19 |
| **Historias Media Prioridad** | 2 |
| **Historias Completadas** | 0 |
| **Historias En Progreso** | 2 |
| **Historias Pendientes** | 19 |

---

## TECNOLOGÍAS Y HERRAMIENTAS

### Power Automate Desktop
- HU-01, 02, 03, 04, 05, 06, 08, 09, 10, 11, 17, 18, 19, 20, 21

### Python (Scripts Auxiliares)
- HU-01, 02, 07, 13, 14

### Excel + VBA
- HU-07, 14, 16, 17, 19, 20, 21

### SQL Server
- HU-01, 03, 04, 05, 06, 11, 12, 13, 14, 15, 18

---

## ARCHIVOS DE ENTRADA CLAVE

1. `01_Consulta_DWH_Reestructurados_Modificados.sql`
2. `02_Consulta_SCC_Reestructurados_Modificados_Contingencia.sql`
3. `03_Verificar_Info_Completitud.sql`
4. `04_Recolectar_Info_Tasas_Plazos_Saldo.sql`
5. `05_Variables_Calculo_Valor_Valuativo.sql`
6. `06_Cargue_Base_Envio_Final.sql`
7. `01. información Consolidada_Plantilla.xlsx`
8. `Reporte Cambio de Tasa crédito Hipotecario.xlsx` (externo)
9. `0.4 Cálculo de la pérdida o ganancia_MM_AAAA.xlsx`
10. `07. Calculo Valuativa mm_aaaa.xlsx` (con macro VBA)
11. `08. Formato de envío mm_aaaa_Def.xlsx`
12. `Verificación en Producción_MM.xlsx`

---

## PRÓXIMOS PASOS

1. ✅ Completar documentación de HU-01 y HU-02
2. ⏳ Documentar HU-03 a HU-21 usando plantilla estándar
3. ⏳ Iniciar desarrollo de HU-01
4. ⏳ Configurar ambiente de desarrollo
5. ⏳ Establecer conexiones SQL
6. ⏳ Validar acceso a archivos y carpetas

---

**Documento:** Índice Maestro de Historias de Usuario  
**Proceso:** RDA Costo Amortizable  
**Versión:** 1.0  
**Fecha:** 10/11/2025  
**Autor:** Ronald Estiven Rios Hernandez
