#!/usr/bin/env python3
"""Standard-library reproduction: CSV/Decimal checks + SQL analysis via SQLite.
SQLite execution checks analysis logic, not MySQL import/runtime compatibility.
"""
from pathlib import Path
import csv, datetime as dt, decimal, collections, hashlib, sqlite3, re, json, html
ROOT=Path(__file__).resolve().parents[1]
D=decimal.Decimal
raw=(ROOT/'data/sales_data.csv').read_bytes()
with (ROOT/'data/sales_data.csv').open(encoding='utf-8-sig',newline='') as f:
 reader=csv.DictReader(f); cols=reader.fieldnames; rows=list(reader)
assert len(rows)==2823 and len(cols)==25
ints={'ORDERNUMBER','QUANTITYORDERED','ORDERLINENUMBER','QTR_ID','MONTH_ID','YEAR_ID','MSRP'}
nums={'PRICEEACH','SALES'}
keys=[(r['ORDERNUMBER'],r['ORDERLINENUMBER']) for r in rows]
assert len(keys)==len(set(keys))
for r in rows:
 date=dt.datetime.strptime(r['ORDERDATE'],'%m/%d/%Y %H:%M')
 assert (date.year,date.month,(date.month-1)//3+1)==tuple(int(r[c]) for c in ['YEAR_ID','MONTH_ID','QTR_ID'])
 assert D(r['SALES'])>=0 and D(r['PRICEEACH'])>=0 and int(r['QUANTITYORDERED'])>0
byorder=collections.defaultdict(set)
for r in rows:byorder[r['ORDERNUMBER']].add((r['CUSTOMERNAME'],r['ORDERDATE'],r['STATUS']))
assert all(len(x)==1 for x in byorder.values())
con=sqlite3.connect(':memory:')
con.create_function('YEAR',1,lambda v:int(v[:4]));con.create_function('MONTH',1,lambda v:int(v[5:7]));con.create_function('QUARTER',1,lambda v:(int(v[5:7])-1)//3+1)
con.create_function('DATE_FORMAT',2,lambda v,fmt:v[:7])
con.create_function('DATEDIFF',2,lambda a,b:(dt.datetime.fromisoformat(a)-dt.datetime.fromisoformat(b)).days)
con.create_function('PLUS_DAY',1,lambda a:(dt.datetime.fromisoformat(a)+dt.timedelta(days=1)).isoformat(' '))
con.create_function('LEAST',2,min);con.create_function('FLOOR',1,lambda v:int(v//1))
con.execute('CREATE TABLE sales ('+','.join(c+' '+('INTEGER' if c in ints else 'REAL' if c in nums else 'TEXT') for c in cols)+')')
con.executemany('INSERT INTO sales VALUES ('+','.join('?' for _ in cols)+')',[[int(r[c]) if c in ints else float(r[c]) if c in nums else dt.datetime.strptime(r[c],'%m/%d/%Y %H:%M').isoformat(' ') if c=='ORDERDATE' else r[c] or None for c in cols] for r in rows])
# Execute the actual analysis files with narrowly scoped dialect translations.
outputs={}
for file in sorted((ROOT/'sql').glob('0[2-9]*.sql')):
 sql=re.sub(r'--[^\n]*','',file.read_text()).replace('USE sales_performance_tracker;','')
 sql=sql.replace('CREATE OR REPLACE VIEW','CREATE VIEW').replace('DATE_ADD(MAX(ORDERDATE),INTERVAL 1 DAY)','PLUS_DAY(MAX(ORDERDATE))')
 for idx,stmt in enumerate(s for s in sql.split(';') if s.strip()):
  cur=con.execute(stmt)
  if not cur.description:continue
  names=[x[0] for x in cur.description]; records=cur.fetchall()
  out=ROOT/'reports/results'/f'{file.stem}_{idx+1}.csv'
  with out.open('w',newline='') as f:
   writer=csv.writer(f);writer.writerow(names);writer.writerows(records)
  outputs[out.name]=[dict(zip(names,x)) for x in records]
# Reconcile each exported aggregate sales result against independent Decimal grouping.
for filename,result in outputs.items():
 for rec in result:
  if 'sales' not in rec:continue
  subset=rows
  for col in ['STATUS','PRODUCTLINE','PRODUCTCODE','CUSTOMERNAME','COUNTRY','TERRITORY']:
   if col in rec:subset=[r for r in subset if r[col]==rec[col]]
  if 'month' in rec:subset=[r for r in subset if dt.datetime.strptime(r['ORDERDATE'],'%m/%d/%Y %H:%M').strftime('%Y-%m')==rec['month']]
  if 'year' in rec:subset=[r for r in subset if int(r['YEAR_ID'])==rec['year']]
  if rec.get('scope')=='Shipped only':subset=[r for r in subset if r['STATUS']=='Shipped']
  if 'segment' in rec:
   customers={x[0] for x in con.execute('SELECT CUSTOMERNAME FROM customer_rfm WHERE segment=?',(rec['segment'],))}
   subset=[r for r in subset if r['CUSTOMERNAME'] in customers]
  assert D(str(rec['sales'])).quantize(D('.01'))==sum((D(r['SALES']) for r in subset),D(0)),(filename,rec)
# Independent verification of KPI counts, AOV, monthly growth and matched periods.
for rec in outputs['04_sales_kpi_analysis_1.csv']:
 subset=[r for r in rows if rec['scope']=='All statuses' or r['STATUS']=='Shipped']
 total=sum((D(r['SALES']) for r in subset),D(0));orders=len({r['ORDERNUMBER'] for r in subset})
 assert rec['order_lines']==len(subset) and rec['orders']==orders
 assert rec['customers']==len({r['CUSTOMERNAME'] for r in subset})
 assert rec['units']==sum(int(r['QUANTITYORDERED']) for r in subset)
 assert D(str(rec['average_order_value']))==(total/orders).quantize(D('.01'),rounding=decimal.ROUND_HALF_UP)
previous=None
for rec in outputs['05_revenue_trends_1.csv']:
 subset=[r for r in rows if dt.datetime.strptime(r['ORDERDATE'],'%m/%d/%Y %H:%M').strftime('%Y-%m')==rec['month']]
 total=sum((D(r['SALES']) for r in subset),D(0))
 assert rec['orders']==len({r['ORDERNUMBER'] for r in subset})
 if previous is None:assert rec['month_growth_pct'] is None
 else:assert D(str(rec['month_growth_pct']))==((total-previous)/previous*100).quantize(D('.01'),rounding=decimal.ROUND_HALF_UP)
 previous=total
for rec in outputs['05_revenue_trends_2.csv']:
 subset=[r for r in rows if int(r['YEAR_ID'])==rec['year'] and int(r['MONTH_ID'])<=5]
 assert D(str(rec['jan_may_sales']))==sum((D(r['SALES']) for r in subset),D(0))
 assert rec['orders']==len({r['ORDERNUMBER'] for r in subset})
assert len({r['PRODUCTCODE'] for r in rows})==109
assert con.execute('SELECT SUM(frequency) FROM customer_rfm').fetchone()[0]==307
assert con.execute('SELECT COUNT(*) FROM customer_rfm').fetchone()[0]==92
assert con.execute("SELECT COUNT(*) FROM customer_rfm WHERE segment='Champions'").fetchone()[0]==17

# Validate the portable import against the source, including all 25 columns.
portable=(ROOT/'sql/01b_import_portable.sql').read_text()
statements=re.findall(r'INSERT INTO sales .*?;\n',portable,re.S)
check=sqlite3.connect(':memory:');check.execute('CREATE TABLE sales ('+','.join(cols)+')')
for stmt in statements:check.execute(stmt)
assert check.execute('SELECT COUNT(*) FROM sales').fetchone()[0]==len(rows)
for actual,r in zip(check.execute('SELECT * FROM sales'),rows):
 for c,v in zip(cols,actual):
  expected=r[c] or None
  if c in ints:assert int(v)==int(expected)
  elif c in nums:assert D(str(v))==D(expected)
  elif c=='ORDERDATE':assert v==dt.datetime.strptime(expected,'%m/%d/%Y %H:%M').isoformat(' ')
  else:assert v==expected
kpis=outputs['04_sales_kpi_analysis_1.csv'];monthly=outputs['05_revenue_trends_1.csv'];products=outputs['06_product_analysis_1.csv'];countries=outputs['08_geographic_analysis_1.csv'];top=outputs['07_customer_analysis_1.csv'];segments=outputs['09_customer_segmentation_2.csv']
quality={'rows':len(rows),'columns':len(cols),'sha256':hashlib.sha256(raw).hexdigest(),'duplicate_keys':0,'invalid_numeric_lines':0,'calendar_mismatches':0,'order_attribute_conflicts':0,'price_sales_mismatch_lines':sum(abs(D(r['SALES'])-D(r['PRICEEACH'])*D(r['QUANTITYORDERED']))>D('.01') for r in rows),'priceeach_100_lines':sum(D(r['PRICEEACH'])==100 for r in rows),'missing':{c:sum(not r[c] for r in rows) for c in cols},'sql_result_files':len(outputs),'validation':'PASS: CSV/Decimal, SQLite analysis logic, portable INSERT all-column round trip. MySQL server execution not completed: installed 9.3.0 server crashed during isolated initialization.'}
(ROOT/'reports/validation.json').write_text(json.dumps(quality,indent=2)+'\n')
metrics={'kpis':kpis,'monthly':monthly,'products':products,'countries':countries,'top_customers':top,'segments':segments}
(ROOT/'reports/metrics.json').write_text(json.dumps(metrics,indent=2)+'\n')
# Self-contained HTML report using only built-in browser rendering.
sections=[]
for title,data,key in [('Monthly sales',monthly,'month'),('Product lines',products,'PRODUCTLINE'),('Countries',countries,'COUNTRY')]:
 maxsales=max(x['sales'] for x in data)
 sections.append('<h2>'+title+'</h2>'+''.join('<div class="row"><span>'+html.escape(str(x[key]))+'</span><div class="bar" style="width:'+str(65*x['sales']/maxsales)+'%"></div><b>'+f"{x['sales']:,.2f}"+'</b></div>' for x in data))
page='''<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Sales Performance Tracker</title><style>body{font:16px system-ui;background:#f5f7fb;color:#17314a;max-width:1050px;margin:40px auto;padding:20px}h1{font-size:36px}.cards{display:flex;flex-wrap:wrap;gap:16px}.card{background:white;padding:22px;border-radius:12px}.card b{display:block;font-size:27px}h2{margin-top:40px}.row{display:flex;align-items:center;gap:12px;margin:10px 0}.row span{width:150px;flex-shrink:0}.row b{font-size:13px}.bar{height:18px;background:#087f8c;border-radius:4px}footer{margin-top:45px;font-size:13px}</style><h1>Sales Performance Tracker</h1><p>Sample retail order-line data · January 2003–May 2005 · All statuses · Currency unspecified</p><div class="cards">'''+''.join('<div class="card">'+name+'<b>'+value+'</b></div>' for name,value in [('Recorded sales',f"{kpis[0]['sales']:,.2f}"),('Orders',str(kpis[0]['orders'])),('Customers',str(kpis[0]['customers'])),('Average order value',f"{kpis[0]['average_order_value']:,.2f}")])+'</div><p>Shipped-only sales: '+f"{kpis[1]['sales']:,.2f}"+'. 2005 is partial; monthly changes describe this sample, not a forecast.</p>'+''.join(sections)+'<footer>Sample Sales Data by kyanyoga · <a href="https://www.kaggle.com/datasets/kyanyoga/sample-sales-data">Source</a> · <a href="https://creativecommons.org/licenses/by-nc-sa/3.0/">CC BY-NC-SA 3.0</a>. Aggregated from supplied CSV; see ATTRIBUTION.md for provenance limitations.</footer></html>'
(ROOT/'dashboards/sales_dashboard.html').write_text(page)
print(json.dumps({'quality':quality,'kpis':kpis,'top_product':products[0],'top_country':countries[0],'top_customer':top[0],'peak_month':max(monthly,key=lambda x:x['sales']),'repeat':outputs['07_customer_analysis_2.csv'],'jan_may':outputs['05_revenue_trends_2.csv'],'segments':segments},indent=2))
