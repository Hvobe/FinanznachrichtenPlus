#!/bin/bash

# Script to generate app icons from FN logo
# Requires ImageMagick (install with: brew install imagemagick)

echo "App Icon Generator für FinanzNachrichten"
echo "========================================"
echo ""
echo "Dieses Script erstellt alle benötigten App Icon Größen aus dem FN Logo."
echo ""
echo "Voraussetzungen:"
echo "1. ImageMagick installieren: brew install imagemagick"
echo "2. FN Logo als PNG in hoher Auflösung (mindestens 1024x1024px)"
echo ""
echo "Verwendung:"
echo "./generate_app_icons.sh /pfad/zum/fn-logo.png"
echo ""
echo "Die generierten Icons werden in:"
echo "FinanzNachrichten/Assets.xcassets/AppIcon.appiconset/"
echo ""
echo "Benötigte Icon-Größen:"
echo "- 40x40px   (20pt @2x)"
echo "- 60x60px   (20pt @3x)" 
echo "- 58x58px   (29pt @2x)"
echo "- 87x87px   (29pt @3x)"
echo "- 80x80px   (40pt @2x)"
echo "- 120x120px (40pt @3x)"
echo "- 120x120px (60pt @2x)"
echo "- 180x180px (60pt @3x)"
echo "- 1024x1024px (App Store)"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ERROR: ImageMagick ist nicht installiert!"
    echo "Bitte installieren mit: brew install imagemagick"
    exit 1
fi

# Check if source image is provided
if [ -z "$1" ]; then
    echo "ERROR: Kein Quellbild angegeben!"
    echo "Verwendung: $0 /pfad/zum/fn-logo.png"
    exit 1
fi

SOURCE_IMAGE="$1"
OUTPUT_DIR="FinanzNachrichten/Assets.xcassets/AppIcon.appiconset"

# Check if source image exists
if [ ! -f "$SOURCE_IMAGE" ]; then
    echo "ERROR: Quellbild nicht gefunden: $SOURCE_IMAGE"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "Generiere App Icons..."

# Generate icons
convert "$SOURCE_IMAGE" -resize 40x40 "$OUTPUT_DIR/icon-20@2x.png"
convert "$SOURCE_IMAGE" -resize 60x60 "$OUTPUT_DIR/icon-20@3x.png"
convert "$SOURCE_IMAGE" -resize 58x58 "$OUTPUT_DIR/icon-29@2x.png"
convert "$SOURCE_IMAGE" -resize 87x87 "$OUTPUT_DIR/icon-29@3x.png"
convert "$SOURCE_IMAGE" -resize 80x80 "$OUTPUT_DIR/icon-40@2x.png"
convert "$SOURCE_IMAGE" -resize 120x120 "$OUTPUT_DIR/icon-40@3x.png"
convert "$SOURCE_IMAGE" -resize 120x120 "$OUTPUT_DIR/icon-60@2x.png"
convert "$SOURCE_IMAGE" -resize 180x180 "$OUTPUT_DIR/icon-60@3x.png"
convert "$SOURCE_IMAGE" -resize 1024x1024 "$OUTPUT_DIR/icon-1024.png"

echo "✅ App Icons erfolgreich generiert!"
echo ""
echo "Nächste Schritte:"
echo "1. Öffne das Projekt in Xcode"
echo "2. Gehe zu Assets.xcassets"
echo "3. Das AppIcon sollte automatisch erkannt werden"
echo "4. Build und teste die App"