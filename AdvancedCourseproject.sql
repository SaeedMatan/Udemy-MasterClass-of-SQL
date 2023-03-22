-- 1
SELECT DISTINCT MIN(replacement_cost) 
FROM film

-- 2
WITH c1 AS (SELECT CASE
				WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
				WHEN replacement_cost BETWEEN 20 AND 24.99 THEN 'medium'
				WHEN replacement_cost BETWEEN 25 AND 29.99 THEN 'high'
			END AS overview
			FROM film
			)
SELECT overview, COUNT(*) FROM c1
WHERE overview = 'low'
GROUP BY overview

-- 3
WITH c2 AS (
			SELECT f.title, f.length, c.name AS "CategoryName"
			FROM film f
			INNER JOIN film_category fc ON fc.film_id = f.film_id
			INNER JOIN category c ON c.category_id = fc.category_id
			WHERE c.name = 'Drama' OR c.name = 'Sports'
			ORDER BY f.length DESC
			)
SELECT*FROM c2
WHERE length = (SELECT MAX(length) FROM c2)

-- 4
SELECT COUNT(fc.film_id), c.name
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY count

-- 5
SELECT a.first_name, a.last_name, COUNT(fa.film_id)
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name
ORDER BY COUNT(fa.film_id) DESC
LIMIT 1*/

-- 6
SELECT COUNT(address) FROM address
WHERE address_id NOT IN (
						SELECT address_id 
						FROM customer 
						)
						
-- 7
SELECT c.city, SUM(p.amount) 
FROM city c
INNER JOIN address a ON a.city_id = c.city_id
INNER JOIN customer cu ON cu.address_id = a.address_id
INNER JOIN payment p ON p.customer_id = cu.customer_id
GROUP BY c.city
ORDER BY 2 DESC

-- 8
SELECT country.country, c.city, SUM(p.amount) 
FROM city c
INNER JOIN country ON country.country_id = c.country_id
INNER JOIN address a ON a.city_id = c.city_id
INNER JOIN customer cu ON cu.address_id = a.address_id
INNER JOIN payment p ON p.customer_id = cu.customer_id
GROUP BY c.city, country.country
ORDER BY 3

-- 9
SELECT t1.staff_id, ROUND(AVG(t1.sum),2)
FROM(SELECT customer_id, staff_id, SUM(amount)
   	 FROM payment
	 GROUP BY staff_id, customer_id
	) t1
GROUP BY t1.staff_id

-- 10
SELECT AVG(t1.sum) FROM(
					 	SELECT EXTRACT(dow FROM payment_date), DATE(payment_date), SUM(amount) 
						FROM payment
						WHERE EXTRACT(dow FROM payment_date) = 0
						GROUP BY DATE(payment_date), EXTRACT(dow FROM payment_date)
						) t1

-- 11
SELECT title, length, replacement_cost 
FROM film f1
WHERE length > (SELECT AVG(length) 
				FROM film f2 
				WHERE f1.replacement_cost = f2.replacement_cost
			   )
ORDER BY length 

