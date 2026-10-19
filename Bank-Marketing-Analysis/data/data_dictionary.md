# Data dictionary

Grain: one source campaign record describing a client and last contact; uniqueness of people is unknown. All 41,188 rows retained. Original authoritative definitions: `bank-additional-names.txt`.

| Source field | SQL field | Meaning |
|---|---|---|
| age | age | Age in years |
| job | job | Occupation category |
| marital | marital | Marital category |
| education | education | Education category |
| default | credit_default | Existing credit in default: yes/no/unknown |
| housing | housing | Housing loan: yes/no/unknown |
| loan | loan | Personal loan: yes/no/unknown |
| contact | contact | Cellular or telephone |
| month | month | Last-contact month; no year supplied |
| day_of_week | day_of_week | Last-contact weekday |
| duration | duration | Last-call seconds; retrospective |
| campaign | campaign | Current campaign contacts including last contact |
| pdays | pdays | Days since previous campaign contact; 999 means never contacted |
| previous | previous | Number of prior-campaign contacts |
| poutcome | poutcome | Previous outcome: success/failure/nonexistent |
| emp.var.rate | emp_var_rate | Quarterly employment variation rate |
| cons.price.idx | cons_price_idx | Monthly consumer price index |
| cons.conf.idx | cons_conf_idx | Monthly consumer confidence index |
| euribor3m | euribor3m | Daily three-month Euribor rate |
| nr.employed | nr_employed | Quarterly number employed indicator |
| y | y | Term deposit subscribed: yes/no |

Derived fields: `record_id` is one-based source row position; `subscribed` is 1 for yes and 0 for no; `age_band` groups under 30, 30–39, 40–49, 50–59, and 60+; `contact_band` groups 1, 2, 3, 4–5, and 6+ campaign contacts.

Conversion (%) = 100 × subscriptions / records. Lift = segment conversion / overall conversion. Lift is descriptive, not incremental causal uplift. `unknown` is preserved as a category; it does not mean no. No source field is imputed.
