-- Sample HRIS data. Loaded after schema.sql.
USE hris;

INSERT INTO departments (id, name, location, budget) VALUES
  (1, 'Engineering', 'Jakarta', 500000.00),
  (2, 'Finance', 'Singapore', 300000.00),
  (3, 'Operations', 'Bandung', 200000.00);

INSERT INTO positions (id, title, min_salary, max_salary) VALUES
  (1, 'Junior Engineer', 4000.00, 7000.00),
  (2, 'Senior Engineer', 8000.00, 14000.00),
  (3, 'Analyst', 5000.00, 9000.00),
  (4, 'Manager', 10000.00, 18000.00);

INSERT INTO employees
  (id, first_name, last_name, email, department_id, position_id, hire_date, salary, status)
VALUES
  (1, 'Alya', 'Putri', 'alya.putri@example.test', 1, 2, '2023-01-15', 12000.00, 'active'),
  (2, 'Bima', 'Saputra', 'bima.saputra@example.test', 1, 1, '2023-03-02', 6000.00, 'active'),
  (3, 'Citra', 'Dewi', 'citra.dewi@example.test', 2, 3, '2023-05-20', 8500.00, 'active'),
  (4, 'Dimas', 'Prakoso', 'dimas.prakoso@example.test', 1, 4, '2022-08-10', 15000.00, 'on_leave'),
  (5, 'Eka', 'Rahma', 'eka.rahma@example.test', 3, 1, '2024-01-08', 5500.00, 'active'),
  (6, 'Fajar', 'Nugroho', 'fajar.nugroho@example.test', 2, 4, '2022-11-01', 16000.00, 'terminated');

INSERT INTO salary_history (employee_id, amount, effective_date, note) VALUES
  (1, 10000.00, '2023-01-15', 'initial hire'),
  (1, 12000.00, '2024-06-01', 'annual review'),
  (2, 6000.00, '2023-03-02', 'initial hire'),
  (3, 8500.00, '2023-05-20', 'initial hire'),
  (4, 15000.00, '2022-08-10', 'initial hire'),
  (5, 5500.00, '2024-01-08', 'initial hire'),
  (6, 16000.00, '2022-11-01', 'initial hire');
