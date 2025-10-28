# TestFlight für Externe Tester - Anleitung

## Voraussetzungen
- App ist bereits für interne Tester verfügbar
- Apple Developer Account
- App Store Connect Zugang

## Schritt-für-Schritt Anleitung

### 1. Build hochladen (falls noch nicht geschehen)
```bash
# Archive erstellen in Xcode
1. Product > Archive
2. Distribute App > App Store Connect > Upload
3. Warte bis der Build in App Store Connect erscheint (ca. 5-30 Min)
```

### 2. In App Store Connect einloggen
- Gehe zu [App Store Connect](https://appstoreconnect.apple.com)
- Wähle deine App aus
- Navigiere zu "TestFlight"

### 3. Build für externe Tests vorbereiten

#### A. Exportkontroll-Compliance
1. Klicke auf den Build
2. Beantworte die Exportkontroll-Frage:
   - "Verwendet Ihre App Verschlüsselung?" 
   - Normalerweise: "Nein" (wenn nur HTTPS verwendet wird)

#### B. Testinformationen hinzufügen
1. Gehe zu "Testinformationen" im linken Menü
2. Fülle aus:
   - **Beta-App-Beschreibung**: Was ist neu in dieser Version
   - **Feedback-E-Mail**: Deine Support-E-Mail
   - **Marketing-URL**: Optional (z.B. Website)
   - **Datenschutzrichtlinien-URL**: Pflicht für externe Tester!

### 4. Externe Testergruppe erstellen
1. Klicke auf "+" neben "Externe Gruppen"
2. Gruppenname eingeben (z.B. "Beta Tester")
3. Build zur Gruppe hinzufügen
4. Tester einladen:
   - E-Mail-Adressen eingeben
   - Oder öffentlichen Link erstellen (bis zu 10.000 Tester)

### 5. Beta-App-Review
**WICHTIG**: Externe Tests benötigen eine Apple Review!

1. Sobald du Tester hinzufügst, startet automatisch die Review
2. Fülle das Review-Formular aus:
   - **Kontaktinformationen**
   - **Anmeldeinformationen** (falls App Login benötigt)
   - **Hinweise für Reviewer**: Erkläre Hauptfunktionen
   
3. Review dauert normalerweise 24-48 Stunden

### 6. Nach der Genehmigung
- Tester erhalten automatisch eine Einladungs-E-Mail
- Oder teile den öffentlichen Link
- Tester müssen:
  1. TestFlight App installieren
  2. Link öffnen oder Code eingeben
  3. App installieren

## Wichtige Unterschiede zu internen Tests

| Feature | Interne Tester | Externe Tester |
|---------|----------------|----------------|
| Max. Anzahl | 100 | 10.000 |
| Apple Review | Nein | Ja (24-48h) |
| Gültigkeit | 90 Tage | 90 Tage |
| Datenschutz-URL | Optional | Pflicht |

## Tipps
- **Datenschutz-URL**: Erstelle eine einfache Seite, z.B. auf GitHub Pages
- **Review-Hinweise**: Sei präzise, was die Hauptfunktionen sind
- **Test-Accounts**: Stelle Demo-Accounts bereit, falls Login nötig
- **Feedback**: Aktiviere "Feedback per E-Mail" für Crash-Reports

## Häufige Probleme

### "Missing Compliance" Error
- Exportkontroll-Compliance nicht beantwortet
- Lösung: Build anklicken > Compliance beantworten

### Review abgelehnt
- Meist wegen fehlender Datenschutzrichtlinie
- Oder unklare App-Beschreibung
- Lösung: Informationen vervollständigen

### Tester erhalten keine Einladung
- E-Mail im Spam-Ordner
- Lösung: Öffentlichen Link verwenden

## Nächste Schritte nach TestFlight
1. Feedback sammeln (90 Tage Zeit)
2. Bugs fixen
3. Neue Builds können ohne erneute Review verteilt werden
4. Finale Version für App Store vorbereiten