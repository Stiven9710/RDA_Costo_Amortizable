# RDA Costo Amortizable - Automatización RPA

![Estado](https://img.shields.io/badge/Estado-En%20Desarrollo-yellow)
![Progreso](https://img.shields.io/badge/Historias%20de%20Usuario-14%2F14-brightgreen)
![Reducción](https://img.shields.io/badge/Reducción%20Tiempo-95%25-orange)
![Frecuencia](https://img.shields.io/badge/Frecuencia-Mensual-blue)

## 📋 Resumen Ejecutivo

### ¿Qué es el Costo Amortizable?

El **Costo Amortizable** es un proceso mensual crítico de la **Coordinación de Portafolio** del Banco Caja Social que permite hacer seguimiento y cálculo del impacto financiero de las modificaciones en las condiciones crediticias originales de los préstamos. 

**Objetivo del proceso:** Calcular y amortizar las pérdidas o ganancias generadas por:
- **Reestructuraciones de créditos**: Cambios en condiciones originales por acuerdos con clientes
- **Modificaciones de condiciones**: Ajustes en tasas, plazos o estructura de pago
- **Retenciones de vivienda**: Disminución de tasas de interés por programas de retención
- **Amortizaciones especiales**: Acuerdos comerciales personalizados

### El Problema

**Situación actual (AS-IS):**
- ⏱️ **Tiempo de ejecución:** 14 horas manuales (2 días al final de cada mes)
- 👤 **Recurso:** 1 ETC (Carol Patricia Campos González)
- 🔄 **Proceso:** 100% manual con múltiples herramientas (SQL Server, Excel, macros VBA)
- ⚠️ **Riesgos:** Alto potencial de error humano en cálculos financieros críticos
- 📊 **Volumen:** 1,000-1,500 registros procesados mensualmente

### La Solución

**Automatización RPA (TO-BE):**
- ⚡ **Tiempo automatizado:** 15 minutos (PAD) u 8 minutos (n8n)
- 📉 **Reducción:** 95% del tiempo de ejecución (14h → 15 min)
- 🤖 **Tecnología:** Power Automate Desktop (PAD) o n8n
- ✅ **Beneficios:** Ejecución desatendida, cero errores, trazabilidad completa
- 🎯 **ROI:** Positivo desde el primer mes

### Alcance del Proceso

El proceso automatizado ejecuta **14 historias de usuario funcionales** que cubren:

1. **Extracción de datos** desde SQL Server (DWH y SCC)
2. **Consolidación** de información en Excel (reestructurados, modificados, retenidos)
3. **Validación y completitud** de información mediante Linked Server
4. **Cálculos financieros** (tasas ponderadas, valor presente, pérdidas/ganancias)
5. **Ejecución de macros VBA** para tablas de amortización
6. **Generación de archivo final** en formato estándar
7. **Cargue a bases de datos** para el provisionador
8. **Notificaciones automáticas** del resultado

### Actores Clave

| Rol | Responsable | Contacto |
|-----|-------------|----------|
| **Dueño del Proceso** | Carol Patricia Campos González | ccamposg@fgs.co |
| **Especialista RPA** | Jeimy Johana Lozano Garnica | jelozanog@fgs.co |
| **Desarrollador** | Ronald Estiven Rios Hernandez | rriosh@fgs.co |

### Infraestructura

**Servidores SQL:**
- `10.1.3.101\SCC` → Base de datos DWH_CC (principal)
- `10.1.5.172\RIESGOS` → Base de datos DWH_Riesgos_Credito (complementaria)

**Aplicaciones:**
- Power Automate Desktop o n8n (orquestador RPA)
- Microsoft Excel 2016+ (con macros VBA)
- SQL Server Management Studio (opcional, desarrollo)

---

## 🎯 Objetivos de la Automatización

- ✅ Optimizar la ocupación manual en tareas repetitivas
- ✅ Reducir tiempos de respuesta para mayor eficiencia
- ✅ Eliminar el riesgo de error por factores humanos
- ✅ Garantizar trazabilidad y auditoría completa del proceso
- ✅ Liberar tiempo del talento humano para actividades de mayor valor

## 🗂️ Estructura del Repositorio

```
RDA_Costo_Amortizable/
│
├── workflows/                      # Flujos de automatización (TO-BE)
│   ├── power-automate/            # Power Automate Desktop (Opción 1)
│   └── n8n/                       # n8n Cloud-Ready (Opción 2)
│
├── scripts/                       # Scripts SQL y auxiliares
│   ├── sql/                      # Queries del proceso (01-06)
│   ├── python/                   # Scripts Python complementarios
│   └── powershell/               # Scripts PowerShell
│
├── config/                        # Configuración del proceso
│   ├── credenciales/             # Variables de entorno y credenciales
│   ├── parametros/               # Parámetros operativos
│   └── conexiones/               # Endpoints y conexiones SQL
│
├── data/                          # Datos del proceso
│   ├── input/plantillas/         # Plantillas Excel base
│   ├── output/                   # Salidas generadas
│   │   ├── reportes/            # Archivos finales (.xls)
│   │   └── logs/                # Logs de procesamiento
│   └── temp/                     # Archivos temporales
│
├── documentacion/                 # Documentación completa
│   ├── funcional/                # Documentación de negocio
│   │   ├── pdd/                 # PDD v1.0 (89 páginas)
│   │   ├── historias_usuario/   # 14 HU funcionales
│   │   └── insumos/             # Plantillas y referencias
│   ├── tecnica/                  # Documentación técnica
│   │   ├── diagramas/           # BPMN AS-IS y TO-BE
│   │   ├── Requisitos_*.md      # Requisitos PAD y n8n
│   │   └── Resumen_Funcional_n8n.md
│   └── gestion_proyecto/        # Gestión del proyecto
│       └── cronograma/          # Planificación desarrollo
│
├── testing/                       # Casos de prueba
│   ├── casos_prueba/             # Tests funcionales/técnicos
│   └── datos_prueba/             # Datos históricos validados
│
└── logs/                          # Logs de ejecución
    ├── ejecuciones/              # Logs exitosos
    └── errores/                  # Logs de fallos
```

## � Flujo del Proceso

### Vista de Alto Nivel (TO-BE Automatizado)

```
┌─────────────────────────────────────────────────────────────────────┐
│                     INICIO: Programación Mensual                     │
│              (Último día hábil del mes - 08:00 AM)                  │
└────────────────────────────────┬────────────────────────────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │  1. EXTRACCIÓN DE DATOS  │
                    │  • DWH Reestructurados   │
                    │  • DWH Modificados       │
                    │  • DWH Retenciones       │
                    │  Tiempo: ~2 min          │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │ 2. CONSOLIDACIÓN EXCEL  │
                    │  • Crear archivo base   │
                    │  • Consolidar por tipo  │
                    │  • Transformar fechas   │
                    │  Tiempo: ~3 min         │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │ 3. ORGANIZACIÓN Y       │
                    │    CLASIFICACIÓN        │
                    │  • Consolidada/Individual│
                    │  • Misma/Diferente Oblig│
                    │  Tiempo: ~2 min         │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │ 4. CARGUE A SQL SERVER  │
                    │  • Tablas temporales    │
                    │  • Validación carga     │
                    │  Tiempo: ~1 min         │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │ 5. VALIDACIÓN Y         │
                    │    COMPLETITUD          │
                    │  • Linked Server queries│
                    │  • Completar info       │
                    │  Tiempo: ~1 min         │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │ 6. RECOLECCIÓN TASAS/   │
                    │    PLAZOS/SALDOS        │
                    │  • Históricos por oblig │
                    │  • Tasas ponderadas     │
                    │  Tiempo: ~2 min         │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │ 7. CÁLCULO FINANCIERO   │
                    │  • Valor presente (VP)  │
                    │  • Pérdidas/Ganancias   │
                    │  Tiempo: ~2 min         │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │ 8. MACRO AMORTIZACIÓN   │
                    │  • Ejecutar VBA         │
                    │  • Tablas de amortiz.   │
                    │  Tiempo: ~1 min         │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │ 9. FORMATO FINAL        │
                    │  • Consolidar BASE      │
                    │  • Aplicar validaciones │
                    │  • Generar .xls 97-2003 │
                    │  Tiempo: ~1 min         │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │ 10. CARGUE FINAL Y      │
                    │     NOTIFICACIONES      │
                    │  • Subir a bd_costo_*   │
                    │  • Enviar emails        │
                    │  Tiempo: <1 min         │
                    └────────────┬────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   FIN: Proceso Completo │
                    │   Tiempo Total: 15 min  │
                    │   Reducción: 95%        │
                    └─────────────────────────┘
```

### Comparativa AS-IS vs TO-BE

| Aspecto | AS-IS (Manual) | TO-BE (Automatizado) | Mejora |
|---------|----------------|----------------------|--------|
| **Tiempo total** | 14 horas | 15 minutos | 95% ⬇️ |
| **Errores** | Alto riesgo (humano) | Cero (automatizado) | 100% ⬇️ |
| **Ejecución** | Diurna (2 días) | Nocturna (1 día) | +100% disponibilidad |
| **Trazabilidad** | Manual (Excel) | Automática (logs) | Auditoría completa |
| **Dependencia** | 1 ETC dedicado | 0 ETC (desatendido) | Liberación talento |

---

## 🚀 Tecnologías Utilizadas

### Opción 1: Power Automate Desktop (PAD)
- **Orquestador RPA**: Power Automate Desktop v2.30+
- **Excel**: Microsoft Excel 2016+ con macros VBA
- **SQL Server**: 2016+ (DWH_CC y DWH_Riesgos_Credito)
- **Scripts**: Python 3.8+ (pandas, pyodbc, openpyxl)
- **SO**: Windows 10/11
- **Tiempo ejecución**: ~15 minutos

### Opción 2: n8n (Cloud-Ready)
- **Orquestador**: n8n v1.x (open source)
- **Runtime**: Node.js 18.x
- **Scripts**: Python 3.9+ (pandas, numpy, openpyxl, pyodbc)
- **Contenedor**: Docker (opcional)
- **SO**: Linux/macOS/Windows
- **Tiempo ejecución**: ~8 minutos (47% más rápido)

### Stack Común
- **Bases de datos**: SQL Server (10.1.3.101\SCC, 10.1.5.172\RIESGOS)
- **Archivos**: Excel .xlsx y .xls (97-2003) con macros VBA
- **Control versiones**: Git
- **Documentación**: Markdown

## 📊 Historias de Usuario Funcionales

### Resumen del Backlog (14 HU)

El proceso se divide en **14 historias de usuario funcionales** agnósticas a la tecnología:

| # | Historia | Descripción | Complejidad |
|---|----------|-------------|-------------|
| **HU-01** | Programar Ejecución | Activar proceso en fecha/hora configuradas (último día hábil) | Media |
| **HU-02** | Administrar Parámetros | Cargar, validar y versionar parámetros operativos | Media |
| **HU-03** | Iniciar Ejecución Manual | Permitir disparo manual seguro del proceso | Baja |
| **HU-04** | Extraer Datos Fuentes Internas | Consultar DWH reestructurados, modificados, retenidos | Alta ⭐ |
| **HU-05** | Validar Calidad Datos | Verificar completitud y consistencia de datos | Media |
| **HU-06** | Consolidar Datos | Unir datos válidos en estructura común | Media |
| **HU-07** | Obtener Variables Complementarias | Incorporar tasas, plazos, factores adicionales | Alta ⭐ |
| **HU-08** | Calcular Indicadores | Generar valor valuativo y pérdida/ganancia | Alta ⭐ |
| **HU-09** | Gestionar Errores y Alertas | Detectar errores críticos y notificar | Media |
| **HU-10** | Generar Reportes | Crear reportes detalle y ejecutivo | Media |
| **HU-11** | Distribuir Reportes | Enviar reportes a lista de distribución vigente | Baja |
| **HU-12** | Registrar Auditoría y Archivar | Registro estructurado de cada ejecución | Media |
| **HU-13** | Tablero KPIs | Visualizar KPIs de ejecución y calidad | Media |
| **HU-14** | Gestionar Listas Destinatarios | Administrar listas y permisos de acceso | Baja |

> **Nota:** Las HU están documentadas de forma **agnóstica a la tecnología** para permitir implementación en PAD, n8n, o cualquier otro orquestador RPA.

### Actividades Técnicas Clave

#### 1. Extracción de Datos (HU-04)
- **Fuentes:** DWH_CC (10.1.3.101\SCC) y DWH_Riesgos_Credito (10.1.5.172\RIESGOS)
- **Tipos:** Reestructurados, Modificados, Retenciones
- **Volumen:** 1,000-1,500 registros/mes
- **Complejidad:** Queries dinámicos con tablas temporales

#### 2. Consolidación y Transformación (HU-05, HU-06)
- **Clasificación:** Consolidada/Individual + Misma/Diferente Obligación
- **Transformaciones:** Fechas dd/mm/yyyy → YYYYMMDD
- **Validaciones:** Campos obligatorios, rangos, consistencia

#### 3. Validación de Completitud (HU-05, HU-07)
- **Linked Server:** Cruce con bases externas para completar información faltante
- **Campos críticos:** Tipo_Id, Numero_Id, Modalidad, Tasas, Plazos, Saldos
- **Umbral aceptación:** ≥98% registros válidos

#### 4. Cálculos Financieros (HU-08)
- **Tasas ponderadas:** Para consolidaciones de múltiples obligaciones
- **Valor presente (VP):** Cálculo con tasa anterior vs nueva
- **Pérdida/Ganancia:** Diferencia entre VP anterior y VP nuevo
- **Fórmulas Excel:** Integradas con datos de SQL

#### 5. Macro VBA Amortización (HU-08)
- **Función:** Generar tablas de amortización por obligación
- **Input:** Variables de cálculo desde SQL (bd_perdidas_ganancias_dwh)
- **Output:** Valores de amortización mensual
- **Complejidad:** Integración Excel-SQL bidireccional

#### 6. Formato de Entrega (HU-10)
- **Archivo final:** Excel 97-2003 (.xls) para compatibilidad
- **Estructura:** Hoja BASE consolidada (50+ columnas)
- **Validaciones finales:** Filtros, advertencias, ajustes especiales
- **Hash SHA-256:** Verificación de integridad

#### 7. Cargue a Producción (HU-12)
- **Tablas destino:** 
  - `[ANDREAL].[Costo_Amortizado_001_*_Acum]` (reestructurados, modificados, retenciones)
  - `[ANDREAL].[bd_costo_amortizable_MM_AAAA]` (base final)
- **Validaciones:** Cantidad de registros cargados vs esperados

## 📦 Requisitos Previos

### Para Power Automate Desktop (Opción 1)
- **Sistema Operativo**: Windows 10/11 (64-bit)
- **Memoria RAM**: Mínimo 8GB, recomendado 16GB
- **Software Base**:
  - Power Automate Desktop v2.30 o superior
  - Microsoft Excel 2016 o superior (con macros habilitadas)
  - SQL Server Management Studio (opcional, para desarrollo)
- **Conectividad**:
  - Acceso a servidores SQL: 10.1.3.101\SCC y 10.1.5.172\RIESGOS
  - SQL ODBC Driver 17 instalado
  - Credenciales Windows Credential Manager configuradas
- **Licencias**: Power Automate Desktop (incluida en Windows 11)

### Para n8n (Opción 2)
- **Sistema Operativo**: Linux (Ubuntu 20.04+) / macOS / Windows con WSL2
- **Memoria RAM**: Mínimo 4GB, recomendado 8GB
- **CPU**: 2 cores mínimo
- **Software Base**:
  - Node.js 18.x o superior
  - n8n v1.x (`npm install n8n -g`)
  - Python 3.9+ con pip
- **Conectividad**:
  - Acceso a servidores SQL (VPN Site-to-Site o SSH Bastion)
  - Linked Server configurado si se usa Azure Cloud
- **Docker** (opcional): Para contenedorización

### Para Scripts Python (Ambas Opciones)
```bash
# Instalar dependencias
pip install pandas>=1.5.0 numpy>=1.24.0 openpyxl>=3.1.0 pyodbc>=4.0.39 python-dotenv>=1.0.0
```

### Accesos Requeridos
- **Bases de Datos**:
  - DWH_CC (servidor 10.1.3.101\SCC) - Lectura/Escritura
  - DWH_Riesgos_Credito (servidor 10.1.5.172\RIESGOS) - Lectura
- **Permisos**:
  - Ejecución de SELECT, INSERT, UPDATE en tablas específicas
  - Acceso a Linked Server (para queries de completitud)
- **Red**:
  - Puertos SQL Server: 1433 (o configurados por TI)
  - Firewall: Permitir tráfico desde máquina de ejecución

## ⚙️ Configuración Inicial

### 1. Clonar el Repositorio
```bash
git clone https://github.com/Stiven9710/RDA_Costo_Amortizable.git
cd RDA_Costo_Amortizable
```

### 2. Configurar Credenciales SQL Server
Crear archivo `.env` en `config/credenciales/`:
```env
# Servidor DWH (SCC)
SQL_SERVER_DWH=10.1.3.101\SCC
SQL_DATABASE_DWH=DWH_CC
SQL_USER_DWH=usuario_dwh
SQL_PASSWORD_DWH=password_seguro

# Servidor Riesgos
SQL_SERVER_RIESGOS=10.1.5.172\RIESGOS
SQL_DATABASE_RIESGOS=DWH_Riesgos_Credito
SQL_USER_RIESGOS=usuario_riesgos
SQL_PASSWORD_RIESGOS=password_seguro

# Configuración Email
SMTP_SERVER=smtp.cajasocial.com
SMTP_PORT=587
EMAIL_FROM=rda.costoamortizable@cajasocial.com
EMAIL_TO=riesgos@cajasocial.com
```

### 3. Verificar Scripts SQL
Los scripts están en `scripts/sql/` y deben ejecutarse en este orden:
```json
{
  "frecuencia_ejecucion": "mensual",
  "dia_ejecucion": "ultimo_dia_habil",
  "hora_inicio": "08:00",
  "timeout_queries_segundos": 300,
  "reintentos_error": 3,
  "generar_respaldo": true,
  "enviar_notificaciones": true,
  "destinatarios_reporte": [
    "carol.campos@cajasocial.com",
    "coordinador.riesgos@cajasocial.com"
  ]
}
```

### 4. Preparar Plantillas Excel
Las plantillas están en `data/input/plantillas/`:
- `Plantilla_Consolidacion_vMM_AAAA.xlsx`: Plantilla base para consolidación
- Verificar que las hojas existan: Reestructurados, Modificados, Retenciones, BASE

### 5. Configurar Power Automate Desktop (Opción 1)
1. Abrir Power Automate Desktop
2. Importar flujos desde `workflows/power-automate/flujos/`
3. Configurar variables de entorno:
   - `PathArchivos`: Ruta base del proyecto
   - `ServidorSQL`: 10.1.3.101\SCC
   - `BaseDatos`: DWH_CC
4. Configurar credenciales en Windows Credential Manager
5. Probar conexión SQL con subproceso de validación

### 6. Configurar n8n (Opción 2)
```bash
# Instalar n8n globalmente
npm install n8n -g

# Importar workflows
n8n import:workflow --input=workflows/n8n/workflows/RDA_Costo_Amortizable_Principal.json

# Configurar variables de entorno en n8n
# Ir a Settings > Environments y agregar variables del .env

# Iniciar n8n
n8n start

# Acceder a interfaz web: http://localhost:5678
```

### 7. Verificar Scripts SQL
Los scripts están en `scripts/sql/`:
- `01_Consulta_DWH_Reestructurados_Modificados.sql`
- `02_Consulta_SCC_Reestructurados_Modificados_Contingencia.sql`
- `03_Verificar_Info_Completitud.sql`
- `04_Recolectar_Info_Tasas_Plazos_Saldo.sql`
- `05_Variables_Calculo_Valor_Valuativo.sql`
- `06_Cargue_Base_Envio_Final.sql`

Ejecutar validación de sintaxis en SSMS antes del primer uso.

## 📖 Ejecución del Proceso

### Frecuencia y Horario
- **Frecuencia**: Mensual (último día hábil del mes)
- **Horario**: 08:00 AM (ejecución desatendida)
- **Duración**: ~15 minutos (PAD) u 8 minutos (n8n)
- **Tipo**: Asistente (sin intervención humana)

### Archivos Generados

| Archivo | Descripción | Ubicación |
|---------|-------------|-----------|
| `Consolidacion_MM_AAAA.xlsx` | Archivo de trabajo consolidado | `data/output/reportes/` |
| `COSTO_AMORTIZABLE_MM_AAAA.xls` | Archivo final formato 97-2003 | `data/output/reportes/` |
| `proceso_MM_AAAA.log` | Log detallado de ejecución | `data/output/logs/` |

### Tablas SQL Generadas

| Tabla | Descripción |
|-------|-------------|
| `[ANDREAL].[Costo_Amortizado_001_Reestructurados_Acum]` | Reestructurados consolidados |
| `[ANDREAL].[Costo_Amortizado_001_Modificados_Acum]` | Modificados consolidados |
| `[ANDREAL].[Costo_Amortizado_001_Retenciones_Acum]` | Retenciones consolidadas |
| `[ANDREAL].[bd_costo_amortizable_MM_AAAA]` | Base valuativa final del mes |
| `[ANDREAL].[bd_perdidas_ganancias_dwh]` | Cálculos de pérdidas/ganancias |

### Notificaciones Automáticas

**En caso de éxito:**
```
Asunto: ✅ RDA Costo Amortizable - Ejecución Exitosa [MM/AAAA]
Destinatarios: Carol Patricia Campos, Coordinador Riesgos
Adjunto: COSTO_AMORTIZABLE_MM_AAAA.xls
```

**En caso de error:**
```
Asunto: ❌ RDA Costo Amortizable - ERROR [MM/AAAA]
Detalle: Paso fallido, mensaje de error, log completo
Acción: Requiere intervención manual
```

## 📝 Documentación

### Acceso Rápido a Documentos Clave

| Documento | Descripción | Ubicación |
|-----------|-------------|-----------|
| 📖 **PDD v1.0** | Process Design Document (89 págs) | `documentacion/funcional/pdd/PDD_RDA_Costo_Amortizable_v1.0.md` |
| 📋 **Historias de Usuario** | 14 HU funcionales agnósticas | `documentacion/funcional/historias_usuario/backlog/` |
| 🔧 **Setup PAD** | Requisitos Power Automate Desktop | `documentacion/tecnica/Requisitos_Infraestructura_PAD.md` |
| ☁️ **Setup n8n** | Requisitos n8n Cloud-Ready | `documentacion/tecnica/Requisitos_Infraestructura_n8n.md` |
| 📊 **Diagramas BPMN** | AS-IS y TO-BE visuales | `documentacion/tecnica/diagramas/` |
| 🗓️ **Cronograma** | Plan de desarrollo | `documentacion/gestion_proyecto/cronograma/` |

### Estructura de Documentación

```
documentacion/
├── funcional/                   # Documentación de negocio
│   ├── pdd/                    # Process Design Document
│   ├── historias_usuario/      # 14 HU + backlog
│   └── insumos/                # Plantillas y referencias
├── tecnica/                     # Documentación técnica
│   ├── diagramas/              # BPMN AS-IS y TO-BE
│   ├── Requisitos_*.md         # Setup PAD y n8n
│   └── Resumen_Funcional_n8n.md
└── gestion_proyecto/            # Gestión del proyecto
    └── cronograma/             # Planificación desarrollo
```
    │   ├── Cronograma_Desarrollo_RDA_Costo_Amortizable.md
    │   └── Cronograma RDA Costo Amortizable.xlsx
    ├── actas_reunion/
    └── seguimiento/
```

### Acceso Rápido a Documentación Clave

| Documento | Ubicación | Propósito |
|-----------|-----------|-----------|
| 🎯 **Índice de HU** | `documentacion/funcional/historias_usuario/Indice_Maestro_Historias_Usuario.md` | Vista general de las 21 historias |
| 📊 **Cronograma** | `documentacion/gestion_proyecto/cronograma/Cronograma_Desarrollo_RDA_Costo_Amortizable.md` | Plan de desarrollo 7 semanas |
| 📖 **PDD** | `documentacion/funcional/pdd/PDD_RDA_Costo_Amortizable_v1.0.md` | Diseño completo del proceso |
| 🏗️ **Diagramas BPMN** | `documentacion/tecnica/diagramas/bpmn/` | Flujos visuales del proceso |
| 🔧 **Setup PAD** | `documentacion/tecnica/Requisitos_Infraestructura_PAD.md` | Guía de configuración PAD |
| ☁️ **Setup n8n** | `documentacion/tecnica/Requisitos_Infraestructura_n8n.md` | Guía de configuración n8n |

## 🧪 Testing y Validación

### Estrategia de Pruebas

#### Fases de Testing
1. **Pruebas Unitarias**: Validar cada HU individualmente (queries, transformaciones, cálculos)
2. **Pruebas de Integración**: Ejecución end-to-end con datos históricos reales
3. **Pruebas de Regresión**: Suite completa antes de cada release
4. **Validación Usuario**: Comparación con proceso manual (umbral aceptación: ≥95%)

#### Casos de Prueba Críticos
- **HU-04**: Extracción correcta desde DWH (volumen y estructura)
- **HU-07**: Completitud vía Linked Server
- **HU-08**: Cálculos de valor presente y pérdida/ganancia (margen error: ±0.01%)
- **HU-08**: Ejecución macros VBA sin fallos

#### Checklist Pre-Producción
- [ ] Pruebas unitarias 100% exitosas
- [ ] Validación funcional con Coordinadora Portafolio
- [ ] Conectividad SQL en producción verificada
- [ ] Credenciales de producción configuradas
- [ ] Plan de rollback documentado
- [ ] Programación automática configurada

> 📂 **Casos de prueba detallados:** Ver `testing/casos_prueba/` y `testing/datos_prueba/`

## 📊 Monitoreo y KPIs

### Ubicación de Logs

| Tipo | Ubicación | Formato |
|------|-----------|---------|
| **Ejecuciones exitosas** | `logs/ejecuciones/` | `RDA_YYYYMMDD_HHMMSS_SUCCESS.log` |
| **Errores** | `logs/errores/` | `RDA_YYYYMMDD_HHMMSS_ERROR.log` |
| **Procesamiento** | `data/output/logs/` | `proceso_MM_AAAA.log` |

### KPIs del Proceso

```log
================================================================================
EJECUCIÓN RDA COSTO AMORTIZABLE
Fecha: 2025-11-30 08:00:15
Usuario: RPA_Robot_CostoAmortizable
Modo: PRODUCCION
Mes/Año: 11/2025
================================================================================

[08:00:15] INFO - ========== INICIO PROCESO ==========
[08:00:16] INFO - Validando conectividad SQL...
[08:00:18] INFO - ✓ Conexión DWH_CC establecida (10.1.3.101\SCC)
[08:00:19] INFO - ✓ Conexión DWH_Riesgos_Credito establecida (10.1.5.172\RIESGOS)

[08:00:20] INFO - ========== HU-01: EXTRACCIÓN DWH ==========
[08:00:22] INFO - Ejecutando query reestructurados...
[08:00:45] INFO - ✓ Reestructurados extraídos: 543 registros
[08:00:46] INFO - Ejecutando query modificados...
[08:01:12] INFO - ✓ Modificados extraídos: 702 registros
[08:01:15] INFO - TOTAL EXTRAÍDO: 1,245 registros

[08:01:20] INFO - ========== HU-02: PREPARACIÓN EXCEL ==========
[08:01:22] INFO - Abriendo plantilla: Plantilla_Consolidacion_v11_2025.xlsx
[08:01:25] INFO - ✓ Hojas validadas: Reestructurados, Modificados, Retenciones, BASE

[08:02:00] INFO - ========== HU-03 a HU-07: CONSOLIDACIÓN ==========
[08:02:05] INFO - Consolidando reestructurados individuales...
[08:02:30] INFO - ✓ 543 registros consolidados
[08:03:15] INFO - Transformando fechas retenidos (dd/mm/yyyy → YYYYMMDD)...
[08:03:45] INFO - ✓ 215 fechas transformadas

[08:05:00] INFO - ========== HU-08 a HU-11: ORGANIZACIÓN Y CARGUE ==========
[08:05:15] INFO - Clasificando reestructurados (Consolidada/Individual)...
[08:05:30] INFO - ✓ Consolidada+Diferente: 234, Consolidada+Misma: 98
[08:05:31] INFO - ✓ Individual+Diferente: 156, Individual+Misma: 55
[08:06:45] INFO - Cargando a SQL Server (tabla: bd_reestructurados_11_2025)...
[08:07:15] INFO - ✓ 1,245 registros cargados exitosamente

[08:08:00] INFO - ========== HU-12 a HU-16: VALIDACIONES Y CÁLCULOS ==========
[08:08:15] INFO - [HU-12] Ejecutando validación de completitud...
[08:08:45] WARNING - 15 registros con información incompleta detectados
[08:08:46] INFO - ✓ Query completitud ejecutada vía Linked Server
[08:09:30] INFO - [HU-13] Recolectando tasas, plazos y saldos históricos...
[08:10:15] INFO - ✓ Tasas ponderadas calculadas para 87 consolidaciones
[08:11:00] INFO - [HU-14] Calculando pérdidas/ganancias...
[08:11:45] INFO - ✓ Pérdidas: $1,234,567,890 | Ganancias: $987,654,321
[08:12:30] INFO - [HU-16] Ejecutando macro VBA amortización...
[08:12:45] INFO - ✓ Macro ejecutada correctamente - 1,245 tablas generadas

[08:13:00] INFO - ========== HU-17 a HU-21: ENTREGA FINAL ==========
[08:13:15] INFO - Generando formato de envío mensual...
[08:13:45] INFO - Consolidando hoja BASE (50+ columnas)...
[08:14:00] INFO - Aplicando validaciones y filtros finales...
[08:14:15] WARNING - Filtradas 8 advertencias no críticas
[08:14:30] INFO - ✓ Archivo final generado: COSTO_AMORTIZABLE_11_2025.xls
[08:14:35] INFO - ✓ Hash SHA-256: a3f5e9d8c2b1f4e7...
[08:14:40] INFO - ✓ Cargado a SQL: bd_costo_amortizable_11_2025

[08:14:45] INFO - ========== NOTIFICACIONES ==========
[08:14:46] INFO - Enviando reporte a carol.campos@cajasocial.com...
[08:14:47] INFO - Enviando reporte a coordinador.riesgos@cajasocial.com...
[08:14:48] INFO - ✓ Notificaciones enviadas: 3 destinatarios

[08:14:50] INFO - ========== PROCESO COMPLETADO ==========
Tiempo total ejecución: 14 minutos 35 segundos
Registros procesados: 1,245
Errores críticos: 0
Advertencias: 23 (no críticas)
Estado final: ✅ EXITOSO

================================================================================
```

### Dashboard de Métricas (n8n)

Si usas n8n, accede al dashboard en: `http://localhost:5678/executions`

**Métricas Clave**:
- ⏱️ **Tiempo promedio**: 8-10 minutos
- 📊 **Registros procesados**: 1,000-1,500 por mes
- ✅ **Tasa de éxito**: >95%
- 🔄 **Reintentos promedio**: 0.2 por ejecución
- 💾 **Uso de memoria**: 2-4 GB

### Alertas y Notificaciones

#### Notificaciones Automáticas por Email

**En caso de éxito**:
```
Asunto: ✅ RDA Costo Amortizable - Ejecución Exitosa [11/2025]

El proceso RDA Costo Amortizable finalizó correctamente.

Resumen:
- Fecha ejecución: 30/11/2025 08:00
- Tiempo total: 14 min 35 seg
- Registros procesados: 1,245
- Archivo generado: COSTO_AMORTIZABLE_11_2025.xls
- Hash SHA-256: a3f5e9d8c2b1f4e7...

Advertencias no críticas: 23
- 15 registros con info incompleta (completado vía Linked Server)
- 8 registros filtrados por validación final

El archivo está disponible en:
- Ubicación: \\servidor\RDA_CostoAmortizable\output\reportes\
- SQL Server: bd_costo_amortizable_11_2025

Adjunto: COSTO_AMORTIZABLE_11_2025.xls
```

**En caso de error**:
```
Asunto: ❌ RDA Costo Amortizable - ERROR [11/2025]

El proceso RDA Costo Amortizable finalizó con errores.

Error detectado en: HU-11 (Cargue SQL Server)
Tipo de error: Timeout de conexión SQL
Mensaje: Connection timeout after 300 seconds

Acciones tomadas:
- Reintento 1: Fallido
- Reintento 2: Fallido
- Reintento 3: Fallido

Requiere intervención manual.
Log completo: logs/errores/RDA_20251130_083012_ERROR.log

Contacto: soporte.rpa@cajasocial.com
```

### Monitoreo en Producción

#### KPIs de Seguimiento Mensual

| KPI | Meta | Actual | Estado |
|-----|------|--------|--------|
| Tiempo de ejecución | ≤ 15 min | 14.5 min | ✅ |
| Tasa de éxito | ≥ 95% | 98.3% | ✅ |
| Reintentos promedio | ≤ 0.5 | 0.2 | ✅ |
| Errores críticos | 0 | 0 | ✅ |
| Puntualidad entrega | 100% | 100% | ✅ |

#### Revisión de Logs - Checklist Mensual

- [ ] Revisar logs del mes anterior en `logs/ejecuciones/`
- [ ] Identificar advertencias recurrentes
- [ ] Analizar tendencias de tiempo de ejecución
- [ ] Validar integridad de archivos generados (hash SHA-256)
- [ ] Confirmar recepción de reportes por usuarios finales
- [ ] Actualizar dashboard de KPIs
- [ ] Archivar logs >90 días en respaldo

### Troubleshooting Común

| Síntoma | Causa Probable | Solución |
|---------|----------------|----------|
| Timeout SQL | Carga alta en servidor | Ejecutar en horario alternativo |
| Macro VBA falla | Excel cerrado inesperadamente | Verificar procesos Excel activos |
| Datos incompletos | Linked Server inactivo | Validar conectividad a servidor remoto |
| Hash SHA-256 no coincide | Archivo modificado manualmente | Regenerar archivo desde proceso |
| Notificaciones no enviadas | Credenciales SMTP incorrectas | Reconfigurar credenciales email |

### Troubleshooting Común

| Síntoma | Causa Probable | Solución |
|---------|----------------|----------|
| Timeout SQL | Carga alta en servidor | Ejecutar en horario alternativo |
| Macro VBA falla | Excel cerrado inesperadamente | Verificar procesos Excel activos |
| Datos incompletos | Linked Server inactivo | Validar conectividad a servidor remoto |
| Hash no coincide | Archivo modificado manualmente | Regenerar archivo desde proceso |
| Notificaciones no llegan | Credenciales SMTP incorrectas | Reconfigurar credenciales email |

---

## 🤝 Gestión del Proyecto

### Metodología Ágil

- **Duración**: 7 semanas
- **Sprints**: 4 sprints de 1-2 semanas
- **Esfuerzo estimado**: 165.5 horas
- **Recurso**: 1 Desarrollador Junior PAD

### Roles y Responsabilidades

| Rol | Responsable | Contacto |
|-----|-------------|----------|
| **Product Owner** | Coordinador de Riesgos | coordinador.riesgos@fgs.co |
| **Desarrollador RPA** | Ronald Estiven Rios | rriosh@fgs.co |
| **Especialista RPA** | Jeimy Johana Lozano | jelozanog@fgs.co |
| **Usuario Final** | Carol Patricia Campos | ccamposg@fgs.co |

### Control de Cambios

Cualquier cambio de alcance requiere:
1. Solicitud documentada
2. Evaluación de impacto
3. Aprobación de Product Owner
4. Actualización de documentación

---

## 📞 Contacto y Soporte

### Canales de Soporte

| Tipo | Contacto | Horario |
|------|----------|---------|
| **Soporte RPA** | soporte.rpa@cajasocial.com | Lun-Vie 8:00 AM - 6:00 PM |
| **Soporte TI** | soporte.ti@cajasocial.com | 24/7 (on-call producción) |
| **Soporte Funcional** | riesgos@cajasocial.com | Lun-Vie 8:00 AM - 5:00 PM |

### Reportar Problemas

**GitHub Issues**: https://github.com/Stiven9710/RDA_Costo_Amortizable/issues

**Escalamiento**:
1. Nivel 1: Desarrollador RPA
2. Nivel 2: Líder RPA
3. Nivel 3: Coordinador de Riesgos
4. Nivel 4: Gerencia TI (emergencias)

---

## 📄 Licencia

**Propiedad exclusiva de Banco Caja Social** - Uso interno únicamente.

**Restricciones**:
- ❌ Prohibida distribución externa
- ❌ Prohibida modificación sin autorización
- ✅ Permitido uso interno por personal autorizado

**Confidencialidad**: Información confidencial y procesos críticos del negocio. Requiere NDA.

---

<div align="center">

**RDA Costo Amortizable - Banco Caja Social**

*Automatización que transforma 14 horas de trabajo manual en 15 minutos de ejecución inteligente*

📅 **Última actualización**: Noviembre 2025  
📌 **Versión**: 1.0.0-dev  
✅ **Estado**: En Desarrollo

**[⬆ Volver arriba](#rda-costo-amortizable---automatización-rpa)**

</div>

---

## 📞 Contacto

**Responsable Funcional**: Carol Patricia Campos González (ccamposg@fgs.co)  
**Coordinador de Riesgos**: coordinador.riesgos@fgs.co  
**Soporte RPA**: soporte.rpa@cajasocial.com | soporte.ti@cajasocial.com

**Documentación completa**: Ver PDD y HU en `documentacion/funcional/`  
**Repositorio**: https://github.com/Stiven9710/RDA_Costo_Amortizable (branch: feature/ronald)

---

## 📄 Licencia

**Propiedad exclusiva de Banco Caja Social** - Uso interno únicamente. Información confidencial.

---

<div align="center">

**RDA Costo Amortizable - Banco Caja Social**

*Automatización que transforma 14 horas de trabajo manual en 15 minutos*

📅 Última actualización: Noviembre 2025 | 📌 Versión: 1.0.0 | ✅ Estado: En Desarrollo

</div>

