# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 19 |
| **Nombre Historia** | Consolidar Información en Hoja BASE |
| **No. Versión** | 1 |
| **Fecha Creación** | 11/11/2025 11:30 |
| **Fecha Modificación** | 11/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Consolidar toda la información procesada en una hoja "BASE" que servirá como fuente única de datos para el archivo de producción final

**De forma que:** Se tenga un repositorio único y estructurado con todos los cálculos, validaciones y datos complementarios listos para el cargue final

---

## Criterios de Aceptación

### Insumos

1. **Tabla SQL (HU-18):**
   - `bd_costo_amortizable_MM_AAAA`
   - Con toda la información consolidada

2. **Archivo Excel de trabajo:**
   - `01. información Consolidada MM_AAAA.xlsx` (de HU-02 a HU-07)
   - Contiene las pestañas originales de consolidación

3. **Archivo de cálculos (HU-16):**
   - `03. Cálculo Amortización MM_AAAA.xlsm`
   - Con resultados de valor valuativo

### Entradas de las Funcionalidades

- Datos consolidados de SQL
- Validaciones completadas
- Cálculos de valor valuativo finalizados
- Mes y año de proceso (MM_AAAA)

### Funcionalidades

1. **Abrir archivo de trabajo principal**
   
   - Abrir: `01. información Consolidada MM_AAAA.xlsx`
   - Este archivo ya tiene las pestañas 1-8 de las HU anteriores
   - Validar que archivo se abre correctamente

2. **Crear nueva pestaña "BASE"**
   
   - Agregar nueva pestaña al final llamada "BASE"
   - Esta será la hoja maestra consolidada
   - Posicionar como última pestaña del archivo

3. **Definir estructura de columnas en BASE**
   
   La pestaña BASE debe tener las siguientes columnas:
   
   **A. Identificación:**
   - A: Fecha_Corte
   - B: Tipo_Id
   - C: Numero_Id
   - D: Nombre_Cliente
   - E: N_Obligacion
   
   **B. Clasificación de Herramienta:**
   - F: Herramienta
   - G: Tipo_Herramienta
   - H: Tipo_Obligacion
   - I: Modalidad
   - J: Producto
   - K: Linea_Credito
   
   **C. Obligaciones Anteriores (para consolidadas):**
   - L: obligacion1
   - M: obligacion2
   - N: obligacion3
   - ... (hasta obligacion25)
   - AJ: obligacion25
   
   **D. Condiciones Anteriores:**
   - AK: Tasa_Anterior
   - AL: Plazo_Anterior
   - AM: Cuota_Anterior
   
   **E. Condiciones Nuevas:**
   - AN: Tasa_Nueva
   - AO: Plazo_Nuevo
   - AP: Cuota_Nueva
   
   **F. Valores y Cálculos:**
   - AQ: Saldo_Capital
   - AR: Valor_Valuativo (Costo Amortizable)
   - AS: Porcentaje_Sobre_Saldo
   - AT: Tipo_Resultado (PÉRDIDA/GANANCIA/NEUTRO)
   
   **G. Información Complementaria:**
   - AU: Segmento
   - AV: Oficina
   - AW: Ciudad
   - AX: Calificacion_Riesgo
   - AY: Provision
   
   **H. Fechas:**
   - AZ: Fecha_Desembolso
   - BA: Fecha_Aplicacion_Herramienta
   - BB: Antiguedad_Meses
   - BC: Meses_Desde_Aplicacion
   
   **I. Auditoría:**
   - BD: Fecha_Proceso
   - BE: Usuario_Proceso
   - BF: Estado_Registro

4. **Extraer datos desde SQL**
   
   Conectar a SQL y extraer información completa:
   ```sql
   SELECT 
       Fecha_Corte,
       Tipo_Id,
       Numero_Id,
       Nombre_Cliente,
       N_Obligacion,
       Herramienta,
       Tipo_Herramienta,
       Tipo_Obligacion,
       Modalidad,
       Producto,
       Linea_Credito,
       -- Obligaciones anteriores (de tabla original)
       Tasa_Anterior,
       Plazo_Anterior,
       Tasa_Nueva,
       Plazo_Nuevo,
       Saldo_Capital,
       Valor_Valuativo,
       Porcentaje_Saldo,
       Tipo_Resultado,
       Segmento,
       Oficina,
       Ciudad,
       Calificacion_Riesgo,
       Provision,
       Fecha_Desembolso,
       Fecha_Aplicacion_Herramienta,
       Antiguedad_Meses,
       Meses_Desde_Aplicacion,
       Fecha_Carga,
       Usuario_Carga,
       Estado
   FROM bd_costo_amortizable_MM_AAAA
   ORDER BY Herramienta, N_Obligacion
   ```

5. **Pegar datos en hoja BASE**
   
   - Pegar todos los datos desde fila 2 (fila 1 son encabezados)
   - Validar que se pegaron todos los registros
   - Aplicar formato de tabla de Excel
   - Nombrar tabla como "tbl_BASE"

6. **Completar obligaciones anteriores desde pestañas originales**
   
   Para las obligaciones consolidadas, agregar las obligaciones previas:
   
   a) **Reestructurados consolidados:**
   - Buscar en pestaña "6. Reestructurados" (HU-08)
   - Para cada N_Obligacion en BASE, buscar sus obligaciones previas (columnas H en adelante)
   - Copiar a columnas L-AJ en BASE
   
   b) **Modificados consolidados:**
   - Buscar en pestaña "7. Modificados" (HU-09)
   - Copiar obligaciones previas a BASE

7. **Calcular cuotas si no están disponibles**
   
   Si Cuota_Anterior y Cuota_Nueva no vienen de SQL, calcularlas:
   
   **Columna AM (Cuota_Anterior):**
   ```excel
   =SI(Plazo_Anterior=0, 0, 
      Saldo_Capital * (Tasa_Anterior/12) / (1 - (1 + Tasa_Anterior/12)^(-Plazo_Anterior)))
   ```
   
   **Columna AP (Cuota_Nueva):**
   ```excel
   =SI(Plazo_Nuevo=0, 0,
      Saldo_Capital * (Tasa_Nueva/12) / (1 - (1 + Tasa_Nueva/12)^(-Plazo_Nuevo)))
   ```

8. **Agregar columnas calculadas adicionales**
   
   **Columna BG: Delta_Tasa**
   ```excel
   =Tasa_Nueva - Tasa_Anterior
   ```
   
   **Columna BH: Delta_Plazo**
   ```excel
   =Plazo_Nuevo - Plazo_Anterior
   ```
   
   **Columna BI: Delta_Cuota**
   ```excel
   =Cuota_Nueva - Cuota_Anterior
   ```
   
   **Columna BJ: Cantidad_Obligaciones_Consolidadas**
   (Para consolidadas, contar cuántas obligaciones anteriores tienen)
   ```excel
   =CONTAR.SI(L2:AJ2, "<>")
   ```

9. **Agregar banderas de validación**
   
   **Columna BK: Flag_Validacion_Tasa**
   ```excel
   =SI(Y(Tasa_Anterior>=0, Tasa_Anterior<=50, Tasa_Nueva>=0, Tasa_Nueva<=50), "OK", "REVISAR")
   ```
   
   **Columna BL: Flag_Validacion_Plazo**
   ```excel
   =SI(Y(Plazo_Anterior>=1, Plazo_Anterior<=360, Plazo_Nuevo>=1, Plazo_Nuevo<=360), "OK", "REVISAR")
   ```
   
   **Columna BM: Flag_Validacion_Saldo**
   ```excel
   =SI(Saldo_Capital>0, "OK", "REVISAR")
   ```
   
   **Columna BN: Flag_Valor_Extremo**
   ```excel
   =SI(ABS(Valor_Valuativo) > 2*Saldo_Capital, "EXTREMO", "OK")
   ```
   
   **Columna BO: Flag_Validacion_General**
   (OK solo si todas las validaciones son OK)
   ```excel
   =SI(Y(BK2="OK", BL2="OK", BM2="OK", BN2="OK"), "OK", "REVISAR")
   ```

10. **Agregar clasificaciones de negocio**
    
    **Columna BP: Rango_Saldo**
    ```excel
    =SI(Saldo_Capital<1000000, "< $1M",
       SI(Saldo_Capital<5000000, "$1M - $5M",
          SI(Saldo_Capital<10000000, "$5M - $10M",
             SI(Saldo_Capital<50000000, "$10M - $50M", "> $50M"))))
    ```
    
    **Columna BQ: Rango_Costo**
    ```excel
    =SI(ABS(Valor_Valuativo)<100000, "< $100K",
       SI(ABS(Valor_Valuativo)<500000, "$100K - $500K",
          SI(ABS(Valor_Valuativo)<1000000, "$500K - $1M", "> $1M")))
    ```
    
    **Columna BR: Categoria_Plazo**
    ```excel
    =SI(Plazo_Nuevo<=12, "Corto Plazo",
       SI(Plazo_Nuevo<=36, "Mediano Plazo", "Largo Plazo"))
    ```

11. **Manejar casos especiales**
    
    Identificar y marcar casos especiales:
    
    **Columna BS: Caso_Especial**
    ```excel
    =SI(Tipo_Obligacion="Misma Obligación", "",
       SI(Cantidad_Obligaciones_Consolidadas=1, "CONSOLIDADA_1_OBLIGACION",
          SI(Cantidad_Obligaciones_Consolidadas>10, "CONSOLIDADA_MASIVA", "")))
    ```
    
    > **Nota:** Consolidadas de 1 sola obligación o más de 10 son casos especiales que pueden requerir revisión

12. **Aplicar formato condicional**
    
    a) **Columna Tipo_Resultado:**
    - Verde claro si "GANANCIA"
    - Rojo claro si "PÉRDIDA"
    - Gris si "NEUTRO"
    
    b) **Columnas de validación (BK-BO):**
    - Verde si "OK"
    - Rojo si "REVISAR" o "EXTREMO"
    
    c) **Columna Valor_Valuativo:**
    - Rojo si negativo (pérdida)
    - Verde si positivo (ganancia)

13. **Crear filtros y ordenamiento**
    
    - Aplicar autofiltro a todas las columnas
    - Congelar primera fila (encabezados)
    - Congelar primeras 5 columnas (identificación)
    - Orden predeterminado: Herramienta, luego Valor_Valuativo DESC

14. **Agregar subtotales por herramienta**
    
    Al final de cada grupo (Reestructurado, Modificado, Retención):
    - Fila de subtotal con:
      - Cantidad de obligaciones
      - Suma de Saldo_Capital
      - Suma de Valor_Valuativo
      - Promedio de tasas y plazos
    - Formato negrita y fondo gris claro

15. **Agregar fila de TOTALES GENERALES**
    
    En la última fila:
    - Total obligaciones: =CONTARA(...)
    - Total saldo: =SUMA(...)
    - Total costo amortizable: =SUMA(...)
    - Promedios: =PROMEDIO(...)
    - Formato negrita, fondo azul claro

16. **Validar integridad de la hoja BASE**
    
    Ejecutar validaciones:
    
    a) **Conteo coincide con SQL:**
    - Filas en BASE = registros en bd_costo_amortizable_MM_AAAA
    
    b) **Totales coinciden:**
    - Suma Valor_Valuativo en BASE = Total en SQL
    - Suma Saldo_Capital en BASE = Total en SQL
    
    c) **No hay filas duplicadas:**
    - Verificar que N_Obligacion no se repite
    
    d) **Todas las fórmulas calcularon:**
    - Buscar #VALUE!, #DIV/0!, #N/A
    - Si hay errores, corregir

17. **Crear hoja de resumen "RESUMEN_BASE"**
    
    Nueva pestaña con KPIs de la hoja BASE:
    
    **Sección 1: Conteos**
    - Total obligaciones
    - Por herramienta
    - Por tipo
    - Por modalidad
    
    **Sección 2: Valores**
    - Saldo total
    - Costo amortizable total
    - Por herramienta
    
    **Sección 3: Promedios**
    - Costo promedio por obligación
    - Tasa anterior/nueva promedio
    - Plazo anterior/nuevo promedio
    
    **Sección 4: Validaciones**
    - Registros con validación OK: XX (XX%)
    - Registros para revisar: XX (XX%)
    - Valores extremos: XX (XX%)

18. **Proteger estructura de BASE**
    
    - Proteger columnas de datos importados (A-AY)
    - Dejar editables columnas de banderas y comentarios
    - Proteger fórmulas
    - Sin contraseña (para facilitar auditorías)

19. **Guardar archivo con BASE consolidada**
    
    - Guardar `01. información Consolidada MM_AAAA.xlsx`
    - Ahora incluye la nueva pestaña "BASE"
    - Validar tamaño de archivo
    - Crear backup del archivo

20. **Generar documentación de la hoja BASE**
    
    Crear pestaña "DICCIONARIO_BASE" con:
    - Nombre de cada columna
    - Descripción
    - Tipo de dato
    - Fuente (SQL/Calculado/Manual)
    - Observaciones

### Puntos de Control Crítico

1. **Datos de SQL no cargan:** Si no se pueden extraer datos de bd_costo_amortizable_MM_AAAA, detener proceso.

2. **Conteos no coinciden:** Si filas en BASE ≠ registros en SQL, detener y revisar.

3. **Totales no cuadran:** Si suma de Valor_Valuativo en BASE ≠ Total en SQL, detener y corregir.

4. **Más del 10% con errores de validación:** Si más del 10% tiene Flag_Validacion_General = "REVISAR", detener y revisar datos fuente.

### Puntos de Control No Crítico

1. **Algunos campos complementarios vacíos:** Si campos como Segmento o Ciudad tienen NULLs, registrar advertencia pero continuar.

2. **Pocos casos especiales:** Si hay < 5% de casos especiales identificados, es normal. Registrar para revisión.

### Salidas

1. **Archivo Excel actualizado:**
   - `01. información Consolidada MM_AAAA.xlsx`
   - Nueva pestaña "BASE" con todos los datos consolidados
   - Pestaña "RESUMEN_BASE" con KPIs
   - Pestaña "DICCIONARIO_BASE" con documentación

2. **Backup:**
   - `01. información Consolidada MM_AAAA_BACKUP_AAAAMMDD_HHMMSS.xlsx`

3. **Log:** `logs/ejecuciones/HU19_Consolidar_BASE_AAAAMMDD_HHMMSS.log`

### Reportería

Log con:
- **Hoja BASE creada exitosamente**
- **Estadísticas:**
  - Registros en BASE: XXX
  - Columnas: XX
  - Saldo total: $XXX,XXX,XXX
  - Costo Amortizable total: $XXX,XXX,XXX
  
- **Validaciones:**
  - Registros OK: XXX (XX%)
  - Para revisar: XXX (XX%)
  - Valores extremos: XXX (XX%)
  
- **Por herramienta:**
  - Reestructurados: XXX (XX%)
  - Modificados: XXX (XX%)
  - Retenciones: XXX (XX%)

### Parametría

- **Archivo de trabajo:** `01. información Consolidada MM_AAAA.xlsx` (configurable)
- **Nombre pestaña BASE:** `BASE` (configurable)
- **Umbral validación general:** 10% (configurable)
- **Umbral valor extremo:** 2x saldo (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-02 a HU-10:** Archivo de consolidación con pestañas 1-8
- **HU-16:** Cálculos de valor valuativo
- **HU-18:** Tabla SQL con datos completos

### Historias de Usuario Posteriores
- **HU-20:** Verificación producción - Leerá hoja BASE
- **HU-21:** Cargue final - Usará hoja BASE como fuente

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 4 horas |
| Desarrollo Python (pandas) | 2 horas |
| Creación de fórmulas | 1 hora |
| Pruebas | 1 hora |
| **Total** | **8 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **Hoja maestra del proceso:** BASE es la consolidación de todo el trabajo de las HU anteriores. Debe ser perfecta.

- **Muchas columnas:** Con 50+ columnas, el archivo puede ser complejo. Importante tener buena documentación (diccionario).

- **Fórmulas vs valores:** Se pueden pegar fórmulas para que se actualicen dinámicamente, o valores para congelar resultados. Recomendado: valores para la mayoría, fórmulas solo para validaciones.

### Consideraciones de Negocio

- **Single source of truth:** BASE se convierte en la fuente única de verdad para el mes. Todas las consultas y verificaciones posteriores deben partir de aquí.

- **Trazabilidad completa:** BASE debe permitir trazar cada obligación desde su origen (pestañas 1-8) hasta el cálculo final.

- **Preparación para auditoría:** Una hoja BASE bien estructurada y documentada facilita enormemente las auditorías.

### Riesgos Identificados

- **Riesgo 1: Archivo muy grande**
  - Impacto: Medio - Lento de abrir y trabajar
  - Mitigación: Eliminar pestañas intermedias que ya no se necesitan. Considerar dividir en múltiples archivos.

- **Riesgo 2: Fórmulas rotas**
  - Impacto: Alto - Cálculos incorrectos
  - Mitigación: Usar referencias relativas correctamente. Validar fórmulas después de pegar. Usar nombres de rango.

- **Riesgo 3: Datos desalineados**
  - Impacto: Alto - Información incorrecta
  - Mitigación: Validaciones exhaustivas de conteos y totales. Comparar con SQL. Revisión manual de muestra.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 11/11/2025
