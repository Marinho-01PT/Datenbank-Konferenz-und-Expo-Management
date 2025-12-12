-- 3.1 Umsatz pro Event:

/* Diese Abfrage analysiert Tickets und Ticketpreise, um den Gesamtumsatz pro Event zu messen. */

SELECT 
    e.name AS event,
    SUM(tt.price) AS totalRevenue,
    COUNT(t.ticketID) AS ticketsSold
FROM Ticket t
JOIN TicketType tt ON t.ticketTypeID = tt.ticketTypeID
JOIN Event e ON tt.eventID = e.eventID
WHERE t.status = 'paid'
GROUP BY e.name
ORDER BY totalRevenue DESC;

-- Interpretation: 

/* Die Analyse liefert konkrete wirtschaftliche Informationen zu jedem Event und zeigt, 
welche Events finanziell besonders wichtig oder besonders schwach sind. */


-- 3.2 Welche Tickettypen sind am profitabelsten?

/* Nicht jedes Ticket ist gleich wichtig. Manchmal generieren wenige teure Tickets mehr Umsatz als viele günstige. */

SELECT 
    tt.name AS ticketType,
    COUNT(t.ticketID) AS sold,
    SUM(tt.price) AS revenue
FROM Ticket t
JOIN TicketType tt ON t.ticketTypeID = tt.ticketTypeID
WHERE t.status = 'paid'
GROUP BY tt.name
ORDER BY revenue DESC;

-- Interpretation: 

/* Die Ergebnisse unterstützen Entscheidungen zu Preisgestaltung, Ausbau oder Reduktion bestimmter Ticketkategorien. */


-- 3.3 Gäste mit mehreren Tickets 

/* Diese Abfrage identifiziert besonders aktive Teilnehmende. */

SELECT 
    p.firstName || ' ' || p.lastName AS guest,
    COUNT(t.ticketID) AS ticketCount
FROM Ticket t
JOIN Guest g ON t.guestID = g.personID
JOIN Person p ON g.personID = p.personID
GROUP BY guest
HAVING COUNT(t.ticketID) > 1;

-- Interpretation:

/* Mehrfach-Käufer sind potenzielle VIP-Kunden oder Zielgruppe für Up-Selling- und Loyalty-Programme. */

