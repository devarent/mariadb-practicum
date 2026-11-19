"use strict";

const test = require("node:test");
const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const logic = require("../src/lib/queries");

const dbDir = path.join(__dirname, "..", "db");
function readSql(name) {
  return fs.readFileSync(path.join(dbDir, name), "utf8");
}

const validEmployee = {
  first_name: "Alya",
  last_name: "Putri",
  email: "alya@example.test",
  department_id: 1,
  position_id: 2,
  hire_date: "2025-01-15",
  salary: 12000
};

test("validateEmployee accepts a valid employee", function () {
  assert.deepEqual(logic.validateEmployee(validEmployee), []);
});

test("validateEmployee reports invalid fields", function () {
  const bad = { first_name: "", last_name: "X", email: "bad", salary: -1 };
  assert.deepEqual(logic.validateEmployee(bad), [
    "first_name", "email", "salary"
  ]);
  assert.ok(logic.validateEmployee(null).length > 0);
});

test("buildEmployeeInsert uses placeholders and ordered params", function () {
  const q = logic.buildEmployeeInsert(validEmployee);
  assert.match(q.sql, /INSERT INTO employees/);
  assert.equal((q.sql.match(/\?/g) || []).length, 7);
  assert.equal(q.params.length, 7);
  assert.equal(q.params[2], "alya@example.test");
  assert.equal(q.params[6], 12000);
});

test("buildEmployeeInsert maps missing ids to null", function () {
  const q = logic.buildEmployeeInsert({
    first_name: "A", last_name: "B", email: "a@example.test",
    hire_date: "2025-01-01", salary: 1
  });
  assert.equal(q.params[3], null);
  assert.equal(q.params[4], null);
});

test("buildPayrollQuery binds the department id", function () {
  const q = logic.buildPayrollQuery(3);
  assert.match(q.sql, /LEFT JOIN employees/);
  assert.match(q.sql, /GROUP BY/);
  assert.equal((q.sql.match(/\?/g) || []).length, 1);
  assert.deepEqual(q.params, [3]);
});

test("buildRaiseProcedureCall builds a CALL statement", function () {
  assert.deepEqual(logic.buildRaiseProcedureCall(7, 5), {
    sql: "CALL sp_give_raise(?, ?)",
    params: [7, 5]
  });
});

test("isoDate returns YYYY-MM-DD", function () {
  assert.equal(logic.isoDate(new Date("2025-01-15T10:20:30Z")), "2025-01-15");
});

test("schema.sql defines all tables, foreign keys and indexes", function () {
  const s = readSql("schema.sql");
  const tables = ["departments", "positions", "employees", "salary_history", "audit_log"];
  for (const table of tables) {
    assert.match(s, new RegExp("CREATE TABLE " + table));
  }
  assert.match(s, /FOREIGN KEY/);
  assert.match(s, /UNIQUE/);
  assert.match(s, /CREATE INDEX idx_employees_department/);
  assert.match(s, /CREATE INDEX idx_salary_employee_date/);
});

test("seed.sql inserts sample data", function () {
  const s = readSql("seed.sql");
  assert.match(s, /INSERT INTO departments/);
  assert.match(s, /INSERT INTO positions/);
  assert.match(s, /INSERT INTO employees/);
  assert.match(s, /INSERT INTO salary_history/);
});

test("procedures.sql defines the three procedures", function () {
  const s = readSql("procedures.sql");
  assert.match(s, /CREATE PROCEDURE sp_hire_employee/);
  assert.match(s, /CREATE PROCEDURE sp_give_raise/);
  assert.match(s, /CREATE PROCEDURE sp_department_payroll/);
  assert.match(s, /DELIMITER/);
});

test("triggers.sql defines audit and delete-guard triggers", function () {
  const s = readSql("triggers.sql");
  assert.match(s, /CREATE TRIGGER trg_employees_ai/);
  assert.match(s, /CREATE TRIGGER trg_employees_au/);
  assert.match(s, /CREATE TRIGGER trg_employees_bd/);
  assert.match(s, /SIGNAL SQLSTATE/);
  assert.match(s, /audit_log/);
});

test("queries.sql contains joins and aggregation", function () {
  const s = readSql("queries.sql");
  assert.match(s, /JOIN departments/);
  assert.match(s, /GROUP BY/);
  assert.match(s, /SUM\(e\.salary\)/);
});
