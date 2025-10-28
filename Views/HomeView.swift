//
//  HomeView.swift
//  FinanzNachrichten
//
//  Hauptansicht der App - Dashboard mit Top-Performern, Terminen und News
//  Zeigt personalisierte Inhalte basierend auf User-Watchlist und Interessen
//

import SwiftUI

/// Main dashboard view showing market overview, top performers, schedule, and personalized news
/// Combines data from user's watchlist with curated financial content
struct HomeView: View {

    // MARK: - Environment Objects

    @EnvironmentObject var bookmarkService: BookmarkService
    @EnvironmentObject var notificationService: NotificationService
    @EnvironmentObject var watchlistService: WatchlistService

    // MARK: - State Properties

    @State private var currentMarketIndex = 0
    @State private var scrollOffset: CGFloat = 0

    // MARK: - Mock Data Service

    private let mockData = MockDataService.shared

    // MARK: - Computed Properties

    /// Returns top performing stocks from active watchlist with fallback to mock data
    /// Ensures at least 5 items are shown for better UX
    var topPerformers: [WatchlistItem] {
        guard let activeWatchlist = watchlistService.activeWatchlist else {
            // Keine aktive Watchlist - zeige Mock-Daten als Fallback
            return mockData.getTopPerformers()
        }

        let performers = activeWatchlist.topPerformers

        // Falls Watchlist weniger als 5 Items hat, fülle mit Mock-Daten auf
        // So sieht die UI immer "voll" aus und User bekommt Inspiration
        if performers.count < 5 {
            let remaining = 5 - performers.count
            return performers + mockData.getTopPerformers().prefix(remaining)
        }

        return performers
    }

    /// Market overview data (indices, commodities, forex, crypto)
    private var marketData: [MarketCard] {
        mockData.getMarketData()
    }

    /// Popular securities for quick access
    private var securities: [Security] {
        mockData.getSecurities()
    }

    /// Editorial/featured news items
    private var editorialNews: [EditorialNewsItem] {
        mockData.getEditorialNews()
    }

    /// Watchlist-related news items
    private var watchlistNews: [WatchlistNewsItem] {
        mockData.getWatchlistNews()
    }

    /// Upcoming schedule items (earnings, dividends, holidays)
    private var scheduleItems: [ScheduleItem] {
        mockData.getScheduleItems()
    }

    /// Additional news for main feed
    private var additionalNews: [AdditionalNewsItem] {
        mockData.getAdditionalNews()
    }

    // MARK: - Helper Functions

    /// Returns sample news title for infinite scroll
    /// - Parameter index: Index for cyclic title selection
    private func getSampleNewsTitle(_ index: Int) -> String {
        mockData.getNewsTitle(for: index)
    }

    /// Returns sample news category
    /// - Parameter index: Index for cyclic category selection
    private func getSampleCategory(_ index: Int) -> String {
        mockData.getNewsCategory(for: index)
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header with FN Logo
                FNHeaderView()
                
                // Top Performers from Watchlist
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                    Text("Deine Top Performer heute")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
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
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                        .padding(.vertical, DesignSystem.Spacing.sm)
                    }
                    .scrollClipDisabled()
                }
                .padding(.top, DesignSystem.Spacing.lg)
                .padding(.bottom, DesignSystem.Spacing.lg)
                .zIndex(1)
                
                // Schedule/Calendar Section
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                    Text("Wichtige Termine diese Woche")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DesignSystem.Spacing.Cards.gap) {
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
                                            .font(DesignSystem.Typography.caption1)
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
                                .frame(width: 150, height: 80)
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                        .padding(.vertical, DesignSystem.Spacing.sm)
                    }
                    .scrollClipDisabled()
                }
                .padding(.bottom, DesignSystem.Spacing.lg)
                
                // Andere Leser interessieren sich für Section
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                    Text("Für dich")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DesignSystem.Spacing.Cards.gap) {
                            ForEach(Array(getPopularNews().enumerated()), id: \.offset) { index, news in
                                NewsCardLargeWithRating(
                                    title: news.title,
                                    category: news.category,
                                    time: news.time,
                                    rating: news.rating,
                                    readerCount: news.readerCount,
                                    hasImage: true,
                                    showChart: shouldShowChart(for: news.category, index: index)
                                )
                                .frame(width: 320)
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                        .padding(.vertical, DesignSystem.Spacing.Cards.shadowPadding)
                    }
                    .scrollClipDisabled()
                }
                .padding(.bottom, DesignSystem.Spacing.lg)
                
                // Personalized Headlines Section based on Interests
                if !getPersonalizedHeadlines().isEmpty {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                        ForEach(getPersonalizedHeadlines(), id: \.self) { interest in
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                                Text(interest)
                                    .font(DesignSystem.Typography.title2)
                                    .foregroundColor(DesignSystem.Colors.onBackground)
                                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: DesignSystem.Spacing.Cards.gap) {
                                        ForEach(Array(getNewsForInterest(interest).enumerated()), id: \.offset) { index, news in
                                            NewsCardLargeWithRating(
                                                title: news.title,
                                                category: news.category,
                                                time: news.time,
                                                rating: Double.random(in: 3.5...5.0),
                                                readerCount: Int.random(in: 500...5000),
                                                hasImage: true,
                                                showChart: shouldShowChart(for: news.category, index: index)
                                            )
                                            .frame(width: 320)
                                        }
                                    }
                                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                                    .padding(.vertical, DesignSystem.Spacing.Cards.shadowPadding)
                                }
                                .scrollClipDisabled()
                            }
                            .padding(.bottom, DesignSystem.Spacing.lg)
                        }
                    }
                }
                
                // Das interessiert andere Leser Section
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                    Text("Das interessiert andere Leser")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DesignSystem.Spacing.Cards.gap) {
                            ForEach(Array(getOtherUsersInterests().enumerated()), id: \.offset) { index, news in
                                NewsCardLargeWithRating(
                                    title: news.title,
                                    category: news.category,
                                    time: news.time,
                                    rating: news.rating,
                                    readerCount: news.readerCount,
                                    hasImage: true,
                                    showChart: shouldShowChart(for: news.category, index: index)
                                )
                                .frame(width: 320)
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                        .padding(.vertical, DesignSystem.Spacing.Cards.shadowPadding)
                    }
                    .scrollClipDisabled()
                }
                .padding(.bottom, DesignSystem.Spacing.lg)
                
                // News Section
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
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
                        
                        // Mix of news, video, and podcast cards - infinite feed
                        ForEach(0..<30, id: \.self) { index in
                            // Determine content type based on index
                            let contentType = index % 8
                            
                            switch contentType {
                            case 0, 1, 3, 5: // News cards with images (50%)
                                NewsCardLarge(
                                    title: getSampleNewsTitle(index),
                                    category: getSampleCategory(index),
                                    time: "vor \(index + 2) Stunden"
                                )
                            case 2, 6: // News cards without images (25%)
                                NewsCardCompact(
                                    title: getSampleNewsTitle(index),
                                    category: getSampleCategory(index),
                                    time: "vor \(index + 2) Stunden"
                                )
                            case 4: // Video cards (12.5%)
                                VideoCard(
                                    title: getSampleVideoTitle(index),
                                    channel: getSampleVideoChannel(index),
                                    duration: getSampleVideoDuration(index),
                                    viewCount: getSampleVideoViewCount(index),
                                    thumbnailType: getSampleVideoType(index)
                                )
                            case 7: // Podcast cards (12.5%)
                                PodcastCard(
                                    title: getSamplePodcastTitle(index),
                                    podcast: getSamplePodcastName(index),
                                    episode: "\(index + 1)",
                                    duration: getSamplePodcastDuration(index),
                                    releaseDate: getSamplePodcastDate(index)
                                )
                            default:
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
                .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                .padding(.top, DesignSystem.Spacing.lg)
                .padding(.bottom, DesignSystem.Spacing.Page.bottom) // Space for bottom navigation
            }
        }
        .background(DesignSystem.Colors.background)
    }
    
    // Get personalized news based on user interests
    private func getPersonalizedNews() -> [EditorialNewsItem] {
        // Get user interests from UserDefaults
        let userInterests = UserDefaults.standard.stringArray(forKey: "userInterests") ?? []
        
        // All available news items
        let allNews = [
            EditorialNewsItem(
                title: "KI-Revolution: Diese Aktien profitieren am meisten",
                category: "Aktien",
                time: "vor 30 Minuten",
                imageName: "editorial_1"
            ),
            EditorialNewsItem(
                title: "Krypto-Analyse: Bitcoin vor dem nächsten Sprung?",
                category: "Krypto",
                time: "vor 1 Stunde",
                imageName: "editorial_2"
            ),
            EditorialNewsItem(
                title: "ETF-Empfehlung: Die besten Dividenden-ETFs 2025",
                category: "ETFs",
                time: "vor 2 Stunden",
                imageName: "editorial_3"
            ),
            EditorialNewsItem(
                title: "Rohstoff-Boom: Gold und Silber im Aufwind",
                category: "Rohstoffe",
                time: "vor 3 Stunden",
                imageName: "editorial_4"
            ),
            EditorialNewsItem(
                title: "Tech-Giganten: Apple vs. Microsoft - Wer gewinnt?",
                category: "Aktien",
                time: "vor 4 Stunden",
                imageName: "editorial_5"
            ),
            EditorialNewsItem(
                title: "EUR/USD: Währungspaar vor Wendepunkt",
                category: "Devisen",
                time: "vor 5 Stunden",
                imageName: "editorial_6"
            ),
            EditorialNewsItem(
                title: "Staatsanleihen: Renditen im Fokus",
                category: "Anleihen",
                time: "vor 6 Stunden",
                imageName: "editorial_7"
            ),
            EditorialNewsItem(
                title: "Optionsstrategien für volatile Märkte",
                category: "Optionen",
                time: "vor 7 Stunden",
                imageName: "editorial_8"
            ),
            EditorialNewsItem(
                title: "DAX-Future: Technische Analyse",
                category: "Futures",
                time: "vor 8 Stunden",
                imageName: "editorial_9"
            )
        ]
        
        // Filter news based on user interests
        if userInterests.isEmpty {
            // If no interests selected, show a mix of everything
            return Array(allNews.prefix(5))
        } else {
            // Filter news by matching categories to user interests
            let filteredNews = allNews.filter { news in
                userInterests.contains(news.category)
            }
            
            // If we don't have enough filtered news, add some general news
            if filteredNews.count < 5 {
                var result = filteredNews
                let remainingNews = allNews.filter { news in
                    !filteredNews.contains { $0.title == news.title }
                }
                result.append(contentsOf: remainingNews.prefix(5 - filteredNews.count))
                return result
            }
            
            return Array(filteredNews.prefix(5))
        }
    }
    
    // Get personalized headlines based on user interests
    private func getPersonalizedHeadlines() -> [String] {
        let userInterests = UserDefaults.standard.stringArray(forKey: "userInterests") ?? []
        // Return only the first 3 interests to avoid too many sections
        return Array(userInterests.prefix(3))
    }
    
    // Get news for a specific interest category
    private func getNewsForInterest(_ interest: String) -> [EditorialNewsItem] {
        let newsItems: [String: [EditorialNewsItem]] = [
            "Aktien": [
                EditorialNewsItem(
                    title: "Apple erreicht neues Allzeithoch nach KI-Ankündigung",
                    category: "Aktien",
                    time: "vor 15 Minuten",
                    imageName: "news_1"
                ),
                EditorialNewsItem(
                    title: "Deutsche Bank übertrifft Gewinnerwartungen deutlich",
                    category: "Aktien",
                    time: "vor 45 Minuten",
                    imageName: "news_2"
                ),
                EditorialNewsItem(
                    title: "Tesla-Aktie unter Druck nach Produktionszahlen",
                    category: "Aktien",
                    time: "vor 1 Stunde",
                    imageName: "news_3"
                )
            ],
            "ETFs": [
                EditorialNewsItem(
                    title: "Neue Rekordmittelzuflüsse in MSCI World ETF",
                    category: "ETFs",
                    time: "vor 20 Minuten",
                    imageName: "etf_1"
                ),
                EditorialNewsItem(
                    title: "Dividenden-ETFs: Die besten Performer 2025",
                    category: "ETFs",
                    time: "vor 35 Minuten",
                    imageName: "etf_2"
                ),
                EditorialNewsItem(
                    title: "Themen-ETFs: KI und Robotik im Fokus",
                    category: "ETFs",
                    time: "vor 50 Minuten",
                    imageName: "etf_3"
                )
            ],
            "Krypto": [
                EditorialNewsItem(
                    title: "Bitcoin durchbricht 100.000 Dollar Marke",
                    category: "Krypto",
                    time: "vor 10 Minuten",
                    imageName: "crypto_1"
                ),
                EditorialNewsItem(
                    title: "Ethereum Update: Staking-Renditen steigen",
                    category: "Krypto",
                    time: "vor 25 Minuten",
                    imageName: "crypto_2"
                ),
                EditorialNewsItem(
                    title: "Neue Regulierung für Krypto-Börsen in der EU",
                    category: "Krypto",
                    time: "vor 40 Minuten",
                    imageName: "crypto_3"
                )
            ],
            "Rohstoffe": [
                EditorialNewsItem(
                    title: "Goldpreis steigt auf 6-Monats-Hoch",
                    category: "Rohstoffe",
                    time: "vor 30 Minuten",
                    imageName: "commodity_1"
                ),
                EditorialNewsItem(
                    title: "Ölpreise volatil nach OPEC-Entscheidung",
                    category: "Rohstoffe",
                    time: "vor 45 Minuten",
                    imageName: "commodity_2"
                ),
                EditorialNewsItem(
                    title: "Kupfer: Nachfrage aus China steigt",
                    category: "Rohstoffe",
                    time: "vor 1 Stunde",
                    imageName: "commodity_3"
                )
            ],
            "Devisen": [
                EditorialNewsItem(
                    title: "EUR/USD: EZB-Entscheidung im Fokus",
                    category: "Devisen",
                    time: "vor 15 Minuten",
                    imageName: "forex_1"
                ),
                EditorialNewsItem(
                    title: "Schweizer Franken bleibt sicherer Hafen",
                    category: "Devisen",
                    time: "vor 30 Minuten",
                    imageName: "forex_2"
                ),
                EditorialNewsItem(
                    title: "Dollar schwächelt vor Fed-Sitzung",
                    category: "Devisen",
                    time: "vor 45 Minuten",
                    imageName: "forex_3"
                )
            ],
            "Anleihen": [
                EditorialNewsItem(
                    title: "Bundesanleihen: Renditen steigen weiter",
                    category: "Anleihen",
                    time: "vor 20 Minuten",
                    imageName: "bond_1"
                ),
                EditorialNewsItem(
                    title: "Unternehmensanleihen: Spreads verengen sich",
                    category: "Anleihen",
                    time: "vor 35 Minuten",
                    imageName: "bond_2"
                ),
                EditorialNewsItem(
                    title: "Green Bonds erreichen Rekordvolumen",
                    category: "Anleihen",
                    time: "vor 50 Minuten",
                    imageName: "bond_3"
                )
            ],
            "Optionen": [
                EditorialNewsItem(
                    title: "Volatilität steigt: Optionsprämien attraktiv",
                    category: "Optionen",
                    time: "vor 25 Minuten",
                    imageName: "option_1"
                ),
                EditorialNewsItem(
                    title: "Put-Call-Ratio signalisiert Vorsicht",
                    category: "Optionen",
                    time: "vor 40 Minuten",
                    imageName: "option_2"
                ),
                EditorialNewsItem(
                    title: "Covered Calls: Zusatzeinkommen generieren",
                    category: "Optionen",
                    time: "vor 55 Minuten",
                    imageName: "option_3"
                )
            ],
            "Futures": [
                EditorialNewsItem(
                    title: "DAX-Future: Widerstand bei 19.500 Punkten",
                    category: "Futures",
                    time: "vor 15 Minuten",
                    imageName: "future_1"
                ),
                EditorialNewsItem(
                    title: "S&P 500 Future deutet auf starken Start",
                    category: "Futures",
                    time: "vor 30 Minuten",
                    imageName: "future_2"
                ),
                EditorialNewsItem(
                    title: "Weizen-Futures steigen nach Erntebericht",
                    category: "Futures",
                    time: "vor 45 Minuten",
                    imageName: "future_3"
                )
            ]
        ]
        
        return newsItems[interest] ?? []
    }
    
    // Determine if we should show a chart for this news item
    private func shouldShowChart(for category: String, index: Int) -> Bool {
        // Alternate between chart and image, with preference for charts on financial categories
        let financialCategories = ["Aktien", "ETFs", "Krypto", "Rohstoffe", "Devisen", "Futures"]
        let isFinancialCategory = financialCategories.contains(category)
        
        // If it's a financial category, show more charts (2 out of 3)
        if isFinancialCategory {
            return index % 3 != 2
        } else {
            // For other categories, alternate evenly
            return index % 2 == 0
        }
    }
    
    // Get popular news based on reader count
    private func getPopularNews() -> [(title: String, category: String, time: String, rating: Double, readerCount: Int)] {
        return [
            (title: "DAX schließt auf Rekordhoch - Anleger optimistisch", category: "Märkte", time: "vor 1 Stunde", rating: 4.8, readerCount: 15234),
            (title: "Tesla übertrifft Erwartungen - Aktie springt 12%", category: "Aktien", time: "vor 2 Stunden", rating: 4.6, readerCount: 12456),
            (title: "Bitcoin-Rally setzt sich fort - 105.000 USD in Sicht", category: "Krypto", time: "vor 3 Stunden", rating: 4.5, readerCount: 10234),
            (title: "Neue EU-Regulierung trifft Tech-Giganten hart", category: "Regulierung", time: "vor 4 Stunden", rating: 4.2, readerCount: 8976),
            (title: "Goldpreis erreicht Jahreshoch - Sichere Häfen gefragt", category: "Rohstoffe", time: "vor 5 Stunden", rating: 4.4, readerCount: 7654)
        ]
    }
    
    // Get what other users are interested in
    private func getOtherUsersInterests() -> [(title: String, category: String, time: String, rating: Double, readerCount: Int)] {
        return [
            (title: "Inflation sinkt überraschend - EZB unter Zugzwang", category: "Wirtschaft", time: "vor 30 Minuten", rating: 4.7, readerCount: 18432),
            (title: "Apple Vision Pro 2: Neue Details durchgesickert", category: "Technologie", time: "vor 1 Stunde", rating: 4.5, readerCount: 14567),
            (title: "Lithium-Aktien im Aufwind - E-Auto Boom", category: "Rohstoffe", time: "vor 2 Stunden", rating: 4.3, readerCount: 11234),
            (title: "Dividendenkönige 2025: Diese Aktien zahlen", category: "Dividenden", time: "vor 3 Stunden", rating: 4.6, readerCount: 9876),
            (title: "KI-ETFs: Die besten Fonds im Vergleich", category: "ETFs", time: "vor 4 Stunden", rating: 4.4, readerCount: 8543)
        ]
    }
    
    // MARK: - Video Content Helpers
    
    private func getSampleVideoTitle(_ index: Int) -> String {
        let titles = [
            "DAX-Analyse: Wird die 20.000 geknackt?",
            "Interview: Warren Buffett's beste Tipps für 2025",
            "Breaking: EZB senkt überraschend Leitzins",
            "Tesla Cybertruck - Revolution oder Flop?",
            "Bitcoin Prognose: 150.000 USD möglich?",
            "Immobilien-Crash 2025? Experten warnen",
            "Apple vs. Samsung: Der große Vergleich",
            "Gold als Krisenwährung - Jetzt einsteigen?",
            "Die besten Dividendenaktien für 2025",
            "Nvidia: KI-König oder überbewertete Blase?"
        ]
        return titles[index % titles.count]
    }
    
    private func getSampleVideoChannel(_ index: Int) -> String {
        let channels = [
            "FinanzNachrichten TV",
            "Börse Stuttgart TV",
            "Der Aktionär TV",
            "wallstreet:online TV",
            "n-tv Börse"
        ]
        return channels[index % channels.count]
    }
    
    private func getSampleVideoDuration(_ index: Int) -> String {
        let durations = ["2:45", "5:12", "8:30", "12:15", "3:58", "15:42", "6:33", "4:20"]
        return durations[index % durations.count]
    }
    
    private func getSampleVideoViewCount(_ index: Int) -> String {
        let counts = ["1.2K", "5.4K", "12K", "834", "2.8K", "15K", "3.1K", "987"]
        return counts[index % counts.count]
    }
    
    private func getSampleVideoType(_ index: Int) -> VideoCard.ThumbnailType {
        let types: [VideoCard.ThumbnailType] = [.marketAnalysis, .interview, .news]
        return types[index % types.count]
    }
    
    // MARK: - Podcast Content Helpers
    
    private func getSamplePodcastTitle(_ index: Int) -> String {
        let titles = [
            "Die Börsenwoche: DAX, Dow Jones & Co.",
            "Value Investing: Die Buffett-Strategie",
            "Krypto Update: Bitcoin, Ethereum und mehr",
            "ETF-Sparplan: So geht's richtig",
            "Rohstoffe im Fokus: Gold, Öl und Kupfer",
            "Tech-Aktien: Chancen und Risiken",
            "Immobilien als Kapitalanlage",
            "Trading-Psychologie: Emotionen kontrollieren",
            "Nachhaltiges Investieren: ESG im Trend",
            "Die Zinswende und ihre Folgen"
        ]
        return titles[index % titles.count]
    }
    
    private func getSamplePodcastName(_ index: Int) -> String {
        let names = [
            "Der Börsen-Podcast",
            "Finanzfluss Podcast",
            "Aktien mit Kopf",
            "Der Finanzwesir rockt",
            "Madame Moneypenny"
        ]
        return names[index % names.count]
    }
    
    private func getSamplePodcastDuration(_ index: Int) -> String {
        let durations = ["32:45", "45:12", "28:30", "52:15", "38:58", "41:42", "36:33", "44:20"]
        return durations[index % durations.count]
    }
    
    private func getSamplePodcastDate(_ index: Int) -> String {
        let dates = ["Heute", "Gestern", "vor 2 Tagen", "vor 3 Tagen", "vor 4 Tagen", "vor 5 Tagen", "vor 1 Woche"]
        return dates[min(index, dates.count - 1)]
    }
}