# Documento Funcional – Power Automate Desktop (PAD) para Proceso RDA Costo Amortizable

## 1. Propósito del Documento
Entregar una guía clara y no técnica sobre cómo PAD soporta la automatización del proceso de Costo Amortizable, orientada a perfiles funcionales (negocio, riesgos, control). No incluye instrucciones técnicas ni código.

## 2. Resumen Ejecutivo
- Proceso manual actual: ~14 horas por ciclo.
- Automatización con PAD: ~15 minutos por ciclo (reducción >98%).
- PAD permite automatizar tareas en computador Windows con integración nativa a Excel, Outlook y conectividad a bases de datos.
- Beneficios clave: rapidez, menor error humano, continuidad operativa y adopción rápida.

## 3. Alcance Funcional
Incluye: extracción de datos, validaciones básicas, cálculos en Excel mediante plantillas, generación de reportes (detallados y ejecutivo), envío a destinatarios y registro básico de ejecución.
No incluye: definición de políticas, análisis cualitativo, aprobaciones gerenciales ni gestión documental externa al flujo.

## 4. Beneficios Clave
| Beneficio | Descripción | Impacto |
|-----------|-------------|---------|
| Reducción de tiempos | De 14h a ~15 min | Liberación de capacidad |
| Estandarización | Mismo flujo, mismos pasos | Calidad y consistencia |
| Adopción ágil | Interfaz de escritorio conocida | Menor curva de aprendizaje |
| Integración Office | Excel/Outlook nativos | Menos fricción operativa |
| Control básico | Logs simples y evidencias | Soporte a auditoría |

## 5. Arquitectura Operativa (Vista Funcional)
El bot PAD corre en un equipo Windows, toma datos de bases internas, usa una plantilla Excel para cálculos y distribuye los resultados por correo.

```
┌────────────────────────────────────────────┐
│ Equipo Windows (Bot PAD)                  │
│  • Agenda de ejecución                    │
│  • Lectura de datos                       │
│  • Plantillas Excel (cálculos)            │
│  • Generación de reportes                 │
│  • Envío de correos y registro            │
└────────────────────────────────────────────┘
             │                         │
             │ Datos                   │ Reportes / Notificaciones
             ▼                         ▼
    Bases de Datos             Destinatarios de negocio
```

## 6. Requisitos Operativos (Simplificados)
- Equipo dedicado o servidor Windows con recursos estándar de oficina (memoria 8–16 GB y disco disponible).  
- Acceso a Excel y Outlook corporativos.  
- Conexión de red estable a las bases de datos internas.  
- Credenciales de servicio con permisos de lectura (y carga si aplica).  
- Carpeta de trabajo para plantillas, datos temporales y reportes.

## 7. Conectividad y Accesos (Simplificado)
- Acceso saliente desde el equipo PAD a servidores de base de datos internos.  
- Permisos otorgados por TI para consultar fuentes requeridas y, si aplica, cargar resultados a la tabla destino.  
- Lista maestra de destinatarios y buzón corporativo para envíos.

## 8. Licenciamiento y Costos (Referenciales)
| Concepto | Descripción | Monto estimado |
|----------|-------------|----------------|
| PAD (desatendido) | Habilitación para ejecución sin usuario | ~190 USD/mes por bot |
| Office 365 | Excel y Outlook corporativos | Según contrato |
| Infraestructura | Equipo/VM Windows | Dependiente de TI |

Nota: Valores referenciales; confirmar con compras/licenciamiento.

## 9. Flujo Resumido del Proceso Automatizado
1. Inicio programado (día/hora definidos).  
2. Preparación: rutas y parámetros del mes.  
3. Extracción de datos de fuentes internas.  
4. Carga en plantilla Excel y ejecución de cálculos.  
5. Validaciones básicas de calidad.  
6. Generación de reportes: reestructurados, modificados y ejecutivo.  
7. Envío de reportes a lista de distribución.  
8. Registro de ejecución y resguardo de archivos.  

## 10. Roles y Responsabilidades
| Rol | Responsabilidad |
|-----|-----------------|
| Propietario del Proceso | Define reglas y valida resultados |
| Analista Funcional | Revisa reportes y solicita ajustes |
| Operador PAD | Supervisa ejecuciones y gestiona incidencias |
| TI / Infraestructura | Mantiene equipo, accesos y respaldos |
| Seguridad | Controla permisos y cumplimiento |
| Auditoría | Solicita y verifica evidencias |

## 11. Riesgos y Mitigaciones
| Riesgo | Impacto | Mitigación |
|--------|---------|-----------|
| PC apagado o sin sesión | Ejecución fallida | Uso de servidor/VM y monitoreo |
| Cambios en estructura de datos | Errores en extracción | Revisión mensual con TI |
| Plantilla Excel corrupta | Retraso en reportes | Respaldo y control de versiones |
| Credenciales vencidas | Fallo de conexión | Gestión de credenciales y alertas |
| Envíos erróneos | Distribución incorrecta | Lista maestra y doble verificación |

## 12. Indicadores (KPIs) Clave
| KPI | Objetivo | Frecuencia |
|-----|----------|------------|
| Tiempo de ejecución | ≤ 20 minutos | Cada ciclo |
| Ejecuciones exitosas | ≥ 95% | Mensual |
| Incidencias críticas | 0 por mes | Mensual |
| Entrega puntual | 100% | Mensual |
| Reprocesos | ≤ 1 por trimestre | Trimestral |

## 13. Gobernanza y Control
| Elemento | Práctica |
|----------|---------|
| Versionado de plantillas | Control y resguardo centralizado |
| Aprobación de reglas | Comité funcional documentado |
| Evidencias | Carpeta de logs y reportes históricos |
| Lista de distribución | Revisión trimestral |
| Cambios | Solicitud formal y prueba piloto |

## 14. Plan de Implementación (Fases)
| Fase | Objetivo | Entregable |
|------|----------|------------|
| 1 – Diseño | Definir alcance, entradas y salidas | Documento funcional validado |
| 2 – Preparación | Configurar equipo, accesos y plantillas | Entorno listo |
| 3 – Construcción | Parametrizar flujo PAD | Flujo base |
| 4 – Piloto | Pruebas con datos reales | Informe de equivalencia |
| 5 – Aprobación | Endoso de negocio | Acta de aprobación |
| 6 – Producción | Operación mensual | Reportes distribuidos |
| 7 – Mejora | Afinar tiempos/controles | Ajustes aprobados |

## 15. Comparativa Resumida: PAD vs n8n (para decisión)
| Criterio | PAD | n8n |
|----------|-----|-----|
| Tiempo de ciclo | ~15 min | ~8 min |
| Costos de licencia | Medio (por bot) | Bajo (self-hosted) |
| Integración Office | Nativa | Indirecta |
| Escalabilidad | Limitada a equipo | Alta (cloud/híbrido) |
| Mantenimiento | En el equipo/VM | Centralizado |
| Curva de adopción | Rápida | Media |

Nota: ambas opciones son válidas; la elección depende de costos, escala y estrategia tecnológica.

## 16. Glosario Funcional
| Término | Definición |
|---------|-----------|
| Bot PAD | Automatización que ejecuta tareas en Windows |
| Plantilla Excel | Archivo estándar con reglas de cálculo |
| Lista de distribución | Destinatarios autorizados de reportes |
| Evidencias | Archivos y registros que prueban la ejecución |

## 17. Próximos Pasos
1. Validar este documento con negocio y riesgos.  
2. Confirmar equipo/VM Windows y accesos necesarios.  
3. Acordar lista de distribución y resguardos.  
4. Ejecutar piloto y comparar con proceso manual.  
5. Definir fecha de entrada en producción.

---
Versión funcional: 1.0  |  Fecha: 10/11/2025  |  Revisión sugerida: Trimestral

# Requisitos de Infraestructura - Power Automate Desktop

## Información General
**Plataforma:** Power Automate Desktop (PAD)  
**Versión Mínima:** 2.38 o superior  
**Tipo de Bot:** Desatendido (Unattended)  
**Tiempo de Ejecución:** ~15 minutos

---

## 1. Requisitos de Hardware

### Especificaciones Mínimas
| Componente | Requerimiento Mínimo |
|------------|----------------------|
| **Procesador** | Intel Core i5 o equivalente (4 núcleos) |
| **RAM** | 8 GB |
| **Disco Duro** | 50 GB libres |
| **Tipo de Disco** | SSD recomendado |
| **Resolución** | 1920x1080 (Full HD) |
| **Conexión Red** | 100 Mbps (cableada preferida) |

### Especificaciones Recomendadas
| Componente | Requerimiento Recomendado |
|------------|---------------------------|
| **Procesador** | Intel Core i7 o superior (6+ núcleos) |
| **RAM** | 16 GB |
| **Disco Duro** | 100 GB libres |
| **Tipo de Disco** | SSD NVMe |
| **Resolución** | 1920x1080 o superior |
| **Conexión Red** | 1 Gbps (cableada) |

---

## 2. Requisitos de Software

### Sistema Operativo
- **Windows 10** (versión 1809 o superior)
- **Windows 11** (todas las versiones)
- **Windows Server 2016/2019/2022** (para entornos corporativos)

### Software Obligatorio
| Software | Versión | Propósito |
|----------|---------|-----------|
| **Microsoft Excel** | 2016, 2019, 365 | Procesamiento de archivos |
| **Microsoft Outlook** | 2016, 2019, 365 | Envío de correos |
| **Power Automate Desktop** | 2.38+ | Motor RPA |
| **SQL Server ODBC Driver** | 17 o 18 | Conexión a bases de datos |
| **.NET Framework** | 4.7.2 o superior | Dependencia de PAD |

### Configuraciones de Excel
```vba
' Habilitar macros con firma digital
Application.AutomationSecurity = msoAutomationSecurityLow

' Deshabilitar alertas durante ejecución automatizada
Application.DisplayAlerts = False

' Habilitar cálculo automático
Application.Calculation = xlCalculationAutomatic
```

---

## 3. Conectividad y Accesos

### Bases de Datos
| Servidor | Instancia | Puerto | Protocolo |
|----------|-----------|--------|-----------|
| 10.1.3.101 | SCC | 1433 | TCP/IP |
| 10.1.5.172 | RIESGOS | 1433 | TCP/IP |

### Credenciales Requeridas
- **Usuario SQL:** Cuenta de servicio con permisos de lectura
- **Windows Credential Manager:** Almacenar credenciales de forma segura
- **Permisos de Base de Datos:**
  - `SELECT` en tablas fuente
  - `INSERT` en tabla destino `ANDREAL.Costo_Amortizado_[YYYYMM]`

### Firewall y Red
```powershell
# Reglas de firewall a configurar
New-NetFirewallRule -DisplayName "SQL Server DWH" -Direction Outbound -LocalPort 1433 -Protocol TCP -Action Allow -RemoteAddress 10.1.3.101
New-NetFirewallRule -DisplayName "SQL Server RIESGOS" -Direction Outbound -LocalPort 1433 -Protocol TCP -Action Allow -RemoteAddress 10.1.5.172
```

---

## 4. Licenciamiento

### Licencias Requeridas
| Componente | Tipo de Licencia | Cantidad |
|------------|------------------|----------|
| **Power Automate Desktop** | Incluida en Windows 11 | 1 |
| **Power Automate Premium** | Unattended RPA add-on | 1 (para ejecución desatendida) |
| **Microsoft 365 E3/E5** | Suite Office | 1 usuario |

### Costos Aproximados (USD/mes)
- Power Automate Premium: $40/usuario
- Unattended RPA add-on: $150/bot
- **Total Estimado:** $190/mes por bot

---

## 5. Configuración de Entorno

### Variables de Entorno Windows
```cmd
# Configurar variables de sistema
setx PAD_WORKSPACE "C:\RPA\RDA_Costo_Amortizable" /M
setx PAD_LOGS "C:\RPA\RDA_Costo_Amortizable\logs" /M
setx SQL_DWH_SERVER "10.1.3.101\SCC" /M
setx SQL_RIESGOS_SERVER "10.1.5.172\RIESGOS" /M
```

### Estructura de Carpetas
```
C:\RPA\RDA_Costo_Amortizable\
├── flows/
│   ├── MainFlow.txt
│   └── ErrorHandling.txt
├── data/
│   ├── input/
│   ├── output/
│   └── temp/
├── logs/
│   └── execution_YYYYMMDD.log
└── config/
    └── credentials.vault
```

---

## 6. Actividades de Power Automate Desktop

### 6.1. Inicialización y Configuración
```
┌─────────────────────────────────────────────────────────────┐
│ BLOQUE 1: Inicialización (30 segundos)                     │
└─────────────────────────────────────────────────────────────┘
```

| # | Actividad PAD | Propósito | Variables Generadas |
|---|---------------|-----------|---------------------|
| 1 | **Set Variable** | Definir fecha de proceso | `%FechaProceso%` |
| 2 | **Set Variable** | Definir rutas de archivos | `%RutaInput%`, `%RutaOutput%` |
| 3 | **Get Credential** | Obtener credenciales SQL | `%UserSQL%`, `%PassSQL%` |
| 4 | **Create Folder** | Crear carpetas temporales | N/A |
| 5 | **Log Message** | Registrar inicio | N/A |

**Código de Ejemplo:**
```
# PAD Action: Set Variable
SET FechaProceso TO $'''%datetime.now.addDays(-1).toString('yyyyMM')%'''

# PAD Action: Get Credential
GETCREDENTIAL Name: 'SQL_DWH' IntoUsername: UserSQL IntoPassword: PassSQL
```

---

### 6.2. Extracción de Datos SQL
```
┌─────────────────────────────────────────────────────────────┐
│ BLOQUE 2: Consultas SQL (2 minutos)                        │
└─────────────────────────────────────────────────────────────┘
```

| # | Actividad PAD | Propósito | Output |
|---|---------------|-----------|--------|
| 6 | **Open SQL Connection** | Conectar a DWH_CC | `%ConnectionDWH%` |
| 7 | **Execute SQL Statement** | Query reestructurados | `%DataReestructurados%` |
| 8 | **Execute SQL Statement** | Query modificados | `%DataModificados%` |
| 9 | **Close SQL Connection** | Cerrar DWH | N/A |
| 10 | **Open SQL Connection** | Conectar a SCC (contingencia) | `%ConnectionSCC%` |
| 11 | **Execute SQL Statement** | Query contingencia | `%DataContingencia%` |
| 12 | **Close SQL Connection** | Cerrar SCC | N/A |

**Código de Ejemplo:**
```
# PAD Action: Open SQL Connection
OPENSQLCONNECTION ConnectionString: 'Server=%SQL_DWH_SERVER%;Database=DWH_CC;User Id=%UserSQL%;Password=%PassSQL%;' IntoConnection: ConnectionDWH

# PAD Action: Execute SQL Statement
EXECUTESQLSTATEMENT Connection: ConnectionDWH SQLStatement: $'''%File.ReadAllText('scripts/sql/01_Consulta_DWH_Reestructurados_Modificados.sql')%''' IntoDataTable: DataReestructurados
```

---

### 6.3. Procesamiento en Excel
```
┌─────────────────────────────────────────────────────────────┐
│ BLOQUE 3: Manipulación Excel (5 minutos)                   │
└─────────────────────────────────────────────────────────────┘
```

| # | Actividad PAD | Propósito | Nodo Equivalente |
|---|---------------|-----------|------------------|
| 13 | **Launch Excel** | Abrir archivo plantilla | Excel.Application |
| 14 | **Write to Excel Worksheet** | Escribir datos reestructurados | Write Range |
| 15 | **Write to Excel Worksheet** | Escribir datos modificados | Write Range |
| 16 | **Run Excel Macro** | Ejecutar `Calculo_Perdida_Ganancia` | VBA Macro |
| 17 | **Run Excel Macro** | Ejecutar `Calculo_Valor_Valuativo` | VBA Macro |
| 18 | **Read from Excel Worksheet** | Leer resultados calculados | Read Range |
| 19 | **Save Excel** | Guardar como reporte final | Save Workbook |
| 20 | **Close Excel** | Cerrar aplicación | Close Workbook |

**Código de Ejemplo:**
```
# PAD Action: Launch Excel
LAUNCHEXCEL Visible: False InstanceName: ExcelInstance FilePath: 'data/input/plantillas/Calculo_Perdida_Ganancia.xlsm'

# PAD Action: Write to Excel
WRITETOEXCELWORKSHEET Instance: ExcelInstance Value: DataReestructurados StartColumn: 'A' StartRow: 2

# PAD Action: Run Macro
RUNEXCELMACRO Instance: ExcelInstance MacroName: 'Calculo_Perdida_Ganancia'
```

---

### 6.4. Validación de Datos
```
┌─────────────────────────────────────────────────────────────┐
│ BLOQUE 4: Validaciones (3 minutos)                         │
└─────────────────────────────────────────────────────────────┘
```

| # | Actividad PAD | Propósito | Condición |
|---|---------------|-----------|-----------|
| 21 | **If** | Verificar datos completos | `%DataReestructurados.RowsCount% > 0` |
| 22 | **For Each** | Iterar filas | Loop sobre DataTable |
| 23 | **If** | Validar saldo positivo | `%CurrentRow['saldo_capital']% > 0` |
| 24 | **If** | Validar rango de tasas | `0 < %CurrentRow['tasa_interes']% < 0.5` |
| 25 | **If** | Validar fechas | `%CurrentRow['fecha_reestructura']% <= %datetime.now%` |
| 26 | **Else** | Registrar error | Log + agregar a lista de errores |
| 27 | **End Loop** | Fin iteración | N/A |

**Código de Ejemplo:**
```
# PAD Action: For Each
FOREACH CurrentRow IN DataReestructurados
    IF CurrentRow['saldo_capital'] > 0 THEN
        # Continuar procesamiento
    ELSE
        # Registrar error
        LOGMESSAGE Message: $'''Error: Saldo negativo en obligación %CurrentRow['obligacion']%''' Level: 'Error'
        ADD %CurrentRow['obligacion']% TO ListaErrores
    END IF
END FOREACH
```

---

### 6.5. Ejecución de Macros
```
┌─────────────────────────────────────────────────────────────┐
│ BLOQUE 5: Cálculos Macros (4 minutos)                      │
└─────────────────────────────────────────────────────────────┘
```

| # | Actividad PAD | Macro VBA | Función |
|---|---------------|-----------|---------|
| 28 | **Run Excel Macro** | `CalcularVP_Original()` | Calcular VP flujos originales |
| 29 | **Run Excel Macro** | `CalcularVP_Nuevo()` | Calcular VP flujos reestructurados |
| 30 | **Run Excel Macro** | `CalcularPerdidaGanancia()` | Diferencia VP_original - VP_nuevo |
| 31 | **Run Excel Macro** | `CalcularValorValuativo()` | Aplicar factor amortización |
| 32 | **Run Excel Macro** | `GenerarResumen()` | Crear hoja resumen |

**Macro VBA Ejemplo:**
```vba
' Macro: CalcularValorValuativo
Sub CalcularValorValuativo()
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim i As Long
    
    Set ws = ActiveSheet
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    
    For i = 2 To lastRow
        ws.Cells(i, 12).Formula = "=ROUNDDOWN(" & _
            ws.Cells(i, 11).Address & " * " & _
            "FactorAmortizacion(" & ws.Cells(i, 8).Address & "), 2)"
    Next i
End Sub
```

---

### 6.6. Control de Errores
```
┌─────────────────────────────────────────────────────────────┐
│ BLOQUE 6: Manejo de Errores (variable)                     │
└─────────────────────────────────────────────────────────────┘
```

| # | Actividad PAD | Trigger | Acción |
|---|---------------|---------|--------|
| 33 | **On Block Error** | Cualquier error en bloques 1-5 | Ir a ErrorHandler |
| 34 | **Get Last Error** | N/A | Obtener detalles del error |
| 35 | **Log Message** | N/A | Registrar error en log |
| 36 | **Take Screenshot** | N/A | Captura de pantalla |
| 37 | **Send Email** | N/A | Notificar a ccamposg@fgs.co |
| 38 | **Stop** | N/A | Detener flujo |

**Código de Ejemplo:**
```
# PAD Action: On Block Error
ONBLOCKERROR
    GETLASTERROR IntoMessage: ErrorMessage IntoType: ErrorType
    LOGMESSAGE Message: $'''Error %ErrorType%: %ErrorMessage%''' Level: 'Error'
    TAKESCREENSHOT Path: 'logs/error_%datetime.now.toString('yyyyMMdd_HHmmss')%.png'
    SENDEMAIL.SendEmail Server: 'smtp.office365.com' From: 'bot-rda@bancocajasocial.com' To: 'ccamposg@fgs.co' Subject: '[ERROR] RDA Costo Amortizable' Body: $'''Se detectó un error: %ErrorMessage%'''
    STOP
END ONBLOCKERROR
```

---

### 6.7. Queries Adicionales
```
┌─────────────────────────────────────────────────────────────┐
│ BLOQUE 7: Consultas Complementarias (2 minutos)            │
└─────────────────────────────────────────────────────────────┘
```

| # | Actividad PAD | Query SQL | Output |
|---|---------------|-----------|--------|
| 39 | **Open SQL Connection** | Reconectar DWH | `%ConnectionDWH%` |
| 40 | **Execute SQL Statement** | 03_Verificar_Info_Completitud.sql | `%DataCompletitud%` |
| 41 | **Execute SQL Statement** | 04_Recolectar_Info_Tasas_Plazos_Saldo.sql | `%DataTasasPlazo%` |
| 42 | **Execute SQL Statement** | 05_Variables_Calculo_Valor_Valuativo.sql | `%DataVariables%` |
| 43 | **Close SQL Connection** | Cerrar DWH | N/A |

---

### 6.8. Generación de Reportes
```
┌─────────────────────────────────────────────────────────────┐
│ BLOQUE 8: Reportes Finales (2 minutos)                     │
└─────────────────────────────────────────────────────────────┘
```

| # | Actividad PAD | Output | Formato |
|---|---------------|--------|---------|
| 44 | **Launch Excel** | Crear Reporte Reestructurados | .xlsx |
| 45 | **Launch Excel** | Crear Reporte Modificados | .xlsx |
| 46 | **Launch Excel** | Crear Reporte Resumen Ejecutivo | .xlsx |
| 47 | **Convert to PDF** | PDF para distribución | .pdf |
| 48 | **Save Files** | Guardar en output/reportes/ | N/A |

---

### 6.9. Cargue a Base de Datos
```
┌─────────────────────────────────────────────────────────────┐
│ BLOQUE 9: Inserción SQL (1 minuto)                         │
└─────────────────────────────────────────────────────────────┘
```

| # | Actividad PAD | Propósito | Tabla Destino |
|---|---------------|-----------|---------------|
| 49 | **Open SQL Connection** | Conectar a ANDREAL | `%ConnectionANDREAL%` |
| 50 | **Execute SQL Statement** | Truncate tabla temporal | `Costo_Amortizado_Temp` |
| 51 | **For Each** | Iterar resultados finales | Loop |
| 52 | **Execute SQL Statement** | INSERT en tabla temporal | `Costo_Amortizado_Temp` |
| 53 | **Execute SQL Statement** | Merge a tabla final | `Costo_Amortizado_%FechaProceso%` |
| 54 | **Close SQL Connection** | Cerrar ANDREAL | N/A |

**Código de Ejemplo:**
```
# PAD Action: Execute SQL Statement (Bulk Insert)
EXECUTESQLSTATEMENT Connection: ConnectionANDREAL SQLStatement: $'''
INSERT INTO ANDREAL.Costo_Amortizado_%FechaProceso% 
(obligacion, tipo_credito, saldo_capital, tasa_interes_original, 
 tasa_interes_nueva, valor_valuativo, fecha_proceso)
SELECT * FROM ANDREAL.Costo_Amortizado_Temp
WHERE NOT EXISTS (
    SELECT 1 FROM ANDREAL.Costo_Amortizado_%FechaProceso% ca
    WHERE ca.obligacion = Costo_Amortizado_Temp.obligacion
)
'''
```

---

### 6.10. Envío de Reportes
```
┌─────────────────────────────────────────────────────────────┐
│ BLOQUE 10: Distribución (30 segundos)                      │
└─────────────────────────────────────────────────────────────┘
```

| # | Actividad PAD | Destinatario | Adjuntos |
|---|---------------|--------------|----------|
| 55 | **Send Email** | ccamposg@fgs.co | Todos los reportes .xlsx + PDF |
| 56 | **Send Email** | Gerencia (CC) | Solo Resumen Ejecutivo |
| 57 | **Log Message** | N/A | Registrar envío exitoso |
| 58 | **Move Files** | Mover a archivo histórico | SharePoint/Red |

**Código de Ejemplo:**
```
# PAD Action: Send Email
SENDEMAIL.SendEmail 
    Server: 'smtp.office365.com' 
    Port: 587 
    EnableSSL: True
    ServerUsername: 'bot-rda@bancocajasocial.com'
    ServerPassword: %EmailPassword%
    From: 'bot-rda@bancocajasocial.com' 
    To: 'ccamposg@fgs.co' 
    CC: 'gerencia@bancocajasocial.com'
    Subject: '[Completado] RDA Costo Amortizable - %FechaProceso%' 
    Body: $'''
Buen día,

Adjunto los reportes de Costo Amortizable correspondientes a %FechaProceso%:

✓ Reestructurados: %DataReestructurados.RowsCount% obligaciones
✓ Modificados: %DataModificados.RowsCount% obligaciones
✓ Resumen Ejecutivo

Total procesado: %TotalObligaciones% obligaciones
Impacto Neto: $%ValorValuativoTotal%

Datos cargados en ANDREAL.Costo_Amortizado_%FechaProceso%

Saludos,
Bot RDA Costo Amortizable
    '''
    Attachments: ['%RutaOutput%/Reestructurados_%FechaProceso%.xlsx', '%RutaOutput%/Modificados_%FechaProceso%.xlsx', '%RutaOutput%/Resumen_Ejecutivo_%FechaProceso%.pdf']
```

---

## 7. Monitoreo y Logs

### Sistema de Logs
```
┌─────────────────────────────────────────────────────────────┐
│ Registro de Eventos                                         │
└─────────────────────────────────────────────────────────────┘
```

| Evento | Nivel | Actividad PAD |
|--------|-------|---------------|
| Inicio de flujo | INFO | Log Message |
| Conexión SQL exitosa | INFO | Log Message |
| Query ejecutado | INFO | Log Message |
| Archivo Excel procesado | INFO | Log Message |
| Validación completada | INFO | Log Message |
| Error detectado | ERROR | Log Message + Screenshot |
| Envío de correo | INFO | Log Message |
| Fin de flujo | INFO | Log Message |

**Formato de Log:**
```log
[2025-11-10 08:00:00] INFO - Iniciando flujo RDA Costo Amortizable
[2025-11-10 08:00:30] INFO - Conexión exitosa a DWH_CC (10.1.3.101\SCC)
[2025-11-10 08:02:15] INFO - Query reestructurados ejecutado: 1,234 registros
[2025-11-10 08:02:45] INFO - Query modificados ejecutado: 567 registros
[2025-11-10 08:03:30] INFO - Archivo Excel abierto: Calculo_Perdida_Ganancia.xlsm
[2025-11-10 08:08:15] INFO - Macro CalcularValorValuativo ejecutado correctamente
[2025-11-10 08:10:00] INFO - Validaciones completadas: 0 errores encontrados
[2025-11-10 08:14:00] INFO - Reportes generados en data/output/reportes/
[2025-11-10 08:14:30] INFO - Correo enviado a ccamposg@fgs.co
[2025-11-10 08:15:00] INFO - Flujo completado exitosamente en 15 minutos
```

---

## 8. Mantenimiento y Actualizaciones

### Tareas de Mantenimiento Mensual
- [ ] Revisar logs de ejecución
- [ ] Validar credenciales SQL vigentes
- [ ] Actualizar drivers ODBC si necesario
- [ ] Verificar espacio en disco
- [ ] Limpiar archivos temporales
- [ ] Revisar versión de PAD

### Actualizaciones de Software
```powershell
# Verificar versión de PAD
Get-AppxPackage -Name Microsoft.PowerAutomateDesktop

# Actualizar componentes
winget upgrade --id Microsoft.PowerAutomateDesktop
```

---

## 9. Troubleshooting

### Problemas Comunes

| Problema | Causa Probable | Solución |
|----------|----------------|----------|
| Error conexión SQL | Timeout de red | Aumentar timeout: `Connection Timeout=60` |
| Macro no ejecuta | Macros deshabilitadas | Habilitar: `Trust Center > Macro Settings` |
| Archivo Excel bloqueado | Proceso previo no cerró | Matar proceso: `taskkill /IM excel.exe /F` |
| Correo no envía | Autenticación fallida | Verificar credenciales en Credential Manager |
| Bot no inicia | Servicio PAD detenido | Reiniciar: `Restart-Service UIFlowService` |

---

## 10. Respaldo y Recuperación

### Estrategia de Backup
```powershell
# Script de respaldo diario
$fecha = Get-Date -Format "yyyyMMdd"
$origen = "C:\RPA\RDA_Costo_Amortizable"
$destino = "\\servidor-backup\RPA\RDA_Costo_Amortizable_$fecha"

Copy-Item -Path $origen -Destination $destino -Recurse -Force
```

### Recuperación ante Desastres
1. Restaurar carpeta desde backup
2. Reinstalar Power Automate Desktop
3. Importar flujo desde `.txt` backup
4. Restaurar credenciales en Credential Manager
5. Ejecutar prueba de flujo

---

**Versión:** 1.0  
**Fecha de Creación:** 10/11/2025  
**Próxima Revisión:** Mensual
