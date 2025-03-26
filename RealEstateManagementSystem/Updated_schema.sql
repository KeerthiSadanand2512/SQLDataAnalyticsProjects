Drop database if exists real_estate;
CREATE DATABASE real_estate;
USE real_estate;
Drop tables if exists Owners;
Drop tables if exists Locations;
Drop tables if exists Properties;
Drop tables if exists Agencies;
Drop tables if exists Agents;
Drop tables if exists Listings;
Drop tables if exists Buyers;
Drop tables if exists Transactions;
Drop tables if exists Tenants;
Drop tables if exists LeaseAgreements;
Drop tables if exists Rentals;
Drop tables if exists Payments;
Drop tables if exists Inspections;
Drop tables if exists MaintenanceRequests;
Drop tables if exists LegalDocuments;
Drop tables if exists Commissions;

-- Owners Table
CREATE TABLE Owners (
    owner_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL CHECK (email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
    phone VARCHAR(20) NOT NULL CHECK (phone REGEXP '^[0-9]{10,15}$'),
    address TEXT
);

-- Locations Table
CREATE TABLE Locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    zipcode VARCHAR(10) NOT NULL CHECK (zipcode REGEXP '^[0-9]{5}(-[0-9]{4})?$'),
    country VARCHAR(100) NOT NULL
);

-- Properties Table
CREATE TABLE Properties (
    property_id INT PRIMARY KEY AUTO_INCREMENT,
    owner_id INT,
    location_id INT,
    property_type ENUM('Apartment', 'House', 'Condo', 'Land', 'Commercial') NOT NULL,
    size DECIMAL(10,2) CHECK (size > 0),
    price DECIMAL(12,2) NOT NULL CHECK (price > 0),
    status ENUM('Available', 'Sold', 'Rented') NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES Owners(owner_id) ON DELETE SET NULL,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id) ON DELETE SET NULL
);

-- Agencies Table
CREATE TABLE Agencies (
    agency_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) UNIQUE NOT NULL
);

-- Agents Table
CREATE TABLE Agents (
    agent_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL CHECK (email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
    phone VARCHAR(20) NOT NULL CHECK (phone REGEXP '^[0-9]{10,15}$'),
    agency_id INT,
    FOREIGN KEY (agency_id) REFERENCES Agencies(agency_id) ON DELETE SET NULL
);

-- Listings Table
CREATE TABLE Listings (
    listing_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT,
    agent_id INT,
    listing_date DATE NOT NULL,
    expiration_date DATE,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES Agents(agent_id) ON DELETE SET NULL
);

-- Buyers Table
CREATE TABLE Buyers (
    buyer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL CHECK (email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
    phone VARCHAR(20) NOT NULL CHECK (phone REGEXP '^[0-9]{10,15}$')
);

-- Transactions Table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT,
    buyer_id INT,
    agent_id INT,
    transaction_date DATE NOT NULL,
    sale_price DECIMAL(12,2) NOT NULL CHECK (sale_price > 0),
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (buyer_id) REFERENCES Buyers(buyer_id) ON DELETE SET NULL,
    FOREIGN KEY (agent_id) REFERENCES Agents(agent_id) ON DELETE SET NULL
);

-- Tenants Table
CREATE TABLE Tenants (
    tenant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL CHECK (email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
    phone VARCHAR(20) NOT NULL CHECK (phone REGEXP '^[0-9]{10,15}$')
);

-- Lease Agreements Table
CREATE TABLE LeaseAgreements (
    lease_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT,
    tenant_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    terms TEXT,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES Tenants(tenant_id) ON DELETE CASCADE
);

-- Rentals Table
CREATE TABLE Rentals (
    rental_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT,
    lease_id INT UNIQUE,
    rent_amount DECIMAL(10,2) NOT NULL CHECK (rent_amount > 0),
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (lease_id) REFERENCES LeaseAgreements(lease_id) ON DELETE CASCADE
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    rental_id INT,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    method ENUM('Credit Card', 'Bank Transfer', 'Cash', 'Cheque') NOT NULL,
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id) ON DELETE CASCADE
);

-- Inspections Table
CREATE TABLE Inspections (
    inspection_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    inspector_name VARCHAR(255) NOT NULL,
    inspection_date DATE NOT NULL,
    findings TEXT,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE
);


-- MaintenanceRequests Table
CREATE TABLE MaintenanceRequests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    tenant_id INT,  -- Allow tenant_id to be NULL
    request_date DATE NOT NULL,
    status ENUM('Pending', 'In Progress', 'Completed') DEFAULT 'Pending',
    details TEXT,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES Tenants(tenant_id) ON DELETE SET NULL
);



--  LegalDocuments Table
CREATE TABLE LegalDocuments (
    document_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    document_type ENUM('Lease Agreement', 'Ownership Document', 'Inspection Report', 'Other') NOT NULL,
    document_text TEXT,
    upload_date DATE NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE
);


-- Commission Table
CREATE TABLE Commissions (
    commission_id INT PRIMARY KEY AUTO_INCREMENT,
    agent_id INT NOT NULL,
    transaction_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    FOREIGN KEY (agent_id) REFERENCES Agents(agent_id) ON DELETE CASCADE,
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id) ON DELETE CASCADE
);











-- Properties Table
-- Index on owner_id and location_id to speed up lookups by owner or location:
CREATE INDEX idx_properties_owner ON Properties(owner_id);
CREATE INDEX idx_properties_location ON Properties(location_id);
-- Index on status if queries frequently filter by property status:
CREATE INDEX idx_properties_status ON Properties(status);

-- Listings Table
-- Index on property_id and agent_id to optimize searches for properties listed by agents:
CREATE INDEX idx_listings_property ON Listings(property_id);
CREATE INDEX idx_listings_agent ON Listings(agent_id);
-- Index on listing_date for filtering by recent listings:
CREATE INDEX idx_listings_date ON Listings(listing_date);

-- Transactions Table
-- Index on property_id, buyer_id, and agent_id to speed up sales history lookups:
CREATE INDEX idx_transactions_property ON Transactions(property_id);
CREATE INDEX idx_transactions_buyer ON Transactions(buyer_id);
CREATE INDEX idx_transactions_agent ON Transactions(agent_id);
-- Index on transaction_date for filtering by sale date:
CREATE INDEX idx_transactions_date ON Transactions(transaction_date);

-- Rentals Table
-- Index on property_id for faster rental queries:
CREATE INDEX idx_rentals_property ON Rentals(property_id);
-- Index on lease_id since it's unique and referenced often:
CREATE UNIQUE INDEX idx_rentals_lease ON Rentals(lease_id);

-- Payments Table
-- Index on rental_id for quicker payment lookups:
CREATE INDEX idx_payments_rental ON Payments(rental_id);
-- Index on payment_date for sorting and filtering payments by date:
CREATE INDEX idx_payments_date ON Payments(payment_date);


-- MaintenanceRequests Table
-- Index on property_id and tenant_id for quicker maintenance request lookups:
CREATE INDEX idx_maintenance_property ON MaintenanceRequests(property_id);
CREATE INDEX idx_maintenance_tenant ON MaintenanceRequests(tenant_id);
-- Index on status to speed up filtering by request status:
CREATE INDEX idx_maintenance_status ON MaintenanceRequests(status);

-- Inspections Table
-- Index on property_id to speed up inspections search:
CREATE INDEX idx_inspections_property ON Inspections(property_id);
-- Index on inspection_date for sorting/filtering by inspection date:
CREATE INDEX idx_inspections_date ON Inspections(inspection_date);

-- Agents Table
-- Index on email and phone for quick lookups:
CREATE UNIQUE INDEX idx_agents_email ON Agents(email);
CREATE UNIQUE INDEX idx_agents_phone ON Agents(phone);
-- Index on agency_id for filtering agents by their agency:
CREATE INDEX idx_agents_agency ON Agents(agency_id);

-- For Filtering and Sorting
-- If queries frequently involve filtering by multiple columns, composite indexes will improve performance.
-- Transactions
-- If you often search for transactions by agent and date, use:
CREATE INDEX idx_transactions_agent_date ON Transactions(agent_id, transaction_date);
-- This helps with queries like:
-- SELECT * FROM Transactions WHERE agent_id = 5 AND transaction_date >= '2025-01-01';
-- Listings
-- If you often filter properties by agent and status, use:
CREATE INDEX idx_listings_agent_status ON Listings(agent_id, listing_date);
-- This helps with:
-- SELECT * FROM Listings WHERE agent_id = 10 ORDER BY listing_date DESC;
-- Rentals
-- If you often query rentals by property and rent amount, use:
CREATE INDEX idx_rentals_property_rent ON Rentals(property_id, rent_amount);
-- This speeds up:
-- SELECT * FROM Rentals WHERE property_id = 20 AND rent_amount > 1500;

-- ALter commands : Add column to owners table
ALTER TABLE owners
ADD COLUMN owners_address varchar(255);

-- Alter commands : Modify column to owners table
ALTER TABLE owners
MODIFY COLUMN owners_address varchar(100);

-- Alter commands : Drop or remove column to owners table 
ALTER TABLE owners
DROP COLUMN owners_address ;

-- Drop Command : Permanently remove table , column or index from the database
DROP TABLE agents_agencies;
DROP INDEX idx_rentals_property_rent ON Rentals;