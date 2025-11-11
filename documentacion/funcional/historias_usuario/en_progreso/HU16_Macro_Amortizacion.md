# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 16 |
| **Nombre Historia** | Ejecutar Macro de Amortización para Cálculo Final |
| **No. Versión** | 1 |
| **Fecha Creación** | 11/11/2025 10:00 |
| **Fecha Modificación** | 11/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Ejecutar la macro VBA que calcula el valor valuativo de costo amortizable mediante tablas de amortización dinámicas

**De forma que:** Se genere el archivo Excel final con los cálculos de amortización completos para cada obligación afectada

---

## Criterios de Aceptación

### Insumos

1. **Tabla SQL:** `bd_perdidas_ganancias_dwh_MM_AAAA` (creada en HU-15)

2. **Archivo Excel con macro:**
   - Ruta: `data/input/plantillas/Macro_Amortizacion_Costo_Amortizable.xlsm`
   - Contiene macro VBA preconfigurada
   - Conecta a SQL Server para leer datos

3. **Conexión SQL:** 10.1.5.172\RIESGOS (DWH_Riesgos_Credito)

### Entradas de las Funcionalidades

- Archivo Excel con macro habilitada (.xlsm)
- Parámetros de conexión SQL
- Mes y año de proceso (MM_AAAA)
- Parámetros de configuración de la macro

### Funcionalidades

1. **Preparar ambiente de ejecución**
   
   - Validar que Excel está instalado y es versión 2016 o superior
   - Validar que las macros están habilitadas en Excel (configuración de seguridad)
   - Cerrar cualquier instancia de Excel abierta
   - Liberar recursos de memoria

2. **Copiar archivo macro a carpeta de trabajo**
   
   - Origen: `data/input/plantillas/Macro_Amortizacion_Costo_Amortizable.xlsm`
   - Destino: `data/output/reportes/03. Cálculo Amortización MM_AAAA.xlsm`
   - Si archivo destino existe (re-ejecución), eliminarlo antes
   - Validar que copia fue exitosa

3. **Abrir archivo Excel con macro**
   
   - Abrir `03. Cálculo Amortización MM_AAAA.xlsm`
   - Habilitar macros si Excel solicita confirmación
   - Esperar a que archivo cargue completamente
   - Validar que macro principal está disponible

4. **Configurar parámetros de conexión SQL en Excel**
   
   Ir a pestaña "Config" y actualizar parámetros:
   - **Servidor:** 10.1.5.172\RIESGOS
   - **Base de datos:** DWH_Riesgos_Credito
   - **Tabla:** bd_perdidas_ganancias_dwh_MM_AAAA
   - **Usuario:** (desde configuración segura)
   - **Contraseña:** (desde configuración segura)
   - **Mes proceso:** MM
   - **Año proceso:** AAAA

5. **Validar conexión SQL desde Excel**
   
   La macro debe incluir rutina de validación:
   - Intentar conectar a SQL Server
   - Validar que tabla bd_perdidas_ganancias_dwh_MM_AAAA existe
   - Contar registros en la tabla
   - Si conexión falla, detener y notificar error

6. **Ejecutar macro principal: "Calcular_Amortizacion"**
   
   Invocar la macro VBA principal. La macro debe ejecutar:
   
   a) **Paso 1: Limpiar pestañas de cálculo**
   - Limpiar pestaña "Datos"
   - Limpiar pestaña "Tablas_Amortizacion"
   - Limpiar pestaña "Resultados"
   
   b) **Paso 2: Extraer datos de SQL**
   - Ejecutar query para traer datos de bd_perdidas_ganancias_dwh_MM_AAAA
   - Pegar en pestaña "Datos"
   - Validar que se extrajeron todos los registros

7. **Generar tablas de amortización por obligación**
   
   La macro debe iterar cada obligación y:
   
   a) **Crear tabla de amortización con condiciones ANTERIORES:**
   - Saldo inicial = Saldo_Capital
   - Tasa = Tasa_Anterior (mensual)
   - Plazo = Plazo_Anterior (meses)
   - Generar cuotas mensuales con: Cuota, Interés, Capital, Saldo
   
   b) **Crear tabla de amortización con condiciones NUEVAS:**
   - Saldo inicial = Saldo_Capital
   - Tasa = Tasa_Nueva (mensual)
   - Plazo = Plazo_Nuevo (meses)
   - Generar cuotas mensuales con: Cuota, Interés, Capital, Saldo
   
   c) **Calcular diferencias:**
   - Diferencia de cuota mensual
   - Diferencia de interés total
   - Diferencia de capital total
   - Valor presente de diferencias (costo amortizable)

8. **Calcular valor valuativo por obligación**
   
   Para cada obligación:
   ```
   Valor_Valuativo = Saldo_Capital * (Tasa_Anterior - Tasa_Nueva) / Tasa_Nueva
   ```
   
   O usar método de suma de diferencias de valor presente:
   ```
   Valor_Valuativo = Σ (Diferencia_Cuota_i / (1 + tasa_descuento)^i)
   ```
   
   Donde i va de 1 hasta el plazo de la obligación

9. **Validar altura de tablas de amortización**
   
   La macro debe validar:
   - Tabla anterior tiene Plazo_Anterior filas
   - Tabla nueva tiene Plazo_Nuevo filas
   - Última fila de cada tabla tiene Saldo = 0 o cercano a 0 (< $10)
   - Si saldo final no es cero, registrar advertencia

10. **Consolidar resultados en pestaña "Resultados"**
    
    Generar tabla consolidada con:
    - N_Obligacion
    - Numero_Id (cliente)
    - Herramienta
    - Tipo_Herramienta
    - Saldo_Capital
    - Tasa_Anterior
    - Tasa_Nueva
    - Plazo_Anterior
    - Plazo_Nuevo
    - Cuota_Anterior (mensual)
    - Cuota_Nueva (mensual)
    - Diferencia_Cuota
    - Intereses_Totales_Anterior
    - Intereses_Totales_Nuevo
    - Diferencia_Intereses
    - **Valor_Valuativo** (costo amortizable calculado)
    - Porcentaje_Sobre_Saldo

11. **Aplicar formato a tablas de amortización**
    
    En pestaña "Tablas_Amortizacion":
    - Formato moneda para columnas de valores
    - Formato porcentaje para tasas
    - Colores alternados por obligación
    - Bordes para separar tablas
    - Negrita en encabezados

12. **Generar totales y estadísticas**
    
    En pestaña "Resultados", agregar sección de totales:
    - Total obligaciones procesadas
    - Saldo total afectado
    - Valor valuativo total (costo amortizable total)
    - Promedio de valor valuativo
    - Valor valuativo por herramienta:
      - Reestructurados: $XXX
      - Modificados: $XXX
      - Retenciones: $XXX

13. **Crear gráficos de análisis**
    
    Agregar gráficos en pestaña "Resultados":
    
    a) **Gráfico de barras:** Valor valuativo por herramienta
    b) **Gráfico de pastel:** Distribución de saldo por herramienta
    c) **Gráfico de líneas:** Evolución de saldo en tabla de amortización (ejemplo)

14. **Validar cálculos ejecutados**
    
    Ejecutar validaciones automáticas:
    
    a) **Todas las obligaciones procesadas:**
    ```
    Registros en "Datos" = Registros en "Resultados"
    ```
    
    b) **Valores valuativos no nulos:**
    - Verificar que todas las obligaciones tienen Valor_Valuativo calculado
    - Si hay NULLs o errores, registrar y detener
    
    c) **Rangos lógicos:**
    - Valor_Valuativo no debe superar 2x el Saldo_Capital
    - Si hay valores extremos, marcar en columna "Revisar"

15. **Identificar obligaciones con errores**
    
    Crear pestaña "Excepciones" con:
    - Obligaciones donde tabla de amortización no cuadró (saldo final != 0)
    - Obligaciones con valor valuativo extremo (> 2x saldo)
    - Obligaciones con errores de cálculo (#VALUE!, #DIV/0!)
    - Requieren revisión manual

16. **Actualizar altura de filas dinámicamente**
    
    La macro debe ajustar:
    - Altura de filas en "Tablas_Amortizacion" según cantidad de cuotas
    - Autoajustar anchos de columnas
    - Congelar paneles en encabezados
    - Aplicar zoom óptimo (100% o 85%)

17. **Proteger pestañas con fórmulas**
    
    - Proteger pestaña "Config" (solo celdas de parámetros editables)
    - Proteger pestaña "Resultados" (solo lectura)
    - Proteger pestaña "Tablas_Amortizacion" (solo lectura)
    - Dejar pestaña "Excepciones" editable (para comentarios)

18. **Guardar archivo con timestamp**
    
    - Guardar archivo Excel
    - Agregar timestamp de ejecución en pestaña "Config"
    - Registrar versión de macro ejecutada
    - Mantener formatos y macros

19. **Exportar resumen a archivo separado**
    
    Opcional: Crear archivo resumen liviano:
    - Copiar solo pestaña "Resultados" a nuevo archivo
    - Guardar como: `Resumen_Costo_Amortizable_MM_AAAA.xlsx` (sin macros)
    - Para fácil distribución y consulta

20. **Registrar log de ejecución de macro**
    
    La macro debe escribir log detallado:
    - Timestamp inicio y fin
    - Parámetros utilizados
    - Registros procesados
    - Tablas de amortización generadas
    - Valor valuativo total calculado
    - Errores o advertencias
    - Tiempo total de ejecución

### Puntos de Control Crítico

1. **Macros no habilitadas:** Si Excel no permite ejecutar macros, detener y habilitar en configuración de seguridad.

2. **Conexión SQL falla:** Si no se puede conectar desde Excel a SQL, detener proceso.

3. **Tablas de amortización no cuadran:** Si más del 5% de tablas tienen saldo final != 0, detener y revisar cálculos de la macro.

4. **Valor valuativo NULL:** Si hay obligaciones sin valor valuativo calculado, detener (error en macro).

5. **Más del 10% con valores extremos:** Si más del 10% tiene valor valuativo > 2x saldo, detener y revisar datos fuente o fórmulas.

### Puntos de Control No Crítico

1. **Pocas excepciones (< 2%):** Si menos del 2% de tablas no cuadran perfectamente (diferencia < $10), registrar advertencia pero continuar.

2. **Tiempo de ejecución largo:** Si macro toma más de 30 minutos, registrar advertencia pero esperar a que complete.

### Salidas

1. **Archivo Excel con resultados:**
   - `data/output/reportes/03. Cálculo Amortización MM_AAAA.xlsm`
   - Pestaña "Datos" con información de SQL
   - Pestaña "Tablas_Amortizacion" con cálculos detallados
   - Pestaña "Resultados" con consolidado y valor valuativo
   - Pestaña "Excepciones" con casos especiales
   - Pestaña "Config" con parámetros utilizados

2. **Archivo resumen (opcional):**
   - `data/output/reportes/Resumen_Costo_Amortizable_MM_AAAA.xlsx`
   - Solo pestaña "Resultados"
   - Sin macros, liviano

3. **Log de ejecución macro:**
   - Escrito en pestaña "Log" del archivo o en archivo .txt separado
   - `logs/ejecuciones/HU16_Macro_Amortizacion_AAAAMMDD_HHMMSS.log`

### Reportería

Log con:
- **Resumen de procesamiento:**
  - Obligaciones procesadas: XXX
  - Tablas de amortización generadas: XXX (2 por obligación)
  - Cuotas totales calculadas: XXXX
  
- **Resultados financieros:**
  - Saldo total procesado: $XXX,XXX,XXX
  - **Valor valuativo total (Costo Amortizable):** $XXX,XXX,XXX
  - Promedio por obligación: $XXX,XXX
  - % sobre saldo total: X.XX%

- **Distribución por herramienta:**
  - Reestructurados: $XXX,XXX valor valuativo
  - Modificados: $XXX,XXX valor valuativo
  - Retenciones: $XXX,XXX valor valuativo

- **Excepciones:** XXX obligaciones requieren revisión

- **Performance:**
  - Tiempo de ejecución: XX minutos
  - Registros por minuto: XXX

### Parametría

- **Archivo macro:** `Macro_Amortizacion_Costo_Amortizable.xlsm` (configurable)
- **Servidor SQL:** `10.1.5.172\RIESGOS` (configurable en pestaña Config)
- **Tabla SQL:** `bd_perdidas_ganancias_dwh_MM_AAAA` (configurable)
- **Umbral saldo final tabla:** $10 (configurable - tolerancia de redondeo)
- **Umbral valor extremo:** 2x saldo (configurable)
- **Timeout macro:** 60 minutos (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-11:** Tablas cargadas en SQL
- **HU-12:** Datos validados
- **HU-13:** Tasas, plazos, saldos
- **HU-15:** Tabla bd_perdidas_ganancias_dwh creada

### Historias de Usuario Posteriores
- **HU-17:** Formato de envío - Puede usar resultados de esta HU
- **HU-18:** Subir base valuativa - Usará el valor valuativo calculado

### Recursos Externos
- **Microsoft Excel 2016+:** Con soporte de macros VBA habilitado
- **Macro VBA:** Debe estar desarrollada y probada antes de HU-16
- **Conectividad SQL desde Excel:** Drivers ODBC o ADO configurados

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD (invocación macro) | 2 horas |
| Ajustes a macro VBA | 4 horas |
| Pruebas de cálculos | 2 horas |
| Pruebas integradas | 2 horas |
| **Total** | **10 horas** |

> **Nota:** Esto asume que la macro VBA ya existe. Si hay que desarrollarla desde cero, sumar 20-30 horas adicionales.

---

## Notas Adicionales

### Consideraciones Técnicas

- **HU más compleja de Sprint 3:** Esta HU requiere integración entre PAD, Excel, VBA y SQL. Múltiples tecnologías trabajando juntas.

- **Macro VBA no forma parte del alcance de esta HU:** Se asume que la macro VBA ya está desarrollada y probada. Esta HU solo la invoca y valida resultados.

- **Performance crítico:** Con miles de obligaciones y tablas de amortización de hasta 360 filas cada una, el archivo Excel puede crecer mucho. Considerar:
  - Procesar en lotes si es necesario
  - Usar cálculo manual en Excel durante ejecución
  - Limpiar objetos de memoria en VBA

- **Alternativa Python:** Se podría reemplazar la macro VBA con scripts Python usando pandas + openpyxl. Más rápido y mantenible, pero requiere cambio de tecnología.

### Consideraciones de Negocio

- **Cálculo del valor valuativo es el corazón del proceso:** Este es el cálculo más importante - determina el impacto financiero real de las herramientas de alivio.

- **Tablas de amortización para auditoría:** Las tablas detalladas permiten auditar cada obligación y verificar que los cálculos son correctos.

- **Valor valuativo = Costo amortizable:** Este valor se reporta como el costo que el banco asume por otorgar los beneficios (reestructuraciones, modificaciones, retenciones).

### Riesgos Identificados

- **Riesgo 1: Macro VBA con errores**
  - Impacto: Crítico - Cálculos incorrectos
  - Mitigación: Pruebas exhaustivas de la macro con casos conocidos. Comparar resultados con cálculos manuales. Revisión de código VBA por desarrollador experimentado.

- **Riesgo 2: Excel se cuelga o crashea**
  - Impacto: Alto - Proceso no completa
  - Mitigación: Procesar en lotes. Limpiar objetos de memoria. Cerrar y reabrir Excel cada N obligaciones. Tener script de recuperación.

- **Riesgo 3: Tablas de amortización no cuadran**
  - Impacto: Alto - Resultados no confiables
  - Mitigación: Validar fórmula de cuota. Manejar redondeos correctamente. Ajustar última cuota si es necesario. Validar que saldo final es cero.

- **Riesgo 4: Macros deshabilitadas por política corporativa**
  - Impacto: Alto - No se puede ejecutar
  - Mitigación: Coordinar con IT para habilitar macros en equipo de ejecución. Tener excepción de política aprobada. Alternativa: Firmar digitalmente la macro.

- **Riesgo 5: Archivo Excel demasiado grande**
  - Impacto: Medio - Performance degradado, difícil de abrir
  - Mitigación: Limitar tablas de amortización detalladas a pestaña separada. Considerar comprimir o dividir en múltiples archivos.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 11/11/2025
