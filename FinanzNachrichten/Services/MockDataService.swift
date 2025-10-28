//
//  MockDataService.swift
//  FinanzNachrichten
//
//  Zentraler Service für alle Mock-Daten der App
//  Diese Mock-Daten werden in der Entwicklung verwendet und später durch echte API-Aufrufe ersetzt
//
//  WICHTIG: Dieser Service wird noch NICHT in den Views verwendet - das kommt in Phase 3+
//

import Foundation
import SwiftUI

/// Central service providing mock data for development
/// In production, this will be replaced by real API calls from backend services
final class MockDataService {

    // MARK: - Singleton

    static let shared = MockDataService()

    private init() {}

    // MARK: - Top Performers

    /// Returns mock top performing stocks
    /// Used as fallback when user's watchlist is empty or has few items
    func getTopPerformers() -> [WatchlistItem] {
        return [
            WatchlistItem(symbol: "NVDA", name: "NVIDIA Corp.", price: "724.31", change: "+15.42", changePercent: "+2.14%", isPositive: true),
            WatchlistItem(symbol: "AAPL", name: "Apple Inc.", price: "182.52", change: "+2.24", changePercent: "+1.23%", isPositive: true),
            WatchlistItem(symbol: "MSFT", name: "Microsoft Corp.", price: "378.85", change: "+3.32", changePercent: "+0.87%", isPositive: true),
            WatchlistItem(symbol: "GOOGL", name: "Alphabet Inc.", price: "138.45", change: "+1.78", changePercent: "+1.30%", isPositive: true),
            WatchlistItem(symbol: "TSLA", name: "Tesla Inc.", price: "234.67", change: "+4.45", changePercent: "+1.92%", isPositive: true)
        ]
    }

    // MARK: - Market Data

    /// Returns market overview data (indices, commodities, forex, crypto)
    func getMarketData() -> [MarketCard] {
        return [
            // Deutsche Indices
            MarketCard(name: "DAX", value: "19,432.56", change: "+0.52%", isPositive: true),
            MarketCard(name: "MDAX", value: "26,189.34", change: "+0.74%", isPositive: true),
            MarketCard(name: "SDAX", value: "13,876.45", change: "-0.12%", isPositive: false),
            MarketCard(name: "TecDAX", value: "3,421.78", change: "+1.23%", isPositive: true),

            // Internationale Indices
            MarketCard(name: "EuroStoxx 50", value: "4,982.34", change: "+0.45%", isPositive: true),
            MarketCard(name: "DJ Industrial", value: "42,866.87", change: "+0.33%", isPositive: true),
            MarketCard(name: "Nasdaq 100", value: "21,234.56", change: "+0.87%", isPositive: true),
            MarketCard(name: "S&P 500", value: "5,918.24", change: "+0.45%", isPositive: true),
            MarketCard(name: "Nikkei", value: "39,876.23", change: "-0.34%", isPositive: false),

            // Rohstoffe & Währungen
            MarketCard(name: "Gold", value: "2,043.25", change: "-0.18%", isPositive: false),
            MarketCard(name: "Brent Oil", value: "73.45", change: "+1.74%", isPositive: true),
            MarketCard(name: "EUR/Dollar", value: "1.0834", change: "+0.23%", isPositive: true),
            MarketCard(name: "Bitcoin", value: "96,432.18", change: "+2.87%", isPositive: true)
        ]
    }

    /// Returns popular securities (stocks)
    func getSecurities() -> [Security] {
        return [
            Security(name: "Apple Inc.", symbol: "AAPL", price: "182.52", change: "+1.23%", isPositive: true),
            Security(name: "Microsoft", symbol: "MSFT", price: "378.85", change: "+0.87%", isPositive: true),
            Security(name: "NVIDIA", symbol: "NVDA", price: "724.31", change: "+2.14%", isPositive: true),
            Security(name: "Amazon", symbol: "AMZN", price: "145.73", change: "-0.45%", isPositive: false),
            Security(name: "Tesla", symbol: "TSLA", price: "234.67", change: "-1.87%", isPositive: false)
        ]
    }

    // MARK: - News Data

    /// Returns sample news titles for infinite scroll
    /// - Parameter index: Index for cyclic title selection
    /// - Returns: News title string
    func getNewsTitle(for index: Int) -> String {
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

    /// Returns sample news category
    /// - Parameter index: Index for cyclic category selection
    /// - Returns: Category string
    func getNewsCategory(for index: Int) -> String {
        let categories = ["Märkte", "Technologie", "Geldpolitik", "Earnings", "Wirtschaft", "Krypto", "Auto", "Energie", "Banken"]
        return categories[index % categories.count]
    }

    /// Returns editorial/featured news items
    func getEditorialNews() -> [EditorialNewsItem] {
        return [
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
    }

    /// Returns watchlist-related news items
    func getWatchlistNews() -> [WatchlistNewsItem] {
        return [
            WatchlistNewsItem(title: "Apple kündigt neue MacBook Pro Serie an", time: "vor 1 Stunde"),
            WatchlistNewsItem(title: "Tesla erweitert Produktionskapazitäten in Deutschland", time: "vor 2 Stunden"),
            WatchlistNewsItem(title: "Microsoft übernimmt KI-Startup für 2 Milliarden Dollar", time: "vor 3 Stunden"),
            WatchlistNewsItem(title: "Amazon Prime Day bricht alle Verkaufsrekorde", time: "vor 4 Stunden"),
            WatchlistNewsItem(title: "Google stellt neue Pixel-Smartphones vor", time: "vor 5 Stunden"),
            WatchlistNewsItem(title: "Netflix plant Expansion in neue Märkte", time: "vor 6 Stunden")
        ]
    }

    /// Returns additional news items for main feed
    func getAdditionalNews() -> [AdditionalNewsItem] {
        return [
            AdditionalNewsItem(
                title: "Europäische Zentralbank senkt Leitzins um 0,25 Prozentpunkte",
                category: "Geldpolitik",
                time: "vor 1 Stunde",
                imageName: "news_placeholder"
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
                category: "Wirtschaft",
                time: "vor 4 Stunden",
                imageName: "news_placeholder"
            )
        ]
    }

    // MARK: - Schedule & Calendar

    /// Returns upcoming financial events (earnings, dividends, holidays)
    func getScheduleItems() -> [ScheduleItem] {
        return [
            ScheduleItem(title: "Apple Q4 Earnings", date: "28. Jan", time: "22:00", type: .earnings),
            ScheduleItem(title: "Tesla Ex-Dividend", date: "29. Jan", time: "09:00", type: .exDividend),
            ScheduleItem(title: "Microsoft Dividende", date: "30. Jan", time: "16:00", type: .dividend),
            ScheduleItem(title: "US Börsenfeiertag", date: "31. Jan", time: "Ganztägig", type: .holiday),
            ScheduleItem(title: "Inflationsdaten EU", date: "1. Feb", time: "11:00", type: .economicData),
            ScheduleItem(title: "Amazon Quartalszahlen", date: "2. Feb", time: "21:30", type: .earnings)
        ]
    }
}
