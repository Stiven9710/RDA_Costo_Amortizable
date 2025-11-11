# Documento Funcional – Plataforma n8n para Proceso RDA Costo Amortizable

## 1. Propósito del Documento
Proporcionar una visión clara, simple y ejecutiva de cómo la plataforma n8n soporta la automatización del proceso de Costo Amortizable, orientada a perfiles funcionales (riesgos, negocio, gerencia) sin necesidad de conocimientos técnicos de desarrollo.

## 2. Resumen Ejecutivo
- Situación actual manual: 14 horas de trabajo operativo.
- Automatización con n8n: ~8 minutos totales (reducción >99%).
- n8n es una plataforma de orquestación de tareas (workflows) sin código complejo, adaptable y de bajo costo.
- Beneficios clave: rapidez, trazabilidad, flexibilidad, menores costos y escalabilidad futura.

## 3. Alcance Funcional
Incluye la recolección de datos (reestructurados y modificados), validaciones básicas, cálculo de indicadores (valor valuativo, pérdida/ganancia), generación de reportes y distribución controlada. No incluye: definición de políticas de negocio, aprobación de resultados, ni análisis de riesgo crediticio cualitativo.

## 4. Beneficios Clave
| Beneficio | Descripción | Impacto |
|-----------|-------------|---------|
| Reducción de tiempo | De 14h manual a ~8 min automático | Eficiencia operativa |
| Menor error humano | Validaciones sistemáticas y flujos repetibles | Calidad de datos |
| Escalabilidad | Se pueden agregar nuevos reportes sin rehacer todo | Evolución del proceso |
| Transparencia | Registro de cada ejecución y resultado | Auditoría y cumplimiento |
| Costo optimizado | Sin licenciamiento elevado (modelo abierto) | Ahorro anual |
| Flexibilidad tecnológica | Soporta varios esquemas de conexión | Adaptación futura |

## 5. Arquitectura General (Vista Funcional)
La plataforma n8n actúa como coordinador: recibe disparos programados, consulta las bases de datos, ejecuta reglas de cálculo y entrega reportes y registros de auditoría.

```
┌────────────────────────────────────────────┐
│ n8n (Orquestación del Proceso)            │
│  • Agenda (cron)                          │
│  • Conexión a BD                          │
│  • Reglas y cálculos                      │
│  • Generación de reportes                 │
│  • Envío y registro                       │
└────────────────────────────────────────────┘
       │                 │
       │ Datos           │ Resultados / Alertas
       ▼                 ▼
  Bases de Datos      Usuarios / Destinatarios
```

## 6. Opciones de Conectividad (Azure + On-Premise)
Para que n8n (en nube o híbrido) acceda a las bases de datos internas se requieren mecanismos seguros. Se presentan cuatro modelos evaluados:

### 6.1 VPN Site-to-Site (Recomendado Producción)
Conexión estable entre la red corporativa y Azure. Ideal para operación continua, escalamiento y cumplimiento de políticas bancarias.
```
Cloud Azure ── VPN IPsec ── Red Interna Banco ── BD SQL / Oracle
```
Características: permanente, cifrada, baja latencia, apta para auditorías. Costo mensual moderado.

### 6.2 SSH Bastion (Alternativa Económica)
Servidor intermedio en Azure que abre un túnel seguro hacia las bases de datos. Adecuado para pruebas o entornos con presupuesto restringido.
```
n8n (Cloud) ─ SSH ─ Bastion ─ Red Interna ─ BD
```
Características: rápido de implementar, muy bajo costo, menos robusto que VPN.

### 6.3 Modelo Híbrido (Worker Local)
Interfaz de n8n en la nube, ejecución de consultas cerca de las bases en sitio (worker). Minimiza latencia y protege credenciales.
```
UI / Orquestación (Cloud) ⇄ Cola segura ⇄ Worker On-Premise ⇄ BD
```
Características: alto rendimiento, más complejidad operativa, costo medio.

### 6.4 ExpressRoute / Conexión Dedicada (Escenario Empresarial Ampliado)
Enlace privado de alta capacidad. Solo justificable con grandes volúmenes o múltiples procesos críticos simultáneos.

### 6.5 Comparación Resumida
| Opción | Costo | Robustez | Latencia | Uso recomendado |
|--------|-------|----------|----------|-----------------|
| VPN Site-to-Site | Medio | Alta | Baja | Operación estable y regulada |
| SSH Bastion | Bajo | Media | Media | Pilotos / etapa inicial |
| Híbrido Worker | Medio | Alta | Muy baja | Optimizar rendimiento |
| ExpressRoute | Alto | Muy alta | Muy baja | Escala corporativa masiva |

## 7. Requisitos Funcionales Principales
1. Ejecutar el proceso automáticamente en fecha definida (fin de mes hábil).
2. Consultar datos de reestructurados y modificados de las fuentes acordadas.
3. Aplicar validaciones mínimas (completitud, rangos razonables de tasa y saldo positivo).
4. Calcular indicadores clave (pérdida/ganancia y valor valuativo) según reglas aprobadas.
5. Consolidar y generar tres tipos de reportes (detallados y ejecutivo).
6. Distribuir los reportes a los destinatarios autorizados.
7. Registrar cada ejecución con fecha, estado y métricas (para auditoría).
8. Notificar errores críticos a responsables funcionales.

## 8. Roles y Responsabilidades
| Rol | Responsabilidad |
|-----|-----------------|
| Propietario de Proceso | Define reglas de cálculo y valida resultados finales |
| Analista Funcional | Revisa reportes y levanta ajustes necesarios |
| Equipo de Riesgos | Interpreta indicadores para decisiones de gestión |
| Operador n8n | Supervisa ejecuciones y atiende alertas |
| Seguridad / Infraestructura | Garantiza conectividad segura y cumplimiento |
| Auditoría Interna | Verifica trazabilidad y controles |

## 9. Riesgos y Mitigaciones
| Riesgo | Impacto | Mitigación |
|--------|---------|-----------|
| Conectividad inestable | Retraso en entrega | Monitoreo y alertas tempranas |
| Datos incompletos | Cálculos erróneos | Validaciones previas y reporte de inconsistencias |
| Cambio en estructura de BD | Fallo de extracción | Revisión mensual de fuentes |
| Uso de versión no aprobada de reglas | Resultados no válidos | Control de versiones y aprobación formal |
| Pérdida de destinatarios | Falta de distribución | Lista maestra actualizada y doble verificación |
| Escalamiento futuro sin planificación | Degradación rendimiento | Plan anual de capacidad |

## 10. Costos Estimados (Rangos Referenciales)
| Concepto | Descripción | Rango mensual |
|----------|-------------|---------------|
| Plataforma n8n (Self-hosted) | Uso de infraestructura propia | 0 – 50 USD |
| Conectividad VPN | Gateway y transferencia | 140 – 200 USD |
| SSH Bastion | VM ligera + IP estática | 15 – 40 USD |
| Modelo Híbrido | Redis/servicios auxiliares | 70 – 110 USD |
| ExpressRoute (si aplica) | Enlace dedicado | > 500 USD |
| Ahorro vs PAD | Eliminación licencias PAD | ≈ 2,280 USD/año |

## 11. Indicadores (KPIs) Clave
| KPI | Objetivo | Frecuencia |
|-----|----------|------------|
| Tiempo de ejecución | ≤ 10 minutos | Cada ciclo |
| Porcentaje de ejecuciones exitosas | ≥ 95% | Mensual |
| Incidencias críticas | 0 por mes | Mensual |
| Reportes entregados puntuales | 100% | Mensual |
| Errores de datos detectados | < 2% del total | Mensual |
| Ahorro de horas operativas | > 50 horas/mes | Trimestral |

## 12. Flujo Resumido del Proceso Automatizado
1. Disparo programado (cron).  
2. Inicialización de parámetros (mes en proceso, rutas).  
3. Consulta paralela de datos base.  
4. Unión y depuración inicial.  
5. Validaciones básicas de calidad.  
6. Cálculo de indicadores clave.  
7. Verificación de errores (decisión).  
8. Si error: notificación y cierre controlado.  
9. Si correcto: consultas complementarias (tasas, variables).  
10. Consolidación final.  
11. Generación de reportes (detalle y ejecutivo).  
12. Inserción de resultados en repositorio interno.  
13. Envío de correos con adjuntos.  
14. Registro de log y métricas.  
15. Archivo histórico.  
16. Cierre y disponibilidad para auditoría.

## 13. Gobernanza y Control
| Elemento | Práctica |
|----------|---------|
| Versionado de reglas | Registro de fecha y aprobación responsable |
| Lista de distribución | Validación trimestral con negocio |
| Cambios mayores | Solicitud formal y prueba controlada |
| Auditoría | Exportación de registros bajo demanda |
| Seguridad de acceso | Roles diferenciados (lectura / operación) |
| Revisión periódica | Comité funcional mensual |

## 14. Plan de Implementación (Fases)
| Fase | Objetivo | Entregable |
|------|----------|------------|
| 1 – Diseño | Definir reglas, alcance y fuentes | Documento funcional validado |
| 2 – Preparación conectividad | Seleccionar opción (VPN/Bastion) | Canal seguro operativo |
| 3 – Construcción workflow | Parametrizar pasos y pruebas internas | Workflow base listo |
| 4 – Validación piloto | Comparar resultados con proceso manual | Informe de equivalencia |
| 5 – Aprobación formal | Endoso de negocio y riesgo | Acta de aprobación |
| 6 – Producción | Ejecución operativa recurrente | Reportes mensuales distribuidos |
| 7 – Optimización | Afinar tiempos y agregar métricas | Tablero de seguimiento |

## 15. Glosario Funcional
| Término | Definición |
|---------|-----------|
| Reestructurado | Obligación cuyo plazo o condiciones fueron renegociadas |
| Modificado | Crédito con ajuste parcial sin formalizar reestructuración completa |
| Valor Valuativo | Indicador del impacto económico neto del ajuste |
| Pérdida/Ganancia | Diferencia económica entre escenario original y nuevo |
| Workflow | Secuencia automatizada de tareas en n8n |
| Conectividad Segura | Mecanismo cifrado para acceder a sistemas internos |
| Bastion | Servidor intermediario para túneles seguros |
| Worker | Componente que ejecuta tareas cercanas a la fuente de datos |
| Log de Ejecución | Registro cronológico de acciones y resultados |

## 16. Selección Recomendada
Para operación estable y alineada con estándares bancarios se recomienda:  
1. Conectividad: VPN Site-to-Site (producción).  
2. Etapa inicial de pruebas: SSH Bastion para validar rapidez y costos.  
3. Mediano plazo: evaluar modelo híbrido si crecen volúmenes o se incorporan más procesos.  
4. ExpressRoute solo ante escalamiento masivo o requerimientos corporativos de integración avanzada.

## 17. Matriz de Decisión Simplificada
| Criterio | VPN | SSH Bastion | Híbrido | ExpressRoute |
|----------|-----|-------------|---------|--------------|
| Cumplimiento regulatorio | Alto | Medio | Alto | Muy alto |
| Costo | Medio | Bajo | Medio | Alto |
| Velocidad ejecución | Alta | Media | Muy alta | Muy alta |
| Facilidad inicial | Media | Alta | Media | Baja |
| Escalabilidad futura | Alta | Media | Alta | Muy alta |

## 18. Próximos Pasos
1. Validar este resumen con negocio y riesgos.  
2. Definir opción de conectividad definitiva.  
3. Formalizar reglas de cálculo documentadas (anexo técnico separado).  
4. Preparar tablero de KPIs para seguimiento mensual.  
5. Iniciar ciclo de pruebas comparativas vs proceso manual.

## 19. Consideraciones Finales
La adopción de n8n permite evolucionar el proceso sin dependencia fuerte de código personalizado. Una vez estabilizado el flujo base, el equipo funcional podrá proponer nuevos indicadores y reportes incrementalmente.

## 20. Resumen en una Frase
Automatizamos un proceso crítico reduciendo horas de trabajo a minutos, con transparencia, control y escalabilidad, utilizando una plataforma abierta y adaptable (n8n).

---
Versión funcional: 1.0  |  Fecha: 10/11/2025  |  Revisión sugerida: Trimestral

## Anexo técnico (separado)

- Este documento evita detalles técnicos (comandos, versiones, scripts, JSON/YAML).
- El contenido técnico completo (instalación, conectividad paso a paso, seguridad, mantenimiento y troubleshooting) se mantiene en un Manual Técnico independiente para equipos de tecnología.
- Para la ejecución del proyecto, basta con este resumen funcional más la elección de conectividad (sección 6) y los KPIs (sección 11).
- Si necesitas el anexo técnico, indícalo y lo publicamos en `documentacion/tecnica/manual_tecnico/`.

## Información General
**Plataforma:** n8n - Fair-code workflow automation  
**Versión Mínima:** 1.0 o superior  
**Tipo de Ejecución:** Serverless/Self-hosted  
**Tiempo de Ejecución:** ~8 minutos (47% más rápido que PAD)

---

## 1. Requisitos de Hardware

### Especificaciones Mínimas (Self-hosted)
| Componente | Requerimiento Mínimo |
|------------|----------------------|
| **Procesador** | 2 CPU cores (x86_64) |
| **RAM** | 4 GB |
| **Disco Duro** | 20 GB libres |
| **Tipo de Disco** | SSD recomendado |
| **Conexión Red** | 50 Mbps |

### Especificaciones Recomendadas (Producción)
| Componente | Requerimiento Recomendado |
|------------|---------------------------|
| **Procesador** | 4 CPU cores (x86_64) |
| **RAM** | 8 GB |
| **Disco Duro** | 50 GB libres |
| **Tipo de Disco** | SSD NVMe |
| **Conexión Red** | 100 Mbps (cableada) |

### Especificaciones para Docker (Contenedor)
```yaml
resources:
  limits:
    cpus: '2.0'
    memory: 4096M
  reservations:
    cpus: '1.0'
    memory: 2048M
```

---

## 2. Requisitos de Software

### 2.1. Plataforma Base

#### Opción A: Linux (Recomendado)
- **Ubuntu 20.04/22.04 LTS**
- **Debian 11/12**
- **CentOS Stream 9**
- **Red Hat Enterprise Linux 8/9**

#### Opción B: macOS
- **macOS Monterey (12.x)** o superior
- **macOS Ventura (13.x)**
- **macOS Sonoma (14.x)**

#### Opción C: Windows
- **Windows 10 Pro/Enterprise** (versión 21H2+)
- **Windows 11 Pro/Enterprise**
- **Windows Server 2019/2022**

---

### 2.2. Runtime y Dependencias

| Software | Versión | Propósito |
|----------|---------|-----------|
| **Node.js** | 18.x LTS o 20.x LTS | Motor de n8n |
| **npm** | 9.x o superior | Gestor de paquetes |
| **Python** | 3.9, 3.10, 3.11 | Ejecución de scripts |
| **PostgreSQL** (opcional) | 12+ o 13+ | Base de datos n8n (recomendado vs SQLite) |
| **Docker** (opcional) | 20.x o superior | Despliegue containerizado |
| **Git** | 2.x | Control de versiones workflows |

---

### 2.3. Instalación de n8n

#### Opción 1: npm (Global)
```bash
# Instalar Node.js 18 LTS
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar n8n globalmente
npm install n8n -g

# Verificar instalación
n8n --version
```

#### Opción 2: Docker (Recomendado para Producción)
```yaml
# docker-compose.yml
version: '3.8'

services:
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n-rda-costo-amortizable
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=${N8N_PASSWORD}
      - N8N_HOST=${N8N_HOST}
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - NODE_ENV=production
      - WEBHOOK_URL=https://${N8N_HOST}/
      - GENERIC_TIMEZONE=America/Bogota
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB}
      - DB_POSTGRESDB_USER=${POSTGRES_USER}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
      - EXECUTIONS_DATA_SAVE_ON_ERROR=all
      - EXECUTIONS_DATA_SAVE_ON_SUCCESS=all
      - EXECUTIONS_DATA_SAVE_MANUAL_EXECUTIONS=true
    volumes:
      - n8n_data:/home/node/.n8n
      - ./workflows:/home/node/.n8n/workflows
      - ./scripts:/home/node/scripts
    depends_on:
      - postgres
    networks:
      - n8n-network

  postgres:
    image: postgres:13-alpine
    container_name: n8n-postgres
    restart: unless-stopped
    environment:
      - POSTGRES_DB=${POSTGRES_DB}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - n8n-network

volumes:
  n8n_data:
  postgres_data:

networks:
  n8n-network:
    driver: bridge
```

**Iniciar con Docker:**
```bash
# Crear archivo .env
cat > .env << 'EOF'
N8N_PASSWORD=tu_password_seguro
N8N_HOST=n8n.bancocajasocial.local
POSTGRES_DB=n8n
POSTGRES_USER=n8n
POSTGRES_PASSWORD=tu_postgres_password
EOF

# Levantar servicios
docker-compose up -d

# Verificar logs
docker-compose logs -f n8n
```

#### Opción 3: npx (Temporal/Desarrollo)
```bash
npx n8n
```

---

### 2.4. Librerías Python Requeridas

```bash
# Crear entorno virtual
python3 -m venv venv
source venv/bin/activate  # Linux/macOS
# venv\Scripts\activate  # Windows

# Instalar dependencias
pip install --upgrade pip
pip install -r requirements.txt
```

**requirements.txt:**
```txt
# Data Processing
pandas==2.1.4
numpy==1.26.2
openpyxl==3.1.2

# Database
pyodbc==5.0.1
sqlalchemy==2.0.23

# Calculations
scipy==1.11.4

# Utilities
python-dotenv==1.0.0
jinja2==3.1.2
```

---

## 3. Conectividad y Accesos

### 3.1. Bases de Datos SQL Server

#### Credenciales n8n
```json
{
  "name": "SQL Server DWH_CC",
  "type": "microsoftSql",
  "data": {
    "server": "10.1.3.101\\SCC",
    "database": "DWH_CC",
    "user": "svc_n8n_rda",
    "password": "{{ $env.SQL_DWH_PASSWORD }}",
    "port": 1433,
    "encrypt": true,
    "trustServerCertificate": true,
    "connectTimeout": 60000,
    "requestTimeout": 60000
  }
}
```

```json
{
  "name": "SQL Server RIESGOS",
  "type": "microsoftSql",
  "data": {
    "server": "10.1.5.172\\RIESGOS",
    "database": "RIESGOS",
    "user": "svc_n8n_rda",
    "password": "{{ $env.SQL_RIESGOS_PASSWORD }}",
    "port": 1433,
    "encrypt": true,
    "trustServerCertificate": true
  }
}
```

### 3.2. Opciones de Conexión a SQL Server

#### Opción 1: Nodo Nativo Microsoft SQL (Recomendado) ✅
n8n incluye un **nodo nativo** para SQL Server que usa el driver `mssql` de Node.js internamente.

**Ventajas:**
- ✅ Configuración visual directa en n8n UI
- ✅ No requiere instalación de drivers adicionales
- ✅ Multiplataforma (Linux/macOS/Windows)
- ✅ Connection pooling automático
- ✅ Soporte completo para operaciones CRUD

**No requiere configuración adicional** - el driver viene incluido con n8n.

---

#### Opción 2: ODBC + Python Script (Alternativa)
Si necesitas características específicas de ODBC o ya tienes DSNs configurados.

**Instalación Driver ODBC (Linux):**
```bash
# Ubuntu/Debian
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev

# Verificar instalación
odbcinst -j

# Verificar drivers disponibles
odbcinst -q -d
```

**Configurar DSN (Opcional):**
```ini
# /etc/odbc.ini
[DWH_CC]
Driver = ODBC Driver 18 for SQL Server
Server = 10.1.3.101\SCC
Database = DWH_CC
TrustServerCertificate = yes

[RIESGOS]
Driver = ODBC Driver 18 for SQL Server
Server = 10.1.5.172\RIESGOS
Database = RIESGOS
TrustServerCertificate = yes
```

**Script Python con ODBC (`scripts/python/query_odbc.py`):**
```python
import pyodbc
import json
import sys
import os

def conectar_sql_server(server, database, user, password):
    """Conectar a SQL Server vía ODBC"""
    connection_string = (
        f"DRIVER={{ODBC Driver 18 for SQL Server}};"
        f"SERVER={server};"
        f"DATABASE={database};"
        f"UID={user};"
        f"PWD={password};"
        f"TrustServerCertificate=yes;"
        f"Connection Timeout=60;"
    )
    
    return pyodbc.connect(connection_string)

def ejecutar_query(server, database, user, password, query):
    """Ejecutar query y devolver JSON"""
    conn = conectar_sql_server(server, database, user, password)
    cursor = conn.cursor()
    
    try:
        cursor.execute(query)
        
        # Obtener columnas
        columns = [column[0] for column in cursor.description]
        
        # Obtener resultados
        results = []
        for row in cursor.fetchall():
            results.append(dict(zip(columns, row)))
        
        return {
            "success": True,
            "data": results,
            "rowCount": len(results)
        }
    except Exception as e:
        return {
            "success": False,
            "error": str(e)
        }
    finally:
        cursor.close()
        conn.close()

if __name__ == '__main__':
    # Leer parámetros desde stdin (JSON)
    input_data = json.loads(sys.stdin.read())
    
    resultado = ejecutar_query(
        server=input_data['server'],
        database=input_data['database'],
        user=input_data['user'],
        password=input_data['password'],
        query=input_data['query']
    )
    
    print(json.dumps(resultado, default=str))
```

**Nodo n8n para usar Python ODBC:**
```json
{
  "name": "Python ODBC Query - DWH",
  "type": "n8n-nodes-base.executeCommand",
  "parameters": {
    "command": "python3",
    "arguments": "{{ $env.SCRIPTS_PATH }}/query_odbc.py",
    "options": {
      "cwd": "{{ $env.WORKSPACE_PATH }}",
      "stdinData": "={{ JSON.stringify({ server: $env.SQL_DWH_SERVER, database: $env.SQL_DWH_DATABASE, user: $env.SQL_DWH_USER, password: $env.SQL_DWH_PASSWORD, query: $json.query }) }}"
    }
  }
}
```

**Cuándo usar ODBC:**
- Necesitas características específicas del driver ODBC
- Ya tienes infraestructura ODBC configurada corporativamente
- Requieres compatibilidad con herramientas legacy
- Necesitas usar DSNs del sistema

---

#### Comparación de Opciones

| Característica | Nodo Nativo SQL | ODBC + Python | REST API |
|----------------|----------------|---------------|----------|
| **Facilidad de configuración** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Performance** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Mantenimiento** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Multiplataforma** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Seguridad** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Dependencias** | Ninguna | ODBC Driver + Python | API intermedia |

**Recomendación:** Usar **Nodo Nativo Microsoft SQL** para este proyecto por su simplicidad y robustez.

---

### 3.3. Conexión desde n8n Cloud a Bases de Datos On-Premise

Si n8n está alojado en la **nube** (AWS, Azure, GCP, n8n Cloud) y necesitas conectarte a bases de datos **on-premise** (Oracle, SQL Server), requieres establecer conectividad segura.

#### Opciones de Conectividad Cloud → On-Premise

#### Opción 1: VPN Site-to-Site con Azure (Recomendado para Producción) ⭐

**Descripción:** Túnel VPN IPsec entre tu red corporativa Banco Caja Social y Azure Virtual Network.

**Arquitectura Azure:**
```
┌──────────────────────────────────────────────────────────────┐
│ Microsoft Azure Cloud                                        │
│  ┌────────────────────────────────────────┐                  │
│  │ Virtual Network (VNet)                 │                  │
│  │  Rango: 10.100.0.0/16                  │                  │
│  │                                        │                  │
│  │  ┌──────────────────┐  ┌──────────┐   │                  │
│  │  │ VM n8n           │  │ VPN      │   │                  │
│  │  │ (Ubuntu 22.04)   │─▶│ Gateway  │◀──┼─── IPsec Tunnel ─┼───┐
│  │  │ 10.100.1.10      │  │ VpnGw1   │   │                  │   │
│  │  └──────────────────┘  └──────────┘   │                  │   │
│  │                                        │                  │   │
│  │ Network Security Group:                │                  │   │
│  │  - Allow HTTPS (443) from Internet     │                  │   │
│  │  - Allow SSH (22) from Admin IPs       │                  │   │
│  └────────────────────────────────────────┘                  │   │
└──────────────────────────────────────────────────────────────┘   │
                                                                    │
                                                                    │ IPsec
┌──────────────────────────────────────────────────────────────┐   │
│ Red Corporativa Banco Caja Social (On-Premise)              │   │
│  ┌────────────────────────────────────────┐                  │   │
│  │  ┌──────────┐         ┌──────────┐    │                  │   │
│  │  │ Firewall │◀────────│ VPN      │◀───┼──────────────────┘
│  │  │ Cisco    │         │ Gateway  │    │
│  │  │ ASA/FTD  │         │(200.x.x.x)│    │
│  │  └────┬─────┘         └──────────┘    │
│  │       │  Rango: 10.1.0.0/16            │
│  │       │                                │
│  │       │  ┌───────────────────┐  ┌───────────────────┐
│  │       └─▶│ SQL Server DWH    │  │ Oracle RIESGOS    │
│  │          │ 10.1.3.101\SCC    │  │ 10.1.5.200:1521   │
│  │          │ Puerto: 1433      │  │ SID: ORCL         │
│  │          └───────────────────┘  └───────────────────┘
│  └────────────────────────────────────────┘
└──────────────────────────────────────────────────────────────┘
```

**Componentes Azure Necesarios:**

**1. Virtual Network (VNet)**
```bash
# Crear Resource Group
az group create \
  --name rg-n8n-bancocajasocial \
  --location eastus

# Crear Virtual Network
az network vnet create \
  --name vnet-n8n-prod \
  --resource-group rg-n8n-bancocajasocial \
  --address-prefix 10.100.0.0/16 \
  --subnet-name subnet-n8n-app \
  --subnet-prefix 10.100.1.0/24

# Crear Gateway Subnet (requerido para VPN Gateway)
az network vnet subnet create \
  --name GatewaySubnet \
  --resource-group rg-n8n-bancocajasocial \
  --vnet-name vnet-n8n-prod \
  --address-prefix 10.100.255.0/27
```

**2. Local Network Gateway (Representa On-Premise)**
```bash
# Crear Local Network Gateway (IP pública del firewall corporativo)
az network local-gateway create \
  --name lng-bancocajasocial-onpremise \
  --resource-group rg-n8n-bancocajasocial \
  --gateway-ip-address 200.10.20.30 \
  --local-address-prefixes 10.1.0.0/16
```

**3. Public IP para VPN Gateway**
```bash
# Crear IP Pública estática
az network public-ip create \
  --name pip-vpn-gateway \
  --resource-group rg-n8n-bancocajasocial \
  --allocation-method Static \
  --sku Standard
```

**4. Virtual Network Gateway (VPN Gateway)**
```bash
# Crear VPN Gateway (tarda ~45 minutos)
az network vnet-gateway create \
  --name vpng-n8n-bancocajasocial \
  --resource-group rg-n8n-bancocajasocial \
  --vnet vnet-n8n-prod \
  --public-ip-addresses pip-vpn-gateway \
  --gateway-type Vpn \
  --vpn-type RouteBased \
  --sku VpnGw1 \
  --vpn-gateway-generation Generation1 \
  --no-wait

# Monitorear progreso
az network vnet-gateway show \
  --name vpng-n8n-bancocajasocial \
  --resource-group rg-n8n-bancocajasocial \
  --query "provisioningState"
```

**5. VPN Connection**
```bash
# Crear conexión VPN Site-to-Site
az network vpn-connection create \
  --name conn-azure-to-bancocajasocial \
  --resource-group rg-n8n-bancocajasocial \
  --vnet-gateway1 vpng-n8n-bancocajasocial \
  --local-gateway2 lng-bancocajasocial-onpremise \
  --shared-key "TuClavePreCompartidaSegura2024!" \
  --connection-protocol IKEv2

# Verificar estado de conexión
az network vpn-connection show \
  --name conn-azure-to-bancocajasocial \
  --resource-group rg-n8n-bancocajasocial \
  --query "connectionStatus"
```

**6. Route Table (Opcional pero Recomendado)**
```bash
# Crear tabla de rutas para forzar tráfico por VPN
az network route-table create \
  --name rt-n8n-to-onpremise \
  --resource-group rg-n8n-bancocajasocial

# Agregar ruta hacia red on-premise
az network route-table route create \
  --name route-to-sqlserver \
  --resource-group rg-n8n-bancocajasocial \
  --route-table-name rt-n8n-to-onpremise \
  --address-prefix 10.1.0.0/16 \
  --next-hop-type VirtualNetworkGateway

# Asociar tabla de rutas al subnet de n8n
az network vnet subnet update \
  --name subnet-n8n-app \
  --resource-group rg-n8n-bancocajasocial \
  --vnet-name vnet-n8n-prod \
  --route-table rt-n8n-to-onpremise
```

**Configuración On-Premise (Firewall Cisco ASA/Fortinet):**

**Para Cisco ASA:**
```cisco
! Configurar IKEv2 Policy
crypto ikev2 policy 10
 encryption aes-256
 integrity sha256
 group 14
 prf sha256
 lifetime seconds 28800

! Configurar IKEv2 Proposal
crypto ikev2 proposal azure-proposal
 encryption aes-256
 integrity sha256
 group 14

! Configurar Peer Azure
crypto ikev2 remote-access-trustpoint azure-vpn
tunnel-group <AZURE_PUBLIC_IP> type ipsec-l2l
tunnel-group <AZURE_PUBLIC_IP> ipsec-attributes
 ikev2 remote-authentication pre-shared-key TuClavePreCompartidaSegura2024!
 ikev2 local-authentication pre-shared-key TuClavePreCompartidaSegura2024!

! Definir tráfico interesante
access-list vpn-azure-traffic extended permit ip 10.1.0.0 255.255.0.0 10.100.0.0 255.255.0.0

! Crear Crypto Map
crypto map azure-vpn-map 10 match address vpn-azure-traffic
crypto map azure-vpn-map 10 set peer <AZURE_PUBLIC_IP>
crypto map azure-vpn-map 10 set ikev2 ipsec-proposal azure-proposal
crypto map azure-vpn-map interface outside

! Habilitar NAT exemption
nat (inside,outside) source static obj-10.1.0.0 obj-10.1.0.0 destination static obj-10.100.0.0 obj-10.100.0.0 no-proxy-arp route-lookup
```

**Para Fortinet FortiGate:**
```fortinet
config vpn ipsec phase1-interface
    edit "Azure-VPN"
        set interface "wan1"
        set ike-version 2
        set keylife 28800
        set peertype any
        set net-device disable
        set proposal aes256-sha256
        set remote-gw <AZURE_PUBLIC_IP>
        set psksecret TuClavePreCompartidaSegura2024!
    next
end

config vpn ipsec phase2-interface
    edit "Azure-VPN-P2"
        set phase1name "Azure-VPN"
        set proposal aes256-sha256
        set keylifeseconds 27000
        set src-subnet 10.1.0.0 255.255.0.0
        set dst-subnet 10.100.0.0 255.255.0.0
    next
end

config firewall policy
    edit 0
        set name "OnPremise-to-Azure"
        set srcintf "internal"
        set dstintf "Azure-VPN"
        set srcaddr "subnet-10.1.0.0"
        set dstaddr "subnet-10.100.0.0"
        set action accept
        set schedule "always"
        set service "ALL"
    next
end
```

**Ventajas VPN Site-to-Site Azure:**
- ✅ Integración nativa con servicios Azure (VM, SQL Database, etc.)
- ✅ Conexión permanente y estable (SLA 99.95%)
- ✅ Encriptación IPsec/IKEv2 de grado empresarial
- ✅ Acceso transparente a múltiples recursos on-premise
- ✅ Baja latencia (< 30ms típicamente en Colombia)
- ✅ Compatible con políticas de seguridad bancarias
- ✅ Monitoreo integrado con Azure Monitor
- ✅ BGP support (con SKU VpnGw2+)

**Desventajas:**
- ❌ Requiere coordinación con equipo de redes corporativo
- ❌ Configuración inicial 2-3 días (incluyendo aprobaciones)
- ❌ VPN Gateway tarda ~45 minutos en aprovisionarse
- ❌ Costo mensual predecible pero no trivial

**Costos Azure Detallados (Colombia - East US):**

| Componente | SKU | Costo/Mes (USD) | Notas |
|------------|-----|-----------------|-------|
| **VPN Gateway** | VpnGw1 | $142.00 | Incluye 1 conexión S2S |
| **Public IP** | Standard | $3.65 | IP estática |
| **Transferencia Datos** | Salida | $0.087/GB | Primeros 10TB |
| **Virtual Network** | N/A | $0.00 | Sin costo |
| **VM n8n (opcional)** | B2s (2 vCPU, 4GB) | $30.37 | Si self-hosted |
| **Managed Disks** | Standard SSD 128GB | $9.60 | Para VM |
| **Backup** | Azure Backup | ~$5.00 | Opcional |
| **Total Mínimo** | | **~$145/mes** | Solo VPN |
| **Total con VM** | | **~$190/mes** | VPN + n8n self-hosted |

**Alternativa n8n Cloud + VPN:**
- n8n Cloud Pro: $50/mes
- VPN Gateway: $142/mes
- **Total: $192/mes** (sin gestionar VM, más simple)

**Comparación con PAD:**
- PAD Premium + Unattended: $190/mes
- Azure VPN + n8n Cloud: $192/mes (+$2/mes, pero 47% más rápido)
- Azure VPN + n8n self-hosted: $190/mes (mismo costo, 47% más rápido)

---

#### Opción 2: SSH Tunnel / Bastion Host Azure (Alternativa Económica) 💰

**Descripción:** VM en Azure que actúa como jump server para establecer túnel SSH hacia bases de datos on-premise.

**Arquitectura Azure:**
```
┌─────────────────────────────────────────────────────────────┐
│ Microsoft Azure Cloud                                       │
│  ┌──────────────────────────────────────────┐               │
│  │ Virtual Network (10.100.0.0/16)          │               │
│  │                                           │               │
│  │  ┌─────────────────┐    SSH Tunnel       │               │
│  │  │ VM n8n Cloud    │──────────────────┐  │               │
│  │  │ (n8n.io SaaS)   │  localhost:1433  │  │               │
│  │  │ or Self-hosted  │  localhost:1521  │  │               │
│  │  └─────────────────┘                  │  │               │
│  │                                        ▼  │               │
│  │                           ┌──────────────────┐            │
│  │                           │ VM Bastion/Jump  │            │
│  │                           │ Ubuntu 22.04 LTS │            │
│  │                           │ B1s (1vCPU, 1GB) │            │
│  │                           │ IP: 10.100.2.10  │            │
│  │                           └────────┬─────────┘            │
│  │                                    │                      │
│  │ NSG Rules:                         │ Public IP            │
│  │  - SSH (22) from n8n subnet only  │ (52.x.x.x)          │
│  └────────────────────────────────────┼──────────────────────┘
                                        │
                                        │ SSH over Internet
                                        │ (Puerto 22)
┌───────────────────────────────────────┼─────────────────────┐
│ Red Corporativa Banco Caja Social    ▼                     │
│  ┌────────────────────────────────────────┐                │
│  │ Firewall                               │                │
│  │  - Allow SSH from 52.x.x.x (Azure IP) │                │
│  │                                        │                │
│  │              ┌───────────────┐  ┌───────────────┐       │
│  │              │ SQL Server    │  │ Oracle DB     │       │
│  │              │ 10.1.3.101    │  │ 10.1.5.200    │       │
│  │              │ Puerto: 1433  │  │ Puerto: 1521  │       │
│  │              └───────────────┘  └───────────────┘       │
│  └────────────────────────────────────────┘                │
└─────────────────────────────────────────────────────────────┘
```

**Paso 1: Crear VM Bastion en Azure**

```bash
# Crear Resource Group (si no existe)
az group create \
  --name rg-n8n-bancocajasocial \
  --location eastus

# Crear subnet para Bastion
az network vnet subnet create \
  --name subnet-bastion \
  --resource-group rg-n8n-bancocajasocial \
  --vnet-name vnet-n8n-prod \
  --address-prefix 10.100.2.0/24

# Crear Network Security Group
az network nsg create \
  --name nsg-bastion \
  --resource-group rg-n8n-bancocajasocial

# Permitir SSH solo desde subnet de n8n
az network nsg rule create \
  --name AllowSSHFromN8n \
  --resource-group rg-n8n-bancocajasocial \
  --nsg-name nsg-bastion \
  --priority 100 \
  --source-address-prefixes 10.100.1.0/24 \
  --destination-port-ranges 22 \
  --protocol Tcp \
  --access Allow

# Permitir SSH desde Internet (temporal para setup)
az network nsg rule create \
  --name AllowSSHFromInternet \
  --resource-group rg-n8n-bancocajasocial \
  --nsg-name nsg-bastion \
  --priority 200 \
  --source-address-prefixes Internet \
  --destination-port-ranges 22 \
  --protocol Tcp \
  --access Allow

# Crear VM Bastion (Ubuntu 22.04 - B1s económico)
az vm create \
  --name vm-bastion-jump \
  --resource-group rg-n8n-bancocajasocial \
  --vnet-name vnet-n8n-prod \
  --subnet subnet-bastion \
  --nsg nsg-bastion \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys \
  --public-ip-address pip-bastion \
  --public-ip-sku Standard

# Obtener IP pública del Bastion
az vm show \
  --name vm-bastion-jump \
  --resource-group rg-n8n-bancocajasocial \
  --show-details \
  --query "publicIps" \
  --output tsv
# Ejemplo salida: 52.170.123.45
```

**Paso 2: Configurar SSH en VM Bastion**

```bash
# Conectarse al Bastion
ssh azureuser@52.170.123.45

# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar autossh para túneles persistentes
sudo apt install -y autossh

# Configurar SSH Server
sudo tee -a /etc/ssh/sshd_config > /dev/null <<'EOF'
# Configuración para n8n tunnel
AllowTcpForwarding yes
GatewayPorts yes
PermitOpen 10.1.3.101:1433 10.1.5.200:1521
ClientAliveInterval 60
ClientAliveCountMax 3
EOF

# Reiniciar SSH
sudo systemctl restart sshd

# Crear usuario dedicado para n8n
sudo useradd -m -s /bin/bash n8n_tunnel
sudo mkdir /home/n8n_tunnel/.ssh
sudo chmod 700 /home/n8n_tunnel/.ssh

# Generar par de llaves para n8n (copiar la privada después)
sudo -u n8n_tunnel ssh-keygen -t ed25519 -C "n8n-azure-tunnel" -f /home/n8n_tunnel/.ssh/id_ed25519 -N ""

# Agregar llave pública a authorized_keys
sudo -u n8n_tunnel cp /home/n8n_tunnel/.ssh/id_ed25519.pub /home/n8n_tunnel/.ssh/authorized_keys
sudo chmod 600 /home/n8n_tunnel/.ssh/authorized_keys

# Mostrar llave privada (copiar para n8n)
sudo cat /home/n8n_tunnel/.ssh/id_ed25519
```

**Paso 3: Configurar Firewall On-Premise**

```bash
# En firewall corporativo Cisco ASA
access-list outside_access_in extended permit tcp host 52.170.123.45 any eq ssh

# O en Fortinet
config firewall address
    edit "Azure-Bastion-IP"
        set subnet 52.170.123.45 255.255.255.255
    next
end

config firewall policy
    edit 0
        set name "Allow-Azure-Bastion-SSH"
        set srcintf "wan1"
        set dstintf "internal"
        set srcaddr "Azure-Bastion-IP"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "SSH"
    next
end
```

**Paso 4: Configurar n8n Cloud con SSH Tunnel**

Si usas **n8n Cloud (SaaS)**:
```bash
# Contactar soporte de n8n.io para habilitar SSH tunnel
# O usar n8n self-hosted en Azure VM

# En VM n8n self-hosted Azure:
ssh azureuser@<n8n-vm-ip>

# Copiar llave privada del bastion
nano ~/.ssh/azure_bastion_key
# Pegar contenido de /home/n8n_tunnel/.ssh/id_ed25519
chmod 600 ~/.ssh/azure_bastion_key

# Crear túnel SSH manual (prueba)
ssh -i ~/.ssh/azure_bastion_key \
    -L 1433:10.1.3.101:1433 \
    -L 1521:10.1.5.200:1521 \
    -N -f \
    n8n_tunnel@10.100.2.10

# Verificar puertos
ss -tuln | grep -E '1433|1521'
```

**Paso 5: Túnel SSH Persistente con Systemd**

```bash
# Crear script de conexión
sudo tee /usr/local/bin/azure-tunnel.sh > /dev/null <<'EOF'
#!/bin/bash
autossh -M 0 \
    -o "ServerAliveInterval 30" \
    -o "ServerAliveCountMax 3" \
    -o "StrictHostKeyChecking=no" \
    -i /home/azureuser/.ssh/azure_bastion_key \
    -L 1433:10.1.3.101:1433 \
    -L 1521:10.1.5.200:1521 \
    -N \
    n8n_tunnel@10.100.2.10
EOF

sudo chmod +x /usr/local/bin/azure-tunnel.sh

# Crear servicio systemd
sudo tee /etc/systemd/system/azure-tunnel.service > /dev/null <<'EOF'
[Unit]
Description=Azure SSH Tunnel to On-Premise Databases
After=network.target

[Service]
Type=simple
User=azureuser
ExecStart=/usr/local/bin/azure-tunnel.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Habilitar e iniciar servicio
sudo systemctl daemon-reload
sudo systemctl enable azure-tunnel.service
sudo systemctl start azure-tunnel.service

# Verificar estado
sudo systemctl status azure-tunnel.service
```

**Paso 6: Configurar Credenciales n8n**

```json
{
  "name": "SQL Server via Azure SSH Tunnel",
  "type": "microsoftSql",
  "data": {
    "server": "localhost",
    "database": "DWH_CC",
    "user": "svc_n8n_rda",
    "password": "{{ $env.SQL_DWH_PASSWORD }}",
    "port": 1433,
    "encrypt": false,
    "trustServerCertificate": true
  }
}
```

**Ventajas SSH Tunnel Azure:**
- ✅ **Muy económico**: B1s solo $10.22/mes (vs VPN Gateway $142/mes)
- ✅ **Fácil implementación**: 1-2 horas vs 2-3 días VPN
- ✅ **Encriptación SSH nativa**: Sin configurar IPsec
- ✅ **Firewall-friendly**: Solo requiere puerto 22 saliente
- ✅ **No requiere aprobaciones complejas**: Más ágil para pruebas
- ✅ **Integración Azure nativa**: VM, NSG, monitoring incluido

**Desventajas:**
- ❌ **Punto único de falla**: Si VM bastion cae, no hay conectividad
- ❌ **Mayor latencia**: SSH + port forwarding añade ~20-30ms
- ❌ **No tan robusto**: Requiere monitoreo del túnel
- ❌ **Límite de ancho de banda**: B1s tiene límite de red

**Costos Azure Detallados (SSH Tunnel):**

| Componente | SKU | Costo/Mes (USD) | Notas |
|------------|-----|-----------------|-------|
| **VM Bastion** | B1s (1 vCPU, 1GB) | $10.22 | 730 horas/mes |
| **Managed Disk** | Standard HDD 32GB | $1.54 | Para VM |
| **Public IP** | Standard Static | $3.65 | IP estática |
| **Transferencia Datos** | Salida | $0.087/GB | Primeros 10TB |
| **NSG/VNet** | N/A | $0.00 | Sin costo |
| **Total SSH Tunnel** | | **~$15.41/mes** | Más económico |

**Si usas n8n Cloud:**
- n8n Cloud Starter: $20/mes
- VM Bastion Azure: $15.41/mes
- **Total: $35.41/mes** (vs $192/mes con VPN)

**Comparación Costos:**
- PAD: $190/mes
- Azure VPN + n8n Cloud: $192/mes
- **Azure SSH + n8n Cloud: $35.41/mes** ✅ **81% más barato que PAD**

---

#### Opción 3: Agente/Proxy On-Premise (n8n Hybrid) 🔄

**Descripción:** Desplegar un **agente n8n ligero** on-premise que ejecuta queries y envía resultados a n8n Cloud.

**Arquitectura:**
```
┌──────────────────────────────────────────┐
│ n8n Cloud                                │
│  ┌────────────────────────────────┐      │
│  │ n8n Main Instance              │      │
│  │  • UI                          │      │
│  │  • Workflow Orchestration      │      │
│  │  • Scheduling                  │      │
│  └────────────┬───────────────────┘      │
└───────────────┼──────────────────────────┘
                │ HTTPS/WebSocket
                │ (outbound only)
┌───────────────▼──────────────────────────┐
│ On-Premise                               │
│  ┌────────────────────────────────┐      │
│  │ n8n Worker/Agent               │      │
│  │  • Ejecuta queries SQL         │      │
│  │  • Polling n8n Cloud           │      │
│  └────────┬───────────────────────┘      │
│           │                              │
│           │  ┌───────────────┐           │
│           └─▶│ SQL Server    │           │
│              │ 10.1.3.101    │           │
│              └───────────────┘           │
└──────────────────────────────────────────┘
```

**Implementación con n8n Worker:**

**1. Desplegar n8n Worker on-premise:**
```yaml
# docker-compose.yml (on-premise)
version: '3.8'

services:
  n8n-worker:
    image: n8nio/n8n:latest
    container_name: n8n-worker-onpremise
    restart: unless-stopped
    environment:
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - EXECUTIONS_MODE=queue
      - QUEUE_BULL_REDIS_HOST=redis
      - QUEUE_BULL_REDIS_PORT=6379
      - N8N_HOST=${N8N_CLOUD_HOST}
      - N8N_PROTOCOL=https
      - WEBHOOK_URL=https://${N8N_CLOUD_HOST}/
    volumes:
      - worker_data:/home/node/.n8n
    networks:
      - internal-network

  redis:
    image: redis:7-alpine
    container_name: redis-queue
    restart: unless-stopped
    networks:
      - internal-network

networks:
  internal-network:
    driver: bridge
```

**Ventajas n8n Hybrid:**
- ✅ Queries ejecutados localmente (baja latencia a BD)
- ✅ Solo tráfico saliente (firewall friendly)
- ✅ Escalable (múltiples workers)
- ✅ n8n Cloud maneja UI y orquestación

**Desventajas:**
- ❌ Requiere mantener worker on-premise
- ❌ Sincronización via Redis/Queue
- ❌ Mayor complejidad arquitectónica

**Costos Estimados:**
- Worker on-premise (servidor pequeño): ~$0 (usa infraestructura existente)
- n8n Cloud: $20-50/mes según plan

---

#### Opción 4: Cloud SQL Proxy (Para Google Cloud SQL) ☁️

Si migraras las BD a **Google Cloud SQL**, puedes usar Cloud SQL Proxy.

```bash
# Descargar Cloud SQL Proxy
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
chmod +x cloud_sql_proxy

# Ejecutar proxy
./cloud_sql_proxy -instances=INSTANCE_CONNECTION_NAME=tcp:1433
```

---

#### Opción 5: AWS Direct Connect / Azure ExpressRoute (Empresarial) 🏢

**Descripción:** Conexión dedicada de fibra óptica entre datacenter corporativo y cloud provider.

**Características:**
- ✅ **Ancho de banda dedicado**: 50 Mbps - 100 Gbps
- ✅ **Latencia ultra baja**: < 10ms
- ✅ **Alta disponibilidad**: SLA 99.9%
- ✅ **Bypass de Internet público**

**Costos:**
- AWS Direct Connect: $0.30/hora (50 Mbps) + costos de proveedor de conectividad
- Azure ExpressRoute: ~$55/mes (50 Mbps) + costos de proveedor
- Instalación: $1,000 - $10,000 (una vez)

**Cuándo usar:**
- Tráfico intensivo de datos (>1TB/mes)
- Requisitos de baja latencia críticos
- Múltiples aplicaciones cloud ↔ on-premise

---

#### Comparación de Opciones

| Opción | Costo/Mes | Latencia | Complejidad | Seguridad | Escalabilidad |
|--------|-----------|----------|-------------|-----------|---------------|
| **VPN Site-to-Site** | $27-$36 | ⭐⭐⭐⭐ (< 50ms) | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **SSH Tunnel** | $8-$10 | ⭐⭐⭐ (50-100ms) | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **n8n Hybrid** | $20-$50 | ⭐⭐⭐⭐⭐ (< 10ms) | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Direct Connect** | $1,000+ | ⭐⭐⭐⭐⭐ (< 10ms) | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

---

#### Configuración de Conectividad Oracle (Adicional)

Si necesitas conectarte a **Oracle Database** on-premise:

**Nodo n8n para Oracle:**
```json
{
  "name": "Oracle DB On-Premise",
  "type": "n8n-nodes-base.oracle",
  "data": {
    "host": "10.1.5.200",
    "port": 1521,
    "database": "ORCL",
    "username": "svc_n8n_rda",
    "password": "{{ $env.ORACLE_PASSWORD }}",
    "serviceName": "ORCL.bancocajasocial.local",
    "connectTimeout": 60000
  }
}
```

**Instalar Oracle Client (si usas n8n self-hosted):**
```bash
# Descargar Oracle Instant Client
wget https://download.oracle.com/otn_software/linux/instantclient/2114000/instantclient-basic-linux.x64-21.14.0.0.0dbru.zip

# Descomprimir
unzip instantclient-basic-linux.x64-21.14.0.0.0dbru.zip -d /opt/oracle

# Configurar variables de entorno
export LD_LIBRARY_PATH=/opt/oracle/instantclient_21_14:$LD_LIBRARY_PATH
export PATH=/opt/oracle/instantclient_21_14:$PATH

# Instalar driver Node.js
npm install oracledb
```

**Configurar tnsnames.ora:**
```ini
# /opt/oracle/instantclient_21_14/network/admin/tnsnames.ora
ORCL =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 10.1.5.200)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = ORCL.bancocajasocial.local)
    )
  )
```

---

#### Recomendación para tu Proyecto

Para **RDA Costo Amortizable** con n8n Cloud:

**Mejor opción:** 🏆 **VPN Site-to-Site (Opción 1)**

**Razones:**
1. **Seguridad:** Cumple con políticas bancarias
2. **Estabilidad:** Conexión permanente y confiable
3. **Latencia:** < 50ms para queries SQL
4. **Escalabilidad:** Permite agregar más flujos/aplicaciones futuras
5. **Costo razonable:** ~$36/mes vs $0 licencias n8n

**Alternativa económica:** **SSH Tunnel (Opción 2)** si presupuesto es limitado (~$10/mes)

**Configuración firewall on-premise necesaria:**
```bash
# Permitir VPN Gateway cloud → SQL Server
iptables -A INPUT -s 10.100.0.0/16 -p tcp --dport 1433 -j ACCEPT

# Permitir VPN Gateway cloud → Oracle
iptables -A INPUT -s 10.100.0.0/16 -p tcp --dport 1521 -j ACCEPT
```

### 3.4. Correo Electrónico (Gmail/Office 365)

#### Gmail Credential
```json
{
  "name": "Gmail - RDA Bot",
  "type": "gmailOAuth2",
  "data": {
    "clientId": "{{ $env.GMAIL_CLIENT_ID }}",
    "clientSecret": "{{ $env.GMAIL_CLIENT_SECRET }}",
    "oauthTokenData": {
      "access_token": "...",
      "refresh_token": "...",
      "scope": "https://mail.google.com/",
      "token_type": "Bearer",
      "expiry_date": 1234567890
    }
  }
}
```

---

## 4. Licenciamiento

### Modelo de Licenciamiento n8n

| Modalidad | Costo | Características |
|-----------|-------|-----------------|
| **Self-hosted (Community)** | $0 | Fair-code, ilimitado, sin soporte oficial |
| **n8n Cloud (Starter)** | $20/mes | 2,500 ejecuciones/mes, soporte comunitario |
| **n8n Cloud (Pro)** | $50/mes | 10,000 ejecuciones/mes, soporte prioritario |
| **Enterprise** | Custom | Ilimitado, SLA, soporte dedicado |

**Recomendación para este proyecto:**  
✅ **Self-hosted (Community)** - $0/mes (infraestructura propia)

### Comparación de Costos vs PAD
```
Power Automate Desktop: $190/mes
n8n Self-hosted:         $0/mes (solo infraestructura ~$20-50/mes)

Ahorro anual: ~$2,280 USD
```

---

## 5. Configuración de Entorno

### 5.1. Variables de Entorno

**Archivo `.env`:**
```bash
# n8n Configuration
N8N_HOST=n8n.bancocajasocial.local
N8N_PORT=5678
N8N_PROTOCOL=https
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=tu_password_seguro

# Database
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=n8n
DB_POSTGRESDB_PASSWORD=tu_postgres_password

# SQL Server Credentials
SQL_DWH_SERVER=10.1.3.101\\SCC
SQL_DWH_DATABASE=DWH_CC
SQL_DWH_USER=svc_n8n_rda
SQL_DWH_PASSWORD=tu_dwh_password

SQL_RIESGOS_SERVER=10.1.5.172\\RIESGOS
SQL_RIESGOS_DATABASE=RIESGOS
SQL_RIESGOS_USER=svc_n8n_rda
SQL_RIESGOS_PASSWORD=tu_riesgos_password

# Email Configuration
GMAIL_CLIENT_ID=tu_client_id.apps.googleusercontent.com
GMAIL_CLIENT_SECRET=tu_client_secret
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=bot-rda@bancocajasocial.com
SMTP_PASSWORD=tu_app_password

# Paths
WORKSPACE_PATH=/home/node/workspace/RDA_Costo_Amortizable
SCRIPTS_PATH=/home/node/scripts
OUTPUT_PATH=/home/node/workspace/RDA_Costo_Amortizable/data/output

# Timezone
GENERIC_TIMEZONE=America/Bogota
TZ=America/Bogota

# Execution Settings
EXECUTIONS_TIMEOUT=1800
EXECUTIONS_TIMEOUT_MAX=3600
EXECUTIONS_DATA_SAVE_ON_ERROR=all
EXECUTIONS_DATA_SAVE_ON_SUCCESS=all
EXECUTIONS_DATA_SAVE_MANUAL_EXECUTIONS=true
EXECUTIONS_DATA_PRUNE=true
EXECUTIONS_DATA_MAX_AGE=336  # 14 días
```

---

## 6. Nodos n8n y Actividades

### 6.1. Trigger - Programación
```
┌─────────────────────────────────────────────────────────────┐
│ NODO 1: Cron Trigger (Inicio Automático)                   │
└─────────────────────────────────────────────────────────────┘
```

**Configuración del Nodo:**
```json
{
  "name": "Cron Trigger - Fin de Mes",
  "type": "n8n-nodes-base.cron",
  "parameters": {
    "rule": {
      "interval": [{
        "field": "cronExpression",
        "expression": "0 8 28-31 * *"
      }]
    }
  },
  "description": "Ejecutar el día 28-31 de cada mes a las 8:00 AM (solo si es último día hábil)"
}
```

**Equivalente PAD:** Start → Scheduled Trigger

---

### 6.2. Inicialización - Variables
```
┌─────────────────────────────────────────────────────────────┐
│ NODO 2: Set Variables (Configuración Inicial)              │
└─────────────────────────────────────────────────────────────┘
```

**Configuración del Nodo:**
```json
{
  "name": "Set Variables Iniciales",
  "type": "n8n-nodes-base.set",
  "parameters": {
    "values": {
      "string": [
        {
          "name": "fecha_proceso",
          "value": "={{ $now.minus({ months: 1 }).toFormat('yyyyMM') }}"
        },
        {
          "name": "ruta_output",
          "value": "={{ $env.OUTPUT_PATH }}/reportes"
        },
        {
          "name": "ejecutor",
          "value": "n8n-bot"
        }
      ],
      "number": [
        {
          "name": "timeout_sql",
          "value": 60000
        }
      ]
    }
  }
}
```

**Equivalente PAD:** Set Variable (x4)

---

### 6.3. Consultas SQL - Ejecución Paralela
```
┌─────────────────────────────────────────────────────────────┐
│ NODO 3 & 4: Microsoft SQL Nodes (Paralelo)                 │
└─────────────────────────────────────────────────────────────┘
```

#### Nodo 3: Query DWH Reestructurados
```json
{
  "name": "Query DWH - Reestructurados",
  "type": "n8n-nodes-base.microsoftSql",
  "credentials": {
    "microsoftSql": "SQL Server DWH_CC"
  },
  "parameters": {
    "operation": "executeQuery",
    "query": "={{ $node['Read SQL File'].json.query_reestructurados }}",
    "options": {
      "queryTimeout": 60000
    }
  }
}
```

#### Nodo 4: Query SCC Modificados (Contingencia)
```json
{
  "name": "Query SCC - Modificados",
  "type": "n8n-nodes-base.microsoftSql",
  "credentials": {
    "microsoftSql": "SQL Server RIESGOS"
  },
  "parameters": {
    "operation": "executeQuery",
    "query": "={{ $node['Read SQL File'].json.query_modificados }}",
    "options": {
      "queryTimeout": 60000
    }
  }
}
```

**Nota:** Estos dos nodos se ejecutan **simultáneamente** gracias a la conexión paralela, reduciendo tiempo de 2 min a 1 min.

**Equivalente PAD:** Open SQL Connection + Execute SQL Statement (x2, pero secuencial)

---

### 6.4. Merge de Datos
```
┌─────────────────────────────────────────────────────────────┐
│ NODO 5: Merge Node (Consolidar Resultados)                 │
└─────────────────────────────────────────────────────────────┘
```

**Configuración del Nodo:**
```json
{
  "name": "Merge Reestructurados + Modificados",
  "type": "n8n-nodes-base.merge",
  "parameters": {
    "mode": "append",
    "options": {}
  }
}
```

**Equivalente PAD:** N/A (manual en VBA)

---

### 6.5. Validación y Filtrado
```
┌─────────────────────────────────────────────────────────────┐
│ NODO 6: Filter Node (Validación de Datos)                  │
└─────────────────────────────────────────────────────────────┘
```

**Configuración del Nodo:**
```json
{
  "name": "Validar Datos Completos",
  "type": "n8n-nodes-base.filter",
  "parameters": {
    "conditions": {
      "boolean": [],
      "number": [
        {
          "value1": "={{ $json.saldo_capital }}",
          "operation": "larger",
          "value2": 0
        },
        {
          "value1": "={{ $json.tasa_interes_original }}",
          "operation": "larger",
          "value2": 0
        },
        {
          "value1": "={{ $json.tasa_interes_original }}",
          "operation": "smaller",
          "value2": 0.5
        }
      ],
      "string": [
        {
          "value1": "={{ $json.obligacion }}",
          "operation": "isNotEmpty"
        }
      ]
    }
  }
}
```

**Equivalente PAD:** If + For Each (iteración manual)

---

### 6.6. Script Python - Cálculos
```
┌─────────────────────────────────────────────────────────────┐
│ NODO 7: Execute Command Node (Python Script)               │
└─────────────────────────────────────────────────────────────┘
```

**Configuración del Nodo:**
```json
{
  "name": "Python - Calcular Valor Valuativo",
  "type": "n8n-nodes-base.executeCommand",
  "parameters": {
    "command": "python3",
    "arguments": "{{ $env.SCRIPTS_PATH }}/calculo_amortizacion.py",
    "options": {
      "cwd": "{{ $env.WORKSPACE_PATH }}",
      "env": {
        "INPUT_FILE": "{{ $json.temp_data_file }}"
      }
    }
  }
}
```

**Script Python (`calculo_amortizacion.py`):**
```python
import pandas as pd
import numpy as np
import sys
import json
from datetime import datetime

def calcular_valor_presente(flujos, tasa, plazo):
    """Calcular Valor Presente de flujos futuros"""
    vp = 0
    for t in range(1, plazo + 1):
        vp += flujos[t-1] / ((1 + tasa) ** t)
    return vp

def calcular_perdida_ganancia(vp_original, vp_nuevo):
    """Calcular diferencia de VP"""
    return vp_original - vp_nuevo

def factor_amortizacion(plazo_remanente):
    """Factor de amortización según plazo remanente"""
    if plazo_remanente <= 12:
        return 1.0
    elif plazo_remanente <= 24:
        return 0.95
    elif plazo_remanente <= 36:
        return 0.90
    elif plazo_remanente <= 60:
        return 0.85
    else:
        return 0.80

def main():
    # Leer datos de entrada (pasados desde n8n)
    input_data = json.loads(sys.stdin.read())
    
    df = pd.DataFrame(input_data)
    
    # Calcular Valor Presente Original
    df['vp_original'] = df.apply(
        lambda row: calcular_valor_presente(
            [row['cuota_original']] * row['plazo_original'],
            row['tasa_interes_original'],
            row['plazo_original']
        ), axis=1
    )
    
    # Calcular Valor Presente Reestructurado
    df['vp_nuevo'] = df.apply(
        lambda row: calcular_valor_presente(
            [row['cuota_nueva']] * row['plazo_nuevo'],
            row['tasa_interes_nueva'],
            row['plazo_nuevo']
        ), axis=1
    )
    
    # Calcular Pérdida/Ganancia
    df['perdida_ganancia'] = df.apply(
        lambda row: calcular_perdida_ganancia(row['vp_original'], row['vp_nuevo']),
        axis=1
    )
    
    # Calcular Valor Valuativo
    df['valor_valuativo'] = df.apply(
        lambda row: row['perdida_ganancia'] * factor_amortizacion(row['plazo_nuevo']),
        axis=1
    )
    
    # Redondear a 2 decimales
    df = df.round({
        'vp_original': 2,
        'vp_nuevo': 2,
        'perdida_ganancia': 2,
        'valor_valuativo': 2
    })
    
    # Devolver JSON a n8n
    print(df.to_json(orient='records'))

if __name__ == '__main__':
    main()
```

**Equivalente PAD:** Run Excel Macro (x4 macros VBA)

---

### 6.7. Control de Errores
```
┌─────────────────────────────────────────────────────────────┐
│ NODO 8: IF Node (Error Detection)                          │
└─────────────────────────────────────────────────────────────┘
```

**Configuración del Nodo:**
```json
{
  "name": "Verificar Errores",
  "type": "n8n-nodes-base.if",
  "parameters": {
    "conditions": {
      "boolean": [
        {
          "value1": "={{ $json.error }}",
          "operation": "notEqual",
          "value2": true
        }
      ]
    }
  }
}
```

**Rama Error:**
```json
{
  "name": "Send Error Email",
  "type": "n8n-nodes-base.gmail",
  "credentials": {
    "gmailOAuth2": "Gmail - RDA Bot"
  },
  "parameters": {
    "resource": "message",
    "operation": "send",
    "subject": "[ERROR] RDA Costo Amortizable - {{ $now.toFormat('yyyy-MM-dd') }}",
    "emailType": "text",
    "message": "Se detectó un error durante la ejecución:\n\n{{ $json.error_message }}\n\nRevise los logs en n8n.",
    "toList": "ccamposg@fgs.co",
    "options": {
      "attachments": "={{ $json.screenshot }}"
    }
  }
}
```

**Equivalente PAD:** On Block Error → Send Email

---

### 6.8. Queries Adicionales - Paralelo
```
┌─────────────────────────────────────────────────────────────┐
│ NODOS 9, 10, 11: Queries Adicionales (Paralelo)            │
└─────────────────────────────────────────────────────────────┘
```

#### Nodo 9: Query Completitud
```json
{
  "name": "Query - Verificar Completitud",
  "type": "n8n-nodes-base.microsoftSql",
  "credentials": {
    "microsoftSql": "SQL Server DWH_CC"
  },
  "parameters": {
    "operation": "executeQuery",
    "query": "={{ $node['Read SQL File'].json.query_completitud }}"
  }
}
```

#### Nodo 10: Query Tasas y Plazos
```json
{
  "name": "Query - Tasas y Plazos",
  "type": "n8n-nodes-base.microsoftSql",
  "credentials": {
    "microsoftSql": "SQL Server DWH_CC"
  },
  "parameters": {
    "operation": "executeQuery",
    "query": "={{ $node['Read SQL File'].json.query_tasas_plazos }}"
  }
}
```

#### Nodo 11: Query Variables Valuativo
```json
{
  "name": "Query - Variables Valuativo",
  "type": "n8n-nodes-base.microsoftSql",
  "credentials": {
    "microsoftSql": "SQL Server DWH_CC"
  },
  "parameters": {
    "operation": "executeQuery",
    "query": "={{ $node['Read SQL File'].json.query_variables }}"
  }
}
```

**Nota:** Estos 3 nodos se ejecutan **simultáneamente**, reduciendo tiempo de 3 min a 1 min.

**Equivalente PAD:** Execute SQL Statement (x3, secuencial)

---

### 6.9. Generación de Excel
```
┌─────────────────────────────────────────────────────────────┐
│ NODO 12: Spreadsheet File Node (Generar Excel)             │
└─────────────────────────────────────────────────────────────┘
```

**Configuración del Nodo:**
```json
{
  "name": "Generar Reporte Excel",
  "type": "n8n-nodes-base.spreadsheetFile",
  "parameters": {
    "operation": "fromJson",
    "fileFormat": "xlsx",
    "options": {
      "fileName": "Reestructurados_{{ $json.fecha_proceso }}.xlsx",
      "headerRow": true,
      "sheetName": "Reestructurados",
      "compression": false
    }
  }
}
```

**Equivalente PAD:** Launch Excel + Write to Worksheet + Save Excel

---

### 6.10. Cargue a Base de Datos
```
┌─────────────────────────────────────────────────────────────┐
│ NODO 13: Microsoft SQL Node (Insert)                       │
└─────────────────────────────────────────────────────────────┘
```

**Configuración del Nodo:**
```json
{
  "name": "Insert SQL - Costo Amortizado",
  "type": "n8n-nodes-base.microsoftSql",
  "credentials": {
    "microsoftSql": "SQL Server ANDREAL"
  },
  "parameters": {
    "operation": "insert",
    "table": "Costo_Amortizado_{{ $json.fecha_proceso }}",
    "columns": "obligacion, tipo_credito, saldo_capital, tasa_interes_original, tasa_interes_nueva, valor_valuativo, fecha_proceso",
    "options": {
      "skipOnConflict": true
    }
  }
}
```

**Equivalente PAD:** Execute SQL Statement (INSERT)

---

### 6.11. Envío de Reportes
```
┌─────────────────────────────────────────────────────────────┐
│ NODO 14: Gmail/Send Email Node (Distribución)              │
└─────────────────────────────────────────────────────────────┘
```

**Configuración del Nodo:**
```json
{
  "name": "Enviar Reportes por Correo",
  "type": "n8n-nodes-base.gmail",
  "credentials": {
    "gmailOAuth2": "Gmail - RDA Bot"
  },
  "parameters": {
    "resource": "message",
    "operation": "send",
    "subject": "[Completado] RDA Costo Amortizable - {{ $json.fecha_proceso }}",
    "emailType": "html",
    "message": "<html><body><p>Buen día,</p><p>Adjunto los reportes de Costo Amortizable correspondientes a <strong>{{ $json.fecha_proceso }}</strong>:</p><ul><li>✓ Reestructurados: {{ $json.count_reestructurados }} obligaciones</li><li>✓ Modificados: {{ $json.count_modificados }} obligaciones</li><li>✓ Resumen Ejecutivo</li></ul><p>Total procesado: <strong>{{ $json.total_obligaciones }}</strong> obligaciones</p><p>Impacto Neto: <strong>${{ $json.valor_valuativo_total }}</strong></p><p>Datos cargados en <code>ANDREAL.Costo_Amortizado_{{ $json.fecha_proceso }}</code></p><p>Saludos,<br>Bot RDA Costo Amortizable (n8n)</p></body></html>",
    "toList": "ccamposg@fgs.co",
    "ccList": "gerencia@bancocajasocial.com",
    "options": {
      "attachments": "binaryProperty",
      "binaryPropertyName": "reportes"
    }
  }
}
```

**Equivalente PAD:** Send Email

---

### 6.12. Logging y Auditoría
```
┌─────────────────────────────────────────────────────────────┐
│ NODO 15: Write Binary File Node (Log Execution)            │
└─────────────────────────────────────────────────────────────┘
```

**Configuración del Nodo:**
```json
{
  "name": "Guardar Log de Ejecución",
  "type": "n8n-nodes-base.writeBinaryFile",
  "parameters": {
    "fileName": "execution_{{ $now.toFormat('yyyyMMdd_HHmmss') }}.log",
    "dataPropertyName": "execution_log",
    "options": {
      "append": false
    }
  }
}
```

**Equivalente PAD:** Log Message (x múltiples)

---

## 7. Mapa Completo de Workflow n8n

```
Cron Trigger (1)
    ↓
Set Variables (2)
    ↓
    ├─→ Query DWH (3) ─┐
    |                   ├─→ Merge (5)
    └─→ Query SCC (4) ─┘       ↓
                         Validate & Filter (6)
                                ↓
                          Python Script (7)
                                ↓
                          IF Errores (8)
                         ↙          ↘
                  [Sí Error]    [No Error]
                      ↓              ↓
               Send Error Email   ├─→ Query Completitud (9) ─┐
                      ↓           ├─→ Query Tasas (10) ───────├─→ Merge (12)
                   End Error     └─→ Query Valuativo (11) ───┘       ↓
                                                              Generate Excel (13)
                                                                      ↓
                                                               Insert SQL (14)
                                                                      ↓
                                                               Send Report (15)
                                                                      ↓
                                                                Log Execution (16)
                                                                      ↓
                                                                    End
```

**Total Nodos:** 16  
**Ejecuciones Paralelas:** 2 (nodos 3-4, nodos 9-10-11)  
**Tiempo Total:** ~8 minutos

---

## 8. Monitoreo y Logs

### Sistema de Logs en n8n

n8n proporciona logging nativo con niveles:
- **INFO:** Operaciones normales
- **WARN:** Advertencias no críticas
- **ERROR:** Errores capturados
- **DEBUG:** Información detallada (desarrollo)

**Configuración de Logging:**
```bash
# En docker-compose.yml o .env
N8N_LOG_LEVEL=info
N8N_LOG_OUTPUT=console,file
N8N_LOG_FILE_LOCATION=/home/node/.n8n/logs/
N8N_LOG_FILE_SIZE_MAX=10485760  # 10MB
N8N_LOG_FILES_COUNT=10
```

**Consultar Logs:**
```bash
# Docker
docker-compose logs -f n8n --tail=100

# Direct
tail -f ~/.n8n/logs/n8n.log
```

---

## 9. Backup y Recuperación

### Backup de Workflows
```bash
# Exportar workflow como JSON
n8n export:workflow --id=1 --output=workflows/RDA_Costo_Amortizable.json

# Backup completo de n8n
docker-compose exec n8n n8n export:all --output=/home/node/.n8n/backup/
```

### Backup de Base de Datos PostgreSQL
```bash
# Backup PostgreSQL
docker-compose exec postgres pg_dump -U n8n n8n > backup_n8n_$(date +%Y%m%d).sql

# Restore
docker-compose exec -T postgres psql -U n8n n8n < backup_n8n_20251110.sql
```

---

## 10. Seguridad

### 10.1. Encriptación de Credenciales
n8n encripta credenciales con `N8N_ENCRYPTION_KEY`:

```bash
# Generar clave de encriptación
openssl rand -hex 32

# Configurar en .env
N8N_ENCRYPTION_KEY=tu_clave_generada_de_64_caracteres
```

### 10.2. HTTPS con Nginx Reverse Proxy
```nginx
# /etc/nginx/sites-available/n8n
server {
    listen 443 ssl http2;
    server_name n8n.bancocajasocial.local;

    ssl_certificate /etc/ssl/certs/n8n.crt;
    ssl_certificate_key /etc/ssl/private/n8n.key;

    location / {
        proxy_pass http://localhost:5678;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 10.3. Autenticación
```bash
# Habilitar autenticación básica
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=tu_password_seguro

# O usar LDAP/SSO (Enterprise)
```

---

## 11. Mantenimiento

### Tareas Mensuales
- [ ] Revisar ejecuciones en n8n UI
- [ ] Limpiar ejecuciones antiguas (>14 días)
- [ ] Backup de workflows
- [ ] Actualizar Node.js/n8n si hay parches de seguridad
- [ ] Verificar espacio en disco
- [ ] Revisar logs de errores

### Actualización de n8n
```bash
# Docker
docker-compose pull
docker-compose up -d

# npm
npm update -g n8n
```

---

## 12. Troubleshooting

| Problema | Causa | Solución |
|----------|-------|----------|
| Timeout en query SQL | Query muy pesado | Aumentar `requestTimeout` a 120000ms |
| Python script falla | Librería faltante | `pip install <librería>` |
| Credencial SQL inválida | Password expirado | Actualizar en n8n UI → Credentials |
| Workflow no dispara | Cron mal configurado | Verificar expresión cron |
| Docker no levanta | Puerto 5678 ocupado | `lsof -i :5678` y matar proceso |

---

**Versión:** 1.0  
**Fecha de Creación:** 10/11/2025  
**Próxima Revisión:** Mensual
