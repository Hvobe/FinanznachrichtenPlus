//
//  NewsListView.swift
//  FinanzNachrichten
//
//  Filterbare Listenansicht für News-Kategorien
//

import SwiftUI

struct NewsListView: View {
    let category: String
    @EnvironmentObject var watchlistService: WatchlistService
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var sortOption: SortOption = .time
    @State private var showWatchlistOnly = false

    enum SortOption: String, CaseIterable {
        case time = "Zeit"
        case relevance = "Relevanz"
        case rating = "Bewertung"

        var icon: String {
            switch self {
            case .time: return "clock"
            case .relevance: return "star"
            case .rating: return "star.fill"
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(DesignSystem.Colors.secondary)

                    TextField("Suchen...", text: $searchText)
                        .font(DesignSystem.Typography.body1)

                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(DesignSystem.Colors.secondary)
                        }
                    }
                }
                .padding(12)
                .background(DesignSystem.Colors.inputBackground)
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                // Filter Bar
                HStack(spacing: 12) {
                    // Sort Options
                    Menu {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Button(action: { sortOption = option }) {
                                HStack {
                                    Image(systemName: option.icon)
                                    Text(option.rawValue)
                                    if sortOption == option {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: sortOption.icon)
                                .font(.system(size: 12))
                            Text(sortOption.rawValue)
                                .font(.system(size: 13, weight: .medium))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10))
                        }
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(DesignSystem.Colors.surface)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(DesignSystem.Colors.border, lineWidth: 1)
                        )
                    }

                    // Watchlist Filter Toggle
                    Button(action: { showWatchlistOnly.toggle() }) {
                        HStack(spacing: 4) {
                            Image(systemName: showWatchlistOnly ? "star.fill" : "star")
                                .font(.system(size: 12))
                            Text("Watchlist")
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(showWatchlistOnly ? .white : DesignSystem.Colors.onBackground)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(showWatchlistOnly ? DesignSystem.Colors.primary : DesignSystem.Colors.surface)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(showWatchlistOnly ? Color.clear : DesignSystem.Colors.border, lineWidth: 1)
                        )
                    }

                    Spacer()

                    // Results Count
                    Text("\(filteredNews.count) Artikel")
                        .font(.system(size: 12))
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)

                Divider()

                // News List
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(filteredNews.enumerated()), id: \.element.id) { index, newsItem in
                            NewsListItemCard(newsItem: newsItem)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)

                            if index < filteredNews.count - 1 {
                                DSSeparator()
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.vertical, 12)
                }
                .background(DesignSystem.Colors.background)
            }
            .navigationTitle(category)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                }
            }
        }
    }

    // MARK: - Computed Properties

    private var filteredNews: [NetflixNewsItem] {
        var news = allMockNews

        // Filter by search text
        if !searchText.isEmpty {
            news = news.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.source.localizedCaseInsensitiveContains(searchText) ||
                item.category.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Filter by watchlist
        if showWatchlistOnly {
            news = news.filter { $0.isWatchlistRelated }
        }

        // Sort
        switch sortOption {
        case .time:
            // Already sorted by time (most recent first)
            break
        case .relevance:
            news.sort { $0.isWatchlistRelated && !$1.isWatchlistRelated }
        case .rating:
            news.sort { $0.rating > $1.rating }
        }

        return news
    }

    // MARK: - Mock Data

    private var allMockNews: [NetflixNewsItem] {
        let watchlistSymbols = watchlistService.activeWatchlist?.items.map { $0.symbol } ?? []

        return [
            NetflixNewsItem(
                title: "Apple kündigt revolutionäres iPhone 16 mit KI-Features an",
                source: "FinanzNachrichten.de",
                time: "vor 1 Stunde",
                category: category,
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
                category: category,
                hasImage: true,
                isWatchlistRelated: watchlistSymbols.contains("TSLA"),
                rating: 4.8,
                readerCount: 2890,
                relatedSymbols: ["TSLA"]
            ),
            NetflixNewsItem(
                title: "Microsoft übernimmt KI-Startup für 2 Milliarden Dollar",
                source: "TechCrunch",
                time: "vor 3 Stunden",
                category: category,
                isWatchlistRelated: watchlistSymbols.contains("MSFT"),
                rating: 4.6,
                readerCount: 1890,
                relatedSymbols: ["MSFT"]
            ),
            NetflixNewsItem(
                title: "Amazon Prime Day bricht alle Verkaufsrekorde",
                source: "Amazon",
                time: "vor 4 Stunden",
                category: category,
                isWatchlistRelated: watchlistSymbols.contains("AMZN"),
                rating: 4.3,
                readerCount: 1567,
                relatedSymbols: ["AMZN"]
            ),
            NetflixNewsItem(
                title: "NVIDIA profitiert von KI-Boom - Aktie steigt 8%",
                source: "CNBC",
                time: "vor 5 Stunden",
                category: category,
                isWatchlistRelated: watchlistSymbols.contains("NVDA"),
                rating: 4.7,
                readerCount: 2100,
                relatedSymbols: ["NVDA"]
            ),
            NetflixNewsItem(
                title: "Deutsche Bank erhöht Dividende um 15%",
                source: "Deutsche Bank AG",
                time: "vor 6 Stunden",
                category: category,
                isWatchlistRelated: watchlistSymbols.contains("DBK"),
                rating: 4.1,
                readerCount: 890,
                relatedSymbols: ["DBK"]
            ),
            NetflixNewsItem(
                title: "Google stellt neue KI-Suchfunktionen vor",
                source: "Google",
                time: "vor 7 Stunden",
                category: category,
                isWatchlistRelated: watchlistSymbols.contains("GOOGL"),
                rating: 4.4,
                readerCount: 1678,
                relatedSymbols: ["GOOGL"]
            ),
            NetflixNewsItem(
                title: "Meta plant neue VR-Plattform für 2025",
                source: "The Verge",
                time: "vor 8 Stunden",
                category: category,
                isWatchlistRelated: watchlistSymbols.contains("META"),
                rating: 4.2,
                readerCount: 1234,
                relatedSymbols: ["META"]
            ),
            NetflixNewsItem(
                title: "SAP erhält Großauftrag von EU-Kommission",
                source: "SAP News",
                time: "vor 9 Stunden",
                category: category,
                isWatchlistRelated: watchlistSymbols.contains("SAP"),
                rating: 4.0,
                readerCount: 667,
                relatedSymbols: ["SAP"]
            ),
            NetflixNewsItem(
                title: "Siemens Energy profitiert von Windkraft-Boom",
                source: "Handelsblatt",
                time: "vor 10 Stunden",
                category: category,
                isWatchlistRelated: watchlistSymbols.contains("SENW"),
                rating: 4.3,
                readerCount: 890,
                relatedSymbols: ["SENW"]
            )
        ]
    }
}

// MARK: - News List Item Card

struct NewsListItemCard: View {
    let newsItem: NetflixNewsItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Small Thumbnail
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .overlay(
                    Group {
                        if newsItem.isWatchlistRelated {
                            VStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(.white)
                                        .padding(6)
                                        .background(DesignSystem.Colors.primary)
                                        .clipShape(Circle())
                                        .padding(6)
                                }
                                Spacer()
                            }
                        }
                    }
                )

            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(newsItem.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.onBackground)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(newsItem.source)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.primary)

                HStack(spacing: 8) {
                    // Rating
                    HStack(spacing: 1) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(newsItem.rating) ? "star.fill" : "star")
                                .font(.system(size: 9))
                                .foregroundColor(.orange)
                        }
                    }

                    Text("•")
                        .font(.system(size: 11))
                        .foregroundColor(DesignSystem.Colors.tertiary)

                    // Reader count
                    HStack(spacing: 3) {
                        Image(systemName: "eye")
                            .font(.system(size: 10))
                        Text("\(newsItem.readerCount)")
                            .font(.system(size: 11))
                    }
                    .foregroundColor(DesignSystem.Colors.secondary)

                    Text("•")
                        .font(.system(size: 11))
                        .foregroundColor(DesignSystem.Colors.tertiary)

                    Text(newsItem.time)
                        .font(.system(size: 11))
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(DesignSystem.Colors.tertiary)
        }
    }
}
