-- 6.1 Welche Sessions sind kritisch, weil sie viele Teilnehmer haben, aber kleine Räume?

SELECT 
    s.title,
    r.name AS room,
    r.capacity,
    COUNT(t.ticketID) AS participants,
    (COUNT(t.ticketID) - r.capacity) AS overflow
FROM Session s
JOIN Room r ON s.roomID = r.roomID
JOIN Track t2 ON s.trackID = t2.trackID
JOIN Event e ON t2.eventID = e.eventID
LEFT JOIN TicketType tt ON tt.eventID = e.eventID
LEFT JOIN Ticket t ON t.ticketTypeID = tt.ticketTypeID AND t.status = 'paid'
GROUP BY s.title, r.name, r.capacity
HAVING COUNT(t.ticketID) > r.capacity;


/* Diese Abfrage ist entscheidend für Sicherheit & Planung: Sie identifiziert Sessions, 
die in grössere Räume verlegt werden müssen, bevor Engpässe oder Sicherheitsrisiken entstehen. */