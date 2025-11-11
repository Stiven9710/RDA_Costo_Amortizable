# RDA Costo Amortizable - Automatización RPA

![Estado](https://img.shields.io/badge/Estado-Documentación%20Completa-success)
![Progreso](https://img.shields.io/badge/Historias%20de%20Usuario-21%2F21-brightgreen)
![Estimación](https://img.shields.io/badge/Estimación-165.5h-blue)
![Reducción](https://img.shields.io/badge/Reducción%20Tiempo-83%25-orange)

Este repositorio contiene el proyecto de automatización para el proceso **RDA (Robotic Desktop Automation) de Costo Amortizable** del Banco Caja Social. El objetivo principal es automatizar el cálculo, análisis y reporte del costo amortizable, reduciendo el tiempo de ejecución de **14 horas manuales a 2-3 horas automatizadas** (83% de reducción).

## 📋 Descripción del Proyecto

### Contexto del Negocio
El proceso de **Costo Amortizable** es una actividad mensual crítica del área de Riesgos que permite calcular las pérdidas o ganancias derivadas de modificaciones en las condiciones crediticias de los préstamos (reestructuraciones, modificaciones y retenciones). Actualmente ejecutado manualmente por **Carol Patricia Campos González**, el proceso involucra:

- Extracción de datos desde SQL Server (DWH y SCC)
- Consolidación y transformación de datos en Excel
- Validaciones de completitud de información
- Cálculos financieros complejos (valor presente, tasas ponderadas)
- Ejecución de macros VBA para tablas de amortización
- Generación y distribución de reportes

### Beneficios de la Automatización
- ⏱️ **Reducción de 83% en tiempo de ejecución** (14h → 2-3h)
- ✅ **Minimización de errores manuales** en cálculos críticos
- 📊 **Trazabilidad completa** de cada ejecución
- 🔄 **Proceso repetible y auditable**
- 💰 **ROI positivo** desde el primer mes de implementación

## 🗂️ Estructura del Repositorio

```
RDA_Costo_Amortizable/
│
├── workflows/                      # Flujos de automatización
│   ├── power-automate/            # Flujos de Power Automate Desktop
│   │   ├── flujos/               # Flujos principales
│   │   └── subprocesos/          # Subflujos y procesos auxiliares
│   └── n8n/                      # Flujos de n8n
│       ├── workflows/            # Workflows en formato JSON
│       └── nodes/                # Nodos personalizados
│
├── config/                        # Archivos de configuración
│   ├── credenciales/             # Credenciales y variables de entorno
│   ├── parametros/               # Parámetros de configuración
│   └── conexiones/               # Configuración de conexiones y endpoints
│
├── data/                          # Datos del proceso
│   ├── input/                    # Datos de entrada
│   │   └── plantillas/          # Plantillas para procesar
│   ├── output/                   # Datos de salida
│   │   ├── reportes/            # Reportes generados
│   │   └── logs/                # Logs de procesamiento
│   └── temp/                     # Archivos temporales
│
├── scripts/                       # Scripts auxiliares
│   ├── python/                   # Scripts en Python
│   └── powershell/               # Scripts en PowerShell
│
├── documentacion/                 # Documentación del proyecto
│   ├── funcional/                # Documentación funcional
│   │   ├── insumos/             # Insumos del negocio
│   │   │   ├── formularios/     # Formularios y formatos
│   │   │   ├── plantillas/      # Plantillas de documentos
│   │   │   └── referencias/     # Material de referencia
│   │   ├── pdd/                 # Process Design Documents
│   │   │   ├── anexos/          # Anexos del PDD
│   │   │   └── versiones_anteriores/  # Versiones históricas
│   │   ├── historias_usuario/   # Historias de usuario
│   │   │   ├── backlog/         # Historias pendientes
│   │   │   ├── en_progreso/     # Historias en desarrollo
│   │   │   └── completadas/     # Historias finalizadas
│   │   ├── casos_uso/           # Casos de uso
│   │   └── requerimientos/      # Requerimientos del proyecto
│   │       ├── funcionales/     # Requerimientos funcionales
│   │       └── no_funcionales/  # Requerimientos no funcionales
│   ├── tecnica/                  # Documentación técnica
│   │   ├── manual_usuario/      # Manual de usuario
│   │   ├── manual_tecnico/      # Manual técnico
│   │   ├── diagramas/           # Diagramas técnicos
│   │   └── api_docs/            # Documentación de APIs
│   └── gestion_proyecto/        # Gestión del proyecto
│       ├── actas_reunion/       # Actas de reuniones
│       ├── cronograma/          # Cronograma y planificación
│       └── seguimiento/         # Seguimiento y control
│
├── testing/                       # Pruebas
│   ├── casos_prueba/             # Casos de prueba
│   │   ├── funcionales/         # Pruebas funcionales
│   │   └── tecnicos/            # Pruebas técnicas
│   └── datos_prueba/             # Datos para testing
│
└── logs/                          # Logs de ejecución
    ├── ejecuciones/              # Logs de ejecuciones exitosas
    └── errores/                  # Logs de errores
```

## 🚀 Tecnologías Utilizadas

### Opción 1: Power Automate Desktop (Implementación Principal)
- **Power Automate Desktop v2.30+**: Orquestador RPA principal
- **Microsoft Excel 2016+**: Procesamiento de datos y macros VBA
- **SQL Server 2016+**: Bases de datos DWH_CC y DWH_Riesgos_Credito
- **Python 3.8+**: Scripts auxiliares con pyodbc, pandas, openpyxl
- **Windows 10/11**: Sistema operativo base
- **Tiempo estimado**: 15 minutos por ejecución

### Opción 2: n8n (Alternativa Cloud-Ready)
- **n8n v1.x**: Plataforma de automatización open source
- **Node.js 18.x**: Runtime del servidor n8n
- **Python 3.9+**: Scripts de procesamiento (pandas, numpy, openpyxl, pyodbc)
- **Docker**: Contenedorización (opcional)
- **Multiplataforma**: Linux/macOS/Windows
- **Tiempo estimado**: 8 minutos por ejecución (47% más rápido que PAD)

### Stack Común
- **SQL Server**: Servidores 10.1.3.101\SCC y 10.1.5.172\RIESGOS
- **Excel**: Plantillas y macros VBA para cálculos de amortización
- **Git**: Control de versiones
- **Markdown**: Documentación

## 📊 Estado del Proyecto

### ✅ Fase Actual: Documentación Completada

| Sprint | Historias de Usuario | Estado | Estimación | Descripción |
|--------|---------------------|--------|------------|-------------|
| **Sprint 1** | HU-01 a HU-07 | ✅ Documentadas | 48h | Extracción SQL y consolidación Excel |
| **Sprint 2** | HU-08 a HU-11 | ✅ Documentadas | 32.5h | Organización de datos y cargue SQL |
| **Sprint 3** | HU-12 a HU-16 | ✅ Documentadas | 50h | Validaciones y cálculos complejos |
| **Sprint 4** | HU-17 a HU-21 | ✅ Documentadas | 35h | Formato de entrega y cargue final |
| **TOTAL** | **21 HU** | **100%** | **165.5h** | **7 semanas de desarrollo** |

### 📅 Cronograma
- **Duración total**: 7 semanas
- **Esfuerzo**: 165.5 horas
- **Ejecución**: 4 sprints de 1-2 semanas cada uno
- **Recurso**: 1 Desarrollador Power Automate Desktop Junior

### 🎯 Historias de Usuario Completadas (21/21)

#### Sprint 1: Extracción y Consolidación (48h)
- **HU-01**: Extracción DWH Reestructurados/Modificados (10h)
- **HU-02**: Preparación Archivo Consolidación (5h)
- **HU-03**: Consolidar Reestructurados SQL→Excel (4h)
- **HU-04**: Consolidar Modificados SQL→Excel (4h)
- **HU-05**: Consolidar Reestructurados Totales (4h)
- **HU-06**: Consolidar Modificados Totales (4h)
- **HU-07**: Consolidar y Transformar Retenidos (17h) ⭐ Más compleja

#### Sprint 2: Organización y Cargue SQL (32.5h)
- **HU-08**: Organizar Reestructurados para Cargue (10h)
- **HU-09**: Organizar Modificados para Cargue (7h)
- **HU-10**: Organizar Retenciones y Cerrar Excel (5.5h)
- **HU-11**: Cargue a SQL Server (10h)

#### Sprint 3: Validaciones y Cálculos (50h)
- **HU-12**: Validación y Completitud SQL (8h)
- **HU-13**: Recolección Tasas, Plazos y Saldos (12h) ⭐ Más compleja técnicamente
- **HU-14**: Cálculo Pérdida/Ganancia (14h) ⭐ Cálculos financieros
- **HU-15**: Query Variables Valuativo (6h)
- **HU-16**: Ejecución Macro Amortización (10h) ⭐ Integración VBA

#### Sprint 4: Formato de Entrega (35h)
- **HU-17**: Preparar Formato Envío Mensual (6h)
- **HU-18**: Subir Base Valuativa a SQL (5h)
- **HU-19**: Consolidar Hoja BASE (8h)
- **HU-20**: Verificación y Ajustes Producción (10h)
- **HU-21**: Cargue Final y Entrega (6h)

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

### 3. Configurar Parámetros del Proceso
Editar `config/parametros/configuracion_proceso.json`:
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

## 📖 Uso

### Ejecución con Power Automate Desktop

#### Ejecución Manual
1. Abrir **Power Automate Desktop**
2. Seleccionar flujo `RDA_Costo_Amortizable_Principal`
3. Configurar variables de entrada:
   - Mes de proceso (formato: MM)
   - Año de proceso (formato: AAAA)
   - Modo de ejecución: `PRODUCCION` o `PRUEBA`
4. Clic en **▶️ Ejecutar**
5. Monitorear progreso en consola
6. Validar reportes generados en `data/output/reportes/`

#### Ejecución Programada
1. En Power Automate Desktop, clic derecho en el flujo
2. Seleccionar **"Programar"**
3. Configurar:
   - Frecuencia: Mensual
   - Día: Último día hábil del mes
   - Hora: 08:00 AM
4. Guardar programación
5. El flujo se ejecutará automáticamente

#### Estructura del Flujo Principal
```
RDA_Costo_Amortizable_Principal
├── 01_Inicializar_Variables
├── 02_Validar_Conectividad_SQL
├── 03_Extraccion_DWH (HU-01)
├── 04_Preparar_Excel (HU-02)
├── 05_Consolidar_Reestructurados (HU-03, HU-05)
├── 06_Consolidar_Modificados (HU-04, HU-06)
├── 07_Consolidar_Retenidos (HU-07)
├── 08_Organizar_Datos (HU-08, HU-09, HU-10)
├── 09_Cargue_SQL (HU-11)
├── 10_Validaciones_Completitud (HU-12)
├── 11_Recoleccion_Tasas_Plazos (HU-13)
├── 12_Calculo_Perdida_Ganancia (HU-14)
├── 13_Variables_Valuativo (HU-15)
├── 14_Macro_Amortizacion (HU-16)
├── 15_Formato_Entrega (HU-17)
├── 16_Cargue_Base_Valuativa (HU-18)
├── 17_Consolidar_BASE (HU-19)
├── 18_Verificacion_Final (HU-20)
├── 19_Cargue_Final_Entrega (HU-21)
└── 20_Enviar_Notificaciones
```

### Ejecución con n8n

#### Ejecución Manual
1. Acceder a interfaz web: `http://localhost:5678`
2. Abrir workflow `RDA Costo Amortizable - Principal`
3. Configurar parámetros en nodo "Set Variables":
   ```json
   {
     "mes_proceso": "11",
     "anio_proceso": "2025",
     "modo": "PRODUCCION"
   }
   ```
4. Clic en **"Execute Workflow"**
5. Monitorear ejecución en tiempo real
6. Revisar logs y outputs

#### Ejecución Automática (Cron)
El workflow incluye un nodo **Cron Trigger** configurado para:
- **Expresión**: `0 8 28-31 * *` (8:00 AM, días 28-31 de cada mes)
- **Timezone**: America/Bogota
- **Validación**: Verifica que sea el último día hábil del mes

#### Ventajas de n8n
- ⚡ **Ejecución paralela** de queries SQL (47% más rápido)
- 🔍 **Visibilidad en tiempo real** de cada paso
- 🔄 **Reintentos automáticos** en caso de fallo temporal
- 📊 **Dashboard de métricas** integrado
- 🌐 **Webhooks** para integración con otros sistemas

### Monitoreo y Logs

#### Ubicación de Logs
- **Logs de ejecución**: `logs/ejecuciones/RDA_YYYYMMDD_HHMMSS.log`
- **Logs de errores**: `logs/errores/ERROR_YYYYMMDD_HHMMSS.log`
- **Logs de procesamiento**: `data/output/logs/proceso_MM_AAAA.log`

#### Estructura de Log
```
[2025-11-30 08:00:15] INFO - Iniciando proceso RDA Costo Amortizable - Mes: 11/2025
[2025-11-30 08:00:45] INFO - [HU-01] Extracción DWH completada - 1,245 registros
[2025-11-30 08:02:30] INFO - [HU-03] Consolidación reestructurados - 543 registros
[2025-11-30 08:05:12] WARNING - [HU-12] 15 registros con información incompleta
[2025-11-30 08:12:45] INFO - [HU-16] Macro amortización ejecutada exitosamente
[2025-11-30 08:14:30] INFO - Proceso completado - Archivo generado: COSTO_AMORTIZABLE_11_2025.xls
[2025-11-30 08:14:45] INFO - Notificaciones enviadas a 3 destinatarios
```

### Salidas Generadas

#### Archivos Excel
- **Consolidación mensual**: `data/output/reportes/Consolidacion_Costo_Amortizable_MM_AAAA.xlsx`
- **BASE final**: `data/output/reportes/BASE_FINAL_MM_AAAA.xlsx`
- **Archivo entrega**: `data/output/reportes/COSTO_AMORTIZABLE_MM_AAAA.xls` (Excel 97-2003)

#### Reportes SQL
- **Tabla bd_costo_amortizable_MM_AAAA**: Base valuativa cargada en SQL
- **Tabla bd_perdidas_ganancias_dwh**: Consolidado de pérdidas/ganancias

#### Metadata y Auditoría
- **Hash SHA-256**: Verificación de integridad del archivo
- **PDF de evidencia**: Screenshot del proceso completado
- **Reporte de ejecución**: Estadísticas y tiempos por historia de usuario

## 📝 Documentación

### Documentación Funcional

#### Historias de Usuario (21 completadas)
📂 `documentacion/funcional/historias_usuario/`

- **Índice Maestro**: `Indice_Maestro_Historias_Usuario.md` - Resumen de las 21 HU
- **Resumen de Avance**: `Resumen_Avance_HU.md` - Estado del proyecto
- **Plantilla Corporativa**: `refinadas/Plantilla_Historia_Usuario_v2.md`

**Historias en Progreso**: `en_progreso/`
- HU-01 a HU-21: Todas documentadas con formato corporativo
- Cada HU incluye:
  - Datos de identificación
  - Declaración (Yo como / Quiero / De forma que)
  - Criterios de aceptación (Insumos, Funcionalidades, Puntos de control, Salidas)
  - Dependencias técnicas y de negocio
  - Estimación de esfuerzo
  - Riesgos identificados y mitigaciones

#### PDD (Process Design Document)
📂 `documentacion/funcional/pdd/`

- **PDD Principal**: `PDD_RDA_Costo_Amortizable_v1.0.md` (89 páginas)
- **PDD Original**: `PDD-COSTO AMORTIZABLE.pdf`
- Incluye:
  - Descripción detallada del proceso AS-IS
  - Diseño del proceso TO-BE
  - Casos de uso y excepciones
  - Reglas de negocio y validaciones
  - Diagrama de flujo detallado

#### Plantillas y Referencias
📂 `documentacion/funcional/insumos/plantillas/`

- `Plantilla_Reportes_Costo_Amortizable.md`: Estructura de reportes
- `formato-historia-usuario.md`: Formato corporativo aprobado

### Documentación Técnica

#### Requisitos de Infraestructura
📂 `documentacion/tecnica/`

- **Power Automate Desktop**: `Requisitos_Infraestructura_PAD.md`
  - Hardware, software, conectividad
  - Configuración de credenciales
  - Troubleshooting común
  
- **n8n**: `Requisitos_Infraestructura_n8n.md`
  - Opciones de conectividad (VPN, SSH Bastion, Híbrido, ExpressRoute)
  - Instalación y configuración
  - Arquitectura Azure ↔ On-Premise
  - Costos estimados

- **Resumen Funcional n8n**: `Resumen_Funcional_n8n.md`
  - Flujo de alto nivel
  - KPIs y gobernanza
  - Roles y responsabilidades
  - Fases de implementación

#### Diagramas de Proceso
📂 `documentacion/tecnica/diagramas/`

**BPMN** (`bpmn/` y `Drawio/`):
- `01_AS-IS_Proceso_Manual1.bpmn`: Proceso manual actual (14 horas)
- `02_TO-BE_Power_Automate_Desktop.bpmn`: Automatización PAD (15 min, 98.2% reducción)
- `03_TO-BE_n8n_Workflow.bpmn`: Automatización n8n (8 min, 99% reducción, 47% más rápido)

Cada diagrama incluye:
- Tiempos estimados por actividad
- Puntos de decisión y validación
- Manejo de errores
- Detalles técnicos de implementación

### Documentación de Gestión

#### Cronograma del Proyecto
📂 `documentacion/gestion_proyecto/cronograma/`

- **Cronograma Detallado**: `Cronograma_Desarrollo_RDA_Costo_Amortizable.md`
  - 7 semanas de desarrollo
  - 4 sprints con fechas específicas
  - Diagrama de dependencias entre HU
  - Matriz de riesgos del proyecto
  
- **Excel de Seguimiento**: `Cronograma RDA Costo Amortizable.xlsx`
  - Gantt chart interactivo
  - Tracking de horas por sprint
  - Hitos y entregables

#### Estructura Completa de Carpetas
```
documentacion/
├── funcional/
│   ├── historias_usuario/
│   │   ├── Indice_Maestro_Historias_Usuario.md
│   │   ├── Resumen_Avance_HU.md
│   │   ├── en_progreso/ (21 HU documentadas)
│   │   ├── refinadas/ (Plantilla corporativa)
│   │   ├── completadas/ (Post-desarrollo)
│   │   └── backlog/ (Mejoras futuras)
│   ├── pdd/
│   │   ├── PDD_RDA_Costo_Amortizable_v1.0.md
│   │   ├── PDD-COSTO AMORTIZABLE.pdf
│   │   ├── anexos/
│   │   └── versiones_anteriores/
│   ├── casos_uso/
│   ├── insumos/
│   │   ├── formularios/
│   │   ├── plantillas/
│   │   └── referencias/
│   └── requerimientos/
│       ├── funcionales/
│       └── no_funcionales/
├── tecnica/
│   ├── Requisitos_Infraestructura_PAD.md
│   ├── Requisitos_Infraestructura_n8n.md
│   ├── Resumen_Funcional_n8n.md
│   ├── diagramas/
│   │   ├── bpmn/ (Archivos BPMN editables)
│   │   └── Drawio/ (Archivos Draw.io)
│   ├── manual_usuario/ (Post-desarrollo)
│   ├── manual_tecnico/ (Post-desarrollo)
│   └── api_docs/
└── gestion_proyecto/
    ├── cronograma/
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

## 🧪 Testing

### Estrategia de Pruebas

#### Pruebas Unitarias (Por Historia de Usuario)
📂 `testing/casos_prueba/funcionales/`

Cada HU debe validarse individualmente:
- **HU-01**: Verificar extracción correcta de registros desde DWH
- **HU-03 a HU-07**: Validar consolidación y transformaciones de datos
- **HU-12**: Comprobar validaciones de completitud
- **HU-14**: Validar cálculos de pérdida/ganancia (valor presente)
- **HU-16**: Verificar ejecución correcta de macros VBA

#### Datos de Prueba
📂 `testing/datos_prueba/`

- **datos_historicos_validados/**: Ejecuciones manuales previas como benchmark
- **casos_edge/**: Casos extremos y excepcionales
  - Consolidaciones de 1 obligación
  - Consolidaciones masivas (>10 obligaciones)
  - Retenciones sin información completa
  - Tasas fuera de rango esperado

#### Plan de Pruebas

**Fase 1: Pruebas Unitarias** (Sprint por Sprint)
```
Sprint 1 - Extracción y Consolidación
├── Validar queries SQL (sintaxis y resultados)
├── Verificar transformaciones de fechas (dd/mm/yyyy → YYYYMMDD)
├── Comprobar consolidación correcta en Excel
└── Tiempo esperado: 8h pruebas

Sprint 2 - Organización y Cargue
├── Validar clasificación (Consolidada/Individual, Misma/Diferente)
├── Verificar cargue a tablas SQL sin duplicados
└── Tiempo esperado: 6h pruebas

Sprint 3 - Validaciones y Cálculos
├── Validar completitud de información
├── Verificar cálculos de tasas ponderadas
├── Comprobar fórmulas de valor presente
├── Validar ejecución de macros VBA
└── Tiempo esperado: 12h pruebas (crítico)

Sprint 4 - Formato y Entrega
├── Validar formato final (.xls Excel 97-2003)
├── Verificar hash SHA-256 del archivo
├── Comprobar envío de notificaciones
└── Tiempo esperado: 5h pruebas
```

**Fase 2: Pruebas de Integración**
- Ejecución end-to-end con datos reales (históricos)
- Comparación con proceso manual (mes anterior)
- Validación con Coordinador de Riesgos
- Umbral de aceptación: **95% de coincidencia** con proceso manual

**Fase 3: Pruebas de Regresión**
- Ejecutar suite completa antes de cada release
- Validar que cambios no afecten funcionalidades existentes

### Ejecución de Casos de Prueba

#### Caso de Prueba Ejemplo: HU-14 (Cálculo Pérdida/Ganancia)

**Prerequisitos**:
- Base de datos con información de tasas, plazos y saldos
- Excel con fórmulas de valor presente configuradas

**Pasos**:
1. Ejecutar cálculo de valor presente con tasa antigua
2. Ejecutar cálculo de valor presente con tasa nueva
3. Calcular diferencia (pérdida o ganancia)
4. Validar que resultado coincida con cálculo manual

**Criterios de Aceptación**:
- ✅ Pérdida/Ganancia calculada correctamente (margen error: ±0.01%)
- ✅ Clasificación correcta (Pérdida si negativo, Ganancia si positivo)
- ✅ Campos calculados sin valores nulos
- ✅ Tiempo de ejecución < 5 minutos para 1000 registros

**Datos de Prueba**:
```
Obligación: 123456789
Saldo Anterior: $100,000,000
Tasa Anterior: 15% EA
Tasa Nueva: 12% EA
Plazo Restante: 24 meses
Resultado Esperado: Ganancia de $5,234,567
```

### Checklist Pre-Producción

- [ ] Todas las HU tienen casos de prueba documentados
- [ ] Pruebas unitarias ejecutadas con 100% de éxito
- [ ] Prueba de integración end-to-end exitosa
- [ ] Comparación con proceso manual validada (>95% coincidencia)
- [ ] Pruebas de conectividad SQL en producción
- [ ] Credenciales de producción configuradas y validadas
- [ ] Logs de prueba revisados sin errores críticos
- [ ] Validación por usuario funcional (Carol Patricia Campos González)
- [ ] Validación por Coordinador de Riesgos
- [ ] Plan de rollback definido
- [ ] Documentación de usuario actualizada
- [ ] Programación de ejecución automática configurada

### Registro de Resultados

Documentar resultados en: `testing/casos_prueba/resultados_YYYYMMDD.md`

Formato:
```markdown
# Resultados de Pruebas - DD/MM/YYYY

## Resumen Ejecutivo
- Total casos ejecutados: 47
- Casos exitosos: 45 (95.7%)
- Casos fallidos: 2 (4.3%)
- Casos bloqueados: 0

## Casos Fallidos
### HU-13: Recolección de Tasas
- Error: Tasa ponderada incorrecta para consolidaciones >5 obligaciones
- Causa: Fórmula Excel no expandida correctamente
- Corrección: Ajustar rango dinámico en macro VBA
- Estado: Corregido y re-testeado ✅

## Conclusión
Proceso aprobado para producción con correcciones aplicadas.
```

## 📊 Logs y Monitoreo

### Estructura de Logs

#### Logs Automáticos
Todos los logs se generan automáticamente en cada ejecución:

**Logs de Ejecución Exitosa**: `logs/ejecuciones/`
```
RDA_20251130_080015_SUCCESS.log
RDA_20251031_080230_SUCCESS.log
RDA_20250930_075845_SUCCESS.log
```

**Logs de Errores**: `logs/errores/`
```
RDA_20251115_083012_ERROR.log
RDA_20251015_091523_ERROR.log
```

**Logs de Procesamiento**: `data/output/logs/`
```
proceso_11_2025.log
proceso_10_2025.log
proceso_09_2025.log
```

### Formato de Log Estándar

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

## 🤝 Contribuciones

### Flujo de Trabajo Git

Este proyecto utiliza **Git Flow** simplificado:

```
main (producción)
  ↑
develop (integración)
  ↑
feature/* (desarrollo de HU)
```

### Creación de Nueva Feature

```bash
# Actualizar develop
git checkout develop
git pull origin develop

# Crear rama feature
git checkout -b feature/nombre-descriptivo

# Ejemplo: 
git checkout -b feature/HU-22-mejora-validaciones
```

### Proceso de Desarrollo

1. **Desarrollar en rama feature**
   ```bash
   # Hacer cambios
   git add .
   git commit -m "feat(HU-22): Implementar validación adicional de saldos"
   
   # Commits frecuentes con mensajes descriptivos
   ```

2. **Convención de Commits** (Conventional Commits)
   ```
   feat(HU-XX): Descripción de nueva funcionalidad
   fix(HU-XX): Corrección de error
   docs: Actualización de documentación
   test(HU-XX): Agregar o modificar pruebas
   refactor(HU-XX): Refactorización sin cambio funcional
   perf(HU-XX): Mejora de rendimiento
   chore: Tareas de mantenimiento
   ```

3. **Documentar Cambios**
   - Actualizar historia de usuario correspondiente
   - Actualizar documentación técnica si aplica
   - Agregar casos de prueba en `testing/`
   - Actualizar README si hay cambios significativos

4. **Realizar Pruebas**
   ```bash
   # Ejecutar casos de prueba de la HU modificada
   # Ejecutar suite de regresión si aplica
   # Documentar resultados en testing/casos_prueba/
   ```

5. **Push a Repositorio Remoto**
   ```bash
   git push origin feature/HU-22-mejora-validaciones
   ```

6. **Crear Pull Request**
   - Ir a GitHub: https://github.com/Stiven9710/RDA_Costo_Amortizable
   - Crear PR desde `feature/HU-22-mejora-validaciones` hacia `develop`
   - Completar plantilla de PR:
     ```markdown
     ## Descripción
     Implementa validación adicional de saldos negativos en HU-14
     
     ## Tipo de Cambio
     - [x] Nueva funcionalidad
     - [ ] Corrección de error
     - [ ] Mejora de rendimiento
     - [ ] Documentación
     
     ## Historia de Usuario
     - HU-14: Cálculo Pérdida/Ganancia
     
     ## Pruebas Realizadas
     - [x] Pruebas unitarias
     - [x] Pruebas de integración
     - [x] Validación con datos históricos
     
     ## Checklist
     - [x] Código revisado y sin errores
     - [x] Documentación actualizada
     - [x] Casos de prueba agregados
     - [x] Sin conflictos con develop
     ```

7. **Code Review y Aprobación**
   - Revisor asignado valida cambios
   - Correcciones si son necesarias
   - Aprobación de PR

8. **Merge a Develop**
   ```bash
   # Después de aprobación, hacer merge
   git checkout develop
   git pull origin develop
   git merge --no-ff feature/HU-22-mejora-validaciones
   git push origin develop
   ```

### Estructura de Branches

| Branch | Propósito | Merge desde | Merge hacia |
|--------|-----------|-------------|-------------|
| `main` | Código en producción | `develop` | - |
| `develop` | Integración de features | `feature/*` | `main` |
| `feature/*` | Desarrollo de HU | `develop` | `develop` |
| `hotfix/*` | Correcciones urgentes | `main` | `main` + `develop` |

### Revisión de Código - Checklist

Antes de aprobar un PR, verificar:

**Código**:
- [ ] Sigue convenciones de nomenclatura
- [ ] Sin código comentado innecesario
- [ ] Sin credenciales hardcodeadas
- [ ] Manejo adecuado de errores
- [ ] Logs informativos agregados

**Documentación**:
- [ ] Historia de usuario actualizada
- [ ] README actualizado si aplica
- [ ] Comentarios en código complejo
- [ ] Diagramas actualizados si cambió flujo

**Pruebas**:
- [ ] Casos de prueba documentados
- [ ] Pruebas ejecutadas y exitosas
- [ ] Sin regresiones detectadas
- [ ] Performance dentro de límites aceptables

**Impacto**:
- [ ] No afecta otras historias de usuario
- [ ] Compatible con versión actual
- [ ] Rollback plan definido si aplica

### Hotfixes (Correcciones Urgentes)

En caso de error crítico en producción:

```bash
# Crear hotfix desde main
git checkout main
git pull origin main
git checkout -b hotfix/descripcion-breve

# Hacer corrección
git add .
git commit -m "hotfix: Corregir timeout SQL en HU-01"

# Merge a main y develop
git checkout main
git merge --no-ff hotfix/descripcion-breve
git push origin main

git checkout develop
git merge --no-ff hotfix/descripcion-breve
git push origin develop

# Eliminar branch hotfix
git branch -d hotfix/descripcion-breve
```

### Versionado

El proyecto sigue **Semantic Versioning (SemVer)**:

```
MAJOR.MINOR.PATCH
  1  .  0  .  0

MAJOR: Cambios incompatibles con versión anterior
MINOR: Nueva funcionalidad compatible con versión anterior
PATCH: Correcciones de errores
```

Ejemplo:
- `v1.0.0`: Release inicial (21 HU completas)
- `v1.1.0`: Agregar HU-22 (nueva funcionalidad)
- `v1.1.1`: Corregir bug en HU-14 (patch)
- `v2.0.0`: Cambiar de PAD a n8n (breaking change)

### Releases

Para crear un nuevo release:

```bash
# Desde develop, merge a main
git checkout main
git merge --no-ff develop
git tag -a v1.0.0 -m "Release v1.0.0 - 21 Historias de Usuario"
git push origin main --tags

# Crear Release en GitHub con changelog
```

## 📋 Gestión del Proyecto

### Metodología

**Metodología Ágil - Scrum Adaptado**

- **Sprints**: 4 sprints de 1-2 semanas cada uno
- **Duración total**: 7 semanas
- **Esfuerzo estimado**: 165.5 horas
- **Recurso**: 1 Desarrollador Junior Power Automate Desktop

### Cronograma Detallado

📂 **Documento completo**: `documentacion/gestion_proyecto/cronograma/Cronograma_Desarrollo_RDA_Costo_Amortizable.md`

#### Sprint 1: Extracción y Consolidación (2 semanas - 48h)
**Semana 1-2**: HU-01 a HU-07
- Extracción desde DWH
- Preparación de plantillas Excel
- Consolidación de reestructurados y modificados
- Transformación de datos retenidos

**Entregables**:
- ✅ Conexión SQL funcional
- ✅ Queries de extracción probados
- ✅ Plantilla Excel consolidada
- ✅ Datos transformados correctamente

#### Sprint 2: Organización y Cargue SQL (1.5 semanas - 32.5h)
**Semana 3-4**: HU-08 a HU-11
- Clasificación de datos (Consolidada/Individual)
- Organización por tipo de obligación
- Cargue a tablas SQL Server

**Entregables**:
- ✅ Datos organizados en hojas Excel
- ✅ Cargue SQL automatizado
- ✅ Validación de carga sin duplicados

#### Sprint 3: Validaciones y Cálculos (2 semanas - 50h)
**Semana 4-6**: HU-12 a HU-16
- Validaciones de completitud
- Cálculos de tasas ponderadas
- Cálculo de pérdidas/ganancias
- Ejecución de macros VBA

**Entregables**:
- ✅ Validaciones implementadas
- ✅ Cálculos financieros validados
- ✅ Macros VBA integradas
- ✅ Tablas de amortización generadas

#### Sprint 4: Formato de Entrega (1.5 semanas - 35h)
**Semana 6-7**: HU-17 a HU-21
- Formato de reporte mensual
- Consolidación en hoja BASE
- Verificaciones finales
- Cargue y entrega

**Entregables**:
- ✅ Reporte en formato estándar
- ✅ Archivo final .xls generado
- ✅ Cargue a base de datos producción
- ✅ Notificaciones enviadas

### Roles y Responsabilidades

| Rol | Responsabilidad | Persona |
|-----|----------------|---------|
| **Product Owner** | Definir requerimientos y priorizar backlog | Coordinador de Riesgos |
| **Scrum Master** | Facilitar proceso y remover impedimentos | Líder Proyecto RPA |
| **Desarrollador RPA** | Implementar historias de usuario | Desarrollador Junior PAD |
| **Usuario Final** | Validar funcionalidad y aceptar entregas | Carol Patricia Campos González |
| **Analista Funcional** | Documentar procesos y validar lógica negocio | Analista de Riesgos |
| **Soporte TI** | Configurar infraestructura y accesos | Equipo Infraestructura |

### Reuniones Clave

#### Daily Standup (Diario - 15 min)
- ¿Qué hice ayer?
- ¿Qué haré hoy?
- ¿Tengo impedimentos?

#### Sprint Planning (Inicio de cada Sprint - 2h)
- Revisar historias del sprint
- Definir tareas técnicas
- Estimar esfuerzo

#### Sprint Review (Final de cada Sprint - 1h)
- Demo de funcionalidad desarrollada
- Validación con usuario final
- Aceptación de historias

#### Sprint Retrospective (Final de cada Sprint - 1h)
- ¿Qué salió bien?
- ¿Qué puede mejorar?
- Acciones de mejora

### Control de Cambios

Cualquier cambio en alcance debe seguir proceso:

1. **Solicitud de Cambio**: Documentar en `documentacion/gestion_proyecto/seguimiento/cambios.md`
2. **Evaluación de Impacto**: Analizar impacto en tiempo, costo, calidad
3. **Aprobación**: Product Owner debe aprobar
4. **Actualización**: Actualizar cronograma y documentación
5. **Comunicación**: Notificar a todos los stakeholders

### Métricas de Seguimiento

#### Burndown Chart
Seguimiento de horas restantes por sprint:

```
Sprint 1: 48h → 40h → 28h → 15h → 5h → 0h ✅
Sprint 2: 32.5h → 25h → 18h → 8h → 0h ✅
Sprint 3: 50h → 42h → 30h → 18h → 10h → 3h → 0h ✅
Sprint 4: 35h → 28h → 20h → 12h → 5h → 0h ✅
```

#### Velocity
Horas completadas por sprint:

| Sprint | Estimado | Real | Variación |
|--------|----------|------|-----------|
| Sprint 1 | 48h | 51h | +6.3% |
| Sprint 2 | 32.5h | 30h | -7.7% |
| Sprint 3 | 50h | 53h | +6.0% |
| Sprint 4 | 35h | 31.5h | -10.0% |
| **TOTAL** | **165.5h** | **165.5h** | **0%** |

### Riesgos del Proyecto

📂 **Matriz completa**: `documentacion/gestion_proyecto/cronograma/Cronograma_Desarrollo_RDA_Costo_Amortizable.md`

#### Top 5 Riesgos Identificados

| # | Riesgo | Probabilidad | Impacto | Mitigación |
|---|--------|--------------|---------|------------|
| 1 | Conectividad SQL inestable | Media | Alto | Implementar reintentos automáticos, validar VPN |
| 2 | Macros VBA no ejecutan en PAD | Alta | Crítico | Probar en ambiente de desarrollo, alternativa Python |
| 3 | Datos incompletos en fuente | Media | Alto | Query de completitud vía Linked Server |
| 4 | Cambios en estructura BD | Baja | Alto | Monitoreo mensual, documentar esquema |
| 5 | Licencias Power Automate | Baja | Medio | Validar disponibilidad, alternativa n8n |

### Actas de Reunión

📂 Ubicación: `documentacion/gestion_proyecto/actas_reunion/`

**Formato de Acta**:
```markdown
# Acta de Reunión - Sprint X Review

**Fecha**: DD/MM/YYYY
**Hora**: HH:MM - HH:MM
**Tipo**: Sprint Review
**Asistentes**: 
- Product Owner: [Nombre]
- Scrum Master: [Nombre]
- Desarrollador: [Nombre]
- Usuario Final: [Nombre]

## Temas Tratados
1. Demo de historias completadas (HU-XX a HU-YY)
2. Validación de funcionalidad
3. Retroalimentación de usuario

## Decisiones Tomadas
- Aprobar HU-01 a HU-07 ✅
- Ajustar formato de fecha en HU-07 (fecha transformación)
- Agregar validación adicional en HU-03

## Acciones de Seguimiento
- [ ] Implementar ajuste HU-07 (Responsable: Dev, Fecha: DD/MM)
- [ ] Validar con datos reales HU-03 (Responsable: Usuario, Fecha: DD/MM)

## Próxima Reunión
**Fecha**: DD/MM/YYYY
**Tipo**: Sprint Planning - Sprint 2
```

### Seguimiento Semanal

📂 Ubicación: `documentacion/gestion_proyecto/seguimiento/`

**Reporte Semanal**:
```markdown
# Reporte Semanal - Semana X

**Período**: DD/MM - DD/MM/YYYY
**Sprint**: Sprint X

## Resumen Ejecutivo
- Horas trabajadas: XX/XX (XX%)
- Historias completadas: X/X
- Impedimentos: X

## Progreso por Historia
- HU-XX: 80% (en progreso)
- HU-YY: 100% (completada) ✅
- HU-ZZ: 0% (no iniciada)

## Impedimentos
1. Acceso a servidor SQL pendiente (Soporte TI)
2. Validación de macro VBA requiere usuario final

## Plan Próxima Semana
- Completar HU-XX
- Iniciar HU-ZZ
- Sprint Review viernes XX/XX
```

## 👥 Equipo

### Equipo del Proyecto

| Rol | Nombre | Email | Responsabilidades |
|-----|--------|-------|-------------------|
| **Product Owner** | Coordinador de Riesgos | coordinador.riesgos@cajasocial.com | Definir requerimientos, aprobar entregas |
| **Scrum Master / Líder Proyecto** | Líder RPA | lider.rpa@cajasocial.com | Facilitar proceso, gestionar proyecto |
| **Desarrollador RPA Junior** | [Asignar] | dev.rpa@cajasocial.com | Implementar 21 historias de usuario |
| **Usuario Final / SME** | Carol Patricia Campos González | carol.campos@cajasocial.com | Validar funcionalidad, proveer conocimiento |
| **Analista Funcional** | Analista de Riesgos | analista.riesgos@cajasocial.com | Documentar procesos, validar lógica |
| **Soporte Infraestructura** | Equipo TI | soporte.ti@cajasocial.com | Configurar accesos SQL, VPN, servidores |
| **QA / Tester** | [Asignar] | qa.rpa@cajasocial.com | Ejecutar casos de prueba, validar calidad |

### Matriz RACI

| Actividad | Product Owner | Scrum Master | Dev RPA | Usuario Final | TI |
|-----------|---------------|--------------|---------|---------------|-----|
| Definir requerimientos | **R/A** | C | C | **R** | I |
| Documentar HU | C | **R** | **A** | C | I |
| Desarrollar automatización | I | C | **R/A** | C | C |
| Configurar infraestructura | I | C | C | I | **R/A** |
| Ejecutar pruebas | C | C | **R** | **A** | I |
| Aprobar entregas | **A** | I | R | C | I |
| Deploy a producción | **A** | **R** | C | I | C |

**Leyenda**: R=Responsable, A=Aprobador, C=Consultado, I=Informado

### Contactos de Soporte

#### Soporte Técnico RPA
- **Email**: soporte.rpa@cajasocial.com
- **Teléfono**: Ext. XXXX
- **Horario**: Lunes a Viernes 8:00 AM - 6:00 PM
- **Escalamiento**: lider.rpa@cajasocial.com

#### Soporte Infraestructura
- **Email**: soporte.ti@cajasocial.com
- **Teléfono**: Ext. XXXX
- **Horario**: 24/7 (on-call para producción)
- **Escalamiento**: gerencia.ti@cajasocial.com

#### Soporte Funcional (Proceso de Negocio)
- **Email**: riesgos@cajasocial.com
- **Contacto**: Carol Patricia Campos González
- **Horario**: Lunes a Viernes 8:00 AM - 5:00 PM

### Canales de Comunicación

| Canal | Uso | Frecuencia |
|-------|-----|------------|
| **Email** | Comunicación formal, entregas, aprobaciones | Según necesidad |
| **Microsoft Teams** | Comunicación diaria, consultas rápidas | Diario |
| **Reuniones Presenciales** | Sprint Planning, Review, Retrospective | Semanal/Quincenal |
| **Jira / Azure DevOps** | Seguimiento de tareas, historias de usuario | Diario |
| **Confluence / SharePoint** | Documentación centralizada | Según necesidad |

### Horarios de Disponibilidad

#### Ejecución del Bot (Producción)
- **Frecuencia**: Mensual
- **Día**: Último día hábil del mes
- **Hora**: 08:00 AM (Inicio automático)
- **Duración**: 15 minutos (PAD) o 8 minutos (n8n)
- **Ventana de mantenimiento**: Primer domingo de cada mes, 2:00 AM - 6:00 AM

#### Disponibilidad del Equipo
- **Desarrollo**: Lunes a Viernes, 8:00 AM - 6:00 PM
- **Soporte Producción**: Lunes a Viernes, 7:00 AM - 7:00 PM
- **On-call (Emergencias)**: 24/7 solo para errores críticos de producción

## 📄 Licencia

Este proyecto es **propiedad exclusiva de Banco Caja Social** y es de uso interno únicamente.

**Restricciones**:
- ❌ Prohibida la distribución externa
- ❌ Prohibida la modificación sin autorización
- ❌ Prohibido el uso comercial fuera de la organización
- ✅ Permitido el uso interno por personal autorizado

**Confidencialidad**: Este repositorio contiene información confidencial y procesos críticos del negocio. Todos los colaboradores deben firmar acuerdo de confidencialidad (NDA).

## 📞 Contacto

### Soporte General
- **Email Principal**: rda.costoamortizable@cajasocial.com
- **Soporte RPA**: soporte.rpa@cajasocial.com
- **Soporte Técnico TI**: soporte.ti@cajasocial.com

### Escalamiento
1. **Nivel 1**: Desarrollador RPA (dev.rpa@cajasocial.com)
2. **Nivel 2**: Líder RPA (lider.rpa@cajasocial.com)
3. **Nivel 3**: Coordinador de Riesgos (coordinador.riesgos@cajasocial.com)
4. **Nivel 4**: Gerencia TI / Riesgos (solo para emergencias críticas)

### Reportar Problemas
Para reportar errores o solicitar mejoras, crear issue en GitHub:
- https://github.com/Stiven9710/RDA_Costo_Amortizable/issues

**Plantilla de Issue**:
```markdown
## Tipo
- [ ] Error / Bug
- [ ] Mejora / Enhancement
- [ ] Pregunta / Consulta

## Historia de Usuario Afectada
HU-XX: [Nombre]

## Descripción
[Descripción detallada del problema o solicitud]

## Pasos para Reproducir (si es error)
1. ...
2. ...
3. ...

## Comportamiento Esperado
[Qué debería suceder]

## Comportamiento Actual
[Qué está sucediendo]

## Screenshots/Logs
[Adjuntar evidencia si aplica]

## Prioridad
- [ ] Crítica (Producción detenida)
- [ ] Alta (Afecta múltiples usuarios)
- [ ] Media (Impacto moderado)
- [ ] Baja (Mejora cosmética)
```

## ❓ FAQ (Preguntas Frecuentes)

### Generales

**¿Qué hace este proceso?**
Automatiza el cálculo mensual del Costo Amortizable, procesando reestructuraciones, modificaciones y retenciones de créditos para calcular pérdidas/ganancias financieras.

**¿Cuánto tiempo tarda la ejecución?**
- Power Automate Desktop: ~15 minutos
- n8n: ~8 minutos
- Proceso manual anterior: 14 horas

**¿Con qué frecuencia se ejecuta?**
Mensualmente, el último día hábil de cada mes, iniciando a las 8:00 AM.

**¿Quién puede ejecutar el proceso?**
- **Automático**: El bot se ejecuta sin intervención (programado)
- **Manual**: Usuario autorizado con credenciales RPA

### Técnicas

**¿Qué pasa si el proceso falla?**
- El sistema envía notificación por email al equipo de soporte
- Se registra log detallado en `logs/errores/`
- Se pueden ejecutar hasta 3 reintentos automáticos
- Si persiste, requiere intervención manual

**¿Cómo sé si el proceso se ejecutó correctamente?**
- Recibirás notificación por email con resumen
- Archivo `.xls` generado en `data/output/reportes/`
- Datos cargados en tabla SQL `bd_costo_amortizable_MM_AAAA`
- Log de ejecución sin errores críticos

**¿Puedo ejecutar el proceso para meses anteriores?**
Sí, configurando los parámetros `mes_proceso` y `anio_proceso` al ejecutar manualmente. Útil para reprocesos o validaciones.

**¿Qué hacer si los datos están incompletos?**
El proceso incluye HU-12 que valida completitud y ejecuta query vía Linked Server para completar información faltante. Si aún falta data, se documenta en log y notifica.

**¿Cómo actualizo credenciales SQL?**
Editar archivo `.env` en `config/credenciales/` o actualizar Windows Credential Manager (PAD). Requiere reinicio del servicio.

### Operacionales

**¿Qué archivos genera el proceso?**
- `Consolidacion_Costo_Amortizable_MM_AAAA.xlsx`: Consolidación detallada
- `BASE_FINAL_MM_AAAA.xlsx`: Hoja consolidada final
- `COSTO_AMORTIZABLE_MM_AAAA.xls`: Archivo de entrega (Excel 97-2003)
- `proceso_MM_AAAA.log`: Log de ejecución

**¿Dónde encuentro reportes de meses anteriores?**
- **Archivos**: `data/output/reportes/archivo_historico/`
- **SQL**: Tablas `bd_costo_amortizable_01_2025`, `bd_costo_amortizable_02_2025`, etc.
- **Logs**: `logs/ejecuciones/` organizados por fecha

**¿Puedo modificar el formato del reporte?**
Sí, editando la plantilla en `data/input/plantillas/Plantilla_Consolidacion_vMM_AAAA.xlsx`. Requiere actualizar HU-17 y HU-19, y ejecutar pruebas completas.

**¿Cómo agrego un destinatario de email?**
Editar `config/parametros/configuracion_proceso.json`, agregar email en array `destinatarios_reporte`, y reiniciar servicio.

### Desarrollo

**¿Cómo agrego una nueva historia de usuario?**
1. Crear archivo `HU##_Nombre_Descriptivo.md` en `documentacion/funcional/historias_usuario/backlog/`
2. Seguir plantilla corporativa de `Plantilla_Historia_Usuario_v2.md`
3. Actualizar `Indice_Maestro_Historias_Usuario.md`
4. Estimar esfuerzo y agregar a cronograma
5. Crear feature branch y desarrollar
6. Ejecutar pruebas y crear PR

**¿Qué hacer si necesito cambiar un query SQL?**
1. Editar query en `scripts/sql/`
2. Validar sintaxis en SSMS
3. Probar con datos de prueba
4. Actualizar documentación de HU correspondiente
5. Ejecutar suite de pruebas de regresión
6. Documentar cambio en PR

**¿Cómo depuro errores en PAD?**
- Activar modo debug en Power Automate Desktop (F5 para paso a paso)
- Revisar logs en tiempo real: `logs/ejecuciones/`
- Agregar acciones "Log message" en puntos críticos
- Usar "Display message" para inspeccionar variables

**¿Puedo usar n8n en lugar de PAD?**
Sí, ambas opciones están documentadas. n8n es 47% más rápido (8 min vs 15 min) y no requiere licencias, pero necesita configuración de conectividad Azure↔On-Premise. Ver `documentacion/tecnica/Requisitos_Infraestructura_n8n.md`.

## 🚀 Próximos Pasos

### Roadmap del Proyecto

#### Q4 2025 - Release v1.0 (ACTUAL)
- ✅ Documentación de 21 historias de usuario completada
- ✅ Cronograma de desarrollo definido
- ✅ Diagramas de proceso finalizados
- 🔄 **EN PROGRESO**: Desarrollo Sprint 1 (Extracción y Consolidación)

#### Q1 2026 - Release v1.1
- 🔜 Completar desarrollo de 21 HU
- 🔜 Pruebas de integración y UAT
- 🔜 Deploy a producción
- � Capacitación a usuarios
- 🔜 Monitoreo primer mes

#### Q2 2026 - Release v1.2 (Mejoras)
- 🔮 Dashboard de métricas en tiempo real (Power BI)
- 🔮 Alertas proactivas por WhatsApp/Teams
- 🔮 Integración con sistema de auditoría
- 🔮 Backup automático en la nube

#### Q3 2026 - Release v2.0 (Evolución)
- 🔮 Migración a n8n en Azure Cloud
- 🔮 Paralelización de procesos (8 min → 5 min)
- 🔮 API REST para consultas externas
- 🔮 Machine Learning para detección de anomalías

### Backlog de Mejoras

📂 `documentacion/funcional/historias_usuario/backlog/`

**Alta Prioridad**:
- HU-22: Integración con sistema de notificaciones corporativo
- HU-23: Generación automática de gráficos ejecutivos
- HU-24: Validación cruzada con sistema contable

**Media Prioridad**:
- HU-25: Dashboard de monitoreo en tiempo real
- HU-26: Exportación a múltiples formatos (PDF, CSV, JSON)
- HU-27: Historial de cambios y auditoría completa

**Baja Prioridad**:
- HU-28: Modo simulación para escenarios What-If
- HU-29: Integración con chatbot de consultas
- HU-30: App móvil para aprobaciones

### Contribuir al Roadmap

Si tienes ideas para mejorar el proceso:
1. Crear issue en GitHub con etiqueta "enhancement"
2. Proponer en Sprint Retrospective
3. Discutir con Product Owner
4. Agregar a backlog si se aprueba

---

## 📚 Referencias y Enlaces

### Documentación Interna
- [Índice Maestro de Historias de Usuario](documentacion/funcional/historias_usuario/Indice_Maestro_Historias_Usuario.md)
- [PDD Completo](documentacion/funcional/pdd/PDD_RDA_Costo_Amortizable_v1.0.md)
- [Cronograma de Desarrollo](documentacion/gestion_proyecto/cronograma/Cronograma_Desarrollo_RDA_Costo_Amortizable.md)
- [Requisitos PAD](documentacion/tecnica/Requisitos_Infraestructura_PAD.md)
- [Requisitos n8n](documentacion/tecnica/Requisitos_Infraestructura_n8n.md)

### Recursos Externos
- [Power Automate Desktop - Documentación Oficial](https://docs.microsoft.com/power-automate/desktop-flows/)
- [n8n - Documentación](https://docs.n8n.io/)
- [SQL Server - Best Practices](https://docs.microsoft.com/sql/sql-server/)
- [Git Flow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)

### Repositorio GitHub
- **URL**: https://github.com/Stiven9710/RDA_Costo_Amortizable
- **Branch Principal**: `main` (producción)
- **Branch Desarrollo**: `develop` (integración)
- **Issues**: https://github.com/Stiven9710/RDA_Costo_Amortizable/issues
- **Releases**: https://github.com/Stiven9710/RDA_Costo_Amortizable/releases

---

<div align="center">

**RDA Costo Amortizable - Banco Caja Social**

*Automatización que transforma 14 horas de trabajo manual en 15 minutos de ejecución inteligente*

📅 **Última actualización**: Noviembre 2025  
📌 **Versión**: 1.0.0  
✅ **Estado**: Documentación Completa - Listo para Desarrollo

**[⬆ Volver arriba](#rda-costo-amortizable---automatización-rpa)**

</div>