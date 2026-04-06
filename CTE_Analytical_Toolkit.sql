-- 🔹 1. Department Salary Analysis with Ranking
WITH avg_salary AS (
    SELECT e.name, d.dep_name, e.salary, e.rnk_tier, AVG(e.salary) OVER (PARTITION BY d.dep_name) AS dep_avg,
    DENSE_RANK() OVER (PARTITION BY d.dep_name ORDER BY e.salary DESC) AS rnk
    FROM employees e JOIN departments d ON e.dep_id = d.dep_id
)
SELECT name, dep_name, salary, ROUND(dep_avg, 2) AS dep_avg,
ROUND(salary - dep_avg, 2) AS salary_diff, rnk, rnk_tier FROM avg_salary
WHERE rnk_tier = 'Gold';

-- 🔹 2. Most Experienced & Highest Paid Employee per Department
WITH most_exp AS (
    SELECT e.name, d.dep_name, e.experience, e.salary,
    MAX(e.experience) OVER (PARTITION BY d.dep_id) AS most_expe,
    MAX(e.salary) OVER(PARTITION BY e.dep_id) AS max_salary FROM employees e INNER JOIN
    departments d ON e.dep_id = d.dep_id
)
SELECT name, most_expe, dep_name, salary, max_salary, experience FROM most_exp;

-- 🔹 3. Hiring Order & Gap Between Employees
with hir_order AS (
    SELECT name, dep_id, join_date, LAG(name) OVER (PARTITION BY dep_id ORDER BY join_date) AS hring_order,
    DATEDIFF(join_date, LAG(join_date) OVER (PARTITION BY dep_id ORDER BY join_date)) AS join_order FROM employees
)
SELECT name, join_date, COALESCE(hring_order, 0) AS hring_order, COALESCE(join_order, 0) AS join_order FROM hir_order

-- 🔹 4. Running Salary & Monthly Rolling Salary (3-Month Window)
WITH running_salary AS(
    SELECT emp_id, name, join_date, salary, SUM(salary) OVER (ORDER BY join_date, emp_id ASC) AS running_salary FROM employees
),
month_salary AS (
    SELECT DATE_FORMAT(join_date, '%Y-%m') AS month, SUM(salary) AS total_salary
    FROM employees GROUP BY DATE_FORMAT(join_date, '%Y-%m')
),
month_running As (
    SELECT month, total_salary, SUM(total_salary) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS monthly_rolling
    FROM month_salary
)
SELECT * FROM month_running;


-- 🔹 5. Hiring Sprint Detection (Rapid Hiring Analysis)
WITH hire_gape AS (
    SELECT name, dep_id, join_date, LAG(join_date) OVER(PARTITION BY dep_id ORDER BY join_date) AS prev_hire_date,
    DATEDIFF(join_date, LAG(join_date) OVER (PARTITION BY dep_id ORDER BY join_date)) AS days_since_last_hire FROM employees
),
sprint_classification AS (
    SELECT name, dep_id, join_date, days_since_last_hire, CASE WHEN days_since_last_hire <= 7 THEN 'yes' ELSE 'no' END AS is_sprint
    FROM hire_gape
)
SELECT * FROM sprint_classification WHERE is_sprint = 'yes';

