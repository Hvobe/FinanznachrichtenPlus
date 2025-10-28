# TestFlight Deployment Checklist

## ✅ Vorbereitung
- [ ] Apple Developer Account aktiv
- [ ] App Store Connect Zugang
- [ ] Xcode installiert und aktuell

## ✅ App Icon
- [ ] FN Logo in hoher Auflösung (min. 1024x1024px) vorhanden
- [ ] ImageMagick installieren: `brew install imagemagick`
- [ ] App Icons generieren: `./generate_app_icons.sh /pfad/zum/fn-logo.png`
- [ ] Icons in Xcode überprüfen

## ✅ Projekt Konfiguration
- [ ] Bundle Identifier festlegen (z.B. com.finanznachrichten.app)
- [ ] App Name: "FinanzNachrichten"
- [ ] Version: 1.0.0
- [ ] Build Number: 1
- [ ] Team auswählen in Signing & Capabilities
- [ ] Automatic Signing aktivieren

## ✅ Code Fixes bereits erledigt
- [x] Duplicate headline in MarketSummaryView entfernt
- [x] Market text synchronization beschleunigt (0.15s)
- [x] Section spacing vereinheitlicht (32px)
- [x] Text cutoff in news detail view behoben

## ✅ Build & Archive
- [ ] Clean Build: Product → Clean Build Folder
- [ ] Archive erstellen: Product → Archive
- [ ] Warten bis Archive im Organizer erscheint

## ✅ Upload zu App Store Connect
- [ ] Im Organizer: "Distribute App" → "App Store Connect" → "Upload"
- [ ] Export Compliance: "No Encryption" auswählen
- [ ] Upload abwarten

## ✅ App Store Connect Setup
- [ ] App in App Store Connect erstellen (falls noch nicht vorhanden)
- [ ] App Information ausfüllen:
  - [ ] App Name
  - [ ] Beschreibung
  - [ ] Keywords
  - [ ] Support URL
  - [ ] Marketing URL (optional)
- [ ] Screenshots vorbereiten (iPhone 6.7", 6.1", 5.5")

## ✅ TestFlight Konfiguration
- [ ] Warten bis Build verarbeitet wurde (15-30 Min)
- [ ] Build für TestFlight freigeben
- [ ] Testinformationen hinzufügen:
  - [ ] Was ist zu testen
  - [ ] Bekannte Issues
  - [ ] Feedback-Fokus
- [ ] Testergruppen erstellen:
  - [ ] Interne Tester (sofort verfügbar)
  - [ ] Externe Tester (Review erforderlich, 24-48h)

## ✅ Tester einladen
- [ ] E-Mail-Adressen der Tester sammeln
- [ ] Tester zu Gruppen hinzufügen
- [ ] Einladungen versenden

## ✅ Nach dem Release
- [ ] Feedback sammeln
- [ ] Crash Reports überprüfen
- [ ] Analytics auswerten
- [ ] Bugs dokumentieren
- [ ] Nächste Version planen

## 📱 Wichtige Links
- App Store Connect: https://appstoreconnect.apple.com
- Apple Developer: https://developer.apple.com
- TestFlight Dokumentation: https://developer.apple.com/testflight/

## 🚨 Häufige Probleme
1. **"Missing Compliance"**: Export Compliance in App Store Connect ausfüllen
2. **"Invalid Binary"**: Provisioning Profile überprüfen
3. **"Missing Icon"**: App Icon Set in Assets.xcassets überprüfen
4. **Build nicht sichtbar**: 15-30 Minuten warten, dann Apple Support kontaktieren