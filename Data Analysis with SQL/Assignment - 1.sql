----- Assignment Solutions -----

--- 1. How to query the factorial of 6 recursively ?

WITH temp_table (factorial, step) AS (
	SELECT 1 factorial, 1 step
	UNION ALL
	SELECT factorial * (step + 1), step + 1
	FROM temp_table
	WHERE step < 6
)
SELECT *
FROM temp_table
;

--- 2. Cancellation rates

WITH users (user_id, action, date) AS
(
SELECT 1, 'Start', '1-1-2020'
UNION ALL
SELECT 1, 'Cancel', '1-2-2020'
UNION ALL
SELECT 2, 'Start', '1-3-2020'
UNION ALL
SELECT 2, 'Publish', '1-4-2020'
UNION ALL
SELECT 3, 'Start', '1-5-2020'
UNION ALL
SELECT 3, 'Cancel', '1-6-2020'
UNION ALL
SELECT 1, 'Start', '1-7-2020'
UNION ALL
SELECT 1, 'Publish', '1-8-2020'
),
Desired_Output AS (
SELECT user_id, 
sum(CASE WHEN action = 'Start' THEN 1.0 ELSE 0.0 END) AS starts, 
sum(CASE WHEN action = 'Cancel' THEN 1.0 ELSE 0.0 END) AS cancels, 
sum(CASE WHEN action = 'Publish' THEN 1.0 ELSE 0.0 END) AS publishes
FROM users
GROUP BY user_id
)
SELECT user_id, 1 * (publishes/starts) AS publish_rate, 1 * (cancels/starts) AS cancel_rate
FROM Desired_Output;