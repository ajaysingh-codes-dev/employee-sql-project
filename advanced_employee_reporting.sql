/* =============================================================================
FILE NAME: employee_analytics_suite.sql
AUTHOR: Ajay Singh
DESCRIPTION: Advanced SQL scripts for data integrity, performance 
             tiering, and departmental budget analysis.
CONCEPTS: Window Functions, CTEs, Joins, and Constraints.
=============================================================================
*/
-- 1. IDENTIFY TOP EARNER PER DEPARTMENT
-- Uses ROW_NUMBER with a Window Function to find the single highest salary in each team.
SELECT dep_name, name, salary FROM(
    SELECT d.dep_name, e.name, e.salary, ROW_NUMBER() OVER (PARTITION BY e.dep_id ORDER BY e.salary DESC) AS rnk 
    FROM employees e INNER JOIN departments d ON e.dep_id = d.dep_id
) ranked WHERE rnk = 1;

-- 2. UNDERPAID ANALYSIS
-- Identifies employees earning less than their specific department's average.
SELECT e.emp_id, d.dep_name, e.name, e.salary, m.avg_salary FROM employees e LEFT
JOIN departments d ON e.dep_id = d.dep_id
JOIN (SELECT dep_id, ROUND(AVG(salary),2) AS avg_salary FROM employees GROUP BY dep_id )
m ON e.dep_id = m.dep_id AND e.salary < m.avg_salary;

-- 3. DEPARTMENTAL BUDGET OVERVIEW
-- Summarizes headcounts and budgets. Uses IFNULL to handle empty departments.
SELECT 
    d.dep_name, 
    COUNT(e.emp_id) AS total_employees, 
    ROUND(IFNULL(AVG(e.salary), 0), 2) AS average_salary,
    SUM(IFNULL(e.salary, 0)) AS total_budget
FROM departments d
LEFT JOIN employees e ON d.dep_id = e.dep_id
GROUP BY d.dep_id, d.dep_name;

-- 4. VETERAN VS. EXPERIENCE AUDIT
-- Finds "Loyal but Junior" staff (At company 2+ years but low industry experience).
SELECT 
    name, 
    join_date, 
    experience,
    TIMESTAMPDIFF(YEAR, join_date, CURDATE()) AS years_at_company
FROM employees
WHERE TIMESTAMPDIFF(YEAR, join_date, CURDATE()) >= 2
  AND experience < 3;

-- 5. RANKING SYSTEM (TIERING)
-- Categorizes employees into Bronze, Silver, and Gold based on years of experience.
SELECT name,experience, CASE WHEN experience < 3 THEN 'Bronze'
WHEN experience BETWEEN 3 AND 5 THEN 'Silver'
ELSE 'Gold' END AS rnk_tier
FROM employees;

-- 6. SCHEMA UPDATE: PERSISTENT TIERING
-- Adds a physical column and populates it with the tier logic.
ALTER TABLE employees ADD COLUMN rnk_tier VARCHAR(100);
UPDATE employees SET rnk_tier = CASE WHEN experience < 3 THEN 'Bronze'
WHEN experience BETWEEN 3 AND 5 THEN 'Silver'
ELSE 'Gold' END;
SELECT emp_id, name, experience, rnk_tier FROM employees;
SELECT * FROM employees WHERE rnk_tier = 'Silver';

-- 7. DATA QUALITY AUDITS (ERROR HUNTING)
-- Checks for negative salaries and duplicate names.
SELECT salary FROM employees WHERE salary < 0;

-- 8. ORPHAN RECORDS CHECK
-- Finds employees not assigned to any department.

-- 9. DATA INTEGRITY (SAFETY NETS)
-- Prevents bad data (negative salaries or impossible ages) at the database level.
ALTER Table employees ADD CONSTRAINT check_salary CHECK (salary >= 0);
ALTER TABLE employees ADD CONSTRaINT check_age CHECK (age < 100);
SELECT name, COUNT(*) AS Duplicates FROM employees GROUP BY name HAVING COUNT(*) > 1;
SELECT name, join_date FROM employees WHERE dep_id IS NULL;

-- 10. GLOBAL SALARY LEADERBOARD
-- Ranks all employees across the entire company using DENSE_RANK.
SELECT name, salary, DENSE_RANK() OVER(ORDER BY salary DESC) AS salary_rank FROM employees;

-- 11. FINANCIAL FILTER (HIGH-EXPENSE DEPARTMENTS)
-- Filters departments that exceed a 500,000 budget.
SELECT d.dep_name, SUM(IFNULL(e.salary, 0)) AS Total_Salary_Budget
FROM employees e INNER JOIN departments d ON e.dep_id = d.dep_id
GROUP BY dep_name HAVING SUM(IFNULL(e.salary, 0)) > 500000;

-- 12. RECRUITMENT SEASONALITY TRENDS
-- Formats dates to find which months see the most hiring activity.
SELECT DATE_FORMAT(join_date, '%M') AS month_name, count(*) AS employees_count FROM
employees GROUP BY month_name ORDER BY employees_count;

-- 13. NTH HIGHEST SALARY PER DEPARTMENT (SUBQUERY + PARTITION)
-- Finds exactly the 2nd highest earner in every department.
-- This is a high-level technical interview solution.
SELECT dep_name, name, salary FROM
(SELECT d.dep_name, e.name, e.salary, DENSE_RANK() OVER (PARTITION BY e.dep_id ORDER BY e.salary DESC) AS rnk 
FROM employees e JOIN departments d ON d.dep_id = e.dep_id) t WHERE rnk = 2;