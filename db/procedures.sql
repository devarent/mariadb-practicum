-- Stored procedures. Loaded after schema.sql and seed.sql.
USE hris;

DROP PROCEDURE IF EXISTS sp_hire_employee;
DELIMITER //
CREATE PROCEDURE sp_hire_employee(
  IN p_first VARCHAR(60),
  IN p_last VARCHAR(60),
  IN p_email VARCHAR(160),
  IN p_dept INT UNSIGNED,
  IN p_pos INT UNSIGNED,
  IN p_salary DECIMAL(12,2)
)
BEGIN
  INSERT INTO employees
    (first_name, last_name, email, department_id, position_id, hire_date, salary)
  VALUES
    (p_first, p_last, p_email, p_dept, p_pos, CURDATE(), p_salary);
  INSERT INTO salary_history (employee_id, amount, effective_date, note)
  VALUES (LAST_INSERT_ID(), p_salary, CURDATE(), 'initial hire');
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_give_raise;
DELIMITER //
CREATE PROCEDURE sp_give_raise(
  IN p_emp INT UNSIGNED,
  IN p_pct DECIMAL(5,2)
)
BEGIN
  DECLARE v_new DECIMAL(12,2);
  SELECT salary * (1 + p_pct / 100) INTO v_new FROM employees WHERE id = p_emp;
  UPDATE employees SET salary = v_new WHERE id = p_emp;
  INSERT INTO salary_history (employee_id, amount, effective_date, note)
  VALUES (p_emp, v_new, CURDATE(), CONCAT('raise ', p_pct, ' percent'));
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_department_payroll;
DELIMITER //
CREATE PROCEDURE sp_department_payroll(IN p_dept INT UNSIGNED)
BEGIN
  SELECT d.name AS department,
         COUNT(e.id) AS employees,
         COALESCE(SUM(e.salary), 0) AS monthly_payroll
  FROM departments d
  LEFT JOIN employees e ON e.department_id = d.id AND e.status = 'active'
  WHERE d.id = p_dept
  GROUP BY d.id, d.name;
END//
DELIMITER ;
