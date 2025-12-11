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
    email     VARCHAR(255) NOT NULL,
    CONSTRAINT uq_person_email UNIQUE (email)
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