"""Validate an initialized demo database using the installed mysql CLI."""
import argparse
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--mysql', default='mysql', help='Path to mysql executable')
    parser.add_argument('connection_args', nargs=argparse.REMAINDER)
    args = parser.parse_args()
    connection_args = args.connection_args
    if connection_args[:1] == ['--']:
        connection_args = connection_args[1:]
    # Do not allow --force: SQL failures must fail validation.
    if any(a == '--force' or a.startswith('--force=') or a == '-f' for a in connection_args):
        parser.error('--force is incompatible with validation')

    def execute(path):
        result = subprocess.run(
            [args.mysql, *connection_args, '--batch', '--raw'],
            input=(ROOT / path).read_text(), text=True, capture_output=True, cwd=ROOT,
        )
        if result.returncode:
            print(result.stderr, file=sys.stderr)
            raise SystemExit(result.returncode)
        return result.stdout

    print(execute('tests/validate.sql').strip())
    output = execute('DQL_Queries.sql')
    # Independent known fixture outcomes exercise every numbered report.
    expected_rows = [
        '18\tAustin\tTX\t480000.00\t1',  # 1: city ranking
        '2025-03\t360000.00\t2010000.00',  # 2: cumulative volume
        '3\tDemo Agent 3\t690000.00',  # 3: above average
        '13\t13\t152',  # 4: aging listing
        '2\tDemo Tenant 2\t24\t2025-12-05\t1200.00\t0.00\t1200.00\t26',
        '3\tDemo Tenant 3\t36\t2025-12-05\t1300.00\t650.00\t650.00\t26',
        '2025-12\tAustin\tTX\tUS\t2250.00',  # 6: cash collections
        '4\tDemo Agent 4\t0.00\t4',  # 7: zero commissions
        'Apartment\t2\t345000.00',  # 8: mean sale price
        '2025\t1050000.00\t960000.00\t9.38',  # 9: complete-year growth
        '7\t2\t600.00\t3.00',  # 10: repeated maintenance
        '2025-12\t8100.00',  # 11: billed rent
        '48\t2025-12-05\t1400.00\t0.00',  # 12: settled late
    ]
    lines = set(output.splitlines())
    missing = [row for row in expected_rows if row not in lines]
    if missing:
        print('FAIL: expected report rows missing:\n' + '\n'.join(missing), file=sys.stderr)
        return 1
    # Guard against extra tenants incorrectly included in arrears.
    arrears = output.split('days_overdue\n', 1)[1].split('payment_month\t', 1)[0]
    if len(arrears.strip().splitlines()) != 2:
        print('FAIL: expected exactly two overdue charges', file=sys.stderr)
        return 1
    print('PASS: expected outputs from all 12 reports, including exactly two overdue charges')
    return 0


if __name__ == '__main__':
    sys.exit(main())
