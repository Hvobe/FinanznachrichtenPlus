#!/usr/bin/env python3

import re
import sys

print("🔧 Fixing Xcode project file...")

# Read the project file
project_file = "FinanzNachrichten.xcodeproj/project.pbxproj"

try:
    with open(project_file, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Find and remove Info.plist from Copy Bundle Resources
    print("📋 Removing Info.plist from Copy Bundle Resources...")
    
    # This regex finds the Copy Bundle Resources section and removes Info.plist references
    # Look for patterns like: B14BEAXX2E16XXXX0083B187 /* Info.plist in Resources */
    content = re.sub(
        r'\t\t[A-F0-9]{24} /\* Info\.plist in Resources \*/,?\n',
        '',
        content
    )
    
    # Also remove any file reference in the resources build phase files list
    content = re.sub(
        r'\t\t\t\t[A-F0-9]{24} /\* Info\.plist in Resources \*/,?\n',
        '',
        content
    )
    
    # Find and remove duplicate MarketComponents.swift from Compile Sources
    print("📋 Checking for duplicate MarketComponents.swift...")
    
    # Count occurrences of MarketComponents.swift in Sources
    market_components_pattern = r'([A-F0-9]{24}) /\* MarketComponents\.swift in Sources \*/'
    matches = re.findall(market_components_pattern, content)
    
    if len(matches) > 1:
        print(f"  Found {len(matches)} instances of MarketComponents.swift")
        # Remove the first occurrence (keep the last one)
        content = content.replace(f"{matches[0]} /* MarketComponents.swift in Sources */,", "", 1)
        print("  ✅ Removed duplicate")
    
    # Check if changes were made
    if content != original_content:
        # Backup the original
        with open(project_file + ".backup", 'w') as f:
            f.write(original_content)
        print(f"📦 Created backup: {project_file}.backup")
        
        # Write the fixed content
        with open(project_file, 'w') as f:
            f.write(content)
        
        print("✅ Project file fixed!")
        print("\n🎯 Next steps:")
        print("1. Close Xcode completely")
        print("2. Open Xcode again")
        print("3. Product → Clean Build Folder")
        print("4. Product → Archive")
    else:
        print("ℹ️  No changes needed - project file looks correct")
        
except FileNotFoundError:
    print("❌ Error: Could not find project.pbxproj file")
    print("Make sure you run this script from the project directory")
    sys.exit(1)
except Exception as e:
    print(f"❌ Error: {e}")
    sys.exit(1)