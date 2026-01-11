# Forage Wells Fargo — Task 1 (Creating a Data Model)

This repository contains my relational data model (ERD + schema) for an investment management system
used by financial advisors to manage clients and their portfolio holdings.

## What the system supports
- Advisors manage multiple clients
- Advisors can create, update, and remove clients
- Each client has a portfolio
- Portfolios contain zero or more securities
- Each security holding tracks: name, category, purchase date, purchase price, quantity
- Data is stored in a relational database

## Data model overview
### Entities (tables)
- `advisor`
- `client`
- `portfolio`
- `security_master`
- `portfolio_holding`

### Relationships
- `advisor` (1) → (many) `client`
- `client` (1) → (1) `portfolio`
- `portfolio` (1) → (many) `portfolio_holding`
- `security_master` (1) → (many) `portfolio_holding`

## Repo contents
- `db/schema.sql` — SQL DDL for tables, keys, and indexes
- `docs/assumptions.md` — modeling assumptions + relationship summary

## Notes on non-data requirements
The prompt mentions uptime, React, Spring, business hours, and scalability. Those matter for architecture,
but they do not require additional entities in the ERD for this task.

## Mermaid ERD (optional)
You can paste this into any Mermaid-enabled viewer:

```mermaid
erDiagram
  ADVISOR ||--o{ CLIENT : manages
  CLIENT ||--|| PORTFOLIO : owns
  PORTFOLIO ||--o{ PORTFOLIO_HOLDING : contains
  SECURITY_MASTER ||--o{ PORTFOLIO_HOLDING : referenced_by

  ADVISOR {
    BIGINT advisor_id PK
    VARCHAR first_name
    VARCHAR last_name
    VARCHAR email
    TIMESTAMP created_at
  }

  CLIENT {
    BIGINT client_id PK
    BIGINT advisor_id FK
    VARCHAR first_name
    VARCHAR last_name
    VARCHAR email
    VARCHAR status
    TIMESTAMP created_at
  }

  PORTFOLIO {
    BIGINT portfolio_id PK
    BIGINT client_id FK UNIQUE
    VARCHAR name
    TIMESTAMP created_at
  }

  SECURITY_MASTER {
    BIGINT security_id PK
    VARCHAR name
    VARCHAR category
  }

  PORTFOLIO_HOLDING {
    BIGINT holding_id PK
    BIGINT portfolio_id FK
    BIGINT security_id FK
    DATE purchase_date
    NUMERIC purchase_price
    NUMERIC quantity
  }