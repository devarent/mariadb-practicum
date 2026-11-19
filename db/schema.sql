-- MariaDB practicum: HRIS schema.
-- ASCII only. No real credentials.
CREATE DATABASE IF NOT EXISTS hris
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE hris;

DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS salary_history;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS positions;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  location VARCHAR(100) NOT NULL DEFAULT 'unknown',
  budget DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE positions (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  min_salary DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  max_salary DECIMAL(12,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB;

CREATE TABLE employees (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(60) NOT NULL,
  last_name VARCHAR(60) NOT NULL,
  email VARCHAR(160) NOT NULL,
  department_id INT UNSIGNED NULL,
  position_id INT UNSIGNED NULL,
  hire_date DATE NOT NULL,
  salary DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  status ENUM('active','on_leave','terminated') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_employees_email UNIQUE (email),
  CONSTRAINT fk_employees_department FOREIGN KEY (department_id)
    REFERENCES departments(id) ON DELETE SET NULL,
  CONSTRAINT fk_employees_position FOREIGN KEY (position_id)
    REFERENCES positions(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE salary_history (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  employee_id INT UNSIGNED NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  effective_date DATE NOT NULL,
  note VARCHAR(255) NULL,
  CONSTRAINT fk_salary_employee FOREIGN KEY (employee_id)
    REFERENCES employees(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE audit_log (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  table_name VARCHAR(60) NOT NULL,
  operation VARCHAR(16) NOT NULL,
  record_id INT UNSIGNED NOT NULL,
  changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  details VARCHAR(255) NULL
) ENGINE=InnoDB;

-- Indexes for the lab queries.
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_employees_status ON employees(status);
CREATE INDEX idx_salary_employee_date ON salary_history(employee_id, effective_date);
CREATE INDEX idx_audit_table_op ON audit_log(table_name, operation);
