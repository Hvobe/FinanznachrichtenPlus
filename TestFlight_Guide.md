# TestFlight Deployment Guide for FinanzNachrichten

## Prerequisites
- Apple Developer Account (bereits vorhanden)
- Xcode mit gültigem Signing Certificate
- App Store Connect Zugang

## Schritt 1: App Icon erstellen
1. Das FN Logo muss in verschiedenen Größen exportiert werden:
   - 1024x1024px (App Store)
   - 180x180px (iPhone App Icon @3x)
   - 120x120px (iPhone App Icon @2x)
   - 87x87px (iPhone Settings @3x)
   - 58x58px (iPhone Settings @2x)
   - 60x60px (iPhone Notification @3x)
   - 40x40px (iPhone Notification @2x)

2. Icon zu Assets.xcassets hinzufügen:
   - Öffne `/FinanzNachrichten/Assets.xcassets/` in Xcode
   - Erstelle neues "iOS App Icon" Set
   - Ziehe die erstellten Icons in die entsprechenden Slots

## Schritt 2: App Konfiguration
1. In Xcode:
   - Öffne das Projekt
   - Wähle das FinanzNachrichten Target
   - Unter "General":
     - Display Name: "FinanzNachrichten"
     - Bundle Identifier: "com.yourcompany.finanznachrichten"
     - Version: "1.0.0"
     - Build: "1"

2. Unter "Signing & Capabilities":
   - Team auswählen
   - Automatic Signing aktivieren

## Schritt 3: Archive erstellen
```bash
# Im Terminal:
cd "/Users/hendrik/Finanznachrichten App/FinanzNachrichtenSwiftUI"

# Clean Build
xcodebuild clean -project FinanzNachrichten.xcodeproj -scheme FinanzNachrichten

# Archive erstellen
xcodebuild archive \
  -project FinanzNachrichten.xcodeproj \
  -scheme FinanzNachrichten \
  -archivePath ~/Desktop/FinanzNachrichten.xcarchive
```

Oder in Xcode:
1. Product → Archive
2. Warte bis der Build abgeschlossen ist

## Schritt 4: Upload zu App Store Connect
1. Im Xcode Organizer (öffnet sich automatisch nach Archive):
   - Wähle das Archive aus
   - Klicke "Distribute App"
   - Wähle "App Store Connect"
   - Wähle "Upload"
   - Folge den Anweisungen

## Schritt 5: TestFlight konfigurieren
1. Gehe zu App Store Connect (https://appstoreconnect.apple.com)
2. Wähle deine App
3. Gehe zu "TestFlight"
4. Warte bis der Build verarbeitet wurde (ca. 15-30 Minuten)
5. Füge Tester hinzu:
   - Interne Tester (bis zu 100)
   - Externe Tester (bis zu 10.000)
6. Erstelle eine Testgruppe und lade Tester ein

## Schritt 6: Build Info
Füge diese Informationen hinzu:
- **Was ist neu**: Beschreibe neue Features
- **Test Details**: Was sollen Tester beachten

## Wichtige Hinweise
- Der erste Upload kann länger dauern
- Export Compliance: Für Finanz-Apps meist "No Encryption"
- App Review für externe Tester kann 24-48 Stunden dauern

## Fehlerbehebung
- **Signing Fehler**: Überprüfe Zertifikate in Keychain
- **Upload Fehler**: Stelle sicher, dass die App ID in App Store Connect existiert
- **Processing Stuck**: Warte oder kontaktiere Apple Support

## Nächste Schritte nach TestFlight
1. Sammle Feedback von Testern
2. Behebe gefundene Bugs
3. Erhöhe Build-Nummer für neue Versionen
4. Wiederhole Upload-Prozess