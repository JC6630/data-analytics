-- 1. Crea el esquema de la BBDD.

--  2 Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.

select 
	"title" as películas,
	rating
from "film"
where "rating" = 'R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40

select *
from "actor";

select concat("first_name",'  ',"last_name") as nombre_actor
from "actor" as a;

select
	a.actor_id, 
	concat("first_name",'  ',"last_name") as nombre_actor
from "actor" as a
where "actor_id" >= 30 and "actor_id" <= 40;


-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
-- Funcion COALESCE visto en https://boringsql.com/posts/window-functions-introduction/


select *
from "film";

select f."title", f."language_id", f."original_language_id"
from "film" as f
where f."language_id" = f."original_language_id";


select 
	f."title", 
	f."language_id", 
	COALESCE(
	f."original_language_id", f."language_id"
	) as idioma_origen
from "film" as f
where f."language_id" = COALESCE(
	  f."original_language_id", f."language_id"
	  );



-- 5. Ordena las películas por duración de forma ascendente.

select 
	film_id,
	title,
	rental_duration 
from "film"
order by "rental_duration";


-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
-- Funcion ILIKE visto en https://boringsql.com/posts/window-functions-introduction/

select concat("first_name", ' ', "last_name") as actores
FROM "actor"; 


select
	concat("first_name", ' ', "last_name") as actores
FROM "actor"
where last_name ILIKE 'Allen';


/* 
 * 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación 
* junto con el recuento.
*/

select *
from "film";

select count("film_id") as recuento
from "film";

select 
	"rating" as clasificación, 
	count("film_id") as recuento
from "film"
group by "rating";


-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film


select *
from "film"
where "rating" = 'PG-13';


select 
	"title" as películas, 
	"rating" as clasificación, 
	"length" as duración
from "film"
where "rating" = 'PG-13' or "length" > 30
order by "length" desc;


-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
-- Funcion OVER visto en https://boringsql.com/posts/window-functions-introduction/

select *
from "film";

select 
    f."title",
    var_pop(f."replacement_cost") OVER () as varianza,
    stddev_pop(f."replacement_cost") OVER () as desviacion_estandar
from "film" as f;


-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

select *
from "film";

select
	f."film_id", 
	f."title",
    MAX(f."length") over() as mayor_duracion,
    MIN(f."length") over() as menor_duracion
from "film" as f;

select 
	f."title", 
	f."length"
from "film" as f
where f."length" = (
	select MAX("length") from "film"
	)
   or f."length" = (
   select MIN("length") from "film"
   )
order by f."length" desc;


-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.


select "amount", "payment_date" 
from "payment"; 

select "amount", "payment_date" 
from "payment"
order by "payment_date" desc;
--limit 1 offset 2; 

select amount 
from payment 
order 
	by payment_date desc, 
	payment_id desc 
LIMIT 1 OFFSET 2;


select "amount"
from "payment"
order 
	by DATE("payment_date") DESC, 
	"payment_id" DESC
LIMIT 1 OFFSET 2;


select 
	DATE(payment_date) as 
	fecha, SUM(amount) as costo_total
from "payment"
GROUP BY 
	DATE(payment_date)
order by fecha desc
LIMIT 1 OFFSET 2;


-- 12 Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación.

select *
from "film";

select 
	title, 
	rating 
from film 
where rating 
	NOT IN ('NC-17', 'G');
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        1

/* 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film 
y muestra la clasificación junto con el promedio de duración.
*/

select 
	rating, 
	AVG(length) as promedio_duracion
from "film"
group by rating;


-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

select 
	title, 
	length 
from "film" 
where length > 180
order by length desc;


-- 15. ¿Cuánto dinero ha generado en total la empresa?

select 
	SUM(amount) as total_generado 
from payment;


-- 16. Muestra los 10 clientes con mayor valor de id.


select
	c.customer_id,
	concat(c."first_name", ' ', c."last_name") as actores
from customer as c
order by customer_id desc 
limit 10;


-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’
-- Funcion ILIKE visto en https://boringsql.com/posts/window-functions-introduction/

SELECT 
	a."first_name", 
	a."last_name"
FROM "actor" as a
JOIN "film_actor" as fa 
	ON a."actor_id" = fa."actor_id"
JOIN "film" f 
	ON fa."film_id" = f."film_id"
WHERE f."title" ILIKE 'Egg Igby';

-- 18. Selecciona todos los nombres de las películas únicos.

select 
	DISTINCT title 
from film;


-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”

SELECT f.title, f.length
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length > 180;


select 
	f."title", 
	c."name" as categoria, 
	f."length"
from "film" as f
join "film_category" fc 
	on f."film_id" = fc."film_id"
join "category" c 
	on fc."category_id" = c."category_id"
where c."name" = 'Comedy' and f."length" > 180;


/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos 
y muestra el nombre de la categoría junto con el promedio de duración.
*/

select 
	c."name" as categoria, 
	AVG(f."length") as promedio_duracion
from "category" as c
join "film_category" as fc 
	on c."category_id" = fc."category_id"
join film f 
	on fc."film_id" = f."film_id"
group by c."name"
having AVG(f."length") > 110
order by AVG(f."length") desc;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT AVG(rental_duration) AS media_duracion_alquiler
FROM film;


-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.

SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM actor;


-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

select
	TO_CHAR(rental_date, 'YYYY') as anual,
	TO_CHAR(rental_date, 'MM') as mes,
	DATE(rental_date) as dia, 
	COUNT(*) as numero_alquileres
from rental
group by 
	TO_CHAR(rental_date, 'YYYY'),
	TO_CHAR(rental_date, 'MM'),
	DATE(rental_date)
order by numero_alquileres desc;


-- 24. Encuentra las películas con una duración superior al promedio.

SELECT 
	title as pelicula, 
	length as duración
FROM "film"
WHERE length > (
	SELECT AVG(length
	) 
	FROM "film")
order by length desc;


-- 25. Averigua el número de alquileres registrados por mes.


select
	TO_CHAR(rental_date, 'YYYY') as anual,
    TO_CHAR(rental_date, 'MM') as mes,

    COUNT(rental_id) as total_alquileres
from 
    "rental"
group by 
    TO_CHAR(rental_date, 'YYYY'), 
    TO_CHAR(rental_date, 'MM')
order by 
    mes asc;



-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

select 
    AVG(amount) as promedio_pago,
    STDDEV(amount) as desviacion_estandar,
    VARIANCE(amount) as varianza
from payment;

-- 27. ¿Qué películas se alquilan por encima del precio medio?

select 
	title, 
	rental_rate
from film
where 
	rental_rate > (
	select AVG(rental_rate
	) 
from film);

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas

select 
	fa.actor_id, 
	COUNT(fa.film_id) as total_peliculas
from film_actor as fa
group by fa.actor_id
having COUNT(fa.film_id) > 40;


-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

select 
	f."title", 
	COUNT(i."inventory_id") as cantidad_disponible
from "film" f
left join "inventory" i 
	on f."film_id" = i."film_id"
group by f."film_id", 
		 f."title"
order by cantidad_disponible desc;



-- 30. Obtener los actores y el número de películas en las que ha actuado.

select *
from actor as a;

select *
from "actor" as a
left join "film_actor" as fa;


select 
	a."actor_id", 
	a."first_name", 
	a."last_name", 
	COUNT(fa.film_id) as numero_peliculas
from "actor" as a
left join "film_actor" fa 
	on a."actor_id" = fa."actor_id"
group by a."actor_id", 
		 a."first_name", 
		 a."last_name"
order by numero_peliculas desc;


-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

select *
from "film";

select *
from "film" as f
left join "film_actor" as fa
	on fa.actor_id = f.film_id
left join "actor" as a
	on a.actor_id = fa.actor_id;

select
	fa."actor_id", 
	f."title" as titulo_pelicula,
	CONCAT(a.first_name, ' ', a.last_name) as actor
from "film" as f
left join "film_actor" as fa
	on fa.actor_id = f.film_id
left join "actor" as a
	on a.actor_id = fa.actor_id
order by f."title" asc;	


-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.


select *
from "actor";


select 
    CONCAT(a."first_name", ' ', a."last_name") as actor,
    fa."film_id"
from "actor" as a
left join film_actor fa on a."actor_id" = fa."actor_id";

select 
    CONCAT(a."first_name", ' ', a."last_name") as actor,
    f."title" as pelicula
from "actor" a
left join film_actor fa on a."actor_id" = fa."actor_id"
left join film f on fa."film_id" = f."film_id"
order by actor, pelicula;


-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.

select *
from "rental" as r;

select *
from "film" as f
left join "inventory" as i
	on f."film_id" = i."film_id"; 

select *
from "film" as f
left join "inventory" as i
	on f."film_id" = i."film_id"
left join "rental" as r
	on r."inventory_id" = i."inventory_id"
order by f."title" asc, r."rental_date" desc;


select
	f.title as titulo_pelicula,
	r.rental_id,
	r.rental_date as fecha_alquiler,
	r.return_date as fecha_devolucion,
	f.rental_rate as precio_alquiler
from "film" as f
left join "inventory" as i
	on f."film_id" = i."film_id"
left join "rental" as r
	on r."inventory_id" = i."inventory_id"
order by f."title" asc, r."rental_date" desc;


-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

select *
from "customer" as c;


select
	c."customer_id",
    CONCAT(c."first_name", ' ', c."last_name") as cliente
from "customer" as c;


select
	c."customer_id",
    CONCAT(c."first_name", ' ', c."last_name") as cliente
from "customer" as c
inner join payment as p
	on p.customer_id = c.customer_id;  


select
	c."customer_id",
    CONCAT(c."first_name", ' ', c."last_name") as cliente,
    SUM(p."amount") as total_gastado
from "customer" as c
inner join "payment" as p
	on p."customer_id" = c."customer_id" 
group by c."customer_id", c."first_name", c."last_name"
order by SUM(p."amount") desc
limit 5;


-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'

select *
from actor;

select
	CONCAT(a."first_name", ' ', a."last_name") as nombre_actor
from actor as a
where a."first_name" = 'Johnny';

select
	CONCAT(a."first_name", ' ', a."last_name") as nombre_actor
from actor as a
where a."first_name" ILIKE 'Johnny';


-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.

select 
    a."first_name" AS "Nombre",
    a."last_name" AS "Apellido"    
from "actor" as a;


-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

select
	a.actor_id,
	CONCAT(a."first_name", ' ', a."last_name") as nombre_actor,
	MIN(a.actor_id) as id_actor_mas_bajo,
	MAX(a.actor_id) as id_actor_mas_alto
from actor as a
group by a.actor_id, a.first_name, a.last_name;  


select
    MIN(a."actor_id") as id_actor_mas_bajo,
    MAX(a."actor_id") as id_actor_mas_alto
from actor as a;


-- 38. Cuenta cuántos actores hay en la tabla “actor”

select *
from "actor" as a;

select 
	COUNT(DISTINCT a."actor_id") as total_actores 
from "actor" as a;


-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

select *
from "actor" as a;

select
	CONCAT(a."last_name", ' ', a."first_name") as actor
from "actor" as a
order by a."last_name" asc; 



-- 40. Selecciona las primeras 5 películas de la tabla “film”

select *
from "film" as f;

select * 
from "film" as f
order by f."film_id" asc
limit 5;


-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

select *
from "actor" as a;


select 
	a."first_name" as nombre_actor
from "actor" as a;


select 
	a."first_name" as nombre_actor,
	COUNT(a."first_name") as total_nombre_actor
from "actor" as a
group by a."first_name"
order by total_nombre_actor desc, a."first_name" asc;


-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

select *
from "rental" as r
inner join customer as c
	on c.customer_id = r.customer_id; 


select
	CONCAT(c."first_name", ' ', c."last_name") as cliente
from "rental" as r
inner join customer as c
	on c.customer_id = r.customer_id; 


select
	r."rental_id" as id_alquiler,
    r."rental_date" as fecha_alquiler,
    r."return_date" as fecha_devolución,
	CONCAT(c."first_name", ' ', c."last_name") as cliente
from "rental" as r
inner join "customer" as c
	on c."customer_id" = r."customer_id"; 


-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

select *
from "customer" as c
left join "rental" as r
	on r."customer_id" = c."customer_id"; 


select
	CONCAT(c."first_name", ' ', c."last_name") as cliente
from "customer" as c
left join "rental" as r
	on r."customer_id" = c."customer_id"; 

select
	r."rental_id" as id_alquiler,
    r."rental_date" as fecha_alquiler,
	CONCAT(c."first_name", ' ', c."last_name") as cliente,
	c."active" as estado_cliente
from "customer" as c
left join "rental" as r
	on r."customer_id" = c."customer_id"; 


-- 44 Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.

select 
    f."title" as pelicula,
    c."name" as categoria
from "film" f
cross join "category" c;

-- No aporta valor porque ya existe una tabla film_category hecha específicamente para unir las películas con sus categorías reales


-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.

select *
from "film" as f
inner join "film_category" fc
	on fc."category_id" = f."film_id"
inner join "category" as c
	on fc."category_id" = c."category_id";


select *
from "film" as f
inner join "film_category" fc
	on fc."category_id" = f."film_id"
inner join "category" as c
	on fc."category_id" = c."category_id"
where c."name" = 'Action';	


select *
from "actor" as a
inner join "film_actor" as fa 
	on a."actor_id" = fa."actor_id"
inner join "film" as f 
	on fa."film_id" = f."film_id"
inner join "film_category" as fc 
	on f."film_id" = fc."film_id"
inner join "category" as c 
	on fc."category_id" = c."category_id"
where c."name" = 'Action';


select
	CONCAT(a."first_name", ' ', a."last_name") as nombre_actor,
	f.title as titulo_pelicula,
	c."name" as categoria
from "actor" as a
inner join "film_actor" as fa 
	on a."actor_id" = fa."actor_id"
inner join "film" as f 
	on fa."film_id" = f."film_id"
inner join "film_category" as fc 
	on f."film_id" = fc."film_id"
inner join "category" as c 
	on fc."category_id" = c."category_id"
where c."name" = 'Action'
order by f."title" asc;


-- 46. Encuentra todos los actores que no han participado en películas.

select 
    CONCAT(a."first_name", ' ', a."last_name") as nombre_actor
from "actor" as a
left join "film_actor" as fa 
	on a."actor_id" = fa."actor_id"
where fa."film_id" is null;


-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

select
	CONCAT(a."first_name", ' ', a."last_name") as nombre_actor
from "actor" as a;


select
	CONCAT(a."first_name", ' ', a."last_name") as nombre_actor,
	COUNT(fa."film_id") as total_peliculas
from "actor" as a
left join "film_actor" as fa
	on fa."actor_id" = a."actor_id"
group by a."actor_id", a."first_name", a."last_name"	
order by total_peliculas desc;


-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.

create view actor_num_peliculas as
select 
    a.first_name as nombre,
    a.last_name as apellido,
    COUNT(fa.film_id) as cantidad_peliculas
from actor as a
left join film_actor as fa 
	on a.actor_id = fa.actor_id
group by a.actor_id, a.first_name, a.last_name;


select * from actor_num_peliculas;


-- 49. Calcula el número total de alquileres realizados por cada cliente

select *
from "customer" as c;

select *
from "customer" as c
left join "rental" as r
	on r."customer_id" = c."customer_id"; 

select
	CONCAT(c."first_name", ' ', c."last_name") as nombre_cliente,
	COUNT(r."rental_id") as total_alquileres
from "customer" as c
left join "rental" as r
	on r."customer_id" = c."customer_id"
group by c."customer_id"
order by total_alquileres desc;



-- 50. Calcula la duración total de las películas en la categoría 'Action'.

select *
from "film" as f;

select *
from "film" as f
inner join "film_category" as fc
	on fc."film_id" = f."film_id"
inner join "category" as c
	on c."category_id" = fc."category_id"; 


select
	c."name" as categoria,
    SUM(f."length") as duracion_total_minutos	
from "film" as f
inner join "film_category" as fc
	on fc."film_id" = f."film_id"
inner join "category" as c
	on c."category_id" = fc."category_id" 
where c."name" = 'Action'
group by categoria;



-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.

create temporary table cliente_rentas_temporal as
select
	CONCAT(c."first_name", ' ', c."last_name") as nombre_cliente,
	COUNT(r."rental_id") as total_alquileres
from "customer" as c
left join "rental" as r
	on r."customer_id" = c."customer_id"
group by c."customer_id"
order by total_alquileres desc;

select * from cliente_rentas_temporal order by total_alquileres desc;


-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

select * 
from "film" as f
inner join "inventory" as i
	on i."film_id" = f."film_id"
inner join "rental" as r
	on r."inventory_id" = i."inventory_id";

select
	f.film_id,
	f.title as pelicula,
	COUNT(r.rental_id) as total_alquileres
from "film" as f
inner join "inventory" as i
	on i."film_id" = f."film_id"
inner join "rental" as r
	on r."inventory_id" = i."inventory_id"	
group by f."film_id", f."title";  	


CREATE TEMPORARY TABLE peliculas_alquiladas as
select
	f.film_id,
	f.title as pelicula,
	COUNT(r.rental_id) as total_alquileres
from "film" as f
inner join "inventory" as i
	on i."film_id" = f."film_id"
inner join "rental" as r
	on r."inventory_id" = i."inventory_id"	
group by f."film_id", f."title" 
having COUNT(r."rental_id") >= 10;


select * from peliculas_alquiladas ORDER BY total_alquileres DESC;


-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente
-- con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
-- los resultados alfabéticamente por título de película.

select *
from "customer" as c
inner join "rental" as r
	on r."customer_id" = c."customer_id"
inner join "inventory" as i
	on i."inventory_id" = r."inventory_id"; 


select
	f."title" as pelicula,
	r."rental_date" as fecha_alquiler,
	r."return_date" as fecha_devolución
from "customer" as c
inner join "rental" as r
	on r."customer_id" = c."customer_id"
inner join "inventory" as i
	on i."inventory_id" = r."inventory_id" 
inner join "film" as f
	on f."film_id" = i."film_id"; 


select
	f."title" as pelicula,
	r."rental_date" as fecha_alquiler,
	r."return_date" as fecha_devolución
from "customer" as c
inner join "rental" as r
	on r."customer_id" = c."customer_id"
inner join "inventory" as i
	on i."inventory_id" = r."inventory_id" 
inner join "film" as f
	on f."film_id" = i."film_id"
where 
	c."first_name" ILIKE 'Tammy'
and c."last_name" ILIKE 'Sanders'
and r."return_date" is null
order by pelicula asc;	


/* 54. Encuentra los nombres de los actores que han actuado en al menos una
película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
alfabéticamente por apellido. */

select *
from "actor" as a
inner join "film_actor" as fa
	on fa."actor_id" = a."actor_id"
inner join "film_category" as fc
	on fc."film_id" = fa."film_id"
inner join "category" as c
	on c."category_id" = fc."category_id"; 


select *
from "actor" as a
inner join "film_actor" as fa
	on fa."actor_id" = a."actor_id"
inner join "film_category" as fc
	on fc."film_id" = fa."film_id"
inner join "category" as c
	on c."category_id" = fc."category_id"
where c.name = 'Sci-Fi';	


select
	a.first_name as nombres,
	a.last_name as apellidos,
	COUNT(fc.film_id) AS total_peliculas_scifi	
from "actor" as a
inner join "film_actor" as fa
	on fa."actor_id" = a."actor_id"
inner join "film_category" as fc
	on fc."film_id" = fa."film_id"
inner join "category" as c
	on c."category_id" = fc."category_id"
where c.name = 'Sci-Fi'
group by a.first_name, a.last_name
order by a.last_name asc;


/* 55. Encuentra el nombre y apellido de los actores que han actuado en
películas que se alquilaron después de que la película ‘Spartacus
Cheaper’ se alquilara por primera vez. Ordena los resultados
alfabéticamente por apellido. */

select *
from "actor" as a
inner join "film_actor" as fa
	on fa."actor_id" = a."actor_id"
inner join "film" as f
	on f."film_id" = fa."film_id"
inner join "inventory" as i
	on i."film_id" = f."film_id"
inner join "rental" as r
	on r."inventory_id" = i."inventory_id"; 


select
    a."first_name" as nombre,
    a."last_name" as apellido,
    f."title" as pelicula,
    r."rental_date" as fecha_alquiler
from "actor" as a
inner join "film_actor" as fa
	on fa."actor_id" = a."actor_id"
inner join "film" as f
	on f."film_id" = fa."film_id"
inner join "inventory" as i
	on i."film_id" = f."film_id"
inner join "rental" as r
	on r."inventory_id" = i."inventory_id"
where r."rental_date" > (
	select
	MIN(r2."rental_date")
	from "film" as f2
	inner join "inventory" as i2
		on i2."film_id" = f2."film_id"
	inner join "rental" as r2
		on r2."inventory_id" = i2."inventory_id"
		where f2."title" ILIKE 'Spartacus Cheaper'
)	
group by a."actor_id", a."first_name", a."last_name", f."film_id", f."title", r."rental_date" 
order by a."last_name" asc, a."first_name" asc, f."title" asc;


-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.

select *	
from "actor" as a
inner join "film_actor" as fa
	on fa.actor_id = a.actor_id
inner join "film" as f
	on f."film_id" = fa."film_id"
inner join "film_category" as fc
	on fc."film_id" = f."film_id"
inner join "category" as c
	on c."category_id" = fc."category_id"
where c."name" = 'Music'; 


select
	CONCAT(a."first_name", ' ', a."last_name") as nombre_actor
from "actor" as a
where a.actor_id not in (
	select distinct fa.actor_id
	from film_actor as fa 
    inner join film_category as fc 
    on fa.film_id = fc.film_id
    inner join category as c 
    on fc.category_id = c.category_id
	where c."name" = 'Music'
);


-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.


select DISTINCT 
    f."title" as pelicula
from "film" as f
inner join "inventory" as i 
	on f."film_id" = i."film_id"
inner join "rental" as r 
	on i."inventory_id" = r."inventory_id"
where r."return_date"::date - r."rental_date"::date > 8
order by f."title" asc;


-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.

select f."title"
from "film" as f
inner join "film_category" as fc 
	on f."film_id" = fc."film_id"
inner join "category" as c 
	on fc."category_id" = c."category_id"
where c."name" = 'Animation';


/* 59 Encuentra los nombres de las películas que tienen la misma duración
que la película con el título ‘Dancing Fever’. Ordena los resultados
alfabéticamente por título de película. */

select *
from film as f
order by f.title asc;



select f."title"
from "film" as f
where length = (
    select length 
    from "film" as ft
    where ft."title" ILIKE 'Dancing Fever'
)
and f."title" NOT ILIKE 'Dancing Fever'
order by f."title" asc;



/* 60. Encuentra los nombres de los clientes que han alquilado al menos 7
películas distintas. Ordena los resultados alfabéticamente por apellido. */


select 
	c.first_name, 
	c.last_name
from customer as c
inner join rental as r
	on r.customer_id = c.customer_id
inner join inventory as i
	on i.inventory_id = r.inventory_id;


select 
	--c."first_name" as nombres, 
	--c."last_name" as apellidos
	concat(c."last_name", '  ', c."first_name") as apellidos_nombres
from "customer" as c
inner join "rental" as r
	on r."customer_id" = c."customer_id"
inner join "inventory" as i
	on i."inventory_id" = r."inventory_id"
group by c."customer_id", c."first_name", c."last_name"
having COUNT(DISTINCT i."film_id") >= 7
order by c."last_name";


/* 61. Encuentra la cantidad total de películas alquiladas por categoría y
muestra el nombre de la categoría junto con el recuento de alquileres. */

select *
from category as c
inner join film_category as fc
	on fc.category_id = c.category_id
inner join inventory as i
	on i.film_id = fc.film_id
inner join rental as r
	on r.inventory_id = i.inventory_id; 


select 
	c."name" as categoria,
	COUNT(r."rental_id") as total_alquileres
from "category" as c
inner join "film_category" as fc
	on fc."category_id" = c."category_id"
inner join "inventory" as i
	on i."film_id" = fc."film_id"
inner join "rental" as r
	on r."inventory_id" = i."inventory_id"
group by c."category_id", c."name"
order by total_alquileres desc;


-- 62. Encuentra el número de películas por categoría estrenadas en 2006.

select
	c."name" as categoria
from category as c
inner join film_category as fc
	on fc.category_id = c.category_id
inner join film as f
	on f.film_id = fc.film_id
group by c.category_id, c."name";



select
	c."name" as categoria,
	COUNT(f."film_id") as total_peliculas_2006
from "category" as c
inner join "film_category" as fc
	on fc."category_id" = c."category_id"
inner join "film" as f
	on f."film_id" = fc."film_id"
group by c."category_id", c."name"
order by total_peliculas_2006 desc;


-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

select *
from staff;


select *
from staff as s
cross join store as st;


select
	concat(s."last_name", '  ', s."first_name") as trabajadores,
	st.store_id 
from staff as s
cross join store as st;


/* 64. Encuentra la cantidad total de películas alquiladas por cada cliente y
muestra el ID del cliente, su nombre y apellido junto con la cantidad de
películas alquiladas. */


select *
from customer as c
left join rental as r
	on r.customer_id = c.customer_id;


select
	c."customer_id" as id,
	concat(c."last_name", '  ', c."first_name") as clientes,
	COUNT(r."rental_id") as total_alquileres
from "customer" as c
left join "rental" as r
	on r."customer_id" = c."customer_id"
group by c."customer_id", c."first_name", c."last_name"
order by total_alquileres desc;


























