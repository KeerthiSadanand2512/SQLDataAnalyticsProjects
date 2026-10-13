# Sales Performance Tracker

A reproducible SQL portfolio project that turns a retail order-line CSV into sales KPIs, monthly trends, product rankings, customer analysis, geographic summaries and RFM segments.

**Business question:** Where is recorded sales value concentrated, how does ordering activity change over time, and which customer groups warrant further investigation?

## Results at a glance
| Metric | All statuses | Shipped only |
|---|---:|---:|
| Recorded sales | 10,032,628.85 | 9,291,501.08 |
| Orders | 307 | 286 |
| Customers | 92 | 92 |
| Units | 99,067 | 91,403 |
| Average order value | 32,679.57 | 32,487.77 |

Classic Cars contributes **39.07%** of recorded sales; the USA contributes **36.16%**. November 2004 is the peak observed month. Jan–May 2005 sales exceed the corresponding 2004 period by **36.41%**. Read [business findings](reports/business_insights.md) for evidence, actions and limitations.

## Dataset and measures
- 2,823 rows, 25 columns; one row is an order line, not an order.
- Key: `(ORDERNUMBER, ORDERLINENUMBER)`; count distinct ORDERNUMBER for orders.
- Dates: January 6, 2003–May 31, 2005. Currency is unspecified.
- Primary measure: `SUM(SALES)`. Average order value: `SUM(SALES) / COUNT(DISTINCT ORDERNUMBER)`.
- Baseline analyses include all statuses; script 04 separately reports shipped orders. Add `WHERE STATUS='Shipped'` before aggregation for a consistent shipped-only analysis.
- Preserve supplied SALES: 1,304 rows do not match QUANTITYORDERED × PRICEEACH. No profit or accounting-revenue claims are made.
- Customer name is the available customer identifier. Full schema: [data dictionary](data/data_dictionary.md).

## Quick start — MySQL 8.0+
Extract this folder into your `SQLDataAnalyticsProjects` repository. Use a local MySQL account with permission to create a database, table, view and routine. These scripts create `sales_performance_tracker`; the import replaces rows only in its `sales` table. Do not use that schema for unrelated data.

### MySQL Workbench
1. Open and execute `sql/01_database_setup.sql`.
2. Open and execute **`sql/01b_import_portable.sql`**. This file contains the actual dataset as INSERT statements, requires no CSV path change, and avoids Error 3948.
3. Execute `02` through `09` in order.
4. Execute `10_validate_expected_results.sql`; expect `PASS: expected snapshot assertions`.

Keep the default MySQL backslash escaping mode for the portable import; the import sets its required session SQL mode explicitly. Run each script through completion and stop on errors.

### Command line
From this project folder:
```sh
sh scripts/run_mysql.sh -u YOUR_USER -p
```
The client may prompt for the password for each script. Credentials are never stored. Use `-h HOST` if needed. The script stops at the first MySQL error.

### Optional direct CSV import
Use `01c_import_local_infile.sql` **instead of 01b**, after creating the schema. Edit its absolute file path. It stages all 25 CSV columns as text, handles the original CRLF and CSV quoting, then converts dates and blank fields. Use the original bundled CSV, whose line endings are CRLF.

Error 3948 means both server and client must allow LOCAL INFILE. Check `SHOW VARIABLES LIKE 'local_infile';`; an administrator can enable it with `SET GLOBAL local_infile=ON;` when appropriate. Start the CLI with `mysql --local-infile=1 -u YOUR_USER -p`. In Workbench, enable the connection's `OPT_LOCAL_INFILE=1` advanced option and reconnect. Alternatively, use the portable INSERT import without changing server configuration. LOCAL loads read a file from the client computer, so enable it only for a trusted server.

## What is included
| Location | Purpose |
|---|---|
| `data/sales_data.csv` | Original uploaded CSV, unchanged |
| `data/data_dictionary.md` | Every source column and target type |
| `sql/01*` | Schema and two alternative imports |
| `sql/02_data_exploration.sql` | Coverage and status mix |
| `sql/03_data_quality_checks.sql` | Duplicate, numeric, calendar and order consistency checks |
| `sql/04_sales_kpi_analysis.sql` | All-status and shipped-only metrics |
| `sql/05_revenue_trends.sql` | Monthly growth, annual totals and comparable Jan–May windows |
| `sql/06_product_analysis.sql` | Product lines, shares and top SKUs |
| `sql/07_customer_analysis.sql` | Top customers and repeat ordering |
| `sql/08_geographic_analysis.sql` | Country and territory summaries |
| `sql/09_customer_segmentation.sql` | Reusable customer_rfm view and segment summaries |
| `sql/10_validate_expected_results.sql` | MySQL assertions against computed snapshot |
| `reports/` | Findings, metrics, validation and 18 result CSV files |
| `dashboards/sales_dashboard.html` | Self-contained offline dashboard |
| `scripts/reproduce.py` | Regenerate outputs and independently reconcile totals |

SQL techniques: aggregation, distinct counts, CTEs, window functions (`LAG`, `PERCENT_RANK`), conditional logic, date functions, views, decimal measures and stored-procedure assertions. Segmentation rules and scoring are documented in the report and SQL.

## Reproduce the report and dashboard
Requires Python 3.9+; **no third-party packages**:
```sh
python3 scripts/reproduce.py
```
Open `dashboards/sales_dashboard.html` in a browser. It works offline with no external libraries. Result CSVs can also be loaded into Tableau, Power BI or a spreadsheet.

Validation checks the CSV with exact Decimal arithmetic, executes analysis SQL through SQLite with explicit dialect translations, reconciles exported sales aggregates, and verifies every field in the generated INSERT import. Native MySQL execution was attempted, but the installed MySQL 9.3.0 server crashed during isolated initialization. **MySQL runtime validation remains outstanding**; run script 10 on your MySQL installation. SQLite validation is not a substitute for a MySQL integration test.




