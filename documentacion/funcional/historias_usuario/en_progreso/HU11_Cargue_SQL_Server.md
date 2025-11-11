# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 11 |
| **Nombre Historia** | Cargar Bases Organizadas en SQL Server |
| **No. Versión** | 1 |
| **Fecha Creación** | 10/11/2025 17:30 |
| **Fecha Modificación** | 10/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Cargar las 3 pestañas organizadas (6, 7, 8) desde el archivo Excel hacia tablas SQL permanentes en el servidor de Riesgos

**De forma que:** Los datos estén disponibles en SQL Server para las validaciones, cruces y cálculos posteriores del proceso

---

## Criterios de Aceptación

### Insumos

1. **Archivo Excel:** `01. información Consolidada MM_AAAA.xlsx` (con HU-08, HU-09, HU-10 completadas)
2. **Pestaña 6:** "Reestructurados" (organizada en HU-08)
3. **Pestaña 7:** "Modificados" (organizada en HU-09)
4. **Pestaña 8:** "Retenidos" (organizada en HU-10)
5. **Servidor SQL:** 10.1.5.172\RIESGOS
6. **Base de datos:** DWH_Riesgos_Credito

### Entradas de las Funcionalidades

- Ruta del archivo Excel con pestañas organizadas
- Credenciales para conexión SQL Server (usuario, contraseña)
- Nombres de tablas destino en SQL
- Parámetros de mes y año (para nombrar tablas)

### Funcionalidades

1. **Preparar conexión a SQL Server**
   
   - Leer credenciales desde configuración segura
   - Servidor: `10.1.5.172\RIESGOS`
   - Base de datos: `DWH_Riesgos_Credito`
   - Establecer conexión con autenticación SQL Server
   - Validar conexión exitosa

2. **Eliminar tablas del mes anterior (si existen)**
   
   Antes de cargar, eliminar tablas del mes actual si existen:
   ```sql
   DROP TABLE IF EXISTS DWH_Riesgos_Credito.dbo.bd_reestructurados_MM_AAAA
   DROP TABLE IF EXISTS DWH_Riesgos_Credito.dbo.bd_modificados_MM_AAAA
   DROP TABLE IF EXISTS DWH_Riesgos_Credito.dbo.bd_retenciones_MM_AAAA
   ```
   
   - MM = mes en 2 dígitos (ej: 04)
   - AAAA = año en 4 dígitos (ej: 2025)
   - Si no existen, continuar sin error

3. **Validar existencia del archivo Excel**
   
   - Verificar que archivo `01. información Consolidada MM_AAAA.xlsx` existe
   - Verificar que no está abierto por otro usuario o proceso
   - Si está abierto, intentar cerrar o esperar hasta 3 minutos
   - Validar que tiene las 3 pestañas necesarias (6, 7, 8)

4. **Cargar pestaña 6 - Reestructurados**
   
   **Opción A: Usar SQL Server Import Wizard (Recomendado para PAD)**
   - Abrir asistente de importación de SQL Server
   - Origen: Microsoft Excel
   - Seleccionar archivo y pestaña `6. Reestructurados$`
   - Destino: SQL Server (10.1.5.172\RIESGOS)
   - Tabla destino: `bd_reestructurados_MM_AAAA`
   - Mapear columnas automáticamente
   - Ejecutar importación
   
   **Opción B: Script Python con pandas (Alternativa)**
   - Leer pestaña con pandas
   - Crear tabla con sqlalchemy
   - Insertar datos con to_sql()
   
   Validar:
   - Carga completa sin errores
   - Cantidad de registros coincide con Excel
   - Todas las columnas fueron importadas

5. **Cargar pestaña 7 - Modificados**
   
   - Usar mismo método que pestaña 6
   - Origen: Pestaña `7. Modificados$`
   - Tabla destino: `bd_modificados_MM_AAAA`
   - Validar carga completa
   - Verificar cantidad de registros

6. **Cargar pestaña 8 - Retenidos**
   
   - Usar mismo método que pestañas anteriores
   - Origen: Pestaña `8. Retenidos$`
   - Tabla destino: `bd_retenciones_MM_AAAA`
   - Validar carga completa
   - Verificar cantidad de registros
   - Nota: Esta tabla puede estar vacía si el mes no tuvo retenciones

7. **Validar estructura de tablas en SQL**
   
   Para cada tabla, verificar:
   ```sql
   SELECT COUNT(*) FROM bd_reestructurados_MM_AAAA
   SELECT COUNT(*) FROM bd_modificados_MM_AAAA
   SELECT COUNT(*) FROM bd_retenciones_MM_AAAA
   ```
   
   Validar columnas principales:
   - Fecha_Corte (o Fecha)
   - Herramienta
   - Tipo_Herramienta
   - Tipo_Obligacion
   - obligacion_nueva
   - Columnas de obligaciones (obligacion1, obligacion2, etc.)

8. **Verificar tipos de datos**
   
   Para cada tabla:
   - Fecha_Corte: VARCHAR o DATE
   - Herramienta: VARCHAR
   - Tipo_Herramienta: VARCHAR
   - Tipo_Obligacion: VARCHAR
   - Obligaciones: VARCHAR (números como texto)
   
   Si los tipos no son correctos, puede requerirse ajuste manual o reintentar importación con configuración específica

9. **Validar integridad de datos**
   
   Ejecutar consultas de validación:
   
   a) **Reestructurados - Verificar metadatos:**
   ```sql
   SELECT DISTINCT Herramienta, Tipo_Herramienta, Tipo_Obligacion
   FROM bd_reestructurados_MM_AAAA
   ```
   Debe retornar solo combinaciones válidas:
   - Reestructurado + Consolidada + Diferente Obligación
   - Reestructurado + Individual + Misma Obligación
   
   b) **Modificados - Verificar metadatos:**
   ```sql
   SELECT DISTINCT Herramienta, Tipo_Herramienta, Tipo_Obligacion
   FROM bd_modificados_MM_AAAA
   ```
   Debe retornar solo:
   - Modificado + Consolidada + Diferente Obligación
   - Modificado + Individual + Misma Obligación
   
   c) **Retenciones - Verificar metadatos:**
   ```sql
   SELECT DISTINCT Herramienta, Tipo_Herramienta, Tipo_Obligacion
   FROM bd_retenciones_MM_AAAA
   ```
   Debe retornar SOLO:
   - Retención + Individual + Misma Obligación

10. **Validar obligaciones no nulas**
    
    Para cada tabla:
    ```sql
    SELECT COUNT(*) FROM bd_reestructurados_MM_AAAA 
    WHERE obligacion_nueva IS NULL OR obligacion_nueva = ''
    ```
    Debe retornar 0 (todas las obligaciones nuevas pobladas)
    
    Repetir para bd_modificados y bd_retenciones

11. **Comparar conteos Excel vs SQL**
    
    - Contar filas en Excel (pestaña 6, 7, 8)
    - Contar registros en SQL (3 tablas)
    - Los números deben coincidir exactamente
    - Si hay diferencia, investigar causa (encabezados, filas vacías, error de importación)

12. **Registrar estadísticas de carga**
    
    - Timestamp de inicio y fin de carga
    - Cantidad de registros por tabla
    - Tiempo de carga por tabla
    - Validaciones exitosas
    - Cualquier advertencia o error

13. **Cerrar conexión SQL**
    
    - Cerrar conexión a SQL Server
    - Liberar recursos
    - Confirmar operación exitosa

### Puntos de Control Crítico

1. **Validación de conexión SQL:** Si no se puede conectar a SQL Server, detener proceso y notificar error de infraestructura.

2. **Validación de importación completa:** Si alguna tabla tiene 0 registros pero el Excel tenía datos, detener y reintentar carga.

3. **Validación de conteos:** Si los conteos SQL vs Excel no coinciden, detener proceso y validar manualmente qué se perdió.

4. **Validación de obligaciones nulas:** Si hay obligaciones nulas, detener proceso (indica error en HU-08, 09 o 10).

5. **Validación de metadatos:** Si aparecen combinaciones inválidas de Herramienta+Tipo+Obligacion, detener proceso (indica error en organización).

### Puntos de Control No Crítico

1. **Tabla de retenciones vacía:** Es válido si el mes no tuvo retenciones. Registrar advertencia pero continuar.

2. **Tipos de datos:** Si SQL Server asigna tipos diferentes a los esperados pero los datos son correctos, registrar advertencia pero continuar.

3. **Tiempo de carga:** Si la carga toma más de lo esperado pero es exitosa, registrar advertencia pero continuar.

### Salidas

1. **Tabla SQL:** `DWH_Riesgos_Credito.dbo.bd_reestructurados_MM_AAAA`
   - Estructura: Misma que pestaña 6
   - Registros: Todos los reestructurados del mes

2. **Tabla SQL:** `DWH_Riesgos_Credito.dbo.bd_modificados_MM_AAAA`
   - Estructura: Misma que pestaña 7
   - Registros: Todos los modificados del mes

3. **Tabla SQL:** `DWH_Riesgos_Credito.dbo.bd_retenciones_MM_AAAA`
   - Estructura: Misma que pestaña 8
   - Registros: Todas las retenciones del mes (puede estar vacía)

4. **Log:** `logs/ejecuciones/HU11_Cargue_SQL_AAAAMMDD_HHMMSS.log`

5. **Reporte de validación:** Documento con:
   - Conteos por tabla
   - Validaciones ejecutadas
   - Cualquier discrepancia o advertencia

### Reportería

Log detallado con:
- Timestamp de inicio y fin de cada carga
- Registros cargados por tabla:
  - Reestructurados: XXX registros
  - Modificados: XXX registros
  - Retenciones: XXX registros
- Validaciones de integridad ejecutadas
- Comparación Excel vs SQL (debe ser 100% coincidente)
- Tiempo total de carga
- Estado: EXITOSO / FALLIDO

### Parametría

- **Servidor SQL:** `10.1.5.172\RIESGOS` (configurable)
- **Base de datos:** `DWH_Riesgos_Credito` (configurable)
- **Nombres de tablas:**
  - `bd_reestructurados_MM_AAAA` (configurable)
  - `bd_modificados_MM_AAAA` (configurable)
  - `bd_retenciones_MM_AAAA` (configurable)
- **Timeout de conexión:** 30 segundos (configurable)
- **Timeout de espera Excel:** 180 segundos (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-08:** Pestaña 6 organizada
- **HU-09:** Pestaña 7 organizada
- **HU-10:** Pestaña 8 organizada y Excel cerrado

### Historias de Usuario Posteriores
- **HU-12:** Validación/Completitud SQL - Leerá estas 3 tablas
- **HU-13:** Recolección de tasas/plazos - Leerá estas 3 tablas
- **HU-15:** Query variables valuativo - Leerá estas 3 tablas

### Recursos Externos
- **Servidor SQL:** 10.1.5.172\RIESGOS debe estar disponible
- **Permisos:** Usuario debe tener permisos CREATE TABLE, INSERT en DWH_Riesgos_Credito
- **Red:** Conectividad entre equipo de ejecución y servidor SQL

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 4 horas |
| Desarrollo Python (opcional) | 2 horas |
| Pruebas unitarias | 2 horas |
| Pruebas integradas | 2 horas |
| **Total** | **10 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **SQL Server Import Wizard en PAD:** Power Automate Desktop puede invocar el asistente de importación de SQL Server usando acciones de UI. Es la forma más confiable para cargar desde Excel.

- **Alternativa Python:** Se puede usar pandas + pyodbc + sqlalchemy para carga programática. Más rápido y con mejor manejo de errores, pero requiere Python instalado.

- **Tipos de datos:** SQL Server intentará inferir tipos automáticamente. Es importante validar que las obligaciones se carguen como VARCHAR (texto) y no como números (para mantener ceros a la izquierda).

- **Tablas mensuales:** Las tablas se crean con sufijo MM_AAAA para mantener histórico. Cada mes se crean nuevas tablas.

- **Eliminación de tablas anteriores:** Se eliminan tablas del mismo mes si existen (re-ejecuciones del proceso).

### Consideraciones de Negocio

- **Punto de no retorno:** Después de HU-11, el proceso migra de Excel a SQL. Los pasos siguientes trabajarán directamente en SQL, con menos intervención manual.

- **Histórico:** Las tablas mensuales permiten trazabilidad y auditoría. No se sobrescriben meses anteriores.

- **Disponibilidad para otros procesos:** Una vez cargado en SQL, otros analistas pueden consultar los datos para análisis adicionales.

### Riesgos Identificados

- **Riesgo 1: Servidor SQL no disponible**
  - Impacto: Alto - Detiene el proceso completamente
  - Mitigación: Validar conectividad al inicio. Tener plan de contingencia (servidor alterno). Notificar a infraestructura inmediatamente.

- **Riesgo 2: Excel bloqueado por otro usuario**
  - Impacto: Medio - Retrasa la carga
  - Mitigación: Implementar espera con timeout. Notificar al usuario para que cierre el archivo.

- **Riesgo 3: Pérdida de datos en importación**
  - Impacto: Alto - Datos incompletos en SQL
  - Mitigación: Validaciones exhaustivas de conteo Excel vs SQL. Comparar muestra de registros manualmente.

- **Riesgo 4: Permisos insuficientes**
  - Impacto: Alto - No se pueden crear tablas
  - Mitigación: Validar permisos al inicio. Tener usuario con permisos elevados como backup.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 10/11/2025
