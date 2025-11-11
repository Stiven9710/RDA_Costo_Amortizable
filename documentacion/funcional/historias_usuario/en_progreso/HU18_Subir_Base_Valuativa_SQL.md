# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 18 |
| **Nombre Historia** | Subir Base Valuativa a SQL Server |
| **No. Versión** | 1 |
| **Fecha Creación** | 11/11/2025 11:00 |
| **Fecha Modificación** | 11/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Cargar la información de costo amortizable calculada en una tabla SQL permanente y ejecutar el segundo query de completitud

**De forma que:** Los datos estén disponibles en el Data Warehouse para consultas, reportería y el proceso de verificación en producción

---

## Criterios de Aceptación

### Insumos

1. **Archivo Excel (HU-17):**
   - `04. Envío Costo Amortizable MM_AAAA.xlsx`
   - Con pestaña "Detalle por Obligación" completa

2. **Tabla SQL (HU-15):**
   - `bd_perdidas_ganancias_dwh_MM_AAAA`
   - Como fuente alternativa

3. **Script SQL:** `06_Cargue_Base_Envio_Final.sql`

4. **Servidor SQL:** 10.1.5.172\RIESGOS (DWH_Riesgos_Credito)

### Entradas de las Funcionalidades

- Datos de costo amortizable por obligación
- Conexión a SQL Server
- Mes y año de proceso (MM_AAAA)
- Script de carga y completitud

### Funcionalidades

1. **Establecer conexión SQL**
   
   - Conectar a servidor 10.1.5.172\RIESGOS
   - Base de datos: DWH_Riesgos_Credito
   - Validar conexión exitosa
   - Registrar credenciales utilizadas

2. **Eliminar tabla del mes anterior si existe**
   
   ```sql
   IF OBJECT_ID('DWH_Riesgos_Credito.dbo.bd_costo_amortizable_MM_AAAA', 'U') IS NOT NULL
       DROP TABLE DWH_Riesgos_Credito.dbo.bd_costo_amortizable_MM_AAAA
   ```

3. **Opción A: Cargar desde Excel (Recomendado)**
   
   Usar SQL Server Import Wizard o script Python:
   - Archivo: `04. Envío Costo Amortizable MM_AAAA.xlsx`
   - Pestaña: "Detalle por Obligación"
   - Tabla destino: `bd_costo_amortizable_MM_AAAA`
   - Mapear todas las columnas
   - Validar que se importaron todos los registros

4. **Opción B: Crear desde tabla bd_perdidas_ganancias_dwh**
   
   Alternativa usando SQL directo:
   ```sql
   CREATE TABLE bd_costo_amortizable_MM_AAAA AS
   SELECT 
       Fecha_Corte,
       N_Obligacion,
       Tipo_Id,
       Numero_Id,
       Herramienta,
       Tipo_Herramienta,
       Tipo_Obligacion,
       Modalidad,
       Saldo_Capital,
       Tasa_Anterior,
       Tasa_Nueva,
       Plazo_Anterior,
       Plazo_Nuevo,
       Perdida_Ganancia as Valor_Valuativo,
       Porcentaje_Saldo,
       Tipo_Resultado
   FROM bd_perdidas_ganancias_dwh_MM_AAAA
   ORDER BY Herramienta, N_Obligacion
   ```

5. **Agregar columnas de auditoría**
   
   ```sql
   ALTER TABLE bd_costo_amortizable_MM_AAAA
   ADD 
       Fecha_Carga DATETIME DEFAULT GETDATE(),
       Usuario_Carga VARCHAR(100) DEFAULT SYSTEM_USER,
       Origen_Datos VARCHAR(50) DEFAULT 'HU-18',
       Estado VARCHAR(20) DEFAULT 'ACTIVO'
   ```

6. **Validar estructura de la tabla**
   
   Verificar columnas obligatorias:
   ```sql
   SELECT COLUMN_NAME, DATA_TYPE
   FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_NAME = 'bd_costo_amortizable_MM_AAAA'
   ORDER BY ORDINAL_POSITION
   ```
   
   Debe incluir al menos:
   - N_Obligacion
   - Numero_Id
   - Herramienta
   - Saldo_Capital
   - Valor_Valuativo
   - Fecha_Corte

7. **Validar datos cargados**
   
   a) **Conteo de registros:**
   ```sql
   SELECT COUNT(*) as total_registros
   FROM bd_costo_amortizable_MM_AAAA
   ```
   Debe coincidir con archivo Excel
   
   b) **Sin valores nulos críticos:**
   ```sql
   SELECT COUNT(*) FROM bd_costo_amortizable_MM_AAAA
   WHERE N_Obligacion IS NULL 
      OR Valor_Valuativo IS NULL
      OR Saldo_Capital IS NULL
   ```
   Debe retornar 0

8. **Ejecutar segundo query de completitud**
   
   Este query complementa información faltante desde otras tablas del DWH:
   
   ```sql
   -- Actualizar información de cliente desde tabla maestra
   UPDATE c
   SET 
       c.Nombre_Cliente = m.nombre_completo,
       c.Segmento = m.segmento_cliente,
       c.Oficina = m.oficina_radicacion,
       c.Ciudad = m.ciudad
   FROM bd_costo_amortizable_MM_AAAA c
   INNER JOIN [10.1.3.101\SCC].DWH_CC.dbo.maestro_clientes m
       ON c.Tipo_Id = m.tipo_identificacion
       AND c.Numero_Id = m.numero_identificacion
   WHERE c.Nombre_Cliente IS NULL
   ```

9. **Actualizar información de producto**
   
   ```sql
   -- Completar información del producto/crédito
   UPDATE c
   SET 
       c.Producto = p.nombre_producto,
       c.Linea_Credito = p.linea_credito,
       c.Destino = p.destino_credito
   FROM bd_costo_amortizable_MM_AAAA c
   LEFT JOIN [10.1.3.101\SCC].DWH_CC.dbo.productos_credito p
       ON c.N_Obligacion = p.obligacion
   WHERE c.Producto IS NULL
   ```

10. **Actualizar información de fechas**
    
    ```sql
    -- Agregar fecha de desembolso y fecha de aplicación de herramienta
    UPDATE c
    SET 
        c.Fecha_Desembolso = h.fecha_desembolso,
        c.Fecha_Aplicacion_Herramienta = h.fecha_modificacion
    FROM bd_costo_amortizable_MM_AAAA c
    LEFT JOIN [10.1.3.101\SCC].DWH_CC.dbo.historico_credito h
        ON c.N_Obligacion = h.obligacion
        AND h.fecha_corte = c.Fecha_Corte
    WHERE c.Fecha_Desembolso IS NULL
    ```

11. **Calcular antigüedad del crédito**
    
    ```sql
    ALTER TABLE bd_costo_amortizable_MM_AAAA
    ADD 
        Antiguedad_Meses INT,
        Meses_Desde_Aplicacion INT
    
    UPDATE bd_costo_amortizable_MM_AAAA
    SET 
        Antiguedad_Meses = DATEDIFF(MONTH, Fecha_Desembolso, Fecha_Corte),
        Meses_Desde_Aplicacion = DATEDIFF(MONTH, Fecha_Aplicacion_Herramienta, Fecha_Corte)
    WHERE Fecha_Desembolso IS NOT NULL
    ```

12. **Agregar clasificación de riesgo**
    
    ```sql
    -- Obtener calificación de riesgo más reciente
    UPDATE c
    SET 
        c.Calificacion_Riesgo = r.calificacion,
        c.Provision = r.provision_requerida
    FROM bd_costo_amortizable_MM_AAAA c
    LEFT JOIN [10.1.3.101\SCC].DWH_CC.dbo.riesgo_credito r
        ON c.N_Obligacion = r.obligacion
        AND r.fecha_calificacion = (
            SELECT MAX(fecha_calificacion)
            FROM [10.1.3.101\SCC].DWH_CC.dbo.riesgo_credito
            WHERE obligacion = c.N_Obligacion
            AND fecha_calificacion <= c.Fecha_Corte
        )
    ```

13. **Crear índices para mejorar consultas**
    
    ```sql
    -- Índice por obligación
    CREATE INDEX idx_obligacion 
    ON bd_costo_amortizable_MM_AAAA(N_Obligacion)
    
    -- Índice por cliente
    CREATE INDEX idx_cliente 
    ON bd_costo_amortizable_MM_AAAA(Tipo_Id, Numero_Id)
    
    -- Índice por herramienta
    CREATE INDEX idx_herramienta 
    ON bd_costo_amortizable_MM_AAAA(Herramienta, Tipo_Herramienta)
    
    -- Índice por fecha
    CREATE INDEX idx_fecha 
    ON bd_costo_amortizable_MM_AAAA(Fecha_Corte)
    
    -- Índice compuesto para reportería
    CREATE INDEX idx_reporteria 
    ON bd_costo_amortizable_MM_AAAA(Herramienta, Fecha_Corte, Estado)
    ```

14. **Generar estadísticas de la tabla**
    
    ```sql
    -- Resumen general
    SELECT 
        COUNT(*) as Total_Obligaciones,
        COUNT(DISTINCT Numero_Id) as Total_Clientes,
        SUM(Saldo_Capital) as Saldo_Total,
        SUM(Valor_Valuativo) as Costo_Amortizable_Total,
        AVG(Valor_Valuativo) as Costo_Promedio,
        MIN(Valor_Valuativo) as Costo_Minimo,
        MAX(Valor_Valuativo) as Costo_Maximo
    FROM bd_costo_amortizable_MM_AAAA
    
    -- Por herramienta
    SELECT 
        Herramienta,
        Tipo_Herramienta,
        COUNT(*) as Cantidad,
        SUM(Saldo_Capital) as Saldo,
        SUM(Valor_Valuativo) as Costo_Amortizable
    FROM bd_costo_amortizable_MM_AAAA
    GROUP BY Herramienta, Tipo_Herramienta
    ORDER BY Herramienta, Tipo_Herramienta
    ```

15. **Validar completitud de información adicional**
    
    ```sql
    -- Verificar % de campos completos
    SELECT 
        COUNT(*) as Total,
        SUM(CASE WHEN Nombre_Cliente IS NOT NULL THEN 1 ELSE 0 END) as Con_Nombre,
        SUM(CASE WHEN Producto IS NOT NULL THEN 1 ELSE 0 END) as Con_Producto,
        SUM(CASE WHEN Calificacion_Riesgo IS NOT NULL THEN 1 ELSE 0 END) as Con_Riesgo,
        CAST(SUM(CASE WHEN Nombre_Cliente IS NOT NULL THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 as Porc_Completo
    FROM bd_costo_amortizable_MM_AAAA
    ```

16. **Otorgar permisos de lectura**
    
    ```sql
    -- Dar permisos a roles que necesitan consultar
    GRANT SELECT ON bd_costo_amortizable_MM_AAAA 
    TO [CONTABILIDAD_LECTORES], [RIESGOS_ANALISTAS], [AUDITORIA]
    
    -- Solo ciertos usuarios pueden modificar
    GRANT UPDATE, DELETE ON bd_costo_amortizable_MM_AAAA 
    TO [RIESGOS_ADMIN]
    ```

17. **Crear vista histórica consolidada**
    
    ```sql
    -- Vista que une todos los meses
    CREATE OR ALTER VIEW vw_costo_amortizable_historico AS
    SELECT *, '01_2025' as Periodo FROM bd_costo_amortizable_01_2025
    UNION ALL
    SELECT *, '02_2025' as Periodo FROM bd_costo_amortizable_02_2025
    UNION ALL
    SELECT *, '03_2025' as Periodo FROM bd_costo_amortizable_03_2025
    -- ... etc para todos los meses disponibles
    
    -- Dar permisos a la vista
    GRANT SELECT ON vw_costo_amortizable_historico TO [PUBLIC]
    ```

18. **Documentar metadatos de la tabla**
    
    ```sql
    -- Agregar descripción a la tabla
    EXEC sp_addextendedproperty 
        @name = N'MS_Description',
        @value = N'Tabla mensual de costo amortizable calculado por obligaciones reestructuradas, modificadas y retenidas. Incluye valor valuativo y datos complementarios de cliente y producto.',
        @level0type = N'SCHEMA', @level0name = 'dbo',
        @level1type = N'TABLE', @level1name = 'bd_costo_amortizable_MM_AAAA'
    
    -- Descripción de columnas clave
    EXEC sp_addextendedproperty 
        @name = N'MS_Description',
        @value = N'Valor valuativo calculado (costo amortizable) de la obligación',
        @level0type = N'SCHEMA', @level0name = 'dbo',
        @level1type = N'TABLE', @level1name = 'bd_costo_amortizable_MM_AAAA',
        @level2type = N'COLUMN', @level2name = 'Valor_Valuativo'
    ```

19. **Registrar en tabla de control de procesos**
    
    ```sql
    -- Insertar registro de ejecución en tabla de control
    INSERT INTO tbl_control_procesos (
        proceso,
        periodo,
        fecha_ejecucion,
        estado,
        registros_procesados,
        valor_total,
        observaciones
    )
    VALUES (
        'COSTO_AMORTIZABLE',
        'MM_AAAA',
        GETDATE(),
        'COMPLETADO',
        (SELECT COUNT(*) FROM bd_costo_amortizable_MM_AAAA),
        (SELECT SUM(Valor_Valuativo) FROM bd_costo_amortizable_MM_AAAA),
        'Carga y completitud exitosa desde HU-18'
    )
    ```

20. **Generar reporte de carga**
    
    Crear reporte con:
    - Timestamp de carga
    - Registros cargados
    - Estadísticas principales
    - % de completitud de campos adicionales
    - Validaciones ejecutadas
    - Estado: EXITOSO / CON ADVERTENCIAS / FALLIDO

### Puntos de Control Crítico

1. **Carga fallida:** Si no se pueden cargar datos desde Excel o SQL, detener proceso.

2. **Conteo no coincide:** Si el número de registros en SQL no coincide con Excel, detener y revisar.

3. **Valores valuativos nulos:** Si hay obligaciones sin Valor_Valuativo, detener (error en HU-16 o HU-17).

4. **Segundo query falla:** Si el query de completitud falla por tablas no disponibles, registrar advertencia pero continuar (no es crítico).

### Puntos de Control No Crítico

1. **Campos adicionales no completos:** Si campos como Nombre_Cliente o Producto tienen NULLs (< 20%), registrar advertencia pero continuar.

2. **Vista histórica no se puede crear:** Si meses anteriores no existen, es normal. Crear vista cuando haya suficiente histórico.

### Salidas

1. **Tabla SQL:**
   - `DWH_Riesgos_Credito.dbo.bd_costo_amortizable_MM_AAAA`
   - Todos los registros con valor valuativo
   - Información complementaria
   - Índices creados
   - Permisos otorgados

2. **Vista histórica:**
   - `vw_costo_amortizable_historico` (si aplica)

3. **Registro en tabla de control:**
   - Entrada en `tbl_control_procesos`

4. **Reporte de carga:**
   - `reportes/Reporte_Carga_SQL_MM_AAAA.xlsx` o en log

5. **Log:** `logs/ejecuciones/HU18_Carga_SQL_AAAAMMDD_HHMMSS.log`

### Reportería

Log con:
- **Carga exitosa:**
  - Registros cargados: XXX
  - Tabla creada: bd_costo_amortizable_MM_AAAA
  
- **Estadísticas:**
  - Costo Amortizable Total: $XXX,XXX,XXX
  - Por herramienta: Reestructurado $XX, Modificado $XX, Retención $XX
  
- **Completitud:**
  - Nombre_Cliente: XX% completo
  - Producto: XX% completo
  - Calificación_Riesgo: XX% completo
  
- **Índices creados:** 5 índices
- **Permisos otorgados:** 3 roles
- **Tiempo de ejecución:** XX minutos

### Parametría

- **Servidor SQL:** `10.1.5.172\RIESGOS` (configurable)
- **Base de datos:** `DWH_Riesgos_Credito` (configurable)
- **Tabla destino:** `bd_costo_amortizable_MM_AAAA` (configurable)
- **Servidor DWH fuente:** `10.1.3.101\SCC` (configurable)
- **Tablas de referencia:** maestro_clientes, productos_credito, riesgo_credito (configurables)

---

## Dependencias

### Historias de Usuario Previas
- **HU-15:** Tabla bd_perdidas_ganancias_dwh creada
- **HU-16:** Cálculos completos
- **HU-17:** Archivo de envío generado

### Historias de Usuario Posteriores
- **HU-19:** Consolidar hoja base - Leerá esta tabla
- **HU-20:** Verificación producción - Comparará con esta tabla
- **HU-21:** Cargue final - Puede usar esta tabla como referencia

### Recursos Externos
- **Permisos SQL:** CREATE TABLE, CREATE INDEX, GRANT
- **Linked Server:** Configurado a servidor SCC para queries de completitud
- **Tablas de referencia:** maestro_clientes, productos_credito, riesgo_credito deben existir

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 2 horas |
| Desarrollo SQL Scripts | 2 horas |
| Pruebas | 1 hora |
| **Total** | **5 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **Dos fuentes posibles:** Se puede cargar desde Excel (HU-17) o desde tabla SQL (HU-15). Excel es más completo, SQL es más rápido.

- **Segundo query de completitud opcional:** Los campos adicionales (Nombre_Cliente, Producto, etc.) son complementarios. Si no se pueden obtener, el proceso puede continuar.

- **Vista histórica incremental:** Se va construyendo mes a mes. Los primeros meses no habrá mucho histórico.

### Consideraciones de Negocio

- **Tabla maestra para reportería:** Esta tabla es la fuente oficial para reportes mensuales, análisis de tendencias y auditorías.

- **Información complementaria enriquece análisis:** Los datos de cliente, producto y riesgo permiten análisis más profundos (ej: ¿qué segmentos tienen mayor costo amortizable?).

- **Histórico para tendencias:** La vista histórica permite analizar evolución del costo amortizable en el tiempo.

### Riesgos Identificados

- **Riesgo 1: Linked Server no configurado**
  - Impacto: Medio - No se puede ejecutar segundo query
  - Mitigación: Validar Linked Server al inicio. Si no existe, continuar sin completitud adicional.

- **Riesgo 2: Tablas de referencia desactualizadas**
  - Impacto: Bajo - Información complementaria incompleta
  - Mitigación: Coordinar con área de datos para mantener tablas actualizadas. Registrar % de completitud.

- **Riesgo 3: Performance de queries con JOIN entre servidores**
  - Impacto: Medio - Proceso lento
  - Mitigación: Traer datos a tablas temporales locales antes de hacer JOIN. Ejecutar en horario de baja carga.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 11/11/2025
