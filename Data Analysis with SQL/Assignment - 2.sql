----- QUESTION 1 ANSWER -----

WITH transactions (sender, receiver, amount, transaction_date) AS (
SELECT 5,2,10,'2-12-20'
UNION ALL
SELECT 1,3,15,'2-13-20'
UNION ALL
SELECT 2,1,20,'2-13-20'
UNION ALL
SELECT 2,3,25,'2-14-20'
UNION ALL
SELECT 3,1,20,'2-15-20'
UNION ALL
SELECT 3,2,15,'2-15-20'
UNION ALL
SELECT 1,4,5,'2-16-20'
),
debits_table (user_id, debits) AS (
SELECT sender, sum(amount)
FROM transactions
GROUP BY sender
),
credits_table (user_id, credits) AS (
SELECT receiver, sum(amount)
FROM transactions
GROUP BY receiver
),
join_table (debits_userid, debits, credits_userid, credits) AS (
SELECT A.user_id, 
COALESCE(A.debits, 0), 
B.user_id, 
COALESCE(B.credits, 0)
FROM debits_table AS A
FULL OUTER JOIN credits_table AS B
ON A.user_id = B.user_id
),
desired_table (user_, net_change) AS (
SELECT debits_userid, credits - debits
FROM join_table
WHERE debits_userid IS NOT NULL
UNION
SELECT credits_userid, credits - debits
FROM join_table
WHERE credits_userid IS NOT NULL
)
SELECT *
FROM desired_table
ORDER BY net_change DESC
;


----- QUESTION 2 ANSWER -----

WITH attendance (student_id, school_date, attendance) AS (
SELECT 1, '4-3-20', 0
UNION ALL
SELECT 2, '4-3-20', 1
UNION ALL
SELECT 3, '4-3-20', 1
UNION ALL
SELECT 1, '4-4-20', 1
UNION ALL
SELECT 2, '4-4-20', 1
UNION ALL
SELECT 3, '4-4-20', 1
UNION ALL
SELECT 1, '4-5-20', 0
UNION ALL
SELECT 2, '4-5-20', 1
UNION ALL
SELECT 3, '4-5-20', 1
UNION ALL
SELECT 4, '4-5-20', 1
),
students (student_id, school_id, grade_level, date_of_birth) AS (
SELECT 1,2,5, '4-3-12'
UNION ALL
SELECT 2,1,4, '4-4-13'
UNION ALL
SELECT 3,1,3, '4-5-14'
UNION ALL
SELECT 4,2,4, '4-3-13'
)
SELECT CAST(1.0*SUM(attendance)/COUNT(*) AS NUMERIC (3,2)) AS Birthday_attendance
FROM attendance A, students B
WHERE  A.student_id = B.student_id 
AND MONTH (A.school_date) = MONTH (B.date_of_birth)
AND DAY (A.school_date) = DAY (B.date_of_birth)
;