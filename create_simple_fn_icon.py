#!/usr/bin/env python3

import os

# Create an SVG icon
svg_content = '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="1024" height="1024" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="backgroundGradient" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#007AFF;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#0051D5;stop-opacity:1" />
    </linearGradient>
  </defs>
  
  <!-- Rounded rectangle background with iOS-style corner radius (22.37%) -->
  <rect width="1024" height="1024" rx="229" ry="229" fill="url(#backgroundGradient)"/>
  
  <!-- FN text -->
  <text x="512" y="580" font-family="SF Pro Display, -apple-system, Helvetica Neue, Arial" 
        font-size="420" font-weight="700" text-anchor="middle" fill="white">FN</text>
</svg>'''

# Create output directory
output_dir = "FinanzNachrichten/Assets.xcassets/AppIcon.appiconset"
os.makedirs(output_dir, exist_ok=True)

# Save the SVG
svg_path = os.path.join(output_dir, "fn_icon.svg")
with open(svg_path, "w") as f:
    f.write(svg_content)

print("✅ Created FN icon SVG at:", svg_path)

# Create Contents.json for the AppIcon set
contents_json = '''{
  "images" : [
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "20x20"
    },
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "29x29"
    },
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "40x40"
    },
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "60x60"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "60x60"
    },
    {
      "idiom" : "ios-marketing",
      "scale" : "1x",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}'''

contents_path = os.path.join(output_dir, "Contents.json")
with open(contents_path, "w") as f:
    f.write(contents_json)

print("✅ Updated Contents.json")

print("\n📱 Icon created successfully!")
print("\nTo convert the SVG to PNG icons, you can:")
print("1. Open the SVG in a graphics app (Preview, Affinity Designer, etc.)")
print("2. Export it as PNG in different sizes")
print("3. Or use an online tool like cloudconvert.com")
print("\nOr in Xcode:")
print("1. Drag the SVG directly into Assets.xcassets")
print("2. Xcode will generate the required sizes automatically")