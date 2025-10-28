# FinanzNachrichten iOS App

SwiftUI-based iOS application for German financial news and market data with comprehensive watchlist management and real-time market information.

## Features

### Core Functionality
- **Multi-Watchlist Management**: Create and manage multiple watchlists with custom colors and themes
- **Real-Time Market Data**: Indices, commodities, forex, and cryptocurrencies
- **Industry Branch Analysis**: Comprehensive view of 16 German market sectors
- **Financial News Feed**: Categorized news with bookmarking capability
- **Calendar/Schedule View**: Track important financial events
- **Dark Mode Support**: Full dark mode implementation

### Watchlist Features
- Performance tracking with donut chart visualization
- Industry-based grouping
- Swipe-to-delete functionality
- Custom watchlist colors and icons
- Performance metrics and statistics

### Markets Features
- Region filter (Deutschland, Europa, USA, Asien)
- Branch detail views with top/bottom performers
- Focus stocks and dividend information
- Analyst ratings

## Technical Stack

- **Framework**: SwiftUI
- **Minimum iOS Version**: iOS 17.2+
- **Xcode**: 15.0+
- **Language**: Swift 5.9
- **Architecture**: MVVM with Service Layer

## Project Structure

```
FinanzNachrichtenSwiftUI/
├── Components/           # Reusable UI components
│   ├── DSComponents.swift
│   ├── NavigationComponents.swift
│   ├── NewsComponents.swift
│   ├── MarketComponents.swift
│   └── InstrumentComponents.swift
├── Views/               # Full screen views
│   ├── HomeView.swift
│   ├── MarketsView.swift
│   ├── WatchlistView.swift
│   ├── MediaView.swift
│   └── MenuView.swift
├── Models/              # Data structures
│   ├── MarketModels.swift
│   ├── NewsModels.swift
│   ├── InstrumentModels.swift
│   ├── WatchlistModels.swift
│   └── BranchModels.swift
├── Services/            # Business logic layer
│   ├── WatchlistService.swift
│   ├── BookmarkService.swift
│   ├── NotificationService.swift
│   ├── MockDataService.swift
│   └── DataMapper.swift
├── DesignSystem/        # Design tokens
│   └── DesignSystem.swift
└── FinanzNachrichten.xcodeproj
```

## Architecture

### Service Layer
- **WatchlistService**: Multi-watchlist management with UserDefaults persistence
- **BookmarkService**: News bookmarking functionality
- **NotificationService**: In-app notification tracking
- **MockDataService**: Centralized mock data for development
- **DataMapper**: Type conversion between different data models

### Design System
Centralized design tokens in `DesignSystem.swift`:
- Spacing: 4pt base system (xs: 4, sm: 8, md: 12, lg: 16, xl: 24, xxl: 32)
- Typography: Semantic text styles with iOS Dynamic Type support
- Colors: 12 adaptive color assets with dark mode
- Components: Reusable base components (DSCard, DSButton, etc.)

## Build Instructions

### Prerequisites
- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later
- iOS Simulator or physical device running iOS 17.2+

### Building the Project

1. **Clone the repository**
   ```bash
   git clone https://github.com/Hvobe/FinanznachrichtenPlus.git
   cd FinanznachrichtenPlus
   ```

2. **Open in Xcode**
   ```bash
   open FinanzNachrichten.xcodeproj
   ```

3. **Select target device**
   - Choose "iPhone 16" simulator or your physical device from the target menu

4. **Build and run**
   - Press `Cmd + R` or click the Play button
   - Or use command line:
   ```bash
   xcodebuild -project FinanzNachrichten.xcodeproj \
     -scheme FinanzNachrichten \
     -destination 'platform=iOS Simulator,name=iPhone 16' \
     build
   ```

### Build Configurations

- **Debug**: Development build with debug symbols
- **Release**: Optimized production build

### Common Build Issues

**Issue**: "Failed to read file attributes" for Assets.xcassets
- **Solution**: Clean build folder (Cmd + Shift + K) and rebuild

**Issue**: "Cannot find 'HomeView' in scope"
- **Solution**: Ensure all files are added to the target in Xcode project settings

## Development

### Mock Data
The app currently uses mock data for development purposes:
- All market data is generated in `MockDataService.swift`
- Sample news and instruments are hardcoded
- UserDefaults is used for persistence

### Adding New Features

1. **New View**: Add to `Views/` directory and follow existing patterns
2. **New Component**: Add to `Components/` and use DesignSystem tokens
3. **New Service**: Add to `Services/` with proper documentation
4. **New Model**: Add to `Models/` with codable support

### Code Style

- English for API documentation (`///`)
- German for inline business logic comments (`//`)
- Use DesignSystem tokens instead of hardcoded values
- Follow SwiftUI best practices and conventions

## Testing

Currently no automated tests. To verify functionality:

1. Build the project (`Cmd + B`)
2. Run on simulator (`Cmd + R`)
3. Test core flows:
   - Create watchlist
   - Add instruments
   - Navigate between tabs
   - Toggle dark mode

## Documentation

For detailed architecture and development guidelines, see [CLAUDE.md](./CLAUDE.md)

## Project Configuration

- **Bundle ID**: `com.hendrik.finanznachrichten`
- **Version**: 1.0
- **Build Number**: Auto-increment
- **Supported Orientations**:
  - iPhone: Portrait only
  - iPad: All orientations

## Roadmap

### Near Term
- [ ] Integrate real financial data API
- [ ] Add unit and UI tests
- [ ] Implement proper networking layer
- [ ] Add localization support

### Future Enhancements
- [ ] Portfolio tracking
- [ ] Price alerts
- [ ] Advanced charting
- [ ] Social features

## License

Private - All rights reserved

## Contact

Project maintained by Henrik von Bezold
- GitHub: [@Hvobe](https://github.com/Hvobe)
