# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 02 |
| **Nombre Historia** | Preparación del Archivo de Consolidación |
| **No. Versión** | 1 |
| **Fecha Creación** | 10/11/2025 14:30 |
| **Fecha Modificación** | 10/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Preparar el archivo Excel de consolidación mensual limpiando las pestañas de datos anteriores

**De forma que:** Tenga una estructura limpia y organizada donde consolidar los datos extraídos de las consultas SQL del mes actual

---

## Criterios de Aceptación

### Insumos

1. **Archivo plantilla:** `01. información Consolidada_Plantilla.xlsx` ubicado en `data/input/plantillas/`
2. **Queries ejecutados** en HU-01 (tablas temporales SQL activas)
3. **Fecha del mes anterior** calculada en HU-01 para nombrar el archivo (formato: MM_AAAA)
4. **Estructura de carpetas** de salida: `data/output/reportes/AAAA/MM/`

### Entradas de las Funcionalidades

- Archivo plantilla Excel con 8 pestañas preconfiguradas y formateadas
- Fecha del mes de cierre para nombrado dinámico del archivo
- Estructura de encabezados y formatos predefinidos en cada pestaña

### Funcionalidades

1. **Validar existencia del archivo plantilla**
   
   El asistente debe verificar que el archivo plantilla existe en la ruta especificada `data/input/plantillas/01. información Consolidada_Plantilla.xlsx`. Si no existe, detener el proceso y notificar.

2. **Crear estructura de carpetas de salida**
   
   - Obtener año y mes de la fecha de cierre
   - Crear estructura de carpetas: `data/output/reportes/AAAA/MM/`
   - Ejemplo: Para abril 2025 crear: `data/output/reportes/2025/04/`
   - Si las carpetas ya existen, continuar sin error

3. **Copiar archivo plantilla con nombre dinámico**
   
   - Copiar el archivo plantilla a la carpeta de salida
   - Nombrar el archivo: `01. información Consolidada MM_AAAA.xlsx`
   - Ejemplo: `01. información Consolidada 04_2025.xlsx`
   - Si ya existe un archivo con ese nombre, sobrescribirlo (se asume re-ejecución)

4. **Abrir el archivo Excel copiado**
   
   Utilizando las acciones de Excel de Power Automate Desktop:
   - Abrir el archivo en modo no visible (background)
   - No mostrar alertas de Excel durante el proceso
   - Mantener la instancia de Excel activa para las operaciones siguientes

5. **Validar estructura de pestañas**
   
   Verificar que las 8 pestañas requeridas existen en el archivo:
   - `1. Consolidadas Reestructuradas`
   - `2. Consolidadas Modificadas`
   - `3. Reestructurados totales`
   - `4. Modificados totales`
   - `5. Retenidos`
   - `6. Reestructurados`
   - `7. Modificados`
   - `8. Retenidos`
   
   Si falta alguna pestaña, registrar error y detener el proceso.

6. **Limpiar datos de cada pestaña preservando encabezados**
   
   Para cada una de las 8 pestañas, ejecutar el siguiente proceso:
   
   - Activar la pestaña
   - Identificar la fila de encabezados (generalmente fila 1)
   - Obtener el último número de fila con datos
   - Seleccionar el rango desde la fila 2 hasta la última fila
   - Eliminar todo el contenido del rango seleccionado (valores, NO formatos ni fórmulas en encabezados)
   - Preservar formatos de celdas (moneda, número, fecha, etc.)
   - Preservar fórmulas en encabezados si existen
   - Preservar validaciones de datos si existen

7. **Verificar limpieza exitosa**
   
   Para cada pestaña:
   - Contar el número de filas con datos (debe ser solo 1 = encabezados)
   - Verificar que los encabezados permanecen intactos
   - Registrar en log el número de filas que fueron eliminadas de cada pestaña

8. **Guardar y cerrar el archivo Excel**
   
   - Guardar los cambios en el archivo
   - Cerrar el archivo Excel
   - Cerrar la instancia de Excel
   - Liberar recursos

9. **Almacenar ruta del archivo en variable global**
   
   - Guardar la ruta completa del archivo en variable: `%ArchivoConsolidacion%`
   - Esta variable será utilizada por las HU-03 a HU-10 para escribir datos

10. **Registrar estadísticas en log**
    
    - Ruta del archivo creado
    - Nombre del archivo
    - Número de pestañas procesadas
    - Número total de filas eliminadas
    - Tamaño del archivo resultante
    - Timestamp de finalización

### Puntos de Control Crítico

1. **Validación de plantilla:** Si el archivo plantilla no existe o no es accesible, detener el proceso y enviar notificación. No continuar sin la plantilla correcta.

2. **Validación de estructura:** Si alguna de las 8 pestañas requeridas no existe en la plantilla, detener el proceso. La estructura debe ser exacta.

3. **Validación de permisos:** Si no se tienen permisos de escritura en la carpeta de salida, detener el proceso.

4. **Validación de Excel:** Si no se puede abrir el archivo Excel (corrupto, bloqueado por otro proceso), detener el proceso después de 3 reintentos.

### Puntos de Control No Crítico

1. **Advertencia de archivo existente:** Si el archivo del mes ya existe, registrar advertencia indicando que será sobrescrito (posible re-ejecución del proceso).

2. **Advertencia de plantilla con datos:** Si la plantilla ya contiene datos residuales, registrar advertencia pero continuar con la limpieza.

3. **Advertencia de formato:** Si se detectan formatos inconsistentes en los encabezados, registrar advertencia pero continuar.

### Salidas

1. **Archivo Excel:** `01. información Consolidada MM_AAAA.xlsx` en la ruta `data/output/reportes/AAAA/MM/`
   - Todas las pestañas limpiadas
   - Solo encabezados presentes
   - Formatos preservados
   - Listo para recibir datos

2. **Variable global:** `%ArchivoConsolidacion%` con la ruta completa al archivo creado

3. **Archivo de log:** `logs/ejecuciones/HU02_Preparacion_Consolidacion_AAAAMMDD_HHMMSS.log`

### Reportería

**Log de ejecución** que incluye:
- Nombre del archivo creado
- Ruta completa del archivo
- Estadísticas de limpieza por pestaña (filas eliminadas)
- Validaciones ejecutadas
- Tiempo total de procesamiento

### Parametría

- **Ruta plantilla:** `data/input/plantillas/01. información Consolidada_Plantilla.xlsx` (configurable)
- **Ruta base de salida:** `data/output/reportes/` (configurable)
- **Prefijo de archivo:** `01. información Consolidada` (configurable)
- **Formato de fecha en nombre:** `MM_AAAA` (configurable)
- **Excel en modo visible:** `No` (configurable para debug)
- **Sobrescribir archivo existente:** `Sí` (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-01:** Extracción de Créditos Reestructurados y Modificados - Requiere que se haya calculado la fecha del mes anterior

### Historias de Usuario Posteriores
- **HU-03 a HU-10:** Todas las historias de consolidación de datos requieren el archivo Excel limpio y la variable `%ArchivoConsolidacion%` poblada

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 2 horas |
| Desarrollo Python (script auxiliar opcional) | 1 hora |
| Pruebas unitarias | 1 hora |
| Pruebas integradas | 1 hora |
| **Total** | **5 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **Excel en background:** El archivo Excel debe procesarse en modo no visible para optimizar rendimiento y evitar interferencias del usuario.

- **Manejo de memoria:** Cerrar la instancia de Excel correctamente para liberar memoria. Usar bloques Try-Finally para garantizar cierre incluso si hay errores.

- **Alternativa Python:** Se puede usar la librería `openpyxl` de Python para manipular el archivo sin necesidad de tener Excel instalado, lo que optimiza rendimiento.

- **Preservación de formato:** Es crítico que los formatos de celdas (moneda, porcentaje, fecha) se mantengan intactos para que las próximas HU funcionen correctamente.

- **Validación de plantilla:** Considerar implementar un checksum o validación de versión de la plantilla para asegurar compatibilidad.

### Consideraciones de Negocio

- **Frecuencia:** Esta operación se ejecuta una vez al mes como segundo paso del proceso de Costo Amortizable.

- **Tiempo de ejecución:** Aproximadamente 15-30 segundos dependiendo del tamaño de la plantilla.

- **Criticidad:** Media-Alta - Si falla, no se pueden consolidar los datos, pero se puede reintentar fácilmente.

### Riesgos Identificados

- **Riesgo 1: Plantilla modificada o corrupta**
  - Impacto: Alto - Puede causar errores en toda la cadena de HU posteriores
  - Mitigación: Implementar versionado de plantilla y validación de estructura antes de usar

- **Riesgo 2: Archivo bloqueado por otro proceso**
  - Impacto: Medio - Impide la creación/modificación del archivo
  - Mitigación: Implementar reintentos con delay y verificar que no hay instancias de Excel abiertas con el archivo

- **Riesgo 3: Permisos insuficientes en carpeta de salida**
  - Impacto: Alto - No se puede crear el archivo
  - Mitigación: Validar permisos al inicio del proceso y configurar carpetas con permisos apropiados

- **Riesgo 4: Disco lleno**
  - Impacto: Alto - No se puede guardar el archivo
  - Mitigación: Verificar espacio disponible en disco antes de copiar archivo (mínimo 100 MB libres)

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 10/11/2025
