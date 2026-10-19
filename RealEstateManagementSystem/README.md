# Real Estate Management & SQL Analytics

A relational database portfolio project for property sales, leasing, rent collection, and maintenance. Built with MySQL, it connects operational records to **12 business reports** with reproducible synthetic data and automated checks.

**Skills demonstrated:** relational modeling · data integrity · joins · CTEs · window functions · financial reconciliation · SQL validation

## Business questions

- Which properties rank highest by asking price within each city?
- How are monthly sales volume and complete-year growth changing?
- Which agents outperform the average, including agents with no sales?
- Which open sale listings have been on the market for at least 90 days?
- Which tenants have unpaid or partially paid overdue rent?
- How much cash was collected by city and month, compared with expected rent?
- Which properties have recurring maintenance issues?
- Which rent charges were settled after their deadline?

## Reproducible findings

At the **December 31, 2025** reporting date, the supplied synthetic dataset produces:

| Metric | Result |
| --- | ---: |
| Properties / cities | 18 / 3 |
| Completed sales | 6 |
| 2024 sales volume | $960,000 |
| 2025 sales volume | $1,050,000 |
| Year-over-year sales growth | 9.38% |
| Expected 2025 rent | $97,200 |
| Rent collected | $95,350 |
| Outstanding overdue rent | $1,850 |
| Commission earned | $60,300 |
| Open sale listings aged at least 90 days | 3 |

**Interpretation:** Tenant 2 owes $1,200 and Tenant 3 owes $650 after a partial payment. Tenant 4 settled a $1,400 charge late and is correctly excluded from current arrears. Tenant 6 paid December rent in two installments on the due date. Property 7 has two maintenance requests, $600 of recorded costs, and a three-day average completion time.

All monetary values are **USD**. Property sales volume is distinct from commission earnings. These findings describe fictional fixtures, not a real property market.

## Quick start

### Requirements

- MySQL **8.0.16 or later** for enforced `CHECK` constraints, CTEs, and window functions.
- MySQL CLI or MySQL Workbench.
- Python 3.9+ only for the optional automated report checks; no third-party Python packages.

The revised scripts were executed successfully with **MySQL Community Server 9.3.0**. Other supported versions have not been executed in this review.

### MySQL CLI

From this directory, connect with your own credentials:

```bash
mysql -u root -p
```

Then execute these commands **one at a time**, checking for errors before continuing:

```sql
SOURCE Updated_schema.sql;
SOURCE New_Data.sql;
SOURCE tests/validate.sql;
SOURCE DQL_Queries.sql;
```

The schema creates `real_estate` if absent and expects it to contain no project tables. It does **not** drop an existing database. Schema and seed files are one-time initialization scripts; rerunning them against populated tables is intentionally unsupported.

For Workbench, open and run the schema, seed, validation, and analytics files in that order. The CLI compatibility file `Data_Retrieval.sql` simply sources `DQL_Queries.sql`; the latter is the recommended file to open directly in Workbench.

The seed inserts run inside one transaction. If a seed statement fails, execute `ROLLBACK;` immediately and resolve the error before retrying; do not continue to its final `COMMIT` after an error.

### Automated checks

After initialization, run:

```bash
python3 tests/run_checks.py -- -u root -p
```

This runs the SQL validation and checks key outputs from all analytics. The CLI can prompt twice for your password, once per connection. For a custom installation:

```bash
python3 tests/run_checks.py --mysql /path/to/mysql -- -u your_user -p
```

The SQL checks verify financial totals, lease consistency, charge periods, sale/listing consistency, overpayments, and rejection of invalid dates, negative payments, and deletion of historical properties. The negative checks roll back their attempted changes. Run checks on the unmodified demo dataset; expected results deliberately fail if fixtures change.

### Start over (disposable demo only)

`scripts/reset_demo.sql` **deletes the entire `real_estate` database**. It is never run automatically. Review it and confirm that the database contains only disposable demo data before sourcing it; then repeat initialization.

## Project layout

```text
RealEstateManagementSystem/
├── README.md
├── Updated_schema.sql          # 17 tables, constraints, and indexes
├── New_Data.sql                # Deterministic, fictional sample data
├── DQL_Queries.sql             # 12 numbered business reports
├── Data_Retrieval.sql          # Compatibility entry point
├── docs/
│   ├── erd.md                  # Current Mermaid relationship diagram
│   └── sample_output.tsv       # Captured results at the fixed reporting date
├── tests/
│   ├── validate.sql            # Financial and integrity checks
│   └── run_checks.py           # Repeatable analytics assertions
├── scripts/
│   └── reset_demo.sql          # Explicit destructive reset
├── ER_Diagram.pdf              # Original coursework reference
└── SQL_finalproject_Group8.pdf # Original coursework report
```

## Database design

[View the current entity relationship diagram](docs/erd.md).

| Area | Tables |
| --- | --- |
| People and organizations | Owners, Buyers, Tenants, Agencies, Agents |
| Property inventory | Locations, Properties, Listings |
| Property sales | Transactions, Commissions |
| Leasing and billing | LeaseAgreements, Rentals, RentCharges, Payments |
| Property operations | Inspections, MaintenanceRequests, LegalDocuments |

Key choices:

- Each property is one individually rentable asset, with a street address and size in square feet.
- A rental references a lease; property identity comes through that lease to avoid conflicting duplicate references.
- A rent charge holds its billing period, due date, and amount. Payments reference a charge, allowing partial or multiple payments.
- A sale references its listing, which supplies the property and agent. Seller identity is stored explicitly for historical reporting.
- Financial and operational relationships use restrictive deletes. Archive properties or deactivate people instead of deleting history.
- Positive monetary amounts and valid date ranges are checked in the schema. Every table has creation and update timestamps.
- Targeted date and composite indexes support common access paths; this small demo does not claim measured performance gains.

## Reporting definitions

- **Reporting date:** `@as_of_date` in `DQL_Queries.sql`, initially `2025-12-31`.
- **Sales volume:** sum of completed property sale prices through the reporting date.
- **Commission earned:** recorded commission on completed sales, not proof of cash paid to an agent.
- **Expected rent:** charges grouped by billing period; does not infer ungenerated charges from lease terms.
- **Cash collected:** payments grouped by payment month, independent of the associated charge month.
- **Overdue balance:** a charge due before the reporting date, less payments received through that date. Charges due today are not yet overdue.
- **Late-settled charge:** paid in full by the reporting date, but not paid in full on its due date.
- **Lease interval:** start date inclusive, end date exclusive.
- **Yearly growth:** compares adjacent complete calendar years only. No prior year returns `NULL`; missing years are not silently treated as zero.

## Scope and limitations

This is a database and analytics demonstration, not a deployed management application or a migration for an existing database.

- Overlapping leases, charge periods outside leases, overpayments, and sale/listing consistency are detected by validation, but are not all blocked at write time. A production writer would need transactional procedures, row locking, and concurrency tests.
- One payment belongs to one charge. Refunds, deposits, cross-charge allocations, and commission splits are not modeled.
- Monthly charges are pre-generated in the seed; no billing scheduler is included.
- Property ownership changes, status changes, and listing closure are not automated workflows. The property owner field stores the current owner record; historical sellers are stored on sales. There is no complete title history.
- Reporting filters dated events, but does not reconstruct past versions of mutable addresses, asking prices, maintenance costs, or tenant details.
- Phone numbers, emails, and postal codes are fictional. Detailed international contact validation belongs outside this demo.
- No authentication layer, access-control deployment, dashboard, or large-data performance benchmark is included.

## Original coursework and attribution

This project builds on the original **Group 8 Real Estate Property Management System** coursework for CPSC 500-7 at University of Niagara Falls Canada, March 2025. Original contributors: Abigia Gashahun Edossa, Dhruv Alpeshkumar Patel, Keerthi Sadanand, and Oludeji Fashoro.

The original PDFs are preserved as historical references. They describe the earlier schema and should not be used as the setup guide for this revision. The SQL files, this README, and `docs/erd.md` describe the current implementation.

No new license is asserted for the original group work. Agree on reuse terms with the contributors before adding a repository license.
