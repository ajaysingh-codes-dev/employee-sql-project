-- =====================================
-- Employee & Department Analysis Project
-- =====================================

-- 1. Average salary per department
SELECT dep_id, AVG(salary) as avg_salary 
from employees GROUP BY dep_id;

-- 2. Total salary per department
SELECT dep_id, SUM(salary) AS total_salary
FROM employees GROUP BY dep_id;

-- 3. Maximum salary per department
SELECT dep_id, MAX(salary) AS max_salary 
FROM employees GROUP BY dep_id;

-- 4. Average salary per department (only salary > 30000)
SELECT dep_id, AVG( salary) AS avg_salary
FROM employees WHERE salary > 30000 GROUP BY dep_id;

-- 5. Employees count (age > 25) per department
SELECT dep_id, COUNT(name) AS employees_over_25
FROM employees WHERE age > 25 GROUP BY dep_id;

-- 6. Total salary of employees with experience > 2 years
SELECT dep_id, SUM(salary) AS total_salary
from employees WHERE experience > 2 GROUP BY dep_id;

-- 7. Departments with average salary > 40000
SELECT d.dep_name, AVG(e.salary) AS avg_salary FROM employees e
INNER JOIN departments d on e.dep_id = d.dep_id GROUP BY d.dep_name
HAVING AVG(e.salary) > 40000;

-- 8. Departments with more than 3 employees
SELECT d.dep_name, COUNT(name)  AS Total_employees FROM employees e
INNER JOIN departments d ON e.dep_id = d.dep_id GROUP BY d.dep_name
HAVING COUNT(name) > 3;

-- 9. Departments where minimum salary < 20000
SELECT d.dep_name, MIN(e.salary) AS minimum_salary
FROM employees e INNER JOIN
departments d ON e.dep_id = d.dep_id GROUP BY d.dep_name
HAVING MIN(e.salary) < 20000;

-- 10. Employee details with department name
SELECT e.name, d.dep_name, e.salary FROM employees e INNER JOIN
departments d ON e.dep_id = d.dep_id;

-- 11. Average salary per department (with department name)
SELECT d.dep_name, AVG(salary) AS avg_salary FROM employees e INNER JOIN
departments d ON e.dep_id = d.dep_id GROUP BY d.dep_name;

-- 12. Department with highest average salary
SELECT d.dep_name, AVG(e.salary) AS avg_salary
FROM employees e INNER JOIN
departments d ON e.dep_id = d.dep_id GROUP BY d.dep_name
ORDER BY avg_salary DESC LIMIT 1;

-- 13. Departments with average salary > 30000
SELECT d.dep_name, AVG(e.salary) AS avg_salary
FROM employees e INNER JOIN
departments d ON e.dep_id = d.dep_id GROUP BY d.dep_name
HAVING AVG(e.salary) > 30000;

-- 14. Departments with more than 2 employees
SELECT d.dep_name, COUNT(*) AS employees_count FROM employees e
INNER JOIN departments d ON
e.dep_id = d.dep_id GROUP BY d.dep_name
HAVING count(e.name) > 2;

-- 15. Highest paid employee in each department
SELECT d.dep_name, e.name, e.salary FROM employees e
INNER JOIN departments d ON e.dep_id = d.dep_id
JOIN (SELECT dep_id, MAX(salary) As HIGGEST_PAY FROM employees
GROUP BY dep_id) m ON e.dep_id = m.dep_id AND e.salary = m.HIGGEST_PAY;

-- 16. Employees earning more than their department average salary
SELECT d.dep_name, e.name, e.salary FROM employees e
INNER JOIN departments d ON e.dep_id = d.dep_id
JOIN (SELECT dep_id, AVG(salary) AS avg_salary FROM employees GROUP BY dep_id
) m ON e.dep_id = m.dep_id AND e.salary > m.avg_salary;

-- 17. 2nd highest salary in each department (Window Function)
SELECT dep_name, name, salary
FROM (
    SELECT 
        d.dep_name,
        e.name,
        e.salary,
        DENSE_RANK() OVER (
            PARTITION BY e.dep_id 
            ORDER BY e.salary DESC
        ) AS rnk
    FROM employees e
    INNER JOIN departments d ON e.dep_id = d.dep_id
) ranked
WHERE rnk = 2;

-- 18. Employees earning above department average (with avg shown)
SELECT e.name, d.dep_name, e.salary, m.avg_salary
FROM employees e JOIN departments d
ON e.dep_id = d.dep_id JOIN (SELECT dep_id, AVG(salary) AS avg_salary FROM employees GROUP BY
dep_id) m ON e.dep_id = m.dep_id AND e.salary > m.avg_salary;

-- 19. Highest salary employee per department (Window Function)
SELECT dep_name, name, salary FROM(
    SELECT d.dep_name, e.name, e.salary,
    DENSE_RANK() OVER (PARTITION BY e.dep_id ORDER BY e.salary DESC
    ) AS rnk FROM employees e INNER JOIN departments d ON e.dep_id = d.dep_id
) ranked WHERE rnk = 1;