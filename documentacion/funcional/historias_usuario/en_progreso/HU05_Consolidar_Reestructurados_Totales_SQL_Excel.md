# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 05 |
| **Nombre Historia** | Consolidar Reestructurados Totales desde SQL a Excel |
| **No. Versión** | 1 |
| **Fecha Creación** | 10/11/2025 15:30 |
| **Fecha Modificación** | 10/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Ejecutar el query "3-Reestructurados Totales" en SQL y copiar los resultados a la pestaña correspondiente del archivo Excel

**De forma que:** Tenga el detalle completo de todos los reestructurados individuales para posterior organización

---

## Criterios de Aceptación

### Insumos

1. **Tablas temporales SQL activas:** `#Base` y `#Base2` (misma sesión)
2. **Archivo Excel abierto:** Con pestañas HU-03 y HU-04 ya completadas
3. **Script SQL:** Sección "3-Reestructurados Totales"
4. **Conexión SQL activa:** Servidor `10.1.3.101\SCC`

### Entradas de las Funcionalidades

- Tablas temporales con detalle individual de reestructurados
- Excel con instancia activa
- Query que extrae el detalle completo por cada reestructuración

### Funcionalidades

1. **Verificar recursos activos**
   
   - Validar instancia Excel activa
   - Validar sesión SQL activa
   - Validar existencia de tablas temporales

2. **Ejecutar query "3-Reestructurados Totales"**
   
   - Seleccionar sección específica del script
   - Ejecutar sentencia SELECT
   - El query extrae el detalle de TODAS las reestructuraciones individuales:
     - Obligación nueva
     - Obligaciones anteriores (detalle completo)
     - Posición de cada obligación
     - Indicador de tipo (consolidada=múltiples obligaciones, individual=1 obligación)
     - Fechas y montos

3. **Copiar resultados completos**
   
   - Seleccionar todos los registros (puede ser volumen alto)
   - Copiar conjunto completo
   - Registrar cantidad en log

4. **Activar pestaña "3. Reestructurados totales"**
   
   - Cambiar a la pestaña correspondiente
   - Verificar existencia y limpieza
   - Confirmar encabezados

5. **Pegar resultados en Excel**
   
   - Posicionar en celda A2
   - Pegar datos de SQL
   - Preservar formatos
   - Este paso puede tomar más tiempo por mayor volumen

6. **Validar integridad del pegado**
   
   - Contar filas pegadas
   - Comparar con registros SQL
   - Verificar columnas críticas: Obligación, Posición, Tipo

7. **Guardar archivo**
   
   - Guardar cambios
   - Mantener Excel abierto para HU-06
   - Timestamp en log

8. **Registrar métricas**
   
   - Registros totales procesados
   - Tiempo de query y pegado
   - Validaciones exitosas

### Puntos de Control Crítico

1. **Validación SQL:** Sesión activa con tablas temporales disponibles.

2. **Validación de volumen:** El query debe retornar más registros que HU-03 (detalle vs consolidado). Si retorna menos, posible error.

3. **Validación de columna Posición:** Debe existir y contener valores numéricos (1, 2, 3, etc.).

4. **Validación de integridad:** Registros SQL = Filas Excel.

### Puntos de Control No Crítico

1. **Advertencia de alto volumen:** Si registros > 10,000, advertir sobre tiempo de procesamiento (normal en esta HU).

2. **Advertencia de posiciones:** Si hay posiciones > 10, advertir (casos especiales).

### Salidas

1. **Pestaña Excel poblada:** "3. Reestructurados totales" con detalle completo de reestructurados
2. **Archivo guardado:** Excel actualizado con 3 pestañas pobladas
3. **Log:** `logs/ejecuciones/HU05_Consolidar_Reestructurados_Totales_AAAAMMDD_HHMMSS.log`

### Reportería

Log detallado con:
- Cantidad de registros totales
- Distribución por posición (cuántos posición 1, 2, 3, etc.)
- Tiempos de ejecución
- Validaciones

### Parametría

- **Nombre pestaña:** `3. Reestructurados totales` (configurable)
- **Celda inicial:** `A2` (configurable)
- **Timeout query:** 10 minutos (mayor por volumen) (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-01:** Tablas temporales activas
- **HU-02:** Archivo preparado
- **HU-03, HU-04:** Excel abierto

### Historias de Usuario Posteriores
- **HU-08:** Organizar Reestructurados - Usará esta información para filtrar y organizar

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

- **Mayor volumen:** Esta pestaña típicamente tiene 3-5 veces más registros que la consolidada (HU-03) porque muestra el detalle de cada obligación.

- **Columna Posición:** Es crítica para HU-08. Indica si es la 1ra, 2da, 3ra obligación que se consolidó.

- **Rendimiento:** Considerar aumentar el timeout del query a 10 minutos por el mayor volumen de datos.

### Consideraciones de Negocio

- **Detalle vs Consolidado:** HU-03 muestra el resultado final (consolidado), HU-05 muestra el detalle de cómo se llegó a ese resultado.

- **Uso posterior:** Esta información es fundamental para HU-08 donde se filtrará por columna C (posición) para identificar reestructuraciones individuales.

### Riesgos Identificados

- **Riesgo 1: Timeout por volumen**
  - Impacto: Medio - Query no completa
  - Mitigación: Aumentar timeout a 10-15 minutos. Si persiste, considerar paginación del query.

- **Riesgo 2: Memoria insuficiente en Excel**
  - Impacto: Medio - Excel puede volverse lento con > 50,000 registros
  - Mitigación: Procesar en modo background, cerrar otras aplicaciones, considerar Excel 64-bit.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 10/11/2025
