#!/bin/bash

# Auto-build script for SwiftUI project
PROJECT_PATH="/Users/hendrik/Finanznachrichten App/FinanzNachrichtenSwiftUI"
cd "$PROJECT_PATH"

echo "🔍 Watching for file changes..."
echo "Press Ctrl+C to stop"

# Use fswatch to monitor file changes
fswatch -o FinanzNachrichten/ | while read f; do
  echo "📁 File changed, rebuilding..."
  
  # Clean build folder and rebuild
  xcodebuild -project FinanzNachrichten.xcodeproj \2
    -scheme FinanzNachrichten \
    -destination 'platform=iOS Simulator,name=iPhone 16' \
    clean build > /dev/null 2>&1
  
  if [ $? -eq 0 ]; then
    echo "✅ Build successful"
    # Send notification to reload simulator if running
    osascript -e 'tell application "Simulator" to activate' 2>/dev/null
  else
    echo "❌ Build failed"
  fi
done2