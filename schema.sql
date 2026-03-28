CREATE DATABASE IF NOT EXISTS project001;
USE project001;

-- Departments table
CREATE TABLE departments(
    dep_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    dep_name VARCHAR(100) NOT NULL,
    dep_location VARCHAR(100) NOT NULL
);

-- Employees table
CREATE TABLE employees(
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    gender ENUM('Male','Female','Other'),
    salary INT,
    age INT,
    dep_id INT,
    experience INT,
    join_date DATE NOT NULL,
    Foreign Key (dep_id) REFERENCES departments(dep_id) ON DELETE SET NULL
);