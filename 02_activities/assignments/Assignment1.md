/\* ASSIGNMENT 1 \*/

\--Please write responses between the QUERY # and END QUERY blocks

/\* SECTION 2 \*/





\--SELECT

/\* 1. Write a query that returns everything in the customer table. \*/

\--QUERY 1



SELECT \*

FROM customer;



\--END QUERY





/\* 2. Write a query that displays all of the columns and 10 rows from the customer table,

sorted by customer\_last\_name, then customer\_first\_name. \*/

\--QUERY 2



SELECT \*

FROM customer

ORDER BY customer\_last\_name, customer\_first\_name

LIMIT 10;



\--END QUERY





\--WHERE

/\* 1. Write a query that returns all customer purchases of product IDs 4 and 9.

Limit to 25 rows of output. \*/

\--QUERY 3



SELECT \*

FROM customer\_purchases

WHERE product\_id = 4

&#x20;  OR product\_id = 9

LIMIT 25;



\--END QUERY





/\* 2. Write a query that returns all customer purchases and a new calculated column 'price'

(quantity \* cost\_per\_quantity), filtered by customer IDs between 8 and 10 (inclusive). \*/

\--QUERY 4



SELECT \*,

&#x20;      quantity \* cost\_per\_quantity AS price

FROM customer\_purchases

WHERE customer\_id BETWEEN 8 AND 10

LIMIT 25;



\--END QUERY





\--CASE

/\* 1. Products can be sold by individual unit or bulk measures. \*/

\--QUERY 5



SELECT product\_id,

&#x20;      product\_name,

&#x20;      CASE

&#x20;          WHEN product\_qty\_type = 'unit' THEN 'unit'

&#x20;          ELSE 'bulk'

&#x20;      END AS prod\_qty\_type\_condensed

FROM product;



\--END QUERY





/\* 2. Add a pepper\_flag column. \*/

\--QUERY 6



SELECT product\_id,

&#x20;      product\_name,

&#x20;      CASE

&#x20;          WHEN product\_qty\_type = 'unit' THEN 'unit'

&#x20;          ELSE 'bulk'

&#x20;      END AS prod\_qty\_type\_condensed,

&#x20;      CASE

&#x20;          WHEN product\_name LIKE '%pepper%' THEN 1

&#x20;          ELSE 0

&#x20;      END AS pepper\_flag

FROM product;



\--END QUERY





\--JOIN

/\* 1. INNER JOIN vendor and vendor\_booth\_assignments. \*/

\--QUERY 7



SELECT \*

FROM vendor AS V

INNER JOIN vendor\_booth\_assignments AS vba

&#x20;   ON V.vendor\_id = vba.vendor\_id

ORDER BY market\_date, vendor\_name

LIMIT 24;



\--END QUERY





/\* SECTION 3 \*/



\--AGGREGATE

/\* 1. Count booth assignments for each vendor. \*/

\--QUERY 8



SELECT vendor\_id,

&#x20;      COUNT(\*) AS booth\_rental\_count

FROM vendor\_booth\_assignments

GROUP BY vendor\_id;



\--END QUERY





/\* 2. Customers who have spent more than $2000. \*/

\--QUERY 9



SELECT c.customer\_id,

&#x20;      c.customer\_first\_name,

&#x20;      c.customer\_last\_name,

&#x20;      SUM(cp.quantity \* cp.cost\_per\_quantity) AS total\_spent

FROM customer AS c

INNER JOIN customer\_purchases AS cp

&#x20;   ON c.customer\_id = cp.customer\_id

GROUP BY c.customer\_id,

&#x20;        c.customer\_first\_name,

&#x20;        c.customer\_last\_name

HAVING SUM(cp.quantity \* cp.cost\_per\_quantity) > 2000

ORDER BY c.customer\_last\_name,

&#x20;        c.customer\_first\_name;



\--END QUERY





\--Temp Table

/\* 1. Copy vendor into temp.new\_vendor and add vendor 10. \*/

\--QUERY 10



CREATE TEMP TABLE temp.new\_vendor AS

SELECT \*

FROM vendor;



INSERT INTO temp.new\_vendor

&#x20;   (vendor\_id,

&#x20;    vendor\_name,

&#x20;    vendor\_type,

&#x20;    vendor\_owner\_first\_name,

&#x20;    vendor\_owner\_last\_name)

VALUES

&#x20;   (10,

&#x20;    'Thomass Superfood Store',

&#x20;    'Fresh Focused',

&#x20;    'Thomas',

&#x20;    'Rosenthal');



\--END QUERY





\--Date

/\* 1. Get customer\_id, month, and year. \*/

\--QUERY 11



SELECT customer\_id,

&#x20;      strftime('%m', market\_date) AS month,

&#x20;      strftime('%Y', market\_date) AS year

FROM customer\_purchases

LIMIT 25;



\--END QUERY





/\* 2. Calculate spending for April 2022. \*/

\--QUERY 12



SELECT customer\_id,

&#x20;      SUM(quantity \* cost\_per\_quantity) AS total\_spent

FROM customer\_purchases

WHERE strftime('%m', market\_date) = '04'

&#x20; AND strftime('%Y', market\_date) = '2022'

GROUP BY customer\_id;



\--END QUERY

Before reading this article, I mostly thought of databases as tools for storing information. Qadri’s article made me realize that the way a database is designed can also reflect the values and assumptions of the people or organizations that create it. Healthcare is a good example, where I spend most of my working hours there. Electronic health records store a lot of patient information, but the system still depends on decisions about what categories and options are included. In healthcare, this also means that the information available to clinicians depends on how the system was designed. If important patient information does not fit into the available categories, it may be harder to document or may be overlooked. This made me think more about the responsibility of people who design health databases and electronic records. The system should not only be efficient, but should also be flexible enough to represent different patients and situations fairly. For example, patients may need to choose from fixed categories for family relationships, gender, ethnicity, or social situations. These options may work for many people, but they may not fully represent everyone. Clinical tools and risk scores also use selected information, so what is included or left out can affect how a patient is assessed. My main takeaway is that databases are not completely neutral. Even small design decisions can have important effects on how people are represented and how decisions are made. This is especially important in healthcare, where the way information is collected and organized can influence how clinicians understand patients and provide care.

