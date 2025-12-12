-- 4.1 Welche Aussteller haben die längsten gebuchten Laufzeiten?

/* Diese Abfrage zeigt, welche Exhibitors besonders lange Booths gebucht haben. */

SELECT 
    ex.name AS exhibitor,
    b.boothID,
    (bookingTo - bookingFrom) AS duration
FROM BoothBooking b
JOIN Exhibitor ex ON b.exhibitorID = ex.exhibitorID
ORDER BY duration DESC;

-- Interpretation:

/* Langzeitbucher sind strategisch wertvoll. Sie sind potenzielle Sponsoren oder Premium-Partner. */

-- 4.2 Belegung pro Zone (A/B/C…):

SELECT 
    zone,
    COUNT(*) AS boothCount
FROM Booth
GROUP BY zone
ORDER BY boothCount DESC;

-- Interpretation:

/* Zeigt Beliebtheit und kommerzielle Wertigkeit einzelner Messebereiche. */

-- 4.3 Exhibitors + ihre Booths + das zugehörige Event

SELECT 
    ex.name AS exhibitor,
    bo.boothID,
    bo.zone,
    e.name AS event
FROM Booth bo
JOIN Event e ON bo.eventID = e.eventID
JOIN BoothBooking bb ON bb.boothID = bo.boothID
JOIN Exhibitor ex ON bb.exhibitorID = ex.exhibitorID;

-- Interpretation:

/* Ermöglicht eine Analyse der Ausstellerverteilung über Events hinweg und zeigt Zonen, die bevorzugt werden. */