//
//  HomeView.swift
//  FinanzNachrichten
//
//  Hauptansicht der App - Tab-basierter Feed mit personalisierten News
//  Neues Design: Top-Tab-Menü + Endlos-Feed statt Sections
//

import SwiftUI

/// Main dashboard view with horizontal top tabs and infinite scroll feed
/// Tabs: "Für dich", "Top Nachrichten", and user-selected interest categories
struct HomeView: View {

    // MARK: - Environment Objects

    @EnvironmentObject var bookmarkService: BookmarkService
    @EnvironmentObject var notificationService: NotificationService
    @EnvironmentObject var watchlistService: WatchlistService

    // MARK: - State Properties

    @State private var selectedTab: String = "Für dich"
    @State private var availableTabs: [String] = []
    @State private var showBookmarkToast = false

    // MARK: - Mock Data Service

    private let mockData = MockDataService.shared

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Header with FN Logo, Bell, Search
            FNHeaderView()

            // Top Horizontal Tab Bar
            TopTabBar(tabs: availableTabs, selectedTab: $selectedTab)

            // Main Feed Content (filtered by selected tab)
            ScrollView {
                LazyVStack(spacing: DesignSystem.Spacing.md) {
                    ForEach(0..<30, id: \.self) { index in
                        feedItem(for: index)
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                    }
                }
                .padding(.top, DesignSystem.Spacing.md)
                .padding(.bottom, DesignSystem.Spacing.xxl)
            }
            .background(DesignSystem.Colors.background)
        }
        .toast(
            isPresented: $showBookmarkToast,
            message: "Artikel gespeichert! Wir passen den Feed deinen Interessen nach an.",
            icon: "bookmark.fill"
        )
        .onAppear {
            loadAvailableTabs()
        }
        .onReceive(NotificationCenter.default.publisher(for: .userInterestsDidChange)) { _ in
            // Reload tabs when user interests are updated
            loadAvailableTabs()
        }
        .onReceive(NotificationCenter.default.publisher(for: .bookmarkAdded)) { _ in
            // Show toast on first bookmark
            if !bookmarkService.hasUserBookmarkedBefore() {
                withAnimation {
                    showBookmarkToast = true
                }
                bookmarkService.markFirstBookmarkSeen()
            }
        }
    }

    // MARK: - Helper Functions

    /// Load available tabs based on user interests
    /// Always includes "Für dich" and "Top Nachrichten", then adds user-selected interests
    private func loadAvailableTabs() {
        let userInterests = UserDefaults.standard.stringArray(forKey: "userInterests") ?? []

        // Default tabs + user interests
        var tabs = ["Für dich", "Top Nachrichten"]

        // Add interest categories (map to German names)
        let interestTabMapping: [String: String] = [
            "Aktien": "Aktien",
            "ETFs": "ETFs",
            "Krypto": "Krypto",
            "Rohstoffe": "Rohstoffe",
            "Devisen": "Devisen",
            "Anleihen": "Anleihen",
            "Optionen": "Optionen",
            "Futures": "Futures",
            "Technik & Wissenschaft": "Technik",
            "Finanzen": "Finanzen"
        ]

        for interest in userInterests {
            if let tabName = interestTabMapping[interest] {
                tabs.append(tabName)
            }
        }

        // Remove duplicates and update
        availableTabs = Array(Set(tabs)).sorted { tab1, tab2 in
            // Keep "Für dich" first, then "Top Nachrichten", then alphabetical
            if tab1 == "Für dich" { return true }
            if tab2 == "Für dich" { return false }
            if tab1 == "Top Nachrichten" { return true }
            if tab2 == "Top Nachrichten" { return false }
            return tab1 < tab2
        }

        // Set initial selected tab
        if selectedTab.isEmpty || !availableTabs.contains(selectedTab) {
            selectedTab = "Für dich"
        }
    }

    /// Generate feed item for given index
    /// Returns different card types: NewsCardLarge (50%), NewsCardCompact (25%), VideoCard (12.5%), PodcastCard (12.5%)
    @ViewBuilder
    private func feedItem(for index: Int) -> some View {
        let cardType = index % 8
        let category = getFilteredCategory(for: index)
        let articleId = generateArticleId(index: index, category: category)

        switch cardType {
        case 0, 2, 4, 6:
            // 50% - Large news cards with images
            NewsCardLarge(
                title: getFilteredNewsTitle(for: index),
                category: category,
                time: "vor \(Int.random(in: 1...240)) Minuten",
                articleId: articleId
            )

        case 1, 5:
            // 25% - Compact news cards without images
            NewsCardCompact(
                title: getFilteredNewsTitle(for: index),
                category: category,
                time: "vor \(Int.random(in: 1...240)) Minuten",
                articleId: articleId
            )

        case 3:
            // 12.5% - Video-themed news
            NewsCardLarge(
                title: "🎥 \(getFilteredNewsTitle(for: index))",
                category: category,
                time: "vor \(Int.random(in: 1...180)) Minuten",
                articleId: articleId
            )

        case 7:
            // 12.5% - Podcast-themed news
            NewsCardLarge(
                title: "🎙️ \(getFilteredNewsTitle(for: index))",
                category: category,
                time: "vor \(Int.random(in: 30...300)) Minuten",
                articleId: articleId
            )

        default:
            EmptyView()
        }
    }

    /// Generate unique article ID based on index, category, and selected tab
    /// Format: "article_{tab}_{index}_{category}"
    private func generateArticleId(index: Int, category: String) -> String {
        return "article_\(selectedTab)_\(index)_\(category)"
    }

    /// Get news title filtered by selected tab
    /// Uses tab-based seed for consistent but different order per tab
    private func getFilteredNewsTitle(for index: Int) -> String {
        // For now, use mock data - will be replaced with real API filtering
        let allTitles = [
            "Apple erreicht neues Allzeithoch nach KI-Ankündigung",
            "Deutsche Bank übertrifft Gewinnerwartungen",
            "Tesla-Aktie unter Druck nach Produktionszahlen",
            "Bitcoin durchbricht 100.000 Dollar Marke",
            "EZB senkt Leitzins erneut - Märkte reagieren positiv",
            "Nvidia präsentiert neue KI-Chips",
            "DAX schließt mit neuem Rekord",
            "Gold erreicht Allzeithoch",
            "Microsoft kündigt neue Cloud-Services an",
            "Ölpreis fällt auf Jahrestief",
            "Alphabet investiert in Quantencomputing",
            "Immobilienmarkt zeigt erste Erholungszeichen",
            "Amazon expandiert im deutschen Markt",
            "Europäische Tech-Aktien im Aufwind",
            "Neue Dividendenrekorde bei DAX-Konzernen"
        ]

        // Create seed based on tab name for consistent shuffling
        let tabSeed = selectedTab.hash
        let shuffledIndex = (index + tabSeed) % allTitles.count

        return allTitles[abs(shuffledIndex)]
    }

    /// Get category filtered by selected tab
    private func getFilteredCategory(for index: Int) -> String {
        // Filter by selected tab
        switch selectedTab {
        case "Für dich":
            // Mixed content based on user interests
            let userInterests = UserDefaults.standard.stringArray(forKey: "userInterests") ?? ["Aktien"]
            return userInterests[index % userInterests.count]

        case "Top Nachrichten":
            // General news categories
            let categories = ["Aktien", "Märkte", "Wirtschaft", "Unternehmen"]
            return categories[index % categories.count]

        default:
            // Return selected tab as category
            return selectedTab
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    /// Posted when a bookmark is added (for first-time toast)
    static let bookmarkAdded = Notification.Name("bookmarkAdded")
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(BookmarkService())
            .environmentObject(NotificationService())
            .environmentObject(WatchlistService.shared)
    }
}
