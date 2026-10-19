USE real_estate;
START TRANSACTION;

INSERT INTO Owners (owner_id, name, email, phone) VALUES
(1, 'Demo Owner 1', 'owner1@example.com', '2025550101'),
(2, 'Demo Owner 2', 'owner2@example.com', '2025550102'),
(3, 'Demo Owner 3', 'owner3@example.com', '2025550103'),
(4, 'Demo Owner 4', 'owner4@example.com', '2025550104'),
(5, 'Demo Owner 5', 'owner5@example.com', '2025550105'),
(6, 'Demo Owner 6', 'owner6@example.com', '2025550106');

INSERT INTO Buyers (buyer_id, name, email, phone) VALUES
(1, 'Demo Buyer 1', 'buyer1@example.com', '2025550101'),
(2, 'Demo Buyer 2', 'buyer2@example.com', '2025550102'),
(3, 'Demo Buyer 3', 'buyer3@example.com', '2025550103'),
(4, 'Demo Buyer 4', 'buyer4@example.com', '2025550104'),
(5, 'Demo Buyer 5', 'buyer5@example.com', '2025550105'),
(6, 'Demo Buyer 6', 'buyer6@example.com', '2025550106');

INSERT INTO Tenants (tenant_id, name, email, phone) VALUES
(1, 'Demo Tenant 1', 'tenant1@example.com', '2025550101'),
(2, 'Demo Tenant 2', 'tenant2@example.com', '2025550102'),
(3, 'Demo Tenant 3', 'tenant3@example.com', '2025550103'),
(4, 'Demo Tenant 4', 'tenant4@example.com', '2025550104'),
(5, 'Demo Tenant 5', 'tenant5@example.com', '2025550105'),
(6, 'Demo Tenant 6', 'tenant6@example.com', '2025550106');

INSERT INTO Locations (location_id, city, state, zipcode, country) VALUES
(1, 'New York', 'NY', '10001', 'US'),
(2, 'Chicago', 'IL', '60601', 'US'),
(3, 'Austin', 'TX', '73301', 'US');

INSERT INTO Agencies (agency_id, name) VALUES
(1, 'Demo Urban Realty'),
(2, 'Demo Metro Homes');

INSERT INTO Agents (agent_id, agency_id, name, email) VALUES
(1, 1, 'Demo Agent 1', 'agent1@example.com'),
(2, 1, 'Demo Agent 2', 'agent2@example.com'),
(3, 2, 'Demo Agent 3', 'agent3@example.com'),
(4, 2, 'Demo Agent 4', 'agent4@example.com');

INSERT INTO Properties (property_id, owner_id, location_id, street_address, property_type, size_sqft, asking_price, status) VALUES
(1, 1, 1, '101 Example Avenue', 'House', 1050, 310000, 'Sold'),
(2, 2, 2, '102 Example Avenue', 'Condo', 1100, 320000, 'Sold'),
(3, 3, 3, '103 Example Avenue', 'Apartment', 1150, 330000, 'Sold'),
(4, 4, 1, '104 Example Avenue', 'House', 1200, 340000, 'Sold'),
(5, 5, 2, '105 Example Avenue', 'Condo', 1250, 350000, 'Sold'),
(6, 6, 3, '106 Example Avenue', 'Apartment', 1300, 360000, 'Sold'),
(7, 1, 1, '107 Example Avenue', 'House', 1350, 370000, 'Rented'),
(8, 2, 2, '108 Example Avenue', 'Condo', 1400, 380000, 'Rented'),
(9, 3, 3, '109 Example Avenue', 'Apartment', 1450, 390000, 'Rented'),
(10, 4, 1, '110 Example Avenue', 'House', 1500, 400000, 'Rented'),
(11, 5, 2, '111 Example Avenue', 'Condo', 1550, 410000, 'Rented'),
(12, 6, 3, '112 Example Avenue', 'Apartment', 1600, 420000, 'Rented'),
(13, 1, 1, '113 Example Avenue', 'House', 1650, 430000, 'Available'),
(14, 2, 2, '114 Example Avenue', 'Condo', 1700, 440000, 'Available'),
(15, 3, 3, '115 Example Avenue', 'Apartment', 1750, 450000, 'Available'),
(16, 4, 1, '116 Example Avenue', 'House', 1800, 460000, 'Available'),
(17, 5, 2, '117 Example Avenue', 'Condo', 1850, 470000, 'Available'),
(18, 6, 3, '118 Example Avenue', 'Apartment', 1900, 480000, 'Available');

INSERT INTO Listings (listing_id, property_id, agent_id, listing_type, listing_date, expiration_date, closed_date, asking_price) VALUES
(1, 1, 1, 'Sale', '2024-01-01', '2024-12-31', '2024-01-15', 310000),
(2, 2, 2, 'Sale', '2024-01-01', '2024-12-31', '2024-02-15', 320000),
(3, 3, 3, 'Sale', '2024-01-01', '2024-12-31', '2024-03-15', 330000),
(4, 4, 1, 'Sale', '2025-01-01', '2025-12-31', '2025-01-15', 340000),
(5, 5, 2, 'Sale', '2025-01-01', '2025-12-31', '2025-02-15', 350000),
(6, 6, 3, 'Sale', '2025-01-01', '2025-12-31', '2025-03-15', 360000),
(13, 13, 1, 'Sale', '2025-08-01', '2026-06-30', NULL, 430000),
(14, 14, 2, 'Sale', '2025-08-01', '2026-06-30', NULL, 440000),
(15, 15, 3, 'Sale', '2025-08-01', '2026-06-30', NULL, 450000),
(16, 16, 1, 'Sale', '2025-12-01', '2026-06-30', NULL, 460000),
(17, 17, 2, 'Sale', '2025-12-01', '2026-06-30', NULL, 470000),
(18, 18, 3, 'Sale', '2025-12-01', '2026-06-30', NULL, 480000);

INSERT INTO Transactions (transaction_id, listing_id, buyer_id, seller_id, transaction_date, sale_price) VALUES
(1, 1, 1, 1, '2024-01-15', 310000),
(2, 2, 2, 2, '2024-02-15', 320000),
(3, 3, 3, 3, '2024-03-15', 330000),
(4, 4, 4, 4, '2025-01-15', 340000),
(5, 5, 5, 5, '2025-02-15', 350000),
(6, 6, 6, 6, '2025-03-15', 360000);

INSERT INTO Commissions (commission_id, transaction_id, amount) VALUES
(1, 1, 9300.0),
(2, 2, 9600.0),
(3, 3, 9900.0),
(4, 4, 10200.0),
(5, 5, 10500.0),
(6, 6, 10800.0);

INSERT INTO LeaseAgreements (lease_id, property_id, tenant_id, start_date, end_date, terms) VALUES
(1, 7, 1, '2025-01-01', '2026-01-01', 'Whole property; end date exclusive; monthly rent due on day 5.'),
(2, 8, 2, '2025-01-01', '2026-01-01', 'Whole property; end date exclusive; monthly rent due on day 5.'),
(3, 9, 3, '2025-01-01', '2026-01-01', 'Whole property; end date exclusive; monthly rent due on day 5.'),
(4, 10, 4, '2025-01-01', '2026-01-01', 'Whole property; end date exclusive; monthly rent due on day 5.'),
(5, 11, 5, '2025-01-01', '2026-01-01', 'Whole property; end date exclusive; monthly rent due on day 5.'),
(6, 12, 6, '2025-01-01', '2026-01-01', 'Whole property; end date exclusive; monthly rent due on day 5.');

INSERT INTO Rentals (rental_id, lease_id, rent_amount) VALUES
(1, 1, 1100),
(2, 2, 1200),
(3, 3, 1300),
(4, 4, 1400),
(5, 5, 1500),
(6, 6, 1600);

INSERT INTO RentCharges (charge_id, rental_id, period_start, due_date, amount_due) VALUES
(1, 1, '2025-01-01', '2025-01-05', 1100),
(2, 1, '2025-02-01', '2025-02-05', 1100),
(3, 1, '2025-03-01', '2025-03-05', 1100),
(4, 1, '2025-04-01', '2025-04-05', 1100),
(5, 1, '2025-05-01', '2025-05-05', 1100),
(6, 1, '2025-06-01', '2025-06-05', 1100),
(7, 1, '2025-07-01', '2025-07-05', 1100),
(8, 1, '2025-08-01', '2025-08-05', 1100),
(9, 1, '2025-09-01', '2025-09-05', 1100),
(10, 1, '2025-10-01', '2025-10-05', 1100),
(11, 1, '2025-11-01', '2025-11-05', 1100),
(12, 1, '2025-12-01', '2025-12-05', 1100),
(13, 2, '2025-01-01', '2025-01-05', 1200),
(14, 2, '2025-02-01', '2025-02-05', 1200),
(15, 2, '2025-03-01', '2025-03-05', 1200),
(16, 2, '2025-04-01', '2025-04-05', 1200),
(17, 2, '2025-05-01', '2025-05-05', 1200),
(18, 2, '2025-06-01', '2025-06-05', 1200),
(19, 2, '2025-07-01', '2025-07-05', 1200),
(20, 2, '2025-08-01', '2025-08-05', 1200),
(21, 2, '2025-09-01', '2025-09-05', 1200),
(22, 2, '2025-10-01', '2025-10-05', 1200),
(23, 2, '2025-11-01', '2025-11-05', 1200),
(24, 2, '2025-12-01', '2025-12-05', 1200),
(25, 3, '2025-01-01', '2025-01-05', 1300),
(26, 3, '2025-02-01', '2025-02-05', 1300),
(27, 3, '2025-03-01', '2025-03-05', 1300),
(28, 3, '2025-04-01', '2025-04-05', 1300),
(29, 3, '2025-05-01', '2025-05-05', 1300),
(30, 3, '2025-06-01', '2025-06-05', 1300),
(31, 3, '2025-07-01', '2025-07-05', 1300),
(32, 3, '2025-08-01', '2025-08-05', 1300),
(33, 3, '2025-09-01', '2025-09-05', 1300),
(34, 3, '2025-10-01', '2025-10-05', 1300),
(35, 3, '2025-11-01', '2025-11-05', 1300),
(36, 3, '2025-12-01', '2025-12-05', 1300),
(37, 4, '2025-01-01', '2025-01-05', 1400),
(38, 4, '2025-02-01', '2025-02-05', 1400),
(39, 4, '2025-03-01', '2025-03-05', 1400),
(40, 4, '2025-04-01', '2025-04-05', 1400),
(41, 4, '2025-05-01', '2025-05-05', 1400),
(42, 4, '2025-06-01', '2025-06-05', 1400),
(43, 4, '2025-07-01', '2025-07-05', 1400),
(44, 4, '2025-08-01', '2025-08-05', 1400),
(45, 4, '2025-09-01', '2025-09-05', 1400),
(46, 4, '2025-10-01', '2025-10-05', 1400),
(47, 4, '2025-11-01', '2025-11-05', 1400),
(48, 4, '2025-12-01', '2025-12-05', 1400),
(49, 5, '2025-01-01', '2025-01-05', 1500),
(50, 5, '2025-02-01', '2025-02-05', 1500),
(51, 5, '2025-03-01', '2025-03-05', 1500),
(52, 5, '2025-04-01', '2025-04-05', 1500),
(53, 5, '2025-05-01', '2025-05-05', 1500),
(54, 5, '2025-06-01', '2025-06-05', 1500),
(55, 5, '2025-07-01', '2025-07-05', 1500),
(56, 5, '2025-08-01', '2025-08-05', 1500),
(57, 5, '2025-09-01', '2025-09-05', 1500),
(58, 5, '2025-10-01', '2025-10-05', 1500),
(59, 5, '2025-11-01', '2025-11-05', 1500),
(60, 5, '2025-12-01', '2025-12-05', 1500),
(61, 6, '2025-01-01', '2025-01-05', 1600),
(62, 6, '2025-02-01', '2025-02-05', 1600),
(63, 6, '2025-03-01', '2025-03-05', 1600),
(64, 6, '2025-04-01', '2025-04-05', 1600),
(65, 6, '2025-05-01', '2025-05-05', 1600),
(66, 6, '2025-06-01', '2025-06-05', 1600),
(67, 6, '2025-07-01', '2025-07-05', 1600),
(68, 6, '2025-08-01', '2025-08-05', 1600),
(69, 6, '2025-09-01', '2025-09-05', 1600),
(70, 6, '2025-10-01', '2025-10-05', 1600),
(71, 6, '2025-11-01', '2025-11-05', 1600),
(72, 6, '2025-12-01', '2025-12-05', 1600);

INSERT INTO Payments (payment_id, charge_id, payment_date, amount, method, reference_code) VALUES
(1, 1, '2025-01-05', 1100, 'Bank Transfer', 'DEMO-0001'),
(2, 2, '2025-02-05', 1100, 'Bank Transfer', 'DEMO-0002'),
(3, 3, '2025-03-05', 1100, 'Bank Transfer', 'DEMO-0003'),
(4, 4, '2025-04-05', 1100, 'Bank Transfer', 'DEMO-0004'),
(5, 5, '2025-05-05', 1100, 'Bank Transfer', 'DEMO-0005'),
(6, 6, '2025-06-05', 1100, 'Bank Transfer', 'DEMO-0006'),
(7, 7, '2025-07-05', 1100, 'Bank Transfer', 'DEMO-0007'),
(8, 8, '2025-08-05', 1100, 'Bank Transfer', 'DEMO-0008'),
(9, 9, '2025-09-05', 1100, 'Bank Transfer', 'DEMO-0009'),
(10, 10, '2025-10-05', 1100, 'Bank Transfer', 'DEMO-0010'),
(11, 11, '2025-11-05', 1100, 'Bank Transfer', 'DEMO-0011'),
(12, 12, '2025-12-05', 1100, 'Bank Transfer', 'DEMO-0012'),
(13, 13, '2025-01-05', 1200, 'Bank Transfer', 'DEMO-0013'),
(14, 14, '2025-02-05', 1200, 'Bank Transfer', 'DEMO-0014'),
(15, 15, '2025-03-05', 1200, 'Bank Transfer', 'DEMO-0015'),
(16, 16, '2025-04-05', 1200, 'Bank Transfer', 'DEMO-0016'),
(17, 17, '2025-05-05', 1200, 'Bank Transfer', 'DEMO-0017'),
(18, 18, '2025-06-05', 1200, 'Bank Transfer', 'DEMO-0018'),
(19, 19, '2025-07-05', 1200, 'Bank Transfer', 'DEMO-0019'),
(20, 20, '2025-08-05', 1200, 'Bank Transfer', 'DEMO-0020'),
(21, 21, '2025-09-05', 1200, 'Bank Transfer', 'DEMO-0021'),
(22, 22, '2025-10-05', 1200, 'Bank Transfer', 'DEMO-0022'),
(23, 23, '2025-11-05', 1200, 'Bank Transfer', 'DEMO-0023'),
(24, 25, '2025-01-05', 1300, 'Bank Transfer', 'DEMO-0024'),
(25, 26, '2025-02-05', 1300, 'Bank Transfer', 'DEMO-0025'),
(26, 27, '2025-03-05', 1300, 'Bank Transfer', 'DEMO-0026'),
(27, 28, '2025-04-05', 1300, 'Bank Transfer', 'DEMO-0027'),
(28, 29, '2025-05-05', 1300, 'Bank Transfer', 'DEMO-0028'),
(29, 30, '2025-06-05', 1300, 'Bank Transfer', 'DEMO-0029'),
(30, 31, '2025-07-05', 1300, 'Bank Transfer', 'DEMO-0030'),
(31, 32, '2025-08-05', 1300, 'Bank Transfer', 'DEMO-0031'),
(32, 33, '2025-09-05', 1300, 'Bank Transfer', 'DEMO-0032'),
(33, 34, '2025-10-05', 1300, 'Bank Transfer', 'DEMO-0033'),
(34, 35, '2025-11-05', 1300, 'Bank Transfer', 'DEMO-0034'),
(35, 36, '2025-12-05', 650.0, 'Bank Transfer', 'DEMO-0035'),
(36, 37, '2025-01-05', 1400, 'Bank Transfer', 'DEMO-0036'),
(37, 38, '2025-02-05', 1400, 'Bank Transfer', 'DEMO-0037'),
(38, 39, '2025-03-05', 1400, 'Bank Transfer', 'DEMO-0038'),
(39, 40, '2025-04-05', 1400, 'Bank Transfer', 'DEMO-0039'),
(40, 41, '2025-05-05', 1400, 'Bank Transfer', 'DEMO-0040'),
(41, 42, '2025-06-05', 1400, 'Bank Transfer', 'DEMO-0041'),
(42, 43, '2025-07-05', 1400, 'Bank Transfer', 'DEMO-0042'),
(43, 44, '2025-08-05', 1400, 'Bank Transfer', 'DEMO-0043'),
(44, 45, '2025-09-05', 1400, 'Bank Transfer', 'DEMO-0044'),
(45, 46, '2025-10-05', 1400, 'Bank Transfer', 'DEMO-0045'),
(46, 47, '2025-11-05', 1400, 'Bank Transfer', 'DEMO-0046'),
(47, 48, '2025-12-10', 1400, 'Bank Transfer', 'DEMO-0047'),
(48, 49, '2025-01-05', 1500, 'Bank Transfer', 'DEMO-0048'),
(49, 50, '2025-02-05', 1500, 'Bank Transfer', 'DEMO-0049'),
(50, 51, '2025-03-05', 1500, 'Bank Transfer', 'DEMO-0050'),
(51, 52, '2025-04-05', 1500, 'Bank Transfer', 'DEMO-0051'),
(52, 53, '2025-05-05', 1500, 'Bank Transfer', 'DEMO-0052'),
(53, 54, '2025-06-05', 1500, 'Bank Transfer', 'DEMO-0053'),
(54, 55, '2025-07-05', 1500, 'Bank Transfer', 'DEMO-0054'),
(55, 56, '2025-08-05', 1500, 'Bank Transfer', 'DEMO-0055'),
(56, 57, '2025-09-05', 1500, 'Bank Transfer', 'DEMO-0056'),
(57, 58, '2025-10-05', 1500, 'Bank Transfer', 'DEMO-0057'),
(58, 59, '2025-11-05', 1500, 'Bank Transfer', 'DEMO-0058'),
(59, 60, '2025-12-05', 1500, 'Bank Transfer', 'DEMO-0059'),
(60, 61, '2025-01-05', 1600, 'Bank Transfer', 'DEMO-0060'),
(61, 62, '2025-02-05', 1600, 'Bank Transfer', 'DEMO-0061'),
(62, 63, '2025-03-05', 1600, 'Bank Transfer', 'DEMO-0062'),
(63, 64, '2025-04-05', 1600, 'Bank Transfer', 'DEMO-0063'),
(64, 65, '2025-05-05', 1600, 'Bank Transfer', 'DEMO-0064'),
(65, 66, '2025-06-05', 1600, 'Bank Transfer', 'DEMO-0065'),
(66, 67, '2025-07-05', 1600, 'Bank Transfer', 'DEMO-0066'),
(67, 68, '2025-08-05', 1600, 'Bank Transfer', 'DEMO-0067'),
(68, 69, '2025-09-05', 1600, 'Bank Transfer', 'DEMO-0068'),
(69, 70, '2025-10-05', 1600, 'Bank Transfer', 'DEMO-0069'),
(70, 71, '2025-11-05', 1600, 'Bank Transfer', 'DEMO-0070'),
(71, 72, '2025-12-05', 800, 'Bank Transfer', 'DEMO-0071'),
(72, 72, '2025-12-05', 800, 'Bank Transfer', 'DEMO-0072');

INSERT INTO MaintenanceRequests (request_id, property_id, tenant_id, request_date, completed_date, status, cost, details) VALUES
(1, 7, 1, '2025-03-01', '2025-03-03', 'Completed', 200, 'Repair faucet'),
(2, 7, 1, '2025-06-01', '2025-06-05', 'Completed', 400, 'Repair heating'),
(3, 8, 2, '2025-12-20', NULL, 'Pending', 0, 'Inspect window seal'),
(4, 9, 3, '2025-12-15', NULL, 'In Progress', 100, 'Repair entry lock');

INSERT INTO Inspections (inspection_id, property_id, inspector_name, inspection_date, findings) VALUES
(1, 7, 'Demo Inspector', '2025-02-01', 'Heating inspection recommended');

INSERT INTO LegalDocuments (document_id, property_id, document_type, document_text, upload_date) VALUES
(1, 7, 'Lease Agreement', 'Synthetic demonstration record; no real legal document.', '2025-01-01');

COMMIT;
