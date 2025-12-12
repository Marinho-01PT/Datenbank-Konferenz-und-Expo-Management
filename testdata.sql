-- ============================================
-- TESTDATEN FÜR KONFERENZ- & EXPO-MANAGEMENT
-- ============================================

-- 1) VENUE
INSERT INTO Venue (name, street, zipCode, city, country)
VALUES 
('Messe Zürich', 'Wallisellenstrasse 49', '8050', 'Zürich', 'Schweiz'),
('Kongresshaus St. Gallen', 'Dufourstrasse 50', '9000', 'St. Gallen', 'Schweiz');

-- 2) EVENTS
INSERT INTO Event (name, startDate, endDate, venueID)
VALUES
('TechExpo 2025', '2025-06-01 09:00', '2025-06-03 18:00', 1),
('AI Summit 2025', '2025-09-10 09:00', '2025-09-12 17:00', 2);

-- 3) ROOMS
INSERT INTO Room (name, capacity, venueID)
VALUES
('Main Hall', 500, 1),
('Workshop Room A', 80, 1),
('Auditorium', 300, 2),
('Meeting Room B', 40, 2);

-- 4) TECHCHECKS
INSERT INTO TechCheck (checkTime, status, roomID)
VALUES
('2025-06-01 07:30', 'OK', 1),
('2025-06-01 08:00', 'OK', 2),
('2025-09-10 07:45', 'OK', 3);

-- 5) PERSONEN (BASIS)
INSERT INTO Person (firstName, lastName, email)
VALUES
('Anna', 'Müller', 'anna.mueller@example.com'),
('Jonas', 'Keller', 'jonas.keller@example.com'),
('Laura', 'Schmid', 'laura.schmid@example.com'),
('David', 'Fischer', 'david.fischer@example.com'),
('Sara', 'Meier', 'sara.meier@example.com'),
('Thomas', 'Weber', 'thomas.weber@example.com');

-- 6) SPEAKER / GUEST / STAFF
INSERT INTO Speaker (personID, bio)
VALUES
(1, 'Expertin für Cloud Computing'),
(2, 'Spezialist für AI & Machine Learning');

INSERT INTO Guest (personID, company)
VALUES
(3, 'Google'),
(4, 'UBS'),
(5, 'ETH Zürich');

INSERT INTO Staff (personID, role)
VALUES
(6, 'Techniker');

-- 7) TRACKS
INSERT INTO Track (name, eventID)
VALUES
('Cloud Technologies', 1),
('Artificial Intelligence', 2);

-- 8) SESSIONS
INSERT INTO Session (title, startTime, endTime, language, "level", trackID, roomID)
VALUES
('Einführung in Cloud Computing', '2025-06-01 10:00', '2025-06-01 11:00', 'DE', 'Beginner', 1, 1),
('Deep Learning Grundlagen', '2025-09-10 10:00', '2025-09-10 11:30', 'EN', 'Intermediate', 2, 3);

-- 9) SESSION-SPEAKER N:M
INSERT INTO SessionSpeaker (personID, sessionID, role, "order")
VALUES
(1, 1, 'Lead Speaker', 1),
(2, 2, 'Lead Speaker', 1);

-- 10) TICKETTYPES
INSERT INTO TicketType (name, quota, price, eventID)
VALUES
('Standard', 500, 199.00, 1),
('VIP', 100, 499.00, 1),
('Standard', 400, 299.00, 2);

-- 11) TICKETS
INSERT INTO Ticket (status, ticketTypeID, guestID)
VALUES
('paid', 1, 3),
('paid', 1, 4),
('cancelled', 2, 3),
('paid', 3, 5);

-- 12) EXHIBITORS
INSERT INTO Exhibitor (name, contactPersonID)
VALUES
('Microsoft', 1),
('OpenAI', 2);

-- 13) BOOTHS
INSERT INTO Booth (zone, area, eventID)
VALUES
('A', '20m2', 1),
('B', '15m2', 1),
('A', '25m2', 2);

-- 14) BOOTH BOOKINGS
INSERT INTO BoothBooking (status, bookingFrom, bookingTo, exhibitorID, boothID)
VALUES
('confirmed', '2025-05-01', '2025-06-03', 1, 1),
('confirmed', '2025-05-10', '2025-06-03', 2, 2),
('pending',   '2025-08-01', '2025-09-12', 1, 3);

-- 15) EQUIPMENT & MATERIAL (TESTDATEN)

-- Geräte anlegen
INSERT INTO Equipment (name, description) VALUES
  ('Beamer 4K', 'Hochauflösender Projektor für Main Hall'),
  ('Whiteboard', 'Mobiles Whiteboard inkl. Stifte'),
  ('Handmikrofon', 'Drahtloses Mikrofon für Q&A'),
  ('Laptop-Adapter USB-C', 'Adapter für MacBooks');

-- Grundausstattung zu Räumen hinzufügen
-- Raum 1 (Main Hall) hat 2 Mikrofone und 1 Beamer
INSERT INTO RoomEquipment (roomID, equipmentID, amount) VALUES
    (1, 1, 1), -- Beamer
    (1, 3, 2); -- 2 Mikrofone

-- Raum 2 (Workshop Room) hat 1 Whiteboard
INSERT INTO RoomEquipment (roomID, equipmentID, amount) VALUES
    (2, 2, 1);

-- Zusatzbedarf für Sessions
-- Session 1 braucht extra Adapter
INSERT INTO SessionEquipment (sessionID, equipmentID, amount) VALUES
    (1, 4, 1);

-- 16) EDGE CASE DATEN (FEHLER PROVOZIEREN)

-- A) Für Q6.4: Eine Session OHNE TechCheck
-- Wir buchen eine Session in Room 4 ("Meeting Room B"), machen aber keinen Check dort.
INSERT INTO Session (title, startTime, endTime, language, "level", trackID, roomID)
VALUES ('Chaos Engineering (No Check)', '2025-06-02 14:00', '2025-06-02 15:30', 'EN', 'Advanced', 1, 4);

-- B) Für Speaker-Stress (Zu wenig Pause)
-- Speaker 1 (Anna Müller) hat schon Session 1 (endet 11:00 am 01.06.).
-- Wir geben ihr eine neue Session um 11:05 (nur 5 Min Pause!).
INSERT INTO Session (title, startTime, endTime, language, "level", trackID, roomID)
VALUES ('Cloud Security Deep Dive', '2025-06-01 11:05', '2025-06-01 12:00', 'DE', 'Expert', 1, 1);

INSERT INTO SessionSpeaker (personID, sessionID, role, "order")
VALUES (1, (SELECT sessionID FROM Session WHERE title = 'Cloud Security Deep Dive'), 'Lead', 1);

-- C) Für Equipment-Albtraum (Viel Material)
-- Eine Session, die extrem viel Zeug braucht (für die Query mit HAVING count > 2)
INSERT INTO Session (title, startTime, endTime, language, "level", trackID, roomID)
VALUES ('Live Hacking Demo', '2025-06-01 16:00', '2025-06-01 18:00', 'EN', 'Expert', 1, 1);

-- Wir brauchen die ID der neuen Session
-- (Da wir SERIAL nutzen, ist es schwer die ID zu raten, besser wir nutzen Subqueries oder schauen nach)
-- Angenommen, es ist Session 5 :
INSERT INTO SessionEquipment (sessionID, equipmentID, amount)
VALUES
    ((SELECT sessionID FROM Session WHERE title = 'Live Hacking Demo'), 1, 2), -- 2 Beamer
    ((SELECT sessionID FROM Session WHERE title = 'Live Hacking Demo'), 2, 1), -- 1 Whiteboard
    ((SELECT sessionID FROM Session WHERE title = 'Live Hacking Demo'), 4, 5); -- 5 Adapter