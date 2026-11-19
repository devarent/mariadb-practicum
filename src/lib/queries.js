"use strict";

// Pure SQL-building and validation helpers for the MariaDB practicum.
// No connection, environment, or I/O in this module.

function validateEmployee(emp) {
  const errors = [];
  if (!emp || typeof emp.first_name !== "string" || emp.first_name.length === 0) {
    errors.push("first_name");
  }
  if (!emp || typeof emp.last_name !== "string" || emp.last_name.length === 0) {
    errors.push("last_name");
  }
  if (!emp || typeof emp.email !== "string" ||
      !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(emp.email)) {
    errors.push("email");
  }
  if (!emp || !Number.isFinite(Number(emp.salary)) || Number(emp.salary) < 0) {
    errors.push("salary");
  }
  return errors;
}

function buildEmployeeInsert(emp) {
  return {
    sql: "INSERT INTO employees " +
      "(first_name, last_name, email, department_id, position_id, hire_date, salary) " +
      "VALUES (?, ?, ?, ?, ?, ?, ?)",
    params: [
      emp.first_name,
      emp.last_name,
      emp.email,
      emp.department_id === undefined ? null : emp.department_id,
      emp.position_id === undefined ? null : emp.position_id,
      emp.hire_date,
      emp.salary
    ]
  };
}

function buildPayrollQuery(deptId) {
  return {
    sql: "SELECT d.name AS department, COUNT(e.id) AS headcount, " +
      "SUM(e.salary) AS payroll FROM departments d " +
      "LEFT JOIN employees e ON e.department_id = d.id " +
      "WHERE d.id = ? GROUP BY d.id, d.name",
    params: [deptId]
  };
}

function buildRaiseProcedureCall(empId, pct) {
  return { sql: "CALL sp_give_raise(?, ?)", params: [empId, pct] };
}

function isoDate(date) {
  return date.toISOString().slice(0, 10);
}

module.exports = {
  validateEmployee: validateEmployee,
  buildEmployeeInsert: buildEmployeeInsert,
  buildPayrollQuery: buildPayrollQuery,
  buildRaiseProcedureCall: buildRaiseProcedureCall,
  isoDate: isoDate
};
