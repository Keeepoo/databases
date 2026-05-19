WITH CustomerBookings AS (
    SELECT 
        c.ID_customer,
        c.name,
        c.email,
        c.phone,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT r.ID_hotel) AS unique_hotels,
        AVG(DATEDIFF(b.check_out_date, b.check_in_date)) AS avg_stay_days,
        GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ', ') AS hotel_list
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY c.ID_customer, c.name, c.email, c.phone
    HAVING total_bookings > 2 AND unique_hotels > 1
)
SELECT 
    name,
    email,
    phone,
    total_bookings,
    hotel_list,
    ROUND(avg_stay_days, 4) AS average_stay_duration
FROM CustomerBookings
ORDER BY total_bookings DESC;
