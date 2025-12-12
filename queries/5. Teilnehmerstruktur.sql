-- 5.1 Übersicht aller Personen + Rollen

SELECT 
    p.personID,
    p.firstName,
    p.lastName,
    CASE 
        WHEN sp.personID IS NOT NULL THEN 'Speaker'
        WHEN g.personID IS NOT NULL THEN 'Guest'
        WHEN st.personID IS NOT NULL THEN 'Staff'
        ELSE 'Undefined'
    END AS role
FROM Person p
LEFT JOIN Speaker sp ON sp.personID = p.personID
LEFT JOIN Guest g ON g.personID = p.personID
LEFT JOIN Staff st ON st.personID = p.personID
ORDER BY p.personID;


-- Interpretation:

/* Diese Übersicht macht sichtbar, ob die Verteilung von Rollen angemessen ist und ob etwa 
 zu wenig Staff oder zu viele Gäste für ein Event angemeldet sind. */