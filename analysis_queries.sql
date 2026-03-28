-- File: 01_basic_employee_queries.sql

-- This file covers:
-- SELECT, WHERE, AND, OR, BETWEEN, IN, NULL handling

--------------------------------------------------
USE project001;

-- 1. View all employees
SELECT * FROM employees;

-- 2. Employees with salary > 50000
SELECT * FROM employees WHERE salary > 50000;

-- 3. Employees with salary > 40000 AND experience > 5
SELECT * FROM employees WHERE salary > 40000 AND experience > 5;

-- 4. Employees in IT or HR department
SELECT * FROM employees WHERE dep_name = 'IT' or dep_name = 'HR';

-- 5. Employees with salary between 40000 and 70000
SELECT * FROM employees WHERE salary BETWEEN 40000 AND 70000;

-- 6. Employees in specific departments
SELECT * FROM employees WHERE dep_id IN (2, 5);

-- 7. Employees with missing department info
SELECT * FROM employees WHERE dep_id IS NULL OR dep_name IS NULL;

-- 8. Employees with known experience
SELECT * FROM employees WHERE experience IS NOT NULL;

-- 9. Combined filtering example
SELECT * FROM employees WHERE salary BETWEEN 40000 AND 80000 AND dep_id IN (1, 2)
AND dep_name IS NOT NULL;

-- 10. Age, salary, and department filter
SELECT * FROM employees WHERE age BETWEEN 25 AND 35 AND salary > 45000
AND dep_id IN (3, 4) AND experience IS NOT NULL;

-- 11. Advanced condition with OR + AND
SELECT * FROM employees WHERE salary > 50000 AND (dep_id = 1 or dep_id = 3)
AND dep_name IS NOT NULL AND experience > 3;