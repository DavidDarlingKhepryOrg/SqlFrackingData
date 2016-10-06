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