# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 15 |
| **Nombre Historia** | Query para Variables de Cálculo Valor Valuativo |
| **No. Versión** | 1 |
| **Fecha Creación** | 11/11/2025 09:30 |
| **Fecha Modificación** | 11/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Ejecutar el query SQL que genera la tabla `bd_perdidas_ganancias_dwh` con las variables necesarias para el cálculo del valor valuativo

**De forma que:** Se tenga la información consolidada de pérdidas/ganancias en el Data Warehouse lista para el cálculo final y la macro de amortización

---

## Criterios de Aceptación

### Insumos

1. **Tablas SQL completadas (HU-13):**
   - `bd_reestructurados_MM_AAAA`
   - `bd_modificados_MM_AAAA`
   - `bd_retenciones_MM_AAAA`
   - Con todos los campos de tasas, plazos, saldos

2. **Script SQL:** `05_Variables_Calculo_Valor_Valuativo.sql`

3. **Servidor SQL:** 10.1.5.172\RIESGOS (DWH_Riesgos_Credito)

### Entradas de las Funcionalidades

- Conexión a servidor 10.1.5.172\RIESGOS
- Tablas del mes con datos completos
- Parámetros: mes, año (MM_AAAA)
- Script SQL de transformación

### Funcionalidades

1. **Establecer conexión SQL**
   
   - Conectar a servidor 10.1.5.172\RIESGOS
   - Base de datos: DWH_Riesgos_Credito
   - Validar conexión exitosa
   - Registrar credenciales utilizadas

2. **Validar tablas fuente**
   
   Verificar que existen y tienen datos:
   ```sql
   SELECT COUNT(*) as total_reestructurados 
   FROM bd_reestructurados_MM_AAAA
   
   SELECT COUNT(*) as total_modificados 
   FROM bd_modificados_MM_AAAA
   
   SELECT COUNT(*) as total_retenciones 
   FROM bd_retenciones_MM_AAAA
   ```
   
   Si alguna tabla no existe o está vacía (excepto retenciones), detener proceso

3. **Eliminar tabla anterior si existe**
   
   Eliminar tabla del mes actual si ya existe (re-ejecución):
   ```sql
   IF OBJECT_ID('DWH_Riesgos_Credito.dbo.bd_perdidas_ganancias_dwh_MM_AAAA', 'U') IS NOT NULL
       DROP TABLE DWH_Riesgos_Credito.dbo.bd_perdidas_ganancias_dwh_MM_AAAA
   ```

4. **Crear tabla consolidada uniendo las 3 tablas**
   
   Ejecutar query de consolidación:
   ```sql
   CREATE TABLE bd_perdidas_ganancias_dwh_MM_AAAA AS
   SELECT 
       Fecha_Corte,
       Tipo_Id,
       Numero_Id,
       obligacion_nueva as N_Obligacion,
       Herramienta,
       Tipo_Herramienta,
       Tipo_Obligacion,
       Modalidad,
       Tasa_Anterior,
       Tasa_Nueva,
       Plazo_Anterior,
       Plazo_Nuevo,
       Saldo_Capital,
       -- Calcular delta tasa
       (Tasa_Nueva - Tasa_Anterior) as Delta_Tasa,
       -- Calcular delta plazo
       (Plazo_Nuevo - Plazo_Anterior) as Delta_Plazo,
       -- Indicador de fuente
       'REESTRUCTURADO' as Fuente
   FROM bd_reestructurados_MM_AAAA
   
   UNION ALL
   
   SELECT 
       Fecha_Corte,
       Tipo_Id,
       Numero_Id,
       obligacion_nueva,
       Herramienta,
       Tipo_Herramienta,
       Tipo_Obligacion,
       Modalidad,
       Tasa_Anterior,
       Tasa_Nueva,
       Plazo_Anterior,
       Plazo_Nuevo,
       Saldo_Capital,
       (Tasa_Nueva - Tasa_Anterior),
       (Plazo_Nuevo - Plazo_Anterior),
       'MODIFICADO'
   FROM bd_modificados_MM_AAAA
   
   UNION ALL
   
   SELECT 
       Fecha_Corte,
       Tipo_Id,
       Numero_Id,
       obligacion_nueva,
       Herramienta,
       Tipo_Herramienta,
       Tipo_Obligacion,
       Modalidad,
       Tasa_Anterior,
       Tasa_Nueva,
       Plazo_Anterior,
       Plazo_Nuevo,
       Saldo_Capital,
       (Tasa_Nueva - Tasa_Anterior),
       (Plazo_Nuevo - Plazo_Anterior),
       'RETENCION'
   FROM bd_retenciones_MM_AAAA
   ```

5. **Agregar columna de cálculo de pérdida/ganancia**
   
   Agregar columna calculada con fórmula de valor presente:
   ```sql
   ALTER TABLE bd_perdidas_ganancias_dwh_MM_AAAA
   ADD Perdida_Ganancia DECIMAL(18,2)
   
   -- Calcular pérdida/ganancia usando fórmula de valor presente
   UPDATE bd_perdidas_ganancias_dwh_MM_AAAA
   SET Perdida_Ganancia = 
       CASE 
           WHEN Tasa_Nueva = 0 THEN Saldo_Capital
           ELSE Saldo_Capital * (
               (1 - POWER((1 + Tasa_Nueva/12), -Plazo_Nuevo)) / (Tasa_Nueva/12)
           )
       END
       -
       CASE 
           WHEN Tasa_Anterior = 0 THEN Saldo_Capital
           ELSE Saldo_Capital * (
               (1 - POWER((1 + Tasa_Anterior/12), -Plazo_Anterior)) / (Tasa_Anterior/12)
           )
       END
   ```

6. **Agregar columna de clasificación de resultado**
   
   ```sql
   ALTER TABLE bd_perdidas_ganancias_dwh_MM_AAAA
   ADD Tipo_Resultado VARCHAR(20)
   
   UPDATE bd_perdidas_ganancias_dwh_MM_AAAA
   SET Tipo_Resultado = 
       CASE 
           WHEN Perdida_Ganancia < 0 THEN 'PÉRDIDA'
           WHEN Perdida_Ganancia > 0 THEN 'GANANCIA'
           ELSE 'NEUTRO'
       END
   ```

7. **Agregar columna de porcentaje sobre saldo**
   
   ```sql
   ALTER TABLE bd_perdidas_ganancias_dwh_MM_AAAA
   ADD Porcentaje_Saldo DECIMAL(10,4)
   
   UPDATE bd_perdidas_ganancias_dwh_MM_AAAA
   SET Porcentaje_Saldo = 
       CASE 
           WHEN Saldo_Capital = 0 THEN 0
           ELSE (Perdida_Ganancia / Saldo_Capital) * 100
       END
   ```

8. **Agregar columnas de timestamp y auditoría**
   
   ```sql
   ALTER TABLE bd_perdidas_ganancias_dwh_MM_AAAA
   ADD 
       Fecha_Proceso DATETIME DEFAULT GETDATE(),
       Usuario_Proceso VARCHAR(100) DEFAULT SYSTEM_USER,
       Version_Proceso VARCHAR(20) DEFAULT 'v1.0'
   ```

9. **Crear índices para mejorar consultas posteriores**
   
   ```sql
   -- Índice por obligación
   CREATE INDEX idx_obligacion 
   ON bd_perdidas_ganancias_dwh_MM_AAAA(N_Obligacion)
   
   -- Índice por identificación
   CREATE INDEX idx_cliente 
   ON bd_perdidas_ganancias_dwh_MM_AAAA(Tipo_Id, Numero_Id)
   
   -- Índice por herramienta
   CREATE INDEX idx_herramienta 
   ON bd_perdidas_ganancias_dwh_MM_AAAA(Herramienta)
   
   -- Índice por fecha
   CREATE INDEX idx_fecha 
   ON bd_perdidas_ganancias_dwh_MM_AAAA(Fecha_Corte)
   ```

10. **Validar estructura de tabla creada**
    
    Verificar columnas de la tabla:
    ```sql
    SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'bd_perdidas_ganancias_dwh_MM_AAAA'
    ORDER BY ORDINAL_POSITION
    ```
    
    Debe tener todas las columnas esperadas

11. **Validar datos en tabla**
    
    Ejecutar validaciones:
    
    a) **Conteo total coincide con suma de tablas fuente:**
    ```sql
    SELECT COUNT(*) as total_consolidado
    FROM bd_perdidas_ganancias_dwh_MM_AAAA
    ```
    Debe ser igual a: count(reestructurados) + count(modificados) + count(retenciones)
    
    b) **No hay registros con campos críticos NULL:**
    ```sql
    SELECT COUNT(*) FROM bd_perdidas_ganancias_dwh_MM_AAAA
    WHERE N_Obligacion IS NULL 
       OR Saldo_Capital IS NULL
       OR Perdida_Ganancia IS NULL
    ```
    Debe retornar 0

12. **Generar estadísticas de la tabla consolidada**
    
    ```sql
    -- Resumen por herramienta
    SELECT 
        Herramienta,
        Tipo_Herramienta,
        COUNT(*) as Total_Obligaciones,
        SUM(Saldo_Capital) as Saldo_Total,
        SUM(Perdida_Ganancia) as PerdidaGanancia_Total,
        AVG(Perdida_Ganancia) as PerdidaGanancia_Promedio,
        MIN(Perdida_Ganancia) as PerdidaGanancia_Minima,
        MAX(Perdida_Ganancia) as PerdidaGanancia_Maxima
    FROM bd_perdidas_ganancias_dwh_MM_AAAA
    GROUP BY Herramienta, Tipo_Herramienta
    ORDER BY Herramienta, Tipo_Herramienta
    ```

13. **Generar resumen global**
    
    ```sql
    SELECT 
        COUNT(*) as Total_Obligaciones,
        COUNT(DISTINCT Numero_Id) as Total_Clientes,
        SUM(Saldo_Capital) as Saldo_Total,
        SUM(CASE WHEN Tipo_Resultado = 'PÉRDIDA' THEN Perdida_Ganancia ELSE 0 END) as Total_Perdidas,
        SUM(CASE WHEN Tipo_Resultado = 'GANANCIA' THEN Perdida_Ganancia ELSE 0 END) as Total_Ganancias,
        SUM(Perdida_Ganancia) as Neto_PerdidaGanancia,
        AVG(Porcentaje_Saldo) as Porcentaje_Promedio
    FROM bd_perdidas_ganancias_dwh_MM_AAAA
    ```

14. **Identificar casos extremos**
    
    ```sql
    -- Registros con pérdida/ganancia superior al 50% del saldo
    SELECT 
        N_Obligacion,
        Numero_Id,
        Herramienta,
        Saldo_Capital,
        Perdida_Ganancia,
        Porcentaje_Saldo
    FROM bd_perdidas_ganancias_dwh_MM_AAAA
    WHERE ABS(Porcentaje_Saldo) > 50
    ORDER BY ABS(Porcentaje_Saldo) DESC
    ```
    
    Registrar casos extremos para revisión

15. **Otorgar permisos de lectura**
    
    Dar permisos a usuarios/roles que necesitan consultar la tabla:
    ```sql
    GRANT SELECT ON bd_perdidas_ganancias_dwh_MM_AAAA 
    TO [RIESGOS_ANALISTAS], [COSTO_AMORTIZABLE_USERS]
    ```

16. **Generar vista consolidada (opcional)**
    
    Crear vista que incluya tablas de múltiples meses:
    ```sql
    CREATE OR ALTER VIEW vw_perdidas_ganancias_historico AS
    SELECT * FROM bd_perdidas_ganancias_dwh_01_2025
    UNION ALL
    SELECT * FROM bd_perdidas_ganancias_dwh_02_2025
    UNION ALL
    SELECT * FROM bd_perdidas_ganancias_dwh_03_2025
    -- ... etc
    ```

17. **Documentar tabla en catálogo de datos**
    
    Agregar metadatos descriptivos:
    ```sql
    EXEC sp_addextendedproperty 
        @name = N'MS_Description', 
        @value = N'Tabla consolidada de pérdidas y ganancias por obligaciones reestructuradas, modificadas y retenidas. Generada mensualmente para proceso RDA Costo Amortizable.',
        @level0type = N'SCHEMA', @level0name = 'dbo',
        @level1type = N'TABLE', @level1name = 'bd_perdidas_ganancias_dwh_MM_AAAA'
    ```

18. **Registrar en log de auditoría**
    
    - Timestamp de creación de tabla
    - Cantidad de registros por fuente
    - Estadísticas globales
    - Casos extremos identificados
    - Tiempo de ejecución del script

### Puntos de Control Crítico

1. **Tablas fuente vacías:** Si reestructurados o modificados están vacías (retenciones puede estar vacía), detener proceso.

2. **Error en UNION:** Si el UNION ALL falla por incompatibilidad de columnas, detener y revisar estructura de tablas fuente.

3. **Conteo no coincide:** Si el total consolidado no es igual a la suma de las 3 tablas fuente, detener (se perdieron registros).

4. **Error en cálculo de pérdida/ganancia:** Si hay errores matemáticos (#DIV/0), detener y corregir datos fuente.

5. **Más del 10% con porcentaje extremo:** Si más del 10% de registros tienen pérdida/ganancia > 50% del saldo, detener y revisar tasas/plazos.

### Puntos de Control No Crítico

1. **Retenciones vacías:** Si tabla de retenciones está vacía (mes sin retenciones), registrar advertencia pero continuar.

2. **Pocos casos extremos (< 5%):** Si menos del 5% tiene porcentajes extremos, registrar advertencia y marcar para revisión.

### Salidas

1. **Tabla SQL:** `DWH_Riesgos_Credito.dbo.bd_perdidas_ganancias_dwh_MM_AAAA`
   - Todas las obligaciones consolidadas
   - Pérdida/Ganancia calculada
   - Clasificación y porcentajes
   - Índices creados
   - Metadatos de auditoría

2. **Reporte de estadísticas:** En log o tabla auxiliar
   - Resumen por herramienta
   - Resumen global
   - Casos extremos

3. **Log:** `logs/ejecuciones/HU15_Query_Variables_Valuativo_AAAAMMDD_HHMMSS.log`

### Reportería

Log con:
- **Resumen de consolidación:**
  - Registros de reestructurados: XXX
  - Registros de modificados: XXX
  - Registros de retenciones: XXX
  - **Total consolidado:** XXX

- **Estadísticas globales:**
  - Total clientes afectados: XXX
  - Saldo total: $XXX,XXX,XXX
  - Pérdida total: $XXX,XXX,XXX
  - Ganancia total: $XXX,XXX,XXX
  - **Neto:** $XXX,XXX,XXX
  - % promedio sobre saldo: X.XX%

- **Distribución por herramienta:**
  - Reestructurados: XXX oblig, $XXX pérdida/ganancia
  - Modificados: XXX oblig, $XXX pérdida/ganancia
  - Retenciones: XXX oblig, $XXX pérdida/ganancia

- **Casos extremos:** XXX registros con porcentaje > 50%

### Parametría

- **Servidor SQL:** `10.1.5.172\RIESGOS` (configurable)
- **Base de datos:** `DWH_Riesgos_Credito` (configurable)
- **Nombre tabla destino:** `bd_perdidas_ganancias_dwh_MM_AAAA` (configurable)
- **Umbral casos extremos:** 50% del saldo (configurable)
- **Tasa mensual:** Tasa anual / 12 (fórmula fija)

---

## Dependencias

### Historias de Usuario Previas
- **HU-11:** Tablas cargadas en SQL
- **HU-12:** Datos validados
- **HU-13:** Tasas, plazos, saldos completos

### Historias de Usuario Posteriores
- **HU-16:** Macro de amortización - Leerá esta tabla
- **HU-18:** Subir base valuativa - Usará esta tabla

### Recursos Externos
- **Permisos SQL:** CREATE TABLE, CREATE INDEX, GRANT en DWH_Riesgos_Credito

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 2 horas |
| Desarrollo SQL Scripts | 3 horas |
| Pruebas unitarias | 0.5 horas |
| Pruebas integradas | 0.5 horas |
| **Total** | **6 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **UNION ALL vs UNION:** Se usa UNION ALL porque no hay riesgo de duplicados entre las 3 tablas (son fuentes diferentes). UNION ALL es más rápido.

- **Cálculos en SQL:** Se replica la fórmula de valor presente en SQL. Asegurar que coincide con la fórmula de HU-14 (Excel).

- **Índices críticos:** Los índices mejoran significativamente el performance de la macro de HU-16 que consultará esta tabla.

- **Tabla histórica:** Al mantener tablas mensuales (no sobrescribir), se crea un histórico consultable.

### Consideraciones de Negocio

- **Tabla maestra para cálculos finales:** Esta tabla es la fuente de verdad para el valor valuativo. Debe ser consistente y confiable.

- **Auditoría y trazabilidad:** Los campos de timestamp y usuario permiten auditoría de cuándo y quién generó la tabla.

- **Disponibilidad para reportería:** Una vez creada, la tabla puede ser consultada para reportes ad-hoc y análisis adicionales.

### Riesgos Identificados

- **Riesgo 1: Fórmula SQL diferente a Excel**
  - Impacto: Alto - Inconsistencias entre HU-14 y HU-15
  - Mitigación: Validar con casos de prueba que ambas fórmulas dan mismo resultado. Comparar muestras.

- **Riesgo 2: Performance del UNION con muchos registros**
  - Impacto: Medio - Proceso lento
  - Mitigación: Asegurar índices en tablas fuente. Ejecutar en horario de baja carga.

- **Riesgo 3: Error en cálculo de pérdida/ganancia**
  - Impacto: Crítico - Valores incorrectos para cálculo final
  - Mitigación: Pruebas exhaustivas. Comparar con resultados de HU-14 (Excel). Validar rangos.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 11/11/2025
