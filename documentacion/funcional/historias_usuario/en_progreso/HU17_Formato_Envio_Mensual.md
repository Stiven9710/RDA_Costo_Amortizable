# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 17 |
| **Nombre Historia** | Preparar Formato de Envío Mensual |
| **No. Versión** | 1 |
| **Fecha Creación** | 11/11/2025 10:30 |
| **Fecha Modificación** | 11/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Preparar el archivo Excel en el formato estándar requerido para el envío mensual con la información de costo amortizable calculada

**De forma que:** El archivo esté listo para ser cargado y compartido con las áreas de Contabilidad y Riesgos

---

## Criterios de Aceptación

### Insumos

1. **Archivo con cálculos completos (HU-16):**
   - `03. Cálculo Amortización MM_AAAA.xlsm`
   - Con pestaña "Resultados" poblada

2. **Plantilla de formato de envío:**
   - `data/input/plantillas/Plantilla_Envio_Costo_Amortizable.xlsx`
   - Estructura estándar definida por Contabilidad

3. **Tabla SQL (HU-15):**
   - `bd_perdidas_ganancias_dwh_MM_AAAA`
   - Como fuente alternativa de datos

### Entradas de las Funcionalidades

- Resultados de valor valuativo por obligación
- Formato estándar de envío
- Mes y año de reporte (MM_AAAA)
- Información de contacto y responsables

### Funcionalidades

1. **Copiar plantilla de formato de envío**
   
   - Origen: `data/input/plantillas/Plantilla_Envio_Costo_Amortizable.xlsx`
   - Destino: `data/output/reportes/04. Envío Costo Amortizable MM_AAAA.xlsx`
   - Si archivo destino existe, sobrescribir (re-ejecución)
   - Validar que copia fue exitosa

2. **Abrir ambos archivos Excel**
   
   - Abrir archivo origen: `03. Cálculo Amortización MM_AAAA.xlsm`
   - Abrir archivo destino: `04. Envío Costo Amortizable MM_AAAA.xlsx`
   - Validar que ambos archivos se abrieron correctamente

3. **Validar estructura de plantilla de envío**
   
   Verificar que plantilla tiene pestañas requeridas:
   - **"Portada":** Información general del reporte
   - **"Resumen Ejecutivo":** Totales y estadísticas
   - **"Detalle por Obligación":** Listado completo
   - **"Por Herramienta":** Consolidado por tipo
   - **"Excepciones":** Casos especiales
   - **"Metodología":** Descripción de cálculos

4. **Actualizar pestaña "Portada"**
   
   Completar campos en la portada:
   - **Título:** "Costo Amortizable - Mes: [NOMBRE_MES] / Año: [AAAA]"
   - **Fecha de corte:** Último día del mes (DD/MM/AAAA)
   - **Fecha de generación:** Fecha actual
   - **Responsable:** Nombre del área/persona
   - **Versión:** v1.0
   - **Estado:** "Final" o "Preliminar"

5. **Copiar detalle de obligaciones**
   
   Desde `03. Cálculo Amortización MM_AAAA.xlsm`, pestaña "Resultados":
   - Seleccionar todas las filas con datos (sin encabezado)
   - Copiar columnas:
     - N_Obligacion
     - Tipo_Id
     - Numero_Id
     - Herramienta
     - Tipo_Herramienta
     - Tipo_Obligacion
     - Modalidad
     - Saldo_Capital
     - Tasa_Anterior
     - Tasa_Nueva
     - Plazo_Anterior
     - Plazo_Nuevo
     - **Valor_Valuativo** (costo amortizable)
     - Porcentaje_Sobre_Saldo

6. **Pegar en pestaña "Detalle por Obligación"**
   
   En archivo `04. Envío Costo Amortizable MM_AAAA.xlsx`:
   - Ir a pestaña "Detalle por Obligación"
   - Pegar desde fila 2 (fila 1 son encabezados)
   - Validar que todos los datos se pegaron correctamente
   - Aplicar formato de tabla de Excel
   - Ordenar por Herramienta y luego por N_Obligacion

7. **Generar Resumen Ejecutivo**
   
   En pestaña "Resumen Ejecutivo", completar:
   
   a) **Totales Generales:**
   - Total obligaciones afectadas: [COUNT]
   - Total clientes únicos: [COUNT DISTINCT]
   - Saldo total: $[SUM Saldo_Capital]
   - **Costo Amortizable Total:** $[SUM Valor_Valuativo]
   - % sobre saldo total: [Costo/Saldo * 100]
   
   b) **Por Herramienta:**
   | Herramienta | Obligaciones | Saldo | Costo Amortizable | % Saldo |
   |-------------|-------------|--------|-------------------|---------|
   | Reestructurado | XXX | $XXX | $XXX | X.XX% |
   | Modificado | XXX | $XXX | $XXX | X.XX% |
   | Retención | XXX | $XXX | $XXX | X.XX% |
   | **TOTAL** | XXX | $XXX | $XXX | X.XX% |

8. **Generar consolidado por tipo de herramienta**
   
   En pestaña "Por Herramienta", crear tabla detallada:
   
   | Herramienta | Tipo_Herramienta | Tipo_Obligacion | Cantidad | Saldo | Costo_Amortizable |
   |-------------|------------------|-----------------|----------|-------|-------------------|
   | Reestructurado | Consolidada | Diferente Obligación | XX | $XX | $XX |
   | Reestructurado | Individual | Misma Obligación | XX | $XX | $XX |
   | Modificado | Consolidada | Diferente Obligación | XX | $XX | $XX |
   | Modificado | Individual | Misma Obligación | XX | $XX | $XX |
   | Retención | Individual | Misma Obligación | XX | $XX | $XX |

9. **Agregar gráficos al Resumen Ejecutivo**
   
   Crear gráficos visuales:
   
   a) **Gráfico de columnas:** Costo Amortizable por Herramienta
   - Eje X: Reestructurado, Modificado, Retención
   - Eje Y: Costo en millones de pesos
   
   b) **Gráfico circular:** Distribución porcentual del costo
   - Mostrar % de cada herramienta sobre el total
   
   c) **Gráfico de barras:** Top 10 obligaciones con mayor costo
   - Mostrar las 10 obligaciones con mayor Valor_Valuativo

10. **Identificar y documentar excepciones**
    
    Desde archivo origen, copiar excepciones a pestaña "Excepciones":
    - Obligaciones con valor valuativo extremo (> 2x saldo)
    - Obligaciones con errores de cálculo
    - Casos que requieren revisión manual
    
    Agregar columna "Comentario" para cada excepción

11. **Completar pestaña "Metodología"**
    
    Actualizar con descripción del proceso:
    - Fuente de datos (servidores, tablas)
    - Metodología de cálculo del valor valuativo
    - Fórmulas utilizadas
    - Supuestos y consideraciones
    - Fecha de última actualización de metodología

12. **Agregar estadísticas adicionales**
    
    En pestaña "Resumen Ejecutivo", sección inferior:
    
    a) **Distribución por rangos de saldo:**
    | Rango Saldo | Cantidad | Costo Total |
    |-------------|----------|-------------|
    | < $1M | XX | $XX |
    | $1M - $5M | XX | $XX |
    | $5M - $10M | XX | $XX |
    | > $10M | XX | $XX |
    
    b) **Estadísticas de tasas:**
    - Tasa anterior promedio: X.XX%
    - Tasa nueva promedio: X.XX%
    - Reducción promedio de tasa: X.XX pp
    
    c) **Estadísticas de plazos:**
    - Plazo anterior promedio: XX meses
    - Plazo nuevo promedio: XX meses
    - Extensión promedio de plazo: XX meses

13. **Aplicar formato profesional**
    
    A todas las pestañas:
    - Formato de moneda: $#,##0 (sin decimales)
    - Formato de porcentaje: 0.00%
    - Formato de fechas: DD/MM/AAAA
    - Colores corporativos del banco
    - Logos y encabezados institucionales en portada
    - Pie de página con número de página y fecha

14. **Proteger estructura del archivo**
    
    - Proteger pestañas "Portada", "Resumen Ejecutivo", "Metodología" (solo lectura)
    - Dejar editables "Detalle por Obligación" y "Excepciones" (para ajustes)
    - Sin contraseña (acceso para todas las áreas)

15. **Validar coherencia de datos**
    
    Ejecutar validaciones finales:
    
    a) **Suma de detalles = Total resumen:**
    ```
    SUM(Detalle.Valor_Valuativo) = Resumen.Costo_Amortizable_Total
    ```
    
    b) **Cantidad de obligaciones coincide:**
    ```
    COUNT(Detalle) = Resumen.Total_Obligaciones
    ```
    
    c) **Por herramienta suma correctamente:**
    - Sumar reestructurados + modificados + retenciones = Total
    
    Si hay discrepancias, corregir antes de continuar

16. **Agregar notas aclaratorias**
    
    En cada pestaña, agregar notas al pie donde sea necesario:
    - Definición de términos técnicos
    - Aclaraciones sobre casos especiales
    - Contacto para dudas o aclaraciones

17. **Generar tabla dinámica (opcional)**
    
    En pestaña nueva "Análisis Dinámico":
    - Crear tabla dinámica desde "Detalle por Obligación"
    - Permitir filtrar por: Herramienta, Modalidad, Rango de Saldo
    - Medidas: COUNT, SUM Saldo, SUM Costo
    - Facilitar análisis ad-hoc por usuarios

18. **Guardar con compresión**
    
    - Guardar archivo Excel
    - Aplicar compresión de imágenes si tiene logos
    - Validar tamaño de archivo (idealmente < 10 MB)
    - Si es muy grande, considerar eliminar datos intermedios

19. **Crear versión PDF del Resumen Ejecutivo**
    
    - Exportar solo pestaña "Portada" y "Resumen Ejecutivo" a PDF
    - Guardar como: `Resumen_Ejecutivo_Costo_Amortizable_MM_AAAA.pdf`
    - Para distribución rápida a ejecutivos

20. **Registrar en log**
    
    - Timestamp de generación del archivo
    - Estadísticas principales
    - Archivos generados
    - Ubicación de salida

### Puntos de Control Crítico

1. **Validación de totales:** Si la suma del detalle no coincide con el resumen, detener y corregir (error de copia o fórmulas).

2. **Datos faltantes:** Si hay obligaciones sin Valor_Valuativo en el detalle, detener (error en HU-16).

3. **Estructura de plantilla:** Si la plantilla no tiene las pestañas esperadas, detener y solicitar plantilla correcta.

### Puntos de Control No Crítico

1. **Excepciones vacías:** Si no hay excepciones, está bien. Dejar pestaña vacía con mensaje "No se identificaron excepciones este mes".

2. **Formato de fechas:** Si hay diferencias menores de formato, registrar advertencia pero continuar.

### Salidas

1. **Archivo Excel principal:**
   - `data/output/reportes/04. Envío Costo Amortizable MM_AAAA.xlsx`
   - Todas las pestañas completas
   - Formato profesional
   - Listo para distribución

2. **PDF Resumen Ejecutivo:**
   - `data/output/reportes/Resumen_Ejecutivo_Costo_Amortizable_MM_AAAA.pdf`
   - 2-3 páginas
   - Portada + resumen con gráficos

3. **Log:** `logs/ejecuciones/HU17_Formato_Envio_AAAAMMDD_HHMMSS.log`

### Reportería

Log con:
- **Archivo generado exitosamente**
- **Estadísticas incluidas:**
  - Obligaciones: XXX
  - Costo Amortizable Total: $XXX,XXX,XXX
  - Distribución por herramienta
- **Archivos de salida:** Excel y PDF generados
- **Ubicación:** data/output/reportes/

### Parametría

- **Plantilla origen:** `Plantilla_Envio_Costo_Amortizable.xlsx` (configurable)
- **Colores corporativos:** Definidos en plantilla (configurable)
- **Logo del banco:** Ruta a archivo de logo (configurable)
- **Umbral archivo grande:** 10 MB (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-16:** Cálculos de valor valuativo completos
- **HU-14:** Cálculos de pérdida/ganancia (referencia)

### Historias de Usuario Posteriores
- **HU-18:** Subir base valuativa a SQL - Usará este archivo como referencia
- **HU-19:** Consolidar hoja base - Puede requerir datos de este archivo
- **HU-20:** Verificación producción - Comparará con este archivo

### Recursos Externos
- **Plantilla de envío:** Debe existir y estar actualizada
- **Logo del banco:** Para portada
- **Microsoft Excel 2016+**

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 3 horas |
| Desarrollo Python (pandas/openpyxl) | 1.5 horas |
| Diseño de formato y gráficos | 1 hora |
| Pruebas | 0.5 horas |
| **Total** | **6 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **Formato estándar crítico:** El archivo debe seguir el formato exacto que espera Contabilidad para poder procesarlo.

- **Alternativa Python:** Usar pandas para consolidar datos y openpyxl/xlsxwriter para generar el Excel con formato puede ser más eficiente que manipular Excel con PAD.

- **PDF para ejecutivos:** El PDF del resumen es clave para distribución rápida sin que usuarios tengan que abrir Excel.

### Consideraciones de Negocio

- **Archivo de entrega oficial:** Este es el archivo que se entrega mensualmente a Contabilidad y Riesgos. Debe ser impecable.

- **Portada profesional:** La portada da la primera impresión. Debe incluir logo, título claro, fechas y responsables.

- **Resumen Ejecutivo autoconsumible:** Debe permitir a un director entender los números principales sin necesidad de revisar el detalle.

### Riesgos Identificados

- **Riesgo 1: Plantilla desactualizada**
  - Impacto: Medio - Formato no es el esperado por destinatarios
  - Mitigación: Validar plantilla al inicio de cada mes. Coordinar con Contabilidad si hay cambios.

- **Riesgo 2: Errores de redondeo en totales**
  - Impacto: Medio - Totales no cuadran por céntimos
  - Mitigación: Usar REDONDEAR en fórmulas de Excel. Validar que suma de detalles = total exacto.

- **Riesgo 3: Archivo muy grande para email**
  - Impacto: Bajo - No se puede enviar por correo
  - Mitigación: Comprimir archivo. Subir a SharePoint y compartir link. Generar versión ligera sin tablas dinámicas.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 11/11/2025
