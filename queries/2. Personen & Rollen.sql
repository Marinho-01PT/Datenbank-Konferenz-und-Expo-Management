-- Q2.1: Speaker mit Anzahl Sessions
-- Zweck: Zeigt, welche Speaker wie oft im Programm auftreten.
SELECT
    p.personID,
    p.firstName,
    p.lastName,
    COUNT(ss.sessionID) AS session_count
FROM Speaker s
JOIN Person p      ON s.personID = p.personID
LEFT JOIN SessionSpeaker ss ON ss.personID = s.personID
GROUP BY p.personID, p.firstName, p.lastName
ORDER BY session_count DESC, lastName, firstName;

-- Q2.2: Gäste pro Event (über Tickets)
-- Zweck: Wie viele Gäste nehmen pro Event teil (basierend auf verkauften Tickets)?
SELECT
    e.eventID,
    e.name                    AS event_name,
    COUNT(DISTINCT t.guestID) AS distinct_guests
FROM Event e
JOIN TicketType tt ON tt.eventID = e.eventID
JOIN Ticket t      ON t.ticketTypeID = tt.ticketTypeID
GROUP BY e.eventID, e.name
ORDER BY distinct_guests DESC;

-- Q2.3: Anzahl Staff-Mitglieder pro Rolle
-- Zweck: Übersicht, wie euer Organisationsteam strukturiert ist.
SELECT
    s.role,
    COUNT(*) AS staff_count
FROM Staff s
GROUP BY s.role
ORDER BY staff_count DESC, s.role;
