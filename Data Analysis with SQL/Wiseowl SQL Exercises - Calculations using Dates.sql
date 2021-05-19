----- CALCULATIONS USING DATES -----
/*

First create a query showing events which took place in your year of birth, neatly formatted.

Amend your query so that it shows the event date neatly formatted:

Once using the FORMAT function; and
Once using the CONVERT function.

*/

SELECT EventName, EventDate, FORMAT(EventDate, 'dd/MM/yyyy') AS UsingFormat, CONVERT(varchar, EventDate, 103) AS UsingConvert
FROM tblEvent
WHERE YEAR(EventDate) = 1990
;

/*
Create a query to show the day of the week and also the day number on which each event occurred
*/

SELECT EventName, EventDate, DATENAME(WEEKDAY, EventDate) AS DayOfTheWeek, DAY(EventDate) AS DayNumber
FROM tblEvent
;

/*
The idea behind this exercise is to see what was happening in the world around the time when you were born (but you can use any reference date).  
First create a query to show the number of days which have elapsed for any event since your birthday.
*/

SELECT EventName, EventDate, ABS(DATEDIFF(day, 20/05/1990, EventDate)) AS 'Days Difference'
FROM tblEvent
;

/*
Create a query to show the full dates for any event
*/

SELECT EventName, CONCAT(DATENAME(WEEKDAY, EventDate),' ',
CASE
	WHEN DAY(EventDate) = 1 THEN CONCAT(DAY(EventDate),'st')
	WHEN DAY(EventDate) = 2 THEN CONCAT(DAY(EventDate),'nd')
	WHEN DAY(EventDate) = 3 THEN CONCAT(DAY(EventDate),'rd')
	ELSE CONCAT(DAY(EventDate),'th')
	END, ' ',
DATENAME(MONTH, EventDate),' ', YEAR(EventDate)) AS FullDate
FROM tblEvent
;
