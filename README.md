# SQL Data Analytics Projects

A portfolio of SQL projects exploring marketing conversion, retail sales performance, and real estate operations. Each project connects a business question to structured data, SQL analysis, and documented results.

The collection demonstrates data exploration, quality checks, relational database design, analytical queries, and clear communication of findings.

## Explore the projects

| Project | Business focus | Data and scope | Deliverables |
| --- | --- | --- | --- |
| [Bank Marketing Analysis](Bank-Marketing-Analysis/README.md) | Understand historical term-deposit subscription patterns across customer and campaign segments | 41,188 campaign records; 11 analyses | MySQL scripts, result CSVs, business findings, offline dashboard |
| [Sales Performance Tracker](Sales-Performance-Tracker/README.md) | Analyze sales concentration, ordering trends, products, customers, and RFM segments | 2,823 order lines, 307 orders, 92 customers | MySQL scripts, quality checks, result CSVs, offline dashboard, reproduction script |
| [Real Estate Management System](RealEstateManagementSystem/README.md) | Model property sales and rentals, track rent collection, and monitor maintenance | 17 tables, 18 synthetic properties, 12 business reports | Schema, sample data, ER diagram, SQL reports, automated checks |

## Project highlights

### Bank Marketing Analysis

**Question:** Which historical customer and campaign segments are associated with higher subscription rates?

- Measures overall conversion and compares job groups, channels, previous campaign outcomes, and contact frequency.
- Preserves unknown categories and source-specific sentinel values during analysis.
- Examines channel differences within previous-outcome groups to investigate confounding.
- Documents interpretation limits: observed associations do not establish causal improvements.

**Example result:** 4,640 subscriptions across 41,188 records produce an overall conversion rate of **11.27%**.

[Project guide](Bank-Marketing-Analysis/README.md) · [Business findings](Bank-Marketing-Analysis/reports/business_insights.md) · [Dashboard source](Bank-Marketing-Analysis/dashboard/index.html) · [MySQL setup](Bank-Marketing-Analysis/MYSQL_SETUP.md)

### Sales Performance Tracker

**Question:** Where is recorded sales value concentrated, and how do product, customer, and geographic patterns change over time?

- Separates order-line counts from distinct orders and customers.
- Compares all-status and shipped-only KPIs, monthly trends, and comparable year-to-date periods.
- Analyzes product lines, customer concentration, geography, and RFM segments.
- Includes a portable MySQL import and a Python workflow to reproduce reports and the dashboard.

**Example result:** All-status recorded sales total **10,032,628.85** across **307 orders**. The source does not specify currency; recorded sales are not presented as profit.

[Project guide](Sales-Performance-Tracker/README.md) · [Business findings](Sales-Performance-Tracker/reports/business_insights.md) · [Dashboard source](Sales-Performance-Tracker/dashboards/sales_dashboard.html) · [SQL analyses](Sales-Performance-Tracker/sql/)

### Real Estate Management System

**Question:** How can a relational database support property operations and reliable sales, rental, and maintenance reporting?

- Models owners, properties, agents, listings, sales, leases, charges, payments, and maintenance.
- Distinguishes property sales volume, commissions, expected rent, and cash collected.
- Supports partial payments and separates outstanding overdue charges from charges settled late.
- Includes reproducible fixtures, restrictive deletes for historical records, and financial validation checks.

**Example result:** At the synthetic **December 31, 2025** snapshot, expected rent is **$97,200**, collections are **$95,350**, and outstanding overdue rent is **$1,850 USD**.

[Project guide](RealEstateManagementSystem/README.md) · [Current ER diagram](RealEstateManagementSystem/docs/erd.md) · [Analytics](RealEstateManagementSystem/DQL_Queries.sql) · [Sample output](RealEstateManagementSystem/docs/sample_output.tsv)

## Technical skills demonstrated

| Area | Examples in this repository |
| --- | --- |
| Database design | Tables, primary and foreign keys, constraints, normalization, targeted indexes |
| Data preparation | CSV imports, typed fields, missing and unknown values, duplicate and consistency checks |
| SQL analysis | Joins, aggregation, conditional logic, subqueries, CTEs, date functions |
| Window functions | Ranking, cumulative totals, prior-period comparisons, percentile scoring |
| Business reporting | Conversion rates, sales KPIs, customer segmentation, rent reconciliation, maintenance metrics |
| Reproducibility | Fixed demo snapshots, exported results, SQL assertions, Python validation workflows |
| Communication | Data dictionaries, business interpretations, dashboards, and explicit limitations |

## Getting started

1. Clone or download this repository.
2. Open the project folder you want to explore.
3. Read that project's README for requirements, data sources, setup order, and validation instructions.
4. Run its setup and analysis scripts, or inspect the included result files first.

Use **MySQL 8.0.16+** as the common baseline for the collection. Individual project guides provide more specific requirements and execution evidence. MySQL Workbench or the MySQL CLI can run the SQL; Python 3.9+ is optional for the supplied reproduction and automated-check workflows.

The bank marketing and sales dashboards are static HTML reports. Download the repository and open the HTML file in a browser to view them. GitHub displays their source unless hosting is configured separately.

Each project uses its own database setup. Review initialization, import, and reset scripts before executing them; some replace demo data or explicitly delete a demonstration database.

## Repository structure

```text
SQLDataAnalyticsProjects/
├── README.md
├── Bank-Marketing-Analysis/
│   ├── data/
│   ├── mysql/
│   ├── reports/
│   └── dashboard/
├── Sales-Performance-Tracker/
│   ├── data/
│   ├── sql/
│   ├── reports/
│   ├── dashboards/
│   └── scripts/
└── RealEstateManagementSystem/
    ├── Updated_schema.sql
    ├── New_Data.sql
    ├── DQL_Queries.sql
    ├── docs/
    ├── scripts/
    └── tests/
```

## Validation and interpretation

Validation differs by project; included outputs should not be mistaken for proof that every script has been executed on every supported database version.

| Project | Documented validation status |
| --- | --- |
| Bank Marketing Analysis | Import records compared with source data; MySQL runtime execution remains unverified. See [validation notes](Bank-Marketing-Analysis/reports/mysql_validation.md). |
| Sales Performance Tracker | Python and SQLite reconciliation, generated-import verification, and MySQL assertions supplied; native MySQL runtime validation remains outstanding. See [validation notes](Sales-Performance-Tracker/reports/VALIDATION.md). |
| Real Estate Management System | Fresh initialization, integrity checks, and expected outputs from all 12 reports passed on MySQL Community Server 9.3.0. See the [project README](RealEstateManagementSystem/README.md). |

The marketing and retail findings describe historical datasets. The real estate records are fictional demonstration data. Read the project-level definitions and limitations before comparing metrics or applying findings to business decisions.

## Data sources and attribution

Dataset provenance, reuse terms, and original contributor credits are documented within each project:

- [Bank marketing attribution](Bank-Marketing-Analysis/ATTRIBUTION.md)
- [Sales dataset attribution](Sales-Performance-Tracker/ATTRIBUTION.md)
- [Real estate coursework and contributor credits](RealEstateManagementSystem/README.md#original-coursework-and-attribution)

Licensing is project-specific; this repository overview does not apply a new license to the collection.
