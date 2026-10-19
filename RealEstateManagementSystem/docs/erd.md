# Current database relationships

```mermaid
erDiagram
    Owners ||--o{ Properties : owns
    Locations ||--o{ Properties : locates
    Agencies ||--o{ Agents : employs
    Properties ||--o{ Listings : has
    Agents ||--o{ Listings : manages
    Listings ||--o| Transactions : closes
    Buyers ||--o{ Transactions : purchases
    Owners ||--o{ Transactions : sells
    Transactions ||--o| Commissions : earns
    Properties ||--o{ LeaseAgreements : leased_under
    Tenants ||--o{ LeaseAgreements : signs
    LeaseAgreements ||--o| Rentals : priced_by
    Rentals ||--o{ RentCharges : billed_as
    RentCharges ||--o{ Payments : settled_by
    Properties ||--o{ MaintenanceRequests : requires
    Tenants o|--o{ MaintenanceRequests : reports
    Properties ||--o{ Inspections : inspected
    Properties ||--o{ LegalDocuments : documented
```

Each property is an individually rentable asset. Lease intervals use an exclusive end date.
A charge represents one rental billing period. Multiple payment rows support partial settlement;
each payment belongs to exactly one charge. A sale references its listing, which determines its
property and agent. Seller identity is stored separately to preserve the historical seller.
One commission record per sale is supported; commission splits are outside this demo's scope.

The two root-level PDFs describe the original group coursework, not this revised schema.
