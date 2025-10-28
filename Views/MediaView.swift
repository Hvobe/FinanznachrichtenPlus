//
//  MediaView.swift
//  FinanzNachrichten
//
//  Netflix-Style News Area with horizontal scrollable sections
//

import SwiftUI

struct MediaView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var watchlistService: WatchlistService
    @State private var showingNewsListView = false
    @State private var selectedCategoryForList: String = ""

    let tabs = ["News", "Analysen"]

    var body: some View {
        VStack(spacing: 0) {
            // Header with FN Logo
            FNHeaderView()

            // Tab Navigation
            HStack(spacing: DesignSystem.Spacing.xl * 2) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = index
                        }
                    }) {
                        VStack(spacing: DesignSystem.Spacing.sm) {
                            Text(tab)
                                .font(.system(size: 15, weight: selectedTab == index ? .semibold : .medium))
                                .foregroundColor(selectedTab == index ? DesignSystem.Colors.onBackground : DesignSystem.Colors.secondary)

                            RoundedRectangle(cornerRadius: 1)
                                .fill(selectedTab == index ? DesignSystem.Colors.primary : Color.clear)
                                .frame(height: 2)
                        }
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
            .padding(.vertical, DesignSystem.Spacing.Section.withinSection)
            .background(DesignSystem.Colors.surface)
            .overlay(
                DSSeparator(),
                alignment: .bottom
            )

            // Content
            ScrollView {
                if selectedTab == 0 {
                    newsTabContent
                } else {
                    analysesTabContent
                }
            }
            .background(DesignSystem.Colors.background)
        }
        .sheet(isPresented: $showingNewsListView) {
            NewsListView(category: selectedCategoryForList)
                .environmentObject(watchlistService)
        }
    }

    // MARK: - News Tab Content

    private var newsTabContent: some View {
        VStack(spacing: DesignSystem.Spacing.Section.between) {
            // 1. Top-News (Hero Cards)
            VStack(alignment: .leading, spacing: 12) {
                NewsSectionHeader(
                    title: NewsCategory.topNews.rawValue,
                    icon: NewsCategory.topNews.icon,
                    onSeeAll: { showCategoryList(NewsCategory.topNews.rawValue) }
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(topNewsData) { newsItem in
                            NetflixHeroCard(newsItem: newsItem)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollClipDisabled()
            }
            .padding(.top, 16)

            // 2. Ad hoc Nachrichten (Compact Cards)
            VStack(alignment: .leading, spacing: 12) {
                NewsSectionHeader(
                    title: NewsCategory.adHoc.rawValue,
                    icon: NewsCategory.adHoc.icon,
                    onSeeAll: { showCategoryList(NewsCategory.adHoc.rawValue) }
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(adHocNewsData) { newsItem in
                            NetflixCompactCard(newsItem: newsItem)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollClipDisabled()
            }

            // 3. Chartanalysen (Compact Cards)
            VStack(alignment: .leading, spacing: 12) {
                NewsSectionHeader(
                    title: NewsCategory.chartAnalysis.rawValue,
                    icon: NewsCategory.chartAnalysis.icon,
                    onSeeAll: { showCategoryList(NewsCategory.chartAnalysis.rawValue) }
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(chartAnalysisData) { newsItem in
                            NetflixCompactCard(newsItem: newsItem)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollClipDisabled()
            }

            // 4. IPO-News (Compact Cards)
            VStack(alignment: .leading, spacing: 12) {
                NewsSectionHeader(
                    title: NewsCategory.ipo.rawValue,
                    icon: NewsCategory.ipo.icon,
                    onSeeAll: { showCategoryList(NewsCategory.ipo.rawValue) }
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(ipoNewsData) { newsItem in
                            NetflixCompactCard(newsItem: newsItem)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollClipDisabled()
            }

            // 5. Konjunktur / Wirtschaftsnews (Compact Cards)
            VStack(alignment: .leading, spacing: 12) {
                NewsSectionHeader(
                    title: NewsCategory.economy.rawValue,
                    icon: NewsCategory.economy.icon,
                    onSeeAll: { showCategoryList(NewsCategory.economy.rawValue) }
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(economyNewsData) { newsItem in
                            NetflixCompactCard(newsItem: newsItem)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollClipDisabled()
            }

            Spacer()
                .frame(height: DesignSystem.Spacing.Page.bottom)
        }
    }

    // MARK: - Analysen Tab Content

    private var analysesTabContent: some View {
        VStack(spacing: DesignSystem.Spacing.Section.between) {
            // 1. Top-Analysen (Hero Cards)
            VStack(alignment: .leading, spacing: 12) {
                NewsSectionHeader(
                    title: AnalysisCategory.topAnalyses.rawValue,
                    icon: AnalysisCategory.topAnalyses.icon,
                    onSeeAll: { showCategoryList(AnalysisCategory.topAnalyses.rawValue) }
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(topAnalysesData) { analysis in
                            AnalysisNewsCard(analysis: analysis)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollClipDisabled()
            }
            .padding(.top, 16)

            // 2. Kaufempfehlungen
            VStack(alignment: .leading, spacing: 12) {
                NewsSectionHeader(
                    title: AnalysisCategory.buyRecommendations.rawValue,
                    icon: AnalysisCategory.buyRecommendations.icon,
                    onSeeAll: { showCategoryList(AnalysisCategory.buyRecommendations.rawValue) }
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(buyRecommendationsData) { analysis in
                            AnalysisNewsCard(analysis: analysis)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollClipDisabled()
            }

            // 3. Halten-Empfehlungen
            VStack(alignment: .leading, spacing: 12) {
                NewsSectionHeader(
                    title: AnalysisCategory.holdRecommendations.rawValue,
                    icon: AnalysisCategory.holdRecommendations.icon,
                    onSeeAll: { showCategoryList(AnalysisCategory.holdRecommendations.rawValue) }
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(holdRecommendationsData) { analysis in
                            AnalysisNewsCard(analysis: analysis)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollClipDisabled()
            }

            // 4. Verkaufsempfehlungen
            VStack(alignment: .leading, spacing: 12) {
                NewsSectionHeader(
                    title: AnalysisCategory.sellRecommendations.rawValue,
                    icon: AnalysisCategory.sellRecommendations.icon,
                    onSeeAll: { showCategoryList(AnalysisCategory.sellRecommendations.rawValue) }
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(sellRecommendationsData) { analysis in
                            AnalysisNewsCard(analysis: analysis)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollClipDisabled()
            }

            Spacer()
                .frame(height: DesignSystem.Spacing.Page.bottom)
        }
    }

    // MARK: - Helper Methods

    private func showCategoryList(_ category: String) {
        selectedCategoryForList = category
        showingNewsListView = true
    }

    // MARK: - Mock Data with Watchlist Integration

    private var topNewsData: [NetflixNewsItem] {
        let watchlistSymbols = watchlistService.activeWatchlist?.items.map { $0.symbol } ?? []
        return [
            NetflixNewsItem(
                title: "Apple kündigt revolutionäres iPhone 16 mit KI-Features an",
                source: "FinanzNachrichten.de",
                time: "vor 1 Stunde",
                category: "Technologie",
                hasImage: true,
                isWatchlistRelated: watchlistSymbols.contains("AAPL"),
                rating: 4.5,
                readerCount: 3245,
                relatedSymbols: ["AAPL"]
            ),
            NetflixNewsItem(
                title: "Tesla übertrifft Erwartungen: Quartalszahlen brechen alle Rekorde",
                source: "Bloomberg",
                time: "vor 2 Stunden",
                category: "Automotive",
                hasImage: true,
                isWatchlistRelated: watchlistSymbols.contains("TSLA"),
                rating: 4.8,
                readerCount: 2890,
                relatedSymbols: ["TSLA"]
            ),
            NetflixNewsItem(
                title: "DAX erreicht neues Allzeithoch - Analysten optimistisch",
                source: "Börse Frankfurt",
                time: "vor 3 Stunden",
                category: "Märkte",
                hasImage: true,
                isWatchlistRelated: false,
                rating: 4.2,
                readerCount: 1567
            )
        ]
    }

    private var adHocNewsData: [NetflixNewsItem] {
        let watchlistSymbols = watchlistService.activeWatchlist?.items.map { $0.symbol } ?? []
        return [
            NetflixNewsItem(
                title: "BREAKING: Microsoft übernimmt KI-Startup für 2 Milliarden Dollar",
                source: "TechCrunch",
                time: "vor 15 Min",
                category: "M&A",
                isWatchlistRelated: watchlistSymbols.contains("MSFT"),
                rating: 4.6,
                readerCount: 890,
                relatedSymbols: ["MSFT"]
            ),
            NetflixNewsItem(
                title: "Amazon Prime Day bricht alle Verkaufsrekorde",
                source: "Amazon",
                time: "vor 30 Min",
                category: "E-Commerce",
                isWatchlistRelated: watchlistSymbols.contains("AMZN"),
                rating: 4.3,
                readerCount: 1234,
                relatedSymbols: ["AMZN"]
            ),
            NetflixNewsItem(
                title: "NVIDIA profitiert von KI-Boom - Aktie steigt 8%",
                source: "CNBC",
                time: "vor 45 Min",
                category: "Technologie",
                isWatchlistRelated: watchlistSymbols.contains("NVDA"),
                rating: 4.7,
                readerCount: 2100,
                relatedSymbols: ["NVDA"]
            ),
            NetflixNewsItem(
                title: "Deutsche Bank erhöht Dividende um 15%",
                source: "Deutsche Bank AG",
                time: "vor 1 Stunde",
                category: "Banking",
                isWatchlistRelated: watchlistSymbols.contains("DBK"),
                rating: 4.1,
                readerCount: 567,
                relatedSymbols: ["DBK"]
            )
        ]
    }

    private var chartAnalysisData: [NetflixNewsItem] {
        let watchlistSymbols = watchlistService.activeWatchlist?.items.map { $0.symbol } ?? []
        return [
            NetflixNewsItem(
                title: "Apple-Aktie: Doppelboden bestätigt - Kaufsignal aktiviert",
                source: "ChartGuys",
                time: "vor 2 Stunden",
                category: "Chartanalyse",
                isWatchlistRelated: watchlistSymbols.contains("AAPL"),
                rating: 4.4,
                readerCount: 678,
                relatedSymbols: ["AAPL"]
            ),
            NetflixNewsItem(
                title: "Tesla durchbricht Widerstand bei $250 - Ziel $300",
                source: "TradingView",
                time: "vor 3 Stunden",
                category: "Chartanalyse",
                isWatchlistRelated: watchlistSymbols.contains("TSLA"),
                rating: 4.2,
                readerCount: 890,
                relatedSymbols: ["TSLA"]
            ),
            NetflixNewsItem(
                title: "DAX-Chartanalyse: Bullisches Dreieck bestätigt",
                source: "Börse Online",
                time: "vor 4 Stunden",
                category: "Chartanalyse",
                isWatchlistRelated: false,
                rating: 4.0,
                readerCount: 445
            )
        ]
    }

    private var ipoNewsData: [NetflixNewsItem] {
        return [
            NetflixNewsItem(
                title: "KI-Startup Cerebras geht an die Börse - Bewertung 5 Mrd. $",
                source: "IPO Watch",
                time: "vor 1 Tag",
                category: "IPO",
                rating: 4.3,
                readerCount: 1123
            ),
            NetflixNewsItem(
                title: "FinTech-Unicorn plant Börsengang für Q2 2025",
                source: "FinanzNachrichten.de",
                time: "vor 2 Tagen",
                category: "IPO",
                rating: 4.1,
                readerCount: 889
            ),
            NetflixNewsItem(
                title: "Europäischer E-Commerce-Riese kündigt IPO an",
                source: "Reuters",
                time: "vor 3 Tagen",
                category: "IPO",
                rating: 4.0,
                readerCount: 667
            )
        ]
    }

    private var economyNewsData: [NetflixNewsItem] {
        return [
            NetflixNewsItem(
                title: "EZB senkt Leitzins um 0,25% - Inflation unter Kontrolle",
                source: "Europäische Zentralbank",
                time: "vor 4 Stunden",
                category: "Geldpolitik",
                rating: 4.6,
                readerCount: 2345
            ),
            NetflixNewsItem(
                title: "US-Arbeitsmarktdaten übertreffen Erwartungen deutlich",
                source: "Bureau of Labor Statistics",
                time: "vor 6 Stunden",
                category: "Wirtschaftsdaten",
                rating: 4.4,
                readerCount: 1890
            ),
            NetflixNewsItem(
                title: "Deutschland erhöht Wachstumsprognose auf 1,8%",
                source: "Bundesministerium",
                time: "vor 8 Stunden",
                category: "Konjunktur",
                rating: 4.2,
                readerCount: 1567
            ),
            NetflixNewsItem(
                title: "Ölpreise fallen auf 6-Monats-Tief nach OPEC-Entscheidung",
                source: "Bloomberg Energy",
                time: "vor 10 Stunden",
                category: "Rohstoffe",
                rating: 4.0,
                readerCount: 998
            )
        ]
    }

    // MARK: - Analysis Mock Data

    private var topAnalysesData: [AnalysisNewsItem] {
        let watchlistSymbols = watchlistService.activeWatchlist?.items.map { $0.symbol } ?? []
        return [
            AnalysisNewsItem(
                title: "Apple: Neues iPhone-Zyklus rechtfertigt höhere Bewertung",
                source: "Goldman Sachs Research",
                analyst: "Goldman Sachs",
                time: "vor 1 Stunde",
                category: .topAnalyses,
                targetPrice: "220 $",
                currentPrice: "182 $",
                potentialPercent: 20.9,
                relatedSymbol: "AAPL",
                relatedCompany: "Apple Inc.",
                isWatchlistRelated: watchlistSymbols.contains("AAPL"),
                rating: 4.7,
                readerCount: 1234
            ),
            AnalysisNewsItem(
                title: "Tesla: Produktionsrekorde treiben Gewinnmargen",
                source: "Morgan Stanley",
                analyst: "Morgan Stanley",
                time: "vor 2 Stunden",
                category: .topAnalyses,
                targetPrice: "280 $",
                currentPrice: "235 $",
                potentialPercent: 19.1,
                relatedSymbol: "TSLA",
                relatedCompany: "Tesla Inc.",
                isWatchlistRelated: watchlistSymbols.contains("TSLA"),
                rating: 4.5,
                readerCount: 987
            )
        ]
    }

    private var buyRecommendationsData: [AnalysisNewsItem] {
        let watchlistSymbols = watchlistService.activeWatchlist?.items.map { $0.symbol } ?? []
        return [
            AnalysisNewsItem(
                title: "Microsoft: KI-Integration treibt Cloud-Wachstum",
                source: "JP Morgan",
                analyst: "JP Morgan",
                time: "vor 3 Stunden",
                category: .buyRecommendations,
                targetPrice: "420 $",
                currentPrice: "379 $",
                potentialPercent: 10.8,
                relatedSymbol: "MSFT",
                relatedCompany: "Microsoft Corp.",
                isWatchlistRelated: watchlistSymbols.contains("MSFT"),
                rating: 4.6,
                readerCount: 789
            ),
            AnalysisNewsItem(
                title: "NVIDIA: KI-Boom erst am Anfang - Starkes Kaufsignal",
                source: "Bank of America",
                analyst: "Bank of America",
                time: "vor 4 Stunden",
                category: .buyRecommendations,
                targetPrice: "850 $",
                currentPrice: "724 $",
                potentialPercent: 17.4,
                relatedSymbol: "NVDA",
                relatedCompany: "NVIDIA Corp.",
                isWatchlistRelated: watchlistSymbols.contains("NVDA"),
                rating: 4.8,
                readerCount: 1567
            ),
            AnalysisNewsItem(
                title: "Amazon: E-Commerce-Erholung plus AWS-Wachstum",
                source: "Deutsche Bank",
                analyst: "Deutsche Bank",
                time: "vor 5 Stunden",
                category: .buyRecommendations,
                targetPrice: "175 $",
                currentPrice: "146 $",
                potentialPercent: 19.9,
                relatedSymbol: "AMZN",
                relatedCompany: "Amazon.com Inc.",
                isWatchlistRelated: watchlistSymbols.contains("AMZN"),
                rating: 4.4,
                readerCount: 890
            )
        ]
    }

    private var holdRecommendationsData: [AnalysisNewsItem] {
        let watchlistSymbols = watchlistService.activeWatchlist?.items.map { $0.symbol } ?? []
        return [
            AnalysisNewsItem(
                title: "Google: Abwarten bis KI-Monetarisierung klarer wird",
                source: "Citigroup",
                analyst: "Citigroup",
                time: "vor 6 Stunden",
                category: .holdRecommendations,
                targetPrice: "145 $",
                currentPrice: "138 $",
                potentialPercent: 5.1,
                relatedSymbol: "GOOGL",
                relatedCompany: "Alphabet Inc.",
                isWatchlistRelated: watchlistSymbols.contains("GOOGL"),
                rating: 3.8,
                readerCount: 567
            ),
            AnalysisNewsItem(
                title: "Meta: Faire Bewertung bei aktuellen Multiples",
                source: "UBS",
                analyst: "UBS",
                time: "vor 7 Stunden",
                category: .holdRecommendations,
                targetPrice: "520 $",
                currentPrice: "503 $",
                potentialPercent: 3.4,
                relatedSymbol: "META",
                relatedCompany: "Meta Platforms",
                isWatchlistRelated: watchlistSymbols.contains("META"),
                rating: 3.9,
                readerCount: 445
            )
        ]
    }

    private var sellRecommendationsData: [AnalysisNewsItem] {
        return [
            AnalysisNewsItem(
                title: "Coinbase: Regulatorische Risiken überwiegen Chancen",
                source: "Barclays",
                analyst: "Barclays",
                time: "vor 8 Stunden",
                category: .sellRecommendations,
                targetPrice: "110 $",
                currentPrice: "145 $",
                potentialPercent: -24.1,
                relatedSymbol: "COIN",
                relatedCompany: "Coinbase Global",
                isWatchlistRelated: false,
                rating: 3.5,
                readerCount: 678
            ),
            AnalysisNewsItem(
                title: "Snap: Werbegeschäft unter Druck - Downgrade",
                source: "Wells Fargo",
                analyst: "Wells Fargo",
                time: "vor 9 Stunden",
                category: .sellRecommendations,
                targetPrice: "8 $",
                currentPrice: "11 $",
                potentialPercent: -27.3,
                relatedSymbol: "SNAP",
                relatedCompany: "Snap Inc.",
                isWatchlistRelated: false,
                rating: 3.2,
                readerCount: 334
            )
        ]
    }
}
