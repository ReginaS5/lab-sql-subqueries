USE sakila;

-- Challenge
-- Write SQL queries to perform the following tasks using the Sakila database:

-- 1 Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(*) AS num_copies
FROM inventory
JOIN film ON inventory.film_id = film.film_id
WHERE film.title = 'Hunchback Impossible';

-- 2 List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 3 Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT actor.first_name, actor.last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = 'Alone Trip';

-- BONUS
-- 4 Sales have been lagging among young families, and you want to target family movies for a promotion.
-- Identify all movies categorized as family films.
SELECT film.title
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

-- 5 Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins,
--  you will need to identify the relevant tables and their primary and foreign keys.
-- Subquery Approach:
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id IN (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

-- Join Approach
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- 6 Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is 
-- defined as the actor who has acted in the most number of films. First, you will need to find the most
--  prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT actor.actor_id, CONCAT(actor.first_name, '', actor.last_name) AS actor_name, 
COUNT(film_actor.film_id) AS film_count
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id
ORDER BY film_count DESC
LIMIT 1;

SELECT film.title
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = 7;

-- 7 Find the films rented by the most profitable customer in the Sakila database. You can use the customer 
-- and payment tables to find the most profitable customer,i.e., the customer who has made the largest sum of 
-- payments.
SELECT film.title
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN customer ON rental.customer_id = customer.customer_id
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY film.title
ORDER BY SUM(payment.amount) DESC
LIMIT 3;

-- 8 Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of
-- the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT customer_id, total_amount_spent
FROM (
    SELECT c.customer_id, SUM(p.amount) AS total_amount_spent
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
) AS customer_total
WHERE total_amount_spent > (
    SELECT AVG(total_amount_spent)
    FROM (
        SELECT SUM(amount) AS total_amount_spent
        FROM payment
        GROUP BY customer_id
    ) AS avg_totals
);

