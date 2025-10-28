#!/bin/bash

echo "🔧 Fixing Assets structure (Version 2)..."
echo ""

# Navigate to the Assets.xcassets directory
cd "/Users/hendrik/Finanznachrichten App/FinanzNachrichtenSwiftUI/FinanzNachrichten/Assets.xcassets"

# Check current structure
echo "📁 Current structure:"
ls -la

# Check if nested Assets.xcassets exists
if [ -d "Assets.xcassets" ]; then
    echo ""
    echo "✅ Found nested Assets.xcassets folder"
    
    # Check if it contains AppIcon.appiconset
    if [ -d "Assets.xcassets/AppIcon.appiconset" ]; then
        echo "✅ Found AppIcon.appiconset in nested folder"
        
        # Remove old AppIcon.appiconset if it exists
        if [ -d "AppIcon.appiconset" ]; then
            echo "🗑️  Removing old AppIcon.appiconset..."
            rm -rf AppIcon.appiconset
        fi
        
        # Move the new AppIcon.appiconset up one level
        echo "📦 Moving new AppIcon.appiconset to correct location..."
        mv Assets.xcassets/AppIcon.appiconset .
        
        # Remove the now empty Assets.xcassets folder
        echo "🗑️  Removing empty nested folder..."
        rmdir Assets.xcassets
        
        echo ""
        echo "✅ SUCCESS! Structure fixed!"
        echo ""
        echo "📁 New structure:"
        ls -la
        
    else
        echo "❌ Error: No AppIcon.appiconset found in Assets.xcassets"
    fi
else
    echo "❌ Error: No nested Assets.xcassets folder found"
    echo "Current contents:"
    ls -la
fi

echo ""
echo "📱 Next steps in Xcode:"
echo "1. Product → Clean Build Folder (Cmd+Shift+K)"
echo "2. Product → Archive"
echo "3. Don't forget to add CFBundleIconName in Info tab!"