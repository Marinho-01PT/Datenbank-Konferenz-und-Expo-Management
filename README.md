Datenbank-Konferenz- und Expo-Management

Dieses Projekt umfasst die Konzeption und Implementierung eines relationalen Datenbankmanagementsystems zur Verwaltung einer modernen Konferenz- und Expo-Veranstaltung. Abgebildet werden dabei sämtliche zentralen Prozesse: Veranstaltungsorte, Events, Räume, Tracks, Sessions, Personen (mit klar getrennten Rollen), Tickets sowie Aussteller und deren gebuchte Messestände. Ziel war es, ein konsistentes, normalisiertes Datenbankschema zu entwickeln und darauf aufbauend aussagekräftige SQL-Abfragen zur Analyse typischer Organisations- und Planungsszenarien zu erstellen.

Wahl des Datenbankmanagementsystems

Für die Umsetzung haben wir PostgreSQL gewählt. Die Datenbank bietet:
	•	vollständige SQL-Konformität
	•	eine stabile, leistungsfähige Open-Source-Architektur
	•	umfangreiche Unterstützung für Constraints, Fremdschlüssel und komplexe Joins
	•	fortgeschrittene Funktionen wie Window Functions und CTEs
	•	hohe Eignung für analytische Abfragen und Data-Insights

Damit erfüllt PostgreSQL alle Anforderungen unserer Aufgabenstellung. Zusätzlich ist das System in der Industrie weit verbreitet, was die Praxisrelevanz unseres Projekts erhöht.

Datenmodell

Ausgehend von einem konzeptionellen Entity-Relationship-Modell wurde ein vollständig normalisiertes Schema entwickelt, das Datenintegrität und klare Beziehungshierarchien sicherstellt. Zu den zentralen Entitäten gehören:
	•	Venue, Event, Room: Abbildung der räumlichen und organisatorischen Struktur
	•	Track, Session: Modellierung des inhaltlichen Programms
	•	Person mit Spezialisierungen Speaker, Guest, Staff: klare Trennung der Rollen
	•	TicketType, Ticket: Verwaltung des Ticketings
	•	Exhibitor, Booth, BoothBooking: realistische Modellierung des Expo-Bereichs
	•	SessionSpeaker: N:M-Beziehung zwischen Sessions und Speakern

Die Modellierung folgt den Prinzipien der 3. Normalform, wodurch Redundanzen vermieden und Updates sicher durchgeführt werden können.

Testdaten

Zur Demonstration der Systemfunktionalität wurden umfangreiche und realistische Testdaten erstellt, die:
	•	mehrere Veranstaltungen mit unterschiedlichen Profilen
	•	Sprecher, Gäste und Mitarbeitende
	•	Ticketverkäufe in verschiedenen Kategorien
	•	Buchungen von Messeständen
	•	überfüllte Räume für kritische Kapazitätsanalysen

abbilden. Alle Tabellen sind mit konsistenten, vielseitigen Daten gefüllt, um aussagekräftige Query-Ergebnisse zu ermöglichen.

SQL-Abfragen und Interpretation

Eine detaillierte Beschreibung aller SQL-Abfragen findet sich im Abschnitt „queries“ dieses Projekts. Jede Anfrage ist mit einer kurzen, narrativen Interpretation versehen, die erklärt:
	•	welches organisatorische Problem adressiert wird
	•	welche Erkenntnisse aus der Abfrage gewonnen werden
	•	wie diese Informationen in der Praxis genutzt werden könnten

Auf diese Weise entsteht eine nachvollziehbare Verbindung zwischen Datenbankstruktur, Abfragen und realistischen Entscheidungsszenarien im Konferenz- und Expo-Management.