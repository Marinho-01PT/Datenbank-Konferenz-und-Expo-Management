
-- Q5.1: Exhibitors mit zugewiesenem Booth und Event
-- Zweck: Zeigt, welcher Aussteller auf welchem Event und Booth ist.
SELECT
    e.name        AS event_name,
    b.boothID,
    b.zone,
    b.area,
    ex.exhibitorID,
    ex.name       AS exhibitor_name
FROM Booth b
JOIN Event    e  ON b.eventID       = e.eventID
JOIN BoothBooking bb ON bb.boothID  = b.boothID
JOIN Exhibitor ex    ON bb.exhibitorID = ex.exhibitorID
ORDER BY event_name, b.zone, b.boothID, exhibitor_name;

-- Q5.2: Anzahl gebuchter Booths pro Event
-- Zweck: Wie stark ist die Expo eines Events ausgelastet?
SELECT
    e.eventID,
    e.name              AS event_name,
    COUNT(DISTINCT b.boothID) AS booked_booths
FROM Event e
LEFT JOIN Booth b        ON b.eventID      = e.eventID
LEFT JOIN BoothBooking bb ON bb.boothID    = b.boothID
GROUP BY e.eventID, e.name
ORDER BY booked_booths DESC, event_name;

-- Q5.3: Booth-Buchungen pro Exhibitor
-- Zweck: Wie aktiv sind die verschiedenen Aussteller?
SELECT
    ex.exhibitorID,
    ex.name AS exhibitor_name,
    COUNT(bb.bookingID) AS booking_count
FROM Exhibitor ex
LEFT JOIN BoothBooking bb ON bb.exhibitorID = ex.exhibitorID
GROUP BY ex.exhibitorID, ex.name
ORDER BY booking_count DESC, exhibitor_name;