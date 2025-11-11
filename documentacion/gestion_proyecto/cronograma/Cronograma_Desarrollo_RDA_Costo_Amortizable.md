# Cronograma de Desarrollo - RDA Costo Amortizable

**Proyecto:** Automatización RDA Costo Amortizable  
**Versión:** 1.0  
**Fecha:** 10/11/2025  
**Desarrollador:** Ronald Estiven Rios Hernandez  
**Dueño de Proceso:** Carol Patricia Campos González

---

## 1. RESUMEN EJECUTIVO

### 1.1 Objetivo del Proyecto
Automatizar el proceso mensual de Costo Amortizable mediante Power Automate Desktop (PAD) con integración de scripts Python, reduciendo el tiempo de ejecución de 14 horas manuales a aproximadamente 2-3 horas automatizadas.

### 1.2 Alcance
- 21 Historias de Usuario
- 4 Sprints de desarrollo
- Estimación total: 140-160 horas de desarrollo
- Duración estimada: 6-8 semanas
- Tecnologías: Power Automate Desktop + Python 3.x

---

## 2. ESTRUCTURA DE HISTORIAS DE USUARIO

### Sprint 1: Extracción y Consolidación de Datos (HU-01 a HU-07)
**Duración estimada:** 2 semanas | **Esfuerzo:** 45 horas

| HU | Nombre | Prioridad | Estimación | Estado |
|----|--------|-----------|------------|--------|
| HU-01 | Extracción de Créditos Reestructurados y Modificados desde DWH | Alta | 10h | 📝 En progreso |
| HU-02 | Preparación del Archivo de Consolidación | Alta | 5h | 📝 En progreso |
| HU-03 | Consolidar Reestructurados desde SQL a Excel | Alta | 4h | ⏳ Pendiente |
| HU-04 | Consolidar Modificados desde SQL a Excel | Alta | 4h | ⏳ Pendiente |
| HU-05 | Consolidar Reestructurados Totales desde SQL a Excel | Alta | 4h | ⏳ Pendiente |
| HU-06 | Consolidar Modificados Totales desde SQL a Excel | Alta | 4h | ⏳ Pendiente |
| HU-07 | Consolidar y Transformar Créditos Retenidos | Alta | 14h | ⏳ Pendiente |

**Entregables Sprint 1:**
- Archivo Excel consolidado con 5 pestañas pobladas
- Tablas temporales SQL creadas y validadas
- Logs de extracción y consolidación

---

### Sprint 2: Organización y Cargue a SQL (HU-08 a HU-11)
**Duración estimada:** 1.5 semanas | **Esfuerzo:** 30 horas

| HU | Nombre | Prioridad | Estimación | Estado |
|----|--------|-----------|------------|--------|
| HU-08 | Organizar Base de Reestructurados para Cargue | Alta | 8h | ⏳ Pendiente |
| HU-09 | Organizar Base de Modificados para Cargue | Alta | 6h | ⏳ Pendiente |
| HU-10 | Organizar Base de Retenciones para Cargue | Alta | 6h | ⏳ Pendiente |
| HU-11 | Cargar Información en Tablas SQL Definitivas | Alta | 10h | ⏳ Pendiente |

**Entregables Sprint 2:**
- 3 pestañas organizadas (Reestructurados, Modificados, Retenidos)
- Datos cargados en tablas SQL permanentes
- Validación de integridad de datos

---

### Sprint 3: Validaciones y Cálculos Complejos (HU-12 a HU-16)
**Duración estimada:** 2 semanas | **Esfuerzo:** 50 horas

| HU | Nombre | Prioridad | Estimación | Estado |
|----|--------|-----------|------------|--------|
| HU-12 | Validación y Completitud de Información en SQL | Alta | 8h | ⏳ Pendiente |
| HU-13 | Recolectar Información de Tasas, Plazos y Saldos | Alta | 12h | ⏳ Pendiente |
| HU-14 | Cálculo de Pérdida o Ganancia por Obligación | Alta | 14h | ⏳ Pendiente |
| HU-15 | Ejecutar Query de Variables para Cálculo Valuativo | Media | 6h | ⏳ Pendiente |
| HU-16 | Ejecutar Macro de Cálculo de Amortización | Alta | 10h | ⏳ Pendiente |

**Entregables Sprint 3:**
- Base de datos validada y completa
- Cálculos de pérdida/ganancia finalizados
- Amortización calculada para todas las obligaciones
- Archivo Excel con macro ejecutada

---

### Sprint 4: Preparación y Envío Final (HU-17 a HU-21)
**Duración estimada:** 1.5 semanas | **Esfuerzo:** 35 horas

| HU | Nombre | Prioridad | Estimación | Estado |
|----|--------|-----------|------------|--------|
| HU-17 | Preparar Formato de Envío Mensual | Alta | 6h | ⏳ Pendiente |
| HU-18 | Subir Base Valuativa a SQL | Alta | 5h | ⏳ Pendiente |
| HU-19 | Consolidar Información en Hoja Base | Media | 8h | ⏳ Pendiente |
| HU-20 | Verificación y Ajustes en Producción | Alta | 10h | ⏳ Pendiente |
| HU-21 | Cargue Final de Costo Amortizado | Alta | 6h | ⏳ Pendiente |

**Entregables Sprint 4:**
- Archivo final de cargue generado
- Validación en producción completada
- Documentación de ejecución
- Notificaciones enviadas

---

## 3. DIAGRAMA DE DEPENDENCIAS

```
HU-01 (Extracción DWH)
  ↓
HU-02 (Preparar Excel)
  ↓
┌─────────────┬─────────────┬─────────────┬─────────────┐
HU-03         HU-04         HU-05         HU-06         HU-07
(Consol.      (Consol.      (Reestruct.   (Modif.       (Retenidos)
Reestruct.)   Modif.)       Totales)      Totales)
└─────────────┴─────────────┴─────────────┴─────────────┘
  ↓
┌──────────────┬──────────────┬──────────────┐
HU-08          HU-09          HU-10
(Org.          (Org.          (Org.
Reestruct.)    Modif.)        Retenc.)
└──────────────┴──────────────┴──────────────┘
  ↓
HU-11 (Cargar a SQL)
  ↓
HU-12 (Validación Completitud)
  ↓
HU-13 (Tasas, Plazos, Saldos)
  ↓
HU-14 (Cálculo Pérdida/Ganancia)
  ↓
HU-15 (Query Variables Valuativas)
  ↓
HU-16 (Macro Amortización)
  ↓
HU-17 (Formato Envío)
  ↓
HU-18 (Subir Base Valuativa)
  ↓
HU-19 (Consolidar Hoja Base)
  ↓
HU-20 (Verificación Producción)
  ↓
HU-21 (Cargue Final)
```

---

## 4. ESTIMACIÓN DE TIEMPOS

### 4.1 Resumen por Sprint

| Sprint | HUs | Desarrollo | Pruebas | Total | Duración |
|--------|-----|------------|---------|-------|----------|
| Sprint 1 | 7 | 36h | 9h | 45h | 2 semanas |
| Sprint 2 | 4 | 24h | 6h | 30h | 1.5 semanas |
| Sprint 3 | 5 | 40h | 10h | 50h | 2 semanas |
| Sprint 4 | 5 | 28h | 7h | 35h | 1.5 semanas |
| **Total** | **21** | **128h** | **32h** | **160h** | **7 semanas** |

### 4.2 Distribución por Tecnología

| Tecnología | Horas | Porcentaje |
|------------|-------|------------|
| Power Automate Desktop | 95h | 59% |
| Python (Scripts) | 33h | 21% |
| Pruebas | 32h | 20% |
| **Total** | **160h** | **100%** |

### 4.3 Historias Críticas (Ruta Crítica)

Las siguientes HU son críticas y cualquier retraso impacta la fecha de entrega:

1. **HU-01:** Extracción DWH - Sin esto, nada funciona
2. **HU-07:** Retenidos - Proceso manual complejo de transformación
3. **HU-11:** Cargue SQL - Punto de integración crítico
4. **HU-14:** Cálculo Pérdida/Ganancia - Lógica de negocio compleja
5. **HU-16:** Macro Amortización - Integración con VBA existente
6. **HU-21:** Cargue Final - Entrega al usuario final

---

## 5. HITOS DEL PROYECTO

| Hito | Fecha Estimada | Entregables |
|------|----------------|-------------|
| **Inicio del Proyecto** | Semana 1 - Día 1 | Kick-off, configuración de ambiente |
| **Fin Sprint 1** | Semana 2 - Día 5 | Extracción y consolidación funcionando |
| **Fin Sprint 2** | Semana 4 - Día 3 | Cargue a SQL operativo |
| **Fin Sprint 3** | Semana 6 - Día 5 | Cálculos complejos completados |
| **Fin Sprint 4** | Semana 7 - Día 5 | Proceso completo automatizado |
| **Pruebas UAT** | Semana 8 | Pruebas con usuario final |
| **Pase a Producción** | Semana 8 - Día 5 | Go-Live |

---

## 6. RECURSOS NECESARIOS

### 6.1 Recursos Humanos

| Rol | Recurso | Dedicación | Responsabilidades |
|-----|---------|------------|-------------------|
| Desarrollador RDA | Ronald Rios | 100% | Desarrollo PAD + Python |
| Dueño de Proceso | Carol Campos | 20% | Validaciones funcionales |
| Especialista CoE | Jeimy Lozano | 30% | Revisiones técnicas |
| Tester/QA | Por definir | 50% | Pruebas integradas |

### 6.2 Recursos Técnicos

| Recurso | Especificación | Uso |
|---------|----------------|-----|
| VM/Máquina RDA | Windows Server 2019+ | Ejecución de PAD |
| Power Automate Desktop | v2.30+ | Desarrollo y ejecución |
| Python | 3.8+ | Scripts auxiliares |
| SQL Server | 2016+ | Almacenamiento de datos |
| Microsoft Excel | 2016+ | Procesamiento de archivos |
| Visual Studio Code | Última versión | Desarrollo Python |

### 6.3 Accesos Requeridos

- Servidor SQL: `10.1.3.101\SCC` (lectura/escritura)
- Servidor SQL: `10.1.5.172\RIESGOS` (lectura)
- Carpetas de red compartidas
- Correo electrónico para notificaciones
- Repositorio de código (Git)

---

## 7. RIESGOS Y MITIGACIONES

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Cambios en estructura de DWH | Media | Alto | Coordinación estrecha con equipo DWH |
| Macro VBA no compatible | Baja | Alto | Refactorizar macro a Python |
| Servidor SQL no disponible | Baja | Alto | Implementar reintentos y notificaciones |
| Requerimientos cambian mid-sprint | Media | Medio | Change control process |
| Recursos no disponibles | Media | Alto | Buffer de 20% en cronograma |
| Validaciones UAT fallan | Media | Medio | Pruebas tempranas con usuario |

---

## 8. PLAN DE COMUNICACIÓN

### 8.1 Reuniones de Seguimiento

| Reunión | Frecuencia | Participantes | Objetivo |
|---------|------------|---------------|----------|
| Daily Stand-up | Diaria (15 min) | Equipo desarrollo | Sincronización diaria |
| Sprint Review | Fin de sprint | Todos | Demostración de avances |
| Sprint Planning | Inicio de sprint | Todos | Planificar siguiente sprint |
| Status Report | Semanal | Stakeholders | Reporte de avances |

### 8.2 Canales de Comunicación

- **Incidencias críticas:** Email + Teams
- **Consultas técnicas:** Teams/Slack
- **Documentación:** Confluence/SharePoint
- **Código:** Azure DevOps/GitHub

---

## 9. CRITERIOS DE ACEPTACIÓN DEL PROYECTO

### 9.1 Funcionales
- ✅ Las 21 HU funcionan correctamente end-to-end
- ✅ El proceso completo se ejecuta en menos de 3 horas
- ✅ Tasa de error < 5%
- ✅ Precisión de cálculos > 99.5%

### 9.2 No Funcionales
- ✅ El asistente puede ejecutarse desatendido
- ✅ Logs completos y trazables de cada ejecución
- ✅ Notificaciones automáticas en caso de errores
- ✅ Documentación técnica y funcional completa
- ✅ Manual de usuario creado

### 9.3 Técnicos
- ✅ Código versionado en repositorio
- ✅ Manejo robusto de excepciones
- ✅ Configuración parametrizada (no hardcoded)
- ✅ Cumple estándares de desarrollo del banco

---

## 10. PLAN DE PRUEBAS

### 10.1 Pruebas Unitarias (Cada HU)
- Pruebas de cada historia individual
- Validación de salidas esperadas
- Manejo de errores

### 10.2 Pruebas de Integración
- Flujo completo HU-01 a HU-21
- Validación de datos entre HUs
- Sincronización de componentes

### 10.3 Pruebas de Aceptación Usuario (UAT)
- Ejecución supervisada con usuario final
- Validación de cálculos contra proceso manual
- Validación de reportes finales
- Aprobación formal

### 10.4 Pruebas de Producción
- Ejecución en ambiente productivo
- Monitoreo de primera ejecución
- Validación de tiempos de ejecución
- Validación de notificaciones

---

## 11. PLAN DE CAPACITACIÓN

| Actividad | Duración | Participantes | Contenido |
|-----------|----------|---------------|-----------|
| Capacitación técnica PAD | 2 horas | Desarrollador | Uso de Power Automate Desktop |
| Capacitación proceso negocio | 3 horas | Desarrollador | Entendimiento del proceso |
| Capacitación usuario final | 2 horas | Carol Campos | Uso del asistente, monitoreo |
| Capacitación soporte | 2 horas | Equipo soporte | Troubleshooting básico |

---

## 12. PLAN DE ROLLOUT

### Fase 1: Piloto (Mes 1)
- Ejecución paralela: Manual + Automatizado
- Validación de resultados
- Ajustes finos

### Fase 2: Producción Parcial (Mes 2)
- 50% automatizado, 50% manual
- Monitoreo intensivo
- Refinamiento

### Fase 3: Producción Total (Mes 3)
- 100% automatizado
- Usuario realiza solo validaciones
- Proceso estabilizado

---

## 13. SIGUIENTE PASOS

### Inmediatos (Esta semana)
1. ✅ Crear estructura de historias de usuario
2. ⏳ Completar HU-01 y HU-02
3. ⏳ Configurar ambiente de desarrollo
4. ⏳ Establecer conexiones a servidores SQL

### Corto Plazo (Próximas 2 semanas)
1. Completar Sprint 1 (HU-01 a HU-07)
2. Realizar primera demo con usuario
3. Ajustar basado en feedback
4. Iniciar Sprint 2

### Mediano Plazo (Próximo mes)
1. Completar Sprints 2 y 3
2. Pruebas de integración
3. Documentación técnica

---

**Aprobado por:**

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| Dueño de Proceso | Carol Patricia Campos | | |
| Especialista CoE | Jeimy Johana Lozano | | |
| Desarrollador | Ronald Estiven Rios | | |

---

**Documento:** Cronograma de Desarrollo - RDA Costo Amortizable  
**Versión:** 1.0  
**Fecha:** 10/11/2025  
**Páginas:** 4
