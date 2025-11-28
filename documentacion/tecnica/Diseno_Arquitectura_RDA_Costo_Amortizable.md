# Diseño de Solución de Arquitectura
## RDA - Costo Amortizable
### Exclusivo para Banco Caja Social

**Fecha:** 28 de noviembre de 2025  
**Versión:** 1.0  
**Estado:** En Desarrollo

---

## Tabla de Contenido

1. [Lista de Distribución](#lista-de-distribución)
2. [Introducción](#introducción)
3. [Audiencia](#audiencia)
4. [Descripción de la Solución](#descripción-de-la-solución)
5. [Alcance](#alcance)
6. [Prerrequisitos](#prerrequisitos)
7. [Diagramas de la Solución](#diagramas-de-la-solución)
   - 7.1. [Diagrama de Vista de Contexto](#diagrama-de-vista-de-contexto)
   - 7.2. [Diagrama de Componentes del Sistema](#diagrama-de-componentes-del-sistema)
   - 7.3. [Diagrama de Componentes del Asistente](#diagrama-de-componentes-del-asistente)
   - 7.4. [Diagrama de Secuencia](#diagrama-de-secuencia)
8. [Arquitectura Empresarial](#arquitectura-empresarial)
   - 8.1. [Arquitectura de Licenciamiento](#arquitectura-de-licenciamiento)
   - 8.2. [Arquitectura de Implementación RPA](#arquitectura-de-implementación-rpa)
9. [Diagramas de Ejecución y Reglas de Negocio](#diagramas-de-ejecución-y-reglas-de-negocio)
   - 9.1. [Flujo del Proceso Principal](#flujo-del-proceso-principal)
   - 9.2. [Subprocesos y Componentes](#subprocesos-y-componentes)
10. [Parametría y Configuraciones](#parametría-y-configuraciones)
    - 10.1. [Parámetros en Configuración Maestro - JSON](#parámetros-en-configuración-maestro---json)
    - 10.2. [Parámetros en Configuración Máquina - JSON](#parámetros-en-configuración-máquina---json)
    - 10.3. [Parámetros de Conexión SQL](#parámetros-de-conexión-sql)
    - 10.4. [Parámetros Azure Key Vault](#parámetros-azure-key-vault)
11. [Optimización de Consultas SQL](#optimización-de-consultas-sql)
12. [Plantillas y Archivos de Trabajo](#plantillas-y-archivos-de-trabajo)
13. [Integración con Python](#integración-con-python)
14. [Manejo de Errores](#manejo-de-errores)
    - 14.1. [Puntos de Control Críticos](#puntos-de-control-críticos)
    - 14.2. [Estrategia de Reintentos](#estrategia-de-reintentos)
15. [Eficiencia del Asistente](#eficiencia-del-asistente)
    - 15.1. [Carga Operativa Actual (Manual)](#carga-operativa-actual-manual)
    - 15.2. [Carga Operativa del Asistente (Automatizado)](#carga-operativa-del-asistente-automatizado)
16. [Integración con Sistemas](#integración-con-sistemas)
17. [Dimensionamiento](#dimensionamiento)
    - 17.1. [Hardware](#hardware)
    - 17.2. [Licenciamiento](#licenciamiento)
    - 17.3. [Software](#software)
18. [Monitoreo y Logs](#monitoreo-y-logs)
19. [Control de Versiones](#control-de-versiones)
20. [Referencias](#referencias)

---

## Lista de Distribución

| Nombre | Cargo | Correo Electrónico |
|--------|-------|-------------------|
| Carol Patricia Campos González | Coordinación de Portafolio - Usuario Funcional | ccamposg@fgs.co |
| Coordinador de Riesgos | Product Owner | coordinador.riesgos@fgs.co |
| Ronald Estiven Rios | Desarrollador RPA | rriosh@fgs.co |
| Jeimy Johana Lozano | Especialista RPA | jelozanog@fgs.co |
| Líder RPA | Scrum Master | lider.rpa@cajasocial.com |
| Arquitecto de Solución | Arquitecto TI | arquitecto.ti@cajasocial.com |
| Soporte Infraestructura | Equipo TI | soporte.ti@cajasocial.com |

---

## Introducción

El propósito de este documento es establecer los componentes de software y hardware necesarios para desarrollar el asistente RPA del proyecto **RDA - Costo Amortizable**.

En este documento se detalla el comportamiento técnico de cada componente asociado al asistente. Estos componentes se basan en los insumos generados en las fases de análisis funcional, documentados en el **PDD (Process Design Document)** v1.0 y las **14 Historias de Usuario (HU-01 a HU-14)**, presentados por el área de Riesgos y aprobados por la Coordinación de Portafolio.

Además, se proporcionan diagramas representativos que muestran:
- La secuencia de ejecución del proceso
- La interacción entre componentes
- La arquitectura técnica de la solución
- Los puntos de integración con sistemas empresariales

Todo esto presentado de manera clara y técnicamente precisa para facilitar el desarrollo, implementación y mantenimiento del asistente RPA.

---

## Audiencia

Este documento está dirigido principalmente a:

- **Usuarios de Negocio**: Coordinación de Portafolio, Coordinador de Riesgos
- **Desarrolladores RPA**: Equipo de desarrollo Power Automate Desktop
- **Arquitectura TI**: Arquitectos de solución y seguridad
- **Infraestructura**: Equipo de IT y operaciones
- **Seguridad**: Equipos de ciberseguridad y UAC (User Access Control)
- **QA/Testing**: Equipo de pruebas y validación

Además de servir como referencia técnica para equipos de desarrollo, arquitectura y soporte en futuras mejoras o mantenimientos del asistente.

---

## Descripción de la Solución

### Objetivo del Proceso

Automatizar el proceso mensual de cálculo del **Costo Amortizable** para operaciones de reestructuraciones, modificaciones y retenciones de créditos en Banco Caja Social.

### Descripción Técnica

El proceso automatizado realiza las siguientes operaciones:

1. **Extracción de Datos**: Consulta y extrae información desde dos servidores SQL Server:
   - **DWH_CC** (10.1.3.101\SCC): Base de datos de Data Warehouse Cartera
   - **DWH_Riesgos_Credito** (10.1.5.172\RIESGOS): Base de datos de Gestión de Riesgos

2. **Consolidación de Información**: 
   - Procesa datos de reestructuraciones y modificaciones
   - Transforma información de créditos retenidos
   - Aplica queries SQL optimizados (6 scripts principales: 01-06)
   - Genera archivos Excel consolidados con plantillas predefinidas

3. **Organización y Clasificación**:
   - Clasifica obligaciones por tipo (Consolidada vs Individual)
   - Organiza por categoría de producto
   - Segrega información para cargue SQL

4. **Cargue a Base de Datos**:
   - Carga información procesada a SQL Server
   - Crea tablas mensuales dinámicas (bd_reestructurados_MM_AAAA, bd_modificados_MM_AAAA, etc.)
   - Valida completitud de datos via Linked Server

5. **Validaciones y Cálculos Financieros**:
   - Valida completitud de información (HU-12)
   - Recolecta tasas, plazos y saldos históricos (HU-13)
   - Calcula pérdidas y ganancias por modificación (HU-14)
   - Genera variables de cálculo valor valuativo (HU-15)

6. **Ejecución de Macros VBA**:
   - Ejecuta macro de amortización en Excel
   - Genera tablas de amortización por obligación
   - Aplica fórmulas financieras complejas

7. **Generación de Reporte Final**:
   - Consolida información en formato estándar (.xls Excel 97-2003)
   - Genera hoja BASE con 50+ columnas de información
   - Aplica validaciones y filtros finales
   - Calcula hash SHA-256 para integridad

8. **Entrega y Notificaciones**:
   - Carga archivo final a SQL Server (bd_costo_amortizable_MM_AAAA)
   - Almacena en servidor de archivos
   - Envía notificaciones automáticas por email a 3+ destinatarios

### Nombre Técnico del Asistente

**R_RDA_CostoAmortizable**

Donde RDA es el acrónimo de:
- **R** = Remote
- **D** = Desktop
- **A** = Automation

*(Remote Desktop Automation - Automatización de Escritorio Remoto)*

### Tecnología de Implementación

La solución se implementará utilizando:

- **Power Automate Desktop** versión 2.30+ (última versión estable disponible)
- **Patrón de diseño**: Alta cohesión y bajo acoplamiento
- **Arquitectura modular**: Componentes estructurados en flujos identificados por funcionalidad
- **Tipo de asistente**: **Atendido** (Attended) - Ejecución con supervisión del usuario bajo demanda
- **Frecuencia de ejecución**: Mensual o **a disposición del usuario** (recomendado: último día hábil del mes)
- **Modo de operación**: Remote Desktop Automation (RDA) - El usuario inicia el proceso cuando lo requiera
- **Integración con Python**: Scripts auxiliares para procesamiento avanzado de datos
- **Manejo de Excel**: Automatización de plantillas y ejecución de macros VBA

### Reducción de Tiempos

| Métrica | Proceso Manual (AS-IS) | Proceso Automatizado (TO-BE) | Mejora |
|---------|------------------------|------------------------------|--------|
| **Tiempo de Ejecución** | 14 horas (2 días) | 15 minutos | **95% reducción** |
| **Intervención Humana** | 100% manual | 5% (supervisión) | **95% automatización** |
| **Errores Humanos** | ~10-15 por mes | <2 por mes | **85% reducción** |
| **Registros Procesados** | 1,000-1,500/mes | 1,000-1,500/mes | Mismo volumen |
| **Disponibilidad** | Horario laboral | 24/7 programable | **Continuidad** |

---

## Alcance

### Incluido en el Alcance

✅ **Extracción Automatizada**:
- Conexión a servidores SQL Server (DWH_CC y DWH_Riesgos_Credito)
- Ejecución de 6 queries SQL optimizados (scripts 01-06)
- Manejo de timeouts y reintentos de conexión

✅ **Procesamiento de Datos**:
- Consolidación de reestructuraciones (query 01)
- Consolidación de modificaciones (query 01)
- Transformación de créditos retenidos (query 01)
- Clasificación por tipo de obligación

✅ **Cargue a Base de Datos**:
- Creación dinámica de tablas mensuales
- Validación de duplicados
- Verificación de integridad de datos

✅ **Validaciones Financieras**:
- Completitud de información via Linked Server
- Recolección de tasas y plazos históricos
- Cálculos de pérdidas/ganancias

✅ **Ejecución de Macros VBA**:
- Automatización de Excel con macros preexistentes
- Generación de tablas de amortización
- Aplicación de fórmulas financieras

✅ **Generación de Reportes**:
- Formato estándar .xls (Excel 97-2003)
- Hoja BASE consolidada (50+ columnas)
- Cálculo de hash para validación

✅ **Notificaciones**:
- Envío de emails automáticos
- Reportes de éxito/error
- Adjuntar archivo final

### Excluido del Alcance

❌ **Análisis de datos**: El asistente no realiza análisis financiero, solo consolida información  
❌ **Aprobaciones**: No incluye flujos de aprobación, solo notifica  
❌ **Modificación de fuentes**: No modifica estructuras de bases de datos origen  
❌ **Modificaciones con Start4u o Tareas Humanas**: Solo se conecta a DWH_CC y DWH_Riesgos_Credito para ejecutar los querys que anteriormente realizaba el usuario  
❌ **OCR o IA**: No incluye procesamiento de documentos con IA (a diferencia de LyD)  
❌ **Dashboard en tiempo real**: Monitoreo via logs y notificaciones únicamente  

### Historias de Usuario Incluidas

El alcance técnico implementa las siguientes 14 Historias de Usuario:

| HU | Descripción | Complejidad |
|----|-------------|-------------|
| **HU-01** | Extracción DWH Reestructurados/Modificados | Alta |
| **HU-02** | Preparación Archivo Consolidación | Media |
| **HU-03** | Consolidar Reestructurados SQL-Excel | Alta |
| **HU-04** | Consolidar Modificados SQL-Excel | Alta |
| **HU-05** | Consolidar Reestructurados Totales | Alta |
| **HU-06** | Consolidar Modificados Totales | Alta |
| **HU-07** | Consolidar y Transformar Retenidos | Alta |
| **HU-08** | Organizar Reestructurados para Cargue | Media |
| **HU-09** | Organizar Modificados para Cargue | Media |
| **HU-10** | Organizar Retenciones para Cargue | Media |
| **HU-11** | Cargue a SQL Server | Alta |
| **HU-12** | Validación Completitud SQL | Alta |
| **HU-13** | Recolección Tasas/Plazos/Saldos | Alta |
| **HU-14** | Cálculo Pérdida/Ganancia | Crítica |

**Total**: 14 HU | **Esfuerzo estimado**: 165.5 horas desarrollo

---

## Prerrequisitos

### Resumen de Componentes Requeridos

| Componente | Detalle | Observaciones |
|------------|---------|---------------|
| **Licenciamiento** | Licencia Power Automate Desktop Attended (Free o Premium) | Ver sección [17.2 Licenciamiento](#licenciamiento) |
| **Escritorio del Usuario** | Windows 10/11 Pro, usuario funcional con sesión activa, puertos 80/443 | Ver sección [17.1 Hardware](#hardware) |
| **Integración SQL** | Usuarios SQL con permisos SELECT/INSERT, Linked Server configurado | Ver sección [16. Integración](#integración-con-sistemas) |
| **Integración Excel** | Microsoft Excel 2016+, macros habilitadas, plantillas configuradas | Ver sección [12. Plantillas](#plantillas-y-archivos-de-trabajo) |
| **Software Adicional** | Python 3.8+, librerías (pandas, pyodbc, openpyxl) | Ver sección [17.3 Software](#software) |
| **Servidor de Archivos** | Acceso de red a carpetas compartidas, permisos lectura/escritura | IP: [Definir] |
| **Credenciales** | Azure Key Vault o archivo .env con credenciales SQL y SMTP | Ver sección [10.4 Azure Key Vault](#parámetros-azure-key-vault) |
| **Datos de Prueba** | Dataset de 1-3 meses históricos con casuísticas completas | Ver documentación de testing |

### Detalle de Prerrequisitos por Categoría

#### 1. Licenciamiento Power Automate
- **Licencia tipo**: Attended (Atendido) - El usuario debe estar presente
- **Modalidad**: Power Automate Desktop Free o Premium (según disponibilidad)
- Licencia por **usuario** (no requiere licencia por máquina para modo attended)
- Licencia por **ambiente** (desarrollo, QA, producción - si aplica)
- Acceso a Power Platform admin center (solo para configuración inicial)

#### 2. Infraestructura de Máquinas
- **Sistema Operativo**: Windows 10 Pro (64-bit) o Windows 11 Pro
- **Tipo de máquina**: Estación de trabajo del usuario o escritorio remoto (RDA)
- **Usuarios**: Usuario funcional (Carol Patricia Campos) con permisos necesarios
- **Sesión activa**: El usuario debe mantener sesión abierta durante la ejecución
- **Conectividad de Red**: 
  - Puertos abiertos: 80, 443 (salida para servicios cloud si se usa Power Platform)
  - VPN corporativa configurada (si aplica)
  - Acceso a redes internas donde residen servidores SQL
- **Firewall**: Reglas configuradas para permitir conexión a:
  - 10.1.3.101\SCC (DWH_CC)
  - 10.1.5.172\RIESGOS (DWH_Riesgos_Credito)

#### 3. Integración con SQL Server
- **Usuarios SQL**: Crear usuarios RPA por cada máquina virtual
- **Permisos en DWH_CC**:
  - SELECT en tablas de reestructurados y modificaciones
  - INSERT/CREATE en esquema temporal para cargue
- **Permisos en DWH_Riesgos_Credito**:
  - SELECT en tablas de información histórica
  - Acceso a Linked Server para validaciones de completitud
- **Drivers**: SQL Server Native Client 11.0 o superior

#### 4. Microsoft Excel
- **Versión**: Microsoft Excel 2016, 2019, 2021 o Microsoft 365
- **Configuración**:
  - Macros habilitadas (Trust Center settings)
  - Complementos VBA activos
  - Plantillas ubicadas en `data/input/plantillas/`
- **Formatos soportados**: .xlsx, .xls (Excel 97-2003 para entregables)

#### 5. Python (Scripts Auxiliares)
- **Versión**: Python 3.8, 3.9, 3.10 o 3.11
- **Librerías requeridas**:
  ```
  pandas>=1.3.0
  openpyxl>=3.0.9
  pyodbc>=4.0.32
  python-dotenv>=0.19.0
  ```
- **PATH configurado**: Python accesible desde Power Automate Desktop

#### 6. Servidor de Archivos
- **Acceso de red**: Usuario RPA con permisos de lectura/escritura para generar las siguientes rutas:
- **Rutas requeridas**:
  - Input: `\\servidor\RDA_CostoAmortizable\input\` (plantillas)
  - Output: `\\servidor\RDA_CostoAmortizable\output\reportes\` (archivos finales)
  - Logs: `\\servidor\RDA_CostoAmortizable\logs\` (trazabilidad)
  - Temp: `\\servidor\RDA_CostoAmortizable\temp\` (procesamiento)

#### 7. Credenciales y Secretos
- **Azure Key Vault**: Vault configurado con secretos para:
  - Conexiones SQL Server (usuario/password)
  - Credenciales SMTP para notificaciones
  - Claves de encriptación para archivos
- **Alternativa local**: Archivo `.env` encriptado (solo desarrollo/QA)

#### 8. Datos de Prueba
- Dataset histórico de 1-3 meses completos
- Incluir casuísticas:
  - Reestructuraciones consolidadas e individuales
  - Modificaciones con y sin cambio de plazo
  - Créditos retenidos transformados
  - Casos con información incompleta (para validar Linked Server)
  - Errores controlados (para validar manejo de excepciones)

---

## Diagramas de la Solución

### Diagrama de Vista de Contexto

A través del siguiente diagrama de contexto del sistema, se pretende abordar los requisitos y necesidades para la configuración inicial de la infraestructura previo al inicio del desarrollo. Cada sistema relacionado está sujeto a posibles mejoras según se refine este modelo.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        DIAGRAMA DE CONTEXTO                             │
│                    RDA - Costo Amortizable                              │
└─────────────────────────────────────────────────────────────────────────┘

    ┌──────────────────┐
    │   Coordinación   │
    │  de Portafolio   │──────┐
    │ (Carol Campos)   │      │
    └──────────────────┘      │
                              │ Notificaciones
                              │ Email (Éxito/Error)
                              ▼
    ┌──────────────────────────────────────────────────────────┐
    │                                                          │
    │        POWER AUTOMATE DESKTOP (Atendido - RDA)         │
    │              R_RDA_CostoAmortizable                     │
    │            (A disposición del usuario)                  │
    │                                                          │
    │   ┌──────────────────────────────────────────────┐     │
    │   │  COMPONENTES PRINCIPALES                     │     │
    │   │  • Main (Orquestador)                        │     │
    │   │  • SQL_Extraccion (HU-01)                    │     │
    │   │  • Excel_Consolidacion (HU-02 a HU-07)       │     │
    │   │  • SQL_Cargue (HU-08 a HU-11)                │     │
    │   │  • Validaciones (HU-12 a HU-14)              │     │
    │   │  • Python_Scripts (Auxiliar)                 │     │
    │   │  • VBA_Macros (HU-16)                        │     │
    │   │  • Reportes_Final (HU-17 a HU-21)            │     │
    │   │  • Notificaciones                            │     │
    │   └──────────────────────────────────────────────┘     │
    │                                                          │
    └────┬──────────────────┬───────────────────┬────────────┘
         │                  │                   │
         │                  │                   │
         ▼                  ▼                   ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   SQL Server    │  │   SQL Server    │  │ Servidor de     │
│   10.1.3.101    │  │  10.1.5.172     │  │    Archivos     │
│      \SCC       │  │    \RIESGOS     │  │  (Compartido)   │
├─────────────────┤  ├─────────────────┤  ├─────────────────┤
│  DWH_CC         │  │ DWH_Riesgos_    │  │ • Plantillas    │
│                 │  │    Credito      │  │ • Reportes      │
│ • Reestruct.    │  │                 │  │ • Logs          │
│ • Modificados   │  │ • Tasas histór. │  │ • Temp          │
│ • Retenciones   │  │ • Plazos        │  │                 │
│                 │  │ • Saldos        │  │                 │
│ [Linked Server]─┼──│ • Completitud   │  │                 │
└─────────────────┘  └─────────────────┘  └─────────────────┘
         │                  │
         │ INSERT           │ SELECT
         ▼                  │
┌─────────────────┐         │
│  Tablas Cargue  │◄────────┘
│  (Mensuales)    │
├─────────────────┤
│ bd_reestruct_   │
│   MM_AAAA       │
│ bd_modificados_ │
│   MM_AAAA       │
│ bd_costo_amort_ │
│   MM_AAAA       │
└─────────────────┘

         │
         │ Carga Final
         ▼
┌─────────────────────────────────────────┐
│      ARCHIVO FINAL GENERADO             │
│  COSTO_AMORTIZABLE_MM_AAAA.xls          │
│  • Hoja BASE (50+ columnas)             │
│  • Hash SHA-256                         │
│  • 1,000-1,500 registros                │
└─────────────────────────────────────────┘

LEYENDA:
──────►  Flujo de datos
═══════  Conexión bidireccional
[     ]  Componente auxiliar
```

### Diagrama de Componentes del Sistema

El siguiente diagrama muestra los componentes del sistema y sus interacciones a nivel técnico:

```
┌───────────────────────────────────────────────────────────────────────┐
│                   ARQUITECTURA DE COMPONENTES                         │
│                      Sistema RDA - Costo Amortizable                  │
└───────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                     CAPA DE PRESENTACIÓN                            │
├─────────────────────────────────────────────────────────────────────┤
│  • Power Automate Desktop UI (Desarrollo)                           │
│  • Logs en consola (Ejecución)                                      │
│  • Notificaciones Email (Resultado)                                 │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   CAPA DE ORQUESTACIÓN                              │
├─────────────────────────────────────────────────────────────────────┤
│                        Main.xaml                                    │
│  ┌───────────────────────────────────────────────────────────┐     │
│  │ • Carga configuración JSON                                │     │
│  │ • Inicializa variables globales                           │     │
│  │ • Invoca componentes en secuencia                         │     │
│  │ • Maneja errores globales                                 │     │
│  │ • Genera log unificado                                    │     │
│  │ • Envía notificaciones finales                            │     │
│  └───────────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   CAPA DE COMPONENTES (Flujos PAD)                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────────────┐  ┌──────────────────────┐               │
│  │ 01_SQL_Extraccion    │  │ 02_Excel_Preparacion │               │
│  │ (HU-01)              │  │ (HU-02)              │               │
│  │ • Conecta DWH_CC     │  │ • Abre plantilla     │               │
│  │ • Ejecuta Query 01   │  │ • Configura formato  │               │
│  │ • Extrae datos       │  │ • Crea hojas         │               │
│  └──────────────────────┘  └──────────────────────┘               │
│           │                          │                             │
│           └──────────┬───────────────┘                             │
│                      ▼                                              │
│  ┌──────────────────────────────────────────────────────┐          │
│  │ 03-07_Consolidacion                                  │          │
│  │ • 03: Consolida Reestructurados SQL→Excel (HU-03)    │          │
│  │ • 04: Consolida Modificados SQL→Excel (HU-04)        │          │
│  │ • 05: Consolida Reestructurados Totales (HU-05)      │          │
│  │ • 06: Consolida Modificados Totales (HU-06)          │          │
│  │ • 07: Transforma Retenidos (HU-07)                   │          │
│  └──────────────────────────────────────────────────────┘          │
│                      │                                              │
│                      ▼                                              │
│  ┌──────────────────────────────────────────────────────┐          │
│  │ 08-10_Organizacion                                   │          │
│  │ • 08: Organiza Reestructurados para cargue (HU-08)   │          │
│  │ • 09: Organiza Modificados para cargue (HU-09)       │          │
│  │ • 10: Organiza Retenciones para cargue (HU-10)       │          │
│  │ • Clasifica: Consolidada vs Individual               │          │
│  └──────────────────────────────────────────────────────┘          │
│                      │                                              │
│                      ▼                                              │
│  ┌──────────────────────────────────────────────────────┐          │
│  │ 11_SQL_Cargue (HU-11)                                │          │
│  │ • Crea tablas dinámicas (bd_*_MM_AAAA)               │          │
│  │ • Carga datos desde Excel                            │          │
│  │ • Valida duplicados                                  │          │
│  └──────────────────────────────────────────────────────┘          │
│                      │                                              │
│                      ▼                                              │
│  ┌──────────────────────────────────────────────────────┐          │
│  │ 12-14_Validaciones_Calculos                          │          │
│  │ • 12: Validación Completitud (HU-12)                 │          │
│  │       → Query via Linked Server                      │          │
│  │ • 13: Recolección Tasas/Plazos/Saldos (HU-13)        │          │
│  │ • 14: Cálculo Pérdida/Ganancia (HU-14)               │          │
│  │       → Fórmulas financieras complejas               │          │
│  └──────────────────────────────────────────────────────┘          │
│                      │                                              │
│                      ▼                                              │
│  ┌──────────────────────────────────────────────────────┐          │
│  │ 15-16_Python_VBA                                     │          │
│  │ • 15: Calcula Variables Valor Valuativo (Python)     │          │
│  │ • 16: Ejecuta Macro VBA Amortización                 │          │
│  │       → Genera tablas amortización                   │          │
│  └──────────────────────────────────────────────────────┘          │
│                      │                                              │
│                      ▼                                              │
│  ┌──────────────────────────────────────────────────────┐          │
│  │ 17-21_Reporte_Final                                  │          │
│  │ • 17: Genera formato envío mensual (HU-17)           │          │
│  │ • 18: Consolida hoja BASE (HU-18)                    │          │
│  │ • 19: Aplica verificaciones finales (HU-19)          │          │
│  │ • 20: Carga a SQL bd_costo_amortizable (HU-20)       │          │
│  │ • 21: Envía notificaciones (HU-21)                   │          │
│  └──────────────────────────────────────────────────────┘          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   CAPA DE INTEGRACIÓN                               │
├─────────────────────────────────────────────────────────────────────┤
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐       │
│  │ SQL_Connector  │  │ Excel_Handler  │  │ Python_Runner  │       │
│  │ • pyodbc       │  │ • COM Interop  │  │ • subprocess   │       │
│  │ • Connection   │  │ • Workbook API │  │ • pandas       │       │
│  │   pooling      │  │ • VBA Execute  │  │ • openpyxl     │       │
│  └────────────────┘  └────────────────┘  └────────────────┘       │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐       │
│  │ File_Manager   │  │ Email_Sender   │  │ Logger         │       │
│  │ • UNC paths    │  │ • SMTP         │  │ • Structured   │       │
│  │ • Read/Write   │  │ • Attachments  │  │ • Timestamped  │       │
│  └────────────────┘  └────────────────┘  └────────────────┘       │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   CAPA DE DATOS                                     │
├─────────────────────────────────────────────────────────────────────┤
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐       │
│  │ DWH_CC         │  │ DWH_Riesgos_   │  │ Servidor       │       │
│  │ (10.1.3.101)   │  │ Credito        │  │ Archivos       │       │
│  │                │  │ (10.1.5.172)   │  │ (UNC Path)     │       │
│  └────────────────┘  └────────────────┘  └────────────────┘       │
│  ┌────────────────┐  ┌────────────────┐                           │
│  │ Azure Key      │  │ Config Files   │                           │
│  │ Vault          │  │ (.json, .env)  │                           │
│  └────────────────┘  └────────────────┘                           │
└─────────────────────────────────────────────────────────────────────┘
```

---

### Diagrama de Componentes del Asistente

El siguiente diagrama muestra la arquitectura modular del asistente RPA con los componentes desarrollados en Power Automate Desktop:

```
┌─────────────────────────────────────────────────────────────────┐
│           ASISTENTE RPA - R_RDA_CostoAmortizable                │
│                  (Power Automate Desktop)                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ Usuario inicia
                              │ ejecución
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        MAIN.XAML                                │
│                     (Orquestador Principal)                     │
├─────────────────────────────────────────────────────────────────┤
│ 1. Cargar Configuracion_Maestro.json                            │
│ 2. Cargar Configuracion_Maquina.json                            │
│ 3. Inicializar variables globales                               │
│ 4. Registrar inicio de proceso (Log)                            │
│ 5. Invocar flujos en secuencia                                  │
│ 6. Capturar errores globales                                    │
│ 7. Generar log consolidado                                      │
│ 8. Enviar notificación final                                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ Invoca
                              ▼
        ┌────────────────────────────────────────────┐
        │     COMPONENTES MODULARES (Subflows)       │
        └────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐    ┌──────────────┐      ┌──────────────┐
│ Configuracion│    │  Extraccion  │      │ Consolidacion│
│   y Setup    │    │     SQL      │      │    Excel     │
├──────────────┤    ├──────────────┤      ├──────────────┤
│• Init_Config │    │• 01_SQL_     │      │• 03_Consolid │
│• Load_Params │    │  Extraccion  │      │  Reestruct   │
│• Validate_   │    │• Connect_DWH │      │• 04_Consolid │
│  Prereq      │    │• Execute_    │      │  Modificados │
│              │    │  Query       │      │• 05_Reestruct│
│              │    │• Get_Data    │      │  Totales     │
│              │    │              │      │• 06_Modific  │
│              │    │              │      │  Totales     │
│              │    │              │      │• 07_Transform│
│              │    │              │      │  Retenidos   │
└──────────────┘    └──────────────┘      └──────────────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              ▼
                    ┌──────────────────┐
                    │   02_Excel_      │
                    │   Preparacion    │
                    ├──────────────────┤
                    │• Open_Template   │
                    │• Configure_      │
                    │  Sheets          │
                    │• Set_Format      │
                    └──────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐    ┌──────────────┐      ┌──────────────┐
│ Organizacion │    │  SQL_Cargue  │      │ Validaciones │
├──────────────┤    ├──────────────┤      ├──────────────┤
│• 08_Organizar│    │• 11_SQL_     │      │• 12_Validar_ │
│  Reestruct   │    │  Cargue      │      │  Completitud │
│• 09_Organizar│    │• Create_     │      │• 13_Recolect │
│  Modificados │    │  Tables      │      │  TasasPlazo  │
│• 10_Organizar│    │• Load_Data   │      │• 14_Calcular │
│  Retenciones │    │• Validate_   │      │  Perdida_    │
│              │    │  Duplicates  │      │  Ganancia    │
└──────────────┘    └──────────────┘      └──────────────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              ▼
                    ┌──────────────────┐
                    │ Python_Scripts & │
                    │   VBA_Macros     │
                    ├──────────────────┤
                    │• 15_Python_Calc_ │
                    │  Valor_Valuativo │
                    │• 16_VBA_Macro_   │
                    │  Amortizacion    │
                    └──────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐    ┌──────────────┐      ┌──────────────┐
│Reporte Final │    │  Cargue SQL  │      │Notificaciones│
├──────────────┤    ├──────────────┤      ├──────────────┤
│• 17_Generar_ │    │• 20_Cargar_  │      │• 21_Enviar_  │
│  Formato     │    │  SQL_Final   │      │  Notificacion│
│• 18_Consolid │    │• Generate_   │      │• Send_Email  │
│  Hoja_BASE   │    │  Hash_SHA256 │      │• Attach_File │
│• 19_Verificar│    │              │      │• Log_Results │
│  Final       │    │              │      │              │
└──────────────┘    └──────────────┘      └──────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  RESULTADO FINAL │
                    ├──────────────────┤
                    │• Archivo .xls    │
                    │• Tabla SQL       │
                    │• Email enviado   │
                    │• Log completo    │
                    └──────────────────┘

LEYENDA:
├──────┤  Componente PAD
│• Item│  Acción dentro del componente
▼       Flujo de ejecución
```

### Diagrama de Secuencia

El siguiente diagrama de secuencia muestra la interacción temporal entre los componentes durante la ejecución del proceso:

```
Usuario    Main      Config    SQL_Ext   Excel_Prep  Consolidacion  SQL_Cargue  Validaciones  Python/VBA  Reporte  Notific
  │          │          │         │           │             │            │           │             │          │        │
  │──Inicia──>│          │         │           │             │            │           │             │          │        │
  │          │          │         │           │             │            │           │             │          │        │
  │          │─Load────>│         │           │             │            │           │             │          │        │
  │          │<─JSON────│         │           │             │            │           │             │          │        │
  │          │          │         │           │             │            │           │             │          │        │
  │          │─Validar prereq────>│           │             │            │           │             │          │        │
  │          │<─OK─────────────────│           │             │            │           │             │          │        │
  │          │                     │           │             │            │           │             │          │        │
  │          │──Conectar DWH_CC──>│           │             │            │           │             │          │        │
  │          │<─Conectado──────────│           │             │            │           │             │          │        │
  │          │──Ejecutar Query01──>│           │             │            │           │             │          │        │
  │          │<─Datos extraídos────│           │             │            │           │             │          │        │
  │          │                     │           │             │            │           │             │          │        │
  │          │───Abrir plantilla──────────────>│             │            │           │             │          │        │
  │          │<──Excel abierto─────────────────│             │            │           │             │          │        │
  │          │                                 │             │            │           │             │          │        │
  │          │───Consolidar Reestructurados───────────────>│            │           │             │          │        │
  │          │<──Consolidado──────────────────────────────────│            │           │             │          │        │
  │          │───Consolidar Modificados────────────────────>│            │           │             │          │        │
  │          │<──Consolidado──────────────────────────────────│            │           │             │          │        │
  │          │───Transformar Retenidos─────────────────────>│            │           │             │          │        │
  │          │<──Transformado─────────────────────────────────│            │           │             │          │        │
  │          │                                                │            │           │             │          │        │
  │          │───Organizar para cargue─────────────────────>│            │           │             │          │        │
  │          │<──Organizado───────────────────────────────────│            │           │             │          │        │
  │          │                                                             │           │             │          │        │
  │          │───Crear tablas dinámicas──────────────────────────────────>│           │             │          │        │
  │          │───Cargar datos Excel→SQL────────────────────────────────────>│           │             │          │        │
  │          │<──Cargado OK───────────────────────────────────────────────────│           │             │          │        │
  │          │                                                                           │             │          │        │
  │          │───Validar completitud via Linked Server────────────────────────────────>│             │          │        │
  │          │<──Validado─────────────────────────────────────────────────────────────────│             │          │        │
  │          │───Recolectar tasas/plazos/saldos──────────────────────────────────────>│             │          │        │
  │          │<──Datos recolectados───────────────────────────────────────────────────────│             │          │        │
  │          │───Calcular pérdida/ganancia────────────────────────────────────────────>│             │          │        │
  │          │<──Cálculos completos───────────────────────────────────────────────────────│             │          │        │
  │          │                                                                                         │          │        │
  │          │───Ejecutar script Python──────────────────────────────────────────────────────────────>│          │        │
  │          │<──Variables calculadas─────────────────────────────────────────────────────────────────────│          │        │
  │          │───Ejecutar macro VBA───────────────────────────────────────────────────────────────────>│          │        │
  │          │<──Tablas amortización generadas───────────────────────────────────────────────────────────│          │        │
  │          │                                                                                                     │        │
  │          │───Generar formato final──────────────────────────────────────────────────────────────────────────>│        │
  │          │───Consolidar hoja BASE───────────────────────────────────────────────────────────────────────────>│        │
  │          │───Aplicar verificaciones──────────────────────────────────────────────────────────────────────────>│        │
  │          │<──Archivo final generado──────────────────────────────────────────────────────────────────────────────│        │
  │          │                                                                                                              │
  │          │───Cargar a SQL bd_costo_amortizable──────────────────────────────────────────────────────────────────────>│        │
  │          │───Generar hash SHA-256────────────────────────────────────────────────────────────────────────────────────>│        │
  │          │<──Cargue exitoso──────────────────────────────────────────────────────────────────────────────────────────────│        │
  │          │                                                                                                                      │
  │          │───Enviar notificaciones────────────────────────────────────────────────────────────────────────────────────────────>│
  │          │<──Email enviado────────────────────────────────────────────────────────────────────────────────────────────────────────│
  │          │                                                                                                                         │
  │<─Proceso completo───│                                                                                                                         │
  │          │                                                                                                                                     │

TIEMPOS ESTIMADOS (Proceso completo ~15 minutos):
┌─────────────────────────────────────────────────────────────┐
│ Fase                          │ Tiempo    │ % del Total    │
├──────────────────────────────────────────────────────────────┤
│ 01. Extracción SQL            │ 2 min     │ 13%            │
│ 02-07. Consolidación Excel    │ 4 min     │ 27%            │
│ 08-11. Organización y Cargue  │ 2 min     │ 13%            │
│ 12-14. Validaciones y Cálculos│ 3 min     │ 20%            │
│ 15-16. Python y VBA           │ 2 min     │ 13%            │
│ 17-21. Reporte y Notificación │ 2 min     │ 13%            │
│ TOTAL                         │ 15 min    │ 100%           │
└─────────────────────────────────────────────────────────────┘
```

### Flujo de Decisiones Críticas

El siguiente diagrama muestra los puntos de decisión críticos durante la ejecución:

```
                    [INICIO]
                       │
                       ▼
            ┌─────────────────────┐
            │ Configuración       │
            │ JSON válida?        │
            └─────────┬───────────┘
                  ┌───┴───┐
                  │       │
              [NO]│       │[SÍ]
                  │       │
                  ▼       ▼
            ┌─────────┐  ┌──────────────────┐
            │ ERROR:  │  │ Conectar DWH_CC? │
            │ Terminar│  └────────┬─────────┘
            └─────────┘       ┌───┴───┐
                              │       │
                          [NO]│       │[SÍ]
                              │       │
                              ▼       ▼
                  ┌──────────────┐   ┌──────────────────┐
                  │ Reintento 1/3│   │ Extraer datos?   │
                  └──────────────┘   └────────┬─────────┘
                              │           ┌───┴───┐
                              │           │       │
                              └───────┐[NO]│       │[SÍ]
                                      │   │       │
                                      ▼   ▼       ▼
                            ┌─────────────┐  ┌─────────────────┐
                            │ Reintento2/3│  │ Plantilla Excel │
                            └─────────────┘  │ existe?         │
                                      │      └────────┬────────┘
                                      │          ┌───┴───┐
                                      │          │       │
                                      └──────┐[NO]│       │[SÍ]
                                             │   │       │
                                             ▼   ▼       ▼
                                  ┌──────────────┐  ┌────────────────┐
                                  │ Reintento3/3 │  │ Consolidar     │
                                  └──────────────┘  │ información    │
                                             │      └────────┬───────┘
                                             │               │
                                             ▼               ▼
                                      ┌───────────┐   ┌──────────────┐
                                      │ ERROR     │   │ Datos        │
                                      │ CRÍTICO   │   │ completos?   │
                                      │ Notificar │   └─────┬────────┘
                                      └───────────┘     ┌───┴───┐
                                                        │       │
                                                    [NO]│       │[SÍ]
                                                        │       │
                                                        ▼       ▼
                                            ┌───────────────┐   ┌──────────────┐
                                            │ Ejecutar query│   │ Cargar a SQL │
                                            │ Linked Server │   │ Server       │
                                            └───────┬───────┘   └──────┬───────┘
                                                    │                   │
                                                    └───────┬───────────┘
                                                            ▼
                                                  ┌──────────────────┐
                                                  │ Validaciones OK? │
                                                  └────────┬─────────┘
                                                       ┌───┴───┐
                                                       │       │
                                                   [NO]│       │[SÍ]
                                                       │       │
                                                       ▼       ▼
                                            ┌──────────────┐   ┌──────────────┐
                                            │ Registrar    │   │ Ejecutar VBA │
                                            │ advertencia  │   │ y Python     │
                                            │ Continuar    │   └──────┬───────┘
                                            └──────────────┘          │
                                                       │               │
                                                       └───────┬───────┘
                                                               ▼
                                                     ┌──────────────────┐
                                                     │ Generar reporte  │
                                                     │ final            │
                                                     └────────┬─────────┘
                                                              ▼
                                                     ┌──────────────────┐
                                                     │ Hash coincide?   │
                                                     └────────┬─────────┘
                                                          ┌───┴───┐
                                                          │       │
                                                      [NO]│       │[SÍ]
                                                          │       │
                                                          ▼       ▼
                                              ┌──────────────┐   ┌──────────────┐
                                              │ Regenerar    │   │ Cargar a SQL │
                                              │ archivo      │   │ Enviar email │
                                              └──────────────┘   └──────┬───────┘
                                                          │               │
                                                          └───────┬───────┘
                                                                  ▼
                                                          [PROCESO EXITOSO]

PUNTOS DE CONTROL:
✓ PC01: Validación configuración JSON
✓ PC02: Conectividad SQL Server
✓ PC03: Existencia de plantillas Excel
✓ PC04: Completitud de datos extraídos
✓ PC05: Validación de cargue SQL
✓ PC06: Ejecución correcta de macros VBA
✓ PC07: Integridad archivo final (hash)
```

---

