-- DATA CLEANING
-- Project: Sales Data Analysis
-- ============================================================

USE world;

-- Checking the table structure
DESCRIBE sales_data_sample;

-- ORDERDATE was stored as text, not as a date
-- This means we cant sort or filter by date properly
ALTER TABLE sales_data_sample
ADD COLUMN ORDER_DATE_CLEAN DATETIME;

-- Converting text dates to proper date format
SET sql_safe_updates = 0;

UPDATE sales_data_sample
SET ORDER_DATE_CLEAN = STR_TO_DATE(ORDERDATE, '%m/%d/%Y %H:%i');

-- Checking if any rows failed -- result was 0, all good!
SELECT COUNT(*) AS null_dates
FROM sales_data_sample
WHERE ORDER_DATE_CLEAN IS NULL;

-- 70 rows had empty POSTALCODE, all from USA
UPDATE sales_data_sample
SET POSTALCODE = 'N/A'
WHERE POSTALCODE IS NULL OR POSTALCODE = '';

-- 1173 rows had empty STATE, mostly non-USA countries
UPDATE sales_data_sample
SET STATE = 'N/A'
WHERE STATE IS NULL OR STATE = '';

-- ADDRESSLINE2 was left empty on purpose, its an optional field