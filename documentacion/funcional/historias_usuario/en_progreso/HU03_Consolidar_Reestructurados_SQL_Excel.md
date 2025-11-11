# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 03 |
| **Nombre Historia** | Consolidar Reestructurados desde SQL a Excel |
| **No. Versión** | 1 |
| **Fecha Creación** | 10/11/2025 15:00 |
| **Fecha Modificación** | 10/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Ejecutar el query "1-Consolidadas Reestructuradas" en SQL y copiar los resultados a la pestaña correspondiente del archivo Excel

**De forma que:** Tenga consolidada la información de créditos reestructurados en el archivo de trabajo mensual

---

## Criterios de Aceptación

### Insumos

1. **Tablas temporales SQL activas:** `#Base` y `#Base2` creadas en HU-01 (conexión SQL aún abierta)
2. **Archivo Excel:** `01. información Consolidada MM_AAAA.xlsx` preparado en HU-02
3. **Script SQL:** Sección "1-Consolidadas Reestructuradas" del query ejecutado en HU-01
4. **Conexión SQL:** Servidor `10.1.3.101\SCC` - Base de datos `DWH_CC`

### Entradas de las Funcionalidades

- Tablas temporales `#Base` con columnas dinámicas de obligaciones (obligacion1, obligacion2, ..., obligacionN)
- Tabla temporal `#Base2` con detalle de obligaciones por posición
- Estructura de pestaña Excel con encabezados predefinidos

### Funcionalidades

1. **Validar que la conexión SQL sigue activa**
   
   El asistente debe verificar que la sesión SQL de HU-01 sigue abierta y las tablas temporales `#Base` y `#Base2` aún existen. Si la sesión se cerró, re-ejecutar HU-01 completa.

2. **Seleccionar y ejecutar el query "1-Consolidadas Reestructuradas"**
   
   - Ubicar la sección del script SQL identificada como "1-Consolidadas Reestructuradas"
   - Ejecutar la sentencia SELECT completa
   - El query debe extraer:
     - Obligación nueva
     - Obligaciones anteriores consolidadas (columnas dinámicas)
     - Fecha de reestructuración
     - Tipo de herramienta
     - Otros campos relevantes
   
3. **Copiar los resultados del query**
   
   - Seleccionar todos los registros retornados por el query (sin incluir encabezados SQL)
   - Copiar el conjunto de resultados completo
   - Registrar en log la cantidad de registros obtenidos
   
4. **Abrir el archivo Excel de consolidación**
   
   Utilizando Power Automate Desktop:
   - Abrir el archivo creado en HU-02: `01. información Consolidada MM_AAAA.xlsx`
   - Modo no visible (background)
   - Mantener instancia de Excel activa

5. **Ubicar la pestaña "1. Consolidadas Reestructuradas"**
   
   - Activar la pestaña específica en el workbook
   - Verificar que la pestaña existe
   - Verificar que la pestaña está limpia (solo encabezados)

6. **Pegar los resultados en la pestaña**
   
   - Posicionar el cursor en la celda A2 (primera celda de datos, debajo de encabezados)
   - Pegar los resultados copiados de SQL
   - Mantener formato de datos (números, fechas)
   - No pegar encabezados (ya existen en el Excel)

7. **Validar el pegado de información**
   
   - Contar el número de filas pegadas en Excel
   - Comparar con el número de registros del query SQL
   - Deben coincidir exactamente
   - Verificar que no hay celdas vacías en columnas críticas (obligación nueva)

8. **Ajustar formato si es necesario**
   
   - Verificar que las columnas numéricas tienen formato numérico
   - Verificar que las fechas tienen formato de fecha
   - Autoajustar ancho de columnas si es necesario para visualización

9. **Guardar el archivo Excel**
   
   - Guardar los cambios en el archivo
   - No cerrar Excel (mantener abierto para HU-04)
   - Registrar timestamp de guardado

10. **Registrar estadísticas en log**
    
    - Número de registros copiados de SQL
    - Número de filas pegadas en Excel
    - Nombre de la pestaña procesada
    - Timestamp de finalización
    - Confirmación de validación exitosa

### Puntos de Control Crítico

1. **Validación de tablas temporales:** Si las tablas `#Base` o `#Base2` no existen, detener el proceso y notificar. Requiere re-ejecución de HU-01.

2. **Validación de query exitoso:** Si el query retorna error o 0 registros, detener y notificar. Puede indicar problema en los datos o en el script SQL.

3. **Validación de pestaña Excel:** Si la pestaña "1. Consolidadas Reestructuradas" no existe en el archivo, detener el proceso. La plantilla puede estar corrupta.

4. **Validación de coincidencia de registros:** Si el número de registros SQL no coincide con las filas pegadas en Excel, detener y notificar. Puede indicar problema en el pegado.

### Puntos de Control No Crítico

1. **Advertencia de alto volumen:** Si el número de registros es mayor a 10,000, registrar advertencia de alto volumen (tiempo de procesamiento mayor).

2. **Advertencia de formato:** Si se detectan inconsistencias en formatos de celdas, registrar advertencia pero continuar.

3. **Advertencia de columnas dinámicas:** Si el número de columnas de obligación es diferente al esperado, registrar advertencia (puede ser normal según el mes).

### Salidas

1. **Pestaña Excel poblada:** "1. Consolidadas Reestructuradas" en archivo `01. información Consolidada MM_AAAA.xlsx` con todos los registros de créditos reestructurados consolidados

2. **Archivo guardado:** Excel con la primera pestaña de datos completada

3. **Archivo de log:** `logs/ejecuciones/HU03_Consolidar_Reestructuradas_AAAAMMDD_HHMMSS.log`

### Reportería

**Log de ejecución** que incluye:
- Cantidad de registros obtenidos del query SQL
- Cantidad de filas pegadas en Excel
- Tiempo de ejecución del query
- Tiempo total de procesamiento
- Confirmación de validaciones

### Parametría

- **Nombre de pestaña Excel:** `1. Consolidadas Reestructuradas` (configurable)
- **Celda inicial de pegado:** `A2` (configurable)
- **Timeout de query:** 5 minutos (configurable)
- **Excel en modo visible:** `No` (configurable para debug)
- **Autoguardado:** `Sí` después de pegar (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-01:** Extracción DWH - Requiere que las tablas temporales estén activas
- **HU-02:** Preparación Excel - Requiere el archivo limpio y listo

### Historias de Usuario Posteriores
- **HU-08:** Organizar Reestructurados - Utilizará los datos consolidados en esta pestaña

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 2.5 horas |
| Desarrollo Python (opcional) | 0.5 horas |
| Pruebas unitarias | 0.5 horas |
| Pruebas integradas | 0.5 horas |
| **Total** | **4 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **Sesión SQL persistente:** Es crítico que la sesión SQL de HU-01 se mantenga abierta hasta completar HU-06. No cerrar la conexión entre estas historias.

- **Manejo de Excel:** Usar las acciones nativas de Excel de PAD para mejor rendimiento. Alternativamente, se puede usar Python con `openpyxl` o `pyodbc` + `pandas` para operación directa SQL→Excel.

- **Tamaño de datos:** Los registros típicos oscilan entre 1,000 y 3,000. Si es mayor, considerar procesamiento por lotes.

- **Columnas dinámicas:** El número de columnas de obligación varía según el mes (calculado en HU-01). El pegado debe manejar esta variabilidad.

### Consideraciones de Negocio

- **Criticidad:** Alta - Esta es la primera consolidación de datos críticos del proceso.

- **Validación:** Los datos consolidados aquí alimentan el cálculo final de costo amortizable.

- **Frecuencia:** Una vez al mes, como parte del flujo completo.

### Riesgos Identificados

- **Riesgo 1: Sesión SQL cerrada prematuramente**
  - Impacto: Alto - Pérdida de tablas temporales
  - Mitigación: Implementar validación de sesión activa antes de ejecutar query. Si está cerrada, re-ejecutar HU-01.

- **Riesgo 2: Desajuste en estructura de columnas**
  - Impacto: Medio - Los datos no se alinean correctamente en Excel
  - Mitigación: Validar que los encabezados en Excel coinciden con las columnas del query antes de pegar.

- **Riesgo 3: Pérdida de datos en el pegado**
  - Impacto: Alto - Información incompleta
  - Mitigación: Validación de conteo de registros SQL vs Excel. Implementar verificación de suma de control (checksum).

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 10/11/2025
