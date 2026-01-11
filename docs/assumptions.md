# Assumptions (Forage Wells Fargo - Task 1)

This document captures the assumptions I made to translate the prompt into a relational ERD.

## Scope assumptions
- This model focuses on the data required to manage advisors, clients, and client portfolio holdings.
- Requirements like 99% uptime, React dashboard, Spring framework, business hours, and “highly scalable”
  are treated as non-data requirements and are not modeled as entities.

## Data model assumptions
1. Advisor → Client is 1-to-many: one advisor can manage many clients.
2. Client → Portfolio is 1-to-1: each client has exactly one main portfolio for this task.
   - Implemented by a UNIQUE constraint on `portfolio.client_id`.
3. A portfolio can hold zero or more securities.
4. Securities are split into:
   - `security_master` (security identity attributes like name + category)
   - `portfolio_holding` (transaction/position attributes like purchase date, price, quantity)
5. A portfolio can contain the same security multiple times (multiple buys on different dates/prices),
   so holdings use a surrogate key `holding_id` rather than enforcing a single (portfolio_id, security_id) row.
6. `purchase_price` represents the price per unit at the time of purchase.
7. `quantity` is stored as a decimal to support partial shares if needed.
8. “Remove a security from a portfolio” is modeled as deleting (or archiving) holdings for that security.
   - For simplicity, this schema uses deletes. A future enhancement could use a `sold_at` timestamp.
9. Client “remove” can be modeled as a soft delete via `status` (ACTIVE/INACTIVE).
10. Emails are optional for clients but required and unique for advisors in this example.

## Relationship summary
- advisor (1) → (many) client
- client (1) → (1) portfolio
- portfolio (1) → (many) portfolio_holding
- security_master (1) → (many) portfolio_holding