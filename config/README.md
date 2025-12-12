# 📁 Configuración del Proyecto RDA Costo Amortizable

Este directorio contiene los archivos de configuración necesarios para el funcionamiento del proceso RDA (Remote Desktop Automation) de Costo Amortizable.

---

## 📂 Estructura de Carpetas

```
config/
├── parametros/                      # Parámetros operativos del proceso
│   ├── Configuracion_Maestro.json   # Configuración de máquinas BR1/BR2
│   └── Configuracion_Maquina.json   # Configuración operativa completa
├── credenciales/                    # Variables de entorno y credenciales
│   └── .env                        # Credenciales SQL, SMTP (NO SUBIR A GIT)
├── conexiones/                      # Endpoints y conexiones
│   └── conexiones_sql.json         # Cadenas de conexión SQL Server
└── README.md                        # Este archivo
```

---

## 📄 Archivos de Configuración

### 1. `Configuracion_Maestro.json`

**Propósito:** Define las máquinas del entorno RPA y su rol en la orquestación.

**Estructura:**
```json
{
  "configuracion": {
    "BOA02SRVVCORP": {
      "numeroMaquina": "BR1",
      "ipMaquina": "10.1.2.58",
      "rol": "Principal",
      "descripcion": "Máquina orquestadora - Producción"
    },
    "BOA07DESINTDP17": {
      "numeroMaquina": "BR2",
      "ipMaquina": "10.1.2.59",
      "rol": "Secundaria",
      "descripcion": "Máquina de desarrollo"
    }
  }
}
```

**Campos:**
- `numeroMaquina`: Identificador BR (BR1, BR2, etc.)
- `ipMaquina`: Dirección IP de la máquina
- `rol`: Principal (producción) o Secundaria (desarrollo/backup)
- `descripcion`: Descripción del propósito de la máquina

---

### 2. `Configuracion_Maquina.json`

**Propósito:** Contiene todos los parámetros operativos del proceso RDA, organizados en 13 secciones funcionales.

#### Secciones del Archivo:

##### 🌐 **Sección 1: `globales`**

Parámetros generales del proceso RDA.

**Campos principales:**
- `numeroMaquinaBR`: Número de máquina asignado (BR1, BR2)
- `nombreAsistente`: Nombre del asistente RPA ("CostoAmortizable")
- `ambiente`: Desarrollo | Pruebas | Producción
- `numeroIntentosLogin`: Reintentos para iniciar sesión
- `numeroIntentosProceso`: Reintentos en caso de error
- `rutaArchivosTemporales`: Ubicación de archivos temporales
- `rutaDescarga`: Carpeta de descargas del navegador
- `rutaLibreriasPython`: Ruta a librerías Python (ej: `C:\\Python312\\Lib`)
- `aplicacionesCerrar`: Lista de aplicaciones a cerrar (separadas por `|`)
- `tiempoEsperaInterfaz*`: Tiempos de espera (MuyBajo: 10s, Bajo: 30s, Medio: 60s, Alto: 120s, MuyAlto: 300s)

**Ejemplo de uso en PAD:**
```vbnet
' Cargar configuración global
Json.ParseJson File: '%ConfigPath%\\Configuracion_Maquina.json' Json=> JsonConfig

' Obtener valores globales
SET nombreAsistente TO JsonConfig['configuracion']['globales']['nombreAsistente']
SET ambiente TO JsonConfig['configuracion']['globales']['ambiente']
SET numeroIntentosLogin TO JsonConfig['configuracion']['globales']['numeroIntentosLogin']
```

---

##### 📧 **Sección 2: `envioNotificaciones`**

Configuración de notificaciones por correo electrónico.

**Campos principales:**
- `correoDesde`: Dirección de correo remitente
- `correoPara`: Destinatarios principales (separados por `;`)
- `correoCC`: Copia (opcional)
- `correoCCO`: Copia oculta (opcional)
- `plantillas`: Tres plantillas (exitoso, error, advertencia)
  - `asunto`: Asunto del correo (admite variables: `{fecha}`, `{hora}`)
  - `cuerpoHTML`: Cuerpo en formato HTML (admite variables dinámicas)
  - `adjuntarReporte`: "True" | "False" (string para PAD)
  - `adjuntarCapturas`: "True" | "False"

**Variables dinámicas disponibles:**
- `{fecha}`: Fecha de ejecución (formato DD/MM/YYYY)
- `{hora}`: Hora de ejecución (formato HH:MM:SS)
- `{cantidadRegistros}`: Número de registros procesados
- `{tiempoEjecucion}`: Tiempo total en minutos
- `{descripcionError}`: Descripción del error (plantilla error)
- `{nombreFlujo}`: Nombre del flujo afectado

**Ejemplo de uso en PAD:**
```vbnet
' Cargar plantilla de email exitoso
SET plantillaExito TO JsonConfig['configuracion']['envioNotificaciones']['plantillas']['exitoso']
SET asunto TO plantillaExito['asunto']
SET cuerpoHTML TO plantillaExito['cuerpoHTML']

' Reemplazar variables dinámicas
Text.Replace Text: asunto TextToFind: '{fecha}' IsRegEx: False ReplaceWith: '%FechaEjecucion%' IgnoreCase: False Result=> asuntoFinal
Text.Replace Text: cuerpoHTML TextToFind: '{cantidadRegistros}' IsRegEx: False ReplaceWith: '%TotalRegistros%' IgnoreCase: False Result=> cuerpoFinal

' Enviar email
Email.SendEmail.SendWithExchange SMTPServer: '%HostSMTP%' ServerPort: '%PuertoSMTP%' From: '%CorreoDesde%' To: '%CorreoPara%' Subject: asuntoFinal Body: cuerpoFinal
```

---

##### 📝 **Sección 3: `logs`**

Configuración de archivos de log del proceso.

**Campos principales:**
- `nombreLogSistema`: Nombre del log del sistema (ej: `SSSIIIIIII_LOG_DE_SISTEMA_YYYYMMDD.csv`)
- `rutaLogSistema`: Ruta completa del archivo de log
- `nombreLogAuditoria`: Nombre del log de auditoría
- `rutaLogAuditoria`: Ruta completa
- `nombreLogPython`: Nombre del log de scripts Python
- `rutaLogPython`: Ruta completa

**Nota sobre nomenclatura:**
- `SSSIIIIIII`: Prefijo del sistema (9 caracteres)
- `YYYYMMDD`: Fecha en formato año-mes-día

**Ejemplo de uso en PAD:**
```vbnet
' Construir ruta de log del día
DateTime.GetCurrentDateTime CurrentDateTime=> FechaActual
DateTime.FormatDateTime DateTime: FechaActual FormatToUse: DateTime.DateTimeFormat.Custom CustomFormat: 'yyyyMMdd' Result=> FechaFormateada

SET nombreLogSistema TO JsonConfig['configuracion']['logs']['nombreLogSistema']
Text.Replace Text: nombreLogSistema TextToFind: 'YYYYMMDD' ReplaceWith: '%FechaFormateada%' Result=> nombreLogFinal

' Escribir en log
File.WriteText File: '%RutaLogs%\\%nombreLogFinal%' TextToWrite: '%MensajeLog%' AppendNewLine: True
```

---

##### 🔧 **Sección 4: `depuracion`**

Configuración de limpieza automática de archivos.

**Campos principales:**
- `diaEliminacion`: Día del mes para ejecutar limpieza (ej: "25")

**Ejemplo de uso en PAD:**
```vbnet
' Verificar si corresponde eliminar archivos antiguos
DateTime.GetCurrentDateTime CurrentDateTime=> FechaActual
SET diaActual TO FechaActual.Day
SET diaEliminacion TO JsonConfig['configuracion']['depuracion']['diaEliminacion']

IF diaActual = diaEliminacion THEN
    ' Ejecutar limpieza de archivos temporales mayores a 90 días
    Folder.GetFiles Folder: '%RutaTemp%' FilesFound=> Archivos
    LOOP FOREACH archivo IN Archivos
        IF archivo.LastWriteTime < DateTime.Now.AddDays(-90) THEN
            File.Delete File: archivo.FullPath
        END IF
    END LOOP
END IF
```

---

##### 📸 **Sección 5: `capturasPantalla`**

Configuración de capturas de pantalla del proceso.

**Campos principales:**
- `consecutivoCapturaPantalla`: Contador inicial ("0")
- `cantidadMaximoConsecutivo`: Máximo consecutivo antes de reiniciar ("9999")
- `nombreCapturaPantallaError`: Formato del nombre para errores
- `rutaCapturasPantallaError`: Ruta de almacenamiento de errores
- `nombreCapturaPantallaProceso`: Formato del nombre para proceso normal
- `rutaCapturasPantallaProceso`: Ruta de almacenamiento de proceso

**Ejemplo de uso en PAD:**
```vbnet
' Capturar pantalla en caso de error
Variables.IncreaseVariable Value: %consecutivoCaptura%

IF consecutivoCaptura > JsonConfig['configuracion']['capturasPantalla']['cantidadMaximoConsecutivo'] THEN
    SET consecutivoCaptura TO 0
END IF

SET nombreCaptura TO JsonConfig['configuracion']['capturasPantalla']['nombreCapturaPantallaError']
Text.Replace Text: nombreCaptura TextToFind: 'CONSECUTIVO' ReplaceWith: consecutivoCaptura Result=> nombreCapturaFinal

Screen.TakeScreenshot CaptureMode: Screen.CaptureMode.AllScreens ImageFile: '%RutaCapturas%\\%nombreCapturaFinal%'
```

---

##### 📊 **Sección 6: `reporteGestion`**

Configuración del reporte de gestión mensual.

**Campos principales:**
- `nombreReporte`: Nombre del archivo de reporte (ej: `SSSIIIIIII_INFORMEGESTION_YYYYMMDD.xlsx`)
- `rutaReporteGestion`: Ruta de almacenamiento
- `fechaReporte`: Fecha del reporte (se actualiza dinámicamente)

**Ejemplo de uso en PAD:**
```vbnet
' Generar nombre del reporte del mes
DateTime.GetCurrentDateTime CurrentDateTime=> FechaActual
DateTime.FormatDateTime DateTime: FechaActual FormatToUse: DateTime.DateTimeFormat.Custom CustomFormat: 'yyyyMMdd' Result=> FechaFormateada

SET nombreReporte TO JsonConfig['configuracion']['reporteGestion']['nombreReporte']
Text.Replace Text: nombreReporte TextToFind: 'YYYYMMDD' ReplaceWith: '%FechaFormateada%' Result=> nombreReporteFinal
SET rutaCompleta TO JsonConfig['configuracion']['reporteGestion']['rutaReporteGestion'] & nombreReporteFinal
```

---

##### 📬 **Sección 7: `variablesSMTP`**

Configuración del servidor SMTP para envío de correos.

**Campos principales:**
- `hostSMTP`: Dirección del servidor SMTP (ej: "10.1.3.83")
- `puertoSMTP`: Puerto del servidor (ej: "25")

**Ejemplo de uso en PAD:**
```vbnet
' Configurar conexión SMTP
SET hostSMTP TO JsonConfig['configuracion']['variablesSMTP']['hostSMTP']
SET puertoSMTP TO JsonConfig['configuracion']['variablesSMTP']['puertoSMTP']

Email.SendEmail.SendWithExchange SMTPServer: hostSMTP ServerPort: puertoSMTP From: '%CorreoDesde%' To: '%CorreoPara%' Subject: '%Asunto%' Body: '%Cuerpo%'
```

---

##### 🗄️ **Sección 8: `variablesDB`**

Configuración de parámetros de base de datos.

**Campos principales:**
- `timeOutSegundos`: Timeout de ejecución de queries (ej: "600" = 10 minutos)

**Ejemplo de uso en PAD:**
```vbnet
' Configurar timeout de conexión SQL
SET timeoutDB TO JsonConfig['configuracion']['variablesDB']['timeOutSegundos']

Sql.OpenConnection Connection: '%ConnectionString%' Timeout: timeoutDB SqlConnection=> SqlConn
```

---

##### 🔌 **Sección 9: `conexionesSQL`**

Configuración de conexiones a bases de datos SQL Server.

**Subsecciones:**
- `dwh_cc`: Conexión a DWH_CC (Data Warehouse Caja Social)
- `dwh_riesgos`: Conexión a DWH_Riesgos_Credito

**Campos por conexión:**
- `servidor`: Dirección del servidor (ej: `"10.1.3.101\\SCC"`)
  - ⚠️ **Importante:** Usar doble backslash `\\` para escapar en JSON
- `baseDatos`: Nombre de la base de datos
- `puerto`: Puerto de conexión (típicamente "1433")
- `autenticacion`: "Windows" | "SQLServer"
- `timeoutConexion`: Timeout de conexión en segundos
- `timeoutComando`: Timeout de ejecución de comandos en segundos
- `habilitarLinkedServer`: "True" | "False" (string para PAD)

**Ejemplo de uso en PAD:**
```vbnet
' Conectar a DWH_CC
SET configDWH TO JsonConfig['configuracion']['conexionesSQL']['dwh_cc']
SET servidor TO configDWH['servidor']
SET baseDatos TO configDWH['baseDatos']
SET timeoutConexion TO configDWH['timeoutConexion']

Sql.OpenConnection ConnectionString: 'Data Source=%servidor%;Initial Catalog=%baseDatos%;Integrated Security=True;Connection Timeout=%timeoutConexion%;' SqlConnection=> SqlConnDWH

' Ejecutar query con timeout de comando
SET querySQL TO 'SELECT * FROM [ANDREAL].[Costo_Amortizado_001_Reestructurados_Acum]'
Sql.ExecuteQuery Connection: SqlConnDWH SqlQuery: querySQL Timeout: configDWH['timeoutComando'] QueryResult=> ResultadoQuery

' Cerrar conexión
Sql.CloseConnection Connection: SqlConnDWH
```

---

##### 📑 **Sección 10: `archivosExcel`**

Configuración de archivos Excel utilizados en el proceso.

**Subsecciones:**
- `plantillaBase`: Configuración de la plantilla Excel base
- `archivoSalida`: Configuración del archivo de salida
- `macrosVBA`: Configuración de ejecución de macros

**Campos de `plantillaBase`:**
- `nombre`: Nombre del archivo de plantilla
- `ubicacionRelativa`: Ruta relativa desde la raíz del proyecto
- `hojas`: Objeto con nombres de las hojas del archivo
  - `reestructurados`, `reestructuradosIndividual`
  - `modificados`, `modificadosIndividual`
  - `retenciones`, `retencionesIndividual`
  - `consolidadaBASE`

**Campos de `archivoSalida`:**
- `nombre`: Formato del nombre de salida (admite `YYYYMMDD`)
- `formato`: "Excel97-2003" (genera archivos .xls)
- `ubicacionRelativa`: Ruta relativa de salida (admite `YYYY`, `MM`)

**Campos de `macrosVBA`:**
- `nombreMacro`: Nombre de la macro a ejecutar
- `habilitarMacros`: "True" | "False"
- `tiempoEjecucionMaxSegundos`: Timeout de ejecución de la macro

**Ejemplo de uso en PAD:**
```vbnet
' Abrir plantilla Excel
SET configExcel TO JsonConfig['configuracion']['archivosExcel']
SET nombrePlantilla TO configExcel['plantillaBase']['nombre']
SET rutaPlantilla TO '%RutaProyecto%' & configExcel['plantillaBase']['ubicacionRelativa'] & nombrePlantilla

Excel.LaunchExcel LaunchUnderAccount: Excel.LaunchAccount.Interactive Visible: True ReadOnly: False LoadAddInsAndMacros: True Instance=> ExcelInstance
Excel.OpenWorkbook Instance: ExcelInstance DocumentPath: rutaPlantilla ReadOnly: False

' Activar hoja de reestructurados
SET nombreHoja TO configExcel['plantillaBase']['hojas']['reestructurados']
Excel.ActivateCell.ActivateCellWithWorksheetName Instance: ExcelInstance WorksheetName: nombreHoja

' Ejecutar macro VBA
IF configExcel['macrosVBA']['habilitarMacros'] = 'True' THEN
    SET nombreMacro TO configExcel['macrosVBA']['nombreMacro']
    Excel.RunMacro Instance: ExcelInstance Macro: nombreMacro
END IF

' Guardar como Excel 97-2003
DateTime.FormatDateTime DateTime: %FechaActual% FormatToUse: DateTime.DateTimeFormat.Custom CustomFormat: 'yyyyMMdd' Result=> FechaFormateada
SET nombreSalida TO configExcel['archivoSalida']['nombre']
Text.Replace Text: nombreSalida TextToFind: 'YYYYMMDD' ReplaceWith: FechaFormateada Result=> nombreSalidaFinal

Excel.SaveAs Instance: ExcelInstance DocumentFormat: Excel.Format.ExcelWorkbook_xls DocumentPath: '%RutaSalida%\\%nombreSalidaFinal%'
```

---

##### 🐍 **Sección 11: `scriptsPython`**

Configuración de scripts Python auxiliares del proceso.

**Campos principales:**
- `rutaEjecutablePython`: Ruta al ejecutable de Python (ej: `"C:\\Python312\\python.exe"`)
- `rutaScripts`: Ruta relativa a los scripts Python
- `timeoutEjecucionSegundos`: Timeout global para scripts Python
- `scripts`: Objeto con configuración de cada script
  - `calculos_financieros`: Script para cálculos de tasas ponderadas
  - `validaciones`: Script para validar completitud de datos
  - `transformaciones`: Script para transformar fechas

**Campos por script:**
- `nombre`: Nombre del archivo .py
- `habilitado`: "True" | "False"
- `argumentos`: Argumentos de línea de comandos

**Ejemplo de uso en PAD:**
```vbnet
' Ejecutar script Python de cálculos financieros
SET configPython TO JsonConfig['configuracion']['scriptsPython']
SET scriptCalculo TO configPython['scripts']['calculos_financieros']

IF scriptCalculo['habilitado'] = 'True' THEN
    SET rutaPython TO configPython['rutaEjecutablePython']
    SET rutaScript TO '%RutaProyecto%' & configPython['rutaScripts'] & scriptCalculo['nombre']
    SET argumentos TO scriptCalculo['argumentos']
    
    System.RunApplication ApplicationPath: rutaPython CommandLineArguments: '"%rutaScript%" %argumentos%' WindowStyle: System.ProcessWindowStyle.Hidden Timeout: configPython['timeoutEjecucionSegundos'] ProcessId=> ProcessId
    
    System.WaitForProcess ProcessId: ProcessId
END IF
```

---

##### ✅ **Sección 12: `puntosControl`**

Configuración de puntos de control del proceso (7 puntos críticos).

**Campos principales:**
- `PC01_extraccionDWH`: "True" | "False" - Validar extracción desde DWH
- `PC02_consolidacionExcel`: "True" | "False" - Validar consolidación en Excel
- `PC03_cargueTablasTempSQL`: "True" | "False" - Validar cargue a tablas temporales
- `PC04_completitudLinkedServer`: "True" | "False" - Validar completitud vía Linked Server
- `PC05_calculosFinancieros`: "True" | "False" - Validar cálculos financieros
- `PC06_ejecucionMacroVBA`: "True" | "False" - Validar ejecución de macro VBA
- `PC07_cargueProduccion`: "True" | "False" - Validar cargue a producción

**Ejemplo de uso en PAD:**
```vbnet
' Ejecutar punto de control 1: Extracción DWH
SET puntosControl TO JsonConfig['configuracion']['puntosControl']

IF puntosControl['PC01_extraccionDWH'] = 'True' THEN
    ' Validar que se extrajeron registros
    IF ResultadoQuery.RowsCount = 0 THEN
        Log.WriteLog Message: 'ERROR: PC01 - No se extrajeron registros del DWH' Severity: Log.Severity.Error
        THROW 'PC01_FALLO'
    ELSE
        Log.WriteLog Message: 'EXITO: PC01 - Extraídos %ResultadoQuery.RowsCount% registros' Severity: Log.Severity.Info
    END IF
END IF
```

---

##### 🔀 **Sección 13: `activadoresFlujos`**

Configuración de activadores que controlan qué flujos se ejecutan.

**Campos principales:**
- `fechaEjecucionManual`: Fecha de ejecución manual (formato DD/MM/YYYY)
- `procesarReestructurados`: "True" | "False" - Activar flujo de reestructurados
- `procesarModificados`: "True" | "False" - Activar flujo de modificados
- `procesarRetenciones`: "True" | "False" - Activar flujo de retenciones
- `ejecutarMacroVBA`: "True" | "False" - Activar ejecución de macro
- `calcularHashSHA256`: "True" | "False" - Activar cálculo de hash de integridad
- `enviarNotificaciones`: "True" | "False" - Activar envío de emails

**Ejemplo de uso en PAD:**
```vbnet
' Determinar qué flujos ejecutar
SET activadores TO JsonConfig['configuracion']['activadoresFlujos']

IF activadores['procesarReestructurados'] = 'True' THEN
    Main.RunSubflow SubflowName: 'Procesar_Reestructurados'
END IF

IF activadores['procesarModificados'] = 'True' THEN
    Main.RunSubflow SubflowName: 'Procesar_Modificados'
END IF

IF activadores['procesarRetenciones'] = 'True' THEN
    Main.RunSubflow SubflowName: 'Procesar_Retenciones'
END IF

IF activadores['enviarNotificaciones'] = 'True' THEN
    Main.RunSubflow SubflowName: 'Enviar_Notificaciones_Email'
END IF
```

---

## 🔐 Seguridad y Buenas Prácticas

### ⚠️ Archivos que NO deben subirse a Git

**NUNCA subir archivos con información sensible:**
```
config/credenciales/.env           # ❌ Contiene credenciales SQL, SMTP
config/credenciales/*.txt          # ❌ Archivos de contraseñas
config/credenciales/*.pwd          # ❌ Archivos de passwords
config/parametros/*_Local.json     # ❌ Configuraciones locales personalizadas
```

**Configurar `.gitignore`:**
```gitignore
# Credenciales y configuraciones sensibles
config/credenciales/.env
config/credenciales/*.txt
config/credenciales/*.pwd
config/parametros/*_Local.json

# Archivos temporales
*.log
*.tmp
*.temp

# Archivos de backup
*.bak
*~
```

### ✅ Buenas Prácticas de Seguridad

1. **Separar configuración pública de credenciales**
   - ✅ JSON con parámetros operativos → Se pueden subir a Git
   - ❌ Archivos .env con credenciales → NUNCA subir a Git

2. **Usar variables de entorno para datos sensibles**
   ```env
   # Archivo .env (NO SUBIR A GIT)
   SQL_USER_DWH=usuario_produccion
   SQL_PASSWORD_DWH=contraseña_segura
   SMTP_PASSWORD=password_email
   ```

3. **Encriptar credenciales en producción**
   - Usar Windows Credential Manager para credenciales SQL
   - Usar Azure Key Vault para almacenamiento centralizado
   - Implementar rotación periódica de contraseñas

4. **Restringir permisos de archivos**
   ```powershell
   # PowerShell: Dar permisos solo al usuario RPA
   $acl = Get-Acl "config/credenciales/.env"
   $acl.SetAccessRuleProtection($true, $false)
   $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("USUARIO_RPA","FullControl","Allow")
   $acl.SetAccessRule($rule)
   Set-Acl "config/credenciales/.env" $acl
   ```

5. **Auditoría de accesos**
   - Registrar en logs quién accede a archivos de configuración
   - Revisar periódicamente permisos de archivos
   - Implementar alertas por cambios no autorizados

---

## 🔄 Instrucciones de Actualización

### Actualizar Configuración de Máquina

**Escenario 1: Cambiar ambiente (Desarrollo → Producción)**

1. Abrir `config/parametros/Configuracion_Maquina.json`
2. Localizar la sección `globales`
3. Cambiar el valor de `ambiente`:
   ```json
   "ambiente": "Producción",
   ```
4. Actualizar rutas correspondientes:
   ```json
   "rutaArchivosTemporales": "\\\\servidor\\RDA_CostoAmortizable\\temp\\",
   "rutaDescarga": "C:\\RDA\\Descargas\\",
   ```
5. Guardar cambios y reiniciar el flujo PAD

**Escenario 2: Agregar nuevo destinatario de email**

1. Abrir `config/parametros/Configuracion_Maquina.json`
2. Localizar `envioNotificaciones.correoPara`
3. Agregar nuevo email separado por `;`:
   ```json
   "correoPara": "ccamposg@fgs.co;jelozanog@fgs.co;rriosh@fgs.co;nuevo@fgs.co",
   ```
4. Guardar cambios (no requiere reinicio)

**Escenario 3: Cambiar servidor SQL**

1. Abrir `config/parametros/Configuracion_Maquina.json`
2. Localizar `conexionesSQL.dwh_cc`
3. Actualizar `servidor`:
   ```json
   "servidor": "10.1.3.102\\SCC_NUEVO",
   ```
4. Verificar conectividad antes de ejecutar el proceso

**Escenario 4: Deshabilitar un script Python**

1. Abrir `config/parametros/Configuracion_Maquina.json`
2. Localizar `scriptsPython.scripts.validaciones`
3. Cambiar `habilitado` a `"False"`:
   ```json
   "validaciones": {
       "nombre": "validar_completitud.py",
       "habilitado": "False",
       "argumentos": "--log"
   }
   ```
4. El script no se ejecutará en la próxima ejecución

---

## 📚 Ejemplos de Código PAD

### Ejemplo Completo: Cargar Configuración al Inicio

```vbnet
' ========================================
' SUBFLOW: Cargar_Configuracion_JSON
' Descripción: Carga archivos de configuración JSON
' ========================================

' 1. Definir ruta base del proyecto
SET RutaProyecto TO 'C:\\RDA_Costo_Amortizable'
SET RutaConfig TO RutaProyecto & '\\config\\parametros'

' 2. Cargar Configuracion_Maestro.json
Json.ParseJson File: '%RutaConfig%\\Configuracion_Maestro.json' Json=> ConfigMaestro

' 3. Obtener información de la máquina actual
SET NombreMaquina TO %COMPUTERNAME%

' 4. Validar que la máquina existe en la configuración
IF ConfigMaestro['configuracion'].Keys.Contains(NombreMaquina) THEN
    SET InfoMaquina TO ConfigMaestro['configuracion'][NombreMaquina]
    SET NumeroMaquinaBR TO InfoMaquina['numeroMaquina']
    SET RolMaquina TO InfoMaquina['rol']
    
    Log.WriteLog Message: 'Máquina identificada: %NombreMaquina% (%NumeroMaquinaBR%) - Rol: %RolMaquina%' Severity: Log.Severity.Info
ELSE
    Log.WriteLog Message: 'ERROR: Máquina %NombreMaquina% no encontrada en Configuracion_Maestro.json' Severity: Log.Severity.Error
    THROW 'MAQUINA_NO_CONFIGURADA'
END IF

' 5. Cargar Configuracion_Maquina.json
Json.ParseJson File: '%RutaConfig%\\Configuracion_Maquina.json' Json=> ConfigMaquina

' 6. Actualizar número de máquina en configuración global
SET ConfigGlobal TO ConfigMaquina['configuracion']['globales']
SET ConfigGlobal['numeroMaquinaBR'] TO NumeroMaquinaBR
SET ConfigGlobal['nombreEstacionBR'] TO NombreMaquina

' 7. Obtener configuraciones principales
SET NombreAsistente TO ConfigGlobal['nombreAsistente']
SET Ambiente TO ConfigGlobal['ambiente']
SET NumeroIntentosLogin TO ConfigGlobal['numeroIntentosLogin']

Log.WriteLog Message: 'Configuración cargada: Asistente=%NombreAsistente%, Ambiente=%Ambiente%' Severity: Log.Severity.Info

' ========================================
' FIN: Cargar_Configuracion_JSON
' ========================================
```

### Ejemplo: Validar Punto de Control

```vbnet
' ========================================
' SUBFLOW: Validar_Punto_Control
' Parámetros de entrada: %NombrePuntoControl%, %ValorValidacion%, %MensajeError%
' ========================================

' 1. Obtener configuración de puntos de control
SET PuntosControl TO ConfigMaquina['configuracion']['puntosControl']

' 2. Verificar si el punto de control está habilitado
IF PuntosControl[NombrePuntoControl] = 'True' THEN
    
    ' 3. Validar el valor proporcionado
    IF ValorValidacion = False THEN
        ' Capturar pantalla del error
        Variables.IncreaseVariable Value: %ConsecutivoCaptura%
        SET RutaCapturas TO ConfigMaquina['configuracion']['capturasPantalla']['rutaCapturasPantallaError']
        SET NombreCaptura TO 'PC_ERROR_%NombrePuntoControl%_%ConsecutivoCaptura%.png'
        
        Screen.TakeScreenshot CaptureMode: Screen.CaptureMode.AllScreens ImageFile: '%RutaCapturas%\\%NombreCaptura%'
        
        ' Escribir en log de errores
        Log.WriteLog Message: 'ERROR: %NombrePuntoControl% - %MensajeError%' Severity: Log.Severity.Error
        
        ' Lanzar excepción para detener el proceso
        THROW '%NombrePuntoControl%_FALLO'
    ELSE
        ' Punto de control exitoso
        Log.WriteLog Message: 'EXITO: %NombrePuntoControl% - Validación aprobada' Severity: Log.Severity.Info
    END IF
ELSE
    ' Punto de control deshabilitado
    Log.WriteLog Message: 'INFO: %NombrePuntoControl% - Punto de control deshabilitado' Severity: Log.Severity.Info
END IF

' ========================================
' FIN: Validar_Punto_Control
' ========================================
```

### Ejemplo: Enviar Email con Plantilla

```vbnet
' ========================================
' SUBFLOW: Enviar_Email_Proceso
' Parámetros: %TipoPlantilla% ('exitoso', 'error', 'advertencia')
' ========================================

' 1. Obtener configuración de email
SET ConfigEmail TO ConfigMaquina['configuracion']['envioNotificaciones']
SET Plantilla TO ConfigEmail['plantillas'][TipoPlantilla]

' 2. Construir asunto
SET Asunto TO Plantilla['asunto']
DateTime.GetCurrentDateTime CurrentDateTime=> FechaActual
DateTime.FormatDateTime DateTime: FechaActual FormatToUse: DateTime.DateTimeFormat.Custom CustomFormat: 'dd/MM/yyyy' Result=> FechaFormateada

Text.Replace Text: Asunto TextToFind: '{fecha}' ReplaceWith: FechaFormateada Result=> AsuntoFinal

' 3. Construir cuerpo HTML
SET CuerpoHTML TO Plantilla['cuerpoHTML']
DateTime.FormatDateTime DateTime: FechaActual FormatToUse: DateTime.DateTimeFormat.Custom CustomFormat: 'HH:mm:ss' Result=> HoraFormateada

Text.Replace Text: CuerpoHTML TextToFind: '{fecha}' ReplaceWith: FechaFormateada Result=> CuerpoTemporal
Text.Replace Text: CuerpoTemporal TextToFind: '{hora}' ReplaceWith: HoraFormateada Result=> CuerpoTemporal2
Text.Replace Text: CuerpoTemporal2 TextToFind: '{cantidadRegistros}' ReplaceWith: %TotalRegistrosProcesados% Result=> CuerpoFinal

' 4. Determinar adjuntos
IF Plantilla['adjuntarReporte'] = 'True' THEN
    SET RutaReporte TO ConfigMaquina['configuracion']['reporteGestion']['rutaReporteGestion']
    SET ListaAdjuntos TO [RutaReporte]
ELSE
    SET ListaAdjuntos TO []
END IF

' 5. Obtener configuración SMTP
SET HostSMTP TO ConfigMaquina['configuracion']['variablesSMTP']['hostSMTP']
SET PuertoSMTP TO ConfigMaquina['configuracion']['variablesSMTP']['puertoSMTP']

' 6. Enviar email
Email.SendEmail.SendWithExchange SMTPServer: HostSMTP ServerPort: PuertoSMTP From: ConfigEmail['correoDesde'] To: ConfigEmail['correoPara'] CC: ConfigEmail['correoCC'] BCC: ConfigEmail['correoCCO'] Subject: AsuntoFinal Body: CuerpoFinal BodyIsHTML: True AttachmentsList: ListaAdjuntos

Log.WriteLog Message: 'Email enviado: %AsuntoFinal%' Severity: Log.Severity.Info

' ========================================
' FIN: Enviar_Email_Proceso
' ========================================
```

---

## 🔗 Referencias al Manual Técnico

Para documentación más detallada, consultar:

1. **Diseño de Arquitectura RDA**
   - Ubicación: `documentacion/tecnica/Diseno_Arquitectura_RDA_Costo_Amortizable.md`
   - Contenido: Arquitectura de 5 capas, componentes modulares, diagramas de secuencia

2. **Process Design Document (PDD)**
   - Ubicación: `documentacion/funcional/pdd/PDD_RDA_Costo_Amortizable_v1.0.md`
   - Contenido: Especificación funcional completa del proceso (89 páginas)

3. **Historias de Usuario**
   - Ubicación: `documentacion/funcional/historias_usuario/en_progreso/`
   - Contenido: 14 historias de usuario funcionales implementadas

4. **Requisitos de Infraestructura PAD**
   - Ubicación: `documentacion/tecnica/Requisitos_Infraestructura_PAD.md`
   - Contenido: Requisitos de hardware, software y configuración de PAD

5. **Cronograma de Desarrollo**
   - Ubicación: `documentacion/gestion_proyecto/cronograma/Cronograma_Desarrollo_RDA_Costo_Amortizable.md`
   - Contenido: Planificación de sprints y estimaciones

---

## ❓ Preguntas Frecuentes (FAQ)

### ¿Por qué los valores booleanos están como strings ("True"/"False")?

Power Automate Desktop (PAD) no soporta nativamente booleanos en JSON. Al cargar el JSON, PAD interpreta `true` como la cadena `"true"`, por lo que se recomienda usar directamente strings `"True"` y `"False"` para evitar confusiones y comparar con `IF variable = 'True' THEN`.

### ¿Por qué usar doble backslash (\\) en las rutas?

JSON requiere escapar el carácter backslash `\`. En JSON, una ruta de Windows se escribe así:
```json
"rutaLibreriasPython": "C:\\Python312\\Lib"
```

Al cargar en PAD, se convierte automáticamente en:
```
C:\Python312\Lib
```

### ¿Cómo valido que mi JSON tiene sintaxis correcta?

**Opción 1: Editor de código con validación**
- Visual Studio Code con extensión JSON
- Notepad++ con plugin JSON Viewer

**Opción 2: Validador online**
- https://jsonlint.com/
- https://jsonformatter.curiousconcept.com/

**Opción 3: Desde PAD**
```vbnet
ON ERROR
    Json.ParseJson File: '%RutaConfig%\\Configuracion_Maquina.json' Json=> ConfigMaquina
END ON ERROR EXCEPTION
    Log.WriteLog Message: 'ERROR: JSON inválido - %ErrorMessage%' Severity: Log.Severity.Error
    THROW 'JSON_INVALIDO'
END
```

### ¿Puedo agregar nuevas secciones al JSON?

Sí, puedes agregar nuevas secciones sin afectar las existentes. Ejemplo:

```json
{
  "configuracion": {
    "globales": { ... },
    "envioNotificaciones": { ... },
    ...
    "nuevaSeccion": {
      "parametro1": "valor1",
      "parametro2": "valor2"
    }
  }
}
```

Luego en PAD:
```vbnet
SET NuevaConfig TO ConfigMaquina['configuracion']['nuevaSeccion']
```

### ¿Cómo manejo diferentes configuraciones por ambiente?

**Opción 1: Usar campo `ambiente` en `globales`**
```vbnet
SET Ambiente TO ConfigMaquina['configuracion']['globales']['ambiente']

IF Ambiente = 'Desarrollo' THEN
    SET ServidorSQL TO 'servidor_desarrollo'
ELSE IF Ambiente = 'Producción' THEN
    SET ServidorSQL TO 'servidor_produccion'
END IF
```

**Opción 2: Archivos de configuración separados**
```
config/parametros/Configuracion_Maquina_DEV.json
config/parametros/Configuracion_Maquina_PROD.json
```

```vbnet
SET Ambiente TO 'DEV'  ' o 'PROD'
Json.ParseJson File: '%RutaConfig%\\Configuracion_Maquina_%Ambiente%.json' Json=> ConfigMaquina
```

---

## 📞 Soporte y Contacto

Para dudas o problemas con la configuración:

- **Soporte Técnico RPA**: soporte.rpa@cajasocial.com
- **Desarrollador**: Ronald Estiven Rios (rriosh@fgs.co)
- **Especialista RPA**: Jeimy Johana Lozano (jelozanog@fgs.co)
- **Usuario Funcional**: Carol Patricia Campos (ccamposg@fgs.co)

---

<div align="center">

**Configuración RDA Costo Amortizable**

*Documentación completa de archivos de configuración JSON para Power Automate Desktop*

📅 **Última actualización**: Diciembre 2025  
📌 **Versión**: 1.0.0

</div>
