-- Q1.1: Anzahl Events pro Venue
-- Zweck: Zeigt, wie viele Events in jedem Venue stattfinden.
SELECT
    v.venueID,
    v.name            AS venue_name,
    COUNT(e.eventID)  AS event_count
FROM Venue v
LEFT JOIN Event e ON e.venueID = v.venueID
GROUP BY v.venueID, v.name
ORDER BY event_count DESC, venue_name;

-- Q1.2: Räume pro Venue mit Kapazität
-- Zweck: Übersicht, welche Räume mit welcher Kapazität zu welchem Venue gehören.
SELECT
    v.name   AS venue_name,
    r.roomID,
    r.name   AS room_name,
    r.capacity
FROM Room r
JOIN Venue v ON r.venueID = v.venueID
ORDER BY venue_name, room_name;

-- Q1.3: Events mit Ort (Stadt, Land) und Dauer in Stunden
-- Zweck: Kombination von Event-Information und Venue + einfache Dauerberechnung.
SELECT
    e.eventID,
    e.name                         AS event_name,
    v.city,
    v.country,
    e.startDate,
    e.endDate,
    EXTRACT(EPOCH FROM (e.endDate - e.startDate)) / 3600 AS duration_hours
FROM Event e
JOIN Venue v ON e.venueID = v.venueID
ORDER BY e.startDate;
