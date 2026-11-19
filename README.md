# MariaDB Practicum

## Overview
A hands-on lab for SQL schema design, indexes, stored procedures, triggers,
replication concepts, backup and restore, and a Docker-based exercise. All
work is local. No cloud account and no real credentials are required.

## Architecture
- MariaDB 11 container hosts the `hris` database, a small HR information
  system with departments, positions, employees, salary_history and
  audit_log tables.
- phpMyAdmin container provides a web UI on port 8080.
- The `db/*.sql` files are mounted into `/docker-entrypoint-initdb.d` with
  numeric prefixes so they run in order on first init: schema, seed,
  procedures, triggers, queries.
- `src/index.js` is a Node.js client demonstrating reads, a transaction,
  and stored procedure calls.
- `src/lib/queries.js` holds pure SQL-building helpers, testable without a
  live database.

Replication concepts (covered conceptually, not started by this compose file):
- A primary server writes binary events to the binlog.
- One or more replicas read the binlog through a replication user and replay it.
- Use a dedicated replication user, never the application user.
- Monitor replica lag with `SHOW REPLICA STATUS` or `SHOW SLAVE STATUS`.
- Backups taken from a replica must record replication coordinates.

## How to run
1. Copy `.env.example` to `.env` and replace every `REPLACE_ME` placeholder.
2. Start the services:
   `docker compose up -d`
3. On a fresh volume the SQL files in `db/` run in order and build the schema.
   To reinitialize, remove the `mariadb-data` volume first.
4. Run the client:
   `npm install`
   `npm start`
5. Open phpMyAdmin at `http://localhost:8080` (user and password from `.env`).
6. Stop everything:
   `docker compose down`

## Test commands
- Run all tests (no database required): `npm test`
- Run a single file: `node --test tests/queries.test.js`

Tests validate the pure SQL-building helpers and check that the SQL files
contain the expected statements. They need no MariaDB instance and no
third-party packages. CI uses the same command on Node.js 22.

## Project structure
```
.
|-- .github/workflows/ci.yml   # CI: Node 22, runs unit tests
|-- .env.example               # placeholder environment variables
|-- .gitignore
|-- LICENSE                    # MIT 2026
|-- README.md
|-- docker-compose.yml         # mariadb:11 + phpmyadmin
|-- package.json
|-- db/
|   |-- schema.sql             # tables, keys, foreign keys, indexes
|   |-- seed.sql               # sample HRIS data
|   |-- procedures.sql         # hire, raise, payroll procedures
|   |-- triggers.sql           # audit and delete-guard triggers
|   `-- queries.sql            # example analytics queries
|-- scripts/
|   |-- backup.sh              # mariadb-dump placeholder
|   `-- restore.sh             # mariadb placeholder
|-- src/
|   |-- index.js               # queries + transaction client
|   `-- lib/queries.js         # pure SQL helpers
`-- tests/
    `-- queries.test.js        # node:test unit tests (no DB)
```

## Security notes
- Every credential in this repository is a placeholder (`REPLACE_ME`).
- Never commit a real `.env` file. It is ignored by git.
- Change the default database and phpMyAdmin passwords before exposing ports.
- Use a least-privilege application user; reserve root for administration.
- SQL identifiers are hardcoded; user values are bound as parameters, never
  concatenated into query strings.
- Backups contain real data; store them outside the repo and encrypt at rest.

## Tech stack
- MariaDB 11
- phpMyAdmin 5
- Node.js 22 or newer (tested on 22 and 26)
- `mysql2` npm driver
- Docker and Docker Compose
- `node:test` for unit tests

## Repository topics
Suggested GitHub topics for this repository: `mariadb`, `mysql`, `sql`,
`docker`, `docker-compose`, `database-design`, `stored-procedures`,
`triggers`, `indexes`, `replication`, `practicum`. These are metadata labels
only; they are listed here so the repository can be tagged consistently.

## License
MIT 2026 Arya Fatthurahman.
