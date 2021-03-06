----- SET OPERATIONS -----

--- UNION / UNION ALL ---

--- Fairport şehrindeki müşteriler ile East Meadow şehrindeki müşterilerin soyisimlerini listeleyin

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

--- Veritabanımızda bulunan bütün isim soyisimleri listeleyin.
--- Sonuçta sadece ad ve soyad olmak üzere iki sütun olacak.
--- UNION ve UNION ALL sonuçlarını karşılaştırın.

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
-- Hangi marka bisikletlerin hem 2016 hem de 2017 modelleri bulunmaktadır?
-- brand_id ve brand_name değerlerini listeleyin

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

-- Hem 2016, hem 2017 hem de 2018 yıllarında sipariş veren müşterileri listeleyiniz.

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

-- 2016 model bisiklet markalarından hangilerinin 2017 model bisikleti yoktur?
-- brand_id ve brand_name değerlerini listeleyin

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

-- Sadece 2017 yılında satılan, diğer yıllarda satılmayan bisikletleri listeleyin.
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

-- Order status id lerinin açıklamalarını yazdırınız.
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
-- Personellerin çalıştıkları mağaza isimlerini simple case expression ile yazdırınız.
SELECT	*,
		CASE store_id
			WHEN 1 THEN 'Santa Cruz Bikes'
			WHEN 2 THEN 'Baldwin Bikes'
			WHEN 3 THEN 'Rowlett Bikes'
			ELSE 'Mağaza bilgisi yok'
		END Store_name
FROM	sales.staffs
;


------ Searched Case Expression -----
-- Order status id lerinin açıklamalarını yazdırınız.
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


-- Personellerin çalıştıkları mağaza isimlerini searched case expression ile yazdırınız.
SELECT	*,
		CASE
			WHEN store_id = 1 THEN 'Santa Cruz Bikes'
			WHEN store_id = 2 THEN 'Baldwin Bikes'
			WHEN store_id = 3 THEN 'Rowlett Bikes'
			ELSE 'Mağaza bilgisi yok'
		END Store_name
FROM	sales.staffs
;


-- Ürünlerin kargoya verilme hızını yazdıracağız.
-- Kargoya verilmeyen siparişler için 'Ürün kargoya verilmedi'
-- Sipariş günü kargoya verilen siparişler 'hızlı',
-- En geç 2 gün içinde kargoya verilenler 'normal'
-- 3 gün veya daha sonra kargoya verilenler 'yavaş'olacak şekilde yeni bir attribute oluşturun.
-- Bu case işlemini simple case ile yapabilir miyiz?
SELECT	*,	CASE
				WHEN order_status <> 4 THEN 'Ürün kargoya verilmedi'
				WHEN DATEDIFF(DAY, order_date, shipped_date) = 0 THEN 'hızlı'
				WHEN DATEDIFF(DAY, order_date, shipped_date) = 1 THEN 'normal'
				WHEN DATEDIFF(DAY, order_date, shipped_date) = 2 THEN 'yavaş'
				ELSE 'çok yavaş'
			END AS shipping_speed
FROM	sales.orders
ORDER BY shipped_date DESC;


-- Müşterilerin email servis sağlayıcılarını yeni bir alanda CASE ile yazdırın
SELECT	*, CASE
				WHEN email LIKE '%@gmail.%' THEN 'GMAIL'
				WHEN email LIKE '%@hotmail.%' THEN 'HOTMAIL'
				WHEN email LIKE '%@yahoo.%' THEN 'YAHOO'
				WHEN email IS NOT NULL THEN 'DİĞER'
			ELSE NULL END email_servis
FROM	sales.customers;


-- Aynı siparişte hem 'Electric Bikes' hem 'Comfort Bicycles' hem de 'Children Bicycles' alan müşterileri listeleyin.
-- Müşterinin Adı, soyadı, order_id ve order_date alanlarını listeleyin.
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