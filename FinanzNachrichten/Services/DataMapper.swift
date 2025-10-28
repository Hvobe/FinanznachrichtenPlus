//
//  DataMapper.swift
//  FinanzNachrichten
//
//  Service für die Konvertierung zwischen verschiedenen Daten-Modellen
//  Mappt z.B. MarketCard → InstrumentData für Detail-Ansichten
//
//  WICHTIG: Dieser Service wird noch NICHT in den Components verwendet - das kommt in Phase 6
//

import Foundation

/// Service for mapping between different data model types
/// Handles conversion of various financial data models to InstrumentData for detail views
enum DataMapper {

    // MARK: - MarketCard Conversions

    /// Converts a MarketCard to InstrumentData for detail view
    /// - Parameter card: The market card to convert
    /// - Returns: InstrumentData with populated fields
    static func toInstrumentData(from card: MarketCard) -> InstrumentData {
        // Parse Preis-String zu Double (entferne Währungssymbole und Formatierung)
        let price = parsePrice(from: card.value)

        // Parse Prozent-Änderung
        let changeValue = parsePercentage(from: card.change)

        // Konvertiere Markt-Name zu Symbol (z.B. "DAX" → "^DAX")
        let symbol = marketNameToSymbol(card.name)

        return InstrumentData(
            symbol: symbol,
            name: card.name,
            isin: nil,
            wkn: nil,
            exchange: "XETRA",
            currentPrice: price,
            change: changeValue * price / 100,
            changePercent: changeValue,
            dayLow: price * 0.97,
            dayHigh: price * 1.03,
            weekLow52: price * 0.80,
            weekHigh52: price * 1.25,
            volume: Int.random(in: 10_000_000...100_000_000),
            marketCap: "N/A",
            pe: nil,
            beta: nil,
            dividendYield: nil,
            nextEarningsDate: nil,
            bid: price - 0.10,
            ask: price + 0.10,
            lastUpdate: Date(),
            chartData: InstrumentData.generateSampleChartData(isPositive: card.isPositive),
            isPositive: card.isPositive
        )
    }

    // MARK: - Security Conversions

    /// Converts a Security to InstrumentData
    /// - Parameter security: The security to convert
    /// - Returns: InstrumentData with populated fields
    static func toInstrumentData(from security: Security) -> InstrumentData {
        let price = parsePrice(from: security.price)
        let changeValue = parsePercentage(from: security.change)

        return InstrumentData(
            symbol: security.symbol,
            name: security.name,
            isin: "US0378331005",
            wkn: "865985",
            exchange: "NYSE",
            currentPrice: price,
            change: changeValue * price / 100,
            changePercent: changeValue,
            dayLow: price * 0.97,
            dayHigh: price * 1.03,
            weekLow52: price * 0.70,
            weekHigh52: price * 1.40,
            volume: Int.random(in: 5_000_000...50_000_000),
            marketCap: "500B",
            pe: 22.3,
            beta: 1.05,
            dividendYield: 1.42,
            nextEarningsDate: Date().addingTimeInterval(86400 * 60),
            bid: price - 0.03,
            ask: price + 0.03,
            lastUpdate: Date(),
            chartData: InstrumentData.generateSampleChartData(isPositive: security.isPositive),
            isPositive: security.isPositive
        )
    }

    // MARK: - WatchlistItem Conversions

    /// Converts a WatchlistItem to InstrumentData
    /// - Parameter item: The watchlist item to convert
    /// - Returns: InstrumentData with populated fields
    static func toInstrumentData(from item: WatchlistItem) -> InstrumentData {
        let price = parsePrice(from: item.price)
        let changeValue = parsePercentage(from: item.change)

        return InstrumentData(
            symbol: item.symbol,
            name: item.name,
            isin: "US0378331005",
            wkn: "865985",
            exchange: "XETRA",
            currentPrice: price,
            change: changeValue * price / 100,
            changePercent: changeValue,
            dayLow: price * 0.97,
            dayHigh: price * 1.03,
            weekLow52: price * 0.75,
            weekHigh52: price * 1.35,
            volume: Int.random(in: 1_000_000...50_000_000),
            marketCap: "1.23T",
            pe: 28.5,
            beta: 1.2,
            dividendYield: 1.85,
            nextEarningsDate: Date().addingTimeInterval(86400 * 30),
            bid: price - 0.05,
            ask: price + 0.05,
            lastUpdate: Date(),
            chartData: InstrumentData.generateSampleChartData(isPositive: item.isPositive),
            isPositive: item.isPositive
        )
    }

    // MARK: - NewsInstrument Conversions

    /// Converts a NewsInstrument (from news article) to InstrumentData
    /// - Parameter instrument: The news instrument to convert
    /// - Returns: InstrumentData with populated fields
    static func toInstrumentData(from instrument: NewsInstrument) -> InstrumentData {
        let price = parsePrice(from: instrument.price)
        let changeValue = parsePercentage(from: instrument.change)

        return InstrumentData(
            symbol: instrument.symbol,
            name: instrument.name,
            isin: "US0378331005",
            wkn: "865985",
            exchange: "NASDAQ",
            currentPrice: price,
            change: changeValue * price / 100,
            changePercent: changeValue,
            dayLow: price * 0.97,
            dayHigh: price * 1.03,
            weekLow52: price * 0.75,
            weekHigh52: price * 1.35,
            volume: Int.random(in: 100_000...10_000_000),
            marketCap: generateMarketCap(price: price),
            pe: Double.random(in: 15...35),
            beta: Double.random(in: 0.8...1.5),
            dividendYield: Double.random(in: 0.5...3.0),
            nextEarningsDate: Date().addingTimeInterval(86400 * 30),
            bid: price - 0.05,
            ask: price + 0.05,
            lastUpdate: Date(),
            chartData: InstrumentData.generateSampleChartData(isPositive: instrument.isPositive),
            isPositive: instrument.isPositive
        )
    }

    // MARK: - MarketInstrument Conversions

    /// Converts a MarketInstrument to InstrumentData
    /// - Parameter instrument: The market instrument to convert
    /// - Returns: InstrumentData with populated fields
    static func toInstrumentData(from instrument: MarketInstrument) -> InstrumentData {
        // Parse Preis-String (kann verschiedene Formate haben)
        let priceString = instrument.value
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: "€", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ".", with: "")

        let price = Double(priceString) ?? 10000.0
        let actualPrice = price > 10000 ? price / 100 : price

        let changeValue = parsePercentage(from: instrument.change)

        // Bestimme Symbol basierend auf Namen
        let symbol = instrumentNameToSymbol(instrument.name)

        return InstrumentData(
            symbol: symbol,
            name: instrument.name,
            isin: nil,
            wkn: nil,
            exchange: "XETRA",
            currentPrice: actualPrice,
            change: changeValue * actualPrice / 100,
            changePercent: changeValue,
            dayLow: actualPrice * 0.97,
            dayHigh: actualPrice * 1.03,
            weekLow52: actualPrice * 0.80,
            weekHigh52: actualPrice * 1.30,
            volume: Int.random(in: 5_000_000...100_000_000),
            marketCap: "N/A",
            pe: nil,
            beta: nil,
            dividendYield: nil,
            nextEarningsDate: nil,
            bid: actualPrice - 0.50,
            ask: actualPrice + 0.50,
            lastUpdate: Date(),
            chartData: InstrumentData.generateSampleChartData(isPositive: instrument.isPositive),
            isPositive: instrument.isPositive
        )
    }

    // MARK: - Helper Functions

    /// Parses a price string to Double
    /// Removes currency symbols and formatting
    /// - Parameter priceString: String like "$182.52" or "19,432.56"
    /// - Returns: Parsed price as Double
    private static func parsePrice(from priceString: String) -> Double {
        let cleaned = priceString
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: "€", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: " ", with: "")

        return Double(cleaned) ?? 100.0
    }

    /// Parses a percentage string to Double
    /// Removes % and + symbols
    /// - Parameter percentString: String like "+1.23%" or "-0.45%"
    /// - Returns: Parsed percentage as Double
    private static func parsePercentage(from percentString: String) -> Double {
        let cleaned = percentString
            .replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: "+", with: "")

        return Double(cleaned) ?? 0.0
    }

    /// Converts market name to trading symbol
    /// - Parameter name: Market name like "DAX" or "Bitcoin"
    /// - Returns: Trading symbol like "^DAX" or "BTC-USD"
    private static func marketNameToSymbol(_ name: String) -> String {
        switch name {
        case "DAX": return "^DAX"
        case "DOW JONES": return "^DJI"
        case "NASDAQ": return "^IXIC"
        case "EUR/USD": return "EURUSD=X"
        case "Bitcoin": return "BTC-USD"
        case "Gold": return "GC=F"
        default: return name
        }
    }

    /// Converts instrument name to symbol
    /// - Parameter name: Instrument name
    /// - Returns: Symbol string
    private static func instrumentNameToSymbol(_ name: String) -> String {
        switch name {
        case "DAX": return "^DAX"
        case "S&P 500": return "^GSPC"
        case "NASDAQ": return "^IXIC"
        case "FTSE 100": return "^FTSE"
        case "Bitcoin": return "BTC-USD"
        case "Ethereum": return "ETH-USD"
        case "Gold": return "GC=F"
        default:
            // Fallback: Nehme erstes Wort als Symbol
            return name.components(separatedBy: " ").first ?? name
        }
    }

    /// Generates a formatted market cap string
    /// - Parameter price: Stock price
    /// - Returns: Market cap string like "1.5B" or "500M"
    private static func generateMarketCap(price: Double) -> String {
        let marketCap = price * Double.random(in: 100_000_000...1_000_000_000)

        if marketCap >= 1_000_000_000 {
            return String(format: "%.1fB", marketCap / 1_000_000_000)
        } else {
            return String(format: "%.0fM", marketCap / 1_000_000)
        }
    }
}
