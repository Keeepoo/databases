-- Задача 2: Пересечение клиентов с >2 бронирований в разных отелях и потративших >500
WITH CustomerStats AS (
    SELECT 
        c.ID_customer,
        c.name,
        COUNT(b.ID_booking) AS total_bookings,
        SUM(r.price) AS total_spent,
        COUNT(DISTINCT r.ID_hotel) AS unique_hotels
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    GROUP BY c.ID_customer, c.name
),
Condition1 AS (
    SELECT ID_customer, name, total_bookings, total_spent, unique_hotels
    FROM CustomerStats
    WHERE total_bookings > 2 AND unique_hotels > 1
),
Condition2 AS (
    SELECT ID_customer, total_spent
    FROM CustomerStats
    WHERE total_spent > 500
)
SELECT 
    c1.ID_customer,
    c1.name,
    c1.total_bookings,
    c1.total_spent,
    c1.unique_hotels
FROM Condition1 c1
JOIN Condition2 c2 ON c1.ID_customer = c2.ID_customer
ORDER BY c1.total_spent ASC;
