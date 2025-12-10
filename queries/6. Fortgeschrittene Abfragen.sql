
-- Q6.1: Top 3 Speaker nach Anzahl Sessions
-- Zweck: Ranking der „aktivsten“ Speaker.
SELECT
    p.personID,
    p.firstName,
    p.lastName,
    COUNT(ss.sessionID) AS session_count
FROM Speaker s
JOIN Person p      ON s.personID = p.personID
JOIN SessionSpeaker ss ON ss.personID = s.personID
GROUP BY p.personID, p.firstName, p.lastName
ORDER BY session_count DESC, lastName, firstName
LIMIT 3;

-- Q6.2: Events mit Anzahl Sessions und Umsatz (Kombi-Übersicht)
-- Zweck: Vergleich von inhaltlicher Dichte (Sessions) und wirtschaftlichem Erfolg (Revenue).
WITH sessions_per_event AS (
    SELECT
        e.eventID,
        COUNT(s.sessionID) AS session_count
    FROM Event e
    LEFT JOIN Track   t ON t.eventID = e.eventID
    LEFT JOIN Session s ON s.trackID = t.trackID
    GROUP BY e.eventID
),
revenue_per_event AS (
    SELECT
        e.eventID,
        COALESCE(SUM(tt.price), 0) AS revenue
    FROM Event e
    LEFT JOIN TicketType tt ON tt.eventID = e.eventID
    LEFT JOIN Ticket     t  ON t.ticketTypeID = tt.ticketTypeID
    GROUP BY e.eventID
)
SELECT
    e.eventID,
    e.name AS event_name,
    spe.session_count,
    rpe.revenue
FROM Event e
LEFT JOIN sessions_per_event spe ON spe.eventID = e.eventID
LEFT JOIN revenue_per_event  rpe ON rpe.eventID = e.eventID
ORDER BY rpe.revenue DESC, spe.session_count DESC, event_name;