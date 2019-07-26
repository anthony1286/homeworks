-- SQL Homework


USE sakila;


-- 1a. Display the first and last names of all actors from the table `actor`.
SELECT 			a.first_name,
						a.last_name

FROM 			actor a;


-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT 			UPPER(CONCAT(a.first_name, " ", a.last_name)) "Actor Name"

FROM 			actor a;


-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
-- What is one query would you use to obtain this information?
SELECT 			a.actor_id,
						a.first_name,
						a.last_name
                    
FROM 			actor a

WHERE 			a.first_name = "JOE";


-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT 			a.first_name,
						a.last_name
                    
FROM 			actor a

WHERE 			a.last_name LIKE "%GEN%";


-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT 			a.first_name,
						a.last_name
                    
FROM 			actor a

WHERE 			a.last_name LIKE "%LI%"

ORDER BY 	a.last_name, a.first_name;


-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT 			c.country_id,
						c.country
                    
FROM 			country c

WHERE 			c.country IN ("Afghanistan", "Bangladesh", "China");


-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description,
-- so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type
-- `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor
ADD COLUMN description BLOB;


-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor
DROP COLUMN description;


-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT 			a.last_name,
						COUNT(a.actor_id)
                    
FROM 			actor a

GROUP BY 	a.last_name

ORDER BY 	2 desc;


-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT 			a.last_name,
						COUNT(a.actor_id)
                    
FROM 			actor a

GROUP BY 	a.last_name

HAVING 			COUNT(DISTINCT a.actor_id) >= 2

ORDER BY 	2 desc;


-- Need to run this line in order to complete the next commands
SET SQL_SAFE_UPDATES = 0;

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE 		actor
SET					first_name = "HARPO"
WHERE 			first_name = "GROUCHO" AND last_name = "WILLIAMS";


-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name
-- after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE 		actor
SET 				first_name = "GROUCHO"
WHERE 			first_name = "HARPO";


-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;


-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT 			s.first_name,
						s.last_name,
						a.address
                    
FROM 			staff s
JOIN 				address a ON a.address_id = s.address_id;


-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT 			s.first_name,
						s.last_name,
						SUM(p.amount)
                    
FROM 			staff s
JOIN 				payment p ON p.staff_id = s.staff_id AND MONTH(p.payment_date) = 8 AND YEAR(p.payment_date) = 2005

GROUP BY  	s.staff_id;


-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT 			f.title,
						COUNT(DISTINCT fa.actor_id)
                    
FROM 			film f
JOIN 				film_actor fa ON fa.film_id = f.film_id

GROUP BY 	f.title;


-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT 			COUNT(i.inventory_id)

FROM 			inventory i
JOIN 				film f ON f.film_id = i.film_id

WHERE 			f.title = "Hunchback Impossible";


-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT 			c.first_name,
						c.last_name,
						sum(p.amount)
                    
FROM 			customer c
JOIN 				payment p ON p.customer_id = c.customer_id

GROUP BY 	c.customer_id

ORDER BY 	c.last_name;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence,
-- films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies
--  starting with the letters `K` and `Q` whose language is English.
SELECT 			f.title

FROM 			film f
JOIN 				language l ON l.language_id = f.language_id

WHERE 			(f.title LIKE 'Q%' OR f.title LIKE 'K%' )
						AND l.name = "English";


-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT 	actor.first_name,
				actor.last_name
 FROM actor
 WHERE actor.actor_id IN
 (
  SELECT film_actor.actor_id
  FROM film_actor
  WHERE film_actor.film_id IN
  (
   SELECT rental_id
   FROM rental
   WHERE inventory_id IN
   (
    SELECT film.film_id
    FROM film
    WHERE film.title = 'Alone Trip'
    )
  )
 ) ;


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers.
--  Use joins to retrieve this information.
SELECT 			c.first_name,
						c.last_name,
						a.address
                        
FROM 			customer c
JOIN 				address a ON a.address_id = c.address_id
JOIN 				city ON city.city_id = a.city_id
JOIN 				country co ON co.country_id = city.country_id AND co.country = "Canada";


-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT 			film.title

FROM 			film
JOIN 				film_category fc ON fc.film_id = film.film_id
JOIN 				category cat ON cat.category_id = fc.category_id AND cat.name = "Family";


-- 7e. Display the most frequently rented movies in descending order.
SELECT 			film.title,
						COUNT(r.rental_id) times_rented
                        
FROM 			film
JOIN 				inventory i ON i.film_id = film.film_id
JOIN 				rental r ON r.inventory_id = i.inventory_id

GROUP BY 	film.title

ORDER BY 	2 desc;


-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT 			store.store_id,
						SUM(p.amount) total_sales
                        
FROM 			store
JOIN 				inventory i ON i.store_id = store.store_id
JOIN 				rental r ON r.inventory_id = i.inventory_id
JOIN 				payment p ON p.rental_id = r.rental_id

GROUP BY 	1;


-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT 			store.store_id,
						city.city,
                        country.country
                        
FROM 			store
JOIN 				address ON address.address_id = store.address_id
JOIN 				city ON city.city_id = address.city_id
JOIN 				country ON country.country_id = city.country_id;
                        

-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT  		cat.name genre,
						SUM(p.amount) gross_revenue
                        
FROM 			category cat
JOIN 				film_category fc ON fc.category_id = cat.category_id
JOIN 				inventory i ON i.film_id = fc.film_id
JOIN 				rental r ON r.inventory_id = i.inventory_id
JOIN 				payment p ON p.rental_id = r.rental_id

GROUP BY 	cat.name

ORDER BY 	2 desc;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
--   Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres AS
SELECT  		cat.name genre,
						SUM(p.amount) gross_revenue
                        
FROM 			category cat
JOIN 				film_category fc ON fc.category_id = cat.category_id
JOIN 				inventory i ON i.film_id = fc.film_id
JOIN 				rental r ON r.inventory_id = i.inventory_id
JOIN 				payment p ON p.rental_id = r.rental_id

GROUP BY 	cat.name

ORDER BY 	2 desc

LIMIT 				5;


-- 8b. How would you display the view that you created in 8a?
SELECT 			*

FROM 			sakila.top_five_genres;


-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW sakila.top_five_genres;
