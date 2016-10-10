CREATE SCHEMA IF NOT EXISTS QUAKES;

USE QUAKES;

DROP VIEW IF EXISTS vue_Quakes_Magnitudes_Grouped_Year_CC_Admin1;
DROP VIEW IF EXISTS vue_Quakes_Magnitudes;

DROP VIEW IF EXISTS vue_Quakes_Oklahoma_vs_California;

DROP TABLE IF EXISTS Quakes;

CREATE TABLE IF NOT EXISTS Quakes (
	Event_DTG VARCHAR (25),
	Latitude DOUBLE,
	Longitude DOUBLE,
	Depth REAL,
	Magnitude REAL,
	MagType VARCHAR (10),
	NbStations INT,
	Gap VARCHAR (10),
	Distance VARCHAR (10),
	RMS VARCHAR (10),
	`Source` VARCHAR (10),
	EventID VARCHAR (20),
	Event_Year VARCHAR(4),
	Event_Month VARCHAR(2),
	Event_Day VARCHAR(2),
	Event_Hour VARCHAR(2),
	Event_Min VARCHAR(2),
	Event_Sec VARCHAR(2),
	cc VARCHAR (10),
	admin1 VARCHAR (100),
	admin2 VARCHAR (100),
	`name` VARCHAR (100));

CREATE INDEX Quakes_Event_Year ON Quakes (Event_Year);
CREATE INDEX Quakes_Event_Month ON Quakes (Event_Month);
CREATE INDEX Quakes_Event_Day ON Quakes (Event_Day);
CREATE INDEX Quakes_cc ON Quakes (cc);
CREATE INDEX Quakes_admin1 ON Quakes (admin1);
CREATE INDEX Quakes_admin2 ON Quakes (admin2);
CREATE INDEX Quakes_name ON Quakes (name);
CREATE INDEX Quakes_Event_DTG ON Quakes (Event_DTG);
CREATE INDEX Quakes_Depth ON Quakes (Depth);
CREATE INDEX Quakes_Magnitude ON Quakes (Magnitude);
CREATE INDEX Quakes_Latitude ON Quakes (Latitude);
CREATE INDEX Quakes_Longitude ON Quakes (Longitude);

CREATE VIEW QUAKES.vue_Quakes_Magnitudes
AS
SELECT
	Event_DTG,
	Latitude,
	Longitude,
	Depth,
	Magnitude,
	MagType,
	NbStations,
	Gap,
	Distance,
	RMS,
	`Source`,
	EventID,
	cc,
	admin1,
	admin2,
	`name`,
	Event_Year,
	Event_Month,
	Event_Day,
	Event_Hour,
	Event_Min,
	Event_Sec,
	CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 0 THEN 1 ELSE 0 END Mag_0,
	CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 1 THEN 1 ELSE 0 END Mag_1,
	CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 2 THEN 1 ELSE 0 END Mag_2,
	CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 3 THEN 1 ELSE 0 END Mag_3,
	CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 4 THEN 1 ELSE 0 END Mag_4,
	CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 5 THEN 1 ELSE 0 END Mag_5,
	CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 6 THEN 1 ELSE 0 END Mag_6,
	CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 7 THEN 1 ELSE 0 END Mag_7,
	CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 8 THEN 1 ELSE 0 END Mag_8,
	CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 9 THEN 1 ELSE 0 END Mag_9
FROM
	Quakes;
	
CREATE VIEW QUAKES.vue_Quakes_Magnitudes_Grouped_Year_CC_Admin1
AS
SELECT
	Event_Year,
	cc,
	admin1,
	SUM(Mag_0) Mag_0,
	SUM(Mag_1) Mag_1,
	SUM(Mag_2) Mag_2,
	SUM(Mag_3) Mag_3,
	SUM(Mag_4) Mag_4,
	SUM(Mag_5) Mag_5,
	SUM(Mag_6) Mag_6,
	SUM(Mag_7) Mag_7,
	SUM(Mag_8) Mag_8,
	SUM(Mag_9) Mag_9
FROM
	QUAKES.vue_Quakes_Magnitudes
GROUP BY
	Event_Year,
	cc,
	admin1;

CREATE VIEW QUAKES.vue_Quakes_Oklahoma_vs_California
AS
SELECT
    cc,
    Event_Year,
    admin1,
    Mag_0,
    Mag_1,
    Mag_2,
    Mag_3,
    Mag_4,
    Mag_5,
    Mag_6,
    Mag_7,
    Mag_8,
    Mag_9,
    Mag_Avg,
    Total,
    Total - Mag_0 Total_wo_Mag_0,
    CAST((Mag_1 + (Mag_2 * 2) + (Mag_3 * 3) + (Mag_4 * 4) + (Mag_5 * 5) + (Mag_6 * 6) + (Mag_7 * 7) + (Mag_8 * 8) + (Mag_9 * 9)) AS DECIMAL) / CAST((Total - Mag_0) AS DECIMAL) Weighted_Avg_Mag,
    Mag_3 + Mag_4 + Mag_5 + Mag_6 + Mag_7 + Mag_8 + Mag_8 Total_Mag_3_and_Above
FROM
(
    SELECT
        cc,
        Event_Year,
        admin1,
        SUM(Mag_0) Mag_0,
        SUM(Mag_1) Mag_1,
        SUM(Mag_2) Mag_2,
        SUM(Mag_3) Mag_3,
        SUM(Mag_4) Mag_4,
        SUM(Mag_5) Mag_5,
        SUM(Mag_6) Mag_6,
        SUM(Mag_7) Mag_7,
        SUM(Mag_8) Mag_8,
        SUM(Mag_9) Mag_9,
        AVG(Magnitude) Mag_Avg,
        COUNT(*) Total,
        COUNT(*) - SUM(Mag_0) Total_wo_Mag_0
    FROM
    (
        
        SELECT
            cc,
            Event_Year,
          	admin1,
          	Magnitude,
            CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 0 THEN 1 ELSE 0 END Mag_0,
            CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 1 THEN 1 ELSE 0 END Mag_1,
            CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 2 THEN 1 ELSE 0 END Mag_2,
            CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 3 THEN 1 ELSE 0 END Mag_3,
            CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 4 THEN 1 ELSE 0 END Mag_4,
            CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 5 THEN 1 ELSE 0 END Mag_5,
            CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 6 THEN 1 ELSE 0 END Mag_6,
            CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 7 THEN 1 ELSE 0 END Mag_7,
            CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 8 THEN 1 ELSE 0 END Mag_8,
            CASE WHEN CAST(Magnitude AS UNSIGNED INTEGER) = 9 THEN 1 ELSE 0 END Mag_9
        FROM
            Quakes
        WHERE
            admin1 IN ('Oklahoma', 'California')
    ) qry1
    GROUP BY
        cc,
        Event_Year,
        admin1
) qry2
ORDER BY
    cc,
    Event_Year DESC,
    admin1;
    
LOAD DATA INFILE 'E:/home/data/quake-info/NCEDC_earthquakes_reverse_geocoded_y_header.csv' INTO TABLE Quakes
	FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
    IGNORE 1 LINES;
