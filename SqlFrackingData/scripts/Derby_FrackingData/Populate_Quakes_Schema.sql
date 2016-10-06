CREATE SCHEMA QUAKES;

SET SCHEMA QUAKES;

DROP VIEW QUAKES.vue_Quakes_Magnitudes_Grouped_Year_CC_Admin1;
DROP VIEW QUAKES.vue_Quakes_Magnitudes;

DROP VIEW QUAKES.vue_Quakes_Oklahoma_vs_California;

DROP TABLE QUAKES.Quakes;

CREATE TABLE QUAKES.Quakes (
	DateTime TIMESTAMP,
	Latitude DOUBLE,
	Longitude DOUBLE,
	Depth REAL,
	Magnitude REAL,
	MagType VARCHAR (10),
	NbStations INT,
	Gap VARCHAR (10),
	Distance VARCHAR (10),
	RMS VARCHAR (10),
	Source VARCHAR (10),
	EventID VARCHAR (20),
	Event_Year VARCHAR(4),
	Event_Month VARCHAR(2),
	Event_Day VARCHAR(2),
	cc VARCHAR (10),
	admin1 VARCHAR (100),
	admin2 VARCHAR (100),
	name VARCHAR (100));

CREATE INDEX QUAKES.Quakes_Event_Year ON QUAKES.Quakes (Event_Year);
CREATE INDEX QUAKES.Quakes_Event_Month ON QUAKES.Quakes (Event_Month);
CREATE INDEX QUAKES.Quakes_Event_Day ON QUAKES.Quakes (Event_Day);
CREATE INDEX QUAKES.Quakes_cc ON QUAKES.Quakes (cc);
CREATE INDEX QUAKES.Quakes_admin1 ON QUAKES.Quakes (admin1);
CREATE INDEX QUAKES.Quakes_admin2 ON QUAKES.Quakes (admin2);
CREATE INDEX QUAKES.Quakes_name ON QUAKES.Quakes (name);
CREATE INDEX QUAKES.Quakes_DateTime ON QUAKES.Quakes (DateTime);
CREATE INDEX QUAKES.Quakes_Depth ON QUAKES.Quakes (Depth);
CREATE INDEX QUAKES.Quakes_Magnitude ON QUAKES.Quakes (Magnitude);
CREATE INDEX QUAKES.Quakes_Latitude ON QUAKES.Quakes (Latitude);
CREATE INDEX QUAKES.Quakes_Longitude ON QUAKES.Quakes (Longitude);

CREATE VIEW QUAKES.vue_Quakes_Magnitudes
AS
SELECT
	DateTime,
	Latitude,
	Longitude,
	Depth,
	Magnitude,
	MagType,
	NbStations,
	Gap,
	Distance,
	RMS,
	Source,
	EventID,
	cc,
	admin1,
	admin2,
	name,
	YEAR(DateTime) Event_Year,
	MONTH(DateTime) Event_Month,
	DAY(DateTime) Event_Day,
	CASE WHEN CAST(Magnitude AS int) = 0 THEN 1 ELSE 0 END Mag_0,
	CASE WHEN CAST(Magnitude AS int) = 1 THEN 1 ELSE 0 END Mag_1,
	CASE WHEN CAST(Magnitude AS int) = 2 THEN 1 ELSE 0 END Mag_2,
	CASE WHEN CAST(Magnitude AS int) = 3 THEN 1 ELSE 0 END Mag_3,
	CASE WHEN CAST(Magnitude AS int) = 4 THEN 1 ELSE 0 END Mag_4,
	CASE WHEN CAST(Magnitude AS int) = 5 THEN 1 ELSE 0 END Mag_5,
	CASE WHEN CAST(Magnitude AS int) = 6 THEN 1 ELSE 0 END Mag_6,
	CASE WHEN CAST(Magnitude AS int) = 7 THEN 1 ELSE 0 END Mag_7,
	CASE WHEN CAST(Magnitude AS int) = 8 THEN 1 ELSE 0 END Mag_8,
	CASE WHEN CAST(Magnitude AS int) = 9 THEN 1 ELSE 0 END Mag_9
FROM
	QUAKES.Quakes;
	
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
    cast((Mag_1 + (Mag_2 * 2) + (Mag_3 * 3) + (Mag_4 * 4) + (Mag_5 * 5) + (Mag_6 * 6) + (Mag_7 * 7) + (Mag_8 * 8) + (Mag_9 * 9)) AS REAL) / cast((Total - Mag_0) AS REAL) Weighted_Avg_Mag,
    Mag_3 + Mag_4 + Mag_5 + Mag_6 + Mag_7 + Mag_8 + Mag_8 Total_Mag_3_and_Above
FROM
(
    SELECT
        cc,
        Event_Year,
        admin1,
        sum(Mag_0) Mag_0,
        sum(Mag_1) Mag_1,
        sum(Mag_2) Mag_2,
        sum(Mag_3) Mag_3,
        sum(Mag_4) Mag_4,
        sum(Mag_5) Mag_5,
        sum(Mag_6) Mag_6,
        sum(Mag_7) Mag_7,
        sum(Mag_8) Mag_8,
        sum(Mag_9) Mag_9,
        avg(Magnitude) Mag_Avg,
        count(*) Total,
        count(*) - sum(Mag_0) Total_wo_Mag_0
    FROM
    (
        
        SELECT
            cc,
            Event_Year,
          	admin1,
          	Magnitude,
            CASE WHEN CAST(Magnitude AS INT) = 0 THEN 1 ELSE 0 END Mag_0,
            CASE WHEN CAST(Magnitude AS INT) = 1 THEN 1 ELSE 0 END Mag_1,
            CASE WHEN CAST(Magnitude AS INT) = 2 THEN 1 ELSE 0 END Mag_2,
            CASE WHEN CAST(Magnitude AS INT) = 3 THEN 1 ELSE 0 END Mag_3,
            CASE WHEN CAST(Magnitude AS INT) = 4 THEN 1 ELSE 0 END Mag_4,
            CASE WHEN CAST(Magnitude AS INT) = 5 THEN 1 ELSE 0 END Mag_5,
            CASE WHEN CAST(Magnitude AS INT) = 6 THEN 1 ELSE 0 END Mag_6,
            CASE WHEN CAST(Magnitude AS INT) = 7 THEN 1 ELSE 0 END Mag_7,
            CASE WHEN CAST(Magnitude AS INT) = 8 THEN 1 ELSE 0 END Mag_8,
            CASE WHEN CAST(Magnitude AS INT) = 9 THEN 1 ELSE 0 END Mag_9
        FROM
            QUAKES.Quakes
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
    
-- CALL SYSCS_UTIL.SYSCS_IMPORT_TABLE ('QUAKES','QUAKES','E:\home\data\quake-info\NCEDC_earthquakes_reverse_geocoded.csv',null,null,null,0);
