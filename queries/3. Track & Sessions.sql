-- Q3.1: Anzahl Sessions pro Track
-- Zweck: Wie stark sind die einzelnen Tracks mit Sessions gefüllt?
SELECT
    t.trackID,
    t.name               AS track_name,
    COUNT(s.sessionID)   AS session_count
FROM Track t
LEFT JOIN Session s ON s.trackID = t.trackID
GROUP BY t.trackID, t.name
ORDER BY session_count DESC, track_name;

-- Q3.2: Sessionplan – Session mit Track, Raum und Zeiten
-- Zweck: Klassischer Programmplan.
SELECT
    e.name       AS event_name,
    t.name       AS track_name,
    s.title      AS session_title,
    r.name       AS room_name,
    s.startTime,
    s.endTime,
    s.language,
    s."level"
FROM Session s
JOIN Track  t ON s.trackID = t.trackID
JOIN Event  e ON t.eventID = e.eventID
JOIN Room   r ON s.roomID  = r.roomID
ORDER BY e.startDate, s.startTime, track_name, room_name;

-- Q3.3: Durchschnittliche Sessionlänge pro Track (in Minuten)
-- Zweck: Zeigt Unterschiede in der durchschnittlichen Dauer zwischen Tracks.
SELECT
    t.name AS track_name,
    AVG(EXTRACT(EPOCH FROM (s.endTime - s.startTime)) / 60) AS avg_duration_minutes
FROM Session s
JOIN Track   t ON s.trackID = t.trackID
GROUP BY t.name
ORDER BY avg_duration_minutes DESC;