DROP VIEW QUAKES.vue_Quakes_Magnitudes;
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
