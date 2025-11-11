# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 20 |
| **Nombre Historia** | Verificación y Ajustes para Producción |
| **No. Versión** | 1 |
| **Fecha Creación** | 11/11/2025 12:00 |
| **Fecha Modificación** | 11/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Realizar las verificaciones finales, filtrar advertencias, aplicar ajustes de BUSCARV y preparar la base final lista para producción

**De forma que:** El archivo esté completamente validado, corregido y listo para el cargue final sin errores

---

## Criterios de Aceptación

### Insumos

1. **Archivo con BASE consolidada (HU-19):**
   - `01. información Consolidada MM_AAAA.xlsx`
   - Con pestaña "BASE" completa

2. **Tabla SQL de referencia:**
   - `bd_costo_amortizable_MM_AAAA` (de HU-18)
   - Para cruces y validaciones

3. **Archivo de parámetros:**
   - `data/input/parametros/Parametros_Validacion.xlsx`
   - Con umbrales y valores de referencia

### Entradas de las Funcionalidades

- Hoja BASE consolidada
- Parámetros de validación
- Catálogos de valores válidos
- Histórico de meses anteriores (para comparaciones)

### Funcionalidades

1. **Abrir archivo de trabajo**
   
   - Abrir `01. información Consolidada MM_AAAA.xlsx`
   - Ir a pestaña "BASE"
   - Validar que tiene datos
   - Registrar cantidad de registros iniciales

2. **Crear pestaña "ADVERTENCIAS"**
   
   - Agregar nueva pestaña "ADVERTENCIAS"
   - Esta contendrá todos los registros que requieren revisión
   - Estructura: misma que BASE + columna "Tipo_Advertencia"

3. **Filtrar registros con advertencias**
   
   Identificar y copiar a pestaña ADVERTENCIAS:
   
   a) **Registros con validación no OK:**
   ```excel
   =FILTRO(BASE, Flag_Validacion_General="REVISAR")
   ```
   Marcar como: "VALIDACION_GENERAL"
   
   b) **Valores extremos:**
   ```excel
   =FILTRO(BASE, Flag_Valor_Extremo="EXTREMO")
   ```
   Marcar como: "VALOR_EXTREMO"
   
   c) **Casos especiales:**
   ```excel
   =FILTRO(BASE, Caso_Especial<>"")
   ```
   Marcar como: Contenido de columna Caso_Especial

4. **Validación contra tabla SQL**
   
   Comparar datos de BASE con SQL:
   
   ```sql
   -- Obtener totales de SQL
   SELECT 
       COUNT(*) as Total_SQL,
       SUM(Valor_Valuativo) as Costo_Total_SQL,
       SUM(Saldo_Capital) as Saldo_Total_SQL
   FROM bd_costo_amortizable_MM_AAAA
   ```
   
   Comparar con totales de BASE:
   - Si diferencias > 0.01%, investigar y corregir

5. **Identificar obligaciones duplicadas**
   
   En pestaña BASE:
   ```excel
   -- Agregar columna auxiliar
   =CONTAR.SI($E$2:$E$10000, E2)
   ```
   
   Si alguna obligación aparece más de 1 vez:
   - Copiar a ADVERTENCIAS
   - Marcar como: "DUPLICADO"
   - Investigar causa
   - Eliminar duplicado (dejar solo 1)

6. **Validar coherencia de clasificación**
   
   Verificar reglas de negocio:
   
   a) **Retenciones siempre Individual + Misma Obligación:**
   ```excel
   =SI(Y(Herramienta="Retención", O(Tipo_Herramienta<>"Individual", Tipo_Obligacion<>"Misma Obligación")), 
       "ERROR_CLASIFICACION", "OK")
   ```
   
   b) **Consolidadas siempre Diferente Obligación:**
   ```excel
   =SI(Y(Tipo_Herramienta="Consolidada", Tipo_Obligacion<>"Diferente Obligación"),
       "ERROR_CLASIFICACION", "OK")
   ```
   
   Si hay errores, copiar a ADVERTENCIAS y corregir en BASE

7. **Aplicar BUSCARV para completar datos faltantes**
   
   Si hay campos vacíos en BASE, buscar en otras fuentes:
   
   a) **Completar Nombre_Cliente desde pestaña 1:**
   ```excel
   =SI(ESBLANCO(D2), 
       BUSCARV(E2, '1. Reestructurados'!$A:$Z, 5, FALSO),
       D2)
   ```
   
   b) **Completar Modalidad desde definitivos (si se tiene en Excel):**
   Si se exportó tabla de definitivos a Excel:
   ```excel
   =SI(ESBLANCO(I2),
       BUSCARV(E2, Definitivos!$A:$F, 4, FALSO),
       I2)
   ```
   
   c) **Completar Producto:**
   Similar lógica con BUSCARV

8. **Validar rangos de tasas**
   
   Crear validación condicional:
   
   a) **Tasas entre 0% y 50%:**
   ```excel
   -- Columna de validación
   =SI(O(Tasa_Anterior<0, Tasa_Anterior>0.5, Tasa_Nueva<0, Tasa_Nueva>0.5),
       "TASA_FUERA_RANGO", "OK")
   ```
   
   Si hay tasas fuera de rango:
   - Copiar a ADVERTENCIAS
   - Puede requerir corrección manual o confirmación

9. **Validar rangos de plazos**
   
   ```excel
   =SI(O(Plazo_Anterior<1, Plazo_Anterior>360, Plazo_Nuevo<1, Plazo_Nuevo>360),
       "PLAZO_FUERA_RANGO", "OK")
   ```

10. **Validar saldos positivos**
    
    ```excel
    =SI(Saldo_Capital<=0, "SALDO_INVALIDO", "OK")
    ```
    
    Saldos en 0 o negativos son error crítico

11. **Comparación con mes anterior (si disponible)**
    
    Si existe archivo del mes anterior:
    - Abrir `01. información Consolidada MM-1_AAAA.xlsx`
    - Comparar cantidad de obligaciones
    - Identificar obligaciones que aparecen en mes actual pero no en anterior (nuevas)
    - Identificar obligaciones que estaban en mes anterior pero no en actual (finalizadas)
    
    Crear reporte de variación mes a mes

12. **Validar que retenciones redujeron tasa**
    
    Para todas las retenciones:
    ```excel
    =SI(Y(Herramienta="Retención", Tasa_Nueva>=Tasa_Anterior),
        "RETENCION_SIN_REDUCCION_TASA", "OK")
    ```
    
    Una retención debería reducir la tasa. Si no lo hace, marcar en ADVERTENCIAS

13. **Aplicar ajustes automáticos aprobados**
    
    Según políticas del banco:
    
    a) **Redondeo de valores valuativos:**
    ```excel
    =REDONDEAR(Valor_Valuativo, 0)  -- Sin decimales
    ```
    
    b) **Redondeo de tasas:**
    ```excel
    =REDONDEAR(Tasa_Anterior, 4)  -- 4 decimales
    =REDONDEAR(Tasa_Nueva, 4)
    ```
    
    c) **Corrección de formatos de fecha:**
    Asegurar que todas las fechas tienen formato DD/MM/AAAA

14. **Aplicar filtros para identificar Top y Bottom**
    
    Crear listas auxiliares:
    
    a) **Top 10 obligaciones con mayor costo amortizable:**
    Copiar a nueva pestaña "TOP_10_COSTO"
    
    b) **Top 10 clientes con mayor costo total:**
    Agrupar por Numero_Id y sumar
    
    c) **Bottom 10 (menores costos):**
    Para análisis de casos atípicos

15. **Generar pestaña "BASE_FINAL"**
    
    - Copiar pestaña BASE completa
    - Renombrar como "BASE_FINAL"
    - Eliminar columnas auxiliares de validación
    - Eliminar registros que están en ADVERTENCIAS y no fueron corregidos
    - Esta será la base limpia para cargue final

16. **Validar integridad de BASE_FINAL**
    
    Ejecutar validaciones finales:
    
    a) **Sin duplicados:**
    ```
    COUNT(DISTINCT N_Obligacion) = COUNT(N_Obligacion)
    ```
    
    b) **Sin valores nulos críticos:**
    - Todas las obligaciones tienen N_Obligacion, Saldo_Capital, Valor_Valuativo
    
    c) **Todas las validaciones OK:**
    - 100% de registros con Flag_Validacion_General = "OK"
    
    d) **Totales cuadran:**
    - Suma Valor_Valuativo = Total esperado
    - Suma Saldo_Capital = Total esperado

17. **Generar reporte de verificación**
    
    Crear pestaña "REPORTE_VERIFICACION" con:
    
    **Sección 1: Resumen de validaciones**
    - Total registros iniciales
    - Registros con advertencias identificadas
    - Registros corregidos
    - Registros eliminados
    - Total registros finales
    
    **Sección 2: Tipos de advertencias**
    - Validación general: XX registros
    - Valores extremos: XX registros
    - Duplicados: XX registros
    - Tasas fuera de rango: XX registros
    - Otros: XX registros
    
    **Sección 3: Ajustes aplicados**
    - BUSCARVs ejecutados: XX
    - Valores redondeados: XX
    - Registros corregidos manualmente: XX
    
    **Sección 4: Comparación SQL vs Excel**
    - Registros SQL: XXX
    - Registros BASE_FINAL: XXX
    - Diferencia: XX
    - % Coincidencia: XX.XX%
    
    **Sección 5: Estadísticas finales**
    - Costo Amortizable Total: $XXX,XXX,XXX
    - Por herramienta
    - Por tipo
    - Distribución por rangos

18. **Aplicar protección a pestañas finales**
    
    - Proteger "BASE_FINAL" (solo lectura)
    - Proteger "REPORTE_VERIFICACION" (solo lectura)
    - Dejar editable "ADVERTENCIAS" (para comentarios de analistas)

19. **Generar archivo de advertencias para revisión**
    
    - Exportar pestaña ADVERTENCIAS a archivo separado
    - Guardar como: `Advertencias_Revision_MM_AAAA.xlsx`
    - Enviar a equipo de Riesgos para revisión y aprobación
    - Esperar retroalimentación antes de HU-21

20. **Guardar versión final validada**
    
    - Guardar archivo principal
    - Crear versión con timestamp: `01. información Consolidada MM_AAAA_VALIDADO_AAAAMMDD.xlsx`
    - Marcar en pestaña "REPORTE_VERIFICACION" el estado: "VALIDADO - LISTO PARA CARGUE FINAL"

### Puntos de Control Crítico

1. **Diferencias con SQL > 0.1%:** Si los totales de BASE_FINAL difieren de SQL en más de 0.1%, detener y reconciliar.

2. **Duplicados encontrados:** Si hay obligaciones duplicadas, detener y eliminar duplicados antes de continuar.

3. **Más del 5% con advertencias críticas:** Si más del 5% de registros tienen advertencias que no se pueden resolver automáticamente, escalar para revisión manual.

4. **Validaciones de negocio fallan:** Si hay retenciones que no reducen tasa, o consolidadas mal clasificadas, detener y corregir.

### Puntos de Control No Crítico

1. **Pocas advertencias (< 2%):** Si menos del 2% tiene advertencias menores, registrar pero continuar.

2. **Algunos campos complementarios vacíos:** Si campos no críticos como Segmento o Ciudad tienen NULLs, está bien.

3. **Valores extremos aislados (< 1%):** Si hay pocos valores extremos que están justificados, registrar pero continuar.

### Salidas

1. **Archivo principal actualizado:**
   - `01. información Consolidada MM_AAAA_VALIDADO_AAAAMMDD.xlsx`
   - Pestaña "BASE_FINAL" limpia y validada
   - Pestaña "ADVERTENCIAS" con casos pendientes
   - Pestaña "REPORTE_VERIFICACION" con análisis completo
   - Pestaña "TOP_10_COSTO" con principales casos

2. **Archivo de advertencias:**
   - `Advertencias_Revision_MM_AAAA.xlsx`
   - Para revisión por equipo de Riesgos

3. **Reporte de verificación:**
   - Puede exportarse a PDF o Word para documentación

4. **Log:** `logs/ejecuciones/HU20_Verificacion_Produccion_AAAAMMDD_HHMMSS.log`

### Reportería

Log con:
- **Verificación completada**
- **Resumen de validaciones:**
  - Registros iniciales: XXX
  - Con advertencias: XXX (XX%)
  - Corregidos: XXX
  - Eliminados: XXX
  - **Registros finales:** XXX
  
- **Tipos de advertencias:**
  - Validación general: XX
  - Valores extremos: XX
  - Duplicados: XX
  - Otros: XX
  
- **Ajustes aplicados:**
  - BUSCARVs: XX
  - Redondeos: XX
  - Correcciones manuales: XX
  
- **Validación final:**
  - Coincidencia con SQL: XX.XX%
  - Costo Amortizable Total: $XXX,XXX,XXX
  - Estado: LISTO PARA CARGUE FINAL

### Parametría

- **Umbral diferencia SQL:** 0.1% (configurable)
- **Umbral advertencias críticas:** 5% (configurable)
- **Umbral advertencias menores:** 2% (configurable)
- **Redondeo valores:** 0 decimales (configurable)
- **Redondeo tasas:** 4 decimales (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-18:** Tabla SQL de referencia
- **HU-19:** Hoja BASE consolidada

### Historias de Usuario Posteriores
- **HU-21:** Cargue final - Usará BASE_FINAL

### Recursos Externos
- **Archivo de parámetros:** Con umbrales y valores de referencia
- **Histórico mes anterior:** Para comparaciones (si disponible)
- **Equipo de Riesgos:** Para aprobar advertencias

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 4 horas |
| Desarrollo Python | 2 horas |
| Validaciones y pruebas | 3 horas |
| Revisión manual de advertencias | 1 hora |
| **Total** | **10 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **HU de control de calidad:** Esta es la HU de QA del proceso. Debe ser exhaustiva.

- **BUSCARV vs Python:** Los BUSCARV en Excel pueden ser lentos con muchos datos. Considerar usar Python con pandas merge para mayor eficiencia.

- **Validaciones parametrizadas:** Los umbrales de validación deberían ser configurables, no hardcodeados.

### Consideraciones de Negocio

- **Última oportunidad de corrección:** Esta es la última HU antes del cargue final. Cualquier error que pase aquí llegará a producción.

- **Balance entre automatización y revisión manual:** No todo se puede automatizar. Algunas advertencias requieren juicio de analista experimentado.

- **Documentación de ajustes crítica:** Cualquier ajuste o corrección manual debe quedar documentado para auditoría.

### Riesgos Identificados

- **Riesgo 1: Advertencias críticas ignoradas**
  - Impacto: Crítico - Datos incorrectos en producción
  - Mitigación: Proceso de aprobación obligatorio. No avanzar a HU-21 hasta que advertencias críticas estén resueltas o aprobadas.

- **Riesgo 2: Correcciones incorrectas**
  - Impacto: Alto - Se introducen nuevos errores al corregir
  - Mitigación: Validar cada corrección. Comparar antes/después. Mantener log de cambios.

- **Riesgo 3: Falsos positivos en validaciones**
  - Impacto: Medio - Se marcan como error datos que son correctos
  - Mitigación: Refinar reglas de validación con casos reales. Permitir excepciones justificadas.

- **Riesgo 4: No se detectan todos los errores**
  - Impacto: Alto - Errores pasan a producción
  - Mitigación: Validaciones múltiples y redundantes. Comparación con SQL. Revisión manual de muestra.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 11/11/2025
