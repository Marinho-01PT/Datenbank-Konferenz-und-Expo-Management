-- 6.1 a Welche Sessions sind kritisch, weil sie viele Teilnehmer haben, aber kleine Räume?

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

-- Q6.1 b: Top 3 Speaker nach Anzahl Sessions
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

-- Q6.3: Komplette Material-Logistik pro Session
-- Zweck: Zeigt dem Technik-Team eine Gesamtliste: Was ist fest im Raum (Standard)
-- und was muss für die Session extra aufgebaut werden (Extra)?
SELECT
    s.title       AS session_title,
    r.name        AS room_name,
    eq.name       AS equipment_name,
    re.amount,
    'Room Standard' AS type
FROM Session s
JOIN Room r           ON s.roomID = r.roomID
JOIN RoomEquipment re ON r.roomID = re.roomID
JOIN Equipment eq     ON re.equipmentID = eq.equipmentID

UNION ALL

SELECT
    s.title       AS session_title,
    r.name        AS room_name,
    eq.name       AS equipment_name,
    se.amount,
    'Extra Booking' AS type
FROM Session s
JOIN Room r             ON s.roomID = r.roomID
JOIN SessionEquipment se ON s.sessionID = se.sessionID
JOIN Equipment eq       ON se.equipmentID = eq.equipmentID

ORDER BY session_title, type DESC;

-- Q6.4: Sessions ohne aktuellen TechCheck (Risiko-Analyse)
-- Zweck: Finde alle Sessions, für die es im Zeitfenster von 24h vor Start
-- keinen erfolgreichen ('OK') TechCheck im zugehörigen Raum gab.
SELECT
    e.name AS event_name,
    r.name AS room_name,
    s.title AS session_title,
    s.startTime
FROM Session s
         JOIN Room r ON s.roomID = r.roomID
         JOIN Track t ON s.trackID = t.trackID
         JOIN Event e ON t.eventID = e.eventID
WHERE NOT EXISTS (
    SELECT 1
    FROM TechCheck tc
    WHERE tc.roomID = s.roomID
      AND tc.status = 'OK'
      AND tc.checkTime >= (s.startTime - INTERVAL '24 hours')
      AND tc.checkTime <= s.startTime
)
ORDER BY s.startTime;

-- Q6.5: Speaker ohne ausreichende Pause
-- Zweck: Findet Speaker, die zwischen zwei Sessions weniger als 15 Minuten Zeit haben.
WITH SpeakerSchedule AS (
    SELECT
        p.firstName || ' ' || p.lastName AS speaker_name,
        s.title,
        s.startTime,
        s.endTime,
        -- Ende der VORHERIGEN Session dieses Speakers
        LAG(s.endTime) OVER (PARTITION BY p.personID ORDER BY s.startTime) AS prev_end_time
    FROM Person p
             JOIN SessionSpeaker ss ON p.personID = ss.personID
             JOIN Session s ON ss.sessionID = s.sessionID
)
SELECT
    speaker_name,
    title AS current_session,
    TO_CHAR(prev_end_time, 'HH24:MI') as last_end,
    TO_CHAR(startTime, 'HH24:MI') as current_start,
    EXTRACT(EPOCH FROM (startTime - prev_end_time)) / 60 AS break_minutes
FROM SpeakerSchedule
WHERE prev_end_time IS NOT NULL
  AND (startTime - prev_end_time) < INTERVAL '15 minutes';

-- Q6.6: Logistik-Warnung (Viel Equipment)
-- Zweck: Sessions, die mehr als 2 verschiedene Zusatzeräte benötigen.
SELECT
    s.title,
    r.name AS room_name,
    COUNT(se.equipmentID) AS distinct_equipment_count
FROM Session s
         JOIN Room r ON s.roomID = r.roomID
         JOIN SessionEquipment se ON s.sessionID = se.sessionID
GROUP BY s.sessionID, s.title, r.name
HAVING COUNT(se.equipmentID) > 2;
