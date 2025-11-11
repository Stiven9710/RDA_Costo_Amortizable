# Plantilla de Reportes - Costo Amortizable

## Información General
**Proceso:** RDA Costo Amortizable  
**Fecha de Corte:** [DD/MM/AAAA]  
**Responsable:** [Nombre del ejecutor]  
**Herramienta:** [Power Automate Desktop / n8n / Manual]

---

## 1. Reporte de Reestructurados

### Estructura del Archivo
**Nombre:** `Reestructurados_[YYYYMM].xlsx`  
**Ubicación:** `data/output/reportes/`

### Columnas Requeridas
| Columna | Tipo | Descripción | Validación |
|---------|------|-------------|------------|
| obligacion | VARCHAR(50) | Número de obligación | NOT NULL, UNIQUE |
| tipo_credito | VARCHAR(50) | Tipo de crédito | IN ('CONSUMO', 'VIVIENDA', 'COMERCIAL') |
| saldo_capital | DECIMAL(18,2) | Saldo de capital | > 0 |
| tasa_interes_original | DECIMAL(5,4) | Tasa de interés original | 0-0.50 |
| tasa_interes_nueva | DECIMAL(5,4) | Tasa de interés reestructurada | 0-0.50 |
| plazo_original | INT | Plazo original en meses | > 0 |
| plazo_nuevo | INT | Plazo reestructurado en meses | > 0 |
| fecha_reestructura | DATE | Fecha de reestructuración | <= Fecha actual |
| valor_presente_original | DECIMAL(18,2) | VP flujos originales | Calculado |
| valor_presente_nuevo | DECIMAL(18,2) | VP flujos reestructurados | Calculado |
| perdida_ganancia | DECIMAL(18,2) | Diferencia VP | VP_original - VP_nuevo |
| valor_valuativo | DECIMAL(18,2) | Valor para amortización | Según fórmula |

### Formato Visual
- **Encabezados:** Negrita, fondo azul (#4472C4), texto blanco
- **Datos:** Bordes completos, fuente Calibri 11
- **Números:** Formato moneda colombiana ($#,##0.00)
- **Fechas:** Formato DD/MM/AAAA
- **Primera fila:** Congelada
- **Filtros:** Activados en todas las columnas

### Fórmulas de Cálculo

#### Valor Presente Original
```
VP_original = Σ[t=1 hasta plazo_original] (Cuota / (1 + tasa_original)^t)
```

#### Valor Presente Reestructurado
```
VP_nuevo = Σ[t=1 hasta plazo_nuevo] (Cuota_nueva / (1 + tasa_nueva)^t)
```

#### Pérdida/Ganancia
```
Perdida_Ganancia = VP_original - VP_nuevo
```

#### Valor Valuativo
```
Valor_Valuativo = Perdida_Ganancia * Factor_Amortizacion(plazo_remanente)
```

---

## 2. Reporte de Modificados

### Estructura del Archivo
**Nombre:** `Modificados_[YYYYMM].xlsx`  
**Ubicación:** `data/output/reportes/`

### Columnas Requeridas
(Similar a Reestructurados con las siguientes diferencias)

| Columna | Tipo | Descripción |
|---------|------|-------------|
| tipo_modificacion | VARCHAR(50) | Tipo de modificación |
| motivo_modificacion | VARCHAR(255) | Motivo de la modificación |
| aprobado_por | VARCHAR(100) | Funcionario que aprobó |

### Tipos de Modificación Válidos
- PLAZO_EXTENDIDO
- TASA_REDUCIDA
- CUOTA_REDUCIDA
- PERIODO_GRACIA
- OTRO

---

## 3. Reporte de Retenidos Vivienda

### Estructura del Archivo
**Nombre:** `Retenidos_Vivienda_[YYYYMM].xlsx`  
**Ubicación:** `data/output/reportes/`

### Columnas Específicas
| Columna | Tipo | Descripción |
|---------|------|-------------|
| avaluo_inmueble | DECIMAL(18,2) | Avalúo del inmueble |
| porcentaje_retencion | DECIMAL(5,4) | % de retención aplicado |
| valor_retenido | DECIMAL(18,2) | Valor monetario retenido |
| estado_inmueble | VARCHAR(50) | Estado del inmueble |

---

## 4. Reporte Resumen Ejecutivo

### Estructura del Archivo
**Nombre:** `Resumen_Ejecutivo_[YYYYMM].xlsx`  
**Ubicación:** `data/output/reportes/`

### Hoja 1: Resumen por Categoría
```
┌─────────────────────────────────────────────────────────┐
│  RESUMEN COSTO AMORTIZABLE - [MES/AÑO]                 │
├─────────────────────┬────────────┬──────────────────────┤
│ Categoría           │ Cantidad   │ Valor Total          │
├─────────────────────┼────────────┼──────────────────────┤
│ Reestructurados     │ [####]     │ $##,###,###,###.##  │
│ Modificados         │ [####]     │ $##,###,###,###.##  │
│ Retenidos Vivienda  │ [####]     │ $##,###,###,###.##  │
├─────────────────────┼────────────┼──────────────────────┤
│ TOTAL               │ [####]     │ $##,###,###,###.##  │
└─────────────────────┴────────────┴──────────────────────┘
```

### Hoja 2: Pérdida/Ganancia Consolidada
```
┌─────────────────────────────────────────────────────────┐
│  IMPACTO FINANCIERO                                      │
├─────────────────────┬──────────────────────────────────┤
│ Concepto            │ Valor                             │
├─────────────────────┼──────────────────────────────────┤
│ Pérdida Total       │ ($##,###,###,###.##)             │
│ Ganancia Total      │ $##,###,###,###.##               │
│ Neto P&G            │ $##,###,###,###.##               │
│ Valor Valuativo     │ $##,###,###,###.##               │
└─────────────────────┴──────────────────────────────────┘
```

### Hoja 3: Gráficos
- **Gráfico de barras:** Cantidad por categoría
- **Gráfico circular:** Distribución porcentual
- **Gráfico de tendencia:** Evolución mensual (últimos 6 meses)

---

## 5. Validaciones Pre-Generación

### Checklist de Validación
- [ ] Fecha de corte válida (último día del mes anterior)
- [ ] No hay duplicados por número de obligación
- [ ] Todos los campos obligatorios completos
- [ ] Saldos positivos
- [ ] Tasas dentro del rango válido (0-50%)
- [ ] Fechas de reestructura no futuras
- [ ] Cálculos de VP correctos
- [ ] Suma de pérdida/ganancia cuadra

### Errores Comunes a Verificar
| Error | Descripción | Acción Correctiva |
|-------|-------------|-------------------|
| DIV/0! | División por cero en cálculos | Validar plazo > 0 |
| #VALUE! | Tipo de dato incorrecto | Convertir a numérico |
| #REF! | Referencia inválida | Revisar fórmulas |
| NULL | Valor nulo en campo obligatorio | Completar información |

---

## 6. Metadata del Reporte

### Información a Incluir en Cada Archivo
```yaml
# Hoja: _Metadata (oculta)
Fecha_Generacion: [YYYY-MM-DD HH:MM:SS]
Usuario_Generador: [usuario@dominio.com]
Herramienta: [Power Automate Desktop v2.x / n8n v1.x]
Servidor_Origen: [10.1.3.101\SCC o 10.1.5.172\RIESGOS]
Query_Utilizado: [01_Consulta_DWH_Reestructurados_Modificados.sql]
Total_Registros: [####]
Tiempo_Ejecucion: [##] minutos
Hash_Verificacion: [MD5/SHA256]
```

---

## 7. Nomenclatura de Archivos

### Patrón de Nombres
```
[TipoReporte]_[YYYYMM]_v[##].xlsx

Ejemplos:
- Reestructurados_202411_v01.xlsx
- Modificados_202411_v01.xlsx
- Retenidos_Vivienda_202411_v01.xlsx
- Resumen_Ejecutivo_202411_v01.xlsx
```

### Control de Versiones
- v01: Primera generación del mes
- v02: Corrección o regeneración
- v03+: Versiones adicionales si se requieren ajustes

---

## 8. Distribución de Reportes

### Destinatarios por Reporte
| Reporte | Destinatario Principal | Copia |
|---------|------------------------|-------|
| Reestructurados | ccamposg@fgs.co | Gerencia Portafolio |
| Modificados | ccamposg@fgs.co | Coordinación Portafolio |
| Retenidos Vivienda | ccamposg@fgs.co | Área Vivienda |
| Resumen Ejecutivo | Gerencia General | Todas las áreas |

### Formato de Correo
```
Asunto: [Completado] RDA Costo Amortizable - [MES/AÑO]

Buen día,

Adjunto los reportes de Costo Amortizable correspondientes a [MES/AÑO]:

✓ Reestructurados: ### obligaciones
✓ Modificados: ### obligaciones
✓ Retenidos Vivienda: ### obligaciones
✓ Resumen Ejecutivo

Total procesado: #### obligaciones
Impacto Neto: $##,###,###,###.##

Datos cargados en base ANDREAL.Costo_Amortizado_[YYYYMM]

Saludos,
[Bot RDA Costo Amortizable / Usuario]
```

---

## 9. Ubicación de Archivos

### Estructura de Carpetas
```
data/
├── input/
│   └── plantillas/
│       ├── Calculo_Perdida_Ganancia.xlsm
│       └── Calculo_Valor_Valuativo.xlsm
│
└── output/
    ├── reportes/
    │   ├── Reestructurados_[YYYYMM].xlsx
    │   ├── Modificados_[YYYYMM].xlsx
    │   ├── Retenidos_Vivienda_[YYYYMM].xlsx
    │   └── Resumen_Ejecutivo_[YYYYMM].xlsx
    │
    └── logs/
        └── Generacion_[YYYYMMDD_HHMMSS].log
```

---

## 10. Respaldo y Retención

### Política de Respaldo
- **Frecuencia:** Diaria
- **Ubicación:** Red corporativa + SharePoint
- **Retención:** 24 meses
- **Compresión:** ZIP con password

### Eliminación de Archivos Temporales
```bash
# Limpiar archivos temporales después de 7 días
find data/temp/ -type f -mtime +7 -delete
```

---

**Versión:** 1.0  
**Fecha de Creación:** 10/11/2025  
**Última Actualización:** 10/11/2025  
**Próxima Revisión:** Trimestral
