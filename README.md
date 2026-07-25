# 📊 Análisis de Ventas: Exploración de Datos y Dashboard de KPIs

## Descripción del proyecto

Este proyecto consiste en el análisis exploratorio de un conjunto de datos de ventas de una empresa distribuidora de modelos a escala (coches clásicos, motos, aviones, barcos, trenes y camiones), con el objetivo de **transformar datos transaccionales en bruto en un dashboard interactivo** que permita monitorizar el rendimiento comercial del negocio.

El dataset original contiene **2.823 registros de líneas de pedido**, correspondientes a **307 pedidos únicos** de **92 clientes** repartidos en **19 países**, con un histórico que abarca desde enero de 2003 hasta septiembre de 2005.

### Problema que resuelve

Los datos de partida están a nivel de **línea de pedido** (un mismo pedido puede tener varias filas, una por cada producto comprado), lo cual dificulta responder preguntas de negocio directas como "¿cuántos pedidos se hicieron?" o "¿cuál es el ticket medio por venta?" sin antes entender bien la granularidad de los datos y aplicar las agregaciones correctas. El proyecto aborda este problema mediante:

- Identificación de la unidad de análisis correcta según el KPI (línea de pedido vs. pedido completo vs. cliente).
- Limpieza y preparación de los datos (tratamiento de valores nulos, validación de tipos numéricos, creación de un identificador único de fila).
- Definición de un conjunto de KPIs relevantes para ventas y beneficios.
- Construcción de un dashboard interactivo con filtros dinámicos, tablas dinámicas y visualizaciones.

### Técnicas y enfoque utilizados

- **Análisis exploratorio de datos (EDA):** revisión de estructura, tipos de datos, valores nulos y duplicados.
- **Modelado de granularidad:** distinción entre nivel de línea de pedido (`ORDERNUMBER + ORDERLINENUMBER`) y nivel de pedido (`ORDERNUMBER`) para evitar KPIs erróneos por doble conteo.
- **Tablas dinámicas (Pivot Tables)** en Google Sheets para el cálculo de KPIs agregados.
- **Segmentaciones de datos (slicers/filtros)** para el análisis interactivo por año, línea de producto, país y estado del pedido.
- **Visualización de datos** mediante gráficos de líneas, barras, barras horizontales y gráficos de dona/circular.
- **Fórmulas de hoja de cálculo** (`SUMIFS`, `COUNTUNIQUE`, `FILTER`, `UNIQUE`, agrupación de fechas) para el cálculo de KPIs a nivel de tarjeta individual.

---

## 🎯 Objetivo del dashboard

Ofrecer una vista única y filtrable del rendimiento de ventas y beneficios del negocio, que permita responder de un vistazo preguntas como:

- ¿Cuánto se ha vendido en total y cuál es la tendencia por año?
- ¿Cuál es el ticket medio por pedido y cuántos pedidos se completan con éxito?
- ¿Qué líneas de producto, países y clientes concentran más ventas?
- ¿Existen patrones estacionales en las ventas por producto?

---

## 📁 Dataset

| Campo | Detalle |
|---|---|
| **Nombre del archivo** | `sales_data_sample.csv` |
| **Registros** | 2.823 filas (líneas de pedido) |
| **Columnas** | 25 |
| **Periodo cubierto** | Enero 2003 – Septiembre 2005 |
| **Granularidad** | Una fila = un producto dentro de un pedido |

---

## 📌 KPIs principales

| KPI | Cálculo |
|---|---|
| Ventas totales | `SUMA(SALES)` |
| Nº de pedidos | `COUNTUNIQUE(ORDERNUMBER)` |
| Unidades vendidas | `SUMA(QUANTITYORDERED)` |
| Nº de clientes activos | `COUNTUNIQUE(CUSTOMERNAME)` |
| Ventas por paises
| Top línea de producto | `SUMA(SALES)` agrupado por `PRODUCTLINE`, ordenado descendente |

---

## 🛠️ Herramientas utilizadas

- **Google Sheets** — limpieza de datos, tablas dinámicas, fórmulas y dashboard final.
- **CSV** como formato de origen de datos.

---

## 📂 Estructura del proyecto

```
├── sales_data_sample.csv     # Dataset original
├── Dashboard (Google Sheets) # Tablas dinámicas, filtros y gráficos
└── README.md                 # Este documento
```

