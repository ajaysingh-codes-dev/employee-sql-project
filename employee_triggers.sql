USE startersql;
SELECT * FROM users;

-- Detect duplicate emails using CTE + Window Function
WITH temp_table AS (
    SELECT id, name, email, created_at, ROW_NUMBER() OVER(PARTITION BY email ORDER BY created_at ASC) AS rnk FROM users
)
SELECT id, name, email, created_at,CASE WHEN rnk = 1 THEN "Original" ELSE 'Duplicate' END AS rnk  FROM temp_table;

-- Create log table to track employee actions
CREATE TABLE employees_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Add column to store action performed
ALTER TABLE employees_logs ADD COLUMN proposed VARCHAR(100);

--  Trigger: Log INSERT actions
DELIMITER &&
CREATE Trigger After_insert_employees
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
INSERT INTO employees_logs(emp_id, name, proposed)
VALUES(NEW.emp_id, NEW.name, 'new_employee_added');
END&&
DELIMITER ;
SELECT * FROM employees;
-- Insert sample employee (testing trigger)
INSERT INTO employees(name, gender, salary, age, dep_id, experience, join_date)
VALUES('Tony stark','Male',85000,32,1,9,'2023-01-11');
SELECT * FROM employees WHERE age = 32;
SELECT * FROM employees_logs;

-- Trigger: Log UPDATE actions with column-level tracking
DELIMITER &&
CREATE Trigger update_employees_logs
AFTER UPDATE on employees
FOR EACH ROW
BEGIN
IF OLD.salary <> NEW.salary THEN
INSERT INTO employees_logs(emp_id, name, proposed)
VALUES(NEW.emp_id, NEW.name, 'salary_update');
END IF;
IF OLD.age <> NEW.age THEN
INSERT INTO employees_logs(emp_id, name, proposed)
VALUES(NEW.emp_id, NEW.name, 'age_update');
END IF;
IF OLD.dep_id <> NEW.dep_id THEN
INSERT INTO employees_logs(emp_id, name, proposed)
VALUES(NEW.emp_id, NEW.name, 'dep_id_update');
END IF;
IF OLD.salary = NEW.salary AND OLD.age = NEW.age AND OLD.dep_id = NEW.dep_id THEN
INSERT INTO employees_logs(emp_id, name, proposed)
VALUES(NEW.emp_id, NEW.name, 'update');
END IF;
END&&
DELIMITER ;
UPDATE employees SET rnk_tier = 'Gold' WHERE name = 'Tony stark';
SELECT * FROM employees WHERE name = 'Tony stark';
SELECT * FROM employees_logs;

-- Trigger: Log DELETE actions
DELIMITER &&
CREATE Trigger Delete_employees_logs
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
INSERT INTO employees_logs(emp_id, name, proposed)
VALUES(OLD.emp_id, OLD.name, 'Delete');
END&&
DELIMITER ;
DELETE FROM employees WHERE name = 'Tony stark';
-- Final logs check
SELECT * FROM employees_logs;
