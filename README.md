# 340B Program Analytics Dashboard

A SQL + Power BI project analyzing 340B Drug Pricing Program performance across a simulated network of covered entities — modeling the analysis a 340B Business Analyst would run to monitor savings capture, replenishment inventory, split-billing accuracy, and HRSA compliance risk.

![Dashboard Preview](dashboard/dashboard_screenshot.png)

## Problem

Covered entities participating in the 340B Program need to track three things closely: how much savings the program is actually capturing, whether replenishment inventory is being managed on time, and whether any claims carry compliance risk (duplicate discounts, ineligible claims billed at 340B pricing). This project builds a synthetic but realistic dataset and analysis layer to answer those questions end-to-end — from raw claims data to a decision-ready dashboard.

## Approach

1. **Synthetic data generation** — 2,000 pharmacy claims across 12 covered entities (DSH hospitals, CAHs, FQHCs, Ryan White clinics) and 8 high-utilization NDCs, plus 600 replenishment orders and 660 split-billing TPA match records (modeled on real TPAs: Verity, Sentry Data Systems, Macro Helix, Kalderos).
2. **Relational schema** (`sql/schema.sql`) — five normalized tables: covered entities, drug reference (WAC vs. 340B ceiling price), claims, replenishment orders, and split-billing flags.
3. **Analysis layer** — 8 SQL queries answering specific program-management questions (see below).
4. **Dashboard** — Power BI report visualizing savings trends, entity performance, replenishment lag, and compliance flags.

## Key Queries

| # | Query | Business Question |
|---|-------|-------------------|
| 1 | Savings Capture by Entity | Which entities generate the most 340B savings, and what % of claims capture 340B pricing? |
| 2 | Duplicate Discount Risk | Which claims are flagged by the TPA as potential duplicate discounts (Medicaid + 340B)? |
| 3 | Replenishment Lag | How long does it take entities to replenish 340B inventory after a triggering claim? |
| 4 | Ineligible Claims Compliance Check | Were any ineligible claims billed at 340B pricing? (0 found — clean result) |
| 5 | Top Drugs by Savings | Which NDCs drive the most total savings? |
| 6 | TPA Match Status Summary | Breakdown of matched/unmatched/at-risk claims by third-party administrator |
| 7 | Monthly Savings Trend | How is total program savings trending over time? |
| 8 | Savings by Entity Type | How does performance differ across DSH, CAH, FQHC, and Ryan White entity types? |

## Key Findings (from synthetic data)

- Program-wide 340B eligibility capture rate is ~88% across all claims.
- No claims were found billed at 340B pricing while marked ineligible — a clean result on the core compliance check (Query 4).
- Replenishment lag varies meaningfully by entity, ranging from same-day to 30-day cycles, highlighting where inventory review would add the most value.
- A small subset (~5%) of TPA-matched claims flagged as "Duplicate Discount Risk," representing the highest-priority audit queue.

## Tech Stack

- **SQL** (SQLite) — schema design, data modeling, analysis queries
- **Python** — synthetic data generation
- **Power BI** — dashboard and visualization layer

## Repo Structure

```
340b-analytics/
├── data/
│   ├── covered_entities.csv
│   ├── drug_reference.csv
│   ├── claims.csv
│   ├── replenishment_orders.csv
│   ├── split_billing_flags.csv
│   └── query_results/        # pre-run query outputs, ready for Power BI import
├── sql/
│   ├── schema.sql
│   └── queries/               # 01–08, one .sql file per business question
├── dashboard/
│   ├── 340b_dashboard.pbix
│   └── dashboard_screenshot.png
├── generate_data.py           # synthetic data generator
└── README.md
```

## Skills Demonstrated

340B Program mechanics · SQL (joins, window functions, aggregation) · relational data modeling · replenishment inventory analysis · split-billing / TPA reconciliation · HRSA compliance risk identification · Power BI dashboarding · data storytelling for healthcare stakeholders

---
*Note: All data in this project is synthetic and generated for portfolio/demonstration purposes. No real patient, claims, or covered entity data is used.*
