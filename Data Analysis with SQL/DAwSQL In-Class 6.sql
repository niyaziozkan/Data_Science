


--DAwSQL Session-6

--MS SQL SERVER STRING FUNCTIONS


--LEN


SELECT LEN (123456789)

SELECT LEN ( 123456789)


SELECT LEN ('WELCOME')

SELECT LEN (' WELCOME')

SELECT LEN ('"WELCOME"')


--CHARINDEX

SELECT CHARINDEX('C', 'CHARACTER' )


SELECT CHARINDEX('C', 'CHARACTER', 2 )


SELECT CHARINDEX('CT', 'CHARACTER' )


SELECT CHARINDEX('ct', 'CHARACTER' )


--PATINDEX

SELECT PATINDEX('%R', 'CHARACTER')

SELECT PATINDEX('%R%', 'CHARACTER')


SELECT PATINDEX('%A____', 'CHARACTER')

--


--LEFT

SELECT LEFT ('CHARACTER', 3)

SELECT LEFT (' CHARACTER', 3)


--RIGHT

SELECT RIGHT ('CHARACTER', 3)

SELECT RIGHT ('CHARACTER ', 3)


--SUBSTRING

SELECT SUBSTRING ('CHARACTER', 3, 5)


SELECT SUBSTRING('123456789', 3, 5)


SELECT SUBSTRING ('CHARACTER', 0 , 3)


SELECT SUBSTRING ('CHARACTER', -1 , 3)



---LOWER

SELECT LOWER ('CHARACTER')

--UPPER

SELECT UPPER ('character')


SELECT UPPER (LEFT('character',1)) + LOWER (RIGHT ('CHARACTER', LEN('CHARACTER')-1 ))



--STRING_SPLIT


SELECT value
FROM STRING_SPLIT ('ALÝ/VELÝ/AHMET','/')

--

SELECT value
FROM STRING_SPLIT ('ALÝ//VELÝ//AHMET','/')


---TRIM

SELECT TRIM('  CHARACTER   ')

SELECT TRIM('  CHARACT ER   ')



SELECT LTRIM('  CHARACT ER   ')

SELECT RTRIM('  CHARACT ER   ')


---REPLACE

SELECT REPLACE ('CHARACTER', 'RAC', '')

SELECT REPLACE ('CHARACTER', 'RAC', '/')


--CHARACTER STRING
SELECT REPLACE('CHARACTER STRING', ' ', '')


--STR

SELECT STR (1234567890)


SELECT STR (1234.00, 6, 2)


SELECT STR (1234.00, 6)

SELECT STR (1234.00, 7, 2)


SELECT STR (1234.123, 8, 2)


----

--CAST

SELECT CAST (123456 AS CHAR)

SELECT CAST (123456 AS CHAR(7))+ 'ALÝ'



SELECT GETDATE()

SELECT CAST (GETDATE() AS DATE)


--CONVERT

SELECT CONVERT(INT , 30.60)

SELECT CONVERT(FLOAT , 30.61)

SELECT CONVERT(FLOAT , 30.61)


SELECT CONVERT(VARCHAR(10), '2020-10-12')


--COALESCE

SELECT COALESCE (NULL, NULL, 'ALÝ', 'VELÝ', NULL)


--NULLIF


SELECT NULLIF ('AHMET', 'AHMET')


SELECT NULLIF ('AHMET', 'VELÝ')




SELECT COUNT ( first_name )
FROM
sales.customers



SELECT COUNT (NULLIF (first_name, 'Debra'))
FROM
sales.customers


------

--Examples

----customer tablosunda kaç tane yahoo maili vardýr?

SELECT count (*)
FROM
sales.customers
WHERE
email LIKE '%yahoo%'


SELECT email
FROM
sales.customers
WHERE
email LIKE '%yahoo%'


----email sütununun deðerlerinde bulunan nokta karakterinden önceki ifadeleri getiriniz.

--SUBSTRING / LEFT
--CHARINDEX


SELECT email
FROM
sales.customers


SELECT email, SUBSTRING(email, 0, CHARINDEX('.',email))
FROM sales.customers
;


select email, left(email,PATINDEX('%.%',email)-1) from sales.customers
;

SELECT LEFT(email, CHARINDEX ('.', email)-1)
FROM
sales.customers
;


--SELECT email, RIGHT(email, CHARINDEX ('.', email))
--FROM
--sales.customers

--///////////////


--her müþteriye ulaþabileceðim telefon veya email bilgisini istiyorum.
--Müþterinin telefon bilgisi varsa email bilgisine gerek yok.
--telefon bilgisi yoksa email adresi iletiþim bilgisi olarak gelsin.
--beklenen sütunlar: customer_id, first_name, last_name, contact

--COALESCE


SELECT TOP 5*
FROM
sales.customers


SELECT customer_id, first_name, last_name, phone, email,
CASE WHEN phone IS NULL THEN email ELSE phone
END AS contact
FROM sales.customers;



SELECT customer_id, first_name, last_name, COALESCE(phone,email) contact, phone, email
FROM
sales.customers
;


--//////////////////

--@ iþareti ile mail sütununu ikiye ayýrýn. Örneðin
--ronna.butler@gmail.com	/ ronna.butler	/ gmail.com


--SUBSTRING / LEFT / RIGHT

SELECT email
FROM
sales.customers



SELECT email, 
		LEFT(email, CHARINDEX('@',email)-1) [left], 
		RIGHT(email, LEN(email) - CHARINDEX('@',email)) [right]
FROM sales.customers


SELECT email,
		SUBSTRING(email, 1, CHARINDEX('@', email)-1) As First_part,
		RIGHT (email,LEN(email)-CHARINDEX('@', email)) As Second_part
FROM [sales].[customers]


SELECT email, 
		SUBSTRING(email, 0, CHARINDEX('@',email)) AS 'name', 
		REPLACE(SUBSTRING(email, CHARINDEX('@',email), len(email)), '@', '') AS 'domain'
FROM sales.customers;


SELECT SUBSTRING(email, CHARINDEX('@',email), len(email)) AS 'domain'
FROM sales.customers;



--

SELECT email,
		SUBSTRING (email, 1 , CHARINDEX('@', email)-1),

		SUBSTRING (email, CHARINDEX('@', email)+1, LEN(email))
FROM
	sales.customers


---

--//////////

-------------- DÖRDÜNCÜ KARAKTERÝ NUMERICAL OLAN SOKAK ÝSÝMLERÝNÝ GETÝRÝNÝZ


select street, LEFT (street, 1)
from
sales.customers


--STRING ÝFADEYE NUMERICAL ÞART VEREMÝYORUZ

SELECT street, LEFT(street,1)
FROM sales.customers
WHERE CAST (SUBSTRING(street,3,1) AS INT) >= 0


-------------

SELECT street, SUBSTRING(street,3,1)
FROM sales.customers
WHERE SUBSTRING(street,3,1) LIKE  '[0-9]'



SELECT street, SUBSTRING(street,3,1)
FROM sales.customers
WHERE SUBSTRING(street,3,1) not  LIKE  '[^0-9]'


SELECT street, SUBSTRING(street,3,1)
FROM sales.customers
WHERE ISNUMERIC (SUBSTRING(street,3,1)) = 0



---//////////////

--street sütununda baþtaki rakamsal ifadenin sonuna yanlýþlýkla eklenmiþ string karakterleri temizleyiniz.
--Yani; 769C veya 747B ifadelerinin sonundaki harfleri temizleyiniz.



SELECT street, REPLACE (street, target_chars,numerical_chars)
FROM	(
			SELECT	street,
					LEFT (street, CHARINDEX(' ', street)-1) AS target_chars,
		
					RIGHT (LEFT (street, CHARINDEX(' ', street)-1), 1) AS string_chars,

					LEFT (street, CHARINDEX(' ', street)-2) AS numerical_chars

			FROM	sales.customers
			WHERE	ISNUMERIC (RIGHT (LEFT (street, CHARINDEX(' ', street)-1), 1)) = 0
		) A

