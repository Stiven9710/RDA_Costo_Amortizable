# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 09 |
| **Nombre Historia** | Organizar Base de Modificados para Cargue SQL |
| **No. Versión** | 1 |
| **Fecha Creación** | 10/11/2025 17:00 |
| **Fecha Modificación** | 10/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Organizar y marcar la información de las pestañas "2. Consolidadas Modificadas" y "4. Modificados totales" en la pestaña "7. Modificados"

**De forma que:** Tenga una base lista para cargar en SQL con todas las marcas y clasificaciones necesarias para créditos modificados

---

## Criterios de Aceptación

### Insumos

1. **Archivo Excel:** `01. información Consolidada MM_AAAA.xlsx` (con HU-08 completada)
2. **Pestaña fuente 1:** "2. Consolidadas Modificadas" (de HU-04)
3. **Pestaña fuente 2:** "4. Modificados totales" (de HU-06)
4. **Pestaña destino:** "7. Modificados" (limpia, solo con encabezados)

### Entradas de las Funcionalidades

- Datos consolidados de modificados con columnas dinámicas
- Detalle de modificados totales con indicador de tipo
- Estructura predefinida en pestaña destino

### Funcionalidades

1. **Validar archivo Excel abierto**
   
   - Verificar que Excel sigue abierto desde HU-08
   - Si está cerrado, abrir `01. información Consolidada MM_AAAA.xlsx`
   - Activar pestaña "7. Modificados"

2. **Copiar obligaciones desde "2. Consolidadas Modificadas"**
   
   - Ir a pestaña "2. Consolidadas Modificadas"
   - Seleccionar desde columna E hasta la última columna de obligaciones poblada
   - Copiar el rango completo (solo datos, sin encabezados)

3. **Pegar obligaciones en "7. Modificados"**
   
   - Volver a pestaña "7. Modificados"
   - Posicionar en columna H (primera columna de obligaciones)
   - Pegar las obligaciones copiadas
   - Las columnas H, I, J, etc. contendrán las obligaciones modificadas

4. **Poblar columna A (Fecha)**
   
   - En pestaña "7. Modificados", columna A "Fecha"
   - Llenar todas las filas con la fecha del último día del mes
   - Formato: AAAAMMDD (ej: 20250430)
   - Usar autocompletar hasta la última fila con datos

5. **Poblar columnas E, F y G con metadatos de modificados consolidados**
   
   Para las filas de consolidadas:
   - **Columna E (Herramienta):** "Modificado"
   - **Columna F (Tipo_Herramienta):** "Consolidada"
   - **Columna G (Tipo_Obligacion):** "Diferente Obligación"
   
   Aplicar a todas las filas que provienen de la pestaña 2

6. **Filtrar y obtener modificados individuales**
   
   - Ir a pestaña "4. Modificados totales"
   - Aplicar filtro en columna C
   - Seleccionar solo registros donde columna C = "1" (individuales)
   - Estos representan modificaciones de obligaciones individuales

7. **Copiar obligaciones individuales (columna C)**
   
   - Con el filtro activo (C=1)
   - Seleccionar columna C (obligación modificada)
   - Copiar la columna

8. **Pegar obligaciones individuales en "7. Modificados"**
   
   - Volver a pestaña "7. Modificados"
   - Posicionarse en la primera fila vacía (después de consolidadas)
   - Pegar en columna H
   - **Pegar nuevamente en columna I** (la misma obligación en ambas columnas)
   - Nota: En modificados individuales, la obligación nueva es la misma que la anterior (modificación sobre misma obligación)

9. **Poblar metadatos para modificados individuales**
   
   Para las filas de individuales recién pegadas:
   - **Columna A (Fecha):** Fecha del mes
   - **Columna E (Herramienta):** "Modificado"
   - **Columna F (Tipo_Herramienta):** "Individual"
   - **Columna G (Tipo_Obligacion):** "Misma Obligación"
   
   > **Nota:** En modificados individuales, siempre es "Misma Obligación" porque se modifica la obligación existente sin cambiar el número

10. **Reemplazar NULLs por vacío**
    
    - Buscar todas las celdas con "NULL" en el rango de datos
    - Reemplazar por vacío (celda en blanco)
    - Usar función "Buscar y reemplazar" de Excel

11. **Validar estructura final**
    
    - Verificar que todas las filas tienen:
      - Columna A (Fecha) poblada
      - Columnas E, F, G (metadatos) pobladas correctamente
      - Columna H (obligacion_nueva) poblada
      - Para individuales: columnas H e I con el mismo valor
    - Contar registros totales

12. **Guardar cambios**
    
    - Guardar el archivo Excel
    - Mantener abierto para HU-10
    - Registrar estadísticas en log

### Puntos de Control Crítico

1. **Validación de pestañas fuente:** Si pestañas 2 o 4 están vacías, validar si es normal (mes sin modificados) o error.

2. **Validación de filtro:** Si el filtro C=1 en pestaña 4 retorna 0 registros, puede ser válido (solo consolidadas).

3. **Validación de columna H:** Todos los registros deben tener obligacion_nueva poblada.

4. **Validación de individuales:** Para individuales, columnas H e I deben ser iguales (misma obligación).

### Puntos de Control No Crítico

1. **Sin modificados:** Si el mes no tiene modificados, registrar advertencia y continuar con pestaña vacía.

2. **Solo un tipo:** Es válido tener solo consolidadas o solo individuales en un mes.

### Salidas

1. **Pestaña poblada:** "7. Modificados" con:
   - Columna A: Fecha
   - Columnas E, F, G: Herramienta, Tipo_Herramienta, Tipo_Obligacion
   - Columna H en adelante: Obligaciones modificadas
   - Registros clasificados correctamente

2. **Archivo guardado:** Excel actualizado con 2 pestañas organizadas (6 y 7)

3. **Log:** `logs/ejecuciones/HU09_Organizar_Modificados_AAAAMMDD_HHMMSS.log`

### Reportería

Log con:
- Número de modificados consolidados
- Número de modificados individuales
- Total de registros en pestaña 7
- Validaciones exitosas

### Parametría

- **Pestaña fuente 1:** `2. Consolidadas Modificadas` (configurable)
- **Pestaña fuente 2:** `4. Modificados totales` (configurable)
- **Pestaña destino:** `7. Modificados` (configurable)
- **Valor filtro individuales:** `1` en columna C (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-04:** Consolidadas Modificadas poblada
- **HU-06:** Modificados totales poblada
- **HU-08:** Excel abierto

### Historias de Usuario Posteriores
- **HU-11:** Cargue SQL - Usará la pestaña 7 organizada

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 3.5 horas |
| Desarrollo Python (opcional) | 1.5 horas |
| Pruebas unitarias | 1 hora |
| Pruebas integradas | 1 hora |
| **Total** | **7 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **Similitud con HU-08:** Esta HU es muy similar a HU-08, con la diferencia de que los modificados individuales siempre son "Misma Obligación" (la obligación se modifica pero mantiene el número).

- **Duplicación de columna:** Para individuales, copiar la misma obligación en H e I para mantener consistencia de estructura con reestructurados.

### Consideraciones de Negocio

- **Modificados vs Reestructurados:** Los modificados son cambios en condiciones (tasa, plazo) sin consolidar obligaciones. Por eso individuales siempre son "Misma Obligación".

### Riesgos Identificados

- **Riesgo 1: Confusión con reestructurados**
  - Impacto: Medio - Clasificación incorrecta
  - Mitigación: Validar que se está procesando la pestaña correcta. Verificar que individuales tienen H=I.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 10/11/2025
