//
//  NewsComponents.swift
//  FinanzNachrichten
//
//  News-bezogene UI-Komponenten für Artikel und News-Items
//  Verschiedene Card-Styles: Netflix-Style, Compact, Large, mit Rating, etc.
//

import SwiftUI

// MARK: - Netflix Style News Card

/// Netflix-inspired news card with image and metadata
/// Displays news article with large visual layout
struct NetflixStyleNewsCard: View {
    let title: String
    let category: String
    let time: String
    let hasImage: Bool
    @State private var showingDetail = false
    
    private var sampleArticle: NewsArticle {
        NewsArticle(
            title: title,
            category: category,
            time: time,
            source: "FinanzNachrichten.de",
            hasImage: hasImage,
            body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
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
                padding: 0,
                hasShadow: true
            ) {
                VStack(spacing: 0) {
                    // Image placeholder
                    if hasImage {
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                            .fill(DesignSystem.Colors.secondary.opacity(0.1))
                            .frame(height: 140)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(DesignSystem.Colors.secondary.opacity(0.3))
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        // Category and time
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
                        }
                        
                        // Title
                        Text(title)
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(DesignSystem.Colors.onCard)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(DesignSystem.Spacing.lg)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingDetail) {
            NewsDetailView(article: sampleArticle)
        }
    }
}

// MARK: - News Card Compact

/// Compact news card without large image
/// Used for dense news listings
struct NewsCardCompact: View {
    let title: String
    let category: String
    let time: String
    let articleId: String
    @State private var showingDetail = false
    @EnvironmentObject var bookmarkService: BookmarkService
    
    private var sampleArticle: NewsArticle {
        NewsArticle(
            title: title,
            category: category,
            time: time,
            source: "FinanzNachrichten.de",
            hasImage: false,
            body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
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
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
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

                        // Bookmark button
                        Button(action: {
                            let wasBookmarked = bookmarkService.isBookmarked(articleId)
                            bookmarkService.toggleBookmark(articleId)

                            // Post notification when bookmark is added
                            if !wasBookmarked {
                                NotificationCenter.default.post(name: .bookmarkAdded, object: nil)
                            }

                            // Haptic feedback
                            if bookmarkService.isBookmarked(articleId) {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            } else {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }
                        }) {
                            Image(systemName: bookmarkService.isBookmarked(articleId) ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(bookmarkService.isBookmarked(articleId) ? DesignSystem.Colors.primary : DesignSystem.Colors.secondary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            NewsDetailView(article: sampleArticle)
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.9)])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - News Card Large

/// Large news card with prominent image and detailed content
/// Used for featured or important news articles
struct NewsCardLarge: View {
    let title: String
    let category: String
    let time: String
    let articleId: String
    let hasImage: Bool = true
    @State private var showingDetail = false
    @EnvironmentObject var bookmarkService: BookmarkService
    
    private var sampleArticle: NewsArticle {
        NewsArticle(
            title: title,
            category: category,
            time: time,
            source: "FinanzNachrichten.de",
            hasImage: hasImage,
            body: "Die Märkte zeigen sich heute überwiegend freundlich. Der DAX konnte im frühen Handel die psychologisch wichtige Marke von 19.500 Punkten überschreiten und notiert aktuell bei 19.523 Punkten, was einem Plus von 0,78% entspricht.\n\nBesonders stark zeigen sich heute die Technologiewerte. Apple und Microsoft konnten beide über 1% zulegen, während NVIDIA sogar um 2,14% steigt. Die positive Stimmung wird durch robuste Quartalszahlen und optimistische Prognosen der Analysten gestützt.\n\n\"Die aktuellen Marktbedingungen sind äußerst günstig für Wachstumswerte\", erklärt Chefanalyst Thomas Müller von der Deutschen Bank. \"Wir sehen derzeit eine klassische Risk-on Stimmung, die vor allem den Technologiesektor beflügelt.\"\n\nAuch die europäischen Märkte profitieren von der positiven Stimmung. Der EuroStoxx 50 notiert 0,65% im Plus, während der französische CAC 40 um 0,82% zulegt. Lediglich der britische FTSE 100 zeigt sich mit einem kleinen Plus von 0,12% etwas zurückhaltender.\n\nFür die kommenden Tage erwarten Analysten eine Fortsetzung des positiven Trends, sofern keine unerwarteten geopolitischen Ereignisse eintreten. Besonders im Fokus stehen die anstehenden Quartalszahlen von Tesla und Meta, die weitere Impulse für den Technologiesektor liefern könnten.",
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

                        // Bookmark button
                        Button(action: {
                            let wasBookmarked = bookmarkService.isBookmarked(articleId)
                            bookmarkService.toggleBookmark(articleId)

                            // Post notification when bookmark is added
                            if !wasBookmarked {
                                NotificationCenter.default.post(name: .bookmarkAdded, object: nil)
                            }

                            // Haptic feedback
                            if bookmarkService.isBookmarked(articleId) {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            } else {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }
                        }) {
                            Image(systemName: bookmarkService.isBookmarked(articleId) ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(bookmarkService.isBookmarked(articleId) ? DesignSystem.Colors.primary : DesignSystem.Colors.secondary)
                        }
                        .buttonStyle(PlainButtonStyle())
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
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.9)])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Chart Visualization

struct ChartVisualization: View {
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let isPositive = Bool.random()
            
            // Generate random chart data
            let points = generateChartPoints(width: width, height: height, isPositive: isPositive)
            
            ZStack {
                // Grid lines
                VStack(spacing: height / 4) {
                    ForEach(0..<5) { _ in
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 1)
                    }
                }
                
                // Chart line
                Path { path in
                    path.move(to: points[0])
                    for i in 1..<points.count {
                        path.addLine(to: points[i])
                    }
                }
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            isPositive ? Color.green : Color.red,
                            isPositive ? Color.green.opacity(0.6) : Color.red.opacity(0.6)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
                
                // Fill area under the line
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height))
                    path.addLine(to: points[0])
                    for i in 1..<points.count {
                        path.addLine(to: points[i])
                    }
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            isPositive ? Color.green.opacity(0.3) : Color.red.opacity(0.3),
                            isPositive ? Color.green.opacity(0.1) : Color.red.opacity(0.1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
    }
    
    private func generateChartPoints(width: CGFloat, height: CGFloat, isPositive: Bool) -> [CGPoint] {
        var points: [CGPoint] = []
        let segments = 20
        let segmentWidth = width / CGFloat(segments)
        
        var currentY = height * 0.7
        let trend = isPositive ? -1.5 : 1.5
        
        for i in 0...segments {
            let x = CGFloat(i) * segmentWidth
            currentY += CGFloat.random(in: -10...10) + trend
            currentY = max(20, min(height - 20, currentY))
            points.append(CGPoint(x: x, y: currentY))
        }
        
        return points
    }
}

// MARK: - News Card Large With Rating

struct NewsCardLargeWithRating: View {
    let title: String
    let category: String
    let time: String
    let rating: Double
    let readerCount: Int
    let hasImage: Bool
    var showChart: Bool = false
    @State private var showingDetail = false
    
    private var sampleArticle: NewsArticle {
        NewsArticle(
            title: title,
            category: category,
            time: time,
            source: "FinanzNachrichten.de",
            hasImage: hasImage,
            body: "Die Märkte zeigen sich heute überwiegend freundlich. Der DAX konnte im frühen Handel die psychologisch wichtige Marke von 19.500 Punkten überschreiten und notiert aktuell bei 19.523 Punkten, was einem Plus von 0,78% entspricht.\n\nBesonders stark zeigen sich heute die Technologiewerte. Apple und Microsoft konnten beide über 1% zulegen, während NVIDIA sogar um 2,14% steigt. Die positive Stimmung wird durch robuste Quartalszahlen und optimistische Prognosen der Analysten gestützt.\n\n\"Die aktuellen Marktbedingungen sind äußerst günstig für Wachstumswerte\", erklärt Chefanalyst Thomas Müller von der Deutschen Bank. \"Wir sehen derzeit eine klassische Risk-on Stimmung, die vor allem den Technologiesektor beflügelt.\"\n\nAuch die europäischen Märkte profitieren von der positiven Stimmung. Der EuroStoxx 50 notiert 0,65% im Plus, während der französische CAC 40 um 0,82% zulegt. Lediglich der britische FTSE 100 zeigt sich mit einem kleinen Plus von 0,12% etwas zurückhaltender.\n\nFür die kommenden Tage erwarten Analysten eine Fortsetzung des positiven Trends, sofern keine unerwarteten geopolitischen Ereignisse eintreten. Besonders im Fokus stehen die anstehenden Quartalszahlen von Tesla und Meta, die weitere Impulse für den Technologiesektor liefern könnten.",
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
                        
                        // Show chart or code overlay based on showChart parameter
                        if showChart {
                            // Chart visualization for financial content
                            ChartVisualization()
                                .padding(20)
                        } else {
                            // Code-like overlay for tech content
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
                        
                        // Rating overlay
                        VStack {
                            HStack {
                                Spacer()
                                
                                HStack(spacing: DesignSystem.Spacing.xs) {
                                    HStack(spacing: 2) {
                                        ForEach(0..<Int(rating), id: \.self) { _ in
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 10))
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                    
                                    Text("\(String(format: "%.1f", rating))")
                                        .font(DesignSystem.Typography.caption2)
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                    
                                    Text("•")
                                        .font(DesignSystem.Typography.caption2)
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                    HStack(spacing: 2) {
                                        Image(systemName: "eye.fill")
                                            .font(.system(size: 10))
                                            .foregroundColor(.white.opacity(0.8))
                                        Text("\(readerCount)")
                                            .font(DesignSystem.Typography.caption2)
                                            .foregroundColor(.white)
                                            .fontWeight(.medium)
                                    }
                                }
                                .padding(.horizontal, DesignSystem.Spacing.sm)
                                .padding(.vertical, DesignSystem.Spacing.xs)
                                .background(Color.black.opacity(0.5))
                                .cornerRadius(DesignSystem.CornerRadius.sm)
                                .padding(DesignSystem.Spacing.md)
                            }
                            Spacer()
                        }
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
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.9)])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - News List Item

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
            body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            mentionedInstruments: []
        )
    }
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    Text(title)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onBackground)
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
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.tertiary)
            }
            .padding(.vertical, DesignSystem.Spacing.md)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            NewsDetailView(article: sampleArticle)
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.9)])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - News Detail View

/// Full-screen news article detail view
/// Shows complete article with image, metadata, and mentioned instruments
struct NewsDetailView: View {
    let article: NewsArticle
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var bookmarkService: BookmarkService
    @State private var dragAmount = CGSize.zero
    
    // Store random values to prevent regeneration on state changes
    private let rectangleWidths: [[CGFloat]] = {
        var widths: [[CGFloat]] = []
        for _ in 0..<8 {
            widths.append([
                CGFloat.random(in: 60...180),
                CGFloat.random(in: 80...140),
                CGFloat.random(in: 40...120)
            ])
        }
        return widths
    }()
    
    var body: some View {
        GeometryReader { geometry in
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
                                
                                // Overlay pattern with responsive widths
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(0..<8) { i in
                                        HStack(spacing: 8) {
                                            Rectangle()
                                                .fill(Color.blue.opacity(0.4))
                                                .frame(width: min(rectangleWidths[i][0], geometry.size.width * 0.3), height: 3)
                                            Rectangle()
                                                .fill(Color.cyan.opacity(0.4))
                                                .frame(width: min(rectangleWidths[i][1], geometry.size.width * 0.25), height: 3)
                                            Rectangle()
                                                .fill(Color.teal.opacity(0.4))
                                                .frame(width: min(rectangleWidths[i][2], geometry.size.width * 0.2), height: 3)
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
                                    ForEach(0..<5) { index in
                                        Image(systemName: index < Int(article.rating) ? "star.fill" : "star")
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
                    
                    // Article Content with max width
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        // Header info
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            // Title
                            Text(article.title)
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
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
                    .frame(maxWidth: min(geometry.size.width - 32, 600)) // Limit max width to prevent overflow
                    .frame(maxWidth: .infinity) // Center the content
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(DesignSystem.Colors.onBackground)
                            .font(.system(size: 16, weight: .medium))
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
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            withAnimation(.easeOut(duration: 0.2)) {
                                dragAmount = .zero
                            }
                        }
                    }
            )
        }
        }
    }
}

// MARK: - News Instrument Row

/// Row component for displaying financial instruments mentioned in news articles
/// Tappable to view full instrument details
struct NewsInstrumentRow: View {
    let instrument: NewsInstrument
    @State private var showingInstrument = false

    var body: some View {
        Button(action: {
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
            // Nutze DataMapper für Type-Conversion
            InstrumentView(instrument: DataMapper.toInstrumentData(from: instrument))
        }
    }
}

// MARK: - Mini Chart View
struct MiniChartView: View {
    let isPositive: Bool
    
    var body: some View {
        ChartVisualization()
    }
}

// MARK: - Video Card
struct VideoCard: View {
    let title: String
    let channel: String
    let duration: String
    let viewCount: String
    let thumbnailType: ThumbnailType
    
    enum ThumbnailType {
        case marketAnalysis
        case interview
        case news
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
                // Video Thumbnail
                ZStack {
                    // Background based on type
                    switch thumbnailType {
                    case .marketAnalysis:
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.1, green: 0.2, blue: 0.3),
                                Color(red: 0.2, green: 0.3, blue: 0.4)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        // Chart overlay for market analysis
                        ChartVisualization()
                            .opacity(0.6)
                            .padding(20)
                        
                    case .interview:
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.2, green: 0.1, blue: 0.3),
                                Color(red: 0.3, green: 0.2, blue: 0.4)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        // Profile silhouettes for interview
                        HStack(spacing: -20) {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 60, height: 60)
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 60, height: 60)
                        }
                        
                    case .news:
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.15, green: 0.15, blue: 0.25),
                                Color(red: 0.25, green: 0.25, blue: 0.35)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        // News ticker style overlay
                        VStack(spacing: 8) {
                            ForEach(0..<3) { _ in
                                HStack(spacing: 8) {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.3))
                                        .frame(width: CGFloat.random(in: 80...150), height: 4)
                                    Rectangle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: CGFloat.random(in: 60...120), height: 4)
                                    Spacer()
                                }
                            }
                        }
                        .padding(20)
                    }
                    
                    // Play button overlay
                    Circle()
                        .fill(Color.black.opacity(0.7))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .offset(x: 3) // Slight offset to center play icon visually
                        )
                    
                    // Duration badge
                    VStack {
                        HStack {
                            Spacer()
                            Text(duration)
                                .font(DesignSystem.Typography.caption2)
                                .foregroundColor(.white)
                                .padding(.horizontal, DesignSystem.Spacing.sm)
                                .padding(.vertical, DesignSystem.Spacing.xs)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(DesignSystem.CornerRadius.sm)
                                .padding(DesignSystem.Spacing.sm)
                        }
                        Spacer()
                    }
                }
                .frame(height: 180)
                .clipped()
                
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    Text(title)
                        .font(DesignSystem.Typography.headline)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "play.rectangle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(DesignSystem.Colors.primary)
                            
                            Text(channel)
                                .font(DesignSystem.Typography.caption1)
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                        
                        Text("•")
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.tertiary)
                        
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "eye")
                                .font(.system(size: 12))
                                .foregroundColor(DesignSystem.Colors.secondary)
                            
                            Text(viewCount)
                                .font(DesignSystem.Typography.caption1)
                                .foregroundColor(DesignSystem.Colors.secondary)
                        }
                        
                        Spacer()
                    }
                }
                .padding(DesignSystem.Spacing.lg)
            }
        }
        .shadow(color: DesignSystem.Colors.shadowMedium, radius: 15, x: 0, y: 6)
    }
}

// MARK: - Podcast Card
struct PodcastCard: View {
    let title: String
    let podcast: String
    let episode: String
    let duration: String
    let releaseDate: String
    let isPlaying: Bool = false
    
    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            HStack(spacing: DesignSystem.Spacing.lg) {
                // Podcast Cover Art
                ZStack {
                    // Gradient background for podcast cover
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.4, green: 0.2, blue: 0.6),
                            Color(red: 0.6, green: 0.3, blue: 0.8)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: 80, height: 80)
                    .cornerRadius(DesignSystem.CornerRadius.md)
                    
                    // Waveform visualization
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.white.opacity(0.8))
                                .frame(width: 3, height: CGFloat.random(in: 20...40))
                                .animation(
                                    isPlaying ? Animation.easeInOut(duration: 0.5)
                                        .repeatForever()
                                        .delay(Double(index) * 0.1) : .default,
                                    value: isPlaying
                                )
                        }
                    }
                    
                    // Play/Pause indicator
                    if isPlaying {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                    }
                }
                
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(title)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(podcast)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    Text("Folge \(episode)")
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.secondary)
                    
                    HStack {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "clock")
                                .font(.system(size: 10))
                            Text(duration)
                        }
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.tertiary)
                        
                        Text("•")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.tertiary)
                        
                        Text(releaseDate)
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.tertiary)
                    }
                }
                
                Spacer()
                
                // Play button
                Button(action: {}) {
                    Circle()
                        .fill(DesignSystem.Colors.primary)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .offset(x: 2)
                        )
                }
            }
        }
        .shadow(color: DesignSystem.Colors.shadowMedium, radius: 12, x: 0, y: 4)
    }
}

// MARK: - Netflix Style Hero Card

struct NetflixHeroCard: View {
    let newsItem: NetflixNewsItem
    @State private var showingDetail = false

    var body: some View {
        Button(action: { showingDetail = true }) {
            VStack(spacing: 0) {
                // Large Image
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 200)

                    // Watchlist Badge
                    if newsItem.isWatchlistRelated {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                            Text("Watchlist")
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(DesignSystem.Colors.primary)
                        .cornerRadius(6)
                        .padding(12)
                    }
                }

                // Content
                VStack(alignment: .leading, spacing: 12) {
                    Text(newsItem.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)

                    HStack {
                        Text(newsItem.source)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.primary)

                        Spacer()

                        // Rating
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(newsItem.rating) ? "star.fill" : "star")
                                    .font(.system(size: 10))
                                    .foregroundColor(.orange)
                            }
                        }

                        Text("•")
                            .font(.system(size: 12))
                            .foregroundColor(DesignSystem.Colors.tertiary)

                        Text("\(newsItem.readerCount) Leser")
                            .font(.system(size: 12))
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }

                    Text(newsItem.time)
                        .font(.system(size: 11))
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
                .padding(16)
            }
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(12)
            .shadow(color: DesignSystem.Shadows.card, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: UIScreen.main.bounds.width - 32)
    }
}

// MARK: - Netflix Style Compact Card

struct NetflixCompactCard: View {
    let newsItem: NetflixNewsItem
    @State private var showingDetail = false

    var body: some View {
        Button(action: { showingDetail = true }) {
            VStack(spacing: 0) {
                // Small Image
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.cyan.opacity(0.5), Color.blue.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 100)

                    // Watchlist Badge
                    if newsItem.isWatchlistRelated {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(DesignSystem.Colors.primary)
                            .clipShape(Circle())
                            .padding(8)
                    }
                }

                // Content
                VStack(alignment: .leading, spacing: 8) {
                    Text(newsItem.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text(newsItem.source)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.primary)

                    HStack(spacing: 4) {
                        HStack(spacing: 1) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(newsItem.rating) ? "star.fill" : "star")
                                    .font(.system(size: 8))
                                    .foregroundColor(.orange)
                            }
                        }

                        Text("•")
                            .font(.system(size: 10))
                            .foregroundColor(DesignSystem.Colors.tertiary)

                        Text(newsItem.time)
                            .font(.system(size: 10))
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                }
                .padding(12)
            }
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(10)
            .shadow(color: DesignSystem.Shadows.card, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 180)
    }
}

// MARK: - Analysis News Card

struct AnalysisNewsCard: View {
    let analysis: AnalysisNewsItem
    @State private var showingDetail = false

    var body: some View {
        Button(action: { showingDetail = true }) {
            VStack(spacing: 0) {
                // Chart Visualization
                ZStack(alignment: .topTrailing) {
                    GeometryReader { geometry in
                        let width = geometry.size.width
                        let height = geometry.size.height

                        // Generate chart data based on category
                        let points = generateChartPoints(
                            width: width,
                            height: height,
                            isPositive: analysis.potentialPercent > 0
                        )

                        ZStack {
                            // Background gradient
                            LinearGradient(
                                colors: [
                                    analysis.category.color.opacity(0.2),
                                    analysis.category.color.opacity(0.05)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )

                            // Chart line
                            Path { path in
                                guard !points.isEmpty else { return }
                                path.move(to: points[0])
                                for i in 1..<points.count {
                                    path.addLine(to: points[i])
                                }
                            }
                            .stroke(analysis.category.color, lineWidth: 2)

                            // Fill area under line
                            Path { path in
                                guard !points.isEmpty else { return }
                                path.move(to: CGPoint(x: 0, y: height))
                                path.addLine(to: points[0])
                                for i in 1..<points.count {
                                    path.addLine(to: points[i])
                                }
                                path.addLine(to: CGPoint(x: width, y: height))
                                path.closeSubpath()
                            }
                            .fill(
                                LinearGradient(
                                    colors: [
                                        analysis.category.color.opacity(0.3),
                                        analysis.category.color.opacity(0.1)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                    }
                    .frame(height: 100)

                    // Watchlist Badge
                    if analysis.isWatchlistRelated {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(DesignSystem.Colors.primary)
                            .clipShape(Circle())
                            .padding(8)
                    }
                }
                .frame(height: 100)

                // Content
                VStack(alignment: .leading, spacing: 8) {
                    Text(analysis.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text(analysis.analyst)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.primary)

                    HStack(spacing: 4) {
                        // Rating stars
                        HStack(spacing: 1) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(analysis.rating) ? "star.fill" : "star")
                                    .font(.system(size: 8))
                                    .foregroundColor(.orange)
                            }
                        }

                        Text("•")
                            .font(.system(size: 10))
                            .foregroundColor(DesignSystem.Colors.tertiary)

                        Text(analysis.time)
                            .font(.system(size: 10))
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                }
                .padding(12)
            }
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(10)
            .shadow(color: DesignSystem.Shadows.card, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 180)
    }

    private func generateChartPoints(width: CGFloat, height: CGFloat, isPositive: Bool) -> [CGPoint] {
        var points: [CGPoint] = []
        let segments = 15
        let segmentWidth = width / CGFloat(segments)

        var currentY = height * 0.6
        let trend = isPositive ? -1.2 : 1.2

        for i in 0...segments {
            let x = CGFloat(i) * segmentWidth
            currentY += CGFloat.random(in: -8...8) + trend
            currentY = max(15, min(height - 15, currentY))
            points.append(CGPoint(x: x, y: currentY))
        }

        return points
    }
}

// MARK: - Section Header

struct NewsSectionHeader: View {
    let title: String
    let icon: String
    let onSeeAll: () -> Void

    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.primary)

                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.onBackground)
            }

            Spacer()

            Button(action: onSeeAll) {
                HStack(spacing: 4) {
                    Text("Alle anzeigen")
                        .font(.system(size: 13, weight: .medium))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(DesignSystem.Colors.primary)
            }
        }
        .padding(.horizontal, 16)
    }
}