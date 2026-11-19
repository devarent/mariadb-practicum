-- Triggers. Loaded after procedures.sql.
USE hris;

DROP TRIGGER IF EXISTS trg_employees_ai;
DELIMITER //
CREATE TRIGGER trg_employees_ai AFTER INSERT ON employees
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, operation, record_id, details)
  VALUES ('employees', 'INSERT', NEW.id, CONCAT('email=', NEW.email));
END//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_employees_au;
DELIMITER //
CREATE TRIGGER trg_employees_au AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, operation, record_id, details)
  VALUES ('employees', 'UPDATE', NEW.id, CONCAT('salary ', OLD.salary, ' -> ', NEW.salary));
END//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_employees_bd;
DELIMITER //
CREATE TRIGGER trg_employees_bd BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
  IF OLD.status = 'active' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'active employee cannot be deleted';
  END IF;
  INSERT INTO audit_log (table_name, operation, record_id, details)
  VALUES ('employees', 'DELETE', OLD.id, CONCAT('email=', OLD.email));
END//
DELIMITER ;
