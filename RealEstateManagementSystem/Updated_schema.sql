-- Run once in an empty database. No existing database is dropped.
CREATE DATABASE IF NOT EXISTS real_estate CHARACTER SET utf8mb4;
USE real_estate;

CREATE TABLE Owners (
owner_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Buyers (
buyer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Tenants (
tenant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Locations (
location_id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    zipcode VARCHAR(10) NOT NULL,
    country CHAR(2) NOT NULL DEFAULT 'US',
    UNIQUE (city, state, zipcode, country),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Agencies (
agency_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Agents (
agent_id INT PRIMARY KEY AUTO_INCREMENT,
    agency_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (agency_id) REFERENCES Agencies(agency_id) ON DELETE RESTRICT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Properties (
property_id INT PRIMARY KEY AUTO_INCREMENT,
    owner_id INT NOT NULL,
    location_id INT NOT NULL,
    street_address VARCHAR(200) NOT NULL,
    unit_number VARCHAR(20) NOT NULL DEFAULT '',
    property_type ENUM('Apartment','House','Condo','Land','Commercial') NOT NULL,
    size_sqft DECIMAL(12,2) NOT NULL CHECK (size_sqft > 0),
    asking_price DECIMAL(12,2) NOT NULL CHECK (asking_price > 0),
    status ENUM('Available','Sold','Rented','Archived') NOT NULL,
    UNIQUE (location_id, street_address, unit_number),
    INDEX idx_property_status_location (status, location_id),
    FOREIGN KEY (owner_id) REFERENCES Owners(owner_id) ON DELETE RESTRICT,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id) ON DELETE RESTRICT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Listings (
listing_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    agent_id INT NOT NULL,
    listing_type ENUM('Sale','Rent') NOT NULL,
    listing_date DATE NOT NULL,
    expiration_date DATE NOT NULL,
    closed_date DATE,
    asking_price DECIMAL(12,2) NOT NULL CHECK (asking_price > 0),
    CHECK (expiration_date >= listing_date),
    CHECK (closed_date IS NULL OR closed_date >= listing_date),
    INDEX idx_listing_agent_date (agent_id, listing_date),
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE RESTRICT,
    FOREIGN KEY (agent_id) REFERENCES Agents(agent_id) ON DELETE RESTRICT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Transactions (
transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    listing_id INT NOT NULL UNIQUE,
    buyer_id INT NOT NULL,
    seller_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    sale_price DECIMAL(12,2) NOT NULL CHECK (sale_price > 0),
    INDEX idx_transaction_date (transaction_date),
    FOREIGN KEY (listing_id) REFERENCES Listings(listing_id) ON DELETE RESTRICT,
    FOREIGN KEY (buyer_id) REFERENCES Buyers(buyer_id) ON DELETE RESTRICT,
    FOREIGN KEY (seller_id) REFERENCES Owners(owner_id) ON DELETE RESTRICT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE LeaseAgreements (
lease_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    tenant_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    terms TEXT,
    CHECK (end_date > start_date),
    INDEX idx_lease_property_dates (property_id, start_date, end_date),
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE RESTRICT,
    FOREIGN KEY (tenant_id) REFERENCES Tenants(tenant_id) ON DELETE RESTRICT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Rentals (
rental_id INT PRIMARY KEY AUTO_INCREMENT,
    lease_id INT NOT NULL UNIQUE,
    rent_amount DECIMAL(10,2) NOT NULL CHECK (rent_amount > 0),
    FOREIGN KEY (lease_id) REFERENCES LeaseAgreements(lease_id) ON DELETE RESTRICT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE RentCharges (
charge_id INT PRIMARY KEY AUTO_INCREMENT,
    rental_id INT NOT NULL,
    period_start DATE NOT NULL,
    due_date DATE NOT NULL,
    amount_due DECIMAL(10,2) NOT NULL CHECK (amount_due > 0),
    UNIQUE (rental_id, period_start),
    INDEX idx_charge_due_date (due_date),
    CHECK (due_date >= period_start),
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id) ON DELETE RESTRICT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Payments (
payment_id INT PRIMARY KEY AUTO_INCREMENT,
    charge_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    method ENUM('Credit Card','Bank Transfer','Cash','Cheque') NOT NULL,
    reference_code VARCHAR(80) NOT NULL UNIQUE,
    INDEX idx_payment_charge_date (charge_id, payment_date),
    INDEX idx_payment_date (payment_date),
    FOREIGN KEY (charge_id) REFERENCES RentCharges(charge_id) ON DELETE RESTRICT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Inspections (
inspection_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    inspector_name VARCHAR(150) NOT NULL,
    inspection_date DATE NOT NULL,
    findings TEXT,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE RESTRICT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE MaintenanceRequests (
request_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    tenant_id INT,
    request_date DATE NOT NULL,
    completed_date DATE,
    status ENUM('Pending','In Progress','Completed') NOT NULL DEFAULT 'Pending',
    cost DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (cost >= 0),
    details TEXT NOT NULL,
    CHECK (completed_date IS NULL OR completed_date >= request_date),
    CHECK ((status = 'Completed' AND completed_date IS NOT NULL)
        OR (status <> 'Completed' AND completed_date IS NULL)),
    INDEX idx_maintenance_status_date (status, request_date),
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE RESTRICT,
    FOREIGN KEY (tenant_id) REFERENCES Tenants(tenant_id) ON DELETE RESTRICT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE LegalDocuments (
document_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT NOT NULL,
    document_type ENUM('Lease Agreement','Ownership Document','Inspection Report','Other') NOT NULL,
    document_text TEXT NOT NULL,
    upload_date DATE NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE RESTRICT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Commissions (
commission_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id) ON DELETE RESTRICT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;
