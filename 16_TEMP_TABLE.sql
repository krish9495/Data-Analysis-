CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);
SELECT *
FROM temp_table;

INSERT INTO temp_table
VALUES ('Krish','jain','Uri');


# WAY 2
SELECT *
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50k
SELECT * 
FROM employee_salary
WHERE salary>50000;

select *
from salary_over_50k;
