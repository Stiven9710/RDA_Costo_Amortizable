# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 14 |
| **Nombre Historia** | Cálculo de Pérdida o Ganancia por Obligación |
| **No. Versión** | 1 |
| **Fecha Creación** | 11/11/2025 09:00 |
| **Fecha Modificación** | 11/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Calcular la pérdida o ganancia generada por cada reestructuración, modificación o retención aplicada a los créditos

**De forma que:** Se determine el impacto financiero de cada herramienta aplicada y se consolide en un archivo Excel para análisis posterior

---

## Criterios de Aceptación

### Insumos

1. **Tablas SQL con datos completos (HU-13):**
   - `bd_reestructurados_MM_AAAA`
   - `bd_modificados_MM_AAAA`
   - `bd_retenciones_MM_AAAA`
   - Cada tabla con: Tasa_Anterior, Tasa_Nueva, Plazo_Anterior, Plazo_Nuevo, Saldo_Capital

2. **Archivo Excel destino:**
   - `02. Pérdidas y Ganancias MM_AAAA.xlsx`
   - Plantilla ubicada en `data/input/plantillas/`

3. **Fórmulas de cálculo:**
   - Fórmula de valor presente de anualidades
   - Cálculo de flujos de caja descontados

### Entradas de las Funcionalidades

- Datos de obligaciones desde SQL
- Plantilla Excel para consolidación
- Parámetros: mes, año, fecha de corte
- Tasas de descuento (si aplica)

### Funcionalidades

1. **Copiar plantilla de Pérdidas y Ganancias**
   
   - Ruta origen: `data/input/plantillas/Plantilla_Perdidas_Ganancias.xlsx`
   - Ruta destino: `data/output/reportes/02. Pérdidas y Ganancias MM_AAAA.xlsx`
   - Validar que plantilla existe
   - Sobrescribir si archivo destino ya existe (re-ejecución)

2. **Abrir archivo Excel destino**
   
   - Abrir `02. Pérdidas y Ganancias MM_AAAA.xlsx`
   - Validar que tiene las pestañas esperadas:
     - "Reestructurados"
     - "Modificados"
     - "Retenciones"
     - "Consolidado"
   - Cada pestaña tiene estructura predefinida con columnas

3. **Exportar datos de SQL a Excel - Reestructurados**
   
   Extraer de SQL:
   ```sql
   SELECT 
       Fecha_Corte,
       Tipo_Id,
       Numero_Id,
       obligacion_nueva,
       obligacion1, obligacion2, obligacion3, ... , obligacion25,
       Herramienta,
       Tipo_Herramienta,
       Tipo_Obligacion,
       Modalidad,
       Tasa_Anterior,
       Tasa_Nueva,
       Plazo_Anterior,
       Plazo_Nuevo,
       Saldo_Capital
   FROM bd_reestructurados_MM_AAAA
   ORDER BY Numero_Id, obligacion_nueva
   ```
   
   Pegar en pestaña "Reestructurados" desde fila 2 (fila 1 son encabezados)

4. **Calcular pérdida/ganancia - Reestructurados**
   
   En pestaña "Reestructurados", agregar columnas calculadas:
   
   **Columna AA: Valor_Anterior**
   Calcular valor presente con condiciones anteriores (Tasa_Anterior, Plazo_Anterior):
   
   Fórmula en Excel (conceptual):
   ```
   =SI(Tasa_Anterior=0, Saldo_Capital, 
      Saldo_Capital * ((1 - (1 + Tasa_Anterior/12)^(-Plazo_Anterior)) / (Tasa_Anterior/12)))
   ```
   
   > **Nota:** Esta es la fórmula de valor presente de una anualidad. Calcula cuánto vale hoy el flujo de pagos futuros con las condiciones anteriores.

5. **Columna AB: Valor_Nuevo**
   
   Calcular valor presente con condiciones nuevas (Tasa_Nueva, Plazo_Nuevo):
   ```
   =SI(Tasa_Nueva=0, Saldo_Capital,
      Saldo_Capital * ((1 - (1 + Tasa_Nueva/12)^(-Plazo_Nuevo)) / (Tasa_Nueva/12)))
   ```

6. **Columna AC: Perdida_Ganancia**
   
   Calcular diferencia:
   ```
   =Valor_Nuevo - Valor_Anterior
   ```
   
   - Si resultado es **negativo**: Pérdida (el banco pierde valor)
   - Si resultado es **positivo**: Ganancia (el banco gana valor)
   
   > **Interpretación:** En reestructuraciones/modificaciones que benefician al cliente (menor tasa, mayor plazo), generalmente hay pérdida para el banco.

7. **Columna AD: Tipo_Resultado**
   
   Clasificar el resultado:
   ```
   =SI(Perdida_Ganancia<0, "PÉRDIDA", SI(Perdida_Ganancia>0, "GANANCIA", "NEUTRO"))
   ```

8. **Aplicar fórmulas a todos los registros**
   
   - Copiar fórmulas de columnas AA, AB, AC, AD
   - Autocompletar hasta la última fila con datos
   - Validar que todas las filas tienen cálculos

9. **Exportar datos de SQL a Excel - Modificados**
   
   Extraer modificados de SQL:
   ```sql
   SELECT 
       Fecha_Corte,
       Tipo_Id,
       Numero_Id,
       obligacion_nueva,
       obligacion1, obligacion2, ...,
       Herramienta,
       Tipo_Herramienta,
       Tipo_Obligacion,
       Modalidad,
       Tasa_Anterior,
       Tasa_Nueva,
       Plazo_Anterior,
       Plazo_Nuevo,
       Saldo_Capital
   FROM bd_modificados_MM_AAAA
   ORDER BY Numero_Id, obligacion_nueva
   ```
   
   Pegar en pestaña "Modificados"

10. **Calcular pérdida/ganancia - Modificados**
    
    Aplicar las mismas fórmulas que en reestructurados (pasos 4-8):
    - Columna AA: Valor_Anterior
    - Columna AB: Valor_Nuevo
    - Columna AC: Perdida_Ganancia
    - Columna AD: Tipo_Resultado

11. **Exportar datos de SQL a Excel - Retenciones**
    
    Extraer retenciones:
    ```sql
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
        Saldo_Capital
    FROM bd_retenciones_MM_AAAA
    ORDER BY Numero_Id, obligacion_nueva
    ```
    
    Pegar en pestaña "Retenciones"

12. **Calcular pérdida/ganancia - Retenciones**
    
    Aplicar las mismas fórmulas (pasos 4-8):
    - Las retenciones típicamente generan pérdida (tasa menor = menos ingresos para el banco)

13. **Consolidar totales por herramienta**
    
    En pestaña "Consolidado", crear tabla resumen:
    
    | Herramienta | Total_Obligaciones | Saldo_Total | Perdida_Total | Ganancia_Total | Neto |
    |-------------|-------------------|-------------|---------------|----------------|------|
    | Reestructurado | =CONTAR(...) | =SUMA(...) | =SUMAR.SI(...<0) | =SUMAR.SI(...>0) | =SUMA(...) |
    | Modificado | ... | ... | ... | ... | ... |
    | Retención | ... | ... | ... | ... | ... |
    | **TOTAL** | ... | ... | ... | ... | ... |

14. **Crear subtotales por tipo de herramienta**
    
    Desglosar consolidado:
    
    a) **Reestructurados:**
    - Consolidada - Diferente Obligación
    - Individual - Misma Obligación
    
    b) **Modificados:**
    - Consolidada - Diferente Obligación
    - Individual - Misma Obligación
    
    c) **Retenciones:**
    - Individual - Misma Obligación

15. **Calcular estadísticas adicionales**
    
    En pestaña "Consolidado", agregar:
    - Pérdida/Ganancia promedio por obligación
    - Pérdida/Ganancia como % del saldo
    - Cantidad de obligaciones con pérdida vs ganancia
    - Distribución de pérdidas/ganancias por rangos

16. **Formatear columnas de valores**
    
    Aplicar formato a todas las pestañas:
    - Columnas de saldo: Formato moneda `$#,##0.00`
    - Columnas de tasas: Formato porcentaje `0.00%`
    - Columnas de plazos: Formato número entero
    - Columnas de pérdida/ganancia: Formato moneda con colores
      - Rojo para pérdidas (negativos)
      - Verde para ganancias (positivos)

17. **Aplicar formato condicional**
    
    En columna Perdida_Ganancia:
    - Fondo rojo claro si < 0 (pérdida)
    - Fondo verde claro si > 0 (ganancia)
    - Fondo gris si = 0 (neutro)

18. **Crear gráficos de análisis**
    
    En pestaña "Consolidado", agregar:
    
    a) **Gráfico de barras:** Pérdida/Ganancia por herramienta
    b) **Gráfico de pastel:** Distribución de saldo por herramienta
    c) **Gráfico de dispersión:** Saldo vs Pérdida/Ganancia

19. **Validar coherencia de cálculos**
    
    Ejecutar validaciones:
    
    a) **Suma de pestañas = Consolidado:**
    - Total pérdidas en Reestructurados + Modificados + Retenciones = Total en Consolidado
    
    b) **Validar fórmulas sin errores:**
    - Buscar celdas con #DIV/0!, #VALUE!, #N/A
    - Si hay errores, identificar causa y corregir
    
    c) **Validar rangos lógicos:**
    - Pérdida/Ganancia no debe ser superior a 3x el Saldo_Capital
    - Si hay valores extremos, marcar para revisión

20. **Generar pestaña de excepciones**
    
    Crear pestaña "Excepciones" con:
    - Obligaciones con pérdida/ganancia > 100% del saldo
    - Obligaciones con tasa o plazo NULL
    - Obligaciones con errores en fórmulas
    - Requieren revisión manual

21. **Guardar y proteger archivo**
    
    - Guardar archivo Excel
    - Proteger pestañas con fórmulas (solo lectura)
    - Dejar pestaña "Consolidado" editable para ajustes manuales
    - Registrar timestamp de generación

### Puntos de Control Crítico

1. **Validación de fórmulas:** Si más del 1% de filas tienen errores de fórmula (#DIV/0!, #VALUE!), detener y corregir origen de datos.

2. **Validación de totales:** Si la suma de pérdidas/ganancias individuales no coincide con el consolidado, detener (error de fórmulas).

3. **Valores extremos:** Si hay pérdidas/ganancias superiores a 3x el saldo de la obligación, detener y revisar datos (probablemente tasas o plazos incorrectos).

4. **Todas las pestañas completas:** Validar que las 3 pestañas principales (Reestructurados, Modificados, Retenciones) tienen datos y cálculos.

### Puntos de Control No Crítico

1. **Retenciones vacías:** Si pestaña Retenciones está vacía (mes sin retenciones), registrar advertencia pero continuar.

2. **Valores extremos aislados (< 0.5%):** Si hay pocos valores extremos, registrar en excepciones pero continuar.

### Salidas

1. **Archivo Excel:** `data/output/reportes/02. Pérdidas y Ganancias MM_AAAA.xlsx`
   - Pestaña "Reestructurados" con cálculos completos
   - Pestaña "Modificados" con cálculos completos
   - Pestaña "Retenciones" con cálculos completos
   - Pestaña "Consolidado" con totales y estadísticas
   - Pestaña "Excepciones" con casos especiales
   - Gráficos de análisis

2. **Resumen estadístico en log:**
   - Total pérdidas: $XXX,XXX,XXX
   - Total ganancias: $XXX,XXX,XXX
   - Neto (pérdida/ganancia): $XXX,XXX,XXX
   - % de pérdida sobre saldo total

3. **Log:** `logs/ejecuciones/HU14_Calculo_Perdida_Ganancia_AAAAMMDD_HHMMSS.log`

### Reportería

Log con:
- **Resumen por herramienta:**
  - Reestructurados: XXX obligaciones, Pérdida neta: $XXX,XXX
  - Modificados: XXX obligaciones, Pérdida neta: $XXX,XXX
  - Retenciones: XXX obligaciones, Pérdida neta: $XXX,XXX

- **Estadísticas globales:**
  - Total obligaciones procesadas: XXX
  - Saldo total afectado: $XXX,XXX,XXX
  - Pérdida total: $XXX,XXX,XXX
  - Ganancia total: $XXX,XXX,XXX
  - **Neto:** $XXX,XXX,XXX (generalmente pérdida)
  - % de pérdida sobre saldo: X.XX%

- **Distribución:**
  - Obligaciones con pérdida: XXX (XX%)
  - Obligaciones con ganancia: XXX (XX%)
  - Obligaciones neutras: XXX (XX%)

- **Excepciones detectadas:** XXX obligaciones requieren revisión

### Parametría

- **Plantilla origen:** `Plantilla_Perdidas_Ganancias.xlsx` (configurable)
- **Ruta salida:** `data/output/reportes/` (configurable)
- **Umbral valor extremo:** 3x saldo (configurable)
- **Tasa de descuento:** Por defecto usar tasa de cada obligación (configurable si se requiere tasa única)
- **Formato moneda:** Pesos colombianos (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-11:** Tablas cargadas en SQL
- **HU-12:** Datos validados y completos
- **HU-13:** Tasas, plazos y saldos recolectados

### Historias de Usuario Posteriores
- **HU-15:** Query variables valuativo - Usará algunos resultados de pérdida/ganancia
- **HU-17:** Formato de envío - Puede requerir resumen de pérdida/ganancia

### Recursos Externos
- **Plantilla Excel:** Debe existir con estructura correcta
- **Excel instalado:** Microsoft Excel 2016+ o compatible

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 6 horas |
| Desarrollo Python (pandas/openpyxl) | 4 horas |
| Creación de fórmulas Excel | 2 horas |
| Pruebas unitarias | 1 hora |
| Pruebas integradas | 1 hora |
| **Total** | **14 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **HU más compleja técnicamente:** Esta es la HU con mayor complejidad de cálculos. Las fórmulas de valor presente requieren entendimiento de matemáticas financieras.

- **Alternativa Python:** Se puede usar pandas + numpy para cálculos y openpyxl para escribir Excel. Más eficiente que manipular Excel directamente con PAD.

- **Fórmulas en Excel vs cálculo en código:** Se puede optar por:
  - **Opción A:** Insertar fórmulas en Excel (más transparente para auditores)
  - **Opción B:** Calcular en Python/PAD y pegar valores (más rápido)

- **División por cero:** Manejar caso cuando Tasa = 0 (usar el saldo directamente como valor presente).

### Consideraciones de Negocio

- **Pérdida esperada:** En general, reestructuraciones, modificaciones y retenciones son beneficios para clientes, por lo que el banco debería tener pérdidas (menor valor presente de flujos futuros).

- **Importancia para negocio:** Este cálculo es fundamental para medir el costo de las herramientas de alivio financiero que el banco otorga.

- **Auditoría:** Los resultados de pérdida/ganancia pueden ser auditados. Es crítico que las fórmulas sean correctas y trazables.

### Riesgos Identificados

- **Riesgo 1: Fórmulas incorrectas**
  - Impacto: Crítico - Resultados financieros incorrectos
  - Mitigación: Validar fórmulas con casos de prueba conocidos. Revisión por experto financiero. Comparar con cálculo manual de muestra.

- **Riesgo 2: Tasas o plazos incorrectos de HU-13**
  - Impacto: Alto - Propagación de errores en cálculos
  - Mitigación: Validar rangos de tasas/plazos antes de calcular. Detener si hay valores sospechosos.

- **Riesgo 3: Excel con errores de fórmula**
  - Impacto: Alto - Cálculos incompletos
  - Mitigación: Validar que no hay #DIV/0!, #VALUE!, #N/A. Manejo robusto de casos especiales en fórmulas.

- **Riesgo 4: Performance en Excel con muchos registros**
  - Impacto: Medio - Proceso muy lento
  - Mitigación: Considerar usar Python para cálculos pesados. Evitar fórmulas volátiles en Excel.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 11/11/2025
