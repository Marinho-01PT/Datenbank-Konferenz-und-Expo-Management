-- 1.1 Räume pro Event & ihre Auslastung anhand Sessions:

/* Bei der Planung eines grossen Events stellt sich oft die Frage, ob die zur Verfügung stehenden Räume sinnvoll genutzt werden.
Manche Räume sind potenziell überbucht, andere bleiben fast unbenutzt. Um die Effizienz der Raumverteilung beurteilen zu können, 
ermittelt diese Abfrage, wie viele Sessions in welchen Räumen stattfinden und wie gross deren Kapazität ist.  */

SELECT 
    e.name AS event,
    r.name AS room,
    r.capacity,
    COUNT(s.sessionID) AS numberOfSessions
FROM Event e
JOIN Room r ON r.venueID = e.venueID
LEFT JOIN Session s ON s.roomID = r.roomID
GROUP BY e.name, r.name, r.capacity
ORDER BY e.name, numberOfSessions DESC;

-- Interpretation:

/*Diese Analyse hilft dem Eventteam zu erkennen, ob bestimmte Räume überproportional genutzt werden und ob eine bessere Verteilung der Sessions notwendig ist,
 sowohl aus organisatorischer als auch aus sicherheitstechnischer Sicht. */

-- 1.2 Sessions, die über den Raum hinausgehen könnten (Dauer > 1h):

/* Einige Sessions sind wesentlich länger als andere. Längere Sessions binden Räume über einen längeren Zeitraum und können Konflikte im Zeitplan erzeugen. 
Mit dieser Abfrage werden alle Sessions identifiziert, die länger als eine Stunde dauern. */

SELECT 
    s.title,
    r.name AS room,
    EXTRACT(EPOCH FROM (endTime - startTime))/3600 AS duration_hours
FROM Session s
JOIN Room r ON s.roomID = r.roomID
WHERE (endTime - startTime) > INTERVAL '1 hour';

-- Interpretation:

/* Die Eventplanung kann sicherstellen, dass lange Sessions nicht versehentlich zu Engpässen führen oder Umlaufzeiten zwischen 
Veranstaltungen zu knapp ausfallen. */