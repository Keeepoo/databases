-- Задача 3: Классы с наименьшей средней позицией и все их автомобили
WITH CarStats AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count,
        cl.country AS car_country
    FROM Cars c
    JOIN Results r ON c.name = r.car
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.name, c.class, cl.country
),
ClassAvg AS (
    SELECT car_class, AVG(average_position) AS class_avg_position
    FROM CarStats
    GROUP BY car_class
),
MinClassAvg AS (SELECT MIN(class_avg_position) AS min_avg FROM ClassAvg),
TargetClasses AS (
    SELECT car_class FROM ClassAvg
    WHERE class_avg_position = (SELECT min_avg FROM MinClassAvg)
),
ClassTotalRaces AS (
    SELECT c.class AS car_class, COUNT(DISTINCT r.race) AS total_races
    FROM Cars c
    JOIN Results r ON c.name = r.car
    WHERE c.class IN (SELECT car_class FROM TargetClasses)
    GROUP BY c.class
)
SELECT 
    cs.car_name,
    cs.car_class,
    ROUND(cs.average_position, 4) AS average_position,
    cs.race_count,
    cs.car_country,
    ctr.total_races
FROM CarStats cs
JOIN TargetClasses tc ON cs.car_class = tc.car_class
JOIN ClassTotalRaces ctr ON cs.car_class = ctr.car_class
ORDER BY cs.car_class, cs.average_position;
