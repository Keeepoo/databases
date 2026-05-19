-- Задача 1: Для каждого класса автомобиль с наименьшей средней позицией
WITH CarStats AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class
),
ClassMinAvg AS (
    SELECT car_class, MIN(average_position) AS min_avg
    FROM CarStats
    GROUP BY car_class
)
SELECT 
    cs.car_name,
    cs.car_class,
    ROUND(cs.average_position, 4) AS average_position,
    cs.race_count
FROM CarStats cs
JOIN ClassMinAvg cma ON cs.car_class = cma.car_class AND cs.average_position = cma.min_avg
ORDER BY cs.average_position;
