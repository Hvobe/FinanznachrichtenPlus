#!/usr/bin/env python3

from PIL import Image, ImageDraw, ImageFont
import os

def create_fn_icon(size):
    """Create an FN icon with the given size"""
    # Create a new image with a gradient background
    img = Image.new('RGB', (size, size), color='white')
    draw = ImageDraw.Draw(img)
    
    # Create gradient background (blue to dark blue)
    for y in range(size):
        # Gradient from light blue to dark blue
        r = int(0 + (0 * y / size))
        g = int(122 + ((50 - 122) * y / size))
        b = int(255 + ((150 - 255) * y / size))
        draw.rectangle([(0, y), (size, y + 1)], fill=(r, g, b))
    
    # Add rounded corners
    corner_radius = int(size * 0.22)  # 22.37% for iOS icons
    
    # Create a mask for rounded corners
    mask = Image.new('L', (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([(0, 0), (size-1, size-1)], corner_radius, fill=255)
    
    # Apply mask
    rounded = Image.new('RGB', (size, size))
    rounded.paste(img, mask=mask)
    img = rounded
    draw = ImageDraw.Draw(img)
    
    # Calculate font size (approximately 40% of icon size for "FN")
    font_size = int(size * 0.4)
    
    # Try to use a system font, fallback to default if not available
    try:
        # Try different font paths for macOS
        font_paths = [
            "/System/Library/Fonts/Helvetica.ttc",
            "/Library/Fonts/Arial Bold.ttf",
            "/System/Library/Fonts/Avenir Next.ttc"
        ]
        font = None
        for path in font_paths:
            if os.path.exists(path):
                try:
                    font = ImageFont.truetype(path, font_size)
                    break
                except:
                    continue
        
        if font is None:
            font = ImageFont.load_default()
    except:
        font = ImageFont.load_default()
    
    # Draw "FN" text
    text = "FN"
    
    # Get text bounding box
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    # Center the text
    x = (size - text_width) // 2
    y = (size - text_height) // 2 - int(size * 0.05)  # Slight upward adjustment
    
    # Draw text with shadow for depth
    shadow_offset = max(2, int(size * 0.01))
    draw.text((x + shadow_offset, y + shadow_offset), text, font=font, fill=(0, 50, 100))
    draw.text((x, y), text, font=font, fill='white')
    
    return img

# Create output directory
output_dir = "FinanzNachrichten/Assets.xcassets/AppIcon.appiconset"
os.makedirs(output_dir, exist_ok=True)

# Icon sizes needed for iOS
icon_sizes = [
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

print("Generating FN app icons...")

for size, filename in icon_sizes:
    icon = create_fn_icon(size)
    icon.save(os.path.join(output_dir, filename), "PNG")
    print(f"✓ Generated {filename} ({size}x{size}px)")

# Create Contents.json for the AppIcon set
contents_json = '''{
  "images" : [
    {
      "filename" : "icon-20@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "filename" : "icon-20@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "20x20"
    },
    {
      "filename" : "icon-29@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "filename" : "icon-29@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "29x29"
    },
    {
      "filename" : "icon-40@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "filename" : "icon-40@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "40x40"
    },
    {
      "filename" : "icon-60@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "60x60"
    },
    {
      "filename" : "icon-60@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "60x60"
    },
    {
      "filename" : "icon-1024.png",
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

with open(os.path.join(output_dir, "Contents.json"), "w") as f:
    f.write(contents_json)

print("\n✅ App icons successfully generated!")
print(f"\nIcons saved to: {output_dir}")
print("\nNext steps:")
print("1. Open the project in Xcode")
print("2. The AppIcon should be automatically recognized")
print("3. Build and test the app")