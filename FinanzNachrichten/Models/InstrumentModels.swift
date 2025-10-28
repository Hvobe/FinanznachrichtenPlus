//
//  InstrumentModels.swift
//  FinanzNachrichten
//
//  Models for financial instruments and chart data
//

import SwiftUI

// MARK: - Instrument Data Model

struct InstrumentData {
    let id = UUID()
    let symbol: String
    let name: String
    let currentPrice: Double
    let change: Double
    let changePercent: Double
    let dayLow: Double
    let dayHigh: Double
    let volume: Int
    let marketCap: String
    let pe: Double?
    let chartData: [ChartPoint]
    let isPositive: Bool
    
    struct ChartPoint {
        let time: Date
        let value: Double
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