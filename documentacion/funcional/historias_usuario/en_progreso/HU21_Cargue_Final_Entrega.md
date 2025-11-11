# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 21 |
| **Nombre Historia** | Cargue Final y Entrega de Archivo de Producción |
| **No. Versión** | 1 |
| **Fecha Creación** | 11/11/2025 12:30 |
| **Fecha Modificación** | 11/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Generar el archivo final de producción en formato Excel 97-2003 (.xls) y entregarlo a las áreas de Contabilidad y Riesgos para su cargue en sistemas oficiales

**De forma que:** El proceso mensual de RDA Costo Amortizable se complete exitosamente y los datos estén disponibles para contabilización y reportería regulatoria

---

## Criterios de Aceptación

### Insumos

1. **Archivo validado (HU-20):**
   - `01. información Consolidada MM_AAAA_VALIDADO_AAAAMMDD.xlsx`
   - Con pestaña "BASE_FINAL" aprobada

2. **Plantilla formato legacy:**
   - `data/input/plantillas/Plantilla_Cargue_Final_Legacy.xls`
   - Formato Excel 97-2003 requerido por sistema destino

3. **Aprobaciones:**
   - Aprobación del Coordinador de Riesgos
   - Revisión de advertencias completada

### Entradas de las Funcionalidades

- BASE_FINAL validada y aprobada
- Formato de entrega requerido (Excel 97-2003)
- Ruta de entrega (SharePoint o carpeta de red)
- Lista de distribución de notificaciones

### Funcionalidades

1. **Validar aprobaciones previas**
   
   Antes de proceder, verificar:
   - Archivo tiene marca de "VALIDADO" en REPORTE_VERIFICACION
   - Advertencias críticas están resueltas o aprobadas
   - Hay aprobación del Coordinador (puede ser archivo de aprobación, email, etc.)
   
   Si falta alguna aprobación, detener y solicitar

2. **Abrir archivo validado**
   
   - Abrir `01. información Consolidada MM_AAAA_VALIDADO_AAAAMMDD.xlsx`
   - Ir a pestaña "BASE_FINAL"
   - Registrar cantidad de registros a cargar
   - Validar que tiene datos

3. **Copiar plantilla de cargue final**
   
   - Origen: `data/input/plantillas/Plantilla_Cargue_Final_Legacy.xls`
   - Destino: `data/output/reportes/ENTREGA_FINAL/Costo_Amortizable_MM_AAAA.xls`
   - Formato: Excel 97-2003 (.xls)
   - Validar que copia fue exitosa

4. **Abrir archivo de cargue final**
   
   - Abrir `Costo_Amortizable_MM_AAAA.xls`
   - Validar que tiene la pestaña "Cargue" (o nombre definido)
   - Validar estructura de columnas

5. **Mapear columnas de BASE_FINAL a formato de cargue**
   
   Definir mapeo según formato requerido por sistema destino:
   
   | Columna Destino | Columna Origen BASE_FINAL | Transformación |
   |-----------------|---------------------------|----------------|
   | FECHA_CORTE | Fecha_Corte | Formato AAAAMMDD |
   | TIPO_ID | Tipo_Id | Sin cambios |
   | NUMERO_ID | Numero_Id | Sin cambios |
   | OBLIGACION | N_Obligacion | Sin cambios |
   | HERRAMIENTA | Herramienta | Sin cambios |
   | TIPO_HERRAMIENTA | Tipo_Herramienta | Sin cambios |
   | MODALIDAD | Modalidad | Sin cambios |
   | SALDO | Saldo_Capital | Formato número sin decimales |
   | TASA_ANT | Tasa_Anterior | Formato decimal 4 posiciones |
   | TASA_NVA | Tasa_Nueva | Formato decimal 4 posiciones |
   | PLAZO_ANT | Plazo_Anterior | Número entero |
   | PLAZO_NVO | Plazo_Nuevo | Número entero |
   | COSTO_AMORT | Valor_Valuativo | Formato número sin decimales |
   | PORCENTAJE | Porcentaje_Sobre_Saldo | Formato decimal 2 posiciones |
   
   > **Nota:** El mapeo exacto puede variar según especificaciones del sistema destino

6. **Exportar datos desde BASE_FINAL**
   
   - Seleccionar todos los datos de BASE_FINAL
   - Aplicar las transformaciones de formato necesarias
   - Copiar datos

7. **Pegar en archivo de cargue final**
   
   - Ir a pestaña "Cargue" en archivo .xls
   - Pegar desde fila 2 (fila 1 son encabezados)
   - Validar que todos los registros se pegaron
   - Ajustar anchos de columnas

8. **Aplicar formato específico requerido**
   
   a) **Fechas en formato AAAAMMDD:**
   ```
   Si fecha es DD/MM/AAAA, convertir a AAAAMMDD (texto)
   Ejemplo: 30/04/2025 → 20250430
   ```
   
   b) **Números sin separadores de miles:**
   ```
   Formato: 0 (sin comas ni puntos como separadores)
   Ejemplo: 1.234.567 → 1234567
   ```
   
   c) **Decimales con punto (no coma):**
   ```
   Ejemplo: 12,5% → 12.5
   ```
   
   d) **Textos sin caracteres especiales:**
   Reemplazar ñ, tildes, caracteres raros

9. **Agregar fila de totales (si requerido)**
   
   En la última fila:
   - Total registros
   - Suma de Saldo
   - Suma de Costo_Amort
   - Otros totales según especificación
   
   Marcar con código especial (ej: OBLIGACION = "TOTAL")

10. **Validar integridad del archivo de cargue**
    
    Ejecutar validaciones finales:
    
    a) **Conteo coincide:**
    ```
    Registros en Cargue.xls = Registros en BASE_FINAL
    ```
    
    b) **Totales coinciden:**
    ```
    SUM(COSTO_AMORT) en Cargue = SUM(Valor_Valuativo) en BASE_FINAL
    ```
    
    c) **Sin celdas vacías en campos obligatorios:**
    - OBLIGACION, SALDO, COSTO_AMORT no deben estar vacíos
    
    d) **Formatos correctos:**
    - Fechas en formato texto AAAAMMDD
    - Números sin formato moneda

11. **Guardar archivo de cargue en formato correcto**
    
    - Guardar como Excel 97-2003 (.xls)
    - Validar tamaño de archivo (debe ser < 65,536 filas si es .xls)
    - Si excede límite, considerar partir en múltiples archivos o usar .xlsx
    - Cerrar archivo

12. **Generar archivo de metadatos**
    
    Crear archivo `Metadata_Costo_Amortizable_MM_AAAA.txt` con:
    ```
    Proceso: RDA Costo Amortizable
    Periodo: MM/AAAA
    Fecha_Generacion: DD/MM/AAAA HH:MM:SS
    Usuario: [nombre_usuario]
    
    Estadísticas:
    - Total_Registros: XXX
    - Reestructurados: XX
    - Modificados: XX
    - Retenciones: XX
    - Saldo_Total: $XXX,XXX,XXX
    - Costo_Amortizable_Total: $XXX,XXX,XXX
    
    Archivos_Generados:
    - Costo_Amortizable_MM_AAAA.xls
    - Metadata_Costo_Amortizable_MM_AAAA.txt
    - Evidencias_Proceso_MM_AAAA.pdf
    
    Validaciones_Ejecutadas:
    - HU-01 a HU-21: COMPLETADAS
    - Validacion_SQL: OK
    - Verificacion_Produccion: OK
    - Aprobaciones: OK
    
    Contacto:
    - Responsable: [nombre]
    - Email: [email]
    - Telefono: [telefono]
    ```

13. **Generar archivo de evidencias (PDF)**
    
    Compilar en PDF `Evidencias_Proceso_MM_AAAA.pdf`:
    - Portada con información del proceso
    - Resumen ejecutivo (de HU-17)
    - Reporte de verificación (de HU-20)
    - Capturas de pantalla de validaciones exitosas
    - Lista de advertencias resueltas
    - Aprobaciones recibidas

14. **Copiar archivos a carpeta de entrega**
    
    Estructura de carpeta:
    ```
    \\red\compartida\Riesgos\RDA\Costo_Amortizable\MM_AAAA\
        ├── Costo_Amortizable_MM_AAAA.xls (ARCHIVO PRINCIPAL)
        ├── Metadata_Costo_Amortizable_MM_AAAA.txt
        ├── Evidencias_Proceso_MM_AAAA.pdf
        ├── Backup/
        │   ├── 01. información Consolidada MM_AAAA_VALIDADO.xlsx
        │   ├── 02. Pérdidas y Ganancias MM_AAAA.xlsx
        │   ├── 03. Cálculo Amortización MM_AAAA.xlsm
        │   └── 04. Envío Costo Amortizable MM_AAAA.xlsx
        └── Logs/
            └── Log_Completo_Proceso_MM_AAAA.log
    ```

15. **Subir a SharePoint (si aplica)**
    
    Si el banco usa SharePoint:
    - Conectar a sitio de SharePoint de Riesgos
    - Navegar a carpeta: "RDA/Costo Amortizable/AAAA/MM"
    - Subir archivo principal: `Costo_Amortizable_MM_AAAA.xls`
    - Subir metadata y evidencias
    - Validar que archivos se subieron correctamente
    - Obtener links de compartición

16. **Calcular hash de archivo principal (integridad)**
    
    Generar hash SHA-256 del archivo de cargue:
    ```bash
    sha256sum Costo_Amortizable_MM_AAAA.xls
    ```
    
    Guardar hash en archivo de metadata
    Esto permite verificar que archivo no fue modificado después de generación

17. **Registrar en base de datos de control**
    
    Actualizar tabla de control de procesos:
    ```sql
    UPDATE tbl_control_procesos
    SET 
        estado = 'COMPLETADO',
        fecha_finalizacion = GETDATE(),
        archivo_final = 'Costo_Amortizable_MM_AAAA.xls',
        ruta_entrega = '\\red\compartida\...',
        hash_archivo = '[hash_SHA256]',
        observaciones = 'Proceso completado exitosamente. HU-01 a HU-21 ejecutadas.'
    WHERE proceso = 'COSTO_AMORTIZABLE'
      AND periodo = 'MM_AAAA'
    ```

18. **Generar y enviar notificaciones**
    
    Enviar emails a lista de distribución:
    
    **Para:** Contabilidad, Riesgos, Auditoría
    **Asunto:** Entrega Costo Amortizable - Periodo MM/AAAA
    **Cuerpo:**
    ```
    Estimados,
    
    Se ha completado el proceso de RDA Costo Amortizable para el periodo MM/AAAA.
    
    Resumen:
    - Total obligaciones: XXX
    - Costo Amortizable Total: $XXX,XXX,XXX
    - Fecha de generación: DD/MM/AAAA
    
    Archivos disponibles en:
    [Ruta de red o link de SharePoint]
    
    Archivos:
    1. Costo_Amortizable_MM_AAAA.xls (ARCHIVO DE CARGUE)
    2. Metadata_Costo_Amortizable_MM_AAAA.txt
    3. Evidencias_Proceso_MM_AAAA.pdf
    
    Todas las validaciones han sido completadas exitosamente.
    El archivo está listo para cargue en el sistema de producción.
    
    Cualquier duda o consulta, favor contactar a:
    [Nombre - Email - Teléfono]
    
    Saludos,
    Proceso Automatizado RDA Costo Amortizable
    ```

19. **Crear registro de auditoría**
    
    Documentar en sistema de auditoría:
    - Fecha y hora de generación
    - Usuario que ejecutó
    - Cantidad de registros
    - Monto total
    - Archivos generados
    - Destinatarios notificados
    - Aprobaciones obtenidas
    - Cualquier incidencia o advertencia relevante

20. **Generar reporte final de proceso completo**
    
    Crear documento `Reporte_Final_Proceso_MM_AAAA.xlsx` con:
    
    **Pestaña 1: Resumen Ejecutivo**
    - Fecha inicio proceso
    - Fecha fin proceso
    - Duración total (horas/días)
    - Estado: COMPLETADO
    
    **Pestaña 2: Ejecución de HUs**
    | HU | Nombre | Estado | Duración | Observaciones |
    |----|--------|--------|----------|---------------|
    | HU-01 | Extracción DWH | COMPLETADO | 2.5h | Sin incidencias |
    | ... | ... | ... | ... | ... |
    | HU-21 | Cargue Final | COMPLETADO | 1.5h | Entrega exitosa |
    
    **Pestaña 3: Estadísticas Finales**
    - Por herramienta
    - Por modalidad
    - Distribuciones
    - Comparación con mes anterior
    
    **Pestaña 4: Incidencias y Resoluciones**
    - Listado de advertencias
    - Acciones tomadas
    - Aprobaciones requeridas
    
    **Pestaña 5: Entregables**
    - Lista de archivos generados
    - Ubicaciones
    - Destinatarios
    - Confirmaciones de recepción

21. **Actualizar documentación del proceso**
    
    - Actualizar fecha de última ejecución exitosa
    - Documentar cualquier lección aprendida
    - Actualizar estimaciones si hubo desviaciones significativas
    - Registrar mejoras identificadas para próximos meses

22. **Archivar logs y evidencias**
    
    - Comprimir carpeta de logs
    - Guardar en repositorio de históricos
    - Mantener logs de últimos 12 meses online
    - Archivar logs más antiguos en almacenamiento frío
    - Asegurar que logs son accesibles para auditorías futuras

### Puntos de Control Crítico

1. **Falta aprobación:** Si no hay aprobación del Coordinador de Riesgos, NO proceder con entrega.

2. **Conteos no coinciden:** Si registros en .xls ≠ registros en BASE_FINAL, detener y corregir.

3. **Archivo corrupto:** Si archivo .xls no se puede abrir o tiene errores, regenerar.

4. **Entrega falla:** Si no se puede copiar a carpeta de red o subir a SharePoint, resolver accesos antes de continuar.

5. **Notificaciones no se envían:** Asegurar que destinatarios reciben notificación. Contactar por teléfono si es necesario.

### Puntos de Control No Crítico

1. **Archivo grande:** Si .xls es muy grande pero funcional, registrar advertencia pero continuar.

2. **Formato de fecha difiere ligeramente:** Si formato es válido aunque no es el ideal, registrar advertencia pero continuar.

### Salidas

1. **Archivo principal de cargue:**
   - `Costo_Amortizable_MM_AAAA.xls` (Excel 97-2003)
   - Formato listo para cargue en sistema destino
   - En carpeta de red compartida y/o SharePoint

2. **Archivo de metadata:**
   - `Metadata_Costo_Amortizable_MM_AAAA.txt`
   - Con estadísticas y hash de archivo

3. **Archivo de evidencias:**
   - `Evidencias_Proceso_MM_AAAA.pdf`
   - Documentación completa del proceso

4. **Archivos de backup:**
   - Todos los archivos intermedios en carpeta Backup/

5. **Logs completos:**
   - Consolidado de todos los logs de HU-01 a HU-21

6. **Reporte final:**
   - `Reporte_Final_Proceso_MM_AAAA.xlsx`

7. **Notificaciones enviadas:**
   - Emails a lista de distribución
   - Confirmaciones de recepción

### Reportería

Log final con:
- **PROCESO COMPLETADO EXITOSAMENTE**
- **Fecha y hora de finalización:** DD/MM/AAAA HH:MM:SS
- **Duración total proceso:** XX horas / XX días
- **Archivos generados:** 7 archivos
- **Estadísticas finales:**
  - Obligaciones procesadas: XXX
  - Reestructurados: XX (XX%)
  - Modificados: XX (XX%)
  - Retenciones: XX (XX%)
  - Saldo total: $XXX,XXX,XXX
  - **Costo Amortizable Total:** $XXX,XXX,XXX
- **Ubicación entrega:** [ruta/link]
- **Notificaciones enviadas:** XX destinatarios
- **Estado:** LISTO PARA CARGUE EN PRODUCCIÓN

### Parametría

- **Formato archivo final:** Excel 97-2003 (.xls) - configurable
- **Ruta de entrega:** `\\red\compartida\...` - configurable
- **SharePoint sitio:** URL del sitio - configurable
- **Lista distribución emails:** Destinatarios - configurable
- **Algoritmo hash:** SHA-256 - configurable
- **Retención logs:** 12 meses - configurable

---

## Dependencias

### Historias de Usuario Previas
- **HU-01 a HU-20:** Todas las HU anteriores deben estar completas
- Especialmente **HU-20:** Verificación y BASE_FINAL aprobada

### Historias de Usuario Posteriores
- Ninguna - Esta es la última HU del proceso

### Recursos Externos
- **Carpeta de red compartida:** Debe tener permisos de escritura
- **SharePoint (si aplica):** Acceso configurado
- **Servidor SMTP:** Para envío de notificaciones
- **Aprobaciones:** Del Coordinador de Riesgos

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 2 horas |
| Generación de documentación | 2 horas |
| Validaciones finales | 1 hora |
| Entrega y notificaciones | 1 hora |
| **Total** | **6 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **Formato legacy (.xls):** Limitación de 65,536 filas. Si se excede, usar .xlsx o partir en múltiples archivos.

- **Hash para integridad:** El hash SHA-256 permite verificar que archivo no fue modificado. Crítico para auditoría.

- **Notificaciones automatizadas:** Usar SMTP o API de Exchange para envío de emails. Loguear intentos y éxitos.

### Consideraciones de Negocio

- **HU final del proceso:** Esta HU marca el cierre exitoso del proceso mensual. Es fundamental que todo esté perfecto.

- **Entrega formal:** No es solo copiar un archivo. Es un proceso formal de entrega con notificaciones, evidencias y trazabilidad.

- **Punto de no retorno:** Una vez entregado y notificado, el proceso está completo. Cambios posteriores requieren nueva ejecución.

### Riesgos Identificados

- **Riesgo 1: Archivo no llega a destinatarios**
  - Impacto: Crítico - Áreas no reciben información
  - Mitigación: Múltiples canales de entrega (red, SharePoint, email). Confirmación de recepción obligatoria.

- **Riesgo 2: Archivo modificado después de entrega**
  - Impacto: Crítico - Pérdida de integridad
  - Mitigación: Hash SHA-256. Archivo en solo lectura. Auditoría de accesos.

- **Riesgo 3: Formato no compatible con sistema destino**
  - Impacto: Alto - No se puede cargar
  - Mitigación: Validar formato con Contabilidad antes. Prueba de cargue en ambiente de pruebas si está disponible.

- **Riesgo 4: Notificaciones van a spam**
  - Impacto: Medio - Destinatarios no se enteran
  - Mitigación: Usar cuentas corporativas autorizadas. Incluir a remitente en lista blanca. Seguimiento telefónico.

---

## Conclusión del Proceso

Con la ejecución exitosa de HU-21, se completa el proceso automatizado de **RDA Costo Amortizable**.

**Logros:**
- 21 Historias de Usuario completadas
- 160 horas estimadas de desarrollo
- 4 Sprints ejecutados
- Reducción de tiempo de proceso: de 14 horas manuales a 2-3 horas automatizadas
- Reducción de errores: Validaciones automatizadas en cada etapa
- Trazabilidad completa: Logs y evidencias de todo el proceso
- Calidad asegurada: Múltiples puntos de control y validaciones

**Próximos pasos (fuera del alcance de este proceso):**
- Cargue en sistema de producción por parte de Contabilidad
- Contabilización y reportes regulatorios
- Revisión de auditoría (si aplica)
- Mejora continua basada en lecciones aprendidas

**¡Proceso completado exitosamente!** 🎉

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 11/11/2025
