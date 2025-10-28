//
//  MarketModels.swift
//  FinanzNachrichten
//
//  Datenmodelle für Marktdaten, Finanzinstrumente und Branchen
//
//  ENTHÄLT:
//  - MarketCard, MarketInstrument: Basis-Marktdaten für UI-Display
//  - WatchlistItem: Hauptmodel für Watchlist-Einträge (mit Codable für Persistierung)
//  - Branch: Branchen-Model mit 16 deutschen Marktsektoren + Mock-Daten
//  - Security: Einfaches Security-Display-Model
//  - Analysis & News: Models für Analysten-Ratings und Branchen-News
//

import Foundation
import SwiftUI

// MARK: - Market Card

/// Simple market overview card model for displaying indices, forex, commodities
/// Used in market overview grids and horizontal scrolls
struct MarketCard {
    let name: String           // e.g., "DAX", "Bitcoin", "EUR/USD"
    let value: String          // Formatted price/value string
    let change: String         // Formatted change percentage
    let isPositive: Bool       // For color-coding (green/red)
}

// MARK: - Market Instrument

/// Market instrument model with region support for filtering
/// Used for displaying world indices grouped by geographic region
struct MarketInstrument: Identifiable {
    let id = UUID()
    let name: String              // Index name (e.g., "DAX", "S&P 500")
    let value: String             // Formatted current value
    let change: String            // Formatted change percentage
    let isPositive: Bool          // For color-coding
    let region: IndexRegion?      // Optional geographic region for filtering

    init(name: String, value: String, change: String, isPositive: Bool, region: IndexRegion? = nil) {
        self.name = name
        self.value = value
        self.change = change
        self.isPositive = isPositive
        self.region = region
    }
}

// MARK: - Index Region

/// Geographic regions for filtering world indices in MarketsView
enum IndexRegion: String, CaseIterable {
    case germany = "Deutschland"
    case europe = "Europa"
    case usa = "USA"
    case asia = "Asien"
}

// MARK: - World Indices Data

extension MarketInstrument {
    /// Mock data for world indices across all regions
    /// Used in MarketsView indices tab with region filtering
    static let worldIndices: [MarketInstrument] = [
        // Deutsche Indizes
        MarketInstrument(name: "DAX", value: "19,432.56", change: "+0.52%", isPositive: true, region: .germany),
        MarketInstrument(name: "MDAX", value: "26,189.34", change: "+0.74%", isPositive: true, region: .germany),
        MarketInstrument(name: "SDAX", value: "13,876.45", change: "-0.12%", isPositive: false, region: .germany),
        MarketInstrument(name: "TecDAX", value: "3,421.78", change: "+1.23%", isPositive: true, region: .germany),

        // Europäische Indizes
        MarketInstrument(name: "EuroStoxx 50", value: "4,982.34", change: "+0.45%", isPositive: true, region: .europe),
        MarketInstrument(name: "FTSE 100", value: "7,845.67", change: "+0.28%", isPositive: true, region: .europe),
        MarketInstrument(name: "CAC 40", value: "7,621.45", change: "+0.38%", isPositive: true, region: .europe),
        MarketInstrument(name: "SMI", value: "11,234.56", change: "+0.15%", isPositive: true, region: .europe),

        // US Indizes
        MarketInstrument(name: "S&P 500", value: "5,918.24", change: "+0.45%", isPositive: true, region: .usa),
        MarketInstrument(name: "Nasdaq 100", value: "21,234.56", change: "+0.87%", isPositive: true, region: .usa),
        MarketInstrument(name: "Dow Jones", value: "42,866.87", change: "+0.33%", isPositive: true, region: .usa),
        MarketInstrument(name: "Russell 2000", value: "2,134.67", change: "-0.22%", isPositive: false, region: .usa),

        // Asiatische Indizes
        MarketInstrument(name: "Nikkei 225", value: "39,876.23", change: "-0.34%", isPositive: false, region: .asia),
        MarketInstrument(name: "Hang Seng", value: "17,234.56", change: "+0.52%", isPositive: true, region: .asia),
        MarketInstrument(name: "Shanghai Comp.", value: "3,012.45", change: "+0.18%", isPositive: true, region: .asia),
        MarketInstrument(name: "KOSPI", value: "2,567.89", change: "+0.41%", isPositive: true, region: .asia)
    ]
}

// MARK: - Security

/// Simple security model for displaying stocks/ETFs in lists
/// Used in HomeView securities section
struct Security {
    let name: String           // Company name
    let symbol: String         // Trading symbol
    let price: String          // Formatted price
    let change: String         // Formatted change percentage
    let isPositive: Bool       // For color-coding
}

// MARK: - Watchlist Item

/// Primary model for watchlist entries
/// Codable for UserDefaults persistence, Equatable for comparisons
/// Used throughout the app for displaying financial instruments
struct WatchlistItem: Identifiable, Codable, Equatable {
    let id: UUID
    let symbol: String
    let name: String
    let price: String
    let change: String
    let changePercent: String
    let isPositive: Bool

    init(id: UUID = UUID(), symbol: String, name: String, price: String, change: String, changePercent: String, isPositive: Bool) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.price = price
        self.change = change
        self.changePercent = changePercent
        self.isPositive = isPositive
    }
}

// MARK: - Watchlist News Item

/// Simplified news item for watchlist-specific news feeds
struct WatchlistNewsItem {
    let title: String          // News headline
    let time: String           // Formatted time string
}

// MARK: - Branch Data Model

/// Industry branch/sector model with stocks and computed rankings
/// Represents a German market sector (e.g., "Elektrotechnologie", "Fahrzeuge")
/// Contains 16 sample branches with real German companies
struct Branch {
    let id = UUID()
    let name: String               // Branch name (e.g., "Elektrotechnologie")
    let color: Color               // Theme color for UI
    let stocks: [WatchlistItem]    // Companies in this branch

    /// Returns stocks sorted by performance (highest change % first)
    var topPerformers: [WatchlistItem] {
        stocks.sorted { item1, item2 in
            let percent1 = Double(item1.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            let percent2 = Double(item2.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            return percent1 > percent2
        }
    }

    /// Returns stocks sorted by losses (lowest change % first)
    var worstPerformers: [WatchlistItem] {
        stocks.sorted { item1, item2 in
            let percent1 = Double(item1.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            let percent2 = Double(item2.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            return percent1 < percent2
        }
    }

    /// Returns mock dividend ranking
    /// In production would sort by actual dividend yield from API
    var dividendStocks: [WatchlistItem] {
        // Mock: zufällige Auswahl, in Production nach Dividendenrendite sortieren
        stocks.shuffled().prefix(5).map { $0 }
    }
}

// MARK: - Branch News Types

/// News category filter for branch detail view
enum BranchNewsType: String, CaseIterable {
    case allNews = "Alle News"
    case pressReleases = "Pressemitteilungen"
    case chartAnalyses = "Chartanalysen"
    case reports = "Berichte"
}

// MARK: - Analyst Ratings

/// Analyst recommendation types with color coding
enum AnalystRating: String, CaseIterable {
    case buy = "Aktuelle Kaufempfehlungen"
    case hold = "Aktuelle Halten-Empfehlungen"
    case sell = "Aktuelle Verkaufsempfehlungen"

    var color: Color {
        switch self {
        case .buy: return .green
        case .hold: return .orange
        case .sell: return .red
        }
    }
}

// MARK: - Branch Stock Categories

/// Stock ranking categories for branch detail view
/// Determines which stock list to display in BranchDetailView
enum BranchStockCategory: String, CaseIterable {
    case topFlop = "Top / Flop - Werte"
    case potential = "Aktien nach Potenzial"
    case focus = "Aktien im Blickpunkt"
    case dividend = "Aktien nach Dividendenrendite"

    /// Descriptive subtitle explaining the category
    var subtitle: String {
        switch self {
        case .topFlop: return "Gewinner / Verlierer in der Branche"
        case .potential: return "Aktien / Empfehlungen mit dem größten Kurspotenzial"
        case .focus: return "Aktien mit den meisten Nachrichten"
        case .dividend: return ""
        }
    }
}

// MARK: - Sample Branches Data

extension Branch {
    /// Mock data for 16 German industry branches with real company symbols
    /// Used in MarketsView and BranchDetailView
    /// Each branch contains 2-5 German stocks with realistic price data
    static let sampleBranches: [Branch] = [
        Branch(
            name: "Bau/Infrastruktur",
            color: .green,
            stocks: [
                WatchlistItem(symbol: "HEI", name: "HeidelbergCement AG", price: "59.34", change: "+1.23", changePercent: "+2.11%", isPositive: true),
                WatchlistItem(symbol: "HOT", name: "Hochtief AG", price: "89.45", change: "+2.45", changePercent: "+2.82%", isPositive: true),
                WatchlistItem(symbol: "LEG", name: "LEG Immobilien SE", price: "89.34", change: "+1.45", changePercent: "+1.65%", isPositive: true),
                WatchlistItem(symbol: "VNA", name: "Vonovia SE", price: "28.67", change: "-0.34", changePercent: "-1.17%", isPositive: false),
                WatchlistItem(symbol: "STHR", name: "Sto SE & Co.", price: "125.40", change: "+3.20", changePercent: "+2.62%", isPositive: true)
            ]
        ),
        Branch(
            name: "Bekleidung/Textil",
            color: .purple,
            stocks: [
                WatchlistItem(symbol: "ADS", name: "Adidas AG", price: "218.45", change: "+4.23", changePercent: "+1.97%", isPositive: true),
                WatchlistItem(symbol: "PUM", name: "PUMA SE", price: "42.67", change: "-0.67", changePercent: "-1.54%", isPositive: false),
                WatchlistItem(symbol: "HUG", name: "Hugo Boss AG", price: "56.78", change: "+1.23", changePercent: "+2.21%", isPositive: true)
            ]
        ),
        Branch(
            name: "Biotechnologie",
            color: .cyan,
            stocks: [
                WatchlistItem(symbol: "BNTX", name: "BioNTech SE", price: "89.45", change: "+2.34", changePercent: "+2.68%", isPositive: true),
                WatchlistItem(symbol: "MOR", name: "MorphoSys AG", price: "45.67", change: "-1.23", changePercent: "-2.62%", isPositive: false),
                WatchlistItem(symbol: "EVT", name: "Evotec SE", price: "12.34", change: "+0.45", changePercent: "+3.78%", isPositive: true)
            ]
        ),
        Branch(
            name: "Chemie",
            color: .orange,
            stocks: [
                WatchlistItem(symbol: "BAS", name: "BASF SE", price: "44.56", change: "-0.78", changePercent: "-1.72%", isPositive: false),
                WatchlistItem(symbol: "LXS", name: "Lanxess AG", price: "25.89", change: "+0.56", changePercent: "+2.21%", isPositive: true),
                WatchlistItem(symbol: "WAC", name: "Wacker Chemie AG", price: "95.67", change: "+2.34", changePercent: "+2.51%", isPositive: true),
                WatchlistItem(symbol: "EVK", name: "Evonik Industries AG", price: "18.90", change: "-0.23", changePercent: "-1.20%", isPositive: false)
            ]
        ),
        Branch(
            name: "Dienstleistungen",
            color: .blue,
            stocks: [
                WatchlistItem(symbol: "DHER", name: "Delivery Hero SE", price: "23.45", change: "+1.23", changePercent: "+5.54%", isPositive: true),
                WatchlistItem(symbol: "TMV", name: "TeamViewer AG", price: "11.45", change: "+0.34", changePercent: "+3.07%", isPositive: true)
            ]
        ),
        Branch(
            name: "Eisen/Stahl",
            color: .gray,
            stocks: [
                WatchlistItem(symbol: "TKA", name: "ThyssenKrupp AG", price: "4.23", change: "-0.12", changePercent: "-2.76%", isPositive: false),
                WatchlistItem(symbol: "SZU", name: "Salzgitter AG", price: "15.67", change: "+0.45", changePercent: "+2.96%", isPositive: true)
            ]
        ),
        Branch(
            name: "Elektrotechnologie",
            color: .yellow,
            stocks: [
                WatchlistItem(symbol: "SIE", name: "Siemens AG", price: "178.25", change: "+4.32", changePercent: "+2.48%", isPositive: true),
                WatchlistItem(symbol: "IFX", name: "Infineon Technologies AG", price: "32.45", change: "+0.67", changePercent: "+2.11%", isPositive: true),
                WatchlistItem(symbol: "SHL", name: "Siemens Healthineers AG", price: "52.34", change: "+0.89", changePercent: "+1.73%", isPositive: true)
            ]
        ),
        Branch(
            name: "Erneuerbare Energien",
            color: .green,
            stocks: [
                WatchlistItem(symbol: "SENW", name: "Siemens Energy AG", price: "23.45", change: "+1.12", changePercent: "+5.01%", isPositive: true),
                WatchlistItem(symbol: "EWE", name: "Encavis AG", price: "16.78", change: "+0.34", changePercent: "+2.07%", isPositive: true)
            ]
        ),
        Branch(
            name: "Fahrzeuge",
            color: .red,
            stocks: [
                WatchlistItem(symbol: "BMW", name: "BMW AG", price: "89.76", change: "-1.23", changePercent: "-1.35%", isPositive: false),
                WatchlistItem(symbol: "MBG", name: "Mercedes-Benz Group AG", price: "63.42", change: "+0.98", changePercent: "+1.57%", isPositive: true),
                WatchlistItem(symbol: "VOW3", name: "Volkswagen AG Vz.", price: "123.45", change: "-2.34", changePercent: "-1.86%", isPositive: false),
                WatchlistItem(symbol: "CON", name: "Continental AG", price: "67.23", change: "-1.45", changePercent: "-2.11%", isPositive: false)
            ]
        ),
        Branch(
            name: "Finanzdienstleistungen",
            color: .indigo,
            stocks: [
                WatchlistItem(symbol: "DBK", name: "Deutsche Bank AG", price: "16.89", change: "+0.67", changePercent: "+4.13%", isPositive: true),
                WatchlistItem(symbol: "CBK", name: "Commerzbank AG", price: "12.45", change: "+0.23", changePercent: "+1.88%", isPositive: true),
                WatchlistItem(symbol: "ALV", name: "Allianz SE", price: "267.80", change: "+3.45", changePercent: "+1.31%", isPositive: true)
            ]
        ),
        Branch(
            name: "Freizeitprodukte",
            color: .pink,
            stocks: [
                WatchlistItem(symbol: "ADS", name: "Adidas AG", price: "218.45", change: "+4.23", changePercent: "+1.97%", isPositive: true),
                WatchlistItem(symbol: "PUM", name: "PUMA SE", price: "42.67", change: "-0.67", changePercent: "-1.54%", isPositive: false)
            ]
        ),
        Branch(
            name: "Gesundheitswesen",
            color: .mint,
            stocks: [
                WatchlistItem(symbol: "SHL", name: "Siemens Healthineers AG", price: "52.34", change: "+0.89", changePercent: "+1.73%", isPositive: true),
                WatchlistItem(symbol: "FME", name: "Fresenius Medical Care AG", price: "34.56", change: "+0.78", changePercent: "+2.31%", isPositive: true),
                WatchlistItem(symbol: "FRE", name: "Fresenius SE & Co.", price: "28.90", change: "-0.45", changePercent: "-1.53%", isPositive: false)
            ]
        ),
        Branch(
            name: "Getränke/Tabak",
            color: .brown,
            stocks: [
                WatchlistItem(symbol: "BEI", name: "Beiersdorf AG", price: "134.56", change: "+2.34", changePercent: "+1.77%", isPositive: true)
            ]
        ),
        Branch(
            name: "Halbleiter",
            color: .teal,
            stocks: [
                WatchlistItem(symbol: "IFX", name: "Infineon Technologies AG", price: "32.45", change: "+0.67", changePercent: "+2.11%", isPositive: true),
                WatchlistItem(symbol: "ASML", name: "ASML Holding N.V.", price: "678.90", change: "+12.45", changePercent: "+1.87%", isPositive: true)
            ]
        ),
        Branch(
            name: "Handel/E-Commerce",
            color: .cyan,
            stocks: [
                WatchlistItem(symbol: "ZAL", name: "Zalando SE", price: "26.89", change: "+0.89", changePercent: "+3.42%", isPositive: true),
                WatchlistItem(symbol: "HFG", name: "HelloFresh SE", price: "8.76", change: "-0.34", changePercent: "-3.74%", isPositive: false)
            ]
        ),
        Branch(
            name: "Hardware",
            color: .gray,
            stocks: [
                WatchlistItem(symbol: "SIE", name: "Siemens AG", price: "178.25", change: "+4.32", changePercent: "+2.48%", isPositive: true)
            ]
        )
    ]
}

// MARK: - Analysis Item Model

/// Analyst report/recommendation model
/// Used in BranchDetailView to display buy/hold/sell recommendations
struct AnalysisItem: Identifiable {
    let id: UUID
    let symbol: String              // Stock symbol
    let name: String                // Company name
    let rating: AnalystRating       // Buy/Hold/Sell
    let targetPrice: String         // Analyst's price target
    let analyst: String             // Analyst/firm name
    let date: Date                  // Report date
    let summary: String             // Brief recommendation summary
}

// MARK: - Branch News Item Model

/// News article model for branch-specific news feeds
/// Simplified version of NewsArticle with category and source
struct BranchNewsItem: Identifiable {
    let id: UUID
    let title: String               // Article headline
    let summary: String             // Brief summary/excerpt
    let time: String                // Formatted time string
    let category: String            // News category
    let source: String              // News source/publisher
}