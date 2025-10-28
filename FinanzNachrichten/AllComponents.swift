import SwiftUI

// MARK: - Imports for Modularized Components
// Note: These imports will be active once the files are added to the Xcode project

// Design System
// import DesignSystem from "DesignSystem/DesignSystem.swift"

// Base Components
// import DSComponents from "Components/DSComponents.swift"

// Feature Components
// import NewsComponents from "Components/NewsComponents.swift"
// import MarketComponents from "Components/MarketComponents.swift"
// import NavigationComponents from "Components/NavigationComponents.swift"

// Models
// import NotificationModels from "Models/NotificationModels.swift"
// import NewsModels from "Models/NewsModels.swift"
// import MarketModels from "Models/MarketModels.swift"
// import CalendarModels from "Models/CalendarModels.swift"
// import NavigationModels from "Models/NavigationModels.swift"
// import PreferenceKeys from "Models/PreferenceKeys.swift"

// Services
// import NotificationService from "Services/NotificationService.swift"
// import BookmarkService from "Services/BookmarkService.swift"

// Views
// import HomeView from "Views/HomeView.swift"
// import MarketsView from "Views/MarketsView.swift"
// import WatchlistView from "Views/WatchlistView.swift"
// import MediaView from "Views/MediaView.swift"
// import MenuView from "Views/MenuView.swift"
// import SearchView from "Views/SearchView.swift"
// import NotificationView from "Views/NotificationView.swift"
// import CalendarView from "Views/CalendarView.swift"
// import AddStockView from "Views/AddStockView.swift"
// import OnboardingView from "Views/OnboardingView.swift"

// MARK: - Notification Service
// NotificationService has been moved to Services/NotificationService.swift
// Related models (MissedItem) have been moved to Models/NotificationModels.swift

// MARK: - Bookmark Service
// BookmarkService has been moved to Services/BookmarkService.swift
// Related models (BookmarkedArticle) have been moved to Models/NewsModels.swift

// MARK: - Preference Keys for Market Card Tracking
struct ViewOffsetData: Equatable {
    let index: Int
    let offset: CGFloat
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = ViewOffsetData
    static var defaultValue = ViewOffsetData(index: 0, offset: 0)
    
    static func reduce(value: inout ViewOffsetData, nextValue: () -> ViewOffsetData) {
        let next = nextValue()
        let screenMidX = UIScreen.main.bounds.width / 2
        
        // Keep the value that's closest to center
        if abs(next.offset - screenMidX) < abs(value.offset - screenMidX) {
            value = next
        }
    }
}

// MARK: - Models

struct MenuSection {
    let title: String
    let items: [MenuItem]
}

struct MenuItem {
    let title: String
    let subtitle: String?
    let hasChevron: Bool
    
    init(title: String, subtitle: String? = nil, hasChevron: Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.hasChevron = hasChevron
    }
}

struct MarketCard {
    let name: String
    let value: String
    let change: String
    let isPositive: Bool
}

struct MarketInstrument {
    let name: String
    let value: String
    let change: String
    let isPositive: Bool
}

struct Security {
    let name: String
    let symbol: String
    let price: String
    let change: String
    let isPositive: Bool
}

struct ScheduleItem {
    let title: String
    let date: String
    let time: String
    let type: ScheduleType
}

enum ScheduleType {
    case earnings
    case exDividend
    case dividend
    case holiday
    case economicData
    
    var color: Color {
        switch self {
        case .earnings: return .blue
        case .exDividend: return Color.orange.opacity(0.8)
        case .dividend: return .orange
        case .holiday: return Color.red.opacity(0.6)
        case .economicData: return .gray
        }
    }
    
    var displayName: String {
        switch self {
        case .earnings: return "Quartalszahlen"
        case .exDividend: return "Ex-Dividende"
        case .dividend: return "Dividende"
        case .holiday: return "Feiertag"
        case .economicData: return "Wirtschaftsdaten"
        }
    }
}

struct EditorialNewsItem {
    let title: String
    let category: String
    let time: String
    let imageName: String
}

struct WatchlistItem {
    let id = UUID()
    let symbol: String
    let name: String
    let price: String
    let change: String
    let changePercent: String
    let isPositive: Bool
}

struct WatchlistNewsItem {
    let title: String
    let time: String
}

struct AdditionalNewsItem {
    let title: String
    let category: String
    let time: String
    let imageName: String
}

struct MediaNewsItem {
    let id = UUID()
    let title: String
    let source: String
    let time: String
    let category: String
    let isBreaking: Bool
    let rating: Double = 4.0
    let readerCount: Int = 1234
}

struct TopStoryItem {
    let id = UUID()
    let title: String
    let subtitle: String
    let source: String
    let time: String
    let imageName: String
}

struct NewsArticle {
    let id = UUID()
    let title: String
    let category: String
    let time: String
    let source: String
    let hasImage: Bool
    let body: String
    let mentionedInstruments: [NewsInstrument]
    let rating: Double = 4.0
    let readerCount: Int = 1234
}

struct NewsInstrument {
    let id = UUID()
    let symbol: String
    let name: String
    let price: String
    let change: String
    let isPositive: Bool
}

// MARK: - Design System

struct DesignSystem {
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }
    
    struct CornerRadius {
        static let sm: CGFloat = 4
        static let md: CGFloat = 8
        static let lg: CGFloat = 12
        static let xl: CGFloat = 16
    }
    
    struct Shadows {
        static let card = Color.black.opacity(0.1)
        static let cardRadius: CGFloat = 4
        static let cardOffset = CGSize(width: 0, height: 2)
    }
}

// MARK: - Extended Design System

extension DesignSystem {
    struct Colors {
        static let primary = Color.red
        static let background = Color.white  // Back to white
        static let surface = Color.white
        static let onBackground = Color.black
        static let onSurface = Color.black
        static let secondary = Color.gray
        static let tertiary = Color.gray.opacity(0.6)
        static let success = Color.green
        static let error = Color.red
        static let cardBackground = Color.white
        static let onCard = Color.black
        static let border = Color.gray.opacity(0.05)  // Very light border
        static let separator = Color.gray.opacity(0.1)
        
        // Enhanced shadow colors for better depth
        static let shadowLight = Color.black.opacity(0.1)
        static let shadowMedium = Color.black.opacity(0.15)
        static let shadowStrong = Color.black.opacity(0.2)
    }
    
    struct Typography {
        static let largeTitle = Font.system(size: 28, weight: .bold)
        static let title1 = Font.system(size: 22, weight: .bold)
        static let title2 = Font.system(size: 18, weight: .bold)
        static let title3 = Font.system(size: 16, weight: .semibold)
        static let headline = Font.system(size: 16, weight: .semibold)
        static let body = Font.system(size: 16, weight: .regular)
        static let body1 = Font.system(size: 16, weight: .regular)
        static let body2 = Font.system(size: 14, weight: .regular)
        static let callout = Font.system(size: 14, weight: .regular)
        static let subheadline = Font.system(size: 14, weight: .medium)
        static let footnote = Font.system(size: 12, weight: .regular)
        static let caption1 = Font.system(size: 12, weight: .medium)
        static let caption2 = Font.system(size: 10, weight: .medium)
        
        // Custom styles
        static let sectionHeader = Font.system(size: 12, weight: .semibold)
        static let cardTitle = Font.system(size: 12, weight: .medium)
        static let cardValue = Font.system(size: 16, weight: .bold)
        static let cardChange = Font.system(size: 12, weight: .medium)
        static let newsTag = Font.system(size: 10, weight: .bold)
        static let newsHeadline = Font.system(size: 16, weight: .semibold)
        static let newsTime = Font.system(size: 12, weight: .regular)
    }
}

// MARK: - Enhanced Components

struct DSSeparator: View {
    enum Orientation {
        case horizontal
        case vertical
    }
    
    let orientation: Orientation
    
    init(orientation: Orientation = .horizontal) {
        self.orientation = orientation
    }
    
    var body: some View {
        Rectangle()
            .fill(DesignSystem.Colors.separator)
            .frame(
                width: orientation == .vertical ? 1 : nil,
                height: orientation == .horizontal ? 1 : nil
            )
    }
}

// MARK: - Stock Logo Helper Functions

func stockLogo(for symbol: String, size: CGFloat) -> some View {
    let (bgColor, fgColor, text) = getLogoStyle(for: symbol)
    
    return Circle()
        .fill(bgColor)
        .frame(width: size, height: size)
        .overlay(
            Text(text)
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundColor(fgColor)
        )
}

func getLogoStyle(for symbol: String) -> (Color, Color, String) {
    switch symbol {
    case "AAPL": return (Color.black, .white, "")
    case "NVDA": return (Color.green, .white, "N")
    case "TSLA": return (Color.red, .white, "T")
    case "MSFT": return (Color.blue, .white, "M")
    case "AMZN": return (Color.orange, .white, "A")
    case "GOOGL": return (Color.red, .white, "G")
    case "META": return (Color.blue, .white, "f")
    case "NFLX": return (Color.red, .white, "N")
    case "DIS": return (Color.indigo, .white, "D")
    case "BMW": return (Color.blue, .white, "BMW")
    case "SAP": return (Color.blue, .white, "S")
    case "EONGY", "EOAN": return (Color.red, .white, "e·on")
    case "BAS": return (Color.green.opacity(0.8), .white, "BASF")
    case "SIE": return (Color(red: 0.0, green: 0.5, blue: 0.5), .white, "S")
    case "VOW3": return (Color.blue, .white, "VW")
    case "ALV": return (Color.blue.opacity(0.7), .white, "A")
    case "DBK": return (Color.blue.opacity(0.9), .white, "DB")
    case "BTC": return (Color.orange, .white, "₿")
    case "ETH": return (Color.purple, .white, "Ξ")
    case "GLD": return (Color.yellow.opacity(0.8), .black, "Au")
    default: 
        let firstChar = String(symbol.prefix(1))
        return (Color.gray, .white, firstChar)
    }
}

// MARK: - News Components

struct NewsCardCompact: View {
    let title: String
    let category: String
    let time: String
    let source: String = "FinanzNachrichten.de"
    @State private var showingDetail = false
    
    private var sampleArticle: NewsArticle {
        NewsArticle(
            title: title,
            category: category,
            time: time,
            source: source,
            hasImage: false,
            body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
            mentionedInstruments: []
        )
    }
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            DSCard(
                backgroundColor: DesignSystem.Colors.cardBackground,
                borderColor: DesignSystem.Colors.border,
                cornerRadius: DesignSystem.CornerRadius.lg,
                padding: DesignSystem.Spacing.lg,
                hasShadow: true
            ) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    Text(title)
                        .font(DesignSystem.Typography.headline)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(category)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.primary)
                        
                        Text("•")
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.tertiary)
                        
                        Text(time)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.secondary)
                        
                        Spacer()
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            NewsDetailView(article: sampleArticle)
        }
    }
}

struct NewsCardLarge: View {
    let title: String
    let category: String
    let time: String
    let hasImage: Bool = true
    @State private var showingDetail = false
    
    private var sampleArticle: NewsArticle {
        NewsArticle(
            title: title,
            category: category,
            time: time,
            source: "FinanzNachrichten.de",
            hasImage: hasImage,
            body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.",
            mentionedInstruments: [
                NewsInstrument(symbol: "AAPL", name: "Apple Inc.", price: "$182.52", change: "+1.23%", isPositive: true),
                NewsInstrument(symbol: "MSFT", name: "Microsoft Corp.", price: "$378.85", change: "+0.87%", isPositive: true)
            ]
        )
    }
    
    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: 0,
            hasShadow: true
        ) {
            VStack(alignment: .leading, spacing: 0) {
                // Image placeholder
                if hasImage {
                    ZStack {
                        // Gradient background simulating code/tech image
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.05, green: 0.1, blue: 0.15),
                                Color(red: 0.1, green: 0.2, blue: 0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 180)
                        
                        // Code-like overlay
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(0..<8) { i in
                                HStack(spacing: 8) {
                                    Rectangle()
                                        .fill(Color.cyan.opacity(0.3))
                                        .frame(width: CGFloat.random(in: 40...120), height: 3)
                                    Rectangle()
                                        .fill(Color.green.opacity(0.3))
                                        .frame(width: CGFloat.random(in: 60...100), height: 3)
                                    Rectangle()
                                        .fill(Color.blue.opacity(0.3))
                                        .frame(width: CGFloat.random(in: 30...80), height: 3)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.vertical, 20)
                    }
                    .clipped()
                }
                
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text(title)
                        .font(DesignSystem.Typography.headline)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Text(category)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.primary)
                            .padding(.horizontal, DesignSystem.Spacing.sm)
                            .padding(.vertical, DesignSystem.Spacing.xs)
                            .background(DesignSystem.Colors.primary.opacity(0.1))
                            .cornerRadius(DesignSystem.CornerRadius.sm)
                        
                        Spacer()
                        
                        Text(time)
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                }
                .padding(DesignSystem.Spacing.lg)
            }
        }
        .shadow(color: DesignSystem.Colors.shadowMedium, radius: 15, x: 0, y: 6)
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            NewsDetailView(article: sampleArticle)
        }
    }
}

struct NewsCardLargeWithRating: View {
    let title: String
    let category: String
    let time: String
    let rating: Double = 4.0
    let readerCount: Int = 1234
    let hasImage: Bool = true
    @State private var showingDetail = false
    
    private var sampleArticle: NewsArticle {
        NewsArticle(
            title: title,
            category: category,
            time: time,
            source: "FinanzNachrichten.de",
            hasImage: hasImage,
            body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.",
            mentionedInstruments: [
                NewsInstrument(symbol: "AAPL", name: "Apple Inc.", price: "$182.52", change: "+1.23%", isPositive: true),
                NewsInstrument(symbol: "TSLA", name: "Tesla Inc.", price: "$234.67", change: "-1.87%", isPositive: false)
            ]
        )
    }
    
    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: 0,
            hasShadow: true
        ) {
            VStack(alignment: .leading, spacing: 0) {
                // Image placeholder with rating overlay
                if hasImage {
                    ZStack {
                        // Gradient background simulating code/tech image
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.05, green: 0.1, blue: 0.15),
                                Color(red: 0.1, green: 0.2, blue: 0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 180)
                        
                        // Code-like overlay
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(0..<8) { i in
                                HStack(spacing: 8) {
                                    Rectangle()
                                        .fill(Color.cyan.opacity(0.3))
                                        .frame(width: CGFloat.random(in: 40...120), height: 3)
                                    Rectangle()
                                        .fill(Color.green.opacity(0.3))
                                        .frame(width: CGFloat.random(in: 60...100), height: 3)
                                    Rectangle()
                                        .fill(Color.blue.opacity(0.3))
                                        .frame(width: CGFloat.random(in: 30...80), height: 3)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.vertical, 20)
                        
                        // Rating overlay in top right corner
                        VStack {
                            HStack {
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    // Stars
                                    HStack(spacing: 1) {
                                        ForEach(0..<Int(rating)) { _ in
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 10))
                                                .foregroundColor(.orange)
                                        }
                                    }
                                    
                                    // Reader count
                                    HStack(spacing: 2) {
                                        Image(systemName: "eye")
                                            .font(.system(size: 8))
                                            .foregroundColor(.white.opacity(0.8))
                                        Text("\(readerCount) Leser")
                                            .font(.system(size: 9, weight: .medium))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(8)
                            }
                            Spacer()
                        }
                        .padding(12)
                    }
                    .clipped()
                }
                
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text(title)
                        .font(DesignSystem.Typography.headline)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Text(category)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.primary)
                            .padding(.horizontal, DesignSystem.Spacing.sm)
                            .padding(.vertical, DesignSystem.Spacing.xs)
                            .background(DesignSystem.Colors.primary.opacity(0.1))
                            .cornerRadius(DesignSystem.CornerRadius.sm)
                        
                        Spacer()
                        
                        Text(time)
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                }
                .padding(DesignSystem.Spacing.lg)
            }
        }
        .shadow(color: DesignSystem.Colors.shadowMedium, radius: 15, x: 0, y: 6)
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            NewsDetailView(article: sampleArticle)
        }
    }
}

struct NewsListItem: View {
    let title: String
    let category: String
    let time: String
    @State private var showingDetail = false
    
    private var sampleArticle: NewsArticle {
        NewsArticle(
            title: title,
            category: category,
            time: time,
            source: "FinanzNachrichten.de",
            hasImage: false,
            body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            mentionedInstruments: [
                NewsInstrument(symbol: "NVDA", name: "NVIDIA Corp.", price: "$724.31", change: "+2.14%", isPositive: true)
            ]
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text(title)
                .font(DesignSystem.Typography.body1)
                .foregroundColor(DesignSystem.Colors.onCard)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Text(category)
                    .font(DesignSystem.Typography.caption2)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Text("•")
                    .font(DesignSystem.Typography.caption2)
                    .foregroundColor(DesignSystem.Colors.secondary)
                
                Text(time)
                    .font(DesignSystem.Typography.caption2)
                    .foregroundColor(DesignSystem.Colors.secondary)
                
                Spacer()
            }
        }
        .padding(.vertical, DesignSystem.Spacing.md)
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            NewsDetailView(article: sampleArticle)
        }
    }
}

struct DSCard<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    let borderColor: Color?
    let cornerRadius: CGFloat
    let padding: CGFloat
    let hasShadow: Bool
    
    init(
        backgroundColor: Color = DesignSystem.Colors.surface,
        borderColor: Color? = DesignSystem.Colors.border,
        cornerRadius: CGFloat = DesignSystem.CornerRadius.lg,
        padding: CGFloat = DesignSystem.Spacing.lg,
        hasShadow: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.hasShadow = hasShadow
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor ?? Color.clear, lineWidth: borderColor != nil ? 1 : 0)
            )
            .shadow(
                color: hasShadow ? DesignSystem.Colors.shadowLight : Color.clear,
                radius: hasShadow ? 10 : 0,
                x: 0,
                y: hasShadow ? 4 : 0
            )
    }
}

// MARK: - Logo Component

struct FNLogoView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Rotated square background
            RoundedRectangle(cornerRadius: size * 0.15)
                .fill(Color(red: 0.8, green: 0.2, blue: 0.2)) // #CC3333 equivalent
                .frame(width: size, height: size)
                .rotationEffect(.degrees(45))
            
            // FN Text
            Text("FN")
                .font(.system(size: size * 0.5, weight: .bold, design: .default))
                .foregroundColor(.white)
        }
        .frame(width: size * 1.2, height: size * 1.2)
    }
}

// MARK: - Header Component

struct FNHeaderView: View {
    @State private var showingSearch = false
    @State private var showingNotifications = false
    @StateObject private var notificationService = NotificationService()
    
    var body: some View {
        HStack {
            // FN Logo
            FNLogoView(size: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Guten Morgen, Sascha")
                    .font(DesignSystem.Typography.title1)
                    .foregroundColor(DesignSystem.Colors.onBackground)
            }
            
            Spacer()
            
            HStack(spacing: DesignSystem.Spacing.xl) {
                // Notification Bell with Badge
                Button(action: {
                    showingNotifications = true
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 24))
                            .foregroundColor(DesignSystem.Colors.onBackground.opacity(0.7))
                        
                        if notificationService.unreadCount > 0 {
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 20, height: 20)
                                
                                Text("\(notificationService.unreadCount)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .offset(x: 10, y: -10)
                        }
                    }
                }
                
                // Search Icon
                Button(action: {
                    showingSearch = true
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 24))
                        .foregroundColor(DesignSystem.Colors.onBackground.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.vertical, DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.surface)
        .overlay(
            DSSeparator(),
            alignment: .bottom
        )
        .sheet(isPresented: $showingSearch) {
            SearchView(isPresented: $showingSearch)
        }
        .sheet(isPresented: $showingNotifications) {
            NotificationView(isPresented: $showingNotifications, notificationService: notificationService)
        }
    }
}

// MARK: - Bottom Navigation

struct BottomNavigationView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            ZStack {
                // Glassmorphic Background - less transparent
                RoundedRectangle(cornerRadius: 24)
                    .fill(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                    )
                
                // Navigation Items
                HStack(spacing: 0) {
                    BottomNavItem(icon: "house.fill", title: "HOME", isSelected: selectedTab == 0)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = 0
                            }
                        }
                    BottomNavItem(icon: "chart.bar.fill", title: "MÄRKTE", isSelected: selectedTab == 1)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = 1
                            }
                        }
                    BottomNavItem(icon: "bookmark.fill", title: "WATCHLIST", isSelected: selectedTab == 2)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = 2
                            }
                        }
                    BottomNavItem(icon: "newspaper.fill", title: "NEWS", isSelected: selectedTab == 3)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = 3
                            }
                        }
                    BottomNavItem(icon: "line.3.horizontal", title: "MENÜ", isSelected: selectedTab == 4)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = 4
                            }
                        }
                }
                .padding(.horizontal, DesignSystem.Spacing.sm)
                .padding(.vertical, DesignSystem.Spacing.md)
            }
            .frame(height: 80)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.bottom, DesignSystem.Spacing.sm)
            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
        }
    }
}

struct BottomNavItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 28, weight: isSelected ? .medium : .regular))
            .foregroundColor(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.secondary.opacity(0.7))
            .scaleEffect(isSelected ? 1.15 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Market Card Component

struct DSMarketCard: View {
    let market: MarketCard
    @State private var showingInstrument = false
    
    var body: some View {
        Button(action: {
            print("Tapped market: \(market.name)")
            showingInstrument = true
        }) {
            DSCard(
                backgroundColor: DesignSystem.Colors.cardBackground,
                borderColor: DesignSystem.Colors.border,
                cornerRadius: DesignSystem.CornerRadius.xl,
                padding: DesignSystem.Spacing.lg,
                hasShadow: true
            ) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    HStack {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                            Text(market.name)
                                .font(DesignSystem.Typography.cardTitle)
                                .foregroundColor(DesignSystem.Colors.secondary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Text(market.value)
                                .font(DesignSystem.Typography.cardValue)
                                .foregroundColor(DesignSystem.Colors.onCard)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer(minLength: 0)
                    }
                    
                    HStack {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(market.isPositive ? DesignSystem.Colors.success.opacity(0.12) : DesignSystem.Colors.error.opacity(0.12))
                                .frame(width: 6, height: 12)
                            
                            Text(market.change)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(market.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                        }
                        
                        Spacer()
                        
                        Image(systemName: market.isPositive ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(market.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingInstrument) {
            InstrumentView(instrument: convertMarketCardToInstrumentData(from: market))
        }
    }
    
    private func convertMarketCardToInstrumentData(from marketCard: MarketCard) -> InstrumentData {
        let price = Double(marketCard.value.replacingOccurrences(of: "€", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: " ", with: "")) ?? 1000.0
        let changeValue = Double(marketCard.change.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0.0
        
        // Convert market name to symbol
        let symbol = marketCardNameToSymbol(marketCard.name)
        
        return InstrumentData(
            symbol: symbol,
            name: marketCard.name,
            currentPrice: price,
            change: changeValue * price / 100,
            changePercent: changeValue,
            dayLow: price * 0.98,
            dayHigh: price * 1.02,
            volume: Int.random(in: 1_000_000...50_000_000),
            marketCap: generateMarketCapForIndex(price: price),
            pe: nil, // Indices don't have P/E ratios
            chartData: InstrumentData.generateSampleChartData(isPositive: marketCard.isPositive),
            isPositive: marketCard.isPositive
        )
    }
    
    private func marketCardNameToSymbol(_ name: String) -> String {
        switch name {
        case "Euro": return "EUR"
        case "Öl": return "OIL"
        case "DOW JONES": return "DJI"
        case "S&P 500": return "SPX"
        case "NASDAQ": return "IXIC"
        default: return name.uppercased()
        }
    }
    
    private func generateMarketCapForIndex(price: Double) -> String {
        let marketCap = price * Double.random(in: 1_000_000_000...10_000_000_000)
        return String(format: "%.1fT", marketCap / 1_000_000_000_000)
    }
}

// MARK: - Watchlist Teaser Card

struct WatchlistTeaserCard: View {
    let symbol: String
    let name: String
    let price: String
    let change: String
    let isPositive: Bool
    @State private var showingInstrument = false
    
    var body: some View {
        Button(action: {
            print("Tapped performance card: \(symbol)")
            showingInstrument = true
        }) {
            DSCard(
                backgroundColor: DesignSystem.Colors.cardBackground,
                borderColor: DesignSystem.Colors.border,
                cornerRadius: DesignSystem.CornerRadius.lg,
                padding: DesignSystem.Spacing.md,
                hasShadow: true
            ) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    HStack {
                        // Stock logo at top
                        stockLogo(for: symbol, size: 32)
                        
                        Spacer()
                        
                        Text(change)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(symbol)
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                        
                        Text(name)
                            .font(DesignSystem.Typography.body2)
                            .foregroundColor(DesignSystem.Colors.onCard)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Text(price)
                        .font(.system(size: 10))
                        .foregroundColor(DesignSystem.Colors.onCard.opacity(0.8))
                        .fontWeight(.medium)
                }
            }
            .frame(width: 180, height: 100)
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingInstrument) {
            InstrumentView(instrument: convertToInstrumentData())
        }
    }
    
    private func convertToInstrumentData() -> InstrumentData {
        let priceValue = Double(price.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: "€", with: "").replacingOccurrences(of: ",", with: "")) ?? 100.0
        let changeValue = Double(change.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0.0
        
        return InstrumentData(
            symbol: symbol,
            name: name,
            currentPrice: priceValue,
            change: changeValue * priceValue / 100,
            changePercent: changeValue,
            dayLow: priceValue * 0.97,
            dayHigh: priceValue * 1.03,
            volume: Int.random(in: 1000000...50000000),
            marketCap: "1.23T",
            pe: 28.5,
            chartData: InstrumentData.generateSampleChartData(isPositive: isPositive),
            isPositive: isPositive
        )
    }
}

// MARK: - Market Movement Row Component

struct MarketMovementRow: View {
    let title: String
    let companyName: String
    let change: String
    let symbol: String
    let isPositive: Bool
    @State private var showingInstrument = false
    
    var body: some View {
        Button(action: {
            print("Tapped market movement: \(symbol)")
            showingInstrument = true
        }) {
            HStack {
                // Stock logo
                stockLogo(for: symbol, size: 40)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(title)
                        .font(DesignSystem.Typography.body2)
                        .foregroundColor(DesignSystem.Colors.secondary)
                    Text(companyName)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.semibold)
                    Text(change)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                }
                Spacer()
                Image(systemName: isPositive ? "arrow.up.right.circle.fill" : "arrow.down.right.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingInstrument) {
            InstrumentView(instrument: convertMarketMovementToInstrumentData())
        }
    }
    
    private func convertMarketMovementToInstrumentData() -> InstrumentData {
        let changeValue = Double(change.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0.0
        let basePrice = symbol == "AAPL" ? 182.52 : 234.67
        
        return InstrumentData(
            symbol: symbol,
            name: companyName,
            currentPrice: basePrice,
            change: changeValue * basePrice / 100,
            changePercent: changeValue,
            dayLow: basePrice * 0.97,
            dayHigh: basePrice * 1.03,
            volume: Int.random(in: 100_000...10_000_000),
            marketCap: generateMarketCapForMovementStock(basePrice: basePrice),
            pe: Double.random(in: 15...35),
            chartData: InstrumentData.generateSampleChartData(isPositive: isPositive),
            isPositive: isPositive
        )
    }
    
    private func generateMarketCapForMovementStock(basePrice: Double) -> String {
        let marketCap = basePrice * Double.random(in: 100_000_000...1_000_000_000)
        if marketCap >= 1_000_000_000 {
            return String(format: "%.1fB", marketCap / 1_000_000_000)
        } else {
            return String(format: "%.0fM", marketCap / 1_000_000)
        }
    }
}

// MARK: - Security Row Component

struct SecurityRow: View {
    let security: Security
    @State private var showingInstrument = false
    
    var body: some View {
        Button(action: {
            print("Tapped security: \(security.symbol)")
            showingInstrument = true
        }) {
            HStack {
                // Stock logo
                stockLogo(for: security.symbol, size: 40)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(security.name)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.medium)
                    Text(security.symbol)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                    Text("$\(security.price)")
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.semibold)
                    Text(security.change)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(security.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingInstrument) {
            InstrumentView(instrument: convertSecurityToInstrumentData(from: security))
        }
    }
    
    private func convertSecurityToInstrumentData(from security: Security) -> InstrumentData {
        let price = Double(security.price) ?? 100.0
        let changeValue = Double(security.change.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0.0
        
        return InstrumentData(
            symbol: security.symbol,
            name: security.name,
            currentPrice: price,
            change: changeValue * price / 100,
            changePercent: changeValue,
            dayLow: price * 0.97,
            dayHigh: price * 1.03,
            volume: Int.random(in: 100_000...10_000_000),
            marketCap: generateMarketCapForStock(price: price),
            pe: Double.random(in: 15...35),
            chartData: InstrumentData.generateSampleChartData(isPositive: security.isPositive),
            isPositive: security.isPositive
        )
    }
    
    private func generateMarketCapForStock(price: Double) -> String {
        let marketCap = price * Double.random(in: 100_000_000...1_000_000_000)
        if marketCap >= 1_000_000_000 {
            return String(format: "%.1fB", marketCap / 1_000_000_000)
        } else {
            return String(format: "%.0fM", marketCap / 1_000_000)
        }
    }
}

// MARK: - Market Summary View

struct MarketSummaryView: View {
    @Binding var currentIndex: Int
    
    // Market summaries for each category
    private let marketSummaries = [
        // Europa (Index 0-4: DAX, MDAX, SDAX, TecDAX, EuroStoxx 50)
        "Europa": "Die europäischen Märkte zeigen sich heute überwiegend freundlich. Positive Impulse kommen von robusten Unternehmenszahlen und der stabilen Konjunkturlage in der Eurozone. Der DAX profitiert besonders von starken Autowerten.",
        
        // Nordamerika (Index 5-7: DJ Industrial, Nasdaq 100, S&P 500)
        "Nordamerika": "Die US-Märkte tendieren fest. Tech-Werte führen die Rally an, unterstützt von optimistischen Wachstumsprognosen. Die Fed-Politik bleibt im Fokus der Anleger, während Inflationsdaten Entspannung signalisieren.",
        
        // Asien (Index 8: Nikkei)
        "Asien": "Die asiatischen Börsen zeigen ein gemischtes Bild. Der Nikkei profitiert von der Yen-Schwäche und positiven Exportdaten. Chinesische Konjunkturmaßnahmen sorgen für vorsichtigen Optimismus in der Region.",
        
        // Rohstoffe & Devisen (Index 9-12: Gold, Brent Oil, EUR/Dollar, Bitcoin)
        "Rohstoffe": "Gold bleibt als sicherer Hafen gefragt. Öl-Preise stabilisieren sich auf hohem Niveau durch OPEC-Förderkürzungen. Der Euro zeigt Stärke gegenüber dem Dollar, während Bitcoin neue Jahreshochs testet."
    ]
    
    private var currentCategory: String {
        switch currentIndex {
        case 0...4:
            return "Europa"
        case 5...7:
            return "Nordamerika"
        case 8:
            return "Asien"
        case 9...12:
            return "Rohstoffe"
        default:
            return "Europa"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            Text("Das bewegt die Märkte aktuell")
                .font(DesignSystem.Typography.title2)
                .foregroundColor(DesignSystem.Colors.onBackground)
            
            DSCard(
                backgroundColor: DesignSystem.Colors.cardBackground,
                borderColor: DesignSystem.Colors.border,
                cornerRadius: DesignSystem.CornerRadius.lg,
                padding: DesignSystem.Spacing.lg,
                hasShadow: true
            ) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    Text(marketSummaries[currentCategory] ?? "")
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .lineSpacing(4)
                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                        .id(currentCategory) // Force view refresh for smooth animation
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Home View

struct HomeView: View {
    @EnvironmentObject var bookmarkService: BookmarkService
    @EnvironmentObject var notificationService: NotificationService
    @State private var currentMarketIndex = 0
    @State private var scrollOffset: CGFloat = 0
    
    // Sample watchlist items - in real app from persistent storage
    let watchlistItems = [
        WatchlistItem(symbol: "AAPL", name: "Apple Inc.", price: "$182.52", change: "+2.24", changePercent: "+1.23%", isPositive: true),
        WatchlistItem(symbol: "NVDA", name: "NVIDIA Corp.", price: "$724.31", change: "+15.42", changePercent: "+2.14%", isPositive: true),
        WatchlistItem(symbol: "MSFT", name: "Microsoft", price: "$378.85", change: "+3.32", changePercent: "+0.87%", isPositive: true),
        WatchlistItem(symbol: "TSLA", name: "Tesla Inc.", price: "$201.45", change: "-3.78", changePercent: "-1.87%", isPositive: false),
        WatchlistItem(symbol: "AMZN", name: "Amazon", price: "$155.34", change: "+0.87", changePercent: "+0.56%", isPositive: true),
        WatchlistItem(symbol: "GOOGL", name: "Alphabet", price: "$138.45", change: "-0.66", changePercent: "-0.45%", isPositive: false)
    ]
    
    var topPerformers: [WatchlistItem] {
        watchlistItems.sorted { item1, item2 in
            let percent1 = Double(item1.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            let percent2 = Double(item2.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            return percent1 > percent2
        }
    }
    
    let marketData = [
        // Indices
        MarketCard(name: "DAX", value: "19,432.56", change: "+0.52%", isPositive: true),
        MarketCard(name: "MDAX", value: "26,189.34", change: "+0.74%", isPositive: true),
        MarketCard(name: "SDAX", value: "13,876.45", change: "-0.12%", isPositive: false),
        MarketCard(name: "TecDAX", value: "3,421.78", change: "+1.23%", isPositive: true),
        MarketCard(name: "EuroStoxx 50", value: "4,982.34", change: "+0.45%", isPositive: true),
        MarketCard(name: "DJ Industrial", value: "42,866.87", change: "+0.33%", isPositive: true),
        MarketCard(name: "Nasdaq 100", value: "21,234.56", change: "+0.87%", isPositive: true),
        MarketCard(name: "S&P 500", value: "5,918.24", change: "+0.45%", isPositive: true),
        MarketCard(name: "Nikkei", value: "39,876.23", change: "-0.34%", isPositive: false),
        // Rohstoffe
        MarketCard(name: "Gold", value: "2,043.25", change: "-0.18%", isPositive: false),
        MarketCard(name: "Brent Oil", value: "73.45", change: "+1.74%", isPositive: true),
        MarketCard(name: "EUR/Dollar", value: "1.0834", change: "+0.23%", isPositive: true),
        MarketCard(name: "Bitcoin", value: "96,432.18", change: "+2.87%", isPositive: true)
    ]
    
    let securities = [
        Security(name: "Apple Inc.", symbol: "AAPL", price: "182.52", change: "+1.23%", isPositive: true),
        Security(name: "Microsoft", symbol: "MSFT", price: "378.85", change: "+0.87%", isPositive: true),
        Security(name: "NVIDIA", symbol: "NVDA", price: "724.31", change: "+2.14%", isPositive: true),
        Security(name: "Amazon", symbol: "AMZN", price: "145.73", change: "-0.45%", isPositive: false),
        Security(name: "Tesla", symbol: "TSLA", price: "234.67", change: "-1.87%", isPositive: false)
    ]
    
    private func getSampleNewsTitle(_ index: Int) -> String {
        let titles = [
            "DAX erreicht neues Jahreshoch bei 19.500 Punkten",
            "Apple stellt neue KI-Features vor - Aktie steigt",
            "EZB kündigt weitere Zinsschritte an",
            "Tesla übertrifft Erwartungen im Q4",
            "Inflation in Deutschland sinkt auf 2,1%",
            "Bitcoin durchbricht 100.000 Dollar Marke",
            "Volkswagen plant massive Investitionen",
            "US-Arbeitsmarktdaten überraschen positiv",
            "Siemens Energy mit Rekordauftrag",
            "Deutsche Bank übertrifft Gewinnerwartungen"
        ]
        return titles[index % titles.count]
    }
    
    private func getSampleCategory(_ index: Int) -> String {
        let categories = ["Märkte", "Technologie", "Geldpolitik", "Earnings", "Wirtschaft", "Krypto", "Auto", "Energie", "Banken"]
        return categories[index % categories.count]
    }
    
    let editorialNews = [
        EditorialNewsItem(
            title: "Neue EU-Regulierung für Kryptowährungen tritt in Kraft",
            category: "Politik",
            time: "vor 2 Stunden",
            imageName: "news_placeholder"
        ),
        EditorialNewsItem(
            title: "Tech-Aktien setzen Rallye fort - NVIDIA erreicht neues Allzeithoch",
            category: "Technologie",
            time: "vor 3 Stunden",
            imageName: "news_placeholder"
        ),
        EditorialNewsItem(
            title: "Inflation in Deutschland sinkt auf 2,1 Prozent",
            category: "Wirtschaft",
            time: "vor 5 Stunden",
            imageName: "news_placeholder"
        )
    ]
    
    let watchlistNews = [
        WatchlistNewsItem(title: "Apple kündigt neue MacBook Pro Serie an", time: "vor 1 Stunde"),
        WatchlistNewsItem(title: "Tesla erweitert Produktionskapazitäten in Deutschland", time: "vor 2 Stunden"),
        WatchlistNewsItem(title: "Microsoft übernimmt KI-Startup für 2 Milliarden Dollar", time: "vor 3 Stunden"),
        WatchlistNewsItem(title: "Amazon Prime Day bricht alle Verkaufsrekorde", time: "vor 4 Stunden"),
        WatchlistNewsItem(title: "Google stellt neue Pixel-Smartphones vor", time: "vor 5 Stunden"),
        WatchlistNewsItem(title: "Netflix plant Expansion in neue Märkte", time: "vor 6 Stunden")
    ]
    
    let scheduleItems = [
        ScheduleItem(title: "Apple Q4 Earnings", date: "28. Jan", time: "22:00", type: .earnings),
        ScheduleItem(title: "Tesla Ex-Dividend", date: "29. Jan", time: "09:00", type: .exDividend),
        ScheduleItem(title: "Microsoft Dividende", date: "30. Jan", time: "16:00", type: .dividend),
        ScheduleItem(title: "US Börsenfeiertag", date: "31. Jan", time: "Ganztägig", type: .holiday),
        ScheduleItem(title: "Inflationsdaten EU", date: "1. Feb", time: "11:00", type: .economicData),
        ScheduleItem(title: "Amazon Quartalszahlen", date: "2. Feb", time: "21:30", type: .earnings)
    ]
    
    let additionalNews = [
        AdditionalNewsItem(
            title: "Europäische Zentralbank senkt Leitzins um 0,25 Prozentpunkte",
            category: "Geldpolitik",
            time: "vor 1 Stunde",
            imageName: "news_placeholder",
        ),
        AdditionalNewsItem(
            title: "Deutscher Aktienindex DAX erreicht neues Jahreshoch",
            category: "Börse",
            time: "vor 2 Stunden",
            imageName: "news_placeholder"
        ),
        AdditionalNewsItem(
            title: "Rohölpreise steigen nach OPEC-Entscheidung um drei Prozent",
            category: "Rohstoffe",
            time: "vor 3 Stunden",
            imageName: "news_placeholder"
        ),
        AdditionalNewsItem(
            title: "US-Arbeitsmarktdaten übertreffen Erwartungen deutlich",
            category: "Wirtschaftsdaten",
            time: "vor 4 Stunden",
            imageName: "news_placeholder"
        ),
        AdditionalNewsItem(
            title: "Bitcoin überschreitet erstmals 50.000 Dollar Marke",
            category: "Kryptowährungen",
            time: "vor 5 Stunden",
            imageName: "news_placeholder"
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header with FN Logo
                FNHeaderView()
                
                // Top Performers from Watchlist
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                    Text("Deine Top Performer heute")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DesignSystem.Spacing.md) {
                            // Show top 5 performers from watchlist sorted by performance
                            ForEach(topPerformers.prefix(5), id: \.symbol) { item in
                                WatchlistTeaserCard(
                                    symbol: item.symbol,
                                    name: item.name,
                                    price: item.price,
                                    change: item.changePercent,
                                    isPositive: item.isPositive
                                )
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.vertical, 10)
                    }
                }
                .padding(.top, DesignSystem.Spacing.lg)
                .padding(.bottom, 10)
                .zIndex(1)
                
                // Schedule/Calendar Section
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                    Text("Wichtige Termine diese Woche")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DesignSystem.Spacing.md) {
                            ForEach(scheduleItems, id: \.title) { item in
                                DSCard(
                                    backgroundColor: DesignSystem.Colors.cardBackground,
                                    borderColor: DesignSystem.Colors.border,
                                    cornerRadius: DesignSystem.CornerRadius.lg,
                                    padding: DesignSystem.Spacing.md,
                                    hasShadow: true
                                ) {
                                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                        HStack {
                                            Text(item.date)
                                                .font(DesignSystem.Typography.caption2)
                                                .foregroundColor(DesignSystem.Colors.secondary)
                                            
                                            Spacer()
                                            
                                            Text(item.time)
                                                .font(DesignSystem.Typography.caption1)
                                                .foregroundColor(DesignSystem.Colors.onCard)
                                                .fontWeight(.semibold)
                                        }
                                        
                                        Spacer()
                                        
                                        Text(item.title)
                                            .font(DesignSystem.Typography.body2)
                                            .foregroundColor(DesignSystem.Colors.onCard)
                                            .fontWeight(.medium)
                                            .lineLimit(2)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Text(item.type.displayName)
                                            .font(.system(size: 10))
                                            .foregroundColor(item.type.color.opacity(0.8))
                                            .fontWeight(.medium)
                                    }
                                }
                                .frame(width: 180, height: 100)
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.vertical, 10)
                    }
                }
                .padding(.top, DesignSystem.Spacing.lg)
                .padding(.bottom, 10)
                
                // News Section
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                    Text("Nachrichten für dich")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                    
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        // First news as large card
                        if let firstNews = editorialNews.first {
                            NewsCardLarge(
                                title: firstNews.title,
                                category: firstNews.category,
                                time: firstNews.time
                            )
                        }
                        
                        // Mix of news cards - infinite feed
                        ForEach(0..<30, id: \.self) { index in
                            if index % 3 == 2 {
                                // Every 3rd card without image
                                NewsCardCompact(
                                    title: getSampleNewsTitle(index),
                                    category: getSampleCategory(index),
                                    time: "vor \(index + 2) Stunden"
                                )
                            } else {
                                // Card with image
                                NewsCardLarge(
                                    title: getSampleNewsTitle(index),
                                    category: getSampleCategory(index),
                                    time: "vor \(index + 2) Stunden"
                                )
                            }
                            
                            // Ad placeholder every 5 items
                            if (index + 1) % 5 == 0 {
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                                    .fill(DesignSystem.Colors.surface)
                                    .frame(height: 80)
                                    .overlay(
                                        Text("Werbeplatz")
                                            .font(DesignSystem.Typography.body2)
                                            .foregroundColor(DesignSystem.Colors.secondary)
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.top, 10)
                .padding(.bottom, 100) // Space for bottom navigation
            }
        }
        .background(DesignSystem.Colors.background)
    }
}

// MARK: - Markets View

struct MarketsView: View {
    @State private var selectedCategory = 0
    @State private var currentMarketIndex = 0
    let categories = ["Übersicht", "Termine", "Indizes", "Aktien", "Rohstoffe", "Devisen", "Krypto"]
    
    let marketData = [
        MarketCard(name: "DAX", value: "15,234.56", change: "+0.78%", isPositive: true),
        MarketCard(name: "DOW JONES", value: "34,567.89", change: "+0.45%", isPositive: true),
        MarketCard(name: "NASDAQ", value: "14,123.45", change: "-0.23%", isPositive: false),
        MarketCard(name: "EUR/USD", value: "1.0234", change: "+0.12%", isPositive: true),
        MarketCard(name: "Bitcoin", value: "$43,567", change: "+2.34%", isPositive: true),
        MarketCard(name: "Gold", value: "$2,045", change: "+0.45%", isPositive: true)
    ]
    
    let securities = [
        Security(name: "Apple Inc.", symbol: "AAPL", price: "$182.52", change: "+1.23%", isPositive: true),
        Security(name: "Microsoft Corp.", symbol: "MSFT", price: "$378.85", change: "+0.87%", isPositive: true),
        Security(name: "NVIDIA Corp.", symbol: "NVDA", price: "$724.31", change: "+2.14%", isPositive: true),
        Security(name: "Tesla Inc.", symbol: "TSLA", price: "$201.45", change: "-1.87%", isPositive: false),
        Security(name: "Amazon.com Inc.", symbol: "AMZN", price: "$155.34", change: "+0.56%", isPositive: true)
    ]
    
    let instruments = [
        MarketInstrument(name: "DAX", value: "15,234.56", change: "+0.78%", isPositive: true),
        MarketInstrument(name: "S&P 500", value: "4,567.89", change: "+0.45%", isPositive: true),
        MarketInstrument(name: "NASDAQ", value: "14,123.45", change: "-0.23%", isPositive: false),
        MarketInstrument(name: "FTSE 100", value: "7,456.78", change: "+0.12%", isPositive: true),
        MarketInstrument(name: "Apple Inc.", value: "$182.52", change: "+1.23%", isPositive: true),
        MarketInstrument(name: "Microsoft Corp.", value: "$378.85", change: "+0.87%", isPositive: true),
        MarketInstrument(name: "NVIDIA Corp.", value: "$724.31", change: "+2.14%", isPositive: true),
        MarketInstrument(name: "Bitcoin", value: "$43,567.89", change: "+2.34%", isPositive: true),
        MarketInstrument(name: "Ethereum", value: "$2,678.45", change: "+1.78%", isPositive: true),
        MarketInstrument(name: "Gold", value: "$2,045.67", change: "+0.45%", isPositive: true)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with FN Logo
            FNHeaderView()
            
            // Markets Sub-Navigation
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.Spacing.xl) {
                    ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                        VStack(spacing: DesignSystem.Spacing.sm) {
                            Text(category)
                                .font(.system(size: 15, weight: selectedCategory == index ? .semibold : .medium))
                                .foregroundColor(selectedCategory == index ? DesignSystem.Colors.onBackground : DesignSystem.Colors.secondary)
                            
                            RoundedRectangle(cornerRadius: 1)
                                .fill(selectedCategory == index ? DesignSystem.Colors.primary : Color.clear)
                                .frame(height: 2)
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedCategory = index
                            }
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.lg)
            }
            .padding(.vertical, DesignSystem.Spacing.lg)
            .background(DesignSystem.Colors.surface)
            .overlay(
                DSSeparator(),
                alignment: .bottom
            )
            
            // Content based on selected category
            if selectedCategory == 1 {
                CalendarView()
            } else if selectedCategory == 0 {
                // Übersicht Tab - Market Overview with cards and top movers
                ScrollView {
                    VStack(spacing: 0) {
                        // Market Cards (Swipeable)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: DesignSystem.Spacing.md) {
                                ForEach(Array(marketData.enumerated()), id: \.offset) { index, market in
                                    DSMarketCard(market: market)
                                        .frame(width: 160, height: 100)
                                        .overlay(
                                            GeometryReader { geometry in
                                                Color.clear
                                                    .preference(
                                                        key: ViewOffsetKey.self,
                                                        value: ViewOffsetData(index: index, offset: geometry.frame(in: .named("scroll")).midX)
                                                    )
                                            }
                                        )
                                }
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                            .padding(.vertical, 10)
                        }
                        .coordinateSpace(name: "scroll")
                        .onPreferenceChange(ViewOffsetKey.self) { value in
                            let screenMidX = UIScreen.main.bounds.width / 2
                            if abs(value.offset - screenMidX) < 80 {
                                if currentMarketIndex != value.index {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentMarketIndex = value.index
                                    }
                                }
                            }
                        }
                        .frame(height: 130)
                        .padding(.top, DesignSystem.Spacing.xl)
                        
                        // Dynamic Market Summary
                        MarketSummaryView(currentIndex: $currentMarketIndex)
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                            .padding(.top, DesignSystem.Spacing.xl)
                        
                        // Market Movement Card
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                            Text("Marktbewegungen")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                            
                            DSCard(
                                backgroundColor: DesignSystem.Colors.cardBackground,
                                borderColor: DesignSystem.Colors.border,
                                cornerRadius: DesignSystem.CornerRadius.lg,
                                padding: DesignSystem.Spacing.lg,
                                hasShadow: true
                            ) {
                                VStack(spacing: DesignSystem.Spacing.md) {
                                    MarketMovementRow(
                                        title: "Gewinner des Tages",
                                        companyName: "Apple Inc.",
                                        change: "+2.34%",
                                        symbol: "AAPL",
                                        isPositive: true
                                    )
                                    
                                    DSSeparator()
                                    
                                    MarketMovementRow(
                                        title: "Verlierer des Tages",
                                        companyName: "Tesla Inc.",
                                        change: "-1.87%",
                                        symbol: "TSLA",
                                        isPositive: false
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.top, DesignSystem.Spacing.xl)
                        
                        // Top Securities Section
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                            Text("Top Wertpapiere")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                            
                            DSCard(
                                backgroundColor: DesignSystem.Colors.cardBackground,
                                borderColor: DesignSystem.Colors.border,
                                cornerRadius: DesignSystem.CornerRadius.lg,
                                padding: DesignSystem.Spacing.lg,
                                hasShadow: true
                            ) {
                                VStack(spacing: DesignSystem.Spacing.md) {
                                    ForEach(Array(securities.enumerated()), id: \.offset) { index, security in
                                        SecurityRow(security: security)
                                        
                                        if index < securities.count - 1 {
                                            DSSeparator()
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.top, DesignSystem.Spacing.xl)
                        .padding(.bottom, 100)
                    }
                }
                .background(DesignSystem.Colors.background)
            } else {
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.xl) {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                            Text(getCategoryTitle())
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                            
                            VStack(spacing: DesignSystem.Spacing.md) {
                                ForEach(getFilteredInstruments(), id: \.name) { instrument in
                                    MarketInstrumentRow(instrument: instrument)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    .padding(.top, DesignSystem.Spacing.xl)
                    .padding(.bottom, 100)
                }
                .background(DesignSystem.Colors.background)
            }
        }
    }
    
    private func getCategoryTitle() -> String {
        switch selectedCategory {
        case 0: return "Finanztermine"
        case 1: return "Marktübersicht"
        case 2: return "Weltweite Indizes"
        case 3: return "Top Aktien"
        case 4: return "Rohstoffe"
        case 5: return "Währungen"
        case 6: return "Kryptowährungen"
        default: return "Märkte"
        }
    }
    
    private func getFilteredInstruments() -> [MarketInstrument] {
        switch selectedCategory {
        case 0: return [] // Termine - no instruments
        case 1: return Array(instruments.prefix(6)) // Overview
        case 2: return Array(instruments.prefix(4)) // Indices
        case 3: return Array(instruments.dropFirst(4).prefix(3)) // Stocks
        case 4: return [instruments.last!] // Commodities (Gold)
        case 5: return [instruments.first!] // Forex (using DAX as placeholder)
        case 6: return Array(instruments.dropFirst(7).prefix(2)) // Crypto
        default: return instruments
        }
    }
}

struct MarketInstrumentRow: View {
    let instrument: MarketInstrument
    @State private var showingInstrument = false
    
    var body: some View {
        Button(action: {
            print("Tapped market instrument: \(instrument.name)")
            showingInstrument = true
        }) {
            DSCard(
                backgroundColor: DesignSystem.Colors.cardBackground,
                borderColor: DesignSystem.Colors.border,
                cornerRadius: DesignSystem.CornerRadius.lg,
                padding: DesignSystem.Spacing.lg,
                hasShadow: true
            ) {
                HStack {
                    // Stock logo
                    stockLogo(for: marketInstrumentNameToSymbol(instrument.name), size: 40)
                    
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        Text(instrument.name)
                            .font(DesignSystem.Typography.body1)
                            .foregroundColor(DesignSystem.Colors.onCard)
                            .fontWeight(.medium)
                        Text(instrument.value)
                            .font(DesignSystem.Typography.body2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                        Text(instrument.change)
                            .font(DesignSystem.Typography.body1)
                            .foregroundColor(instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                            .fontWeight(.semibold)
                        Image(systemName: instrument.isPositive ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 12))
                            .foregroundColor(instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingInstrument) {
            InstrumentView(instrument: convertMarketInstrumentToInstrumentData(from: instrument))
        }
    }
    
    private func convertMarketInstrumentToInstrumentData(from marketInstrument: MarketInstrument) -> InstrumentData {
        let price = Double(marketInstrument.value.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: "€", with: "").replacingOccurrences(of: ",", with: "")) ?? 1000.0
        let changeValue = Double(marketInstrument.change.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0.0
        
        // Convert market instrument name to symbol
        let symbol = marketInstrumentNameToSymbol(marketInstrument.name)
        
        return InstrumentData(
            symbol: symbol,
            name: marketInstrument.name,
            currentPrice: price,
            change: changeValue * price / 100,
            changePercent: changeValue,
            dayLow: price * 0.98,
            dayHigh: price * 1.02,
            volume: Int.random(in: 1_000_000...50_000_000),
            marketCap: generateMarketCapForInstrument(price: price, name: marketInstrument.name),
            pe: marketInstrument.name.contains("Inc.") || marketInstrument.name.contains("Corp.") ? Double.random(in: 15...35) : nil,
            chartData: InstrumentData.generateSampleChartData(isPositive: marketInstrument.isPositive),
            isPositive: marketInstrument.isPositive
        )
    }
    
    private func marketInstrumentNameToSymbol(_ name: String) -> String {
        switch name {
        case "Apple Inc.": return "AAPL"
        case "Microsoft Corp.": return "MSFT"
        case "NVIDIA Corp.": return "NVDA"
        case "Bitcoin": return "BTC"
        case "Ethereum": return "ETH"
        case "Gold": return "GLD"
        case "DAX": return "DAX"
        case "S&P 500": return "SPX"
        case "NASDAQ": return "IXIC"
        case "FTSE 100": return "UKX"
        default: return name.prefix(4).uppercased() + String(name.suffix(name.count - 4).prefix(0))
        }
    }
    
    private func generateMarketCapForInstrument(price: Double, name: String) -> String {
        if name.contains("Inc.") || name.contains("Corp.") {
            // Stock
            let marketCap = price * Double.random(in: 100_000_000...1_000_000_000)
            if marketCap >= 1_000_000_000 {
                return String(format: "%.1fB", marketCap / 1_000_000_000)
            } else {
                return String(format: "%.0fM", marketCap / 1_000_000)
            }
        } else {
            // Index or commodity
            let marketCap = price * Double.random(in: 1_000_000_000...10_000_000_000)
            return String(format: "%.1fT", marketCap / 1_000_000_000_000)
        }
    }
}

// Helper function to convert market instrument names to symbols
private func marketInstrumentNameToSymbol(_ name: String) -> String {
    switch name {
    case "Apple Inc.": return "AAPL"
    case "Microsoft Corp.": return "MSFT"
    case "NVIDIA Corp.": return "NVDA"
    case "Bitcoin": return "BTC"
    case "Ethereum": return "ETH"
    case "Gold": return "GLD"
    case "DAX": return "DAX"
    case "S&P 500": return "SPX"
    case "NASDAQ": return "IXIC"
    case "FTSE 100": return "UKX"
    default: return name.prefix(4).uppercased()
    }
}

// MARK: - Calendar View

struct CalendarView: View {
    // Sample calendar events
    @State private var calendarEvents: [CalendarEvent] = [
        // Today's events
        CalendarEvent(
            date: Date(),
            time: "09:00",
            type: .earnings,
            title: "Veröffentlichung Quartalsmitteilung (Stichtag Q1)",
            company: "HORNBACH HOLDING AG & CO KGAA",
            details: "Q1 2025 Earnings Report"
        ),
        CalendarEvent(
            date: Date(),
            time: "10:00",
            type: .meeting,
            title: "Hauptversammlung",
            company: "AROUNDTOWN SA",
            details: "Ordentliche Hauptversammlung 2025"
        ),
        CalendarEvent(
            date: Date(),
            time: "11:00",
            type: .meeting,
            title: "Hauptversammlung",
            company: "CANCOM SE",
            details: "Jahreshauptversammlung"
        ),
        CalendarEvent(
            date: Date(),
            time: "14:00",
            type: .meeting,
            title: "Hauptversammlung",
            company: "AD PEPPER MEDIA INTERNATIONAL NV",
            details: "Annual General Meeting"
        ),
        CalendarEvent(
            date: Date(),
            time: "15:00",
            type: .meeting,
            title: "Hauptversammlung",
            company: "PVA TEPLA AG",
            details: "Ordentliche Hauptversammlung"
        ),
        CalendarEvent(
            date: Date(),
            time: "16:00",
            type: .meeting,
            title: "Hauptversammlung",
            company: "FRANCOTYP-POSTALIA HOLDING AG",
            details: "Jahreshauptversammlung 2025"
        ),
        // Tomorrow's events
        CalendarEvent(
            date: Date().addingTimeInterval(86400),
            time: "08:00",
            type: .dividend,
            title: "Ex-Dividende",
            company: "BASF SE",
            details: "Dividende: €3.40 pro Aktie"
        ),
        CalendarEvent(
            date: Date().addingTimeInterval(86400),
            time: "09:00",
            type: .earnings,
            title: "Q2 2025 Earnings Call",
            company: "SAP SE",
            details: "Quarterly Results Presentation"
        ),
        // Next week events
        CalendarEvent(
            date: Date().addingTimeInterval(7 * 86400),
            time: "14:30",
            type: .economic,
            title: "US Arbeitsmarktdaten",
            company: "Bureau of Labor Statistics",
            details: "Non-Farm Payrolls, Unemployment Rate"
        ),
        CalendarEvent(
            date: Date().addingTimeInterval(7 * 86400),
            time: "15:00",
            type: .economic,
            title: "EZB Zinsentscheid",
            company: "Europäische Zentralbank",
            details: "Interest Rate Decision and Press Conference"
        ),
        // Holiday
        CalendarEvent(
            date: Date().addingTimeInterval(14 * 86400),
            time: "Ganztägig",
            type: .holiday,
            title: "US Börsen geschlossen",
            company: "Independence Day",
            details: "NYSE, NASDAQ geschlossen"
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Events List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(getGroupedEvents(), id: \.key) { dateGroup in
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            // Date Header
                            Text(formatDateHeader(dateGroup.key))
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                                .padding(.horizontal, DesignSystem.Spacing.lg)
                                .padding(.top, DesignSystem.Spacing.lg)
                            
                            // Events for this date
                            VStack(spacing: DesignSystem.Spacing.md) {
                                ForEach(dateGroup.value) { event in
                                    CalendarEventRow(event: event)
                                        .padding(.horizontal, DesignSystem.Spacing.lg)
                                }
                            }
                        }
                        
                        DSSeparator()
                            .padding(.top, DesignSystem.Spacing.lg)
                    }
                }
                .padding(.bottom, 100)
            }
            .background(DesignSystem.Colors.background)
        }
        .background(DesignSystem.Colors.background)
    }
    
    private func getFilteredEvents() -> [CalendarEvent] {
        return calendarEvents.sorted { $0.date < $1.date }
    }
    
    private func getGroupedEvents() -> [(key: Date, value: [CalendarEvent])] {
        let filtered = getFilteredEvents()
        let grouped = Dictionary(grouping: filtered) { event in
            Calendar.current.startOfDay(for: event.date)
        }
        return grouped.sorted { $0.key < $1.key }
    }
    
    private func formatDateHeader(_ date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        
        if calendar.isDateInToday(date) {
            return "Heute"
        } else if calendar.isDateInTomorrow(date) {
            return "Morgen"
        } else {
            formatter.dateFormat = "EEEE, d. MMMM"
            return formatter.string(from: date)
        }
    }
    
    private func getEventTypeColor(for type: String) -> Color {
        switch type {
        case "Earnings": return Color.blue
        case "Dividenden": return Color.green
        case "Hauptversammlungen": return Color.purple
        case "Wirtschaftsdaten": return Color.orange
        case "Feiertage": return Color.red
        default: return DesignSystem.Colors.secondary
        }
    }
}

// Calendar Event Model
struct CalendarEvent: Identifiable {
    let id = UUID()
    let date: Date
    let time: String
    let type: EventType
    let title: String
    let company: String
    let details: String
}

enum EventType {
    case earnings
    case dividend
    case meeting
    case economic
    case holiday
    
    var color: Color {
        switch self {
        case .earnings: return Color.blue
        case .dividend: return Color.green
        case .meeting: return Color.purple
        case .economic: return Color.orange
        case .holiday: return Color.red
        }
    }
    
    var icon: String {
        switch self {
        case .earnings: return "chart.line.uptrend.xyaxis"
        case .dividend: return "dollarsign.circle"
        case .meeting: return "person.3"
        case .economic: return "globe"
        case .holiday: return "calendar"
        }
    }
}

// Calendar Event Row
struct CalendarEventRow: View {
    let event: CalendarEvent
    
    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.md,
            hasShadow: true
        ) {
            HStack(spacing: DesignSystem.Spacing.md) {
                // Time
                VStack {
                    Text(event.time)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.medium)
                    
                    Circle()
                        .fill(event.type.color)
                        .frame(width: 8, height: 8)
                }
                .frame(width: 50)
                
                DSSeparator(orientation: .vertical)
                    .frame(height: 60)
                
                // Event Details
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(event.title)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Text(event.company)
                        .font(DesignSystem.Typography.body2)
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .lineLimit(1)
                    
                    if !event.details.isEmpty {
                        Text(event.details)
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondary.opacity(0.8))
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Event Type Icon
                Image(systemName: event.type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(event.type.color)
            }
        }
    }
}

// MARK: - Watchlist View

struct WatchlistView: View {
    @State private var selectedTab = 0
    @State private var watchlistItems: [WatchlistItem] = []
    @State private var showingAddStock = false
    @State private var newStockSymbol = ""
    @StateObject private var bookmarkService = BookmarkService()
    
    // Stock data for initialization
    let stockData: [String: (String, String, String, String, Bool)] = [
        "AAPL": ("Apple Inc.", "$182.52", "+2.24", "+1.23%", true),
        "MSFT": ("Microsoft Corp.", "$378.85", "+3.32", "+0.87%", true),
        "NVDA": ("NVIDIA Corp.", "$724.31", "+15.42", "+2.14%", true),
        "TSLA": ("Tesla Inc.", "$234.67", "-4.45", "-1.87%", false),
        "AMZN": ("Amazon.com Inc.", "$145.73", "-0.66", "-0.45%", false),
        "GOOGL": ("Alphabet Inc.", "$138.45", "+1.78", "+1.30%", true),
        "SAP": ("SAP SE", "€168.34", "+2.15", "+1.29%", true),
        "SIE": ("Siemens AG", "€178.92", "+1.23", "+0.69%", true),
        "VOW3": ("Volkswagen AG", "€112.45", "-2.34", "-2.04%", false),
        "BAS": ("BASF SE", "€45.67", "+0.89", "+1.99%", true),
        "ALV": ("Allianz SE", "€267.89", "+3.45", "+1.30%", true),
        "DBK": ("Deutsche Bank AG", "€13.45", "-0.23", "-1.68%", false)
    ]
    
    let watchlistNews = [
        WatchlistNewsItem(title: "Apple kündigt neue MacBook Pro Serie an", time: "vor 1 Stunde"),
        WatchlistNewsItem(title: "Tesla erweitert Produktionskapazitäten in Deutschland", time: "vor 2 Stunden"),
        WatchlistNewsItem(title: "Microsoft übernimmt KI-Startup für 2 Milliarden Dollar", time: "vor 3 Stunden"),
        WatchlistNewsItem(title: "NVIDIA profitiert von KI-Boom - Quartalszahlen übertreffen Erwartungen", time: "vor 4 Stunden")
    ]
    
    let scheduleItems = [
        ScheduleItem(title: "Apple Q4 Earnings", date: "28. Jan", time: "22:00", type: .earnings),
        ScheduleItem(title: "Tesla Ex-Dividend", date: "29. Jan", time: "09:00", type: .exDividend),
        ScheduleItem(title: "Microsoft Dividende", date: "30. Jan", time: "16:00", type: .dividend),
        ScheduleItem(title: "US Börsenfeiertag", date: "31. Jan", time: "Ganztägig", type: .holiday),
        ScheduleItem(title: "Inflationsdaten EU", date: "1. Feb", time: "11:00", type: .economicData),
        ScheduleItem(title: "Amazon Quartalszahlen", date: "2. Feb", time: "21:30", type: .earnings)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with FN Logo
            FNHeaderView()
            
            // Tab Navigation
            HStack(spacing: DesignSystem.Spacing.xl * 2) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = 0
                    }
                }) {
                    VStack(spacing: DesignSystem.Spacing.sm) {
                        Text("Aktien")
                            .font(.system(size: 15, weight: selectedTab == 0 ? .semibold : .medium))
                            .foregroundColor(selectedTab == 0 ? DesignSystem.Colors.onBackground : DesignSystem.Colors.secondary)
                        
                        RoundedRectangle(cornerRadius: 1)
                            .fill(selectedTab == 0 ? DesignSystem.Colors.primary : Color.clear)
                            .frame(height: 2)
                    }
                }
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = 1
                    }
                }) {
                    VStack(spacing: DesignSystem.Spacing.sm) {
                        Text("News")
                            .font(.system(size: 15, weight: selectedTab == 1 ? .semibold : .medium))
                            .foregroundColor(selectedTab == 1 ? DesignSystem.Colors.onBackground : DesignSystem.Colors.secondary)
                        
                        RoundedRectangle(cornerRadius: 1)
                            .fill(selectedTab == 1 ? DesignSystem.Colors.primary : Color.clear)
                            .frame(height: 2)
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.lg)
            .background(DesignSystem.Colors.surface)
            .overlay(
                DSSeparator(),
                alignment: .bottom
            )
            
            // Content based on selected tab
            if selectedTab == 0 {
                // Aktien Tab
                ScrollView {
                VStack(spacing: DesignSystem.Spacing.xl) {
                    // Watchlist Header with Add Button
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        HStack {
                            Text("Meine Watchlist")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                            
                            Spacer()
                            
                            Button(action: {
                                showingAddStock = true
                            }) {
                                HStack(spacing: DesignSystem.Spacing.xs) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .semibold))
                                    Text("HINZUFÜGEN")
                                        .font(.system(size: 12, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, DesignSystem.Spacing.md)
                                .padding(.vertical, DesignSystem.Spacing.sm)
                                .background(DesignSystem.Colors.primary)
                                .cornerRadius(DesignSystem.CornerRadius.sm)
                            }
                        }
                        
                        
                        // Watchlist Items
                        VStack(spacing: DesignSystem.Spacing.md) {
                            ForEach(watchlistItems, id: \.id) { item in
                                WatchlistItemRow(item: item, onRemove: {
                                    removeFromWatchlist(item)
                                })
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    .padding(.top, DesignSystem.Spacing.xl)
                    
                    // Watchlist News Section
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        Text("News zu deinen Wertpapieren")
                            .font(DesignSystem.Typography.title2)
                            .foregroundColor(DesignSystem.Colors.onBackground)
                        
                        DSCard(
                            backgroundColor: DesignSystem.Colors.cardBackground,
                            borderColor: DesignSystem.Colors.border,
                            cornerRadius: DesignSystem.CornerRadius.lg,
                            padding: DesignSystem.Spacing.lg,
                            hasShadow: true
                        ) {
                            VStack(spacing: DesignSystem.Spacing.md) {
                                ForEach(Array(watchlistNews.enumerated()), id: \.offset) { index, news in
                                    HStack {
                                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                            Text(news.title)
                                                .font(DesignSystem.Typography.body2)
                                                .foregroundColor(DesignSystem.Colors.onCard)
                                                .lineLimit(2)
                                                .fixedSize(horizontal: false, vertical: true)
                                            
                                            Text(news.time)
                                                .font(DesignSystem.Typography.caption2)
                                                .foregroundColor(DesignSystem.Colors.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12))
                                            .foregroundColor(DesignSystem.Colors.secondary)
                                    }
                                    
                                    if index < watchlistNews.count - 1 {
                                        DSSeparator()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    
                    // Schedule/Calendar Section in Watchlist
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        Text("Termine & Ereignisse")
                            .font(DesignSystem.Typography.title2)
                            .foregroundColor(DesignSystem.Colors.onBackground)
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: DesignSystem.Spacing.md) {
                                ForEach(scheduleItems, id: \.title) { item in
                                    DSCard(
                                        backgroundColor: DesignSystem.Colors.cardBackground,
                                        borderColor: DesignSystem.Colors.border,
                                        cornerRadius: DesignSystem.CornerRadius.lg,
                                        padding: DesignSystem.Spacing.md,
                                        hasShadow: true
                                    ) {
                                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                            HStack {
                                                Text(item.date)
                                                    .font(DesignSystem.Typography.caption2)
                                                    .foregroundColor(DesignSystem.Colors.secondary)
                                                
                                                Spacer()
                                                
                                                Text(item.time)
                                                    .font(DesignSystem.Typography.caption1)
                                                    .foregroundColor(DesignSystem.Colors.onCard)
                                                    .fontWeight(.semibold)
                                            }
                                            
                                            Spacer()
                                            
                                            Text(item.title)
                                                .font(DesignSystem.Typography.body2)
                                                .foregroundColor(DesignSystem.Colors.onCard)
                                                .fontWeight(.medium)
                                                .lineLimit(2)
                                                .fixedSize(horizontal: false, vertical: true)
                                            
                                            Text(item.type.displayName)
                                                .font(.system(size: 10))
                                                .foregroundColor(item.type.color.opacity(0.8))
                                                .fontWeight(.medium)
                                        }
                                    }
                                    .frame(width: 180, height: 100)
                                }
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                            .padding(.vertical, 10)
                        }
                    }
                    .padding(.top, DesignSystem.Spacing.xl)
                    .padding(.bottom, 10)
                }
                .padding(.bottom, 100)
            }
            .background(DesignSystem.Colors.background)
            } else {
                // News Tab - Saved Articles
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.xl) {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                            Text("Gespeicherte Artikel")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                            
                            if bookmarkService.bookmarkedArticleDetails.isEmpty {
                                DSCard(
                                    backgroundColor: DesignSystem.Colors.surface,
                                    borderColor: DesignSystem.Colors.border,
                                    cornerRadius: DesignSystem.CornerRadius.lg,
                                    padding: DesignSystem.Spacing.xl,
                                    hasShadow: false
                                ) {
                                    VStack(spacing: DesignSystem.Spacing.lg) {
                                        Image(systemName: "bookmark.slash")
                                            .font(.system(size: 48))
                                            .foregroundColor(DesignSystem.Colors.secondary.opacity(0.5))
                                        
                                        Text("Keine gespeicherten Artikel")
                                            .font(DesignSystem.Typography.body1)
                                            .foregroundColor(DesignSystem.Colors.secondary)
                                        
                                        Text("Speichere Artikel mit dem Lesezeichen-Symbol, um sie hier zu sehen")
                                            .font(DesignSystem.Typography.caption1)
                                            .foregroundColor(DesignSystem.Colors.tertiary)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, DesignSystem.Spacing.xl)
                                }
                            } else {
                                VStack(spacing: DesignSystem.Spacing.md) {
                                    ForEach(bookmarkService.bookmarkedArticleDetails, id: \.id) { article in
                                        DSCard(
                                            backgroundColor: DesignSystem.Colors.cardBackground,
                                            borderColor: DesignSystem.Colors.border,
                                            cornerRadius: DesignSystem.CornerRadius.lg,
                                            padding: DesignSystem.Spacing.lg,
                                            hasShadow: true
                                        ) {
                                            HStack {
                                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                                                    Text(article.title)
                                                        .font(DesignSystem.Typography.headline)
                                                        .foregroundColor(DesignSystem.Colors.onCard)
                                                        .lineLimit(2)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                    
                                                    HStack(spacing: DesignSystem.Spacing.md) {
                                                        Text(article.category)
                                                            .font(DesignSystem.Typography.caption2)
                                                            .foregroundColor(DesignSystem.Colors.primary)
                                                        
                                                        Text("•")
                                                            .font(DesignSystem.Typography.caption2)
                                                            .foregroundColor(DesignSystem.Colors.tertiary)
                                                        
                                                        Text(article.time)
                                                            .font(DesignSystem.Typography.caption2)
                                                            .foregroundColor(DesignSystem.Colors.secondary)
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(DesignSystem.Colors.secondary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.top, DesignSystem.Spacing.xl)
                    }
                    .padding(.bottom, 100)
                }
                .background(DesignSystem.Colors.background)
                .onAppear {
                    bookmarkService.loadArticleDetails()
                }
            }
        }
        .sheet(isPresented: $showingAddStock) {
            AddStockView(isPresented: $showingAddStock, onAdd: { symbol, name in
                addToWatchlist(symbol: symbol, name: name)
            })
        }
        .onAppear {
            loadInitialWatchlist()
        }
    }
    
    private func loadInitialWatchlist() {
        // Load from onboarding selection first
        if let savedSymbols = UserDefaults.standard.array(forKey: "initialWatchlist") as? [String],
           !savedSymbols.isEmpty && watchlistItems.isEmpty {
            for symbol in savedSymbols {
                if let data = stockData[symbol] {
                    let item = WatchlistItem(
                        symbol: symbol,
                        name: data.0,
                        price: data.1,
                        change: data.2,
                        changePercent: data.3,
                        isPositive: data.4
                    )
                    watchlistItems.append(item)
                }
            }
            // Clear the initial watchlist after loading to prevent reloading
            UserDefaults.standard.removeObject(forKey: "initialWatchlist")
        } else if watchlistItems.isEmpty {
            // Load default items if no onboarding selection
            watchlistItems = [
                WatchlistItem(symbol: "AAPL", name: "Apple Inc.", price: "$182.52", change: "+2.24", changePercent: "+1.23%", isPositive: true),
                WatchlistItem(symbol: "MSFT", name: "Microsoft Corp.", price: "$378.85", change: "+3.32", changePercent: "+0.87%", isPositive: true),
                WatchlistItem(symbol: "NVDA", name: "NVIDIA Corp.", price: "$724.31", change: "+15.42", changePercent: "+2.14%", isPositive: true)
            ]
        }
    }
    
    private func addToWatchlist(symbol: String, name: String) {
        // In a real app, you would fetch real data from an API
        let newItem = WatchlistItem(
            symbol: symbol,
            name: name,
            price: "$0.00",
            change: "+0.00",
            changePercent: "+0.00%",
            isPositive: true
        )
        watchlistItems.append(newItem)
    }
    
    private func removeFromWatchlist(_ item: WatchlistItem) {
        watchlistItems.removeAll { $0.id == item.id }
    }
}

// AddStockView and WatchlistItemRow have been moved to AddStockView.swift




// MARK: - News Detail View

struct NewsDetailView: View {
    let article: NewsArticle
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var bookmarkService = BookmarkService()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Title Image
                    if article.hasImage {
                        VStack(spacing: 0) {
                            // Image
                            ZStack {
                                // Gradient background simulating news image
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.1, green: 0.2, blue: 0.4),
                                        Color(red: 0.2, green: 0.3, blue: 0.5)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .frame(height: 200)
                                
                                // Overlay pattern
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(0..<8) { i in
                                        HStack(spacing: 8) {
                                            Rectangle()
                                                .fill(Color.blue.opacity(0.4))
                                                .frame(width: CGFloat.random(in: 60...180), height: 3)
                                            Rectangle()
                                                .fill(Color.cyan.opacity(0.4))
                                                .frame(width: CGFloat.random(in: 80...140), height: 3)
                                            Rectangle()
                                                .fill(Color.teal.opacity(0.4))
                                                .frame(width: CGFloat.random(in: 40...120), height: 3)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                                .padding(.vertical, 20)
                            }
                            .clipped()
                            
                            // Rating and reader count below image
                            HStack {
                                // Stars
                                HStack(spacing: 2) {
                                    ForEach(0..<Int(article.rating)) { _ in
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.orange)
                                    }
                                }
                                
                                Spacer()
                                
                                // Reader count
                                HStack(spacing: 4) {
                                    Image(systemName: "eye")
                                        .font(.system(size: 12))
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                    Text("\(article.readerCount) Leser")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                }
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                            .padding(.vertical, DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.surface)
                        }
                    }
                    
                    // Article Content
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        // Header info
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            // Title
                            Text(article.title)
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Meta info
                            HStack {
                                Text(article.category)
                                    .font(DesignSystem.Typography.caption1)
                                    .foregroundColor(DesignSystem.Colors.primary)
                                    .padding(.horizontal, DesignSystem.Spacing.md)
                                    .padding(.vertical, DesignSystem.Spacing.sm)
                                    .background(DesignSystem.Colors.primary.opacity(0.1))
                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text(article.source)
                                        .font(DesignSystem.Typography.caption1)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                    Text(article.time)
                                        .font(DesignSystem.Typography.caption2)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                }
                            }
                        }
                        
                        DSSeparator()
                        
                        // Article Body
                        Text(article.body)
                            .font(DesignSystem.Typography.body1)
                            .foregroundColor(DesignSystem.Colors.onBackground)
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Mentioned Instruments
                        if !article.mentionedInstruments.isEmpty {
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                                Text("Erwähnte Instrumente")
                                    .font(DesignSystem.Typography.title3)
                                    .foregroundColor(DesignSystem.Colors.onBackground)
                                
                                DSCard(
                                    backgroundColor: DesignSystem.Colors.cardBackground,
                                    borderColor: DesignSystem.Colors.border,
                                    cornerRadius: DesignSystem.CornerRadius.lg,
                                    padding: DesignSystem.Spacing.lg,
                                    hasShadow: true
                                ) {
                                    VStack(spacing: 0) {
                                        ForEach(Array(article.mentionedInstruments.enumerated()), id: \.offset) { index, instrument in
                                            NewsInstrumentRow(instrument: instrument)
                                            
                                            if index < article.mentionedInstruments.count - 1 {
                                                DSSeparator()
                                                    .padding(.vertical, DesignSystem.Spacing.md)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(DesignSystem.Spacing.lg)
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(DesignSystem.Colors.onBackground)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: DesignSystem.Spacing.md) {
                        Button(action: {
                            bookmarkService.toggleBookmark(article.id.uuidString)
                            if bookmarkService.isBookmarked(article.id.uuidString) {
                                bookmarkService.bookmarkArticle(article)
                            } else {
                                bookmarkService.removeBookmarkedArticle(article.id.uuidString)
                            }
                        }) {
                            Image(systemName: bookmarkService.isBookmarked(article.id.uuidString) ? "bookmark.fill" : "bookmark")
                                .foregroundColor(bookmarkService.isBookmarked(article.id.uuidString) ? DesignSystem.Colors.primary : DesignSystem.Colors.onBackground)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(DesignSystem.Colors.onBackground)
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NewsInstrumentRow: View {
    let instrument: NewsInstrument
    @State private var showingInstrument = false
    
    var body: some View {
        Button(action: {
            print("Tapped instrument: \(instrument.symbol)")
            showingInstrument = true
        }) {
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(instrument.symbol)
                        .font(DesignSystem.Typography.headline)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.bold)
                    Text(instrument.name)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                    Text(instrument.price)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.semibold)
                    Text(instrument.change)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(DesignSystem.Colors.secondary)
                    .padding(.leading, DesignSystem.Spacing.sm)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingInstrument) {
            InstrumentView(instrument: convertToInstrumentData(from: instrument))
        }
    }
    
    private func convertToInstrumentData(from newsInstrument: NewsInstrument) -> InstrumentData {
        let price = Double(newsInstrument.price.replacingOccurrences(of: "€", with: "").replacingOccurrences(of: " ", with: "")) ?? 100.0
        let changeValue = Double(newsInstrument.change.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0.0
        
        return InstrumentData(
            symbol: newsInstrument.symbol,
            name: newsInstrument.name,
            currentPrice: price,
            change: changeValue * price / 100,
            changePercent: changeValue,
            dayLow: price * 0.97,
            dayHigh: price * 1.03,
            volume: Int.random(in: 100_000...10_000_000),
            marketCap: generateMarketCap(price: price),
            pe: Double.random(in: 15...35),
            chartData: InstrumentData.generateSampleChartData(isPositive: newsInstrument.isPositive),
            isPositive: newsInstrument.isPositive
        )
    }
    
    private func generateMarketCap(price: Double) -> String {
        let marketCap = price * Double.random(in: 100_000_000...1_000_000_000)
        if marketCap >= 1_000_000_000 {
            return String(format: "%.1fB", marketCap / 1_000_000_000)
        } else {
            return String(format: "%.0fM", marketCap / 1_000_000)
        }
    }
}

// MARK: - Preview Provider

struct AllComponents_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview der kompletten App mit Bottom Navigation
            ContentView()
                .previewDisplayName("Complete App")
            
            // Preview nur der HomeView
            HomeView()
                .previewDisplayName("Home View")
            
            // Preview der News-Komponenten
            VStack(spacing: DesignSystem.Spacing.xl) {
                NewsCardLarge(
                    title: "Neue EU-Regulierung für Kryptowährungen tritt in Kraft",
                    category: "Politik",
                    time: "vor 2 Stunden"
                )
                
                DSCard(
                    backgroundColor: DesignSystem.Colors.cardBackground,
                    borderColor: DesignSystem.Colors.border,
                    cornerRadius: DesignSystem.CornerRadius.lg,
                    padding: DesignSystem.Spacing.lg,
                    hasShadow: true
                ) {
                    VStack(spacing: 0) {
                        NewsListItem(
                            title: "Tech-Aktien setzen Rallye fort - NVIDIA erreicht neues Allzeithoch",
                            category: "Technologie",
                            time: "vor 3 Stunden"
                        )
                        DSSeparator()
                        NewsListItem(
                            title: "Inflation in Deutschland sinkt auf 2,1 Prozent",
                            category: "Wirtschaft",
                            time: "vor 5 Stunden"
                        )
                    }
                }
            }
            .padding()
            .background(DesignSystem.Colors.background)
            .previewDisplayName("News Components")
        }
    }
}

// MARK: - Onboarding View

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    @State private var selectedInterests: Set<String> = []
    @State private var selectedStocks: Set<String> = []
    
    let interests = [
        "Aktien", "ETFs", "Krypto", "Rohstoffe", 
        "Devisen", "Anleihen", "Optionen", "Futures"
    ]
    
    let popularStocks = [
        ("Apple", "AAPL", "Tech-Gigant"),
        ("Microsoft", "MSFT", "Software & Cloud"),
        ("NVIDIA", "NVDA", "KI-Leader"),
        ("Tesla", "TSLA", "E-Mobilität"),
        ("Amazon", "AMZN", "E-Commerce"),
        ("Alphabet", "GOOGL", "Tech & Search"),
        ("SAP", "SAP", "Software"),
        ("Siemens", "SIE", "Industrie"),
        ("Volkswagen", "VOW3", "Automobil"),
        ("BASF", "BAS", "Chemie"),
        ("Allianz", "ALV", "Versicherung"),
        ("Deutsche Bank", "DBK", "Banking")
    ]
    
    var body: some View {
        ZStack {
            // Solid background
            Color.white
                .ignoresSafeArea()
            
            VStack {
                // Skip button
                HStack {
                    Spacer()
                    Button("Überspringen") {
                        completeOnboarding()
                    }
                    .foregroundColor(.gray)
                    .padding()
                }
                
                // Content
                TabView(selection: $currentPage) {
                    // Welcome page
                    WelcomePageView()
                        .tag(0)
                    
                    // Interests selection page
                    InterestsSelectionView(selectedInterests: $selectedInterests, interests: interests)
                        .tag(1)
                    
                    // Stocks selection page
                    StocksSelectionView(selectedStocks: $selectedStocks, stocks: popularStocks)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Custom page indicator and buttons
                VStack(spacing: 20) {
                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.red : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }) {
                                Text("Zurück")
                                    .fontWeight(.medium)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                            }
                        }
                        
                        Button(action: {
                            if currentPage < 2 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                savePreferencesAndComplete()
                            }
                        }) {
                            Text(getButtonText())
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(getButtonColor())
                                .cornerRadius(12)
                        }
                        .disabled(currentPage == 1 && selectedInterests.isEmpty)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    private func getButtonText() -> String {
        switch currentPage {
        case 0: return "Los geht's"
        case 1: return selectedInterests.isEmpty ? "Wähle mindestens ein Interesse" : "Weiter"
        case 2: return "Fertig"
        default: return "Weiter"
        }
    }
    
    private func getButtonColor() -> Color {
        if currentPage == 1 && selectedInterests.isEmpty {
            return Color.gray
        }
        return Color.red
    }
    
    private func savePreferencesAndComplete() {
        // Save interests
        UserDefaults.standard.set(Array(selectedInterests), forKey: "userInterests")
        
        // Save selected stocks to watchlist
        UserDefaults.standard.set(Array(selectedStocks), forKey: "initialWatchlist")
        
        completeOnboarding()
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        withAnimation {
            showOnboarding = false
        }
    }
}

struct WelcomePageView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // FN Logo
            FNLogoView(size: 80)
                .padding(.bottom, 20)
            
            Text("Willkommen bei\nFinanznachrichten")
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Text("Deine persönliche Finanz-App für\naktuelle Nachrichten und Marktdaten")
                .font(.system(size: 18))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
}

struct InterestsSelectionView: View {
    @Binding var selectedInterests: Set<String>
    let interests: [String]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Was interessiert dich?")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top, 40)
            
            Text("Wähle deine Interessensgebiete aus")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(interests, id: \.self) { interest in
                    InterestButton(
                        title: interest,
                        isSelected: selectedInterests.contains(interest),
                        action: {
                            if selectedInterests.contains(interest) {
                                selectedInterests.remove(interest)
                            } else {
                                selectedInterests.insert(interest)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

struct InterestButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isSelected ? Color.red : Color.gray.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.red : Color.clear, lineWidth: 2)
                )
        }
    }
}

struct StocksSelectionView: View {
    @Binding var selectedStocks: Set<String>
    let stocks: [(String, String, String)]
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Erste Werte für deine Watchlist")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("Wähle beliebte Aktien aus oder überspringe diesen Schritt")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(stocks, id: \.1) { stock in
                        StockSelectionRow(
                            name: stock.0,
                            symbol: stock.1,
                            category: stock.2,
                            isSelected: selectedStocks.contains(stock.1),
                            action: {
                                if selectedStocks.contains(stock.1) {
                                    selectedStocks.remove(stock.1)
                                } else {
                                    selectedStocks.insert(stock.1)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

struct StockSelectionRow: View {
    let name: String
    let symbol: String
    let category: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(symbol)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    Text(name)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(category)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .red : .gray)
            }
            .padding(16)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.red : Color.clear, lineWidth: 2)
            )
        }
    }
}
