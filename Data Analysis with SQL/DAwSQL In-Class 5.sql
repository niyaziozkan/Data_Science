-- DATE and TIME DATA TYPES
-- Bikestores DB tablolarýnda yer alan date veya time sütunlarýný inceleyiniz.

SELECT *
FROM sales.orders
;

SELECT DISTINCT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
;

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE = 'date'
;

-- Herbir date and time data tiplerini içeren bir tablo create ediniz.
CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
);


-- Bu tabloya farklý deðerler giriniz.
-- Deðerleri girerken hem týrnak içinde giriniz hem de Construct Date and Time fonksiyonlarýný kullanýnýz.

INSERT INTO dbo.t_date_time (A_time) VALUES ('12:00:00');
INSERT INTO dbo.t_date_time (A_date) VALUES ('2021-05-17');
INSERT INTO dbo.t_date_time (A_time) VALUES (TIMEFROMPARTS(12,0,0,0,0));
INSERT INTO t_date_time (A_time) VALUES (TIMEFROMPARTS(20,00,00,0,0));
INSERT INTO t_date_time (A_date) VALUES (DATEFROMPARTS(2021,05,17));
INSERT INTO t_date_time (A_datetime) VALUES (DATETIMEFROMPARTS(2021,05,17, 20,0,0,0));
INSERT INTO t_date_time (A_datetimeoffset) VALUES (DATETIMEOFFSETFROMPARTS(2021,05,17, 20,0,0,0, 2,0,0));

SELECT * 
FROM dbo.t_date_time
;

-- Return Date or Time Parts fonksiyonlarýný kullanýnýz
-- DATENAME, DATEPART, DAY, MONTH, YEAR
-- Datepartlar nelerdir?
-- Yeni oluþturulan tablodaki tarih deðerlerinden yýl, ay, gün, saat, dakika, saniye deðerlerini getiriniz.

SELECT	A_date, DATENAME(D, A_date), DAY(A_date), DATEPART(QUARTER, A_date),
		DATENAME(MONTH, A_date)
FROM	dbo.t_date_time
;

SELECT	*,
		DATENAME(DW, order_date) hafta_gun_order_date,
		DATEDIFF(D, order_date, required_date) fark_gun,
		DATEDIFF_BIG(WEEK, order_date, required_date) fark_hafta
FROM	sales.orders;

-- DATEADD ve EOMONTH fonksiyonlarý
SELECT	*, 
		-- order_date + 3
		DATEADD(D, 3, order_date) order_date_3,
		-- required_date + 2 ay
		DATEADD(M, 1, required_date) required_date_1M,
		-- required_date - 1 hafta
		DATEADD(WEEK, -1, required_date) required_date_1Honce,
		-- order_date in month son tarih
		EOMONTH(order_date) order_date_last
FROM	sales.orders;


-- ISDATE() fonksiyonu
/* ISDATE() fonksiyonu bir metnin tarih veya saat formatýnda olup olmadýðýný 
kontrol etmek için kullanýlýr. Genellikle tarih tipine dönüþtürmek
istediðiniz bir metnin dönüþtürme iþlemi öncesinde bu iþleme uygun olup
olmadýðýný test etmek için kullanýlýyor. Dolayýsýyla bu fonksiyon sadece
text argumanlar ile çalýþmaktadýr. Zaten date ya da time veri tipinde bir
deðeri arguman olarak kullanýrsak mantýk hatasý yapmýþ oluruz ki
bu tip durumlarda zaten ISDATE() fonksiyonuna gerek yok. Yine de fonksiyonun
nasýl çalýþtýðýný merak ediyorsanýz test etmek istediðiniz deðeri metne
dönüþtürüp fonksiyonu kullanabilirsiniz. Þöyle ki:
*/
SELECT	*,
		ISDATE(CONVERT(nvarchar, order_date)) order_date_ISDATE,
		ISDATE(CONVERT(nvarchar, shipped_date)) shipped_date_ISDATE,
		ISDATE(CONVERT(nvarchar, store_id)) store_id_ISDATE
FROM	sales.orders
;

SELECT	ISDATE(GETDATE());
SELECT	ISDATE('2021-17-01');

-- System Date and Time functions
SELECT	GETDATE();
SELECT	CURRENT_TIMESTAMP;
SELECT	GETUTCDATE();