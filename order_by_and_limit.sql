-- 1. Get all employees sorted by salary (lowest to highest)
SELECT emp_id, name, gender, salary 
FROM employees 
ORDER BY salary ASC;

-- 2. Get all employees sorted by experience (highest to lowest)
SELECT emp_id, name, gender, experience 
FROM employees 
ORDER BY experience DESC;

-- 3. Get all employees sorted by age (youngest first)
SELECT emp_id, name, gender, age 
FROM employees 
ORDER BY age ASC;

-- 4. Sort employees by department, then by salary (highest first within each department)
SELECT emp_id, name, gender, dep_id, salary 
FROM employees 
ORDER BY dep_id ASC, salary DESC;

-- 5. Sort employees by gender (descending), then by age (youngest first)
SELECT * 
FROM employees 
ORDER BY gender DESC, age ASC;

-- 6. Sort employees by experience, then salary (both highest first)
SELECT emp_id, name, gender, experience, salary 
FROM employees 
ORDER BY experience DESC, salary DESC;

-- 7. Get top 5 highest paid employees
SELECT emp_id, name, gender, dep_id, salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 5;

-- 8. Get 3 least experienced employees
SELECT emp_id, name, gender, salary, dep_id, experience 
FROM employees 
ORDER BY experience ASC 
LIMIT 3;

-- 9. Get 2 youngest employees
SELECT emp_id, name, age, salary, dep_id 
FROM employees 
ORDER BY age ASC 
LIMIT 2;

-- 10. Get employees ranked 3rd to 6th by salary (highest first)
SELECT * 
FROM employees 
ORDER BY salary DESC 
LIMIT 2, 4;  -- skip first 2, then take next 4

-- 11. Get employees with department names, sorted by department then salary
SELECT e.emp_id, e.name, d.dep_name, e.salary 
FROM employees e 
JOIN departments d ON e.dep_id = d.dep_id
ORDER BY d.dep_name ASC, e.salary DESC;

-- 12. Get highest paid employee(s) from each department
SELECT e.emp_id, e.name, d.dep_name, e.salary 
FROM employees e 
JOIN departments d ON e.dep_id = d.dep_id
JOIN (
    SELECT dep_id, MAX(salary) AS max_salary 
    FROM employees 
    GROUP BY dep_id
) m ON e.dep_id = m.dep_id AND e.salary = m.max_salary;

-- 13. Sort employees by department location, then experience (highest first)
SELECT e.emp_id, e.name, e.salary, e.experience, d.dep_location 
FROM employees e 
JOIN departments d ON e.dep_id = d.dep_id
ORDER BY d.dep_location ASC, e.experience DESC;

-- 14. Get second highest salary employee (using OFFSET)
SELECT * 
FROM employees 
ORDER BY salary DESC 
LIMIT 1, 1;

-- 15. Get top 3 distinct salaries
SELECT DISTINCT salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 3;

-- 16. Get latest 5 joined employees
SELECT * 
FROM employees 
ORDER BY join_date DESC 
LIMIT 5;

-- 17. Get earliest 2 joined employees
SELECT * 
FROM employees 
ORDER BY join_date ASC 
LIMIT 2;

-- 18. Get any 5 employees
SELECT * 
FROM employees 
LIMIT 5;

-- Note:
-- Without ORDER BY, the result is not guaranteed to be consistent.
-- SQL may return different rows each time depending on execution.