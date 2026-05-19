-- Задача 2: Автомобиль с наименьшей средней позицией (при равенстве – по алфавиту)
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
)
SELECT 
    car_name,
    car_class,
    ROUND(average_position, 4) AS average_position,
    race_count,
    car_country
FROM CarStats
ORDER BY average_position, car_name
LIMIT 1;
