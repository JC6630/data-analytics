# 🎬 Proyecto de Análisis de Base de Datos - Sakila (PostgreSQL)

## 📌 Descripción del Proyecto
Este proyecto consiste en el diseño, análisis y optimización de una base de datos cinematográfica basada en el modelo **Sakila**. A través de la herramienta **DBeaver**, se ha estructurado el esquema relacional y se han ejecutado una serie de consultas SQL avanzadas para extraer métricas clave de negocio, resolver inconsistencias lógicas y analizar la actividad operativa.

---

## 🗒️ Metodología y Pasos Seguidos

### 1. Generación del Esquema en DBeaver
Para comprender la arquitectura física de los datos, se generó el **Esquema Relacional (Diagrama ER)** utilizando las capacidades nativas de DBeaver:
* **Sincronización:** Se accedió al *Database Navigator*, seleccionando el esquema principal (`public`) de PostgreSQL.
* **Visualización:** Mediante la pestaña **Diagrama ER** de la carpeta *Tablas*, el motor recopiló automáticamente las entidades y sus conexiones mediante Claves Foráneas (*Foreign Keys*).
* **Persistencia:** Se utilizó la funcionalidad de actualización integrada (`F5 / Refresh`) para asegurar que el lienzo recogiera en tiempo real cualquier alteración estructural.

### 2. Implementación de Consultas Avanzadas y Documentación
Para la manipulación de datos se aplicaron estándares estrictos de PostgreSQL, apoyándose en técnicas de optimización y en la documentación oficial de funciones avanzadas (como *Window Functions* de la comunidad especializada `boringsql.com`):
* **Normalización de Relaciones:** Uso de combinaciones externas e internas (`INNER JOIN`, `LEFT JOIN`) para evitar productos cartesianos masivos.
* **Manejo de Nulos:** Inclusión de funciones de control de flujo como `COALESCE` para la limpieza y presentación de métricas a nivel de reporte.
* **Segmentación Temporal:** Uso de funciones nativas de PostgreSQL (`TO_CHAR`, `EXTRACT`) para el correcto agrupamiento cronológico.

---

## 📊 Informe de Análisis y Consultas SQL

### 🔎 1. Evaluación de Relaciones: CROSS JOIN vs. INNER JOIN
Se evaluó el impacto de cruzar las tablas `film` y `category` mediante un producto cartesiano directo:
```sql
SELECT f.film_id, f.title, c.category_id, c.name AS category_name
FROM film f
CROSS JOIN category c;
```
* **Conclusión del análisis:** **Esta consulta NO aporta valor práctico.** Un `CROSS JOIN` multiplica cada película por cada categoría existente (ej. 1,000 películas × 16 categorías = 16,000 filas). Esto genera datos falsos al afirmar que todas las películas pertenecen a todos los géneros a la vez. Para obtener valor real, se sustituyó por un `INNER JOIN` utilizando la tabla intermedia `film_category`.

### 📉 2. Clasificación de Actores por Apellido
Selección completa del catálogo de actores unificando su identidad y ordenándolos alfabéticamente:
```sql
SELECT CONCAT(a.first_name, ' ', a.last_name) AS actor
FROM actor AS a
ORDER BY a.last_name ASC;
```

### 🎬 3. Disponibilidad en Inventario y Auditoría de Vacíos
Análisis de la oferta de películas cruzando el catálogo con la tabla intermedia `film_actor` e `inventory`. Se aplicó `LEFT JOIN` para garantizar que la consulta **recoja incluso aquellas películas que no tienen actores o que carecen de copias físicas en stock** (evitando que el sistema las oculte).

```sql
-- Conteo de existencias totales por título (0 si no hay stock)
SELECT f.film_id, f.title AS pelicula, COUNT(i.inventory_id) AS cantidad_disponible
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER BY cantidad_disponible DESC;
```

### 📊 4. Volumen Operativo de Alquileres por Mes
Para resolver la métrica de alquileres mensuales sin duplicar registros de un mismo periodo, se refinó la agrupación eliminando la granularidad de días (`DD`) y aplicando funciones nativas de PostgreSQL:

```sql
SELECT
    TO_CHAR(rental_date, 'YYYY') AS anual,
    TO_CHAR(rental_date, 'MM') AS mes,
    COUNT(rental_id) AS total_alquileres
FROM "rental"
GROUP BY TO_CHAR(rental_date, 'YYYY'), TO_CHAR(rental_date, 'MM')
ORDER BY anual ASC, mes ASC;
```
* **Conclusión del análisis:** Al agrupar estrictamente por `YYYY` y `MM`, PostgreSQL compacta el desglose diario en una única fila mensual. Esto permite identificar con precisión estacional los picos de demanda del negocio.

---

## 💡 Herramientas y Conceptos Clave Incorporados
* **`COALESCE(valor, reemplazo)`**: Implementado para interceptar valores `NULL` y sustituirlos por respuestas por defecto (`0` o texto explícito), asegurando reportes limpios.
* **`TO_CHAR` y `EXTRACT`**: Preferidos sobre funciones como `DATE_FORMAT` o `YEAR()` debido a que estas últimas no pertenecen al estándar de PostgreSQL y arrojan errores de tipo de dato (`SQL Error [42883]`).
* **Window Functions (Lectura Complementaria)**: Basado en la documentación de `boringsql.com`, se analizó el potencial de cláusulas como `OVER (PARTITION BY ...)` para realizar cálculos de medias móviles (`MOVING AVERAGE`) y clasificaciones (`RANK`, `DENSE_RANK`) sin necesidad de colapsar las filas de detalle con un `GROUP BY` tradicional.
