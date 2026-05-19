-- Задача 3: Предпочтения клиентов по типу отеля
WITH HotelCategory AS (
    SELECT 
        h.ID_hotel,
        h.name AS hotel_name,
        AVG(r.price) AS avg_price,
        CASE 
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS category
    FROM Hotel h
    JOIN Room r ON h.ID_hotel = r.ID_hotel
    GROUP BY h.ID_hotel, h.name
),
CustomerHotels AS (
    SELECT 
        c.ID_customer,
        c.name,
        GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ', ') AS visited_hotels,
        MAX(CASE WHEN hc.category = 'Дорогой' THEN 1 ELSE 0 END) AS has_expensive,
        MAX(CASE WHEN hc.category = 'Средний' THEN 1 ELSE 0 END) AS has_middle,
        MAX(CASE WHEN hc.category = 'Дешевый' THEN 1 ELSE 0 END) AS has_cheap
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    JOIN HotelCategory hc ON h.ID_hotel = hc.ID_hotel
    GROUP BY c.ID_customer, c.name
)
SELECT 
    ID_customer,
    name,
    CASE 
        WHEN has_expensive = 1 THEN 'Дорогой'
        WHEN has_middle = 1 THEN 'Средний'
        ELSE 'Дешевый'
    END AS preferred_hotel_type,
    visited_hotels
FROM CustomerHotels
ORDER BY FIELD(preferred_hotel_type, 'Дешевый', 'Средний', 'Дорогой');
