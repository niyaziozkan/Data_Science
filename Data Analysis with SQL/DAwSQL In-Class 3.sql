----- ADVANCED GROUPING OPERATIONS -----

--- HAVING ---

--- Check whether any product id in the products table is multiplexed

SELECT COUNT(product_id)
FROM production.products
GROUP BY product_id
HAVING COUNT(product_id) > 1
;

--- Which category ids have maximum list price bigger than 4000 or minimum list price lower than 500

SELECT category_id
FROM production.products
GROUP BY category_id
HAVING MAX(list_price) > 4000 OR MIN(list_price) < 500
;

--- Find the brands average list prices

SELECT B.brand_name, AVG(A.list_price) avg_list_price
FROM production.products A, production.brands B
WHERE A.brand_id = B.brand_id 
GROUP BY B.brand_name
ORDER BY AVG(A.list_price) DESC
;

--- Find the brands average list prices bigger than 1000

SELECT B.brand_name, AVG(A.list_price) avg_list_price
FROM production.products A, production.brands B
WHERE A.brand_id = B.brand_id 
GROUP BY B.brand_name
HAVING AVG(A.list_price) > 1000
ORDER BY AVG(A.list_price) DESC
;

--- Find the brands average list prices bigger than 1000 (Without HAVING) ---

WITH temp_table (brand_name, avg_list_price) AS
(
SELECT B.brand_name, AVG(A.list_price) avg_list_price
FROM production.products A, production.brands B
WHERE A.brand_id = B.brand_id 
GROUP BY B.brand_name
)
SELECT brand_name, avg_list_price
FROM temp_table
WHERE avg_list_price > 1000
ORDER BY avg_list_price DESC
;

--- Find an orders net price (don't forget the discount!) ---

SELECT order_id, SUM(quantity * list_price * (1-discount)) net_price
FROM sales.order_items
GROUP BY order_id
;


----- GROUPING SETS -----

--- Create a summary table that contains brand, category, model year and net_price 

SELECT b.brand_name AS brand, c.category_name AS category, p.model_year,
ROUND (SUM (quantity * i.list_price * (1 - discount)) , 0 ) sales
INTO sales.sales_summary 
FROM sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year

SELECT *
FROM sales.sales_summary
ORDER BY 1,2,3

--- 1. Find total sales amount

SELECT SUM(sales)
FROM sales.sales_summary

--- 2. Find brands total sales amount

SELECT brand, SUM(sales)
FROM sales.sales_summary
GROUP BY brand

--- 3. Find categories total sales amount

SELECT category, SUM(sales)
FROM sales.sales_summary
GROUP BY category

--- 4. Find brand and categories total sales amount

SELECT brand, category, SUM(sales)
FROM sales.sales_summary
GROUP BY brand, category

--- GROUPING SETS ---

SELECT brand, category, SUM(sales)
FROM sales.sales_summary
GROUP BY 
	GROUPING SETS (
		(brand, category),
		(brand),
		()
	)
ORDER BY brand, category

--- CUBE ---

SELECT brand, category, SUM(sales)
FROM sales.sales_summary
GROUP BY
		CUBE (brand, category)
ORDER BY 
	brand, category

--- ROLLUP ---

SELECT brand, category, model_year, SUM(sales)
FROM sales.sales_summary
GROUP BY
		CUBE (brand, category, model_year)
ORDER BY 
	brand, category

--- PIVOT ---

SELECT category, SUM(sales)
FROM sales.sales_summary
GROUP BY category

SELECT *
FROM
(
	SELECT category , sales
	FROM SALES.sales_summary
) A
PIVOT
(
	SUM(sales)
	FOR category IN
	(
	[Children Bicycles], 
    [Comfort Bicycles], 
    [Cruisers Bicycles], 
    [Cyclocross Bicycles], 
    [Electric Bikes], 
    [Mountain Bikes], 
    [Road Bikes])
	) AS PIVOT_TABLE