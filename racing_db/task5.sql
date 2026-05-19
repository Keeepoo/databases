-- Задача 5: Классы с наибольшим количеством авто с low_position (средняя > 3.0)
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
ClassLowCount AS (
    SELECT car_class, COUNT(*) AS low_position_count
    FROM CarStats
    WHERE average_position > 3.0
    GROUP BY car_class
),
MaxLowCount AS (SELECT MAX(low_position_count) AS max_low FROM ClassLowCount),
TargetClasses AS (
    SELECT car_class FROM ClassLowCount
    WHERE low_position_count = (SELECT max_low FROM MaxLowCount)
),
ClassTotalRaces AS (
    SELECT c.class AS car_class, COUNT(DISTINCT r.race) AS total_races
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.class
)
SELECT 
    cs.car_name,
    cs.car_class,
    ROUND(cs.average_position, 4) AS average_position,
    cs.race_count,
    cs.car_country,
    ctr.total_races,
    clc.low_position_count
FROM CarStats cs
JOIN TargetClasses tc ON cs.car_class = tc.car_class
JOIN ClassLowCount clc ON cs.car_class = clc.car_class
JOIN ClassTotalRaces ctr ON cs.car_class = ctr.car_class
WHERE cs.average_position > 3.0
ORDER BY clc.low_position_count DESC, cs.car_class, cs.average_position;
