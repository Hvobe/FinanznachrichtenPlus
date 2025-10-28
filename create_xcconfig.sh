#!/bin/bash

echo "Creating xcconfig file to force settings..."

# Create a config file
cat > FinanzNachrichten.xcconfig << EOF
// Force Info.plist settings
INFOPLIST_FILE = FinanzNachrichten/Info.plist
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
INFOPLIST_KEY_CFBundleIconName = AppIcon

// Ensure asset catalog is included
ASSETCATALOG_COMPILER_INCLUDE_ALL_APPICON_ASSETS = YES
EOF

echo "✅ Created FinanzNachrichten.xcconfig"
echo ""
echo "Next steps:"
echo "1. In Xcode: Project (not Target) → Info"
echo "2. Under Configurations → Debug → FinanzNachrichten"
echo "3. Click the dropdown and select 'FinanzNachrichten'"
echo "4. Do the same for Release"
echo "5. Clean Build Folder and Archive"