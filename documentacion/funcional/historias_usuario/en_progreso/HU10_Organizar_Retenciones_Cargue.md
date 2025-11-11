# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 10 |
| **Nombre Historia** | Organizar Base de Retenciones para Cargue SQL |
| **No. Versión** | 1 |
| **Fecha Creación** | 10/11/2025 17:15 |
| **Fecha Modificación** | 10/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Organizar la información de la pestaña "5. Retenidos" en la pestaña "8. Retenidos" con las marcas y clasificaciones necesarias

**De forma que:** Tenga una base lista para cargar en SQL con la estructura estandarizada para retenciones

---

## Criterios de Aceptación

### Insumos

1. **Archivo Excel:** `01. información Consolidada MM_AAAA.xlsx` (con HU-08 y HU-09 completadas)
2. **Pestaña fuente:** "5. Retenidos" (de HU-07)
3. **Pestaña destino:** "8. Retenidos" (limpia, solo con encabezados)

### Entradas de las Funcionalidades

- Datos de créditos con retención de tasa en pestaña 5
- Columna C con números de obligación (N_Obligación)
- Estructura predefinida en pestaña destino

### Funcionalidades

1. **Validar archivo Excel**
   
   - Verificar que Excel sigue abierto desde HU-09
   - Si está cerrado, abrir `01. información Consolidada MM_AAAA.xlsx`
   - Activar pestaña "8. Retenidos"

2. **Copiar columna C (N_Obligación) de "5. Retenidos"**
   
   - Ir a pestaña "5. Retenidos"
   - Seleccionar columna C "N_Obligación"
   - Copiar todos los datos (sin encabezado)
   - Registrar cantidad de registros

3. **Pegar obligaciones en "8. Retenidos"**
   
   - Volver a pestaña "8. Retenidos"
   - Posicionar en columna H (obligacion_nueva)
   - Pegar las obligaciones copiadas
   - Estas serán las únicas obligaciones (sin obligaciones anteriores)

4. **Poblar columna A (Fecha_Corte)**
   
   - En pestaña "8. Retenidos", columna A "Fecha_Corte"
   - Llenar todas las filas con la fecha del último día del mes
   - Formato: AAAAMMDD (ej: 20250430)
   - Usar autocompletar hasta la última fila con datos

5. **Poblar columnas E, F y G con metadatos de retenciones**
   
   Para TODAS las filas de retenciones:
   - **Columna E (Herramienta):** "Retención"
   - **Columna F (Tipo_Herramienta):** "Individual"
   - **Columna G (Tipo_Obligacion):** "Misma Obligación"
   
   > **Importante:** Las retenciones SIEMPRE son:
   > - Individual (no se consolidan obligaciones)
   > - Misma Obligación (la retención se aplica sobre la misma obligación existente)
   
   Aplicar a todas las filas con datos

6. **Dejar columna I (obligacion1) vacía**
   
   - La columna I (obligacion1) debe permanecer vacía
   - Esto indica que no hay obligación anterior (es la misma)
   - No copiar ni poblar esta columna para retenciones

7. **Validar que solo columna H tiene datos de obligación**
   
   - Verificar que columna H (obligacion_nueva) tiene datos
   - Verificar que columna I (obligacion1) está vacía
   - Verificar que no hay datos en columnas J, K, etc.

8. **Reemplazar NULLs por vacío**
   
   - Buscar todas las celdas con "NULL" en el rango de datos
   - Reemplazar por vacío (celda en blanco)
   - Usar función "Buscar y reemplazar" de Excel

9. **Validar estructura final**
   
   - Verificar que todas las filas tienen:
      - Columna A (Fecha_Corte) poblada
      - Columna E: "Retención"
      - Columna F: "Individual"
      - Columna G: "Misma Obligación"
      - Columna H (obligacion_nueva) poblada
      - Columna I y siguientes: vacías
   - Contar registros totales

10. **Nota sobre columnas adicionales**
    
    Las columnas Tipo_Id, Modalidad, Numero_Id se llenarán posteriormente en HU-12 cuando se haga el cruce con la tabla de definitivos en SQL. Por ahora deben permanecer vacías.

11. **Guardar y cerrar Excel**
    
    - Guardar todos los cambios
    - Cerrar el archivo Excel (ya no se necesita abierto)
    - Liberar recursos
    - Con esto se completan las 3 pestañas organizadas (6, 7, 8)

12. **Registrar estadísticas finales**
    
    - Registros en pestaña 8. Retenidos
    - Total de registros en pestañas 6 + 7 + 8
    - Resumen de Sprint 2 - Fase de organización
    - Timestamp de finalización

### Puntos de Control Crítico

1. **Validación de pestaña 5:** Si está vacía, validar si es normal (mes sin retenciones) o error.

2. **Validación de obligaciones:** Todas deben estar en columna H únicamente. Si hay datos en I, J, etc., es error.

3. **Validación de metadatos:** Todas las retenciones deben tener exactamente: Retención + Individual + Misma Obligación.

4. **Validación de unicidad:** Verificar que no hay obligaciones duplicadas (debieron eliminarse en HU-07).

### Puntos de Control No Crítico

1. **Sin retenciones:** Si la pestaña 5 está vacía (mes sin retenciones de tasa), registrar advertencia y continuar con pestaña 8 vacía.

2. **Bajo volumen:** Las retenciones suelen ser menos frecuentes. Un número bajo es normal.

### Salidas

1. **Pestaña poblada:** "8. Retenidos" con:
   - Columna A: Fecha_Corte
   - Columnas E, F, G: Retención, Individual, Misma Obligación (todas iguales)
   - Columna H: N_Obligación
   - Columnas I en adelante: vacías
   - Sin duplicados

2. **Archivo cerrado:** Excel completamente procesado con:
   - 5 pestañas de datos fuente (1-5)
   - 3 pestañas organizadas para SQL (6-8)

3. **Log:** `logs/ejecuciones/HU10_Organizar_Retenciones_AAAAMMDD_HHMMSS.log`

4. **Log consolidado Sprint 2:** Resumen de HU-08, HU-09, HU-10

### Reportería

Log con:
- Número de retenciones organizadas
- Confirmación de metadatos correctos
- Total de registros en las 3 pestañas organizadas (6+7+8)
- Validación de estructura final
- Tiempo total de organización (HU-08 a HU-10)

### Parametría

- **Pestaña fuente:** `5. Retenidos` (configurable)
- **Pestaña destino:** `8. Retenidos` (configurable)
- **Valores fijos:**
  - Herramienta: `Retención`
  - Tipo_Herramienta: `Individual`
  - Tipo_Obligacion: `Misma Obligación`

---

## Dependencias

### Historias de Usuario Previas
- **HU-07:** Retenidos consolidados y limpiados
- **HU-08, HU-09:** Excel abierto y pestañas 6-7 completadas

### Historias de Usuario Posteriores
- **HU-11:** Cargue SQL - Usará la pestaña 8 organizada
- **HU-12:** Validación SQL - Llenará campos faltantes (Tipo_Id, Modalidad, Numero_Id)

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 2.5 horas |
| Desarrollo Python (opcional) | 1 hora |
| Pruebas unitarias | 1 hora |
| Pruebas integradas | 1 hora |
| **Total** | **5.5 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **HU más simple del Sprint 2:** Esta es la HU más sencilla de organización porque todas las retenciones tienen la misma clasificación (Retención + Individual + Misma Obligación).

- **Solo una columna de obligación:** A diferencia de reestructurados y modificados, las retenciones solo tienen la obligación actual, sin obligaciones anteriores.

- **Cierre de Excel:** Con esta HU se cierra el archivo Excel, marcando el fin de la fase de organización en Excel. Las siguientes HU trabajarán con SQL.

### Consideraciones de Negocio

- **Retenciones como beneficio:** Las retenciones de tasa son un beneficio que el banco otorga a clientes (reducción de tasa de interés), no reestructuraciones ni modificaciones de deuda.

- **Misma obligación siempre:** El crédito mantiene su número de obligación, solo cambia la tasa.

- **Campos que se llenan en SQL:** Los campos Tipo_Id, Modalidad, Numero_Id se obtienen de un cruce con la tabla de clientes en SQL (HU-12).

### Riesgos Identificados

- **Riesgo 1: Duplicados no eliminados en HU-07**
  - Impacto: Medio - Sobrevaloración de cálculos
  - Mitigación: Validar unicidad de obligaciones. Si hay duplicados, detener y volver a HU-07.

- **Riesgo 2: Archivo Excel no se cierra**
  - Impacto: Bajo - Archivo bloqueado para HU-11
  - Mitigación: Usar bloque Finally para garantizar cierre. Validar que archivo no tiene lock.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 10/11/2025
