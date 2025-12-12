# Konferenz- & Expo-Management Datenbank

## Projektübersicht
Dieses Projekt implementiert ein relationales Datenbanksystem zur zentralen und einheitlichen Verwaltung von Konferenzen und Ausstellungen. Das System ersetzt isolierte Planungstabellen durch eine konsistente Datenbasis, die alle Aspekte einer Veranstaltung abdeckt – von der Programmplanung über das Ressourcenmanagement bis hin zur Expo-Verwaltung.

Das Ziel war die Entwicklung eines robusten Schemas, das Geschäftsregeln direkt auf Datenbankebene erzwingt, um Datenintegrität ohne vorgeschaltete Applikationslogik zu gewährleisten.

## Autoren
* **Keanu Belo da Silva**
* **Bruno Marinho**
* **Sebastian Oliver Jung**

---

## Funktionalitäten & Umfang

Die Datenbank deckt fünf Kernbereiche des Event-Managements ab:

1.  **Event- & Venue-Management**
    * Verwaltung von Veranstaltungsorten (Venues) und Events.
    * Hierarchische Struktur: Venue -> Räume -> Sessions.
    * Zeitliche Validierung von Veranstaltungszeiträumen.

2.  **Programmplanung & Speaker**
    * Detaillierte Session-Planung mit Zuweisung zu Tracks und Räumen.
    * Verwaltung von Speakern, Gästen und Mitarbeitern (Spezialisierung der Entität `Person`).
    * Vermeidung von Doppelbuchungen für Speaker und Räume.

3.  **Expo- & Stand-Management**
    * Verwaltung von Ausstellern (Exhibitors) und Standflächen (Booths).
    * Buchungssystem mit automatischer Prüfung auf zeitliche Überschneidungen (`BoothBooking`).

4.  **Ticketing**
    * Definition von Ticket-Kategorien (z. B. VIP, Standard) mit Preisen und Kontingenten.
    * Echtzeit-Überwachung der Ticketverfügbarkeit.

5.  **Technik & Logistik**
    * Verwaltung von technischer Ausstattung (`Equipment`) und Zuweisung zu Räumen (Grundausstattung) oder Sessions (Zusatzbedarf).
    * Protokollierung von technischen Checks (`TechCheck`) zur Qualitätssicherung.

---

## Technische Implementierung

Das System wurde für **PostgreSQL** optimiert, um fortgeschrittene Mechanismen zur Integritätssicherung zu nutzen.

### 1. Datenintegrität & Constraints
Es werden strikte `CHECK`-Constraints und Fremdschlüsselbeziehungen verwendet:
* **Zeit-Logik:** Startzeiten müssen vor Endzeiten liegen (z. B. bei `Event`, `Session`).
* **Wertebereiche:** Preise und Kapazitäten dürfen nicht negativ sein.
* **Status-Validierung:** Beschränkung auf vordefinierte Werte (z. B. 'paid', 'cancelled') anstelle von Freitext.

### 2. Konfliktvermeidung (Advanced SQL)
Um Überbuchungen physikalisch unmöglich zu machen, werden PostgreSQL-spezifische `EXCLUDE`-Constraints verwendet:
* **Raumbelegung:** Ein Raum kann nicht zeitgleich von zwei Sessions belegt werden.
* **Standbuchung:** Ein Messestand kann nicht zeitgleich an zwei Aussteller vermietet werden.
  *(Implementiert mittels `GIST`-Index und `tsrange`)*.

### 3. Business-Logik durch Trigger
Komplexe Geschäftsregeln, die mehrere Tabellen betreffen, sind durch `PL/pgSQL`-Trigger automatisiert:
* **Speaker-Konflikt:** Verhindert, dass ein Speaker zur gleichen Zeit in zwei verschiedenen Sessions eingeplant wird.
* **Ticket-Kontingente:** Verhindert den Verkauf von Tickets, wenn das definierte Kontingent (`Quota`) erschöpft ist.

### 4. Normalisierung
Das Schema befindet sich in der **3. Normalform (3NF)**. Redundanzen wurden entfernt (z. B. Entfernung der `eventID` aus `BoothBooking`, da diese transitiv über `Booth` abgeleitet wird), um Inkonsistenzen zu vermeiden.

---

## Installation & Ausführung

### Voraussetzungen
* PostgreSQL (Version 12 oder höher empfohlen)
* Erweiterung `btree_gist` (wird im Skript aktiviert)

### Schritte
1.  **Datenbank erstellen:** Erstellen Sie eine leere Datenbank (z. B. `conference_db`).
2.  **Struktur anlegen:** Führen Sie das Skript `Datenbank.sql` aus.
    * *Dies erstellt alle Tabellen, Views, Constraints und Trigger.*
3.  **Testdaten laden:** Führen Sie das Skript `testdata.sql` aus.
    * *Dies befüllt das System mit realistischen Daten und speziellen Edge-Case-Szenarien.*

---

## Analyse & Abfragen

Das Projekt beinhaltet eine Sammlung von SQL-Skripten zur Auswertung der Daten (`queries/`). Neben Standard-Reports (Umsatz, Belegung) sind komplexe analytische Abfragen enthalten:

* **Risiko-Analyse:** Identifikation von Sessions ohne erfolgreichen TechCheck kurz vor Start.
* **Logistik-Planung:** Ermittlung von Sessions mit hohem Materialbedarf.
* **Performance-Metriken:** Vergleich von inhaltlicher Dichte (Anzahl Sessions) und wirtschaftlichem Erfolg (Umsatz) pro Event.
* **Stress-Test:** Identifikation von Speakern mit kritisch kurzen Pausen zwischen Sessions.