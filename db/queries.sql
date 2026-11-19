-- Example analytics queries. Loaded last; statements are read-only.
USE hris;

-- 1. Active employees with department and position.
SELECT e.id, e.first_name, e.last_name, d.name AS department,
       p.title AS position, e.salary
FROM employees e
JOIN departments d ON d.id = e.department_id
JOIN positions p ON p.id = e.position_id
WHERE e.status = 'active'
ORDER BY e.salary DESC;

-- 2. Monthly payroll per department.
SELECT d.name AS department, COUNT(e.id) AS headcount, SUM(e.salary) AS payroll
FROM departments d
LEFT JOIN employees e ON e.department_id = d.id
GROUP BY d.id, d.name
ORDER BY payroll DESC;

-- 3. Salary history for one employee.
SELECT employee_id, amount, effective_date, note
FROM salary_history
WHERE employee_id = 1
ORDER BY effective_date;

-- 4. Recent hires (index-friendly range scan on hire_date).
SELECT id, first_name, last_name, hire_date
FROM employees
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 365 DAY)
ORDER BY hire_date DESC;

-- 5. Recent employee audit trail.
SELECT operation, record_id, details, changed_at
FROM audit_log
WHERE table_name = 'employees'
ORDER BY changed_at DESC
LIMIT 50;
