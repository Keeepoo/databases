-- Задача 4: Автомобили, чья средняя позиция лучше средней по классу (в классе минимум 2 авто)
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
    SELECT car_class, AVG(average_position) AS class_avg_position, COUNT(*) AS cars_in_class
    FROM CarStats
    GROUP BY car_class
    HAVING COUNT(*) >= 2
)
SELECT 
    cs.car_name,
    cs.car_class,
    ROUND(cs.average_position, 4) AS average_position,
    cs.race_count,
    cs.car_country
FROM CarStats cs
JOIN ClassAvg ca ON cs.car_class = ca.car_class
WHERE cs.average_position < ca.class_avg_position
ORDER BY cs.car_class, cs.average_position;
