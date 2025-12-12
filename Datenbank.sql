-- Sicherheitsdrops (damit das Skript mehrfach ausführbar ist)

DROP TABLE IF EXISTS SessionSpeaker   CASCADE;
DROP TABLE IF EXISTS BoothBooking     CASCADE;
DROP TABLE IF EXISTS Booth            CASCADE;
DROP TABLE IF EXISTS Exhibitor        CASCADE;
DROP TABLE IF EXISTS Ticket           CASCADE;
DROP TABLE IF EXISTS TicketType       CASCADE;
DROP TABLE IF EXISTS Staff            CASCADE;
DROP TABLE IF EXISTS Guest            CASCADE;
DROP TABLE IF EXISTS Speaker          CASCADE;
DROP TABLE IF EXISTS Person           CASCADE;
DROP TABLE IF EXISTS Session          CASCADE;
DROP TABLE IF EXISTS Track            CASCADE;
DROP TABLE IF EXISTS TechCheck        CASCADE;
DROP TABLE IF EXISTS Room             CASCADE;
DROP TABLE IF EXISTS Event            CASCADE;
DROP TABLE IF EXISTS Venue            CASCADE;
DROP TABLE IF EXISTS SessionEquipment CASCADE;
DROP TABLE IF EXISTS RoomEquipment    CASCADE;
DROP TABLE IF EXISTS Equipment        CASCADE;



-- 1) EVENT-, ORTS- & RAUM-MANAGEMENT

CREATE TABLE Venue (
    venueID  SERIAL PRIMARY KEY,
    name     VARCHAR(255) NOT NULL,
    street   VARCHAR(255) NOT NULL,
    zipCode  VARCHAR(20)  NOT NULL,
    city     VARCHAR(255) NOT NULL,
    country  VARCHAR(255) NOT NULL,
    CONSTRAINT uq_venue_name UNIQUE (name)
);

CREATE TABLE Event (
    eventID   SERIAL PRIMARY KEY,
    name      VARCHAR(255) NOT NULL,
    startDate TIMESTAMP    NOT NULL,
    endDate   TIMESTAMP    NOT NULL,
    venueID   INT          NOT NULL,
    CONSTRAINT fk_event_venue FOREIGN KEY (venueID) REFERENCES Venue(venueID),
    CONSTRAINT uq_event_name UNIQUE (name)
);

CREATE TABLE Room (
    roomID   SERIAL PRIMARY KEY,
    name     VARCHAR(255) NOT NULL,
    capacity INT          NOT NULL CHECK (capacity > 0),
    venueID  INT          NOT NULL,
    CONSTRAINT fk_room_venue FOREIGN KEY (venueID) REFERENCES Venue(venueID)
);

CREATE TABLE TechCheck (
    techCheckID SERIAL PRIMARY KEY,
    checkTime   TIMESTAMP   NOT NULL,
    status      VARCHAR(50) NOT NULL CHECK (status IN ('pending','ok','failed')),
    roomID      INT         NOT NULL,
    CONSTRAINT fk_techcheck_room FOREIGN KEY (roomID) REFERENCES Room(roomID)
);


-- 2) PERSONEN & ROLLEN

CREATE TABLE Person (
    personID  SERIAL PRIMARY KEY,
    firstName VARCHAR(255) NOT NULL,
    lastName  VARCHAR(255) NOT NULL,
    email     VARCHAR(255) NOT NULL
);

CREATE TABLE Speaker (
    personID INT PRIMARY KEY,
    bio      TEXT,
    CONSTRAINT fk_speaker_person FOREIGN KEY (personID) REFERENCES Person(personID)
);

CREATE TABLE Guest (
    personID INT PRIMARY KEY,
    company  VARCHAR(255),
    CONSTRAINT fk_guest_person FOREIGN KEY (personID) REFERENCES Person(personID)
);

CREATE TABLE Staff (
    personID INT PRIMARY KEY,
    role     VARCHAR(50) NOT NULL,
    CONSTRAINT fk_staff_person FOREIGN KEY (personID) REFERENCES Person(personID)
);


-- 3) PROGRAMM- & SESSION-PLANUNG

CREATE TABLE Track (
    trackID SERIAL PRIMARY KEY,
    name    VARCHAR(255) NOT NULL,
    eventID INT          NOT NULL,
    CONSTRAINT fk_track_event FOREIGN KEY (eventID) REFERENCES Event(eventID)
);

CREATE TABLE Session (
    sessionID SERIAL PRIMARY KEY,
    title     VARCHAR(255) NOT NULL,
    startTime TIMESTAMP    NOT NULL,
    endTime   TIMESTAMP    NOT NULL,
    language  VARCHAR(50)  NOT NULL,
    "level"   VARCHAR(50)  NOT NULL,
    trackID   INT          NOT NULL,
    roomID    INT          NOT NULL,
    CONSTRAINT fk_session_track FOREIGN KEY (trackID) REFERENCES Track(trackID),
    CONSTRAINT fk_session_room  FOREIGN KEY (roomID)  REFERENCES Room(roomID)
);


-- 4) TICKETING

CREATE TABLE TicketType (
    ticketTypeID SERIAL PRIMARY KEY,
    name         VARCHAR(255)  NOT NULL,
    quota        INT           NOT NULL CHECK (quota >= 0),
    price        DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    eventID      INT           NOT NULL,
    CONSTRAINT fk_tickettype_event FOREIGN KEY (eventID) REFERENCES Event(eventID)
);

CREATE TABLE Ticket (
    ticketID     SERIAL PRIMARY KEY,
    status       VARCHAR(50) NOT NULL CHECK (status IN ('paid','pending','cancelled')),
    ticketTypeID INT         NOT NULL,
    guestID      INT         NOT NULL,
    CONSTRAINT fk_ticket_type  FOREIGN KEY (ticketTypeID) REFERENCES TicketType(ticketTypeID),
    CONSTRAINT fk_ticket_guest FOREIGN KEY (guestID)      REFERENCES Guest(personID)
);


-- 5) EXPO & STÄNDE

CREATE TABLE Exhibitor (
    exhibitorID     SERIAL PRIMARY KEY,
    name            VARCHAR(255) NOT NULL,
    contactPersonID INT          NOT NULL,
    CONSTRAINT fk_exhibitor_contact FOREIGN KEY (contactPersonID) REFERENCES Person(personID)
);

CREATE TABLE Booth (
    boothID SERIAL PRIMARY KEY,
    zone    VARCHAR(50)  NOT NULL,
    area    VARCHAR(50)  NOT NULL,
    eventID INT          NOT NULL,
    CONSTRAINT fk_booth_event FOREIGN KEY (eventID) REFERENCES Event(eventID)
);

CREATE TABLE BoothBooking (
    bookingID   SERIAL PRIMARY KEY,
    status      VARCHAR(50) NOT NULL CHECK (status IN ('pending','confirmed','cancelled')),
    bookingFrom TIMESTAMP   NOT NULL,
    bookingTo   TIMESTAMP   NOT NULL,
    exhibitorID INT         NOT NULL,
    boothID     INT         NOT NULL,
    CONSTRAINT fk_booking_exhibitor FOREIGN KEY (exhibitorID) REFERENCES Exhibitor(exhibitorID),
    CONSTRAINT fk_booking_booth     FOREIGN KEY (boothID)     REFERENCES Booth(boothID)
);


-- 6) N:M VERKNÜPFUNG SESSION–SPEAKER

CREATE TABLE SessionSpeaker (
    personID  INT NOT NULL,
    sessionID INT NOT NULL,
    role      VARCHAR(50) NOT NULL,
    "order"   INT,

    CONSTRAINT pk_sessionspeaker
        PRIMARY KEY (personID, sessionID),

    CONSTRAINT fk_sessionspeaker_person
        FOREIGN KEY (personID)  REFERENCES Speaker(personID),

    CONSTRAINT fk_sessionspeaker_session
        FOREIGN KEY (sessionID) REFERENCES Session(sessionID)
);

-- ======================================================
-- 6b) EQUIPMENT & MATERIAL (WIEDER EINGEFÜGT)
-- ======================================================

CREATE TABLE Equipment (
    equipmentID SERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    description TEXT
);

-- n:m Beziehung: Was ist standardmäßig im Raum?
CREATE TABLE RoomEquipment (
    roomID      INT NOT NULL,
    equipmentID INT NOT NULL,
    amount      INT DEFAULT 1 CHECK (amount > 0),

    CONSTRAINT pk_roomequipment
       PRIMARY KEY (roomID, equipmentID),

    CONSTRAINT fk_roomeq_room
       FOREIGN KEY (roomID) REFERENCES Room(roomID),
    CONSTRAINT fk_roomeq_equipment
       FOREIGN KEY (equipmentID) REFERENCES Equipment(equipmentID)
);

-- n:m Beziehung: Was wird für eine Session extra benötigt?
CREATE TABLE SessionEquipment (
    sessionID   INT NOT NULL,
    equipmentID INT NOT NULL,
    amount      INT DEFAULT 1 CHECK (amount > 0),

    CONSTRAINT pk_sessionequipment
      PRIMARY KEY (sessionID, equipmentID),

    CONSTRAINT fk_sessioneq_session
      FOREIGN KEY (sessionID) REFERENCES Session(sessionID),
    CONSTRAINT fk_sessioneq_equipment
      FOREIGN KEY (equipmentID) REFERENCES Equipment(equipmentID)
);


-- ======================================================
-- 7) CONSTRAINTS & REGELN (LOGIK)
-- ======================================================

-- Zeit-Logik: Ende muss nach Start sein
ALTER TABLE Event ADD CONSTRAINT check_event_dates CHECK (endDate > startDate);
ALTER TABLE Session ADD CONSTRAINT check_session_dates CHECK (endTime > startTime);
ALTER TABLE BoothBooking ADD CONSTRAINT check_booking_dates CHECK (bookingTo > bookingFrom);

-- Werte-Logik: Keine negativen Preise oder Kapazitäten
ALTER TABLE Room ADD CONSTRAINT check_capacity_positive CHECK (capacity > 0);
ALTER TABLE TicketType ADD CONSTRAINT check_price_positive CHECK (price >= 0);
ALTER TABLE TicketType ADD CONSTRAINT check_quota_positive CHECK (quota >= 0);
ALTER TABLE Person ADD CONSTRAINT uq_person_email UNIQUE (email);


-- Status-Logik: Nur erlaubte Werte (Enum-Ersatz)
ALTER TABLE Ticket ADD CONSTRAINT check_ticket_status
    CHECK (status IN ('paid', 'reserved', 'cancelled', 'valid', 'used'));
ALTER TABLE TechCheck ADD CONSTRAINT check_tech_status
    CHECK (status IN ('OK', 'failed', 'pending'));

-- Aktiviert die Erweiterung für komplexe Indices
CREATE EXTENSION IF NOT EXISTS btree_gist;

ALTER TABLE BoothBooking
    ADD CONSTRAINT no_booth_overlap
    EXCLUDE USING GIST (
    boothID WITH =,
    tsrange(bookingFrom, bookingTo) WITH &&
);

ALTER TABLE Session
    ADD CONSTRAINT no_room_overlap
    EXCLUDE USING GIST (
    roomID WITH =,
    tsrange(startTime, endTime) WITH &&
);

-- ======================================================
-- 8) TRIGGER & FUNKTIONEN (KOMPLEXE LOGIK)
-- ======================================================

-- A) SPEAKER-KONFLIKT PRÜFUNG
-- Verhindert, dass ein Speaker zur gleichen Zeit in zwei Sessions ist.
CREATE OR REPLACE FUNCTION check_speaker_conflict()
RETURNS TRIGGER AS $$
DECLARE
conflict_count INT;
BEGIN
    -- Prüfen, ob der Speaker zur gleichen Zeit woanders spricht
SELECT COUNT(*)
INTO conflict_count
FROM SessionSpeaker ss
         JOIN Session s ON ss.sessionID = s.sessionID
WHERE ss.personID = NEW.personID           -- Gleicher Speaker
  AND ss.sessionID <> NEW.sessionID        -- Nicht die aktuelle Session
  AND (
    -- Prüft auf Zeit-Überlappung mit der neuen Session
    -- (Holt die Zeiten der neuen Session aus der Tabelle Session)
    SELECT tsrange(s_new.startTime, s_new.endTime) && tsrange(s.startTime, s.endTime)
FROM Session s_new
WHERE s_new.sessionID = NEW.sessionID
    );

IF conflict_count > 0 THEN
        RAISE EXCEPTION 'Konflikt: Dieser Speaker ist zur gleichen Zeit bereits in einer anderen Session gebucht.';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_speaker_conflict
    AFTER INSERT OR UPDATE ON SessionSpeaker
                        FOR EACH ROW EXECUTE FUNCTION check_speaker_conflict();


-- B) TICKET-KONTINGENT PRÜFUNG
-- Verhindert, dass mehr Tickets verkauft werden als "quota" erlaubt.
CREATE OR REPLACE FUNCTION check_ticket_quota()
RETURNS TRIGGER AS $$
DECLARE
current_sold INT;
    max_quota INT;
BEGIN
    -- Kontingent für diesen Typ abrufen
SELECT quota INTO max_quota FROM TicketType WHERE ticketTypeID = NEW.ticketTypeID;

-- Bisher verkaufte Tickets zählen (inklusive dem neuen, falls AFTER trigger, aber wir nutzen BEFORE)
SELECT COUNT(*) INTO current_sold FROM Ticket WHERE ticketTypeID = NEW.ticketTypeID;

IF current_sold >= max_quota THEN
        RAISE EXCEPTION 'Ausverkauft: Das Kontingent für Ticket-Typ ID % ist erschöpft.', NEW.ticketTypeID;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_ticket_quota
    BEFORE INSERT ON Ticket
    FOR EACH ROW EXECUTE FUNCTION check_ticket_quota();
