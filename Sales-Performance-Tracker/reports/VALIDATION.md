# Validation scope

Executed successfully: `python3 scripts/reproduce.py` using standard-library Python, SQLite SQL execution with narrow date/function translations, exact Decimal reconciliation, and all-column portable INSERT round trip. Outputs are in validation.json, metrics.json and results/.

Not executed successfully: native MySQL server startup/import/queries. Installed mysqld 9.3.0 terminated with SIGSEGV while initializing an isolated temporary datadir; no existing server or database was changed. SQL targets MySQL 8.0+ syntax. Run scripts 01–10 locally to verify native behavior. Script 10 needs CREATE ROUTINE permission; analysis itself does not.

The supplied snapshot hash is recorded in validation.json. Reproduction requires the same dataset. Optional LOCAL INFILE was not runtime tested. Re-running imports replaces the project sales table; views remain defined against that table.
