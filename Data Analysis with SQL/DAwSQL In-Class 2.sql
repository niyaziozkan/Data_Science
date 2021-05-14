----- SINGLE ROW SUBQUERIES -----

-- Kali	Vargas'�n �al��t��� ma�azadaki t�m personelleri listeleyin.

SELECT *
FROM sales.staffs
WHERE store_id =
	(SELECT store_id
	FROM sales.staffs
	WHERE first_name ='Kali' AND last_name = 'Vargas')
;


-- Venita Daniel'�n y�neticisi oldu�u personelleri listeleyin.

SELECT *
FROM sales.staffs
WHERE manager_id =
	(SELECT staff_id
	FROM sales.staffs
	WHERE first_name ='Venita' AND last_name = 'Daniel')
;

-- 'Rowlett Bikes' isimli ma�azan�n bulundu�u �ehirdeki m��terileri listeleyin.

SELECT first_name, last_name
FROM sales.customers
WHERE city =
	(SELECT city
	FROM sales.stores
	WHERE store_name = 'Rowlett Bikes')
;

-- 'Trek CrossRip+ - 2018' isimli bisikletten pahal� olan bisikletleri listeleyin.
-- Product id, product name, model_year, fiyat, marka ad� ve kategori ad� alanlar�na ihtiya� duyulmaktad�r.

SELECT *
FROM production.products
WHERE list_price <
(
	SELECT list_price
	FROM production.products
	WHERE product_name = 'Trek CrossRip+ - 2018')
;

-- Arla Ellis isimli m��teriden daha �nceki tarihlerde sipari� veren m��terileri listeleyin.
-- M��teri ad�, soyad� ve sipari� tarihi bilgilerini listeleyin.

SELECT A.first_name, A.last_name, B.order_date
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id AND B.order_date <
	(SELECT B.order_date
	FROM sales.customers A, sales.orders B
	WHERE A.first_name = 'Arla' AND A.last_name = 'Ellis' AND A.customer_id = B.customer_id)
;


----- MULTIPLE ROW SUBQUERIES -----

-- Holbrook �ehrinde oturan m��terilerin sipari� tarihlerini listeleyin.

SELECT order_date
FROM sales.orders
WHERE customer_id IN
	(SELECT customer_id
	FROM sales.customers
	WHERE city = 'Holbrook')
;

-- Kasha Todd isimli m��terinin al��veri� yapt��� tarihte/tarihlerde al��veri� yapan t�m m��terileri listeleyin.
-- M��teri ad�, soyad� ve sipari� tarihi bilgilerini listeleyin.

SELECT A.first_name, A.last_name, B.order_date
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id AND B.order_date IN
	(SELECT B.order_date
	FROM sales.customers A, sales.orders B
	WHERE A.first_name = 'Kasha' AND A.last_name = 'Todd' AND A.customer_id = B.customer_id)
;

-- Cruisers Bicycles, Mountain Bikes veya Road Bikes haricindeki kategorilere ait �r�nleri listeleyin.
--	Sadece 2016 model y�l�na ait bisikletlerin ad� ve fiyat bilgilerini listeleyin.

SELECT product_name, list_price
FROM production.products
WHERE model_year = '2016' AND category_id IN
(
SELECT category_id
FROM production.categories
WHERE category_name NOT IN ('Cruisers Bicycles', 'Mountain Bikes', 'Road Bikes'))
;

-- B�t�n elektrikli bisikletlerden pahal� olan bisikletleri listelyin.
-- �r�n ad�, model_y�l� ve fiyat bilgilerini y�ksek fiyattan d���k fiyata do�ru s�ralay�n�z.

SELECT product_name, model_year, list_price
FROM production.products
WHERE list_price > (
	SELECT MAX(A.list_price )
	FROM production.products A, production.categories B
	WHERE A.category_id = B.category_id AND B.category_name = 'Electric Bikes')
ORDER BY list_price DESC
;

SELECT product_name, model_year, list_price
FROM production.products
WHERE list_price > ALL (
	SELECT A.list_price
	FROM production.products A, production.categories B
	WHERE A.category_id = B.category_id AND B.category_name = 'Electric Bikes')
ORDER BY list_price DESC
;

-- Herhangi bir elektrikli bisikletten pahal� olan bisikletleri listelyin.
-- �r�n ad�, model_y�l� ve fiyat bilgilerini y�ksek fiyattan d���k fiyata do�ru s�ralay�n�z.

SELECT product_name, model_year, list_price
FROM production.products
WHERE list_price > (
	SELECT MIN(A.list_price )
	FROM production.products A, production.categories B
	WHERE A.category_id = B.category_id AND B.category_name = 'Electric Bikes')
ORDER BY list_price DESC
;

SELECT product_name, model_year, list_price
FROM production.products
WHERE list_price > ANY (
	SELECT A.list_price
	FROM production.products A, production.categories B
	WHERE A.category_id = B.category_id AND B.category_name = 'Electric Bikes')
ORDER BY list_price DESC
;

-- Sharyn Hopkins isimli m��terinin ilk sipari�inden �nce sipari� veren m��terileri listeleyin.
-- M��teri ad�, soyad� ve sipari� tarihi bilgilerini listeleyin.

SELECT B.first_name, B.last_name, A.order_date
FROM sales.orders A, sales.customers B
WHERE A.customer_id = B.customer_id AND A.order_date < ALL (
	SELECT A.order_date
	FROM sales.orders A, sales.customers B
	WHERE A.customer_id = B.customer_id AND B.first_name = 'Sharyn' AND B.last_name = 'Hopkins')
;

-- Sharyn Hopkins isimli m��terinin son sipari�inden �nce sipari� veren m��terileri listeleyin.
-- M��teri ad�, soyad� ve sipari� tarihi bilgilerini listeleyin.

SELECT B.first_name, B.last_name, A.order_date
FROM sales.orders A, sales.customers B
WHERE A.customer_id = B.customer_id AND A.order_date < ANY (
	SELECT A.order_date
	FROM sales.orders A, sales.customers B
	WHERE A.customer_id = B.customer_id AND B.first_name = 'Sharyn' AND B.last_name = 'Hopkins')
;


----- VIEWS -----

-- Sadece stokta bulunan �r�nleri g�steren bir view olu�turun ve birka� sorgu i�inde kullan�n.
-- �r�n ad�, markas�, kategorisi, model_y�l�, liste fiyat�

CREATE VIEW stock_bikes AS
	SELECT A.product_name, B.brand_name, C.category_name, A.model_year, A.list_price
	FROM production.products A, production.brands B, production.categories C
	WHERE A.brand_id = B.brand_id AND A.category_id = C.category_id AND A.product_id IN (
		SELECT product_id
		FROM production.stocks
		WHERE quantity > 0)
;

SELECT *
FROM stock_bikes
WHERE model_year = '2016'
;

-- Sipari� detaylar� ile ilgili bir view olu�turun ve birka� sorgu i�inde kullan�n.
-- M��teri ad� soyad�, order_date, product_name, model_year, quantity, list_price, final_price (indirimli fiyat) 

CREATE VIEW production.order_details AS
	SELECT A.first_name, A.last_name, B.order_date, C.product_name, C.model_year, D.quantity, D.list_price, D.list_price * (1 - D.discount) final_price
	FROM sales.customers A, sales.orders B, production.products C, sales.order_items D
	WHERE A.customer_id = B.customer_id AND C.product_id = D.product_id AND B.order_id = D.order_id
;

SELECT *
FROM production.order_details
WHERE final_price < 500
;


----- WITH -----

-- VIEW konusunun ilk �rne�ini WITH clause ile olu�turup Strider markal� bisikletleri listeleyin. (Ordinary CTE)

WITH temp_table AS (
	SELECT A.product_name, B.brand_name, C.category_name, A.model_year, A.list_price
	FROM production.products A, production.brands B, production.categories C
	WHERE A.brand_id = B.brand_id AND A.category_id = C.category_id AND A.product_id IN (
		SELECT product_id
		FROM production.stocks
		WHERE quantity > 0))
SELECT *
FROM temp_table
WHERE brand_name = 'Strider'
;

-- 0'dan 9'a kadar herbir rakam bir sat�rda olacak �ekide bir tablo olu�turun.

WITH temp_table (rakam) AS 
(
	SELECT 0 rakam
	UNION ALL
	SELECT rakam + 1
	FROM temp_table
	WHERE rakam < 9
)
SELECT *
FROM temp_table
;