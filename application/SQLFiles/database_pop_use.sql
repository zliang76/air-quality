USE air_quality;
SET SQL_SAFE_UPDATES = 0;

-- Creations and populations of tables 

-- 01
-- Creating the area_info table
DROP TABLE IF EXISTS area_info;
CREATE TABLE IF NOT EXISTS area_info(
	areaID INT AUTO_INCREMENT,
	year INT,
    local_site_name VARCHAR(255),
    address VARCHAR(255),
	state_code INT,
    state_name VARCHAR(255),
    county_code INT,
    county_name VARCHAR(255),
    city_name VARCHAR(255),
    site_num INT,
    cbsa_name VARCHAR(255),
    PRIMARY KEY (areaID)
);
-- Populating the area_info table
INSERT INTO area_info( year,local_site_name,state_code, state_name, county_code, county_name, city_name, site_num,cbsa_name)
SELECT year,local_site_name,state_code, state_name, county_code, county_name, city_name, site_num,cbsa_name
FROM air_quality
WHERE local_site_name <>'';

-- 02
-- Creating the site_name table
DROP TABLE IF EXISTS site_name;
CREATE TABLE IF NOT EXISTS site_name(
	local_site_name VARCHAR(255),
    PRIMARY KEY(local_site_name));
    
-- Populating the local_site_name table
INSERT INTO site_name
SELECT local_site_name
FROM air_quality
GROUP BY local_site_name;


-- 03
-- Creating the sample table
DROP TABLE IF EXISTS sample;
CREATE TABLE IF NOT EXISTS sample(
	sampleID INT AUTO_INCREMENT, 
    year INT,
    local_site_name VARCHAR(255),
    sample_duration VARCHAR(255),
    pollutant_standard VARCHAR(255),
    units_of_measure VARCHAR(255) NOT NULL,
    event_type VARCHAR(255),
    PRIMARY KEY(sampleID),
    CONSTRAINT fk_site1 FOREIGN KEY(local_site_name)
    REFERENCES site_name(local_site_name)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
-- Populating the sample table
INSERT INTO sample(year, local_site_name, sample_duration, pollutant_standard, units_of_measure, event_type)
SELECT year, local_site_name, sample_duration, pollutant_standard, units_of_measure, event_type
FROM air_quality
WHERE local_site_name <> '';



-- 04
-- Creating the monitoring_info table
DROP TABLE IF EXISTS monitoring_info;
CREATE TABLE IF NOT EXISTS monitoring_info(
	monitorID INT AUTO_INCREMENT,
    year INT,
	local_site_name VARCHAR(255),
	parameter_code INT,
    parameter_name VARCHAR(255) NOT NULL,
    POC INT,
    latitude INT NOT NULL,
    longitude INT NOT NULL,
    datum VARCHAR(255),
    PRIMARY KEY(monitorID),
    CONSTRAINT fk_site2 FOREIGN KEY(local_site_name)
    REFERENCES site_name(local_site_name)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
-- Populating the monitoring_info table
INSERT INTO monitoring_info(year, local_site_name,parameter_code,parameter_name,POC,latitude,longitude,datum)
SELECT year, local_site_name,parameter_code,parameter_name,poc,latitude,longitude,datum
FROM air_quality
WHERE local_site_name <> '';


-- 05
-- Creating the method table
DROP TABLE IF EXISTS method;
CREATE TABLE IF NOT EXISTS method(
	methodID INT AUTO_INCREMENT,
	year INT,
    local_site_name VARCHAR(255),
	method_name VARCHAR(255),
    metric_used VARCHAR(255) NOT NULL,
    PRIMARY KEY(methodID),
    CONSTRAINT fk_site3 FOREIGN KEY(local_site_name)
    REFERENCES site_name(local_site_name)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
-- Populating the method table
INSERT INTO method(year, local_site_name, method_name,metric_used)
SELECT year, local_site_name, method_name,metric_used
FROM air_quality
WHERE local_site_name <> '';


-- 06
-- Creating the observation table
DROP TABLE IF EXISTS observation;
CREATE TABLE IF NOT EXISTS observation(
	observationID INT AUTO_INCREMENT,
    year INT,
    local_site_name VARCHAR(255),
	observation_count INT,
    observation_percent INT NOT NULL,
    completeness_indicator VARCHAR(255) NOT NULL,
	valid_day_count INT NOT NULL,
    required_day_count INT NOT NULL,
    null_data_count INT NOT NULL,
    certification_indicator VARCHAR(255) NOT NULL,
    PRIMARY KEY(observationID),
    CONSTRAINT fk_site4 FOREIGN KEY(local_site_name)
    REFERENCES site_name(local_site_name)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
-- Populating the observation table
INSERT INTO observation(year,local_site_name, observation_count, observation_percent,completeness_indicator,valid_day_count,
	required_day_count,null_data_count, certification_indicator)
SELECT year,local_site_name, observation_count, observation_percent,completeness_indicator,valid_day_count,
	required_day_count,null_data_count, certification_indicator
FROM air_quality
WHERE local_site_name <> '';


-- 07
-- Creating the air_quality_indicator table
DROP TABLE IF EXISTS air_quality_indicator;
CREATE TABLE IF NOT EXISTS air_quality_indicator(
	qualityID INT AUTO_INCREMENT,
	year INT,
	local_site_name VARCHAR(255),
	num_obs_below_mdl INT,
    arithmetic_mean INT,
    arithmetic_standard_dev INT,
    primary_exceedance_count INT,
    secondary_exceedance_count INT,
    PRIMARY KEY(qualityID),
    CONSTRAINT fk_site5 FOREIGN KEY(local_site_name)
    REFERENCES site_name(local_site_name)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
-- Populating the air_quality_indicator table
INSERT INTO air_quality_indicator(year,local_site_name ,num_obs_below_mdl,arithmetic_mean, 
	arithmetic_standard_dev,primary_exceedance_count,secondary_exceedance_count)
SELECT year,local_site_name ,num_obs_below_mdl,arithmetic_mean, 
	arithmetic_standard_dev,primary_exceedance_count,secondary_exceedance_count
FROM air_quality
WHERE local_site_name <> '';

-- 08
-- Creating the max_values table
DROP TABLE IF EXISTS max_values;
CREATE TABLE IF NOT EXISTS max_values(
	max_valueID INT AUTO_INCREMENT,
	year INT,
    local_site_name VARCHAR(255),
	first_max_value INT NOT NULL,
    first_max_datetime DATETIME,
    second_max_value INT,
    second_max_datetime DATETIME,
    third_max_value INT,
    third_max_datetime DATETIME,
    fourth_max_value INT,
    fourth_max_datetime DATETIME,
    first_max_non_overlapping_value INT,
    first_no_max_datetime DATETIME,
    second_max_non_overlapping_value INT,
    second_no_max_datetime DATETIME,
    PRIMARY KEY(max_valueID),
    CONSTRAINT fk_site6 FOREIGN KEY(local_site_name)
    REFERENCES site_name(local_site_name)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
-- Adjusting columns from the mega-table so we could insert them into new tables
UPDATE air_quality 
SET first_no_max_datetime = NULL 
WHERE first_no_max_datetime < '1000-01-01 00:00:00';

UPDATE air_quality 
SET second_no_max_datetime = NULL 
WHERE second_no_max_datetime < '1000-01-01 00:00:00';

UPDATE air_quality 
SET first_max_datetime = NULL 
WHERE first_max_datetime < '1000-01-01 00:00:00';

UPDATE air_quality 
SET second_max_datetime = NULL 
WHERE second_max_datetime < '1000-01-01 00:00:00';

UPDATE air_quality 
SET third_max_datetime = NULL 
WHERE third_max_datetime < '1000-01-01 00:00:00';

UPDATE air_quality 
SET fourth_max_datetime = NULL 
WHERE fourth_max_datetime < '1000-01-01 00:00:00';

-- Populating the max_values table
INSERT INTO max_values(year,local_site_name,first_max_value,first_max_datetime,second_max_value,second_max_datetime ,
    third_max_value,third_max_datetime, fourth_max_value, fourth_max_datetime, first_max_non_overlapping_value,
    first_no_max_datetime, second_max_non_overlapping_value, second_no_max_datetime)
SELECT year,local_site_name,first_max_value,first_max_datetime,second_max_value,second_max_datetime ,
    third_max_value,third_max_datetime, fourth_max_value, fourth_max_datetime, first_max_non_overlapping_value,
    first_no_max_datetime, second_max_non_overlapping_value, second_no_max_datetime
FROM air_quality
WHERE local_site_name <> '';


-- 09
-- Creating the percentiles table
DROP TABLE IF EXISTS percentiles;
CREATE TABLE IF NOT EXISTS percentiles(
	percentileID INT AUTO_INCREMENT,
    year INT,
	local_site_name VARCHAR(255),
	ninety_nine_percentile INT,
    ninety_eight_percentile INT,
    ninety_five_percentile INT,
    ninety_percentile INT,
    seventy_five_percentile INT,
    fifty_percentile INT,
    ten_percentile INT,
    PRIMARY KEY (percentileID),
    CONSTRAINT fk_site7 FOREIGN KEY(local_site_name)
    REFERENCES site_name(local_site_name)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Populating the percentiles table
INSERT INTO percentiles(year, local_site_name,ninety_nine_percentile, ninety_eight_percentile, ninety_five_percentile, ninety_percentile,
    seventy_five_percentile, fifty_percentile, ten_percentile)
SELECT year, local_site_name,ninety_nine_percentile, ninety_eight_percentile, ninety_five_percentile, ninety_percentile,
    seventy_five_percentile, fifty_percentile, ten_percentile
FROM air_quality
WHERE local_site_name <> '';





-- More advanced SQL implementations: trigger, stored procedure, view

-- 01
-- Create a trigger called percentiles_before_update: before updating the percentiles table, if the data updated in 
-- ninety_nine_percentile column
-- is greater than 100 or 0, signals an error message; if the data updated is between 0 and 1, then times the data with 100
-- and makes it a valid percentile
DROP TRIGGER IF EXISTS percentiles_before_update;

DELIMITER //
CREATE TRIGGER percentiles_before_update1
BEFORE UPDATE
ON percentiles
FOR EACH ROW
BEGIN
	IF NEW.ninety_nine_percentile > 100 OR NEW.ninety_nine_percentile < 0 THEN
    SIGNAL SQLSTATE '22003'
	SET MESSAGE_TEXT = 'The percentile must be a number less than 100 and greater than 0.', MYSQL_ERRNO = 1264;
    ELSEIF NEW.ninety_nine_percentile >= 0 AND NEW.ninety_nine_percentile <= 1 THEN
    SET NEW.ninety_nine_percentile = NEW.ninety_nine_percentile * 100;
    END IF;
END //
DELIMITER ;
-- Test the percentiles_before_update1 trigger by doing an update, should return an error message
UPDATE percentiles
SET ninety_nine_percentile = 110
WHERE percentileID = 1;

-- 02
-- Create a trigger called percentiles_before_update2: before updating the percentiles table, if the data updated in 
-- ninety_eight_percentile column
-- is greater than 100 or 0, signals an error message; if the data updated is between 0 and 1, then times the data with 100
-- and makes it a valid percentile
DROP TRIGGER IF EXISTS percentiles_before_update2;

DELIMITER //
CREATE TRIGGER percentiles_before_update2
BEFORE UPDATE
ON percentiles
FOR EACH ROW
BEGIN
	IF NEW.ninety_eight_percentile > 100 OR NEW.ninety_eight_percentile < 0 THEN
    SIGNAL SQLSTATE '22003'
	SET MESSAGE_TEXT = 'The percentile must be a number less than 100 and greater than 0.', MYSQL_ERRNO = 1264;
    ELSEIF NEW.ninety_eight_percentile >= 0 AND NEW.ninety_eight_percentile <= 1 THEN
    SET NEW.ninety_eight_percentile = NEW.ninety_eight_percentile * 100;
    END IF;
END //
DELIMITER ;
-- Test the percentiles_before_update2 trigger by doing an update, should return an error message
UPDATE percentiles
SET ninety_eight_percentile = 110
WHERE percentileID = 1;

-- 03
-- Create a trigger called percentiles_before_update3: before updating the percentiles table, if the data updated in 
-- ninety_five_percentile column
-- is greater than 100 or 0, signals an error message; if the data updated is between 0 and 1, then times the data with 100
-- and makes it a valid percentile
DROP TRIGGER IF EXISTS percentiles_before_update3;

DELIMITER //
CREATE TRIGGER percentiles_before_update3
BEFORE UPDATE
ON percentiles
FOR EACH ROW
BEGIN
	IF NEW.ninety_five_percentile > 100 OR NEW.ninety_five_percentile < 0 THEN
    SIGNAL SQLSTATE '22003'
	SET MESSAGE_TEXT = 'The percentile must be a number less than 100 and greater than 0.', MYSQL_ERRNO = 1264;
    ELSEIF NEW.ninety_five_percentile >= 0 AND NEW.ninety_five_percentile <= 1 THEN
    SET NEW.ninety_five_percentile = NEW.ninety_five_percentile * 100;
    END IF;
END //
DELIMITER ;
-- Test the percentiles_before_update3 trigger by doing an update, should return an error message
UPDATE percentiles
SET ninety_five_percentile = 110
WHERE percentileID = 1;


-- 04
-- Create a trigger called percentiles_before_update4: before updating the percentiles table, if the data updated in 
-- ninety_percentile column
-- is greater than 100 or 0, signals an error message; if the data updated is between 0 and 1, then times the data with 100
-- and makes it a valid percentile
DROP TRIGGER IF EXISTS percentiles_before_update4;


DELIMITER //
CREATE TRIGGER percentiles_before_update4
BEFORE UPDATE
ON percentiles
FOR EACH ROW
BEGIN
	IF NEW.ninety_percentile > 100 OR NEW.ninety_percentile < 0 THEN
    SIGNAL SQLSTATE '22003'
	SET MESSAGE_TEXT = 'The percentile must be a number less than 100 and greater than 0.', MYSQL_ERRNO = 1264;
    ELSEIF NEW.ninety_percentile >= 0 AND NEW.ninety_percentile <= 1 THEN
    SET NEW.ninety_percentile = NEW.ninety_percentile * 100;
    END IF;
END //
DELIMITER ;
-- Test the percentiles_before_update4 trigger by doing an update, should return an error message
UPDATE percentiles
SET ninety_percentile = 110
WHERE percentileID = 1;

-- 05
-- Create a trigger called percentiles_before_update5: before updating the percentiles table, if the data updated in 
-- seventy_five_percentile column
-- is greater than 100 or 0, signals an error message; if the data updated is between 0 and 1, then times the data with 100
-- and makes it a valid percentile
DROP TRIGGER IF EXISTS percentiles_before_update5;

DELIMITER //
CREATE TRIGGER percentiles_before_update5
BEFORE UPDATE
ON percentiles
FOR EACH ROW
BEGIN
	IF NEW.seventy_five_percentile > 100 OR NEW.seventy_five_percentile < 0 THEN
    SIGNAL SQLSTATE '22003'
	SET MESSAGE_TEXT = 'The percentile must be a number less than 100 and greater than 0.', MYSQL_ERRNO = 1264;
    ELSEIF NEW.seventy_five_percentile >= 0 AND NEW.seventy_five_percentile <= 1 THEN
    SET NEW.seventy_five_percentile= NEW.seventy_five_percentile * 100;
    END IF;
END //
DELIMITER ;
-- Test the percentiles_before_update5 trigger by doing an update, should return an error message
UPDATE percentiles
SET seventy_five_percentile = 110
WHERE percentileID = 1;


-- 06
-- Create a trigger called percentiles_before_update6: before updating the percentiles table, if the data updated in 
-- fifty_percentile column
-- is greater than 100 or 0, signals an error message; if the data updated is between 0 and 1, then times the data with 100
-- and makes it a valid percentile
DROP TRIGGER IF EXISTS percentiles_before_update6;

DELIMITER //
CREATE TRIGGER percentiles_before_update6
BEFORE UPDATE
ON percentiles
FOR EACH ROW
BEGIN
	IF NEW.fifty_percentile > 100 OR NEW.fifty_percentile < 0 THEN
    SIGNAL SQLSTATE '22003'
	SET MESSAGE_TEXT = 'The percentile must be a number less than 100 and greater than 0.', MYSQL_ERRNO = 1264;
    ELSEIF NEW.fifty_percentile >= 0 AND NEW.fifty_percentile <= 1 THEN
    SET NEW.fifty_percentile= NEW.fifty_percentile * 100;
    END IF;
END //
DELIMITER ;
-- Test the percentiles_before_update6 trigger by doing an update, should return an error message
UPDATE percentiles
SET fifty_percentile = 110
WHERE percentileID = 1;


-- 07
-- Create a trigger called percentiles_before_update7: before updating the percentiles table, if the data updated in 
-- ten_percentile column
-- is greater than 100 or 0, signals an error message; if the data updated is between 0 and 1, then times the data with 100
-- and makes it a valid percentile
DROP TRIGGER IF EXISTS percentiles_before_update7;

DELIMITER //
CREATE TRIGGER percentiles_before_update7
BEFORE UPDATE
ON percentiles
FOR EACH ROW
BEGIN
	IF NEW.ten_percentile > 100 OR NEW.ten_percentile < 0 THEN
    SIGNAL SQLSTATE '22003'
	SET MESSAGE_TEXT = 'The percentile must be a number less than 100 and greater than 0.', MYSQL_ERRNO = 1264;
    ELSEIF NEW.ten_percentile >= 0 AND NEW.ten_percentile <= 1 THEN
    SET NEW.ten_percentile= NEW.ten_percentile * 100;
    END IF;
END //
DELIMITER ;
-- Test the percentiles_before_update7 trigger by doing an update, should return an error message
UPDATE percentiles
SET ten_percentile = 110
WHERE percentileID = 1;



-- 08
-- Create a procedure called getIndicator(), which returns the year, name of the local site and the corresponding arithmetic 
-- mean of the air quality test as an indicator of air quality of the region. Note, this procedure only retun data from 
-- the last 20 years.
DROP PROCEDURE IF EXISTS getIndicator;

DELIMITER //
CREATE PROCEDURE getIndicator()

BEGIN
SELECT year,local_site_name,arithmetic_mean
FROM air_quality_indicator
WHERE year >= 2000
GROUP BY year, arithmetic_mean, local_site_name;

END //
DELIMITER ;
-- Test the getIndicator() procedure by calling it
CALL getIndicator();


-- 09
-- Create a procedure called getAreaInfo(), which returns the local site name, year, state and county. 
DROP PROCEDURE IF EXISTS getAreaInfo;

DELIMITER //
CREATE PROCEDURE getAreaInfo()

BEGIN
SELECT local_site_name,year, state_name,county_name, site_num
FROM area_info
GROUP BY local_site_name,year, state_name,county_name, site_num;

END //
DELIMITER ;
-- Test the getAreaInfo() procedure by calling it
CALL getAreaInfo();


-- 10
-- Create a view called method_summary with the count of method used and metric used for each year
DROP VIEW IF EXISTS method_summary;
CREATE VIEW method_summary AS
SELECT year, COUNT(method_name) AS method_count, COUNT(metric_used) AS metric_count
FROM method
GROUP BY year;
-- Test the method_summary view with the select statement
SELECT * FROM method_summary;

-- 11
-- Create a view called site_summary with the count of site,states, and county existed for each year
DROP VIEW IF EXISTS site_summary;
CREATE VIEW site_summary AS
SELECT year, COUNT(local_site_name) AS site_count, COUNT( DISTINCT state_name) AS state_count, COUNT(DISTINCT county_name) AS county_count
FROM area_info
GROUP BY year;
-- Test the method_summary view with the select statement
SELECT * FROM site_summary;







