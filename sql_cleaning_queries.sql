-- Step 1: Create Database
USE anjli3;

SET SQL_SAFE_UPDATES = 0;

-- Step 2: Check Raw Data 
SELECT * FROM funnel_data LIMIT 100;

-- Step 3: Check Null Values
SELECT
    SUM(CASE WHEN Device IS NULL THEN 1 ELSE 0 END) AS missing_device,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS missing_region,
    SUM(CASE WHEN Revenue IS NULL THEN 1 ELSE 0 END) AS missing_revenue
FROM funnel_data;

-- STEP 4 : REMOVE EXTRA SPACES
UPDATE funnel_data
SET Event = LOWER(TRIM(Event));

-- STEP 5 : STANDARDIZE EVENT COLUMN
-- Convert all text into lowercase

UPDATE funnel_data
SET Event = LOWER(Event);

-- STEP 6 : STANDARDIZE DEVICE COLUMN

UPDATE funnel_data
SET Device = LOWER(Device);

-- STEP 7 : STANDARDIZE REGION COLUMN

UPDATE funnel_data
SET Region = LOWER(Region);

-- STEP 8 : HANDLE MISSING DEVICE VALUES
-- Replace NULL with 'unknown'

UPDATE funnel_data
SET Device = 'unknown'
WHERE Device IS NULL;

-- STEP 9 : HANDLE MISSING REGION VALUES

UPDATE funnel_data
SET Region = 'unknown'
WHERE Region IS NULL;

-- STEP 10 : HANDLE MISSING REVENUE VALUES
-- Replace NULL revenue with 0

UPDATE funnel_data
SET Revenue = 0
WHERE Revenue IS NULL;

-- STEP 11 : CHECK DUPLICATE RECORDS

SELECT
    User_ID,
    Session_ID,
    Event,
    Timestamp,
    COUNT(*) AS duplicate_count
FROM funnel_data
GROUP BY User_ID, Session_ID, Event, Timestamp
HAVING COUNT(*) > 1;

-- STEP 12 : REMOVE DUPLICATES
DELETE t1
FROM funnel_data t1
JOIN funnel_data t2
ON t1.User_ID = t2.User_ID
AND t1.Session_ID = t2.Session_ID
AND t1.Event = t2.Event
AND t1.Timestamp = t2.Timestamp
AND t1.User_ID > t2.User_ID;

-- STEP 13 : CHECK UNIQUE VALUES
SELECT DISTINCT Event
FROM funnel_data;

SELECT DISTINCT Device
FROM funnel_data;

SELECT DISTINCT Region
FROM funnel_data;

-- STEP 14 : CHECK FOR NULL TIMESTAMP

SELECT *
FROM funnel_data
WHERE Timestamp IS NULL;

SELECT *
FROM funnel_data
WHERE Region IS NULL
   OR Device IS NULL;
   
UPDATE funnel_data
SET Region = 'unknown'
WHERE Region IS NULL;

UPDATE funnel_data
SET Device = 'unknown'
WHERE Device IS NULL;

UPDATE funnel_data
SET Region = 'unknown'
WHERE Region = '';

UPDATE funnel_data
SET Device = 'unknown'
WHERE Device = '';

-- STEP 15 : CREATE CLEANED DATA TABLE
CREATE TABLE cleaned_funnel_data AS
SELECT *
FROM funnel_data;