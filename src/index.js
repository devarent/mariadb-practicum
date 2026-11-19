"use strict";

// Query + transaction client for the MariaDB practicum.
// Requires a running MariaDB (see docker-compose.yml).
const mysql = require("mysql2/promise");
const logic = require("./lib/queries");

const config = {
  host: process.env.DB_HOST || "127.0.0.1",
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || "REPLACE_ME",
  password: process.env.DB_PASSWORD || "REPLACE_ME",
  database: process.env.DB_NAME || "hris"
};

async function main() {
  const conn = await mysql.createConnection(config);
  try {
    // READ with a bound parameter.
    const [rows] = await conn.execute(
      "SELECT id, first_name, last_name, salary FROM employees WHERE status = ?",
      ["active"]
    );
    console.log("active employees:", rows.length);

    // TRANSACTION: hire an employee and record the initial salary.
    const emp = {
      first_name: "Lab",
      last_name: "User",
      email: "lab.user@example.test",
      department_id: 1,
      position_id: 1,
      hire_date: logic.isoDate(new Date()),
      salary: 5000
    };
    const errors = logic.validateEmployee(emp);
    if (errors.length > 0) {
      throw new Error("invalid employee: " + errors.join(", "));
    }

    await conn.beginTransaction();
    let newId;
    try {
      const insert = logic.buildEmployeeInsert(emp);
      const [result] = await conn.execute(insert.sql, insert.params);
      newId = result.insertId;
      await conn.execute(
        "INSERT INTO salary_history (employee_id, amount, effective_date, note) " +
        "VALUES (?, ?, ?, ?)",
        [newId, emp.salary, emp.hire_date, "initial hire"]
      );
      await conn.commit();
      console.log("hired employee id:", newId);
    } catch (err) {
      await conn.rollback();
      throw err;
    }

    // STORED PROCEDURE: department payroll.
    const payroll = logic.buildPayrollQuery(1);
    const [payrollRows] = await conn.execute(payroll.sql, payroll.params);
    console.log("payroll:", payrollRows);

    // CLEANUP: the delete trigger blocks active rows, so terminate first.
    await conn.execute(
      "UPDATE employees SET status = 'terminated' WHERE id = ?",
      [newId]
    );
    await conn.execute("DELETE FROM employees WHERE id = ?", [newId]);
    console.log("done");
  } finally {
    await conn.end();
  }
}

if (require.main === module) {
  main().catch(function onError(err) {
    console.error(err);
    process.exitCode = 1;
  });
}

module.exports = { main: main };
