# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 04 |
| **Nombre Historia** | Consolidar Modificados desde SQL a Excel |
| **No. Versión** | 1 |
| **Fecha Creación** | 10/11/2025 15:15 |
| **Fecha Modificación** | 10/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Ejecutar el query "2-Consolidadas Modificadas" en SQL y copiar los resultados a la pestaña correspondiente del archivo Excel

**De forma que:** Tenga consolidada la información de créditos modificados en el archivo de trabajo mensual

---

## Criterios de Aceptación

### Insumos

1. **Tablas temporales SQL activas:** `#Base` y `#Base2` (misma sesión de HU-01)
2. **Archivo Excel abierto:** `01. información Consolidada MM_AAAA.xlsx` (instancia de HU-03)
3. **Script SQL:** Sección "2-Consolidadas Modificadas" del query
4. **Conexión SQL activa:** Servidor `10.1.3.101\SCC`

### Entradas de las Funcionalidades

- Tablas temporales con información de créditos modificados
- Excel con instancia activa y pestaña HU-03 ya completada
- Query SQL específico para extraer modificaciones consolidadas

### Funcionalidades

1. **Verificar que Excel y SQL siguen activos**
   
   - Validar que la instancia de Excel de HU-03 sigue abierta
   - Validar que la sesión SQL sigue activa
   - Si alguno está cerrado, re-ejecutar desde el punto necesario

2. **Seleccionar y ejecutar el query "2-Consolidadas Modificadas"**
   
   - Ubicar la sección "2-Consolidadas Modificadas" en el script SQL
   - Ejecutar la sentencia SELECT
   - El query extrae:
     - Obligación nueva modificada
     - Obligaciones anteriores
     - Fecha de modificación
     - Tipo de modificación
     - Montos y tasas modificadas
   
3. **Copiar resultados del query**
   
   - Seleccionar todos los registros retornados
   - Copiar el conjunto completo
   - Registrar cantidad de registros en log

4. **Ubicar la pestaña "2. Consolidadas Modificadas" en Excel**
   
   - Activar la pestaña en el workbook ya abierto
   - Verificar que existe y está limpia
   - Confirmar encabezados presentes

5. **Pegar los resultados en la pestaña**
   
   - Posicionar cursor en celda A2
   - Pegar resultados de SQL
   - Mantener formatos apropiados
   - No sobrescribir encabezados

6. **Validar el pegado**
   
   - Contar filas pegadas
   - Comparar con registros SQL
   - Verificar integridad de datos críticos

7. **Guardar cambios en Excel**
   
   - Guardar el archivo
   - Mantener Excel abierto para HU-05
   - Registrar timestamp

8. **Registrar operación en log**
   
   - Cantidad de registros procesados
   - Validaciones exitosas
   - Tiempo de ejecución

### Puntos de Control Crítico

1. **Validación de sesión SQL:** Si no está activa, detener y re-ejecutar desde HU-01.

2. **Validación de query:** Si retorna error o 0 registros sin justificación (puede haber meses sin modificados), detener y notificar.

3. **Validación de pestaña Excel:** Si no existe, detener. Problema en plantilla.

4. **Validación de integridad:** Si registros SQL ≠ filas Excel, detener.

### Puntos de Control No Crítico

1. **Sin datos:** Si el query retorna 0 registros y es justificado (mes sin modificaciones), registrar advertencia y continuar.

2. **Alto volumen:** Si registros > 5,000, advertir sobre tiempo de procesamiento.

### Salidas

1. **Pestaña Excel poblada:** "2. Consolidadas Modificadas" con todos los créditos modificados
2. **Archivo guardado:** Excel actualizado
3. **Log:** `logs/ejecuciones/HU04_Consolidar_Modificados_AAAAMMDD_HHMMSS.log`

### Reportería

Log con registros procesados, validaciones y tiempos de ejecución.

### Parametría

- **Nombre pestaña:** `2. Consolidadas Modificadas` (configurable)
- **Celda inicial:** `A2` (configurable)
- **Timeout query:** 5 minutos (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-01:** Tablas temporales activas
- **HU-02:** Archivo Excel preparado
- **HU-03:** Excel abierto con instancia activa

### Historias de Usuario Posteriores
- **HU-09:** Organizar Modificados - Usará estos datos consolidados

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 2 horas |
| Desarrollo Python (opcional) | 0.5 horas |
| Pruebas unitarias | 0.5 horas |
| Pruebas integradas | 1 hora |
| **Total** | **4 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **Similitud con HU-03:** Esta HU es casi idéntica a HU-03, cambiando solo la pestaña y el query. Considerar crear un subflow reutilizable en PAD.

- **Optimización:** Se puede paralelizar la ejecución de queries HU-03 a HU-06 si el servidor SQL lo permite, reduciendo tiempo total.

### Consideraciones de Negocio

- **Variabilidad:** Algunos meses pueden tener 0 modificados (es normal), otros pueden tener miles. El proceso debe manejar ambos casos.

### Riesgos Identificados

- **Riesgo 1: Confusión entre reestructurados y modificados**
  - Impacto: Alto - Datos incorrectos
  - Mitigación: Validar que se está ejecutando el query correcto ("2-Consolidadas Modificadas")

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 10/11/2025
