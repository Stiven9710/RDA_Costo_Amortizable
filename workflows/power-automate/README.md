# 🤖 Flujos Power Automate Desktop - RDA Costo Amortizable

Este directorio contiene los flujos PAD del Robot de Automatización de Costo Amortizable, un proceso mensual crítico de la Coordinación de Portafolio del Banco Caja Social.

## 📂 Estructura de Carpetas

```
workflows/power-automate/
│
├── Main.robin                          # 🎯 ORQUESTADOR PRINCIPAL
│   └── Entry point del RDA, coordina la ejecución completa
│
├── subprocesos/                        # 📦 SUBFLUJOS ORGANIZADOS POR CAPAS
│   │
│   ├── 00_Configuracion/               # ⚙️ CAPA 00: Configuración e Inicialización
│   │   ├── [Configuracion]-Configuracion.robin
│   │   │   └── Carga JSON, crea carpetas, prepara entorno
│   │   └── [Configuracion]-DepuracionCarpetas.robin
│   │       └── Limpieza mensual de carpetas antiguas
│   │
│   ├── 01_Extraccion/                  # 📥 CAPA 01: Extracción de Datos (PLACEHOLDER)
│   ├── 02_Consolidacion/               # 🔄 CAPA 02: Consolidación (PLACEHOLDER)
│   ├── 03_Organizacion/                # 📋 CAPA 03: Organización (PLACEHOLDER)
│   ├── 04_Cargue/                      # 💾 CAPA 04: Cargue a SQL (PLACEHOLDER)
│   ├── 05_Validacion/                  # ✅ CAPA 05: Validación (PLACEHOLDER)
│   ├── 06_Calculos/                    # 🧮 CAPA 06: Cálculos Financieros (PLACEHOLDER)
│   ├── 07_Ejecucion/                   # ▶️ CAPA 07: Ejecución de Macros (PLACEHOLDER)
│   ├── 08_FormatoFinal/                # 📊 CAPA 08: Formato Final (PLACEHOLDER)
│   ├── 09_Cargue_Final/                # 🚀 CAPA 09: Cargue Final (PLACEHOLDER)
│   │
│   ├── 10_Maestra/                     # 🎛️ CAPA 10: Maestra Coordinadora
│   │   └── [Maestra]-MaestraGestion.robin
│   │       └── Coordina subflujos de negocio CAPA 01-09
│   │
│   ├── 99_Funciones/                   # 🔧 CAPA 99: Funciones Utilitarias
│   │   ├── [Funcion]-CapturaPantalla.robin
│   │   │   └── Captura screenshots con numeración consecutiva
│   │   ├── [Funcion]-EnvioNotificacion.robin
│   │   │   └── Envío de correos con 7 tipos de plantillas HTML
│   │   └── [Funcion]-FormatearFechaHora.robin
│   │       └── Formateo de fecha/hora con formatos personalizados
│   │
│   └── Excel/                          # 📈 HELPERS: Operaciones Excel
│       └── [Excel]-GenerarReporteGestion.robin
│           └── Escritura en reporte Excel de gestión
│
└── plantillas/                         # 📝 TEMPLATES para Desarrollo
    ├── Plantilla_Con_Reintento.robin
    │   └── Template con lógica de N reintentos automáticos
    └── Plantilla_Sin_Reintento.robin
        └── Template sin reintentos, error inmediato
```

---

## 🚀 Flujos Disponibles

### Orquestador Principal

| Flujo | Descripción | Ubicación |
|-------|-------------|-----------|
| **Main.robin** | Orquestador principal que coordina la ejecución completa del RDA | `Main.robin` |

### CAPA 00: Configuración

| Flujo | Descripción | Ubicación |
|-------|-------------|-----------|
| **[Configuracion]-Configuracion.robin** | Inicialización del entorno: carga JSON, crea carpetas, cierra apps previas | `subprocesos/00_Configuracion/` |
| **[Configuracion]-DepuracionCarpetas.robin** | Limpieza mensual de carpetas del mes anterior | `subprocesos/00_Configuracion/` |

### CAPA 10: Maestra Coordinadora

| Flujo | Descripción | Ubicación |
|-------|-------------|-----------|
| **[Maestra]-MaestraGestion.robin** | Coordina la ejecución de subflujos de negocio CAPA 01-09 | `subprocesos/10_Maestra/` |

### CAPA 99: Funciones Utilitarias

| Flujo | Descripción | Ubicación |
|-------|-------------|-----------|
| **[Funcion]-CapturaPantalla.robin** | Captura screenshots de proceso o error con nomenclatura estandarizada | `subprocesos/99_Funciones/` |
| **[Funcion]-EnvioNotificacion.robin** | Envío de notificaciones por correo con plantillas HTML (INICIO, FIN, PCC, PCNC, DIANOHABIL, LOGS y REPORTE, PERSONALIZADO) | `subprocesos/99_Funciones/` |
| **[Funcion]-FormatearFechaHora.robin** | Formateo de fecha/hora actual con formatos personalizados | `subprocesos/99_Funciones/` |

### Helpers Excel

| Flujo | Descripción | Ubicación |
|-------|-------------|-----------|
| **[Excel]-GenerarReporteGestion.robin** | Escritura de datos de ejecución en reporte Excel de gestión | `subprocesos/Excel/` |

### Plantillas para Desarrollo

| Plantilla | Descripción | Ubicación |
|-----------|-------------|-----------|
| **Plantilla_Con_Reintento.robin** | Template con lógica de reintentos automáticos (parametrizable) | `plantillas/` |
| **Plantilla_Sin_Reintento.robin** | Template sin reintentos, error inmediato con notificación PCNC | `plantillas/` |

---

## 📖 Documentación

### 📘 Manual Técnico Completo

**Ubicación**: `documentacion/tecnica/Manual_Tecnico_Flujos_PAD.md`

**Contenido**:
- ✅ Arquitectura de flujos por capas
- ✅ Documentación detallada de los 10 flujos base
- ✅ Variables globales compartidas (JSON)
- ✅ Convenciones de desarrollo (nomenclatura, estructura, logs)
- ✅ Diagramas de flujo Mermaid
- ✅ Casos de prueba por cada flujo
- ✅ Manejo de errores (PCC y PCNC)
- ✅ Anexos (plantilla de documentación, checklist de desarrollo)

### 📚 Otros Documentos Técnicos

| Documento | Ubicación | Descripción |
|-----------|-----------|-------------|
| **Diseño de Arquitectura RDA** | `documentacion/tecnica/Diseno_Arquitectura_RDA_Costo_Amortizable.md` | Arquitectura completa de 5 capas, componentes, diagramas |
| **Requisitos Infraestructura PAD** | `documentacion/tecnica/Requisitos_Infraestructura_PAD.md` | Requisitos de software, hardware, permisos |
| **PDD v1.0** | `documentacion/funcional/pdd/PDD_RDA_Costo_Amortizable_v1.0.md` | Process Design Document completo (89 páginas) |

---

## 🔧 Cómo Usar

### Ejecutar el RDA

#### Opción 1: Ejecución Manual (RDA - Atendido)

1. **Abrir Power Automate Desktop**
2. **Importar el flujo principal**:
   - File → Import → Seleccionar `Main.robin`
3. **Configurar variables de entorno**:
   - Editar `config/Configuracion_Maestro.json`
   - Editar `config/Configuracion_Maquina.json`
4. **Validar equipo autorizado**:
   - Agregar `COMPUTERNAME` en `Configuracion_Maestro.json` → `maquinasAutorizadas`
5. **Ejecutar el flujo**:
   - Seleccionar `Main.robin` → Click en "Run"
6. **Monitorear ejecución**:
   - Ver logs en tiempo real en consola PAD
   - Logs detallados en `Ejecuciones/{AAAA}/{MM}/Logs/`

#### Opción 2: Ejecución Programada (Futuro)

1. **Configurar trigger en Power Automate Desktop**:
   - Programar ejecución mensual (último día hábil)
   - Configurar horario (recomendado: 08:00 AM)
2. **Notificaciones automáticas**:
   - Correo de INICIO al iniciar
   - Correo de FIN al completar
   - Correo de PCC/PCNC en caso de error

### Crear Nuevo Flujo

#### Paso 1: Seleccionar Plantilla

- **¿El proceso puede fallar temporalmente?** → Usar `Plantilla_Con_Reintento.robin`
  - Ejemplos: Conexión SQL, apertura de Excel, descarga de archivos
- **¿El proceso no requiere reintentos?** → Usar `Plantilla_Sin_Reintento.robin`
  - Ejemplos: Validaciones, transformaciones, lectura de datos

#### Paso 2: Copiar y Renombrar

```bash
# Ejemplo: Crear nuevo flujo de extracción
cp plantillas/Plantilla_Con_Reintento.robin subprocesos/01_Extraccion/[Extraccion]-ExtraccionDWH.robin
```

#### Paso 3: Personalizar el Flujo

1. **Buscar y reemplazar**:
   - Reemplazar `SubflujoConReintento` con `ExtraccionDWH`
   - Reemplazar `Plantilla_Con_Reintento` con `[Extraccion]-ExtraccionDWH`

2. **Implementar lógica**:
   ```
   @REGION Proceso Principal
       @# ================================================
       @# Insertar lógica de extracción aquí
       @# ================================================
       
       @# Ejemplo: Conexión a SQL
       SQL.OpenConnection ConnectionString: gblStrSQLConnectionString Connection: sqlConnection
       
       @# Ejemplo: Ejecutar query
       SQL.ExecuteQuery Connection: sqlConnection Query: "SELECT * FROM tabla" Result: dataTable
       
       @# ================================================
       @# FIN Lógica de Extracción
       @# ================================================
   @ENDREGION
   ```

3. **Configurar manejo de errores**:
   - Definir si es PCC (crítico) o PCNC (no crítico)
   - Agregar logging detallado

#### Paso 4: Integrar en Maestra

Editar `subprocesos/10_Maestra/[Maestra]-MaestraGestion.robin`:

```
@REGION Invocación de Subflujos de Negocio CAPA 01-09
    @# CAPA 01: Extracción
    CALL [Extraccion]-ExtraccionDWH
    
    @# Validar éxito
    IF gblObjVariablesGenerales.estadoProceso = "False" THEN
        @# Manejar error
        EXIT BLOCK
    END
    
    @# CAPA 02-09: Resto de subflujos...
@ENDREGION
```

#### Paso 5: Documentar

Agregar sección en `documentacion/tecnica/Manual_Tecnico_Flujos_PAD.md` usando la plantilla del Anexo A.

---

## 🧪 Pruebas

### Casos de Prueba Resumidos

Los casos de prueba detallados están documentados en el **Manual Técnico** para cada flujo. A continuación un resumen:

| Flujo | Casos de Prueba | Estado |
|-------|----------------|--------|
| **Main.robin** | TC-001 a TC-005 (5 casos) | ✅ Documentados |
| **[Configuracion]-Configuracion.robin** | TC-CFG-001 a TC-CFG-005 (5 casos) | ✅ Documentados |
| **[Configuracion]-DepuracionCarpetas.robin** | TC-DEP-001 a TC-DEP-004 (4 casos) | ✅ Documentados |
| **[Maestra]-MaestraGestion.robin** | TC-MAE-001 a TC-MAE-003 (3 casos) | ✅ Documentados |
| **[Funcion]-CapturaPantalla.robin** | TC-CAP-001 a TC-CAP-004 (4 casos) | ✅ Documentados |
| **[Funcion]-EnvioNotificacion.robin** | TC-NOT-001 a TC-NOT-004 (4 casos) | ✅ Documentados |
| **[Funcion]-FormatearFechaHora.robin** | TC-FOR-001 a TC-FOR-003 (3 casos) | ✅ Documentados |
| **[Excel]-GenerarReporteGestion.robin** | TC-REP-001 a TC-REP-003 (3 casos) | ✅ Documentados |

### Ejecución de Pruebas

1. **Preparar entorno de prueba**:
   - Copiar archivos JSON de configuración a carpeta de desarrollo
   - Agregar equipo de desarrollo en `maquinasAutorizadas`
   - Configurar rutas de prueba

2. **Ejecutar pruebas unitarias**:
   - Probar cada subflujo individualmente
   - Validar logs generados
   - Verificar capturas de pantalla

3. **Ejecutar prueba end-to-end**:
   - Ejecutar `Main.robin` completo
   - Validar secuencia de invocación
   - Verificar notificaciones por correo

---

## 🐛 Troubleshooting

### Errores Comunes

| Error | Síntoma | Causa Probable | Solución |
|-------|---------|----------------|----------|
| **CFG-001** | "Archivo Configuracion_Maestro.json no encontrado" | Archivo JSON faltante | Crear archivo en `config/Configuracion_Maestro.json` |
| **CFG-002** | "Equipo no autorizado" | COMPUTERNAME no está en lista | Agregar equipo en `maquinasAutorizadas` del JSON Maestro |
| **PCC-001** | "Error en Configuracion" | Error en carga de JSON | Validar sintaxis JSON con linter |
| **Screenshot no guardado** | Captura de pantalla no se crea | Permisos de escritura en carpeta | Validar permisos en carpeta de Capturas |
| **Correo no enviado** | Notificación no llega | Credenciales SMTP incorrectas | Reconfigurar `smtpServer` y `smtpPort` en JSON Maestro |

### Validar Configuración

```powershell
# Verificar estructura de carpetas
Test-Path "C:\RDA_CostoAmortizable\Ejecuciones"

# Verificar archivos JSON
Get-Content "config/Configuracion_Maestro.json" | ConvertFrom-Json

# Verificar permisos de escritura
New-Item -Path "C:\RDA_CostoAmortizable\Ejecuciones\test.txt" -ItemType File
```

### Logs para Diagnóstico

**Log de Sistema** (errores detallados):
```
Ubicación: Ejecuciones/{AAAA}/{MM}/Logs/Log_Sistema_YYYYMMDD.csv
Formato: Timestamp,Nivel,Subflujo,Mensaje
```

**Log de Auditoría** (eventos clave):
```
Ubicación: Ejecuciones/{AAAA}/{MM}/Logs/Log_Auditoria_YYYYMMDD.csv
Formato: Evento,Fecha,Hora,Observaciones
```

### Soporte

**Contactos**:
- **Desarrollador RPA**: Ronald Estiven Rios Hernandez (rriosh@fgs.co)
- **Especialista RPA**: Jeimy Johana Lozano Garnica (jelozanog@fgs.co)
- **Usuario Funcional**: Carol Patricia Campos González (ccamposg@fgs.co)

**Reportar Issues**:
- GitHub Issues: https://github.com/Stiven9710/RDA_Costo_Amortizable/issues

---

## 👥 Información de Contacto

**Desarrollador**: Ronald Estiven Rios Hernandez  
**Email**: rriosh@fgs.co

**Especialista RPA**: Jeimy Johana Lozano Garnica  
**Email**: jelozanog@fgs.co

**Coordinadora de Portafolio**: Carol Patricia Campos González  
**Email**: ccamposg@fgs.co

---

## 📄 Licencia

**Propiedad exclusiva de Banco Caja Social** - Uso interno únicamente.

**Restricciones**:
- ❌ Prohibida distribución externa
- ❌ Prohibida modificación sin autorización
- ✅ Permitido uso interno por personal autorizado

---

## 📊 Estadísticas del Proyecto

**Flujos Implementados**: 10 de 10 ✅  
**Capas Documentadas**: 6 (Orquestador, CAPA 00, CAPA 10, CAPA 99, Excel, Plantillas)  
**Líneas de Código PAD**: ~1,200 líneas  
**Documentación Técnica**: 1,300+ líneas  
**Casos de Prueba**: 31 casos documentados

---

<div align="center">

**RDA Costo Amortizable - Power Automate Desktop**

*Automatización que transforma 14 horas de trabajo manual en 15 minutos de ejecución inteligente*

📅 **Última actualización**: 12 de diciembre de 2025  
📌 **Versión**: 1.0.0  
✅ **Estado**: En Desarrollo - Arquitectura Base Completada

**[⬆ Volver arriba](#-flujos-power-automate-desktop---rda-costo-amortizable)**

</div>
