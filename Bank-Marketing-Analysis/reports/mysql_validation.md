# MySQL validation status

- Target: MySQL Server 8.0 or newer (CTEs and DENSE_RANK are required).
- All 41,188 emitted import records were checked field by field against source-derived data.
- Repeat-import behavior was checked using an equivalent SQL import in a separate verification environment.
- MySQL-specific schema and qualified wildcards were reviewed.
- End-to-end MySQL execution remains unverified because permission to connect to the temporary MySQL test server was declined.
- Run `mysql/03_validate.sql` after setup and import: all six results should be 1.
- Reference result CSVs and the dashboard come from the original analysis of the same source data. Compare your local MySQL outputs with `reports/results/`; numeric rounding and tied row order may vary.

This package contains MySQL scripts only, with no alternative database, Python runner, or alternative SQL dialect scripts.
