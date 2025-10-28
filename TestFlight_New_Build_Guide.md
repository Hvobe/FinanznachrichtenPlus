# Neuen Build in TestFlight hochladen

## Schritt 1: Build-Nummer erhöhen

### In Xcode:
1. Öffne dein Projekt in Xcode
2. Wähle dein Target (FinanzNachrichten)
3. Gehe zu "General" Tab
4. Erhöhe die **Build-Nummer** (nicht Version!):
   - Version: 1.0 (bleibt gleich)
   - Build: 2 → 3 (oder höher)

**WICHTIG**: Jeder Upload braucht eine neue Build-Nummer!

## Schritt 2: Archive erstellen

### In Xcode:
1. Wähle echtes Gerät oder "Any iOS Device" als Target (nicht Simulator!)
2. Menu: **Product → Clean Build Folder** (⇧⌘K)
3. Menu: **Product → Archive**
4. Warte bis Build fertig ist (kann 5-10 Min dauern)

## Schritt 3: Upload zu App Store Connect

### Im Archives Organizer (öffnet sich automatisch):
1. Wähle dein Archive
2. Klicke "Distribute App"
3. Wähle folgende Optionen:
   - **App Store Connect** → Next
   - **Upload** → Next
   - **Automatisch manage signing** → Next
   - Warte auf Validierung
   - **Upload**

## Schritt 4: In App Store Connect

Nach 5-30 Minuten erscheint der Build:
1. Gehe zu [App Store Connect](https://appstoreconnect.apple.com)
2. Deine App → TestFlight
3. Der neue Build erscheint mit Status "Processing"
4. Nach Verarbeitung: **Exportkontrolle beantworten**

## Schritt 5: Build verteilen

### Für interne Tester:
- Build wird automatisch verfügbar

### Für externe Tester:
1. Gehe zu deiner externen Gruppe
2. Klicke auf "+" bei Builds
3. Wähle neuen Build
4. Speichern

## Schnell-Checkliste

```bash
# Terminal Commands für Automatisierung:
# 1. Build-Nummer automatisch erhöhen
xcrun agvtool next-version -all

# 2. Archive erstellen (Command Line)
xcodebuild -project FinanzNachrichten.xcodeproj \
  -scheme FinanzNachrichten \
  -configuration Release \
  -archivePath build/FinanzNachrichten.xcarchive \
  archive

# 3. IPA exportieren
xcodebuild -exportArchive \
  -archivePath build/FinanzNachrichten.xcarchive \
  -exportPath build \
  -exportOptionsPlist ExportOptions.plist
```

## Häufige Fehler

### "Build already exists"
- Build-Nummer nicht erhöht
- Lösung: Build-Nummer erhöhen, neu archivieren

### "No eligible devices"
- Simulator als Target ausgewählt
- Lösung: "Any iOS Device" wählen

### Build erscheint nicht in TestFlight
- Warte 30+ Minuten
- Check E-Mail für Fehler
- Prüfe App Store Connect für Warnungen

### "Missing compliance"
- Exportkontrolle nicht beantwortet
- Lösung: In TestFlight → Build → Compliance beantworten

## Pro-Tipps

1. **Versionierung**:
   - Version (1.0): Für große Updates
   - Build (1,2,3...): Für jeden TestFlight Upload

2. **Automatisierung**:
   - Nutze Fastlane für automatische Uploads
   - Oder Xcode Cloud (kostenlos bis 25h/Monat)

3. **Build-Beschreibung**:
   - Füge Changelog in TestFlight hinzu
   - Tester sehen was neu ist

4. **Parallel arbeiten**:
   - Während Upload läuft, kannst du weiter coden
   - Build-Nummer erst beim nächsten Archive erhöhen