//
//  InstrumentModels.swift
//  FinanzNachrichten
//
//  Datenmodelle für Finanzinstrumente und Chart-Darstellung
//
//  ENTHÄLT:
//  - InstrumentData: Vollständiges Finanzinstrument-Model für Detail-Ansicht
//  - ChartType: Chart-Darstellungstypen (Line, Area, Candle, OHLC, Percent)
//  - ChartDataPoint: Einzelner Datenpunkt für Chart-Visualisierung
//

import SwiftUI

// MARK: - Chart Type

/// Chart display types for financial data visualization
enum ChartType: String, CaseIterable {
    case line = "Line"
    case area = "Area"
    case candle = "Candle"
    case ohlc = "OHLC"
    case percent = "%"

    var icon: String {
        switch self {
        case .line: return "chart.line.uptrend.xyaxis"
        case .area: return "chart.xyaxis.line"
        case .candle: return "chart.bar"
        case .ohlc: return "chart.bar.xaxis"
        case .percent: return "percent"
        }
    }
}

// MARK: - Instrument Data Model

struct InstrumentData {
    let id = UUID()
    let symbol: String
    let name: String
    let isin: String?
    let wkn: String?
    let exchange: String?
    let currentPrice: Double
    let change: Double
    let changePercent: Double
    let dayLow: Double
    let dayHigh: Double
    let weekLow52: Double?
    let weekHigh52: Double?
    let volume: Int
    let marketCap: String
    let pe: Double?
    let beta: Double?
    let dividendYield: Double?
    let nextEarningsDate: Date?
    let bid: Double?
    let ask: Double?
    let lastUpdate: Date?
    let chartData: [ChartPoint]
    let isPositive: Bool
    
    struct ChartPoint {
        let time: Date
        let value: Double
        let open: Double?
        let high: Double?
        let low: Double?
        let close: Double?

        init(time: Date, value: Double, open: Double? = nil, high: Double? = nil, low: Double? = nil, close: Double? = nil) {
            self.time = time
            self.value = value
            self.open = open
            self.high = high
            self.low = low
            self.close = close
        }
    }
    
    var formattedPrice: String {
        return String(format: "%.2f €", currentPrice)
    }
    
    var formattedChange: String {
        let sign = isPositive ? "+" : ""
        return "\(sign)\(String(format: "%.2f", change))"
    }
    
    var formattedChangePercent: String {
        let sign = isPositive ? "+" : ""
        return "\(sign)\(String(format: "%.2f", changePercent))%"
    }
    
    static func generateSampleChartData(isPositive: Bool) -> [ChartPoint] {
        var points: [ChartPoint] = []
        let baseValue = 100.0
        let now = Date()
        
        for i in 0..<50 {
            let time = now.addingTimeInterval(TimeInterval(-3600 * (50 - i)))
            let randomChange = Double.random(in: -2...2)
            let trend = isPositive ? Double(i) * 0.1 : Double(i) * -0.05
            let value = baseValue + trend + randomChange
            points.append(ChartPoint(time: time, value: value))
        }
        
        return points
    }
}