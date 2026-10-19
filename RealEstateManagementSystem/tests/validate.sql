USE real_estate;
-- Fail the script if a fixture, financial invariant, or negative check is wrong.
DELIMITER $$
CREATE PROCEDURE validate_demo()
BEGIN
    DECLARE rejected BOOLEAN DEFAULT FALSE;
    IF (SELECT COUNT(*) FROM Properties) <> 18 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Expected 18 properties'; END IF;
    IF (SELECT SUM(sale_price) FROM Transactions WHERE YEAR(transaction_date)=2024) <> 960000 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '2024 volume mismatch'; END IF;
    IF (SELECT SUM(sale_price) FROM Transactions WHERE YEAR(transaction_date)=2025) <> 1050000 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '2025 volume mismatch'; END IF;
    IF (SELECT SUM(amount_due) FROM RentCharges) <> 97200 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Expected rent mismatch'; END IF;
    IF (SELECT SUM(amount) FROM Payments) <> 95350 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Collected rent mismatch'; END IF;
    IF (SELECT SUM(c.amount_due - COALESCE(p.paid,0)) FROM RentCharges c LEFT JOIN
        (SELECT charge_id, SUM(amount) AS paid FROM Payments WHERE payment_date <= '2025-12-31' GROUP BY charge_id) p USING (charge_id)
        WHERE c.due_date < '2025-12-31') <> 1850 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Overdue balance mismatch'; END IF;
    IF EXISTS (SELECT 1 FROM LeaseAgreements a JOIN LeaseAgreements b ON a.property_id=b.property_id AND a.lease_id<b.lease_id AND a.start_date<b.end_date AND b.start_date<a.end_date) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Overlapping lease'; END IF;
    IF EXISTS (SELECT 1 FROM RentCharges c JOIN Rentals r USING(rental_id) JOIN LeaseAgreements l USING(lease_id) WHERE c.period_start<l.start_date OR c.period_start>=l.end_date OR c.due_date>=l.end_date) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Charge outside lease'; END IF;
    IF EXISTS (SELECT 1 FROM Transactions t JOIN Listings l USING(listing_id) WHERE l.listing_type<>'Sale' OR t.transaction_date<l.listing_date OR t.transaction_date>l.expiration_date OR l.closed_date IS NULL OR l.closed_date<>t.transaction_date) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid sale listing'; END IF;
    IF EXISTS (SELECT 1 FROM Payments GROUP BY charge_id HAVING SUM(amount)>(SELECT amount_due FROM RentCharges WHERE charge_id=Payments.charge_id)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Overpayment'; END IF;
    START TRANSACTION;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET rejected = TRUE;
        INSERT INTO LeaseAgreements(property_id,tenant_id,start_date,end_date) VALUES(13,1,'2025-12-01','2025-01-01');
    END;
    IF NOT rejected THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid dates accepted'; END IF;
    SET rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET rejected = TRUE;
        INSERT INTO Payments(charge_id,payment_date,amount,method,reference_code) VALUES(1,'2025-01-05',-1,'Cash','TEST-INVALID');
    END;
    IF NOT rejected THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Negative payment accepted'; END IF;
    SET rejected = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET rejected = TRUE;
        DELETE FROM Properties WHERE property_id=1;
    END;
    IF NOT rejected THEN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Historical property deleted'; END IF;
    ROLLBACK;
    SELECT 'PASS: fixtures, financial totals, relationships, and negative checks' AS validation_result;
END$$
DELIMITER ;
CALL validate_demo();
DROP PROCEDURE validate_demo;
