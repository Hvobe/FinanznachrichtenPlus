#!/bin/bash

echo "Fixing Assets structure..."

cd "/Users/hendrik/Finanznachrichten App/FinanzNachrichtenSwiftUI/FinanzNachrichten/Assets.xcassets"

# Backup old AppIcon.appiconset
if [ -d "AppIcon.appiconset" ]; then
    echo "Backing up old AppIcon.appiconset..."
    mv AppIcon.appiconset AppIcon.appiconset.backup
fi

# Move the new AppIcon.appiconset from nested folder
if [ -d "Assets.xcassets/AppIcon.appiconset" ]; then
    echo "Moving AppIcon.appiconset to correct location..."
    mv Assets.xcassets/AppIcon.appiconset .
    
    # Remove the empty nested folder
    rm -rf Assets.xcassets
    
    echo "✅ Fixed! AppIcon.appiconset is now in the correct location."
else
    echo "❌ Error: Could not find Assets.xcassets/AppIcon.appiconset"
fi

echo ""
echo "Next steps:"
echo "1. Go back to Xcode"
echo "2. Product → Clean Build Folder"
echo "3. Product → Archive"