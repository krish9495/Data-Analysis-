#CTE(COMMON TABLE EXPRESSION)

WITH CTE_EXAMPLE AS                                            # cte starts with (WITH)
(SELECT gender , AVG(salary) avg_sal, MAX(salary) max_sal,MIN(salary) min_sal ,COUNT(salary) cnt_sal 
FROM employee_demographics dem
JOIN employee_salary sal
	on dem.employee_id=sal.employee_id
group by gender)

select AVG(avg_sal) from
CTE_EXAMPLE;


#now the same thing using sub queries

-- SELECT AVG(avg_sal) FROM
-- (SELECT gender , AVG(salary) avg_sal, MAX(salary) max_sal,MIN(salary) min_sal ,COUNT(salary) cnt_sal 
-- FROM employee_demographics dem
-- JOIN employee_salary sal
-- 	on dem.employee_id=sal.employee_id
-- group by gender) example_subquery

#CTE LOOKS MORE SIMPLE AND EASY THAN SUB QUERY


#we can have multiple cte also 
WITH CTE_example as 
(
select employee_id,gender,birth_date
from employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_example2 as 
(
select employee_id,salary 
from employee_salary
where salary >50000
)
select * from CTE_example
join CTE_example2 
ON CTE_example.employee_id=CTE_example2.employee_id;