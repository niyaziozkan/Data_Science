
------ INNER JOIN ------

-- Ürünleri kategori isimleri ile birlikte listeleyin
-- Ürün IDsi, ürün adý, kategori IDsi ve kategori adlarýný seçin

SELECT	A.product_id, A.product_name, A.category_id, B.category_name
FROM	production.products A
INNER JOIN	production.categories B
	ON	A.category_id = B.category_id
;

-- alternatif yazým

SELECT	A.product_id, A.product_name, A.category_id, B.category_name
FROM	production.products A,
		production. categories B
WHERE	A.category_id = B.category_id
;

-- Maðaza çalýþanlarýný çalýþtýklarý maðaza bilgileriyle birlikte listeleyin
-- Çalýþan adý, soyadý, maðaza adlarýný seçin

SELECT	A.first_name, A.last_name, B.store_name
FROM	sales.staffs A
INNER JOIN sales.stores B
	ON	A.store_id = B.store_id
;


------ LEFT JOIN ------

-- Inner join ile yaptýðýnýz sorguyu LEFT JOIN ile yapýn

SELECT	A.product_id, A.product_name, A.category_id, B.category_name
FROM	production.products A
LEFT JOIN	production.categories B
	ON	A.category_id = B.category_id
;

/* Products tablosuna yeni bir ürün eklendiðini
fakat kategori ID alanýnýn boþ olduðunu varsayalým.
Bu durumda sorgu sonucunda nasýl bir deðiþiklik olurdu?
INNER JOIN ve LEFT JOIN i bu bakýmdan karþýlaþtýrýn*/

-- Ürün bilgilerini stok miktarlarý ile birlikte listeleyin
--		Stokta bulunmayan ürünlerin bilgileri de gelsin istiyoruz
--		ProductID si 310 dan büyük olan ürünleri getirin
--		ProductID, ProductName ve stok bilgilerini seçin
-- Bu sorguyu INNER JOIN ile yapsaydýnýz nasýl bir farklýlýk olurdu?

SELECT	A.product_id, A.product_name, B.*
FROM	production.products A
LEFT JOIN production.stocks B
	ON	A.product_id = B.product_id
WHERE	A.product_id > 310
;


------ RIGHT JOIN ------

-- Stok miktarlarý ile ilgili LEFT JOIN ile yaptýðýnýz sorguyu RIGHT JOIN ile yapýn
-- Her iki sorgu sonucunun da ayný olmasýný saðlayýn (satýr sayýsý, sütun sýralamasý vs.)

SELECT	B.product_id, B.product_name, A.*
FROM	production.stocks A
RIGHT JOIN production.products B
	ON	A.product_id = B.product_id
WHERE	B.product_id > 310
;

-- Maðaza çalýþanlarýný yaptýklarý satýþlar ile birlikte listeleyin
--		Hiç satýþ yapmayan çalýþan varsa onlarýn da gelmesini istiyoruz.
--		Staff ID, Staff adý, soyadý ve sipariþ bilgilerini seçin
--		Sonucu daha iyi analiz edebilmek için sorguyu Staff ID alanýna göre sýralayýn.

SELECT	A.staff_id, A.first_name, A.last_name, B.*
FROM	sales.staffs A
LEFT JOIN sales.orders B
	ON	A.staff_id = B.staff_id
ORDER BY A.staff_id
;


------ FULL OUTER JOIN ------

-- Ürünlerin stok miktarlarý ve sipariþ bilgilerini birlikte listeleyin
-- production.stocks ve sales.order_items tablolarýný kullanýn
-- Sorgu sonucunda bütün sütunlarýn gelmesini saðlayýn
-- Çýkan sonucu daha kolay yorumlamak için product_id ve order_id alanlarýna göre sýralayýn 

SELECT	*
FROM	production.stocks A
FULL OUTER JOIN	sales.order_items B
	ON	A.product_id = B.product_id
ORDER BY A.product_id, B.order_id
;


------ CROSS JOIN ------

-- Hangi markada hangi kategoride kaçar ürün olduðu bilgisine ihtiyaç duyuluyor
-- Ürün sayýsý hesaplamadan sadece marka * kategori ihtimallerinin hepsini içeren bir tablo oluþturun.
-- Çýkan sonucu daha kolay yorumlamak için brand_id ve category_id alanlarýna göre sýralayýn 

SELECT	*
FROM	production.brands A
CROSS JOIN production.categories B
ORDER BY A.brand_id, B.category_id
;

-- Bazý ürünlerin stok bilgileri stocks tablosunda yok.
-- Bu ürünlerin herbir maðazada 0 adet olacak þekilde stocks tablosuna basýlmasý isteniyor.
-- Bunu nasýl yaparsýnýz?
-- Örneðin product_id = 314 olan ürünün stok bilgilerini kontrol edebilirsiniz
-- Sadece stock tablosuna basýlacak listeyi oluþturun, INSERT etmeyin

SELECT	B.store_id, A.product_id, 0 quantity
FROM	production.products A
CROSS JOIN sales.stores B
WHERE	A.product_id NOT IN (SELECT product_id FROM production.stocks)
ORDER BY A.product_id, B.store_id
;


------ SELF JOIN ------
-- Personelleri ve þeflerini listeleyin
-- Çalýþan adý ve yönetici adý bilgilerini getirin

SELECT	A.first_name, B.first_name manager_name
FROM	sales.staffs A
JOIN	sales.staffs B
	ON	A.manager_id = B.staff_id
ORDER BY B.first_name
;

-- alternatif yazým

SELECT	A.first_name, B.first_name manager_name
FROM	sales.staffs A, sales.staffs B
WHERE	A.manager_id = B.staff_id
ORDER BY B.first_name
;

-- Bir önceki sorgu sonucunda gelen þeflerin yanýna onlarýn da þeflerini getiriniz
-- Çalýþan adý, þef adý, þefin þefinin adý bilgilerini getirin

SELECT	A.first_name,
		B.first_name manager1_name,
		C.first_name manager2_name
FROM	sales.staffs A
JOIN	sales.staffs B
	ON	A.manager_id = B.staff_id
JOIN	sales.staffs C
	ON	B.manager_id = C.staff_id
ORDER BY C.first_name, B.first_name
;


-- 1. Soru
-- Bir liste oluþturun ve bu listede ürün adý, model yýlý, fiyatý, kategorisi ve markasý bulunsun.
-- Toplam satýr sayýsý 321 olmalý

SELECT	A.product_name, A.model_year, A.list_price,
		B.category_name, C.brand_name
FROM	production.products A, production.categories B, production.brands C
WHERE	A.category_id = B.category_id AND
		A.brand_id = C.brand_id
;


-- 2. Soru
-- Bu liste oluþturun ve bu listede çalýþan adý soyadý, sipariþ tarihi, müþteri adý soyadý bulunsun.
-- Bu listede tüm çalýþanlarýn olmasýný saðlayýn fakat müþterilerden sadece sipariþ verenler bulunsun.
-- Toplam satýr sayýsý 1.619 olmalý

SELECT	A.first_name staff_fname, A.last_name staff_lname,
		B.order_date,
		C.first_name customer_fname, C.last_name customer_lname
FROM	sales.staffs A
LEFT JOIN	sales.orders B
ON		A.staff_id = B.staff_id
LEFT JOIN	sales.customers C
ON		B.customer_id = C.customer_id
;