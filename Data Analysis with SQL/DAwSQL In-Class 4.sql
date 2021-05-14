----- SET OPERATIONS -----

--- UNION / UNION ALL ---

--- Fairport þehrindeki müþteriler ile East Meadow þehrindeki müþterilerin soyisimlerini listeleyin

SELECT last_name
FROM sales.customers
WHERE city = 'Fairport' 
UNION
SELECT last_name
FROM sales.customers
WHERE city = 'East Meadow'

SELECT last_name
FROM sales.customers
WHERE city = 'Fairport' 
UNION ALL
SELECT last_name
FROM sales.customers
WHERE city = 'East Meadow'
ORDER BY last_name

SELECT last_name
FROM sales.customers
WHERE city = 'East Meadow' OR city = 'Fairport'

--- Veritabanýmýzda bulunan bütün isim soyisimleri listeleyin.
--- Sonuçta sadece ad ve soyad olmak üzere iki sütun olacak.
--- UNION ve UNION ALL sonuçlarýný karþýlaþtýrýn.

SELECT first_name, last_name
FROM sales.customers
UNION
SELECT first_name, last_name
FROM sales.staffs

SELECT first_name, last_name
FROM sales.customers
UNION ALL
SELECT first_name, last_name
FROM sales.staffs

SELECT	*
FROM	production.brands
UNION
SELECT	*
FROM	production.categories
;

-- INTERSECT / EXCEPT
-- Hangi marka bisikletlerin hem 2016 hem de 2017 modelleri bulunmaktadýr?
-- brand_id ve brand_name deðerlerini listeleyin

SELECT *
FROM production.brands
WHERE brand_id IN
(
SELECT brand_id
FROM production.products
WHERE model_year = '2016'
INTERSECT
SELECT brand_id
FROM production.products
WHERE model_year = '2017'
)

-- Hem 2016, hem 2017 hem de 2018 yýllarýnda sipariþ veren müþterileri listeleyiniz.

SELECT customer_id, first_name, last_name
FROM sales.customers
WHERE customer_id IN
(
SELECT customer_id
FROM sales.orders
WHERE YEAR(order_date) = '2016'
INTERSECT
SELECT customer_id
FROM sales.orders
WHERE YEAR(order_date) = '2017'
INTERSECT
SELECT customer_id
FROM sales.orders
WHERE YEAR(order_date) = '2018'
)
;

-- 2016 model bisiklet markalarýndan hangilerinin 2017 model bisikleti yoktur?
-- brand_id ve brand_name deðerlerini listeleyin

SELECT	*
FROM	production.brands
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2016
					EXCEPT
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2017
					)
;

-- Sadece 2017 yýlýnda satýlan, diðer yýllarda satýlmayan bisikletleri listeleyin.
-- Bu kurala uyan bisiklet varsa product_id ve product_name bilgilerini listeleyin

SELECT	product_id, product_name
FROM	production.products
WHERE	product_id IN (
						SELECT	B.product_id
						FROM	sales.orders A, sales.order_items B
						WHERE	A.order_id = B.order_id AND
								YEAR(A.order_date) = 2017
						EXCEPT
						SELECT	B.product_id
						FROM	sales.orders A, sales.order_items B
						WHERE	A.order_id = B.order_id AND
								YEAR(A.order_date) <> 2017
						)
;

SELECT	B.product_id
FROM	sales.orders A, sales.order_items B
WHERE	A.order_id = B.order_id AND
		YEAR(A.order_date) = 2017
EXCEPT
SELECT	B.product_id
FROM	sales.orders A, sales.order_items B
WHERE	A.order_id = B.order_id AND
		(YEAR(A.order_date) < 2017 OR YEAR(A.order_date) > 2017)

------ CASE EXPRESSION ------

--- Simple Case Expression ---

-- Order status id lerinin açýklamalarýný yazdýrýnýz.
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
SELECT	*,
		CASE order_status
			WHEN 1 THEN 'Pending'
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			WHEN 4 THEN 'Completed'
		END Order_Status_Text
FROM	sales.orders
;

-- Query Time
-- Personellerin çalýþtýklarý maðaza isimlerini simple case expression ile yazdýrýnýz.
SELECT	*,
		CASE store_id
			WHEN 1 THEN 'Santa Cruz Bikes'
			WHEN 2 THEN 'Baldwin Bikes'
			WHEN 3 THEN 'Rowlett Bikes'
			ELSE 'Maðaza bilgisi yok'
		END Store_name
FROM	sales.staffs
;


------ Searched Case Expression -----
-- Order status id lerinin açýklamalarýný yazdýrýnýz.
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
SELECT	*, 
		CASE
			WHEN order_status = 1 THEN 'Pending'
			WHEN order_status = 2 THEN 'Processing'
			WHEN order_status = 3 THEN 'Rejected'
			WHEN order_status = 4 THEN 'Completed'
		END Order_Status_Text
FROM	sales.orders
;


-- Personellerin çalýþtýklarý maðaza isimlerini searched case expression ile yazdýrýnýz.
SELECT	*,
		CASE
			WHEN store_id = 1 THEN 'Santa Cruz Bikes'
			WHEN store_id = 2 THEN 'Baldwin Bikes'
			WHEN store_id = 3 THEN 'Rowlett Bikes'
			ELSE 'Maðaza bilgisi yok'
		END Store_name
FROM	sales.staffs
;


-- Ürünlerin kargoya verilme hýzýný yazdýracaðýz.
-- Kargoya verilmeyen sipariþler için 'Ürün kargoya verilmedi'
-- Sipariþ günü kargoya verilen sipariþler 'hýzlý',
-- En geç 2 gün içinde kargoya verilenler 'normal'
-- 3 gün veya daha sonra kargoya verilenler 'yavaþ'olacak þekilde yeni bir attribute oluþturun.
-- Bu case iþlemini simple case ile yapabilir miyiz?
SELECT	*,	CASE
				WHEN order_status <> 4 THEN 'Ürün kargoya verilmedi'
				WHEN DATEDIFF(DAY, order_date, shipped_date) = 0 THEN 'hýzlý'
				WHEN DATEDIFF(DAY, order_date, shipped_date) = 1 THEN 'normal'
				WHEN DATEDIFF(DAY, order_date, shipped_date) = 2 THEN 'yavaþ'
				ELSE 'çok yavaþ'
			END AS shipping_speed
FROM	sales.orders
ORDER BY shipped_date DESC;


-- Müþterilerin email servis saðlayýcýlarýný yeni bir alanda CASE ile yazdýrýn
SELECT	*, CASE
				WHEN email LIKE '%@gmail.%' THEN 'GMAIL'
				WHEN email LIKE '%@hotmail.%' THEN 'HOTMAIL'
				WHEN email LIKE '%@yahoo.%' THEN 'YAHOO'
				WHEN email IS NOT NULL THEN 'DÝÐER'
			ELSE NULL END email_servis
FROM	sales.customers;


-- Ayný sipariþte hem 'Electric Bikes' hem 'Comfort Bicycles' hem de 'Children Bicycles' alan müþterileri listeleyin.
-- Müþterinin Adý, soyadý, order_id ve order_date alanlarýný listeleyin.
SELECT	A.first_name, A.last_name, B.order_date
FROM	sales.customers A, sales.orders B
WHERE	A.customer_id = B.customer_id AND
		B.order_id IN	(
						SELECT	A.order_id
						FROM	sales.order_items A, production.products B
						WHERE	A.product_id = B.product_id AND
								B.category_id = (SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Electric Bikes')
						INTERSECT
						SELECT	A.order_id
						FROM	sales.order_items A, production.products B
						WHERE	A.product_id = B.product_id AND
								B.category_id = (SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Comfort Bicycles')
						INTERSECT
						SELECT	A.order_id
						FROM	sales.order_items A, production.products B
						WHERE	A.product_id = B.product_id AND
								B.category_id = (SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Children Bicycles')
						)