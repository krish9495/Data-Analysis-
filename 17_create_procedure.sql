
CREATE PROCEDURE large_salaries()
SELECT * 
FROM employee_salary
WHERE salary >=50000;

#AFTER USING THIS ABOVE QUESRY ONE FILE CREATED IN STORED PROCEDURES NAMED large_salaries

CALL large_salaries();

#NOW IF WE WANT TO USE 2 OR MORE QUERY AND INSERT THERE DATA IN PROCEDURE THEN

CREATE PROCEDURE large_salaries2()
SELECT * 
FROM employee_salary
WHERE salary >=50000;
SELECT *
FROM employee_salary
where salary>10000;
#HERE IT WILL TAKE ONE QUERY TILL SALARY>=50000; AND PUT IT IN LARGE SALARIES2 AND THEN TAKE SECOND QUERY AND SHOW HIS OUTPUT TO PREVENT THIS WE CAN USE DILIMITTER


DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
    -- Retrieve all employees with salaries >= 50000
    SELECT * 
    FROM employee_salary
    WHERE salary >= 50000;

    -- Retrieve all employees with salaries > 10000
    SELECT *
    FROM employee_salary
    WHERE salary > 10000;
END $$
DELIMITER ;

CALL large_salaries2();