/* ASSIGNMENT 1 */
--Please write responses between the QUERY # and END QUERY blocks
/* SECTION 2 */


--SELECT
/* 1. Write a query that returns everything in the customer table. */
--QUERY 1

SELECT *
FROM customer;

--END QUERY


/* 2. Write a query that displays all of the columns and 10 rows from the customer table,
sorted by customer_last_name, then customer_first_name. */
--QUERY 2

SELECT *
FROM customer
ORDER BY customer_last_name, customer_first_name
LIMIT 10;

--END QUERY


--WHERE
/* 1. Write a query that returns all customer purchases of product IDs 4 and 9.
Limit to 25 rows of output. */
--QUERY 3

SELECT *
FROM customer_purchases
WHERE product_id = 4
   OR product_id = 9
LIMIT 25;

--END QUERY


/* 2. Write a query that returns all customer purchases and a new calculated column 'price'
(quantity * cost_per_quantity), filtered by customer IDs between 8 and 10 (inclusive). */
--QUERY 4

SELECT *,
       quantity * cost_per_quantity AS price
FROM customer_purchases
WHERE customer_id BETWEEN 8 AND 10
LIMIT 25;

--END QUERY


--CASE
/* 1. Products can be sold by individual unit or bulk measures. */
--QUERY 5

SELECT product_id,
       product_name,
       CASE
           WHEN product_qty_type = 'unit' THEN 'unit'
           ELSE 'bulk'
       END AS prod_qty_type_condensed
FROM product;

--END QUERY


/* 2. Add a pepper_flag column. */
--QUERY 6

SELECT product_id,
       product_name,
       CASE
           WHEN product_qty_type = 'unit' THEN 'unit'
           ELSE 'bulk'
       END AS prod_qty_type_condensed,
       CASE
           WHEN product_name LIKE '%pepper%' THEN 1
           ELSE 0
       END AS pepper_flag
FROM product;

--END QUERY


--JOIN
/* 1. INNER JOIN vendor and vendor_booth_assignments. */
--QUERY 7

SELECT *
FROM vendor AS V
INNER JOIN vendor_booth_assignments AS vba
    ON V.vendor_id = vba.vendor_id
ORDER BY market_date, vendor_name
LIMIT 24;

--END QUERY


/* SECTION 3 */

--AGGREGATE
/* 1. Count booth assignments for each vendor. */
--QUERY 8

SELECT vendor_id,
       COUNT(*) AS booth_rental_count
FROM vendor_booth_assignments
GROUP BY vendor_id;

--END QUERY


/* 2. Customers who have spent more than $2000. */
--QUERY 9

SELECT c.customer_id,
       c.customer_first_name,
       c.customer_last_name,
       SUM(cp.quantity * cp.cost_per_quantity) AS total_spent
FROM customer AS c
INNER JOIN customer_purchases AS cp
    ON c.customer_id = cp.customer_id
GROUP BY c.customer_id,
         c.customer_first_name,
         c.customer_last_name
HAVING SUM(cp.quantity * cp.cost_per_quantity) > 2000
ORDER BY c.customer_last_name,
         c.customer_first_name;

--END QUERY


--Temp Table
/* 1. Copy vendor into temp.new_vendor and add vendor 10. */
--QUERY 10

CREATE TEMP TABLE temp.new_vendor AS
SELECT *
FROM vendor;

INSERT INTO temp.new_vendor
    (vendor_id,
     vendor_name,
     vendor_type,
     vendor_owner_first_name,
     vendor_owner_last_name)
VALUES
    (10,
     'Thomass Superfood Store',
     'Fresh Focused',
     'Thomas',
     'Rosenthal');

--END QUERY


--Date
/* 1. Get customer_id, month, and year. */
--QUERY 11

SELECT customer_id,
       strftime('%m', market_date) AS month,
       strftime('%Y', market_date) AS year
FROM customer_purchases
LIMIT 25;

--END QUERY


/* 2. Calculate spending for April 2022. */
--QUERY 12

SELECT customer_id,
       SUM(quantity * cost_per_quantity) AS total_spent
FROM customer_purchases
WHERE strftime('%m', market_date) = '04'
  AND strftime('%Y', market_date) = '2022'
GROUP BY customer_id;

--END QUERY