# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 13 |
| **Nombre Historia** | Recolectar Información de Tasas, Plazos y Saldos |
| **No. Versión** | 1 |
| **Fecha Creación** | 11/11/2025 08:30 |
| **Fecha Modificación** | 11/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Extraer información histórica de tasas, plazos y saldos de las obligaciones desde el Data Warehouse para complementar las tablas del proceso

**De forma que:** Tenga todos los datos necesarios para el cálculo de pérdida/ganancia y valor valuativo

---

## Criterios de Aceptación

### Insumos

1. **Tablas SQL validadas en HU-12:**
   - `bd_reestructurados_MM_AAAA`
   - `bd_modificados_MM_AAAA`
   - `bd_retenciones_MM_AAAA`

2. **Tablas fuente en DWH (servidor 10.1.3.101\SCC):**
   - `definitivos_credito` - Información actual de créditos
   - `historico_credito` - Información histórica de créditos
   - `tabla_tasas` - Tasas históricas
   - `tabla_saldos` - Saldos históricos

3. **Script SQL:** `04_Recolectar_Info_Tasas_Plazos_Saldo.sql`

### Entradas de las Funcionalidades

- Conexión a servidor 10.1.5.172\RIESGOS (tablas destino)
- Conexión a servidor 10.1.3.101\SCC (tablas fuente - DWH_CC)
- Fecha de corte del proceso (último día del mes)
- Parámetros de mes y año (MM_AAAA)

### Funcionalidades

1. **Establecer conexiones SQL**
   
   - **Conexión 1:** 10.1.5.172\RIESGOS - Tablas del mes
   - **Conexión 2:** 10.1.3.101\SCC (DWH_CC) - Tablas históricas
   - Validar ambas conexiones
   - Validar Linked Server configurado

2. **Agregar columnas necesarias a tablas del mes**
   
   Para cada tabla (reestructurados, modificados, retenciones), agregar columnas:
   ```sql
   ALTER TABLE bd_reestructurados_MM_AAAA
   ADD 
       Tasa_Anterior DECIMAL(10,4) NULL,
       Tasa_Nueva DECIMAL(10,4) NULL,
       Plazo_Anterior INT NULL,
       Plazo_Nuevo INT NULL,
       Saldo_Capital DECIMAL(18,2) NULL,
       Fecha_Desembolso DATE NULL,
       Fecha_Reestructuracion DATE NULL
   ```
   
   Repetir para bd_modificados y bd_retenciones
   
   Si las columnas ya existen, omitir error

3. **Identificar obligaciones a procesar - Reestructurados Consolidados**
   
   Para reestructurados consolidados (Diferente Obligación):
   - obligacion_nueva: La nueva obligación generada
   - obligacion1, obligacion2, ... : Las obligaciones anteriores que se consolidaron
   
   Query para identificar:
   ```sql
   SELECT 
       obligacion_nueva,
       obligacion1,
       obligacion2,
       obligacion3,
       -- hasta obligacion25
       Tipo_Obligacion
   FROM bd_reestructurados_MM_AAAA
   WHERE Tipo_Obligacion = 'Diferente Obligación'
   ```

4. **Recolectar tasas ANTERIORES - Reestructurados Consolidados**
   
   Para las obligaciones consolidadas, calcular tasa ponderada de las obligaciones anteriores:
   
   ```sql
   UPDATE r
   SET r.Tasa_Anterior = (
       SELECT 
           SUM(h.tasa_interes * h.saldo_capital) / SUM(h.saldo_capital)
       FROM [10.1.3.101\SCC].DWH_CC.dbo.historico_credito h
       WHERE h.obligacion IN (
           r.obligacion1, r.obligacion2, r.obligacion3, -- hasta obligacion25
       )
       AND h.fecha_corte = (
           SELECT MAX(fecha_corte) 
           FROM [10.1.3.101\SCC].DWH_CC.dbo.historico_credito
           WHERE fecha_corte < r.Fecha_Corte
           AND obligacion IN (r.obligacion1, r.obligacion2, r.obligacion3, ...)
       )
   )
   FROM bd_reestructurados_MM_AAAA r
   WHERE r.Tipo_Obligacion = 'Diferente Obligación'
   ```
   
   > **Nota:** Esta es una tasa ponderada por saldo de todas las obligaciones que se consolidaron

5. **Recolectar tasas NUEVAS - Reestructurados Consolidados**
   
   Para la obligación nueva (consolidada):
   ```sql
   UPDATE r
   SET r.Tasa_Nueva = d.tasa_interes
   FROM bd_reestructurados_MM_AAAA r
   INNER JOIN [10.1.3.101\SCC].DWH_CC.dbo.definitivos_credito d
       ON r.obligacion_nueva = d.obligacion
   WHERE r.Tipo_Obligacion = 'Diferente Obligación'
   ```

6. **Recolectar plazos ANTERIORES - Reestructurados Consolidados**
   
   Calcular plazo promedio ponderado de obligaciones anteriores:
   ```sql
   UPDATE r
   SET r.Plazo_Anterior = (
       SELECT 
           SUM(h.plazo_meses * h.saldo_capital) / SUM(h.saldo_capital)
       FROM [10.1.3.101\SCC].DWH_CC.dbo.historico_credito h
       WHERE h.obligacion IN (r.obligacion1, r.obligacion2, ...)
       AND h.fecha_corte = (última fecha disponible antes de la reestructuración)
   )
   FROM bd_reestructurados_MM_AAAA r
   WHERE r.Tipo_Obligacion = 'Diferente Obligación'
   ```

7. **Recolectar plazos NUEVOS - Reestructurados Consolidados**
   
   ```sql
   UPDATE r
   SET r.Plazo_Nuevo = d.plazo_meses
   FROM bd_reestructurados_MM_AAAA r
   INNER JOIN [10.1.3.101\SCC].DWH_CC.dbo.definitivos_credito d
       ON r.obligacion_nueva = d.obligacion
   WHERE r.Tipo_Obligacion = 'Diferente Obligación'
   ```

8. **Recolectar saldos CONSOLIDADOS**
   
   Sumar saldos de todas las obligaciones anteriores:
   ```sql
   UPDATE r
   SET r.Saldo_Capital = (
       SELECT SUM(h.saldo_capital)
       FROM [10.1.3.101\SCC].DWH_CC.dbo.historico_credito h
       WHERE h.obligacion IN (r.obligacion1, r.obligacion2, ...)
       AND h.fecha_corte = (última fecha antes de reestructuración)
   )
   FROM bd_reestructurados_MM_AAAA r
   WHERE r.Tipo_Obligacion = 'Diferente Obligación'
   ```

9. **Procesar obligaciones INDIVIDUALES (Misma Obligación)**
   
   Para reestructurados, modificados y retenciones individuales:
   - La obligacion_nueva es la misma que la anterior
   - Se compara la tasa/plazo anterior vs nueva de la misma obligación
   
   **Tasa anterior:**
   ```sql
   UPDATE r
   SET r.Tasa_Anterior = (
       SELECT h.tasa_interes
       FROM [10.1.3.101\SCC].DWH_CC.dbo.historico_credito h
       WHERE h.obligacion = r.obligacion_nueva
       AND h.fecha_corte = (
           SELECT MAX(fecha_corte)
           FROM [10.1.3.101\SCC].DWH_CC.dbo.historico_credito
           WHERE obligacion = r.obligacion_nueva
           AND fecha_corte < r.Fecha_Corte
       )
   )
   FROM bd_reestructurados_MM_AAAA r
   WHERE r.Tipo_Obligacion = 'Misma Obligación'
   ```

10. **Tasa nueva para individuales**
    
    ```sql
    UPDATE r
    SET r.Tasa_Nueva = d.tasa_interes
    FROM bd_reestructurados_MM_AAAA r
    INNER JOIN [10.1.3.101\SCC].DWH_CC.dbo.definitivos_credito d
        ON r.obligacion_nueva = d.obligacion
    WHERE r.Tipo_Obligacion = 'Misma Obligación'
    ```

11. **Plazo anterior para individuales**
    
    ```sql
    UPDATE r
    SET r.Plazo_Anterior = (
        SELECT h.plazo_meses
        FROM [10.1.3.101\SCC].DWH_CC.dbo.historico_credito h
        WHERE h.obligacion = r.obligacion_nueva
        AND h.fecha_corte = (fecha más reciente antes del corte)
    )
    FROM bd_reestructurados_MM_AAAA r
    WHERE r.Tipo_Obligacion = 'Misma Obligación'
    ```

12. **Plazo nuevo para individuales**
    
    ```sql
    UPDATE r
    SET r.Plazo_Nuevo = d.plazo_meses
    FROM bd_reestructurados_MM_AAAA r
    INNER JOIN [10.1.3.101\SCC].DWH_CC.dbo.definitivos_credito d
        ON r.obligacion_nueva = d.obligacion
    WHERE r.Tipo_Obligacion = 'Misma Obligación'
    ```

13. **Saldo para individuales**
    
    ```sql
    UPDATE r
    SET r.Saldo_Capital = d.saldo_capital
    FROM bd_reestructurados_MM_AAAA r
    INNER JOIN [10.1.3.101\SCC].DWH_CC.dbo.definitivos_credito d
        ON r.obligacion_nueva = d.obligacion
    WHERE r.Tipo_Obligacion = 'Misma Obligación'
    ```

14. **Repetir proceso para tabla Modificados**
    
    Ejecutar los mismos UPDATE (pasos 9-13) para:
    ```sql
    FROM bd_modificados_MM_AAAA
    ```
    
    Los modificados pueden ser consolidados o individuales, aplicar lógica correspondiente según Tipo_Obligacion

15. **Repetir proceso para tabla Retenciones**
    
    Ejecutar UPDATE para retenciones (siempre individuales):
    ```sql
    FROM bd_retenciones_MM_AAAA
    ```
    
    > **Nota:** Las retenciones SIEMPRE son "Misma Obligación", usar lógica de individuales

16. **Manejo de valores NULL en tasas/plazos**
    
    Identificar registros donde no se encontró información histórica:
    ```sql
    SELECT 
        COUNT(*) as registros_sin_tasa_anterior
    FROM bd_reestructurados_MM_AAAA
    WHERE Tasa_Anterior IS NULL
    ```
    
    Opciones para NULLs:
    - **Opción A:** Usar tasa/plazo promedio del mercado (requiere parametrización)
    - **Opción B:** Usar tasa/plazo de la obligación nueva como proxy
    - **Opción C:** Marcar para revisión manual
    
    Registrar todos los casos con NULL en reporte de excepciones

17. **Validar rangos de valores**
    
    Verificar que los datos tienen sentido:
    
    a) **Tasas entre 0% y 50%:**
    ```sql
    SELECT COUNT(*) FROM bd_reestructurados_MM_AAAA
    WHERE Tasa_Anterior < 0 OR Tasa_Anterior > 50
       OR Tasa_Nueva < 0 OR Tasa_Nueva > 50
    ```
    Debe retornar 0
    
    b) **Plazos entre 1 y 360 meses:**
    ```sql
    SELECT COUNT(*) FROM bd_reestructurados_MM_AAAA
    WHERE Plazo_Anterior < 1 OR Plazo_Anterior > 360
       OR Plazo_Nuevo < 1 OR Plazo_Nuevo > 360
    ```
    
    c) **Saldos mayores a 0:**
    ```sql
    SELECT COUNT(*) FROM bd_reestructurados_MM_AAAA
    WHERE Saldo_Capital <= 0
    ```

18. **Calcular diferencias (deltas)**
    
    Agregar columnas calculadas:
    ```sql
    ALTER TABLE bd_reestructurados_MM_AAAA
    ADD 
        Delta_Tasa DECIMAL(10,4),
        Delta_Plazo INT
    
    UPDATE bd_reestructurados_MM_AAAA
    SET 
        Delta_Tasa = Tasa_Nueva - Tasa_Anterior,
        Delta_Plazo = Plazo_Nuevo - Plazo_Anterior
    ```
    
    Repetir para modificados y retenciones

19. **Generar estadísticas de recolección**
    
    Para cada tabla:
    - Total de registros procesados
    - Registros con todas las tasas/plazos completos (%)
    - Registros con NULLs que requieren atención
    - Rango de tasas anteriores: MIN, MAX, AVG
    - Rango de tasas nuevas: MIN, MAX, AVG
    - Rango de saldos: MIN, MAX, SUM, AVG
    - Delta tasa promedio
    - Delta plazo promedio

20. **Validar consistencia lógica**
    
    Ejecutar validaciones de negocio:
    
    a) **Para retenciones, tasa nueva debe ser menor:**
    ```sql
    SELECT COUNT(*) FROM bd_retenciones_MM_AAAA
    WHERE Tasa_Nueva >= Tasa_Anterior
    ```
    Debe ser 0 o muy bajo (retención implica reducción de tasa)
    
    b) **Para reestructurados, generalmente se extiende plazo:**
    Validar que hay aumento en plazo en mayoría de casos

21. **Generar reporte de excepciones**
    
    Crear reporte con:
    - Obligaciones sin información histórica (Tasa_Anterior NULL)
    - Valores fuera de rango
    - Retenciones con tasa que no disminuyó
    - Cualquier anomalía detectada
    - Requiere revisión manual

### Puntos de Control Crítico

1. **Conexión a historico_credito:** Si no se puede acceder a tabla histórica, detener (no se pueden obtener tasas/plazos anteriores).

2. **Más del 20% con NULLs:** Si más del 20% de registros no tienen Tasa_Anterior o Plazo_Anterior, detener y revisar fuente de datos.

3. **Saldos en 0 o NULL:** Si hay obligaciones con Saldo_Capital NULL o 0, detener (dato crítico para cálculos).

4. **Valores fuera de rango:** Si hay tasas o plazos fuera de rangos válidos, detener y revisar datos fuente.

### Puntos de Control No Crítico

1. **Pocos registros con NULLs (< 5%):** Si menos del 5% tiene NULLs, registrar advertencia y aplicar estrategia de imputación.

2. **Retenciones con tasa que no bajó:** Si son casos aislados (< 1%), registrar advertencia pero continuar.

### Salidas

1. **Tablas actualizadas:**
   - `bd_reestructurados_MM_AAAA` con tasas, plazos, saldos
   - `bd_modificados_MM_AAAA` con tasas, plazos, saldos
   - `bd_retenciones_MM_AAAA` con tasas, plazos, saldos

2. **Reporte de estadísticas:** `reportes/Estadisticas_Tasas_Plazos_MM_AAAA.xlsx`
   - Estadísticas por tabla
   - Distribución de tasas
   - Distribución de plazos
   - Distribución de saldos

3. **Reporte de excepciones:** `reportes/Excepciones_Recoleccion_MM_AAAA.xlsx`
   - Obligaciones con NULLs
   - Valores fuera de rango
   - Anomalías detectadas

4. **Log:** `logs/ejecuciones/HU13_Recoleccion_Tasas_Plazos_AAAAMMDD_HHMMSS.log`

### Reportería

Log con:
- **Resumen de recolección por tabla:**
  - Reestructurados: XXX registros, YYY completos, ZZZ con NULLs
  - Modificados: XXX registros, YYY completos, ZZZ con NULLs
  - Retenciones: XXX registros, YYY completos, ZZZ con NULLs

- **Estadísticas de tasas:**
  - Tasa anterior promedio: X.XX%
  - Tasa nueva promedio: X.XX%
  - Delta promedio: +/- X.XX%

- **Estadísticas de plazos:**
  - Plazo anterior promedio: XX meses
  - Plazo nuevo promedio: XX meses
  - Delta promedio: +/- XX meses

- **Estadísticas de saldos:**
  - Saldo total: $XXX,XXX,XXX
  - Saldo promedio: $XXX,XXX
  - Saldo mínimo/máximo

### Parametría

- **Servidor histórico:** `10.1.3.101\SCC` (configurable)
- **Tabla histórica:** `historico_credito` (configurable)
- **Tabla definitivos:** `definitivos_credito` (configurable)
- **Rango válido tasas:** 0% a 50% (configurable)
- **Rango válido plazos:** 1 a 360 meses (configurable)
- **Umbral crítico NULLs:** 20% (configurable)
- **Umbral advertencia NULLs:** 5% (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-11:** Tablas cargadas en SQL
- **HU-12:** Campos de identificación completos

### Historias de Usuario Posteriores
- **HU-14:** Cálculo pérdida/ganancia - Usa tasas, plazos, saldos
- **HU-15:** Query variables valuativo - Usa estos datos

### Recursos Externos
- **Tabla historico_credito:** Debe tener histórico completo de obligaciones
- **Tabla definitivos_credito:** Información actual de obligaciones
- **Linked Server:** Configurado entre servidores

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 3 horas |
| Desarrollo SQL Scripts | 6 horas |
| Pruebas unitarias | 1.5 horas |
| Pruebas integradas | 1.5 horas |
| **Total** | **12 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **Queries complejos:** Los UPDATE con subqueries a tablas históricas pueden ser lentos. Considerar usar tablas temporales para mejorar performance.

- **Ponderación por saldo:** Para consolidados, las tasas y plazos anteriores se ponderan por el saldo de cada obligación (obligaciones con mayor saldo tienen más peso).

- **Fecha de corte histórica:** Se busca la información más reciente ANTES de la fecha de reestructuración/modificación/retención.

### Consideraciones de Negocio

- **HU más compleja del Sprint 3:** Esta HU es la más compleja técnicamente por los cálculos de tasas/plazos ponderados y manejo de históricos.

- **Calidad de histórico crítica:** Si la tabla historico_credito no está bien mantenida, habrá muchos NULLs que requerirán tratamiento especial.

- **Retenciones reducen tasa:** Las retenciones de tasa son un beneficio, por lo que la tasa nueva debería ser menor que la anterior. Si no es así, puede indicar error de datos.

### Riesgos Identificados

- **Riesgo 1: Histórico incompleto**
  - Impacto: Alto - Muchas obligaciones sin tasa/plazo anterior
  - Mitigación: Coordinar con área de datos para completar histórico. Definir estrategia de imputación para NULLs.

- **Riesgo 2: Performance degradado**
  - Impacto: Medio - Queries muy lentos
  - Mitigación: Usar índices en tablas históricas. Traer datos a tablas temporales locales. Ejecutar en horario de baja carga.

- **Riesgo 3: Cambios en estructura de tabla histórica**
  - Impacto: Alto - Queries fallan
  - Mitigación: Validar estructura al inicio. Tener queries parametrizados para adaptarse a cambios.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 11/11/2025
