DROP VIEW QUAKES.vue_Quakes_Magnitudes_Grouped_Year_CC_Admin1;
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
