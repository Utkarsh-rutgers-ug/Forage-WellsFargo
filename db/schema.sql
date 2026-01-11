DROP TABLE IF EXISTS portfolio_holding;
DROP TABLE IF EXISTS portfolio;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS security_master;
DROP TABLE IF EXISTS advisor;

CREATE TABLE advisor (
  advisor_id      BIGSERIAL PRIMARY KEY,
  first_name      VARCHAR(80)  NOT NULL,
  last_name       VARCHAR(80)  NOT NULL,
  email           VARCHAR(255) NOT NULL UNIQUE,
  created_at      TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE security_master (
  security_id     BIGSERIAL PRIMARY KEY,
  name            VARCHAR(255) NOT NULL,
  category        VARCHAR(80)  NOT NULL
);

CREATE TABLE client (
  client_id       BIGSERIAL PRIMARY KEY,
  advisor_id      BIGINT       NOT NULL REFERENCES advisor(advisor_id),
  first_name      VARCHAR(80)  NOT NULL,
  last_name       VARCHAR(80)  NOT NULL,
  email           VARCHAR(255),
  status          VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
  created_at      TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE portfolio (
  portfolio_id    BIGSERIAL PRIMARY KEY,
  client_id       BIGINT       NOT NULL UNIQUE REFERENCES client(client_id),
  name            VARCHAR(120) NOT NULL DEFAULT 'Main Portfolio',
  created_at      TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Holdings represent the securities contained in a portfolio.
-- Purchase fields belong at the holding level because the same security
-- can be purchased multiple times at different dates/prices.
CREATE TABLE portfolio_holding (
  holding_id      BIGSERIAL PRIMARY KEY,
  portfolio_id    BIGINT        NOT NULL REFERENCES portfolio(portfolio_id),
  security_id     BIGINT        NOT NULL REFERENCES security_master(security_id),
  purchase_date   DATE          NOT NULL,
  purchase_price  NUMERIC(12,2) NOT NULL CHECK (purchase_price >= 0),
  quantity        NUMERIC(18,6) NOT NULL CHECK (quantity >= 0)
);

-- Indexes for common query patterns
CREATE INDEX idx_client_advisor_id     ON client(advisor_id);
CREATE INDEX idx_holding_portfolio_id  ON portfolio_holding(portfolio_id);
CREATE INDEX idx_holding_security_id   ON portfolio_holding(security_id);