# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Costo Amortizable |
| **No. Historia** | 06 |
| **Nombre Historia** | Consolidar Modificados Totales desde SQL a Excel |
| **No. Versión** | 1 |
| **Fecha Creación** | 10/11/2025 15:45 |
| **Fecha Modificación** | 10/11/2025 |

---

## Declaración

**Yo como:** Ejecutor del proceso de Costo Amortizable

**Quiero:** Ejecutar el query "4-Modificados Totales" en SQL y copiar los resultados a la pestaña correspondiente del archivo Excel

**De forma que:** Tenga el detalle completo de todos los modificados para posterior organización y sea la última extracción desde las tablas temporales SQL

---

## Criterios de Aceptación

### Insumos

1. **Tablas temporales SQL activas:** `#Base` y `#Base2` (última vez que se usan)
2. **Archivo Excel abierto:** Con pestañas HU-03, HU-04, HU-05 completadas
3. **Script SQL:** Sección "4-Modificados Totales"
4. **Conexión SQL:** Servidor `10.1.3.101\SCC`

### Entradas de las Funcionalidades

- Tablas temporales con detalle de modificaciones
- Excel con 3 pestañas ya pobladas
- Query de extracción de modificados totales

### Funcionalidades

1. **Verificar recursos activos**
   
   - Validar instancia Excel activa
   - Validar sesión SQL activa
   - Última validación de tablas temporales antes de cerrar sesión

2. **Ejecutar query "4-Modificados Totales"**
   
   - Seleccionar sección "4-Modificados Totales" del script
   - Ejecutar sentencia SELECT
   - El query extrae:
     - Todas las obligaciones modificadas (detalle completo)
     - Número de obligación
     - Indicador de posición (columna C con valor 1 para individuales)
     - Fecha de modificación
     - Tipo de modificación
     - Montos y tasas

3. **Copiar resultados del query**
   
   - Seleccionar todos los registros
   - Copiar conjunto completo
   - Registrar cantidad (típicamente menor volumen que reestructurados)

4. **Activar pestaña "4. Modificados totales"**
   
   - Cambiar a la pestaña en Excel
   - Verificar existencia y limpieza
   - Confirmar estructura de encabezados

5. **Pegar resultados en Excel**
   
   - Posicionar cursor en celda A2
   - Pegar datos de SQL
   - Mantener formatos apropiados
   - Verificar que columna C (indicador) se pegó correctamente

6. **Validar integridad del pegado**
   
   - Contar filas pegadas
   - Comparar con registros SQL
   - Verificar columna C contiene valores numéricos (usualmente "1")
   - Validar que no hay NULLs en columnas críticas

7. **Guardar y cerrar Excel**
   
   - Guardar todos los cambios realizados
   - Cerrar la instancia de Excel (ya no se necesita abierto)
   - Liberar recursos

8. **Cerrar sesión SQL**
   
   - Las tablas temporales ya no se necesitan
   - Cerrar la conexión SQL abierta desde HU-01
   - Liberar recursos del servidor
   - Registrar cierre de sesión en log

9. **Registrar estadísticas finales**
   
   - Registros de esta HU
   - Total de registros consolidados (HU-03 + HU-04 + HU-05 + HU-06)
   - Tiempo total desde HU-01 hasta HU-06
   - Confirmación de sesiones cerradas

### Puntos de Control Crítico

1. **Validación SQL:** Última oportunidad de usar tablas temporales. Si fallan, re-ejecutar desde HU-01.

2. **Validación de columna C:** Debe contener indicadores (1 para individuales). Es crítica para HU-09.

3. **Validación de integridad:** Registros SQL = Filas Excel.

4. **Validación de cierre:** Confirmar que Excel y SQL se cerraron correctamente.

### Puntos de Control No Crítico

1. **Sin modificados:** Si el query retorna 0 registros (mes sin modificaciones), registrar advertencia y continuar.

2. **Advertencia de volumen:** Si registros > 5,000, registrar (normal en algunos meses).

### Salidas

1. **Pestaña Excel poblada:** "4. Modificados totales" con detalle de modificados
2. **Archivo cerrado y guardado:** `01. información Consolidada MM_AAAA.xlsx` con 4 pestañas pobladas
3. **Sesión SQL cerrada:** Tablas temporales eliminadas, recursos liberados
4. **Log:** `logs/ejecuciones/HU06_Consolidar_Modificados_Totales_AAAAMMDD_HHMMSS.log`
5. **Log consolidado Sprint 1 Fase 1:** Resumen de HU-01 a HU-06

### Reportería

Log que incluye:
- Registros de modificados totales
- Resumen acumulado de las 4 pestañas pobladas
- Tiempo total de procesamiento SQL (HU-01 a HU-06)
- Confirmación de cierre de sesiones

### Parametría

- **Nombre pestaña:** `4. Modificados totales` (configurable)
- **Celda inicial:** `A2` (configurable)
- **Timeout query:** 5 minutos (configurable)
- **Cerrar Excel:** `Sí` (configurable)
- **Cerrar SQL:** `Sí` (configurable)

---

## Dependencias

### Historias de Usuario Previas
- **HU-01:** Tablas temporales (última vez usadas)
- **HU-02:** Archivo preparado
- **HU-03 a HU-05:** Pestañas previas completadas

### Historias de Usuario Posteriores
- **HU-07:** Consolidar Retenidos - Usará archivo Excel cerrado (reabrirá)
- **HU-09:** Organizar Modificados - Usará los datos de esta pestaña

---

## Estimación

| Concepto | Tiempo Estimado |
|----------|-----------------|
| Desarrollo PAD | 2 horas |
| Desarrollo Python (opcional) | 0.5 horas |
| Pruebas unitarias | 0.5 horas |
| Pruebas integradas | 1 hora |
| **Total** | **4 horas** |

---

## Notas Adicionales

### Consideraciones Técnicas

- **Última HU con tablas temporales:** Esta es la última historia que usa las tablas `#Base` y `#Base2`. Después de completar HU-06, estas tablas se eliminan automáticamente al cerrar la sesión SQL.

- **Cierre ordenado:** Es importante cerrar Excel y SQL de forma ordenada para liberar recursos y evitar locks de archivo.

- **Punto de checkpoint:** Al finalizar HU-06, se tiene un checkpoint importante: archivo Excel con 4 pestañas de datos SQL completadas. Si hay error en HU-07 en adelante, se puede reiniciar desde aquí sin re-ejecutar queries SQL.

### Consideraciones de Negocio

- **Finalización Fase SQL:** Con esta HU se completa la fase de extracción de datos desde SQL. HU-07 en adelante trabaja con archivos externos y transformaciones en Excel.

- **Variabilidad de modificados:** Los modificados son menos frecuentes que reestructurados, por lo que el volumen suele ser menor.

### Riesgos Identificados

- **Riesgo 1: Excel no se cierra correctamente**
  - Impacto: Bajo - Archivo puede quedar bloqueado
  - Mitigación: Usar bloque Finally en PAD para garantizar cierre. Validar que el archivo no tiene lock antes de continuar.

- **Riesgo 2: Sesión SQL no se cierra**
  - Impacto: Bajo - Recursos del servidor no liberados
  - Mitigación: Usar bloque Finally para cerrar conexión. Monitorear conexiones activas en servidor.

- **Riesgo 3: Datos incompletos al cerrar**
  - Impacto: Alto - Si se cierra Excel/SQL antes de completar, pérdida de datos
  - Mitigación: Validar que todas las pestañas tienen datos antes de cerrar. Implementar guardado incremental.

---

**Documento:** Historia de Usuario - Proceso RDA Costo Amortizable | **Versión:** 1 | **Fecha:** 10/11/2025
