# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 01 |
| **Nombre Historia** | Extracción de Créditos Reestructurados y Modificados desde DWH |
| **No. Versión** | 1 |
| **Fecha Creación** | 10/11/2025 14:00 |
| **Fecha Modificación** | 10/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Ejecutar queries SQL dinámicos en el Data Warehouse para extraer información de créditos reestructurados y modificados del mes anterior

**De forma que:** Pueda consolidar los datos base necesarios para el cálculo del costo amortizable y generar las tablas temporales de trabajo

---

## Criterios de Aceptación

### Insumos

1. **Script SQL:** `01_Consulta_DWH_Reestructurados_Modificados.sql` ubicado en `scripts/sql/`
2. **Archivo de configuración:** `conexiones_sql.json` con credenciales y parámetros de conexión al servidor
3. **Fecha de cierre:** Último día del mes anterior calculado automáticamente (formato: AAAA/MM/DD)
4. **Credenciales de acceso:** Servidor `10.1.3.101\SCC` - Base de datos `DWH_CC`

### Entradas de las Funcionalidades

Información almacenada en el Data Warehouse del Banco que contiene:
- Créditos reestructurados del mes anterior
- Créditos modificados del mes anterior
- Obligaciones consolidadas y obligaciones individuales por cliente

### Funcionalidades

1. **Establecer conexión con el servidor SQL**
   
   El asistente debe conectarse al servidor `10.1.3.101\SCC` utilizando las credenciales configuradas en el archivo `conexiones_sql.json`. La conexión debe validarse antes de ejecutar cualquier query.

2. **Calcular y formatear la fecha del mes anterior**
   
   - Obtener la fecha actual del sistema
   - Calcular el último día del mes anterior
   - Formatear la fecha al formato requerido: `AAAA/MM/DD`
   - Ejemplo: Si se ejecuta el 15/05/2025, la fecha será: `2025/04/30`

3. **Seleccionar la base de datos DWH_CC**
   
   Cambiar el contexto de la conexión a la base de datos `DWH_CC` donde se encuentran las tablas de créditos.

4. **Ejecutar query para crear tabla temporal #Base (Créditos Reestructurados)**
   
   - Leer la sección del script SQL: `drop table #Base`
   - Reemplazar el parámetro de fecha con la fecha calculada
   - Ejecutar la sentencia SQL para crear y poblar la tabla temporal `#Base` con los créditos reestructurados
   - La tabla debe contener: obligación nueva, obligación anterior, fecha de reestructuración, tipo de herramienta

5. **Ejecutar query para crear tabla temporal #Base2 (Créditos Modificados)**
   
   - Leer la sección del script SQL: `drop table #Base2`
   - Reemplazar el parámetro de fecha con la fecha calculada
   - Ejecutar la sentencia SQL para crear y poblar la tabla temporal `#Base2` con los créditos modificados
   - La tabla debe contener: obligación nueva, obligación anterior, posición, fecha de modificación

6. **Determinar el número máximo de obligaciones por cliente**
   
   - Ejecutar la consulta: `select max(obligaciones) as max_oblig from #Base`
   - Capturar el resultado (ejemplo: si retorna 4, significa que un cliente tiene hasta 4 obligaciones anteriores consolidadas)
   - Validar que el resultado sea mayor a 0

7. **Crear columnas dinámicas de obligaciones en tabla #Base**
   
   El asistente debe ejecutar un bucle iterativo para crear tantas columnas de obligación como indique el resultado del paso anterior:
   
   - Para cada número de obligación (desde 1 hasta N):
     - Ejecutar: `alter table #base add obligacion{i} VARCHAR(50)`
     - Ejecutar: `update a set a.obligacion{i} = b.obligacion from #base a inner join #Base2 b on a.obligacion_nueva = b.obligacion_nueva where b.posicion = {i}`
   
   - Ejemplo: Si max(obligaciones) = 4, se deben crear: obligacion1, obligacion2, obligacion3, obligacion4
   - Cada columna debe poblarse con la obligación correspondiente según la posición

8. **Validar que las tablas temporales contienen registros**
   
   - Ejecutar: `select count(*) from #Base` - validar que count > 0
   - Ejecutar: `select count(*) from #Base2` - validar que count > 0
   - Si alguna tabla está vacía, generar advertencia en el log pero continuar el proceso

9. **Registrar estadísticas de ejecución en log**
   
   - Fecha procesada
   - Número de obligaciones detectadas
   - Cantidad de registros en #Base
   - Cantidad de registros en #Base2
   - Timestamp de inicio y fin
   - Duración total de la ejecución

### Puntos de Control Crítico

1. **Validación de conexión SQL:** Si no se puede establecer conexión con el servidor `10.1.3.101\SCC`, el proceso debe detenerse y enviar notificación. Se permiten 3 reintentos con intervalo de 30 segundos.

2. **Validación de fecha:** Si la fecha calculada es inválida o futura, el proceso debe detenerse inmediatamente.

3. **Validación de base de datos:** Si la base de datos `DWH_CC` no existe o no es accesible, el proceso debe detenerse.

4. **Validación de max(obligaciones):** Si el resultado es 0 o NULL, el proceso debe detenerse y notificar que no hay datos para procesar.

### Puntos de Control No Crítico

1. **Advertencia de tablas vacías:** Si #Base o #Base2 no contienen registros, generar advertencia en log pero permitir continuar el proceso.

2. **Advertencia de rendimiento:** Si la ejecución de un query toma más de 5 minutos, registrar advertencia de rendimiento en el log.

3. **Advertencia de número alto de obligaciones:** Si max(obligaciones) > 10, registrar advertencia ya que es inusual y podría indicar datos anómalos.

### Salidas

1. **Tabla temporal #Base:** Tabla en memoria SQL con créditos reestructurados consolidados, incluyendo columnas dinámicas de obligaciones (obligacion1, obligacion2, ..., obligacionN)

2. **Tabla temporal #Base2:** Tabla en memoria SQL con el detalle de todas las obligaciones anteriores por posición

3. **Variable de sesión:** `%NumeroMaximoObligaciones%` - Almacena el número máximo de obligaciones para uso en historias posteriores

4. **Archivo de log:** `logs/ejecuciones/HU01_Extraccion_DWH_AAAAMMDD_HHMMSS.log` con toda la trazabilidad de la ejecución

### Reportería

**Log de ejecución detallado** que incluye:
- Timestamp de cada operación
- Queries ejecutados
- Cantidad de registros procesados
- Errores o advertencias encontrados
- Tiempo de ejecución de cada query

### Parametría

- **Servidor SQL:** `10.1.3.101\SCC` (configurable en `config/parametros/conexiones_sql.json`)
- **Base de datos:** `DWH_CC` (configurable)
- **Timeout de queries:** 10 minutos por defecto (configurable)
- **Número de reintentos de conexión:** 3 (configurable)
- **Intervalo entre reintentos:** 30 segundos (configurable)
- **Correo de notificaciones:** Lista de correos para alertas críticas (configurable en `config/parametros/notificaciones.json`)

---

## Dependencias

### Historias de Usuario Previas
- **Ninguna** - Esta es la primera historia de usuario del flujo de automatización

### Historias de Usuario Posteriores
- **HU-02:** Preparación del Archivo de Consolidación - Requiere que las tablas temporales #Base y #Base2 estén creadas y pobladas
- **HU-03 a HU-06:** Consolidación de reportes - Requieren la variable `%NumeroMaximoObligaciones%` y las tablas temporales activas

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 4 horas |
| Desarrollo Python (scripts auxiliares) | 3 horas |
| Pruebas unitarias | 2 horas |
| Pruebas integradas | 1 hora |
| **Total** | **10 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **Tablas temporales SQL:** Las tablas #Base y #Base2 son temporales (prefijo #) y solo existen durante la sesión SQL. Deben mantenerse activas hasta que se complete la HU-06. No cerrar la conexión SQL hasta ese punto.

- **Queries dinámicos:** La creación de columnas obligacion1, obligacion2, etc., es dinámica y depende del resultado de max(obligaciones). El código de automatización debe soportar un número variable de obligaciones (históricamente entre 2 y 8, pero puede llegar hasta 25).

- **Rendimiento:** La ejecución de estos queries puede tomar entre 5 y 15 minutos dependiendo del volumen de datos del mes. Se recomienda ejecutar fuera de horario laboral.

- **Herramientas de automatización:** Se utilizará Power Automate Desktop para la orquestación principal y opcionalmente scripts Python para operaciones complejas de SQL dinámico.

### Consideraciones de Negocio

- **Frecuencia de ejecución:** Esta historia se ejecuta mensualmente, los 2 primeros días hábiles después del cierre del mes.

- **Criticidad:** Alta - Es la base de todo el proceso de Costo Amortizable. Si falla, todo el proceso se detiene.

- **Impacto en reportería:** Los datos extraídos alimentan los reportes regulatorios y contables del banco.

### Riesgos Identificados

- **Riesgo 1: Servidor SQL no disponible**
  - Impacto: Alto - Detiene todo el proceso
  - Mitigación: Implementar reintentos automáticos y notificación inmediata al equipo de infraestructura

- **Riesgo 2: Cambios en estructura de tablas del DWH**
  - Impacto: Alto - Los queries fallarían
  - Mitigación: Coordinar con el equipo de DWH para notificar cambios con anticipación. Implementar validaciones de estructura antes de ejecutar queries.

- **Riesgo 3: Volumen de datos inusualmente alto**
  - Impacto: Medio - Puede causar timeout o problemas de rendimiento
  - Mitigación: Configurar timeouts apropiados y monitorear logs de ejecución para identificar tendencias

- **Riesgo 4: Datos corruptos o inconsistentes en DWH**
  - Impacto: Medio - Puede generar resultados incorrectos
  - Mitigación: Implementar validaciones de calidad de datos (valores NULL, formatos incorrectos, duplicados)

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 10/11/2025
