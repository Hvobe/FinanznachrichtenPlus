//
//  WatchlistView.swift
//  FinanzNachrichten
//
//  Multi-Watchlist Verwaltung mit horizontalem Selector und kontextbezogenem Content
//  Ermöglicht das Erstellen, Wechseln und Verwalten mehrerer Watchlists
//

import SwiftUI

/// Multi-watchlist management view with horizontal selector and contextual content
/// Supports creating, switching between, and managing multiple watchlists
struct WatchlistView: View {

    // MARK: - State Properties

    @State private var selectedTab = 0
    @State private var showingAddStock = false
    @State private var showingEditSheet = false
    @State private var showingNewWatchlistPrompt = false
    @State private var newWatchlistName = ""
    @State private var newStockSymbol = ""

    // MARK: - Environment Objects

    @EnvironmentObject var watchlistService: WatchlistService
    @StateObject private var bookmarkService = BookmarkService()

    // MARK: - Mock Data Service

    private let mockData = MockDataService.shared

    // MARK: - Stock Data Dictionary

    /// Stock data lookup for quick initialization
    /// Maps symbol to tuple: (name, price, change, changePercent, isPositive)
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

    // MARK: - Computed Properties

    /// Returns watchlist news filtered by active watchlist symbols
    /// In production, this would be fetched from API based on watchlist symbols
    var filteredWatchlistNews: [WatchlistNewsItem] {
        guard let activeWatchlist = watchlistService.activeWatchlist else {
            return []
        }

        // Hole alle Watchlist-News aus MockDataService
        let allNews = mockData.getWatchlistNews()

        // Filtere News basierend auf Symbolen in der aktiven Watchlist
        // Zeige nur News die zu Aktien in der Watchlist passen
        return allNews.filter { news in
            activeWatchlist.items.contains { item in
                news.title.contains(item.symbol) || news.title.contains(item.name)
            }
        }
    }

    /// Returns schedule items filtered by active watchlist symbols
    /// Shows only events relevant to stocks in the active watchlist
    var filteredScheduleItems: [ScheduleItem] {
        guard let activeWatchlist = watchlistService.activeWatchlist else {
            return []
        }

        // Hole alle Schedule-Items aus MockDataService
        let allSchedule = mockData.getScheduleItems()

        // Filtere Schedule-Items nach Watchlist-Symbolen
        // Nur Events für Aktien in der Watchlist anzeigen
        return allSchedule.filter { schedule in
            activeWatchlist.items.contains { item in
                schedule.title.contains(item.symbol) || schedule.title.contains(item.name)
            }
        }
    }

    /// Returns current watchlist index for page indicator
    private var currentWatchlistIndex: Int {
        guard let activeId = watchlistService.activeWatchlistId,
              let index = watchlistService.watchlists.firstIndex(where: { $0.id == activeId }) else {
            return 0
        }
        return index
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Header with FN Logo
            FNHeaderView()

            // Tab Navigation (Add button moved to card)
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
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
            .padding(.vertical, DesignSystem.Spacing.Section.withinSection)
            .background(DesignSystem.Colors.surface)
            .overlay(
                DSSeparator(),
                alignment: .bottom
            )

            // Content based on selected tab
            ZStack(alignment: .bottomTrailing) {
                if selectedTab == 0 {
                    // Aktien Tab - Watchlist selector + chart + items
                    aktienTabContent
                } else {
                    // News Tab - Saved Articles
                    newsTabContent
                }

                // Floating Action Button (only in Aktien tab)
                if selectedTab == 0 {
                    Button(action: {
                        showingAddStock = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(
                                Circle()
                                    .fill(DesignSystem.Colors.primary)
                            )
                            .shadow(color: DesignSystem.Colors.primary.opacity(0.4), radius: 12, x: 0, y: 4)
                    }
                    .padding(.trailing, DesignSystem.Spacing.Page.horizontal)
                    .padding(.bottom, 100) // Above tab bar
                }
            }
        }
        .sheet(isPresented: $showingAddStock) {
            AddStockView(isPresented: $showingAddStock, onAdd: { symbol, name in
                addToWatchlist(symbol: symbol, name: name)
            })
        }
        .sheet(isPresented: $showingEditSheet) {
            if let activeWatchlist = watchlistService.activeWatchlist {
                WatchlistEditSheet(watchlist: activeWatchlist)
                    .environmentObject(watchlistService)
            }
        }
        .alert("Neue Watchlist", isPresented: $showingNewWatchlistPrompt) {
            TextField("Name", text: $newWatchlistName)
            Button("Abbrechen", role: .cancel) {
                newWatchlistName = ""
            }
            Button("Erstellen") {
                let trimmedName = newWatchlistName.trimmingCharacters(in: .whitespaces)
                if !trimmedName.isEmpty {
                    let newWatchlist = watchlistService.createWatchlist(name: trimmedName)
                    watchlistService.switchToWatchlist(newWatchlist)
                }
                newWatchlistName = ""
            }
        } message: {
            Text("Gib deiner neuen Watchlist einen Namen")
        }
        .onAppear {
            loadInitialWatchlist()
        }
    }

    // MARK: - Aktien Tab Content

    private var aktienTabContent: some View {
        ScrollView {
            if let activeWatchlist = watchlistService.activeWatchlist {
            VStack(spacing: 0) {
                // 1. Header with Watchlist Name + "Neue Watchlist" Button
                HStack {
                    Text(activeWatchlist.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.onBackground)

                    Spacer()

                    Button(action: {
                        showingNewWatchlistPrompt = true
                    }) {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .semibold))

                            Text("Neue Watchlist")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(DesignSystem.Colors.primary)
                        .padding(.horizontal, DesignSystem.Spacing.md)
                        .padding(.vertical, DesignSystem.Spacing.xs)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                .fill(DesignSystem.Colors.primary.opacity(0.1))
                        )
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                .padding(.top, DesignSystem.Spacing.sm)
                .padding(.bottom, DesignSystem.Spacing.xs)

                // 2. Horizontal Watchlist Selector with Donut Charts
                VStack(spacing: DesignSystem.Spacing.sm) {
                    TabView(selection: $watchlistService.activeWatchlistId) {
                        ForEach(watchlistService.watchlists) { watchlist in
                            CombinedWatchlistCard(
                                watchlist: watchlist,
                                onEdit: { showingEditSheet = true }
                            )
                            .tag(watchlist.id as UUID?)
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                        }

                        // Add Watchlist Card
                        CompactAddWatchlistCard {
                            showingNewWatchlistPrompt = true
                        }
                        .tag(nil as UUID?)
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 240)
                    .onChange(of: watchlistService.activeWatchlistId) {
                        // Trigger view update when active watchlist changes
                    }

                    // Page Indicator with numbering
                    if watchlistService.watchlists.count > 1 {
                        Text("\(currentWatchlistIndex + 1) / \(watchlistService.watchlists.count)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                }
                .padding(.top, DesignSystem.Spacing.md)

                // 3. Watchlist Items Header
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                    Text("Wertpapiere")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.onBackground)

                    // Watchlist Items
                    if activeWatchlist.items.isEmpty {
                        DSCard(
                            backgroundColor: DesignSystem.Colors.surface,
                            borderColor: DesignSystem.Colors.border,
                            cornerRadius: DesignSystem.CornerRadius.lg,
                            padding: DesignSystem.Spacing.xl,
                            hasShadow: false
                        ) {
                            VStack(spacing: DesignSystem.Spacing.lg) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 48))
                                    .foregroundColor(DesignSystem.Colors.secondary.opacity(0.5))

                                Text("Keine Wertpapiere")
                                    .font(DesignSystem.Typography.body1)
                                    .foregroundColor(DesignSystem.Colors.secondary)

                                Text("Tippe auf das + Symbol, um Aktien zu deiner Watchlist hinzuzufügen")
                                    .font(DesignSystem.Typography.caption1)
                                    .foregroundColor(DesignSystem.Colors.tertiary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, DesignSystem.Spacing.xl)
                        }
                    } else {
                        DSCard(
                            backgroundColor: DesignSystem.Colors.cardBackground,
                            borderColor: DesignSystem.Colors.border,
                            cornerRadius: DesignSystem.CornerRadius.lg,
                            padding: 0,
                            hasShadow: true
                        ) {
                            VStack(spacing: 0) {
                                ForEach(Array(activeWatchlist.items.enumerated()), id: \.element.id) { index, item in
                                    WatchlistItemRow(item: item, onRemove: {
                                        watchlistService.removeFromWatchlist(item, fromWatchlist: activeWatchlist)
                                    })

                                    if index < activeWatchlist.items.count - 1 {
                                        DSSeparator()
                                            .padding(.horizontal, DesignSystem.Spacing.lg)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                .padding(.top, DesignSystem.Spacing.Section.headerGap)

                // News Section (always show for now with mock data)
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                    Text("News zu deinen Werten")
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
                            // Mock news - always show
                            ForEach(Array([
                                WatchlistNewsItem(title: "Apple kündigt neue MacBook Pro Serie an", time: "vor 1 Stunde"),
                                WatchlistNewsItem(title: "Tesla erweitert Produktionskapazitäten", time: "vor 2 Stunden"),
                                WatchlistNewsItem(title: "Microsoft übernimmt KI-Startup", time: "vor 3 Stunden")
                            ].enumerated()), id: \.offset) { index, news in
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

                                if index < 2 {
                                    DSSeparator()
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                .padding(.top, DesignSystem.Spacing.Section.between)


                // Schedule Section (filtered by active watchlist)
                if !filteredScheduleItems.isEmpty {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                        Text("Termine & Ereignisse")
                            .font(DesignSystem.Typography.title2)
                            .foregroundColor(DesignSystem.Colors.onBackground)
                            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: DesignSystem.Spacing.Cards.gap) {
                                ForEach(filteredScheduleItems, id: \.title) { item in
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
                            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                            .padding(.vertical, DesignSystem.Spacing.Cards.shadowPadding)
                        }
                    }
                    .padding(.top, DesignSystem.Spacing.Section.between)
                }

                Spacer()
                    .frame(height: DesignSystem.Spacing.Page.bottom)
            }
            }
        }
        .background(DesignSystem.Colors.background)
    }

    // MARK: - News Tab Content

    private var newsTabContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
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

                                            HStack(spacing: DesignSystem.Spacing.sm) {
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
                .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                .padding(.top, DesignSystem.Spacing.Section.headerGap)
            }
            .padding(.bottom, DesignSystem.Spacing.Page.bottom)
        }
        .background(DesignSystem.Colors.background)
        .onAppear {
            bookmarkService.loadArticleDetails()
        }
    }

    // MARK: - Helper Methods

    private func loadInitialWatchlist() {
        // Load from onboarding selection first
        if let savedSymbols = UserDefaults.standard.array(forKey: "initialWatchlist") as? [String],
           !savedSymbols.isEmpty,
           let activeWatchlist = watchlistService.activeWatchlist,
           activeWatchlist.items.isEmpty {

            for symbol in savedSymbols {
                if let data = stockData[symbol] {
                    let priceString = data.1.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: "€", with: "")
                    let price = Double(priceString) ?? 0.0
                    let changeString = data.2.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "%", with: "")
                    let change = Double(changeString) ?? 0.0
                    let changePercentString = data.3.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "%", with: "")
                    let changePercent = Double(changePercentString) ?? 0.0

                    watchlistService.addToWatchlist(
                        symbol: symbol,
                        name: data.0,
                        price: price,
                        change: change,
                        changePercent: changePercent,
                        isPositive: data.4,
                        toWatchlist: activeWatchlist
                    )
                }
            }
            UserDefaults.standard.removeObject(forKey: "initialWatchlist")
        } else if let activeWatchlist = watchlistService.activeWatchlist,
                  activeWatchlist.items.isEmpty,
                  watchlistService.watchlists.count == 1 {
            // Load default items if first time and empty
            watchlistService.addToWatchlist(symbol: "AAPL", name: "Apple Inc.", price: 182.52, change: 2.24, changePercent: 1.23, isPositive: true)
            watchlistService.addToWatchlist(symbol: "MSFT", name: "Microsoft Corp.", price: 378.85, change: 3.32, changePercent: 0.87, isPositive: true)
            watchlistService.addToWatchlist(symbol: "NVDA", name: "NVIDIA Corp.", price: 724.31, change: 15.42, changePercent: 2.14, isPositive: true)
        }
    }

    private func addToWatchlist(symbol: String, name: String) {
        watchlistService.addToWatchlist(symbol: symbol, name: name)
    }
}

// MARK: - Compact Add Watchlist Card (Secondary Option)

struct CompactAddWatchlistCard: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: DesignSystem.Spacing.md) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(DesignSystem.Colors.primary.opacity(0.3))

                Text("Neue Watchlist")
                    .font(DesignSystem.Typography.body1)
                    .foregroundColor(DesignSystem.Colors.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .padding(DesignSystem.Spacing.lg)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
                        .fill(DesignSystem.Colors.surface.opacity(0.5))
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                        .foregroundColor(DesignSystem.Colors.border)
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
