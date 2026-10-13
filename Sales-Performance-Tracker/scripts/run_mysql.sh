#!/bin/sh
# Run from repository project root; password is prompted by mysql.
set -eu
mysql "$@" < sql/01_database_setup.sql
mysql "$@" < sql/01b_import_portable.sql
for script in sql/02*.sql sql/03*.sql sql/04*.sql sql/05*.sql sql/06*.sql sql/07*.sql sql/08*.sql sql/09*.sql sql/10*.sql; do
  mysql "$@" < "$script"
done
