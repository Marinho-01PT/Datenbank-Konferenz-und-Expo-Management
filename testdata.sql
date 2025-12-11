-- VENUES 
INSERT INTO Venue (name, street, zipCode, city, country) VALUES
('Messe Zürich', 'Wallisellenstrasse 49', '8050', 'Zürich', 'Schweiz'),
('Congress Center Basel', 'Messeplatz 21', '4058', 'Basel', 'Schweiz'),
('Kongresshaus St. Gallen', 'Dufourstrasse 50', '9000', 'St. Gallen', 'Schweiz');


-- EVENTS 
INSERT INTO Event (name, startDate, endDate, venueID) VALUES
('TechExpo 2025', '2025-06-01 09:00', '2025-06-03 18:00', 1),
('AI Summit 2025', '2025-09-10 09:00', '2025-09-12 17:00', 3),
('CyberSecurity Days 2025', '2025-03-15 08:30', '2025-03-16 18:00', 2);


-- ROOMS 
INSERT INTO Room (name, capacity, venueID) VALUES
('Main Hall', 500, 1),
('Workshop A', 120, 1),
('Workshop B', 80, 1),
('Auditorium', 300, 2),
('Breakout Room', 60, 2),
('Forum Room', 200, 3),
('Seminarraum 1', 40, 3);


-- PERSONEN
INSERT INTO Person (firstName, lastName, email) VALUES
('Anna','Müller','anna.mueller@example.com'),
('Jonas','Keller','jonas.keller@example.com'),
('Laura','Schmid','laura.schmid@example.com'),
('David','Fischer','david.fischer@example.com'),
('Sara','Meier','sara.meier@example.com'),
('Thomas','Weber','thomas.weber@example.com'),
('Mia','Ziegler','mia.ziegler@example.com'),
('Luca','Hartmann','luca.hartmann@example.com'),
('Felix','Brunner','felix.brunner@example.com'),
('Elena','Graf','elena.graf@example.com'),
('Samuel','Huber','samuel.huber@example.com'),
('Marie','Kuhn','marie.kuhn@example.com'),
('Daniel','Roth','daniel.roth@example.com'),
('Julia','Vogt','julia.vogt@example.com'),
('Oliver','Arnold','oliver.arnold@example.com'),
('Nina','Bach','nina.bach@example.com'),
('Timo','Sutter','timo.sutter@example.com'),
('Sophie','Lutz','sophie.lutz@example.com'),
('Jan','Hofer','jan.hofer@example.com'),
('Klara','Bieri','klara.bieri@example.com'),
('Martin','Frick','martin.frick@example.com'),
('Bianca','Fischer','bianca.fischer@example.com'),
('Peter','Schwarz','peter.schwarz@example.com'),
('Sandra','Keller','sandra.keller@example.com'),
('Marius','Graf','marius.graf@example.com'),
('Vanessa','Hug','vanessa.hug@example.com'),
('Kevin','Ritter','kevin.ritter@example.com'),
('Sarah','Kunz','sarah.kunz@example.com'),
('Philipp','Brändli','philipp.braendli@example.com'),
('Aline','Weiss','aline.weiss@example.com'),
('Leon','Hauser','leon.hauser@example.com'),
('Mira','Lanz','mira.lanz@example.com'),
('Robin','Germann','robin.germann@example.com'),
('Sven','Egli','sven.egli@example.com'),
('Carla','Imhof','carla.imhof@example.com'),
('Ben','Maurer','ben.maurer@example.com'),
('Paula','Schärer','paula.schaerer@example.com'),
('Joel','Felder','joel.felder@example.com'),
('Finn','Hertig','finn.hertig@example.com'),
('Selina','Grob','selina.grob@example.com');


-- SPEAKER 
INSERT INTO Speaker (personID, bio) VALUES
(1,'Cloud Expertin'),
(2,'AI Researcher'),
(3,'Cyber Security Analyst'),
(4,'Data Science Professor'),
(5,'DevOps Engineer'),
(6,'Blockchain Specialist');


-- GUESTS (IDs 7–20 + 31–40)
INSERT INTO Guest (personID, company) VALUES
(7,'Google'), (8,'UBS'), (9,'ETH Zürich'), (10,'Microsoft'),
(11,'Swisscom'), (12,'IBM'), (13,'OpenAI'), (14,'SAP'),
(15,'Oracle'), (16,'NVIDIA'), (17,'Credit Suisse'),
(18,'PostFinance'), (19,'Zalando'), (20,'Swiss Life'),
(31,'Google'), (32,'ETH Zürich'), (33,'Swisscom'), (34,'UBS'),
(35,'OpenAI'), (36,'Microsoft'), (37,'SAP'), (38,'NVIDIA'),
(39,'IBM'), (40,'PostFinance');


-- STAFF 
INSERT INTO Staff (personID, role) VALUES
(21,'Techniker'), (22,'Security'), (23,'Organisator'),
(24,'Logistik'), (25,'Support'), (26,'Stage Manager'),
(27,'Video Crew'), (28,'Catering'), (29,'Moderation'),
(30,'Customer Desk');


-- TRACKS
INSERT INTO Track (name, eventID) VALUES
('Cloud Technologies', 1),
('Artificial Intelligence', 1),
('DevOps & Automation', 1),
('Machine Learning', 2),
('Neural Networks', 2),
('Cyber Defense', 3),
('Threat Analysis', 3);


-- SESSIONS
INSERT INTO Session (title, startTime, endTime, language, "level", trackID, roomID) VALUES
('Einführung in Cloud Computing','2025-06-01 10:00','2025-06-01 11:00','DE','Beginner',1,1),
('High-Performance Cloud','2025-06-01 11:30','2025-06-01 12:30','EN','Advanced',1,2),
('AI Grundlagen','2025-06-01 13:00','2025-06-01 14:30','EN','Beginner',2,1),
('AI Ethics & Safety','2025-06-01 15:00','2025-06-01 16:00','DE','Intermediate',2,3),
('DevOps Pipelines','2025-06-02 10:00','2025-06-02 11:00','EN','Beginner',3,2),
('Kubernetes Scaling','2025-06-02 11:00','2025-06-02 12:00','EN','Advanced',3,2),
('Machine Learning Intro','2025-09-10 10:00','2025-09-10 11:00','EN','Beginner',4,6),
('Neural Networks Deep Dive','2025-09-10 11:00','2025-09-10 12:30','EN','Advanced',5,6),
('Cyber Defense Basics','2025-03-15 09:00','2025-03-15 10:00','DE','Beginner',6,4),
('Threat Detection Workshop','2025-03-15 10:30','2025-03-15 12:00','EN','Intermediate',7,5),
('Zero Trust Security','2025-03-15 13:00','2025-03-15 14:00','EN','Advanced',6,4),
('Cloud Cost Optimization','2025-06-02 14:00','2025-06-02 15:00','EN','Intermediate',1,2),
('Building ML Pipelines','2025-09-11 09:00','2025-09-11 10:00','EN','Beginner',4,7),
('Large Language Models','2025-09-11 10:30','2025-09-11 12:00','EN','Advanced',5,6),
('Modern Threat Hunting','2025-03-16 09:00','2025-03-16 10:00','EN','Intermediate',7,5);


-- SESSION SPEAKER
INSERT INTO SessionSpeaker (personID, sessionID, role, "order") VALUES
(1,1,'Lead',1),(4,2,'Lead',1),(2,3,'Lead',1),(6,4,'Lead',1),
(5,5,'Lead',1),(5,6,'Co-Lead',2),(3,9,'Lead',1),(3,10,'Lead',1),
(4,11,'Lead',1),(2,12,'Lead',1),(4,13,'Lead',1),(6,15,'Lead',1);


-- TICKET TYPES
INSERT INTO TicketType (name, quota, price, eventID) VALUES
('Standard',500,199,1),('VIP',100,499,1),
('Standard',400,299,2),('Premium',150,599,2),
('Standard',200,149,3),('VIP',50,399,3);


-- TICKETS 
INSERT INTO Ticket (status, ticketTypeID, guestID) VALUES
('paid',1,7),('paid',1,8),('paid',1,9),('paid',1,10),
('paid',2,11),('cancelled',2,7),('paid',2,12),
('paid',3,13),('paid',3,14),('paid',3,15),('paid',3,16),
('paid',4,8),('paid',4,9),('paid',4,17),('paid',4,18),
('paid',5,19),('paid',5,20),('paid',5,11),
('paid',6,12),('cancelled',6,13),('paid',6,14),
('paid',1,15),('paid',1,16),('paid',1,17),
('paid',3,18),('paid',3,19),('paid',3,20);

-- Viele extra Tickets für realistische Überfüllung & Analysen
INSERT INTO Ticket (status, ticketTypeID, guestID)
SELECT 'paid', 1, g.personID FROM Guest g LIMIT 120;

INSERT INTO Ticket (status, ticketTypeID, guestID)
SELECT 'paid', 2, g.personID FROM Guest g LIMIT 20;

INSERT INTO Ticket (status, ticketTypeID, guestID)
SELECT 'paid', 3, g.personID FROM Guest g LIMIT 60;

INSERT INTO Ticket (status, ticketTypeID, guestID)
SELECT 'paid', 4, g.personID FROM Guest g LIMIT 25;

INSERT INTO Ticket (status, ticketTypeID, guestID)
SELECT 'paid', 3, g.personID FROM Guest g CROSS JOIN generate_series(1,5) LIMIT 250;


-- EXHIBITORS
INSERT INTO Exhibitor (name, contactPersonID) VALUES
('Microsoft',1),('OpenAI',2),('NVIDIA',4),
('Cisco',5),('Accenture',6);


-- BOOTHS
INSERT INTO Booth (zone, area, eventID) VALUES
('A','20m2',1),('B','15m2',1),('A','30m2',2),
('C','25m2',3),('B','22m2',1);


-- BOOTH BOOKINGS (integriert + erweitert)
INSERT INTO BoothBooking (status, bookingFrom, bookingTo, exhibitorID, boothID) VALUES
('confirmed','2025-04-01','2025-06-03',1,1),
('confirmed','2025-05-15','2025-06-03',2,2),
('pending','2025-08-01','2025-09-12',3,3),
('confirmed','2025-02-01','2025-03-16',4,4),
('confirmed','2025-04-10','2025-06-03',5,5),
('confirmed','2025-01-01','2025-12-31',1,1),
('confirmed','2025-03-01','2025-11-15',2,2),
('pending','2025-05-01','2025-06-15',3,3),
('confirmed','2025-04-01','2025-09-30',4,4),
('cancelled','2025-02-10','2025-06-03',5,5);