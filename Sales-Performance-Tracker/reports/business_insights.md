# Sales Performance Tracker — business findings

## Executive view
The supplied sample records **10,032,628.85** in line sales across **307 orders**, **92 customers**, **109 products**, and **99,067 units**. Average order value is **32,679.57**. These figures include every status; shipped-only sales are **9,291,501.08** across **286 orders**. Values have no confirmed currency and are not profit or recognized revenue.

## Findings and actions
| Finding | Evidence | Practical next step |
|---|---|---|
| Classic Cars leads the mix | 3,919,615.66; 39.07% of all-status sales | Review availability and demand by SKU before prioritizing inventory. |
| USA is the largest market | 3,627,982.83; 36.16% share | Investigate country-level service capacity and customer concentration. |
| November 2004 is the largest observed month | 1,089,048.01 across 33 orders | Review historical promotions and order timing; two complete years cannot establish durable seasonality. |
| Euro Shopping Channel is the leading customer | 912,294.11 across 26 orders; 9.09% of sales | Review account service needs and dependence on major customers. |
| Jan–May 2005 exceeds Jan–May 2004 | 1,791,486.71 versus 1,313,317.19; **36.41%** increase | Compare matched periods; 2005 is incomplete and should not be compared with a complete prior year. |
| Repeat ordering is common in this sample | 91 of 92 customers, or 98.91%, have more than one observed order | Treat this as a sample description, not a population retention rate or cohort survival measure. |

## Customer segmentation
RFM snapshot: **2005-06-01**, one day after the last order. Frequency counts distinct orders; monetary sums supplied SALES; recency counts days since latest order. All statuses are included, so labels describe recorded ordering activity. Scores range 1–4 using percentile ranks; equal values keep equal scores and groups need not have equal sizes. Rules are applied in this order: Champions (R/F/M >=3), At risk (R<=2 and F>=3), Loyal (F>=3), Recent / developing (R>=3), then Occasional / inactive. Scores are relative to this sample, not universal business thresholds.

| Segment | Customers | Recorded sales |
|---|---:|---:|
| Champions | 17 | 3,843,324.83 |
| Occasional / inactive | 42 | 3,339,905.86 |
| Recent / developing | 28 | 2,374,362.96 |
| At risk | 4 | 441,595.10 |
| Loyal | 1 | 33,440.10 |

Prioritize the 17 Champions for account care and inspect the 4 At risk accounts for recent activity before proposing outreach. Customer names substitute for customer IDs; no identity resolution was performed.

## Quality and interpretation
- No duplicate order-line keys, invalid numeric values, calendar mismatches, or within-order customer/date/status conflicts were found.
- **1,304 lines** differ from quantity × PRICEEACH by more than 0.01. The same number of rows has PRICEEACH=100, suggesting a cap in that column. Preserve SALES; do not overwrite it with a recomputed value. The cause cannot be established from this file.
- Optional fields are blank on 2,521 ADDRESSLINE2, 1,486 STATE and 76 POSTALCODE records. Blanks become NULL; territory `NA` remains a valid code.
- The date range is 2003-01-06 through 2005-05-31. May 2005 is the last observed month; later missing months are not zero sales.
- No costs, margins, payments, returns ledger or exchange rates are provided. Order statuses alone cannot establish revenue recognition or profitability.

## Validation evidence
See `validation.json`, `metrics.json` and `results/*.csv`. Python Decimal calculations independently reconcile all exported sales totals, and the generated INSERT file round-trips all 25 fields. Analysis queries were executed in SQLite with documented date/function translations. The installed MySQL 9.3.0 server crashed during isolated initialization, so native MySQL execution is **not certified**. Script 10 supplies executable MySQL snapshot assertions for local verification.

Dataset: [Sample Sales Data by kyanyoga](https://www.kaggle.com/datasets/kyanyoga/sample-sales-data), CC BY-NC-SA 3.0 as requested; see `ATTRIBUTION.md` for source and provenance limitations.
