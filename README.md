# RDA Costo Amortizable - Automatización RPA

Este repositorio contiene el proyecto de automatización para el proceso RDA (Robotic Desktop Automation) de Costo Amortizable utilizando Power Automate Desktop y/o n8n. El objetivo principal es automatizar el cálculo, análisis y reporte del costo amortizable de manera eficiente y confiable.

## 📋 Descripción del Proyecto

Proyecto de automatización RPA que optimiza el proceso de cálculo y análisis del costo amortizable, reduciendo tiempos de procesamiento y minimizando errores manuales.

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

- **Power Automate Desktop**: Herramienta principal de RPA
- **n8n**: Alternativa de automatización de workflows
- **Python 3.x**: Scripts auxiliares y procesamiento de datos
- **PowerShell**: Automatización de tareas del sistema

## 📦 Requisitos Previos

### Para Power Automate Desktop
- Windows 10 o superior
- Power Automate Desktop instalado
- Credenciales de acceso a los sistemas involucrados

### Para n8n
- Node.js 16.x o superior
- n8n instalado (`npm install n8n -g`)

### Para Scripts Python
```bash
pip install pandas numpy openpyxl python-dotenv
```

## ⚙️ Configuración Inicial

1. **Clonar el repositorio**
   ```bash
   git clone <url-repositorio>
   cd RDA_Costo_Amortizable
   ```

2. **Configurar credenciales**
   - Copiar `.env.example` a `.env` en `config/credenciales/`
   - Completar las credenciales necesarias

3. **Configurar parámetros**
   - Revisar y ajustar `config/parametros/configuracion_general.json`
   - Configurar endpoints en `config/conexiones/endpoints.json`

## 📖 Uso

### Ejecutar Flujo Principal (Power Automate)
1. Abrir Power Automate Desktop
2. Importar el flujo desde `workflows/power-automate/flujos/RDA_Principal.txt`
3. Configurar las variables de entrada
4. Ejecutar el flujo

### Ejecutar Workflow (n8n)
```bash
n8n import:workflow --input=workflows/n8n/workflows/RDA_Principal.json
n8n start
```

## 📝 Documentación

- **Manual de Usuario**: `documentacion/tecnica/manual_usuario/`
- **Manual Técnico**: `documentacion/tecnica/manual_tecnico/`
- **PDD**: `documentacion/funcional/pdd/`
- **Historias de Usuario**: `documentacion/funcional/historias_usuario/`

## 🧪 Testing

Los casos de prueba se encuentran en la carpeta `testing/`. Para ejecutar pruebas:

1. Revisar casos de prueba en `testing/casos_prueba/`
2. Utilizar datos de prueba en `testing/datos_prueba/`
3. Documentar resultados en los casos de prueba correspondientes

## 📊 Logs y Monitoreo

Los logs se almacenan automáticamente en:
- **Ejecuciones exitosas**: `logs/ejecuciones/`
- **Errores**: `logs/errores/`
- **Logs de procesamiento**: `data/output/logs/`

## 🤝 Contribuciones

Para contribuir al proyecto:

1. Crear una rama desde `develop`
2. Documentar cambios en historias de usuario
3. Actualizar documentación técnica si es necesario
4. Realizar pruebas exhaustivas
5. Crear Pull Request con descripción detallada

## 📋 Gestión del Proyecto

- **Actas de reunión**: `documentacion/gestion_proyecto/actas_reunion/`
- **Cronograma**: `documentacion/gestion_proyecto/cronograma/`
- **Control de cambios**: `documentacion/gestion_proyecto/seguimiento/`

## 👥 Equipo

- **Líder de Proyecto**: [Nombre]
- **Desarrolladores RPA**: [Nombres]
- **Analista Funcional**: [Nombre]

## 📄 Licencia

Este proyecto es propiedad de Banco Caja Social y es de uso interno exclusivo.

## 📞 Contacto

Para consultas o soporte, contactar a: [correo@empresa.com]

---

**Última actualización**: Noviembre 2025