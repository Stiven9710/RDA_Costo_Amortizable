# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 08 |
| **Nombre Historia** | Organizar Base de Reestructurados para Cargue SQL |
| **No. Versión** | 1 |
| **Fecha Creación** | 10/11/2025 16:30 |
| **Fecha Modificación** | 10/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Organizar y marcar la información de las pestañas "1. Consolidadas Reestructuradas" y "3. Reestructurados totales" en la pestaña "6. Reestructurados"

**De forma que:** Tenga una base lista para cargar en SQL con todas las marcas y clasificaciones necesarias (Herramienta, Tipo_Herramienta, Tipo_Obligación)

---

## Criterios de Aceptación

### Insumos

1. **Archivo Excel:** `01. información Consolidada MM_AAAA.xlsx` con pestañas 1 y 3 pobladas
2. **Pestaña fuente 1:** "1. Consolidadas Reestructuradas" (de HU-03)
3. **Pestaña fuente 2:** "3. Reestructurados totales" (de HU-05)
4. **Pestaña destino:** "6. Reestructurados" (limpia, solo con encabezados)

### Entradas de las Funcionalidades

- Datos consolidados de reestructurados con columnas dinámicas de obligaciones
- Detalle de reestructurados totales con indicador de tipo (consolidada/individual)
- Estructura predefinida en pestaña destino para organización

### Funcionalidades

1. **Abrir archivo de consolidación**
   
   - Abrir `01. información Consolidada MM_AAAA.xlsx`
   - Modo no visible para optimizar rendimiento
   - Activar pestaña "6. Reestructurados"

2. **Copiar obligaciones desde "1. Consolidadas Reestructuradas"**
   
   - Ir a pestaña "1. Consolidadas Reestructuradas"
   - Seleccionar desde columna E hasta la última columna de obligaciones que tenga datos
   - Columnas típicas: E, F, G, H, I... hasta obligacionN
   - Copiar el rango seleccionado (solo datos, sin encabezados)

3. **Pegar obligaciones en "6. Reestructurados"**
   
   - Volver a pestaña "6. Reestructurados"
   - Posicionar en columna H (primera columna de obligaciones en destino)
   - Pegar las obligaciones copiadas
   - Las columnas H, I, J, K, ... contendrán: obligacion1, obligacion2, obligacion3, etc.

4. **Poblar columna A (Fecha)**
   
   - En pestaña "6. Reestructurados", columna A "Fecha"
   - Llenar todas las filas con la fecha del último día del mes que se está trabajando
   - Formato: AAAAMMDD (ej: 20250430 para abril 2025)
   - Usar autocompletar hasta la última fila con datos

5. **Poblar columnas E, F y G con metadatos de reestructurados consolidados**
   
   Para todas las filas que provienen de consolidadas (primera parte):
   - **Columna E (Herramienta):** "Reestructurado"
   - **Columna F (Tipo_Herramienta):** "Consolidada"
   - **Columna G (Tipo_Obligacion):** "Diferente Obligación"
   
   Usar autocompletar o fórmula para poblar hasta donde hay datos consolidados

6. **Filtrar y obtener reestructurados individuales**
   
   - Ir a pestaña "3. Reestructurados totales"
   - Aplicar filtro en columna C
   - Seleccionar solo registros donde columna C = "1" (individuales)
   - Estos representan reestructuraciones de una sola obligación (no consolidadas)

7. **Copiar obligaciones individuales (columnas E y F)**
   
   - Con el filtro activo (C=1)
   - Seleccionar columna E (obligación nueva) y columna F (obligación anterior)
   - Copiar las dos columnas

8. **Pegar obligaciones individuales en "6. Reestructurados"**
   
   - Volver a pestaña "6. Reestructurados"
   - Posicionarse en la primera fila vacía (después de los consolidados)
   - Pegar en columnas H e I
   - Nota: Los individuales solo tienen 2 columnas (nueva y anterior)

9. **Poblar metadatos para reestructurados individuales**
   
   Para las filas de individuales recién pegadas:
   - **Columna A (Fecha):** Fecha del mes (copiar de filas anteriores)
   - **Columna E (Herramienta):** "Reestructurado"
   - **Columna F (Tipo_Herramienta):** "Individual"
   - **Columna G (Tipo_Obligacion):** Depende del caso:
     - Si obligacion_nueva = obligacion1 (columna H = columna I): "Misma Obligación"
     - Si obligacion_nueva ≠ obligacion1 (columna H ≠ columna I): "Diferente Obligación"

10. **Distinguir entre Misma y Diferente Obligación**
    
    Lógica de clasificación:
    
    - **Misma Obligación:** La reestructuración se hizo sobre la misma obligación (número no cambió)
      - Ejemplo: Obligación 33011547244 se reestructuró y sigue siendo 33011547244
      - En este caso, dejar columna I (obligacion1) vacía
    
    - **Diferente Obligación:** La reestructuración generó un nuevo número de obligación
      - Ejemplo: Obligación anterior 30013200814 → nueva 30019544024
      - En este caso, columna H tiene la nueva, columna I tiene la anterior
    
    **Tabla de combinaciones posibles:**
    
    | Herramienta | Tipo_Herramienta | Tipo_Obligacion | Obligacion_Nueva (H) | Obligacion1 (I) | Obligacion2 (J) |
    |-------------|------------------|-----------------|----------------------|-----------------|-----------------|
    | Reestructurado | Consolidada | Diferente Obligación | 30019544025 | 30013200815 | 30013200816 |
    | Reestructurado | Individual | Misma Obligación | 33011547244 | [vacío] | [vacío] |
    | Reestructurado | Individual | Diferente Obligación | 30019544024 | 30013200814 | [vacío] |

11. **Ajustar columnas de obligaciones según tipo**
    
    - Para "Misma Obligación": Dejar obligacion1 vacía (eliminar el contenido de columna I si es igual a H)
    - Para "Diferente Obligación": Mantener todas las obligaciones anteriores pobladas
    - Validar que la lógica se aplicó correctamente

12. **Reemplazar NULLs por vacío**
    
    - Buscar todas las celdas con "NULL" en el rango de datos
    - Reemplazar por vacío (celda en blanco)
    - Esto es necesario para que SQL no tenga problemas al cargar
    - Usar función "Buscar y reemplazar" de Excel

13. **Validar estructura final**
    
    - Verificar que todas las filas tienen:
      - Columna A (Fecha) poblada
      - Columnas E, F, G (metadatos) pobladas correctamente
      - Al menos columna H (obligacion_nueva) poblada
      - Columnas de obligaciones anteriores según corresponda
    - Contar registros: consolidados + individuales
    - El total debe coincidir con suma de registros originales

14. **Guardar cambios**
    
    - Guardar el archivo Excel
    - Mantener abierto para HU-09
    - Registrar estadísticas en log

### Puntos de Control Crítico

1. **Validación de pestañas fuente:** Si pestañas 1 o 3 están vacías o no existen, detener el proceso.

2. **Validación de filtro:** Si el filtro C=1 en pestaña 3 retorna 0 registros, puede ser válido (no hubo individuales) o error. Validar con usuario.

3. **Validación de clasificación:** Si hay registros que no se pueden clasificar en "Misma" o "Diferente", detener y requerir revisión manual.

4. **Validación de columna H:** Todos los registros deben tener obligacion_nueva. Si hay vacíos, detener.

### Puntos de Control No Crítico

1. **Solo consolidadas o solo individuales:** Es válido tener solo uno de los dos tipos en un mes específico. Registrar advertencia.

2. **Alto número de obligaciones:** Si alguna consolidación tiene > 10 obligaciones anteriores, registrar advertencia (caso especial).

### Salidas

1. **Pestaña poblada:** "6. Reestructurados" en archivo Excel con:
   - Columna A: Fecha
   - Columnas E, F, G: Herramienta, Tipo_Herramienta, Tipo_Obligacion
   - Columna H en adelante: Obligación nueva y obligaciones anteriores
   - Registros clasificados y marcados correctamente

2. **Archivo guardado:** Excel actualizado

3. **Log:** `logs/ejecuciones/HU08_Organizar_Reestructurados_AAAAMMDD_HHMMSS.log`

### Reportería

Log con:
- Número de reestructurados consolidados organizados
- Número de reestructurados individuales organizados
- Distribución por tipo (Misma vs Diferente Obligación)
- Total de registros en pestaña 6
- Validaciones exitosas

### Parametría

- **Pestaña fuente 1:** `1. Consolidadas Reestructuradas` (configurable)
- **Pestaña fuente 2:** `3. Reestructurados totales` (configurable)
- **Pestaña destino:** `6. Reestructurados` (configurable)
- **Valor filtro individuales:** `1` en columna C (configurable)
- **Formato fecha:** AAAAMMDD (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-03:** Consolidadas Reestructuradas poblada
- **HU-05:** Reestructurados totales poblada

### Historias de Usuario Posteriores
- **HU-11:** Cargue SQL - Usará la pestaña 6 organizada

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 5 horas |
| Desarrollo Python (clasificación lógica) | 2 horas |
| Pruebas unitarias | 1.5 horas |
| Pruebas integradas | 1.5 horas |
| **Total** | **10 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **Lógica de clasificación compleja:** La distinción entre "Misma" y "Diferente" obligación requiere comparación de columnas. Python con pandas simplifica esto:
  ```
  df['Tipo_Obligacion'] = df.apply(lambda row: 'Misma Obligación' if row['H'] == row['I'] else 'Diferente Obligación', axis=1)
  ```

- **Manejo de columnas dinámicas:** El número de columnas de obligaciones varía. El código debe ser flexible.

### Consideraciones de Negocio

- **Importancia de clasificación:** La clasificación correcta impacta los cálculos de amortización. Errores aquí se propagan a todo el proceso.

### Riesgos Identificados

- **Riesgo 1: Clasificación incorrecta**
  - Impacto: Alto - Cálculos erróneos
  - Mitigación: Validación cruzada con usuario en primeras ejecuciones. Implementar reglas de negocio claras.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 10/11/2025
