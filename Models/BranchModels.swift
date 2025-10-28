//
//  BranchModels.swift
//  FinanzNachrichten
//
//  WARNUNG: Diese Datei enthält DUPLIKATE!
//  Branch-Model ist auch in MarketModels.swift definiert (dort die aktive Version)
//  Diese Datei sollte ggf. entfernt oder konsolidiert werden
//
//  ENTHÄLT:
//  - Branch: Branchen-Model (DUPLIZIERT mit MarketModels.swift)
//  - BranchNewsType, AnalystRating: Branchen-spezifische Enums
//

import SwiftUI
import Foundation

// MARK: - Branch Data Model

/// Industry branch model (DUPLICATE - see MarketModels.swift for active version)
struct Branch {
    let id = UUID()
    let name: String
    let color: Color
    let stocks: [WatchlistItem]

    var topPerformers: [WatchlistItem] {
        stocks.sorted { item1, item2 in
            let percent1 = Double(item1.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            let percent2 = Double(item2.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            return percent1 > percent2
        }
    }

    var worstPerformers: [WatchlistItem] {
        stocks.sorted { item1, item2 in
            let percent1 = Double(item1.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            let percent2 = Double(item2.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            return percent1 < percent2
        }
    }

    var dividendStocks: [WatchlistItem] {
        // Mock dividend ranking - in real app would be sorted by actual dividend yield
        stocks.shuffled().prefix(5).map { $0 }
    }
}

// MARK: - Branch News Types

enum BranchNewsType: String, CaseIterable {
    case allNews = "Alle News"
    case pressReleases = "Pressemitteilungen"
    case chartAnalyses = "Chartanalysen"
    case reports = "Berichte"
}

// MARK: - Analyst Ratings

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

enum BranchStockCategory: String, CaseIterable {
    case topFlop = "Top / Flop - Werte"
    case potential = "Aktien nach Potenzial"
    case focus = "Aktien im Blickpunkt"
    case dividend = "Aktien nach Dividendenrendite"

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