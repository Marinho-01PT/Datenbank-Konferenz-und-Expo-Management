-- Q4.1: Anzahl Tickets pro TicketType
-- Zweck: Welche Ticketarten werden wie häufig verkauft?
SELECT
    tt.ticketTypeID,
    tt.name AS ticket_type_name,
    e.name  AS event_name,
    COUNT(t.ticketID) AS ticket_count
FROM TicketType tt
LEFT JOIN Ticket t ON t.ticketTypeID = tt.ticketTypeID
JOIN Event e       ON tt.eventID = e.eventID
GROUP BY tt.ticketTypeID, tt.name, e.name
ORDER BY e.name, ticket_type_name;

-- Q4.2: Umsatz pro Event
-- Zweck: Gesamtumsatz je Event (ohne Rabatte/Steuern, einfach price * Anzahl Tickets).
SELECT
    e.eventID,
    e.name AS event_name,
    COALESCE(SUM(tt.price), 0) AS revenue
FROM Event e
LEFT JOIN TicketType tt ON tt.eventID = e.eventID
LEFT JOIN Ticket t      ON t.ticketTypeID = tt.ticketTypeID
GROUP BY e.eventID, e.name
ORDER BY revenue DESC;

-- Q4.3: Tickets nach Status (z.B. 'paid', 'reserved', 'canceled')
-- Zweck: Überblick über den Status der Tickets pro Event.
SELECT
    e.name       AS event_name,
    t.status,
    COUNT(*)     AS ticket_count
FROM Ticket t
JOIN TicketType tt ON t.ticketTypeID = tt.ticketTypeID
JOIN Event      e  ON tt.eventID = e.eventID
GROUP BY e.name, t.status
ORDER BY e.name, t.status;
