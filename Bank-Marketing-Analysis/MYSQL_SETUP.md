# Run the project in MySQL Workbench

Requires a **MySQL Server 8.0 or newer**, including 8.4, plus a connection in MySQL Workbench. Workbench is the interface; the server must also be running. Run `SELECT VERSION();` to check the server version. MySQL 5.7 cannot run the CTE and window-function queries.

## Steps
1. Extract the ZIP and open MySQL Workbench. Connect to your local MySQL server.
2. Choose **File → Open SQL Script**, select `mysql/00_setup.sql`, and run the entire script using the execute-all lightning button. This creates `bank_marketing_sql`, `bank_raw`, and the derived `bank` view. Your account needs permission to create a database/table/view.
3. Open `mysql/01_import_data.sql` and execute the entire script. It includes all 41,188 source records as small INSERT batches. No Python, CSV import wizard, file-path edits, or LOCAL INFILE setting is needed. Wait for COMMIT to finish; the final count should be 41,188.
4. Open `mysql/03_validate.sql` and execute it. All six values should be **1**. Stop and inspect errors if any are 0.
5. Open `mysql/02_analysis.sql`. Run the entire file for all 11 result tabs, or highlight one complete query and run just that selection.
6. Refresh the Schemas sidebar to browse the tables and view. Right-click a result grid to export results as CSV.

## Command-line alternative
From the extracted project directory, use your own MySQL username (replace `root` if needed):

```sh
mysql --default-character-set=utf8mb4 -u root -p < mysql/00_setup.sql
mysql --default-character-set=utf8mb4 -u root -p < mysql/01_import_data.sql
mysql --default-character-set=utf8mb4 -u root -p < mysql/03_validate.sql
mysql --default-character-set=utf8mb4 -u root -p < mysql/02_analysis.sql
```

The password is requested interactively; no password is stored in the files.

## Re-running and troubleshooting
- Setup does not drop any table. Use this dedicated database for this project. An unrelated existing `bank_raw` table with the same name may conflict with the expected schema.
- Import uses stable source-row IDs and INSERT IGNORE, so rerunning against the unmodified project table skips existing IDs. It does not repair edited rows. Check the validation result and review Workbench warnings if you have modified the table.
- If a connection is interrupted during import, reconnect and rerun the import, then validate. InnoDB transactions normally roll back uncommitted batches.
- Access denied: use a local account with database/table/view creation privileges.
- Syntax error near WITH or DENSE_RANK: check the **server** version, not the Workbench version.
- Each analysis script starts with `USE bank_marketing_sql`, so no manual default-schema selection is necessary.

## Dashboard and results
The included screenshot and CSV outputs are reference results from the original analysis of the same source data. They have not been regenerated from a verified MySQL run. See `reports/mysql_validation.md` for validation limits. Opening the dashboard requires only a browser; it is a static snapshot and does not automatically refresh from your local server.

