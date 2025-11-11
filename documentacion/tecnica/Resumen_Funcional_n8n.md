# Manual Funcional Resumido – n8n (RDA Costo Amortizable)

Versión: 1.0  |  Fecha: 10/11/2025  |  Audiencia: Negocio, Riesgos, Gerencia

## 1) Objetivo y resumen ejecutivo
- Objetivo: Automatizar el proceso de Costo Amortizable reduciendo 14 horas manuales a pocos minutos con control y trazabilidad.
- Tiempo estimado de ejecución: ~8 minutos (reducción > 99%).
- Beneficios: rapidez, menor error, evidencia para auditoría, escalabilidad y ahorro anual.
- Alcance: extracción de datos (reestructurados/modificados), validaciones básicas, cálculo de indicadores y generación/distribución de reportes.
- Fuera de alcance: definición de políticas, interpretación gerencial, análisis cualitativo de riesgo.

## 2) Arquitectura conceptual (vista funcional)
```
Usuarios/Negocio  ⇄  n8n (Orquestación)  ⇄  Bases de Datos Internas
                         │
                         ├─ Agenda (programación)
                         ├─ Validaciones y reglas
                         ├─ Generación de reportes
                         └─ Registro y alertas
```

## 3) Conectividad Azure ↔ On-Premise (opciones)
| Opción | Uso | Ventajas | Considerar |
|--------|-----|----------|------------|
| VPN Site-to-Site | Producción | Estable, segura | Costo medio, requiere coordinación |
| SSH Bastion | Pilotos | Muy económica, rápida | Menos robusta, un único punto de falla |
| Híbrido (worker local) | Escalamiento | Baja latencia, crecimiento | Mayor complejidad operativa |
| ExpressRoute | Corporativo masivo | Máxima estabilidad y capacidad | Alto costo, solo si multi-procesos |

Selección recomendada: VPN para producción; Bastion para pruebas rápidas; evaluar Híbrido si crece el volumen.

## 4) Requisitos funcionales mínimos
1. Ejecución automática mensual (último día hábil).  
2. Consulta de fuentes definidas con control de acceso.  
3. Validaciones: completitud, saldos positivos, rangos de tasa.  
4. Cálculo de indicadores: pérdida/ganancia y valor valuativo.  
5. Reportes (detalle y ejecutivo) y distribución autorizada.  
6. Registro de cada ejecución (fecha, estado, métricas).  
7. Notificación ante error crítico.  
8. Control de versiones de reglas y lista de destinatarios.  

## 5) Roles y gobierno
| Rol | Función principal |
|-----|-------------------|
| Propietario Proceso | Define reglas y valida resultados |
| Analista Funcional | Revisa reportes y solicita ajustes |
| Riesgos | Interpreta indicadores para gestión |
| Operación (n8n) | Supervisa y atiende alertas |
| Seguridad/Infra | Garantiza conectividad segura |
| Auditoría | Verifica trazabilidad y controles |

## 6) KPIs clave
| KPI | Objetivo |
|-----|----------|
| Tiempo ejecución | ≤ 10 min |
| Ejecuciones exitosas | ≥ 95% mes |
| Incidencias críticas | 0 mes |
| Puntualidad entrega | 100% |
| Ahorro operativo | > 50 h/mes |

## 7) Costos referenciales (rangos)
| Concepto | Rango mensual aproximado |
|----------|--------------------------|
| n8n self-hosted | 0–50 USD |
| VPN Site-to-Site | 140–200 USD |
| SSH Bastion | 15–40 USD |
| Híbrido (servicios auxiliares) | 70–110 USD |
| Ahorro vs PAD (licencia) | ≈ 2.280 USD/año |

## 8) Riesgos y mitigaciones
| Riesgo | Mitigación |
|--------|------------|
| Conectividad inestable | Monitoreo y alertas tempranas |
| Datos incompletos | Validaciones previas y reporte inconsistencias |
| Cambio estructura BD | Revisión mensual fuentes |
| Reglas desactualizadas | Control de versiones y aprobación |
| Escalamiento sin capacidad | Plan trimestral de capacidad |

## 9) Flujo de alto nivel
Disparo → Inicializar → Consultas paralelas → Unir y depurar → Validar → Calcular → Verificar errores → Consultas complementarias → Consolidar → Reportes → Enviar → Registrar/archivar.

## 10) Fases de implementación
| Fase | Objetivo | Entregable |
|------|----------|------------|
| Diseño | Alcance y reglas | Documento validado |
| Conectividad | Elegir y habilitar canal | VPN/Bastion operativo |
| Construcción | Parametrizar flujo | Workflow base |
| Piloto | Comparar con proceso manual | Informe equivalencia |
| Go-Live | Operación mensual | Reportes distribuidos |
| Optimización | Mejoras y KPIs | Tablero seguimiento |

## 11) Próximos pasos
1. Confirmar opción de conectividad para producción.  
2. Validar reglas de cálculo y lista de destinatarios.  
3. Ejecutar piloto controlado (1 ciclo) y cerrar acta.  
4. Activar tablero de KPIs y gobernanza mensual.  

## 12) Nota final
Contenido técnico detallado (instalación, configuraciones, scripts) se separa en Manual Técnico para TI. Este resumen es suficiente para decisión y seguimiento funcional.

---
Resumen en una frase: n8n reduce un proceso crítico de horas a minutos con control, calidad y escalabilidad a bajo costo.
