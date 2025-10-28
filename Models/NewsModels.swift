//
//  NewsModels.swift
//  FinanzNachrichten
//
//  Datenmodelle für Nachrichten-Artikel in verschiedenen Kontexten
//
//  ENTHÄLT:
//  - NewsArticle: Vollständiger Artikel mit Body und erwähnten Instrumenten
//  - NewsInstrument: In Artikeln erwähnte Finanzinstrumente
//  - EditorialNewsItem, MediaNewsItem, TopStoryItem: Verschiedene Display-Varianten
//  - BookmarkedArticle: Persistierbare Bookmark-Version
//

import Foundation
import SwiftUI

// MARK: - News Article

/// Full news article model with body text and mentioned financial instruments
/// Used in article detail view
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

// MARK: - News Instrument

/// Financial instrument mentioned in a news article
/// Tappable to navigate to instrument detail view
struct NewsInstrument {
    let id = UUID()
    let symbol: String        // Trading symbol
    let name: String          // Company/instrument name
    let price: String         // Current price
    let change: String        // Price change percentage
    let isPositive: Bool      // For color-coding
}

// MARK: - Editorial News Item

/// Curated news item with image for editorial sections
/// Used in HomeView "Für dich" section
struct EditorialNewsItem {
    let title: String
    let category: String
    let time: String
    let imageName: String     // Asset name for image
}

// MARK: - Media News Item

/// News item for media/category views with engagement metrics
/// Supports breaking news flag
struct MediaNewsItem {
    let id = UUID()
    let title: String
    let source: String        // Publisher name
    let time: String
    let category: String
    let isBreaking: Bool      // Breaking news indicator
    let rating: Double = 4.0  // Mock article rating
    let readerCount: Int = 1234  // Mock reader count
}

// MARK: - Top Story Item

/// Featured top story with subtitle and image
/// Used in prominent display positions
struct TopStoryItem {
    let id = UUID()
    let title: String
    let subtitle: String      // Brief summary
    let source: String
    let time: String
    let imageName: String     // Asset name for image
}

// MARK: - Additional News Item

/// Simplified news item for auxiliary sections
struct AdditionalNewsItem {
    let title: String
    let category: String
    let time: String
    let imageName: String
}

// MARK: - Bookmarked Article

/// Codable bookmark version for persistence in BookmarkService
/// Simplified compared to NewsArticle (no body, no instruments)
struct BookmarkedArticle: Codable {
    let id: String           // Article UUID as string for Codable
    let title: String
    let category: String
    let time: String
    let source: String
    let hasImage: Bool
    let bookmarkedDate: Date // When user bookmarked this article
}

// MARK: - News Categories

/// News category filter for MediaView
/// Each category has an associated SF Symbol icon
enum NewsCategory: String, CaseIterable {
    case topNews = "Top-News"
    case adHoc = "Ad hoc Nachrichten"
    case chartAnalysis = "Chartanalysen"
    case ipo = "IPO-News"
    case economy = "Konjunktur / Wirtschaftsnews"

    var icon: String {
        switch self {
        case .topNews: return "star.fill"
        case .adHoc: return "bolt.fill"
        case .chartAnalysis: return "chart.line.uptrend.xyaxis"
        case .ipo: return "building.columns.fill"
        case .economy: return "globe.europe.africa.fill"
        }
    }
}

/// Analyst analysis category with color coding
/// Used for filtering analyst reports by recommendation type
enum AnalysisCategory: String, CaseIterable {
    case topAnalyses = "Top-Analysen"
    case buyRecommendations = "Kaufempfehlungen"
    case holdRecommendations = "Halten-Empfehlungen"
    case sellRecommendations = "Verkaufsempfehlungen"

    /// SF Symbol icon for category
    var icon: String {
        switch self {
        case .topAnalyses: return "chart.bar.doc.horizontal.fill"
        case .buyRecommendations: return "arrow.up.circle.fill"
        case .holdRecommendations: return "arrow.left.arrow.right.circle.fill"
        case .sellRecommendations: return "arrow.down.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .topAnalyses: return .blue
        case .buyRecommendations: return .green
        case .holdRecommendations: return .orange
        case .sellRecommendations: return .red
        }
    }
}

// MARK: - Netflix Style News Item

struct NetflixNewsItem: Identifiable {
    let id = UUID()
    let title: String
    let source: String
    let time: String
    let category: String
    let hasImage: Bool
    let isWatchlistRelated: Bool
    let rating: Double
    let readerCount: Int
    let relatedSymbols: [String] // For watchlist filtering

    init(title: String, source: String, time: String, category: String, hasImage: Bool = true, isWatchlistRelated: Bool = false, rating: Double = 4.0, readerCount: Int = 1234, relatedSymbols: [String] = []) {
        self.title = title
        self.source = source
        self.time = time
        self.category = category
        self.hasImage = hasImage
        self.isWatchlistRelated = isWatchlistRelated
        self.rating = rating
        self.readerCount = readerCount
        self.relatedSymbols = relatedSymbols
    }
}

// MARK: - Analysis Item

struct AnalysisNewsItem: Identifiable {
    let id = UUID()
    let title: String
    let source: String
    let analyst: String
    let time: String
    let category: AnalysisCategory
    let targetPrice: String
    let currentPrice: String
    let potentialPercent: Double
    let relatedSymbol: String
    let relatedCompany: String
    let isWatchlistRelated: Bool
    let rating: Double
    let readerCount: Int

    init(title: String, source: String, analyst: String, time: String, category: AnalysisCategory, targetPrice: String, currentPrice: String, potentialPercent: Double, relatedSymbol: String, relatedCompany: String, isWatchlistRelated: Bool = false, rating: Double = 4.0, readerCount: Int = 890) {
        self.title = title
        self.source = source
        self.analyst = analyst
        self.time = time
        self.category = category
        self.targetPrice = targetPrice
        self.currentPrice = currentPrice
        self.potentialPercent = potentialPercent
        self.relatedSymbol = relatedSymbol
        self.relatedCompany = relatedCompany
        self.isWatchlistRelated = isWatchlistRelated
        self.rating = rating
        self.readerCount = readerCount
    }
}