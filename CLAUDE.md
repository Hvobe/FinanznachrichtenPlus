# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Git Commit Policy

**CRITICAL**: When creating git commits, NEVER include:
- "Generated with [Claude Code]..." footer
- "Co-Authored-By: Claude <noreply@anthropic.com>"
- Any references to Claude, AI, or automated generation

All commits must appear as if written by the developer (hvobe).

## Project Overview

FinanzNachrichten is a SwiftUI-based iOS app for German financial news and market data. The app provides real-time market information, financial news, watchlist management, and comprehensive views of financial instruments through a tab-based navigation pattern.

**IMPORTANT**: Files in the `/FinanzNachrichten/` subdirectory are duplicates. The active files used by the build system are in the root `/FinanzNachrichtenSwiftUI/` directory. Always work with root directory files.

## Build & Development Commands

```bash
# Build for iPhone 16 simulator (standard build)
xcodebuild -project FinanzNachrichtenSwiftUI/FinanzNachrichten.xcodeproj \
  -scheme FinanzNachrichten \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  clean build

# Quick build (no clean - faster)
xcodebuild -project FinanzNachrichtenSwiftUI/FinanzNachrichten.xcodeproj \
  -scheme FinanzNachrichten \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  build

# Auto-build with file watching (requires fswatch)
cd FinanzNachrichtenSwiftUI && ./watch-and-build.sh

# Check for build errors/warnings only
xcodebuild -project FinanzNachrichtenSwiftUI/FinanzNachrichten.xcodeproj \
  -scheme FinanzNachrichten \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  build 2>&1 | grep -E "(error:|warning:|BUILD)"

# List available simulators
xcrun simctl list devices

# TestFlight/Release builds
# 1. Increment build number first
xcrun agvtool next-version -all

# 2. Archive for distribution
xcodebuild archive \
  -project FinanzNachrichtenSwiftUI/FinanzNachrichten.xcodeproj \
  -scheme FinanzNachrichten \
  -archivePath ./build/FinanzNachrichten.xcarchive

# 3. Export for TestFlight (requires ExportOptions.plist)
xcodebuild -exportArchive \
  -archivePath ./build/FinanzNachrichten.xcarchive \
  -exportPath ./build \
  -exportOptionsPlist ExportOptions.plist
```

## Architecture & Code Organization

### High-Level Architecture

The app follows a **Component-based SwiftUI architecture** with services for shared state:

1. **Service Layer**: Singleton services manage global state and persistence
   - `WatchlistService`: Multi-watchlist management with UserDefaults persistence
   - `BookmarkService`: Bookmarked news persistence
   - `NotificationService`: In-app notification management
   - `MockDataService`: Centralized mock data for development (FinanzNachrichten/Services/)
   - `DataMapper`: Type conversion service for InstrumentData (FinanzNachrichten/Services/)
2. **Environment Injection**: Services injected at app root (`FinanzNachrichtenSwiftUIApp.swift`)
3. **Component Organization**:
   - `Components/`: Reusable UI components grouped by feature (DataMapper integration)
   - `Views/`: Full screen views (MockDataService integration)
   - `Models/`: Data structures and mock data
   - `DesignSystem/`: Centralized styling and theming
4. **Navigation**: Tab-based with sheet modals for details

### File Organization

```
FinanzNachrichtenSwiftUI/
├── Components/           # Reusable UI components
│   ├── DSComponents.swift         # Design system base components
│   ├── NavigationComponents.swift # Navigation bars, tabs
│   ├── NewsComponents.swift       # News cards and lists  
│   ├── MarketComponents.swift     # Market cards and data
│   └── InstrumentComponents.swift # Instrument views
├── Views/               # Full screen views
│   ├── HomeView.swift            # Main dashboard
│   ├── MarketsView.swift         # Markets overview with branches
│   ├── BranchDetailView.swift    # Industry branch detail view
│   ├── WatchlistView.swift       # User watchlist
│   ├── MediaView.swift           # News categories
│   ├── MenuView.swift            # Settings menu
│   ├── CalendarView.swift        # Calendar/schedule view
│   └── [Modal Views...]          # Search, AddStock, etc.
├── Models/              # Data structures
│   ├── MarketModels.swift        # Market data types, WatchlistItem, Branch
│   ├── BranchModels.swift        # Branch data, categories, ratings
│   ├── NewsModels.swift          # News structures
│   ├── InstrumentModels.swift    # Financial instruments
│   ├── CalendarModels.swift      # Calendar/schedule models
│   └── [Other models...]
├── Services/            # State management
│   ├── WatchlistService.swift     # Multi-watchlist management
│   ├── BookmarkService.swift      # News bookmarking
│   └── NotificationService.swift  # In-app notifications
├── FinanzNachrichten/Services/  # Utility services (in subdirectory)
│   ├── MockDataService.swift     # Centralized mock data
│   └── DataMapper.swift           # Model type conversions
├── DesignSystem/        # Styling
│   └── DesignSystem.swift        # Colors, spacing, typography
└── FinanzNachrichten.xcodeproj

**AVOID**: Files in `/FinanzNachrichten/` subdirectory are duplicates!
```

### Navigation Flow

```
ContentView (Tab Controller)
├── Tab 0: HomeView
│   ├── Market overview cards
│   ├── Top performers from watchlist
│   ├── Schedule section (ScheduleItems)
│   ├── Personalized news ("Für dich")
│   ├── Interest-based sections (dynamic)
│   └── News feed (infinite scroll)
├── Tab 1: MarketsView
│   ├── Market overview (indices, forex, crypto)
│   ├── Industry branches grid (Branch.sampleBranches)
│   │   └── Tap → BranchDetailView (sheet)
│   └── Calendar section
├── Tab 2: WatchlistView
│   ├── Watchlist items (WatchlistService)
│   └── AddStockView (sheet)
├── Tab 3: MediaView
│   └── Categorized news
└── Tab 4: MenuView
    ├── Appearance settings (dark mode)
    ├── Notifications
    └── App info

Modal Sheets:
- SearchView
- NotificationView
- InstrumentView (details)
- AddStockView
- BranchDetailView (industry detail)
```

## Design System

Centralized design system in `DesignSystem/DesignSystem.swift`:

### Key Components
- **Spacing**: Base unit 4pt system (xs:4, sm:8, md:12, lg:16, xl:24, xxl:32)
- **Typography**: Semantic text styles (largeTitle → caption)
- **Colors**: 12 adaptive color assets with dark mode support
- **Shadows**: 3 elevation levels (low, medium, high)
- **Components**: DSCard, DSButton, DSSegmentedControl base components

### Implementation Patterns
```swift
// Spacing usage
.padding(DesignSystem.Spacing.md)

// Typography
.font(DesignSystem.Typography.title2)

// Colors
.foregroundColor(DesignSystem.Colors.primary)

// Shadow prevention in ScrollViews
ScrollView {
    // Content with shadows
}
.scrollClipDisabled() // Prevents shadow clipping
```

## Key Services & State Management

### WatchlistService
```swift
// Singleton pattern - manages global watchlist
WatchlistService.shared.addToWatchlist(instrument)
WatchlistService.shared.removeFromWatchlist(instrument)
WatchlistService.shared.isInWatchlist(instrument)
// Persists to UserDefaults: "watchlistInstruments"
```

### BookmarkService
```swift
// News bookmark management
@EnvironmentObject var bookmarkService: BookmarkService
bookmarkService.toggleBookmark(for: newsItem)
// Persists to UserDefaults: "bookmarkedNews"
```

### NotificationService
```swift
// In-app notification tracking
@EnvironmentObject var notificationService: NotificationService
notificationService.missedItemsCount
```

### MockDataService
```swift
// Centralized mock data for development
// Located in FinanzNachrichten/Services/MockDataService.swift
let mockData = MockDataService.shared

// Get mock data for various contexts
let topPerformers = mockData.getTopPerformers()        // [WatchlistItem]
let marketData = mockData.getMarketData()              // [MarketCard]
let securities = mockData.getSecurities()              // [Security]
let scheduleItems = mockData.getScheduleItems()        // [ScheduleItem]

// Mock news data (cyclic for infinite scroll)
let newsTitle = mockData.getNewsTitle(for: index)
let newsCategory = mockData.getNewsCategory(for: index)
```

### DataMapper
```swift
// Type conversion service for InstrumentView details
// Located in FinanzNachrichten/Services/DataMapper.swift

// Convert various models to InstrumentData for detail view
let instrument = DataMapper.toInstrumentData(from: marketCard)
let instrument = DataMapper.toInstrumentData(from: security)
let instrument = DataMapper.toInstrumentData(from: watchlistItem)
let instrument = DataMapper.toInstrumentData(from: newsInstrument)
let instrument = DataMapper.toInstrumentData(from: marketInstrument)

// Usage in Components:
.fullScreenCover(isPresented: $showingInstrument) {
    InstrumentView(instrument: DataMapper.toInstrumentData(from: market))
}
```

## Common Implementation Patterns

### Sheet Presentation with Swipe-to-Dismiss
```swift
struct SheetView: View {
    @State private var dragAmount = CGSize.zero
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            // Content
        }
        .offset(y: dragAmount.height)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        dragAmount = value.translation
                    }
                }
                .onEnded { value in
                    if value.translation.height > 100 {
                        dismiss()
                    } else {
                        dragAmount = .zero
                    }
                }
        )
    }
}
```

### Interactive Section Headers
```swift
Button(action: { showingDetail = true }) {
    HStack {
        Text("Section Title")
            .font(DesignSystem.Typography.title2)
        Spacer()
        Image(systemName: "chevron.right")
    }
}
.buttonStyle(PlainButtonStyle())
```

### Market Data Colors
```swift
// Positive/negative changes
.foregroundColor(isPositive ? .green : .red)

// Bid/Ask backgrounds
.background(DesignSystem.Colors.secondary.opacity(0.08))
```

## Industry Branches Feature

The app includes a comprehensive industry branches system with 16+ German market sectors:

### Branch System
```swift
// Access sample branches
Branch.sampleBranches // Array of 16 industry branches

// Branch structure
struct Branch {
    let name: String              // e.g., "Elektrotechnologie", "Fahrzeuge"
    let color: Color              // Branch theme color
    let stocks: [WatchlistItem]   // Companies in this branch

    var topPerformers: [WatchlistItem]    // Sorted by performance
    var worstPerformers: [WatchlistItem]  // Sorted by losses
    var dividendStocks: [WatchlistItem]   // Mock dividend data
}
```

### Branch Detail View (BranchDetailView.swift)
- **Stock Categories**: Top/Flop, Potential, Focus, Dividend
- **Analyst Ratings**: Buy, Hold, Sell recommendations
- **News Filtering**: All News, Press Releases, Chart Analyses, Reports
- **Implementation**: MarketsView.swift:122 - Branch grid with navigation

## Recent Improvements & Current State

### ✅ Completed (Phase 1-10 Refactoring)
- **MockDataService**: Centralized all mock data (was scattered across Views)
- **DataMapper**: Unified type conversions (eliminates 200+ lines of duplicate code)
- **Documentation**: Comprehensive docs added to all Services, Models, Components
- **Code Quality**: English API docs (///) + German business logic comments (//)
- **Multi-Watchlist**: Full support with color themes and persistence
- **DesignSystem**: Fully documented with platform conversion notes

### Current Limitations & TODOs
- **Data**: All data is mock (MockDataService) - needs API integration
- **API**: No network layer implemented yet
- **Tests**: No test suite configured
- **Localization**: German strings hardcoded, no .strings files
- **Images**: Synchronous loading, needs async optimization
- **Search**: Currently non-functional placeholder
- **Branch Data**: Real-time stock data not integrated
- **BranchModels.swift**: Contains duplicates of MarketModels.swift - should be consolidated

## Project Configuration

- **Bundle ID**: `com.hendrik.finanznachrichten`
- **iOS Target**: 17.2 minimum (15.0 deployment)
- **Orientations**: Portrait (iPhone), All (iPad)
- **Dependencies**: None - pure Apple frameworks
- **Version**: 1.0 
- **Build**: Auto-increment with `xcrun agvtool next-version -all`

## Key Data Models

### Mock Data Location
Mock data is now centralized in **MockDataService** (FinanzNachrichten/Services/MockDataService.swift):

```swift
// NEW: Centralized mock data (recommended approach)
MockDataService.shared.getTopPerformers()    // [WatchlistItem]
MockDataService.shared.getMarketData()       // [MarketCard]
MockDataService.shared.getSecurities()       // [Security]
MockDataService.shared.getScheduleItems()    // [ScheduleItem]
MockDataService.shared.getNewsTitle(for: index)

// Static mock data still exists in Models (legacy)
Branch.sampleBranches                    // Models/MarketModels.swift
MarketInstrument.worldIndices            // Models/MarketModels.swift

// User preferences
UserDefaults.standard.stringArray(forKey: "userInterests") // Interest categories
UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
```

### UserDefaults Keys
- `"userInterests"` - Array of interest categories for personalized news
- `"hasCompletedOnboarding"` - Boolean for onboarding state
- `"isDarkMode"` - Dark mode preference (@AppStorage)
- `"watchlistItems"` - JSON encoded watchlist (WatchlistService)
- `"bookmarkedNews"` - JSON encoded bookmarks (BookmarkService)

## Performance Tips

- Use `LazyVStack` for long scrollable lists
- Avoid `CGFloat.random()` in view bodies (causes re-renders)
- Pre-calculate random values in `init()` or `onAppear`
- Use `.scrollClipDisabled()` when ScrollView contains shadowed content
- Animation duration: 0.2-0.5s standard
- HomeView uses infinite scroll pattern (30+ news items) - optimize for pagination later