# Data dictionary

Grain: one order line. Key: `(ORDERNUMBER, ORDERLINENUMBER)`. Customer name is the available customer identifier; no customer ID is supplied. Blank optional fields become SQL NULL. Currency is not documented.

| CSV / SQL column | MySQL type | Meaning |
|---|---|---|
| ORDERNUMBER | INT | Ordernumber |
| QUANTITYORDERED | INT | Quantityordered |
| PRICEEACH | DECIMAL(14,2) | Supplied unit price; frequently capped at 100 |
| ORDERLINENUMBER | INT | Orderlinenumber |
| SALES | DECIMAL(14,2) | Supplied line sales value; primary measure |
| ORDERDATE | DATETIME | Original m/d/yyyy H:MM; normalized to DATETIME |
| STATUS | VARCHAR(255) | Status |
| QTR_ID | INT | Supplied quarter 1–4 |
| MONTH_ID | INT | Month Id |
| YEAR_ID | INT | Year Id |
| PRODUCTLINE | VARCHAR(255) | Productline |
| MSRP | INT | Manufacturer suggested retail price |
| PRODUCTCODE | VARCHAR(255) | Productcode |
| CUSTOMERNAME | VARCHAR(255) | Customername |
| PHONE | VARCHAR(255) | Phone |
| ADDRESSLINE1 | VARCHAR(255) | Addressline1 |
| ADDRESSLINE2 | VARCHAR(255) | Addressline2 |
| CITY | VARCHAR(255) | City |
| STATE | VARCHAR(255) | State |
| POSTALCODE | VARCHAR(255) | Postalcode |
| COUNTRY | VARCHAR(255) | Country |
| TERRITORY | VARCHAR(255) | Source territory code; NA means North America |
| CONTACTLASTNAME | VARCHAR(255) | Contactlastname |
| CONTACTFIRSTNAME | VARCHAR(255) | Contactfirstname |
| DEALSIZE | VARCHAR(255) | Supplied line-level deal size, not an order segment |
