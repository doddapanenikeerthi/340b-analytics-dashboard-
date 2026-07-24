-- 340B Analytics Dashboard: Schema
-- SQLite-compatible; adjust types slightly for SQL Server/Postgres if needed

CREATE TABLE covered_entities (
    entity_id    TEXT PRIMARY KEY,
    entity_name  TEXT NOT NULL,
    entity_type  TEXT NOT NULL,   -- e.g., Hospital - DSH, FQHC, Ryan White Clinic
    state        TEXT NOT NULL
);

CREATE TABLE drug_reference (
    ndc          TEXT PRIMARY KEY,
    drug_name    TEXT NOT NULL,
    wac_price    REAL NOT NULL,   -- Wholesale Acquisition Cost
    price_340b   REAL NOT NULL    -- 340B ceiling price
);

CREATE TABLE claims (
    claim_id      TEXT PRIMARY KEY,
    entity_id     TEXT NOT NULL REFERENCES covered_entities(entity_id),
    ndc           TEXT NOT NULL REFERENCES drug_reference(ndc),
    fill_date     TEXT NOT NULL,
    encounter_type TEXT NOT NULL,
    eligible_340b TEXT NOT NULL CHECK (eligible_340b IN ('Y','N')),
    billed_price  REAL NOT NULL,
    qty           INTEGER NOT NULL
);

CREATE TABLE replenishment_orders (
    order_id      TEXT PRIMARY KEY,
    entity_id     TEXT NOT NULL REFERENCES covered_entities(entity_id),
    ndc           TEXT NOT NULL REFERENCES drug_reference(ndc),
    order_date    TEXT NOT NULL,
    qty_ordered   INTEGER NOT NULL,
    unit_price_340b REAL NOT NULL,
    lag_days_from_trigger_claim INTEGER NOT NULL
);

CREATE TABLE split_billing_flags (
    claim_id      TEXT NOT NULL REFERENCES claims(claim_id),
    tpa_name      TEXT NOT NULL,   -- e.g., Verity, Sentry, Macro Helix, Kalderos
    match_status  TEXT NOT NULL    -- Matched / Unmatched - Review / Duplicate Discount Risk
);
