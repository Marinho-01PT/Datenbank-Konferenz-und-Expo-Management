-- 2.1 Alle Speaker mit ihren Sessions & Tracks:

/* Konferenzen leben von ihren Speakern. Diese Abfrage verbindet Speaker, Sessions und Tracks, um sichtbar zu machen,
wer welche Themen abdeckt und wie zentral einzelne Personen im Programm sind. */

SELECT 
    p.firstName || ' ' || p.lastName AS speaker,
    s.title AS session,
    t.name AS track,
    sp.role,
    sp."order"
FROM SessionSpeaker sp
JOIN Speaker spk ON sp.personID = spk.personID
JOIN Person p ON sp.personID = p.personID
JOIN Session s ON sp.sessionID = s.sessionID
JOIN Track t ON s.trackID = t.trackID
ORDER BY speaker, sp."order";

-- Interpretation:

/* So erkennt man, welche Speaker eine zentrale Rolle im Content der Konferenz spielen — wichtig für Marketing, VIP-Betreuung und Planung. */

-- 2.2 Welche Speaker haben die meisten Sessions?:

/* Hier wird analysiert, welche Speaker am stärksten in die Konferenz involviert sind. */

SELECT 
    p.firstName || ' ' || p.lastName AS speaker,
    COUNT(sp.sessionID) AS sessionCount
FROM SessionSpeaker sp
JOIN Person p ON sp.personID = p.personID
GROUP BY speaker
ORDER BY sessionCount DESC;

-- Interpretaion:

/* Die Ergebnisse ermöglichen es, Top-Speaker zu identifizieren, mögliche Überlastungen früh zu erkennen oder gezielt Zusatzangebote zu planen. */