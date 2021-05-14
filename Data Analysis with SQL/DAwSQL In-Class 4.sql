----- SET OPERATIONS -----

--- UNION / UNION ALL ---

--- Fairport �ehrindeki m��teriler ile East Meadow �ehrindeki m��terilerin soyisimlerini listeleyin

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

--- Veritaban�m�zda bulunan b�t�n isim soyisimleri listeleyin.
--- Sonu�ta sadece ad ve soyad olmak �zere iki s�tun olacak.
--- UNION ve UNION ALL sonu�lar�n� kar��la�t�r�n.

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
-- Hangi marka bisikletlerin hem 2016 hem de 2017 modelleri bulunmaktad�r?
-- brand_id ve brand_name de�erlerini listeleyin

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

-- Hem 2016, hem 2017 hem de 2018 y�llar�nda sipari� veren m��terileri listeleyiniz.

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

-- 2016 model bisiklet markalar�ndan hangilerinin 2017 model bisikleti yoktur?
-- brand_id ve brand_name de�erlerini listeleyin

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

-- Sadece 2017 y�l�nda sat�lan, di�er y�llarda sat�lmayan bisikletleri listeleyin.
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

-- Order status id lerinin a��klamalar�n� yazd�r�n�z.
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
-- Personellerin �al��t�klar� ma�aza isimlerini simple case expression ile yazd�r�n�z.
SELECT	*,
		CASE store_id
			WHEN 1 THEN 'Santa Cruz Bikes'
			WHEN 2 THEN 'Baldwin Bikes'
			WHEN 3 THEN 'Rowlett Bikes'
			ELSE 'Ma�aza bilgisi yok'
		END Store_name
FROM	sales.staffs
;


------ Searched Case Expression -----
-- Order status id lerinin a��klamalar�n� yazd�r�n�z.
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


-- Personellerin �al��t�klar� ma�aza isimlerini searched case expression ile yazd�r�n�z.
SELECT	*,
		CASE
			WHEN store_id = 1 THEN 'Santa Cruz Bikes'
			WHEN store_id = 2 THEN 'Baldwin Bikes'
			WHEN store_id = 3 THEN 'Rowlett Bikes'
			ELSE 'Ma�aza bilgisi yok'
		END Store_name
FROM	sales.staffs
;


-- �r�nlerin kargoya verilme h�z�n� yazd�raca��z.
-- Kargoya verilmeyen sipari�ler i�in '�r�n kargoya verilmedi'
-- Sipari� g�n� kargoya verilen sipari�ler 'h�zl�',
-- En ge� 2 g�n i�inde kargoya verilenler 'normal'
-- 3 g�n veya daha sonra kargoya verilenler 'yava�'olacak �ekilde yeni bir attribute olu�turun.
-- Bu case i�lemini simple case ile yapabilir miyiz?
SELECT	*,	CASE
				WHEN order_status <> 4 THEN '�r�n kargoya verilmedi'
				WHEN DATEDIFF(DAY, order_date, shipped_date) = 0 THEN 'h�zl�'
				WHEN DATEDIFF(DAY, order_date, shipped_date) = 1 THEN 'normal'
				WHEN DATEDIFF(DAY, order_date, shipped_date) = 2 THEN 'yava�'
				ELSE '�ok yava�'
			END AS shipping_speed
FROM	sales.orders
ORDER BY shipped_date DESC;


-- M��terilerin email servis sa�lay�c�lar�n� yeni bir alanda CASE ile yazd�r�n
SELECT	*, CASE
				WHEN email LIKE '%@gmail.%' THEN 'GMAIL'
				WHEN email LIKE '%@hotmail.%' THEN 'HOTMAIL'
				WHEN email LIKE '%@yahoo.%' THEN 'YAHOO'
				WHEN email IS NOT NULL THEN 'D��ER'
			ELSE NULL END email_servis
FROM	sales.customers;


-- Ayn� sipari�te hem 'Electric Bikes' hem 'Comfort Bicycles' hem de 'Children Bicycles' alan m��terileri listeleyin.
-- M��terinin Ad�, soyad�, order_id ve order_date alanlar�n� listeleyin.
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