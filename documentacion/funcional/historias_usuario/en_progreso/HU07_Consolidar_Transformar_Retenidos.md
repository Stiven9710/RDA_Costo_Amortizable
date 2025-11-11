# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 07 |
| **Nombre Historia** | Consolidar y Transformar Créditos Retenidos |
| **No. Versión** | 1 |
| **Fecha Creación** | 10/11/2025 16:00 |
| **Fecha Modificación** | 10/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Procesar el archivo externo "Reporte Cambio de Tasa crédito Hipotecario", transformar fechas con fórmulas Excel, copiar columnas específicas al archivo de consolidación y eliminar duplicados

**De forma que:** Tenga consolidada la información de créditos de vivienda con retención de tasa, completando así las 5 pestañas de datos base necesarias para el proceso

---

## Criterios de Aceptación

### Insumos

1. **Archivo externo:** "Reporte Cambio de Tasa crédito Hipotecario.xlsx" (recibido por correo o carpeta compartida)
2. **Archivo de consolidación:** `01. información Consolidada MM_AAAA.xlsx` (cerrado en HU-06)
3. **Ruta de entrada:** Carpeta configurada para archivos externos `data/input/externos/`
4. **Fecha de corte:** Último día del mes anterior (calculada en HU-01)

### Entradas de las Funcionalidades

Archivo "Reporte Cambio de Tasa crédito Hipotecario" que contiene:
- Columna B: Fecha de retención (formato dd/mm/aaaa - ej: 12/08/2018)
- Columna E: No. Crédito (obligación)
- Columna AB: Saldo
- Columna K: Tasa actual
- Columna L: Tasa autorizada (nueva tasa después de retención)

### Funcionalidades

1. **Validar existencia del archivo externo**
   
   El asistente debe:
   - Buscar el archivo "Reporte Cambio de Tasa crédito Hipotecario" en la carpeta `data/input/externos/`
   - Validar que el archivo tiene fecha del mes actual o mes anterior
   - Si no existe, detener y notificar (requiere intervención manual para obtener el archivo)
   - Si existe, registrar ruta completa en log

2. **Abrir el archivo externo de retenidos**
   
   - Abrir el archivo con Excel en PAD
   - Modo visible o no visible según configuración
   - Verificar que contiene las columnas esperadas (B, E, AB, K, L)

3. **Crear columna C "FECHA DWH" para transformación de fechas**
   
   - Insertar nueva columna C (o usar si ya existe)
   - Nombrar la columna: "FECHA DWH"
   - Esta columna contendrá la fecha transformada al formato del DWH: AAAAMMDD

4. **Aplicar fórmula de transformación de fecha**
   
   Para transformar la fecha de formato dd/mm/aaaa a AAAAMMDD, el asistente debe:
   
   - **Para días 1-9 (del 01 al 09):**
     - Aplicar fórmula: `=CONCATENAR(AÑO(B{fila})*10,MES(B{fila})*10,DIA(B{fila}))`
     - Ejemplo: 12/08/2018 → 20180812
   
   - **Para días 10-31:**
     - Aplicar fórmula: `=CONCATENAR(AÑO(B{fila})*10,MES(B{fila}),DIA(B{fila}))`
     - Nota: No multiplicar MES por 10 para evitar "010" cuando el día es >= 10
   
   - **Fórmula universal (recomendada):**
     - `=AÑO(B{fila})&SI(LARGO(MES(B{fila}))=2,MES(B{fila}),"0"&MES(B{fila}))&SI(LARGO(DIA(B{fila}))=2,DIA(B{fila}),"0"&DIA(B{fila}))`
     - Esta fórmula maneja automáticamente días y meses de 1 o 2 dígitos
   
   - Aplicar la fórmula a todas las filas con datos
   - Copiar y pegar como valores para eliminar la fórmula y dejar solo los resultados

5. **Abrir archivo de consolidación**
   
   - Abrir `01. información Consolidada MM_AAAA.xlsx`
   - Activar pestaña "5. Retenidos"
   - Verificar que está limpia (solo encabezados)

6. **Copiar columna C (FECHA DWH) del archivo externo**
   
   - Seleccionar toda la columna C con fechas transformadas
   - Copiar los datos (sin encabezado)
   - Cambiar al archivo de consolidación
   - Pegar en pestaña "5. Retenidos", columna B

7. **Copiar columna E (No. Crédito) del archivo externo**
   
   - Volver al archivo de retenidos
   - Seleccionar columna E "No. Crédito"
   - Copiar datos
   - Pegar en archivo consolidación, pestaña "5. Retenidos", columna C

8. **Copiar columna AB (Saldo) del archivo externo**
   
   - Seleccionar columna AB "Saldo"
   - Copiar datos
   - Pegar en archivo consolidación, pestaña "5. Retenidos", columna D

9. **Copiar columna K (Tasa actual) del archivo externo**
   
   - Seleccionar columna K "Tasa actual"
   - Copiar datos
   - Pegar en archivo consolidación, pestaña "5. Retenidos", columna E

10. **Copiar columna L (Tasa Autorizada) del archivo externo**
    
    - Seleccionar columna L "Tasa Autorizada"
    - Copiar datos
    - Pegar en archivo consolidación, pestaña "5. Retenidos", columna F

11. **Poblar columna A (Fecha_Corte) en archivo consolidación**
    
    - En la pestaña "5. Retenidos", columna A "Fecha_Corte"
    - Poblar todas las filas con la fecha del último día del mes que se está procesando
    - Formato: AAAAMMDD
    - Ejemplo: Si se procesa abril 2025, poner: 20250430
    - Usar fórmula o autocompletar hasta la última fila con datos

12. **Identificar y manejar duplicados (dobles retenciones)**
    
    Un crédito puede aparecer duplicado si tuvo dos retenciones en el mismo mes. Proceso:
    
    - Ordenar datos por columna C (N_Obligación)
    - Identificar obligaciones duplicadas
    - Para cada duplicado:
      - Comparar las fechas de retención (columna B)
      - Tomar la retención más reciente (última fecha)
      - Usar la **Tasa_Actual inicial** (de la primera retención)
      - Usar la **Tasa_Autorizada final** (de la última retención)
      - Usar el **Saldo de la última retención**
    
    **Ejemplo de unificación:**
    
    Antes (duplicado):
    | Fecha_Corte | Fecha_Retencion | N_Obligacion | Saldo | Tasa_Actual | Tasa_Autorizada |
    |-------------|-----------------|--------------|-------|-------------|-----------------|
    | 20180831 | 20180802 | 0132207763991 | 13,921,737 | 10 | 9 |
    | 20180831 | 20180809 | 0132207763991 | 33,043,371 | 9 | 8 |
    
    Después (unificado):
    | Fecha_Corte | Fecha_Retencion | N_Obligacion | Saldo | Tasa_Actual | Tasa_Autorizada |
    |-------------|-----------------|--------------|-------|-------------|-----------------|
    | 20180831 | 20180809 | 0132207763991 | 33,043,371 | 10 | 8 |

13. **Eliminar registros duplicados**
    
    - Después de unificar manualmente o automáticamente los duplicados
    - Eliminar las filas duplicadas (mantener solo la fila unificada)
    - Registrar en log cuántas obligaciones tenían doble retención

14. **Validar datos finales**
    
    - Verificar que no quedan duplicados (columna C única)
    - Verificar que todas las columnas críticas tienen datos (no NULLs)
    - Verificar que las fechas están en formato correcto
    - Verificar que tasas son numéricas y razonables (0-30%)

15. **Guardar y cerrar archivos**
    
    - Guardar cambios en archivo de consolidación
    - Cerrar archivo de retenidos externo (sin guardar cambios)
    - Cerrar archivo de consolidación
    - Liberar recursos

16. **Registrar estadísticas**
    
    - Número total de registros en archivo externo
    - Número de duplicados encontrados
    - Número de registros finales (después de eliminar duplicados)
    - Validaciones exitosas
    - Timestamp de finalización

### Puntos de Control Crítico

1. **Validación de archivo externo:** Si no existe el archivo "Reporte Cambio de Tasa crédito Hipotecario", detener el proceso y notificar. Requiere intervención manual para obtenerlo.

2. **Validación de columnas:** Si las columnas B, E, AB, K, L no existen en el archivo externo, detener. La estructura del archivo cambió.

3. **Validación de transformación de fechas:** Si las fechas transformadas no están en formato AAAAMMDD correcto, detener. Puede causar problemas en SQL posterior.

4. **Validación de duplicados:** Si hay obligaciones duplicadas que no se pudieron unificar, detener y requerir intervención manual.

### Puntos de Control No Crítico

1. **Sin retenidos:** Si el archivo externo viene vacío (sin retenciones en el mes), registrar advertencia y continuar con pestaña vacía.

2. **Alto número de duplicados:** Si más del 10% de registros son duplicados, registrar advertencia (revisar si es normal).

3. **Tasas fuera de rango:** Si alguna tasa es > 30% o < 0%, registrar advertencia (posible error en datos).

### Salidas

1. **Pestaña Excel poblada:** "5. Retenidos" en archivo `01. información Consolidada MM_AAAA.xlsx` con:
   - Columna A: Fecha_Corte (poblada)
   - Columna B: Fecha_Retencion (formato AAAAMMDD)
   - Columna C: N_Obligacion
   - Columna D: Saldo
   - Columna E: Tasa_Actual
   - Columna F: Tasa_Autorizada
   - Sin duplicados

2. **Archivo cerrado:** Consolidación completa con 5 pestañas de datos

3. **Log:** `logs/ejecuciones/HU07_Consolidar_Retenidos_AAAAMMDD_HHMMSS.log`

4. **Resumen Sprint 1:** Con HU-07 se completa el Sprint 1 - Extracción y Consolidación de Datos

### Reportería

Log detallado que incluye:
- Ruta del archivo externo procesado
- Número de registros originales
- Número de duplicados identificados y unificados
- Número de registros finales
- Distribución de tasas (promedio, mínimo, máximo)
- Tiempo total de procesamiento
- Confirmación de 5 pestañas completadas

### Parametría

- **Ruta archivo externo:** `data/input/externos/` (configurable)
- **Nombre archivo externo:** `Reporte Cambio de Tasa crédito Hipotecario` (configurable con comodines)
- **Nombre pestaña:** `5. Retenidos` (configurable)
- **Columnas a copiar:** B→B, E→C, AB→D, K→E, L→F (configurable)
- **Manejo de duplicados:** Automático o manual (configurable)
- **Formato fecha salida:** AAAAMMDD (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-01:** Fecha de cierre calculada
- **HU-02:** Archivo de consolidación preparado
- **HU-06:** Primeras 4 pestañas completadas
- **Fuente Externa:** Reporte de tasa hipotecario (fuera del proceso automatizado)

### Historias de Usuario Posteriores
- **HU-08:** Organizar Reestructurados
- **HU-10:** Organizar Retenciones - Usará los datos de esta pestaña

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 8 horas |
| Desarrollo Python (transformaciones) | 4 horas |
| Pruebas unitarias | 3 horas |
| Pruebas integradas | 2 horas |
| **Total** | **17 horas** |

**Nota:** Esta es la HU más compleja del Sprint 1 por las transformaciones de fechas y manejo de duplicados.

---

## Notas Adicionales

### Consideraciones Técnicas

- **Fórmulas Excel complejas:** La transformación de fechas requiere lógica condicional. Considerar usar Python con pandas para simplificar:
  ```
  df['FECHA_DWH'] = pd.to_datetime(df['Fecha_Retención']).dt.strftime('%Y%m%d')
  ```

- **Manejo de duplicados:** El manejo de duplicados puede ser complejo en PAD. Considerar:
  1. **Opción A (Manual asistida):** Identificar duplicados y notificar al usuario para revisión manual
  2. **Opción B (Automática):** Usar Python pandas con groupby para unificar automáticamente
  3. **Opción C (Híbrida):** Unificar casos simples automáticamente, notificar casos complejos

- **Dependencia externa:** Esta HU depende de un archivo externo que debe ser proporcionado. Implementar verificación al inicio del proceso completo.

### Consideraciones de Negocio

- **Criticidad de retenidos:** Los créditos con retención de tasa son importantes para el banco (clientes preferenciales). Los datos deben ser exactos.

- **Dobles retenciones:** Es normal que algunos clientes tengan doble retención en el mes (mejora progresiva de condiciones). El proceso debe manejar esto correctamente.

- **Tasas nominales:** Se deben calcular después las tasas nominales (efectiva a nominal) en HU posteriores.

### Riesgos Identificados

- **Riesgo 1: Archivo externo no disponible**
  - Impacto: Alto - Detiene todo el proceso
  - Mitigación: Notificar al inicio del proceso si falta. Coordinación con área que genera el reporte. Considerar plan de contingencia con SQL (script 02_Contingencia).

- **Riesgo 2: Cambio en estructura del archivo externo**
  - Impacto: Alto - Las columnas no coinciden
  - Mitigación: Validar estructura de columnas antes de procesar. Implementar mapeo flexible de columnas.

- **Riesgo 3: Transformación incorrecta de fechas**
  - Impacto: Alto - Datos inválidos en pasos posteriores
  - Mitigación: Validación exhaustiva del formato. Casos de prueba con diferentes formatos de fecha. Usar librería robusta de fechas (Python datetime o pandas).

- **Riesgo 4: Duplicados no identificados**
  - Impacto: Medio - Sobrevaloración de amortización
  - Mitigación: Implementar validación de unicidad antes de continuar a HU-08. Query SQL para verificar duplicados.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 10/11/2025
