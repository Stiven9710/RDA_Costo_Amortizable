# Historia de Usuario

## Datos de Identificación

| Campo | Detalle |
|-------|---------|
| **Nombre Proceso** | Consulta fuentes externas |
| **No. Historia** | 14 |
| **Nombre Historia** | Generar reporte de gestiones |
| **No. Versión** | 1 |
| **Fecha Creación** | 13/12/2021 13:00 |
| **Fecha Modificación** | 13/12/2021 |

---

## Declaración

**Yo como:** Analista

**Quiero:** Generar un reporte de gestiones realizadas por parte del Asistente Bot durante la ejecución del proceso

**De forma que:** Logre realizar trazabilidad de las gestiones realizadas

---

## Criterios de Aceptación

### Insumos

1. Estructura reporte de gestiones: `[Consulta fuentes externas] Reporte de gestión`
2. Parámetros de ejecución

### Entradas de las Funcionalidades

Información guardada en la ejecución del Asistente Bot.

### Funcionalidades

1. Generar reporte de las gestiones realizadas por el Asistente Bot una vez finalice su ejecución.
   
   > **Nota:** El formato del reporte debe ser Microsoft Excel (.xlsx).

2. Nombrar el reporte con la siguiente estructura: `Reporte Gestiones - Conversión de pólizas - ddmmaaaa`

3. El reporte debe permitir parametrizar:
   - Frecuencia
   - Tiempo histórico
   - Hora en la que se desea consultar

### Puntos de Control Crítico

No aplica.

### Puntos de Control No Crítico

No aplica.

### Salidas

Reporte `Reporte Gestiones - Conversión de pólizas - ddmmaaaa` de las gestiones realizadas por el Asistente Bot.

### Reportería

No aplica.

### Parametría

- Correos electrónicos de notificaciones
- Periodicidad de generación de reportes

---

**Documento:** FNC-FNC-FT-03 Versión 3 | **Fecha:** 08/10/2021