#!/usr/bin/env python3

import os
import subprocess

# Create a simple PNG icon using Python's built-in capabilities
# Since we can't use PIL, we'll create it with a different approach

# First, let's create a new SVG with just the red diamond
svg_content = '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="1024" height="1024" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
  <!-- Red diamond shape rotated 45 degrees -->
  <rect x="212" y="212" width="600" height="600" rx="60" ry="60" 
        transform="rotate(45 512 512)" fill="#DC2626"/>
  
  <!-- FN text -->
  <text x="512" y="600" font-family="-apple-system, SF Pro Display, Helvetica Neue, Arial" 
        font-size="380" font-weight="800" text-anchor="middle" fill="white">FN</text>
</svg>'''

# Save the SVG
svg_path = "icon_1024.svg"
with open(svg_path, "w") as f:
    f.write(svg_content)

print("✅ Created icon_1024.svg")

# Try to convert using sips (built into macOS)
output_path = "FinanzNachrichten/Assets.xcassets/AppIcon.appiconset/icon-1024.png"
os.makedirs(os.path.dirname(output_path), exist_ok=True)

# Create all required sizes
sizes = [
    (40, "icon-20@2x.png"),
    (60, "icon-20@3x.png"),
    (58, "icon-29@2x.png"),
    (87, "icon-29@3x.png"),
    (80, "icon-40@2x.png"),
    (120, "icon-40@3x.png"),
    (120, "icon-60@2x.png"),
    (180, "icon-60@3x.png"),
    (1024, "icon-1024.png")
]

print("\n🎨 Erstelle PNG-Icons...")
print("\nBitte führe folgende Schritte aus:")
print("1. Öffne 'icon_1024.svg' in Safari (Rechtsklick → Öffnen mit → Safari)")
print("2. Rechtsklick auf das Bild → 'Bild sichern unter...'")
print("3. Speichere es als 'icon_1024.png'")
print("4. Ziehe die PNG-Datei in Xcode ins 1024x1024 Feld")
print("\nXcode wird dann automatisch alle anderen Größen generieren!")

# Alternative: Create a simple red square with text using HTML/CSS approach
html_content = '''<!DOCTYPE html>
<html>
<head>
<style>
body { margin: 0; padding: 0; }
.icon {
    width: 1024px;
    height: 1024px;
    position: relative;
    overflow: hidden;
}
.diamond {
    width: 600px;
    height: 600px;
    background: #DC2626;
    transform: rotate(45deg);
    position: absolute;
    top: 212px;
    left: 212px;
    border-radius: 60px;
}
.text {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    color: white;
    font-family: -apple-system, "SF Pro Display", "Helvetica Neue", Arial;
    font-size: 380px;
    font-weight: 800;
    z-index: 10;
}
</style>
</head>
<body>
<div class="icon">
    <div class="diamond"></div>
    <div class="text">FN</div>
</div>
</body>
</html>'''

with open("icon_preview.html", "w") as f:
    f.write(html_content)

print("\n📱 Alternative Methode:")
print("1. Öffne 'icon_preview.html' in Safari")
print("2. Mache einen Screenshot des roten Icons (Cmd+Shift+4)")
print("3. Schneide es auf 1024x1024px zu")
print("4. Ziehe es in Xcode")