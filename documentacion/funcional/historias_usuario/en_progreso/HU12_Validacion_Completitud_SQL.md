# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 12 |
| **Nombre Historia** | Validación y Completitud de Información en SQL |
| **No. Versión** | 1 |
| **Fecha Creación** | 11/11/2025 08:00 |
| **Fecha Modificación** | 11/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Verificar la completitud de la información cargada en las 3 tablas SQL y completar campos faltantes mediante cruces con tablas de referencia

**De forma que:** Los datos estén completos y validados antes de proceder con los cálculos de pérdida/ganancia y valor valuativo

---

## Criterios de Aceptación

### Insumos

1. **Tablas SQL cargadas en HU-11:**
   - `bd_reestructurados_MM_AAAA`
   - `bd_modificados_MM_AAAA`
   - `bd_retenciones_MM_AAAA`

2. **Tabla de referencia:**
   - `definitivos_credito` (servidor 10.1.3.101\SCC, base DWH_CC)
   - Contiene: Tipo_Id, Numero_Id, Modalidad por obligación

3. **Script SQL:** `03_Verificar_Info_Completitud.sql`

### Entradas de las Funcionalidades

- Conexión a servidor 10.1.5.172\RIESGOS (tablas del mes)
- Conexión a servidor 10.1.3.101\SCC (tabla definitivos)
- Parámetros de mes y año (MM_AAAA)

### Funcionalidades

1. **Establecer conexiones a ambos servidores SQL**
   
   - **Conexión 1:** 10.1.5.172\RIESGOS (DWH_Riesgos_Credito) - Tablas del mes
   - **Conexión 2:** 10.1.3.101\SCC (DWH_CC) - Tabla definitivos
   - Validar ambas conexiones exitosas
   - Registrar credenciales utilizadas

2. **Validar existencia de tablas del mes**
   
   Verificar que existen:
   ```sql
   SELECT COUNT(*) FROM DWH_Riesgos_Credito.dbo.bd_reestructurados_MM_AAAA
   SELECT COUNT(*) FROM DWH_Riesgos_Credito.dbo.bd_modificados_MM_AAAA
   SELECT COUNT(*) FROM DWH_Riesgos_Credito.dbo.bd_retenciones_MM_AAAA
   ```
   
   Si alguna no existe, detener proceso (error en HU-11)

3. **Verificar completitud de campos obligatorios**
   
   Para cada tabla, validar que NO hay NULLs en:
   - Fecha_Corte (o Fecha)
   - Herramienta
   - Tipo_Herramienta
   - Tipo_Obligacion
   - obligacion_nueva
   
   Query de validación:
   ```sql
   SELECT COUNT(*) as registros_incompletos
   FROM bd_reestructurados_MM_AAAA
   WHERE Fecha_Corte IS NULL 
      OR Herramienta IS NULL
      OR Tipo_Herramienta IS NULL
      OR Tipo_Obligacion IS NULL
      OR obligacion_nueva IS NULL
   ```
   
   Si registros_incompletos > 0, detener y reportar error

4. **Identificar campos faltantes por completar**
   
   Verificar campos que deben completarse desde definitivos:
   - Tipo_Id (tipo de identificación del cliente)
   - Numero_Id (número de identificación del cliente)
   - Modalidad (modalidad del crédito)
   
   Query para contar faltantes:
   ```sql
   SELECT 
       COUNT(*) as total_registros,
       SUM(CASE WHEN Tipo_Id IS NULL OR Tipo_Id = '' THEN 1 ELSE 0 END) as sin_tipo_id,
       SUM(CASE WHEN Numero_Id IS NULL OR Numero_Id = '' THEN 1 ELSE 0 END) as sin_numero_id,
       SUM(CASE WHEN Modalidad IS NULL OR Modalidad = '' THEN 1 ELSE 0 END) as sin_modalidad
   FROM bd_reestructurados_MM_AAAA
   ```
   
   Repetir para las 3 tablas

5. **Actualizar Tipo_Id desde tabla definitivos - Reestructurados**
   
   Actualizar mediante LEFT JOIN con la tabla definitivos:
   ```sql
   UPDATE r
   SET r.Tipo_Id = d.tipo_id
   FROM DWH_Riesgos_Credito.dbo.bd_reestructurados_MM_AAAA r
   LEFT JOIN [10.1.3.101\SCC].DWH_CC.dbo.definitivos_credito d
       ON r.obligacion_nueva = d.obligacion
   WHERE r.Tipo_Id IS NULL OR r.Tipo_Id = ''
   ```
   
   Registrar cantidad de registros actualizados

6. **Actualizar Numero_Id desde tabla definitivos - Reestructurados**
   
   ```sql
   UPDATE r
   SET r.Numero_Id = d.identificacion
   FROM DWH_Riesgos_Credito.dbo.bd_reestructurados_MM_AAAA r
   LEFT JOIN [10.1.3.101\SCC].DWH_CC.dbo.definitivos_credito d
       ON r.obligacion_nueva = d.obligacion
   WHERE r.Numero_Id IS NULL OR r.Numero_Id = ''
   ```

7. **Actualizar Modalidad desde tabla definitivos - Reestructurados**
   
   ```sql
   UPDATE r
   SET r.Modalidad = d.modalidad
   FROM DWH_Riesgos_Credito.dbo.bd_reestructurados_MM_AAAA r
   LEFT JOIN [10.1.3.101\SCC].DWH_CC.dbo.definitivos_credito d
       ON r.obligacion_nueva = d.obligacion
   WHERE r.Modalidad IS NULL OR r.Modalidad = ''
   ```

8. **Actualizar campos en tabla Modificados**
   
   Repetir los 3 UPDATE (Tipo_Id, Numero_Id, Modalidad) para:
   ```sql
   FROM DWH_Riesgos_Credito.dbo.bd_modificados_MM_AAAA
   ```
   
   Usar la misma lógica de LEFT JOIN con definitivos_credito

9. **Actualizar campos en tabla Retenciones**
   
   Repetir los 3 UPDATE (Tipo_Id, Numero_Id, Modalidad) para:
   ```sql
   FROM DWH_Riesgos_Credito.dbo.bd_retenciones_MM_AAAA
   ```

10. **Verificar obligaciones sin match en definitivos**
    
    Identificar obligaciones que no se encontraron en tabla definitivos:
    ```sql
    SELECT r.obligacion_nueva, r.Tipo_Id, r.Numero_Id, r.Modalidad
    FROM bd_reestructurados_MM_AAAA r
    WHERE r.Tipo_Id IS NULL OR r.Numero_Id IS NULL OR r.Modalidad IS NULL
    ```
    
    - Si hay obligaciones sin match, registrar advertencia
    - Estas pueden ser obligaciones muy nuevas o canceladas
    - Generar reporte con obligaciones no encontradas
    - Puede requerir revisión manual

11. **Validar consistencia de datos actualizados**
    
    Verificar que los datos tienen sentido:
    ```sql
    -- Verificar que Tipo_Id tiene valores válidos
    SELECT DISTINCT Tipo_Id, COUNT(*) as cantidad
    FROM bd_reestructurados_MM_AAAA
    GROUP BY Tipo_Id
    ORDER BY cantidad DESC
    ```
    
    Valores esperados de Tipo_Id: CC (Cédula Ciudadanía), NIT, CE, etc.
    
    Repetir validación para las 3 tablas

12. **Generar estadísticas de completitud**
    
    Para cada tabla, calcular:
    - Total de registros
    - Registros con Tipo_Id completo (%)
    - Registros con Numero_Id completo (%)
    - Registros con Modalidad completa (%)
    - Registros 100% completos
    - Registros con campos faltantes

13. **Validar calidad de datos**
    
    Ejecutar validaciones adicionales:
    
    a) **No duplicados en obligacion_nueva:**
    ```sql
    SELECT obligacion_nueva, COUNT(*) as veces
    FROM bd_reestructurados_MM_AAAA
    GROUP BY obligacion_nueva
    HAVING COUNT(*) > 1
    ```
    Debe retornar 0 registros
    
    b) **Formato de identificaciones válido:**
    - Numero_Id no debe tener caracteres especiales inválidos
    - Debe tener longitud razonable (entre 5 y 15 caracteres)
    
    c) **Modalidades válidas:**
    - Verificar que Modalidad está en catálogo de modalidades esperadas

14. **Generar reporte de validación**
    
    Crear reporte con:
    - Timestamp de ejecución
    - Estadísticas de completitud por tabla
    - Lista de obligaciones sin match en definitivos
    - Validaciones de calidad ejecutadas
    - Estado final: COMPLETO / INCOMPLETO / CON ADVERTENCIAS

15. **Registrar en log de auditoría**
    
    - Cantidad de registros actualizados por tabla y campo
    - Tiempo de ejecución de cada UPDATE
    - Obligaciones no encontradas en definitivos
    - Resultados de validaciones de calidad

### Puntos de Control Crítico

1. **Conexión a definitivos:** Si no se puede conectar a servidor 10.1.3.101\SCC, detener proceso (sin esta tabla no se pueden completar campos).

2. **Campos obligatorios faltantes:** Si después de los UPDATE aún hay NULLs en Fecha, Herramienta, Tipo_Herramienta, Tipo_Obligacion, u obligacion_nueva, detener proceso.

3. **Alta proporción sin match:** Si más del 10% de obligaciones no tienen match en definitivos, detener y revisar (puede indicar problema con tabla definitivos o con las obligaciones).

4. **Duplicados encontrados:** Si se encuentran obligaciones duplicadas en obligacion_nueva, detener y corregir en origen (error en HU-08, 09, o 10).

### Puntos de Control No Crítico

1. **Obligaciones sin match menores al 5%:** Si menos del 5% no tienen match, registrar advertencia pero continuar (pueden ser obligaciones muy recientes o ya canceladas).

2. **Modalidades no estándar:** Si aparecen modalidades no reconocidas pero los demás campos están OK, registrar advertencia pero continuar.

### Salidas

1. **Tablas actualizadas en SQL:**
   - `bd_reestructurados_MM_AAAA` con Tipo_Id, Numero_Id, Modalidad completos
   - `bd_modificados_MM_AAAA` con campos completos
   - `bd_retenciones_MM_AAAA` con campos completos

2. **Reporte de validación:** `reportes/Validacion_Completitud_MM_AAAA.xlsx`
   - Pestaña 1: Estadísticas de completitud
   - Pestaña 2: Obligaciones sin match en definitivos
   - Pestaña 3: Resultados de validaciones de calidad

3. **Log:** `logs/ejecuciones/HU12_Validacion_Completitud_AAAAMMDD_HHMMSS.log`

### Reportería

Log detallado con:
- **Estadísticas de actualización:**
  - Reestructurados: XXX registros actualizados
  - Modificados: XXX registros actualizados
  - Retenciones: XXX registros actualizados
  
- **Completitud final:**
  - Tipo_Id: XX% completo
  - Numero_Id: XX% completo
  - Modalidad: XX% completo
  
- **Obligaciones sin match:** Lista de N_Obligación sin encontrar en definitivos

- **Validaciones de calidad:** Resultados de cada validación ejecutada

### Parametría

- **Servidor definitivos:** `10.1.3.101\SCC` (configurable)
- **Base definitivos:** `DWH_CC` (configurable)
- **Tabla definitivos:** `definitivos_credito` (configurable)
- **Umbral de advertencia obligaciones sin match:** 5% (configurable)
- **Umbral crítico obligaciones sin match:** 10% (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-11:** Tablas cargadas en SQL

### Historias de Usuario Posteriores
- **HU-13:** Recolección de tasas/plazos - Requiere Tipo_Id y Numero_Id
- **HU-14:** Cálculo pérdida/ganancia - Requiere todos los campos completos
- **HU-15:** Query variables valuativo - Requiere datos validados

### Recursos Externos
- **Tabla definitivos_credito:** Debe estar actualizada con información reciente
- **Conectividad entre servidores:** Link server configurado entre RIESGOS y SCC

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 3 horas |
| Desarrollo SQL Scripts | 3 horas |
| Pruebas unitarias | 1 hora |
| Pruebas integradas | 1 hora |
| **Total** | **8 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **Linked Server:** Los UPDATE requieren que exista un Linked Server configurado entre 10.1.5.172\RIESGOS y 10.1.3.101\SCC.

- **Performance:** Los LEFT JOIN entre servidores pueden ser lentos. Considerar traer datos de definitivos a tabla temporal local primero.

- **Índices:** Asegurar que definitivos_credito tiene índice en columna obligacion para mejorar performance de JOIN.

### Consideraciones de Negocio

- **Calidad de datos crítica:** Esta HU es fundamental para garantizar la calidad de los cálculos posteriores. Datos incompletos o incorrectos impactarían los resultados de pérdida/ganancia.

- **Tabla definitivos como fuente de verdad:** La tabla definitivos_credito es la fuente maestra de información de clientes y créditos.

### Riesgos Identificados

- **Riesgo 1: Tabla definitivos desactualizada**
  - Impacto: Alto - Obligaciones recientes no se encuentran
  - Mitigación: Validar fecha de última actualización de definitivos. Coordinar con área de datos si está desactualizada.

- **Riesgo 2: Linked Server no configurado**
  - Impacto: Alto - No se pueden ejecutar queries entre servidores
  - Mitigación: Validar configuración al inicio. Tener procedimiento documentado para configurar Linked Server.

- **Riesgo 3: Performance degradado**
  - Impacto: Medio - Proceso toma demasiado tiempo
  - Mitigación: Usar tablas temporales locales. Ejecutar UPDATE en lotes si es necesario.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 11/11/2025
