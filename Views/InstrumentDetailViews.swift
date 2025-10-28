//
//  InstrumentDetailViews.swift
//  FinanzNachrichten
//
//  Detail views for instrument profile sections
//

import SwiftUI

// MARK: - News Detail View
struct InstrumentNewsDetailView: View {
    let instrument: InstrumentData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.md) {
                    ForEach(0..<20) { index in
                        NewsListItem(
                            title: getNewsTitle(for: index),
                            category: getNewsSource(for: index),
                            time: "vor \(index + 1) Stunden",
                            imageUrl: nil
                        )
                        
                        if index < 19 {
                            DSSeparator()
                                .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                        }
                    }
                }
                .padding(.vertical, DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Nachrichten zu \(instrument.symbol)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func getNewsTitle(for index: Int) -> String {
        let titles = [
            "\(instrument.name) meldet Rekordumsatz im letzten Quartal",
            "Analysten erhöhen Kursziel für \(instrument.symbol)",
            "\(instrument.name) kündigt neue Produktlinie an",
            "Starke Nachfrage treibt \(instrument.symbol) Aktie",
            "\(instrument.name) übertrifft Gewinnerwartungen",
            "Neue Partnerschaft stärkt \(instrument.name) Position",
            "\(instrument.symbol): Positive Analystenkommentare",
            "\(instrument.name) expandiert in neue Märkte"
        ]
        return titles[index % titles.count]
    }
    
    private func getNewsSource(for index: Int) -> String {
        let sources = ["Reuters", "Bloomberg", "CNBC", "Financial Times", "Wall Street Journal", "Handelsblatt"]
        return sources[index % sources.count]
    }
}

// MARK: - Metrics Detail View
struct InstrumentMetricsDetailView: View {
    let instrument: InstrumentData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.Section.between) {
                    // Basic Metrics
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: 0) {
                            SectionHeader(title: "Handelsdaten")
                            
                            SimpleStatRow(title: "Aktueller Kurs", value: String(format: "%.2f", instrument.currentPrice))
                            SimpleStatRow(title: "Tageshoch", value: String(format: "%.2f", instrument.dayHigh))
                            SimpleStatRow(title: "Tagestief", value: String(format: "%.2f", instrument.dayLow))
                            SimpleStatRow(title: "52W Hoch", value: String(format: "%.2f", instrument.weekHigh52))
                            SimpleStatRow(title: "52W Tief", value: String(format: "%.2f", instrument.weekLow52))
                            SimpleStatRow(title: "Volumen", value: formatVolume(instrument.volume))
                            SimpleStatRow(title: "Ø Volumen (30T)", value: formatVolume(Int(Double(instrument.volume) * 0.85)))
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
                    // Valuation Metrics
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: 0) {
                            SectionHeader(title: "Bewertung")
                            
                            SimpleStatRow(title: "Marktkapitalisierung", value: instrument.marketCap)
                            SimpleStatRow(title: "KGV", value: String(format: "%.2f", instrument.pe))
                            SimpleStatRow(title: "Beta", value: String(format: "%.2f", instrument.beta))
                            SimpleStatRow(title: "Dividendenrendite", value: String(format: "%.2f%%", instrument.dividendYield))
                            SimpleStatRow(title: "EPS", value: String(format: "%.2f", instrument.currentPrice / instrument.pe))
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
                    // Trading Info
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: 0) {
                            SectionHeader(title: "Handelsinfo")
                            
                            SimpleStatRow(title: "Geld", value: String(format: "%.2f", instrument.bid))
                            SimpleStatRow(title: "Brief", value: String(format: "%.2f", instrument.ask))
                            SimpleStatRow(title: "Spread", value: String(format: "%.2f", instrument.ask - instrument.bid))
                            SimpleStatRow(title: "Börse", value: instrument.exchange)
                            SimpleStatRow(title: "Währung", value: "EUR")
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                }
                .padding(.vertical, DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Kennzahlen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func formatVolume(_ volume: Int) -> String {
        if volume >= 1_000_000 {
            return String(format: "%.1fM", Double(volume) / 1_000_000)
        } else if volume >= 1_000 {
            return String(format: "%.1fK", Double(volume) / 1_000)
        } else {
            return "\(volume)"
        }
    }
}

// MARK: - Analysis Detail View
struct InstrumentAnalysisDetailView: View {
    let instrument: InstrumentData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.Section.between) {
                    // Analyst Ratings
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            SectionHeader(title: "Analystenempfehlungen")
                            
                            HStack(spacing: DesignSystem.Spacing.xl) {
                                VStack {
                                    Text("KAUFEN")
                                        .font(DesignSystem.Typography.title1)
                                        .foregroundColor(DesignSystem.Colors.success)
                                    Text("Konsens")
                                        .font(DesignSystem.Typography.caption1)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    HStack(spacing: 2) {
                                        ForEach(0..<5) { index in
                                            Image(systemName: index < 4 ? "star.fill" : "star")
                                                .font(.system(size: 16))
                                                .foregroundColor(DesignSystem.Colors.primary)
                                        }
                                    }
                                    Text("4.2/5.0")
                                        .font(DesignSystem.Typography.caption1)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                }
                            }
                            
                            DSSeparator()
                            
                            // Rating Distribution
                            VStack(spacing: DesignSystem.Spacing.sm) {
                                RatingRow(rating: "Starker Kauf", count: 8, total: 20, color: DesignSystem.Colors.success)
                                RatingRow(rating: "Kauf", count: 7, total: 20, color: Color.green.opacity(0.8))
                                RatingRow(rating: "Halten", count: 3, total: 20, color: DesignSystem.Colors.warning)
                                RatingRow(rating: "Verkauf", count: 1, total: 20, color: Color.orange)
                                RatingRow(rating: "Starker Verkauf", count: 1, total: 20, color: DesignSystem.Colors.error)
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
                    // Price Targets
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            SectionHeader(title: "Kursziele")
                            
                            VStack(spacing: DesignSystem.Spacing.md) {
                                HStack {
                                    Text("Durchschnitt")
                                        .font(DesignSystem.Typography.body2)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                    Spacer()
                                    Text(String(format: "%.2f €", instrument.currentPrice * 1.15))
                                        .font(DesignSystem.Typography.headline)
                                        .foregroundColor(DesignSystem.Colors.onCard)
                                }
                                
                                HStack {
                                    Text("Höchstes")
                                        .font(DesignSystem.Typography.body2)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                    Spacer()
                                    Text(String(format: "%.2f €", instrument.currentPrice * 1.35))
                                        .font(DesignSystem.Typography.body1)
                                        .foregroundColor(DesignSystem.Colors.success)
                                }
                                
                                HStack {
                                    Text("Niedrigstes")
                                        .font(DesignSystem.Typography.body2)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                    Spacer()
                                    Text(String(format: "%.2f €", instrument.currentPrice * 0.95))
                                        .font(DesignSystem.Typography.body1)
                                        .foregroundColor(DesignSystem.Colors.error)
                                }
                                
                                HStack {
                                    Text("Potenzial")
                                        .font(DesignSystem.Typography.body2)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                    Spacer()
                                    Text("+15%")
                                        .font(DesignSystem.Typography.body1)
                                        .foregroundColor(DesignSystem.Colors.success)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
                    // Performance
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            SectionHeader(title: "Performance")
                            
                            VStack(spacing: DesignSystem.Spacing.md) {
                                PerformanceRow(period: "1 Tag", value: 0.5, isPositive: true)
                                PerformanceRow(period: "1 Woche", value: 2.1, isPositive: true)
                                PerformanceRow(period: "1 Monat", value: -1.3, isPositive: false)
                                PerformanceRow(period: "3 Monate", value: 12.5, isPositive: true)
                                PerformanceRow(period: "YTD", value: 45.2, isPositive: true)
                                PerformanceRow(period: "1 Jahr", value: 67.8, isPositive: true)
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                }
                .padding(.vertical, DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Analysen & Performance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Market Data Detail View
struct InstrumentMarketDataDetailView: View {
    let instrument: InstrumentData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.Section.between) {
                    // Order Book
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            SectionHeader(title: "Orderbuch")
                            
                            HStack(spacing: DesignSystem.Spacing.xl) {
                                // Bid Side
                                VStack(alignment: .leading) {
                                    Text("Geld")
                                        .font(DesignSystem.Typography.caption1)
                                        .foregroundColor(DesignSystem.Colors.success)
                                    
                                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                        ForEach(0..<5) { index in
                                            HStack {
                                                Text(String(format: "%.2f", instrument.bid - Double(index) * 0.05))
                                                    .font(DesignSystem.Typography.caption2)
                                                Spacer()
                                                Text("\(1000 + index * 200)")
                                                    .font(DesignSystem.Typography.caption2)
                                                    .foregroundColor(DesignSystem.Colors.secondary)
                                            }
                                        }
                                    }
                                }
                                
                                // Ask Side
                                VStack(alignment: .trailing) {
                                    Text("Brief")
                                        .font(DesignSystem.Typography.caption1)
                                        .foregroundColor(DesignSystem.Colors.error)
                                    
                                    VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                                        ForEach(0..<5) { index in
                                            HStack {
                                                Text("\(800 + index * 150)")
                                                    .font(DesignSystem.Typography.caption2)
                                                    .foregroundColor(DesignSystem.Colors.secondary)
                                                Spacer()
                                                Text(String(format: "%.2f", instrument.ask + Double(index) * 0.05))
                                                    .font(DesignSystem.Typography.caption2)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
                    // Trading Statistics
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: 0) {
                            SectionHeader(title: "Handelsstatistik")
                            
                            SimpleStatRow(title: "Eröffnung", value: String(format: "%.2f", instrument.currentPrice * 0.98))
                            SimpleStatRow(title: "Vortagesschluss", value: String(format: "%.2f", instrument.currentPrice - instrument.change))
                            SimpleStatRow(title: "Handelsvolumen", value: formatVolume(instrument.volume))
                            SimpleStatRow(title: "Handelsumsatz", value: formatCurrency(Double(instrument.volume) * instrument.currentPrice))
                            SimpleStatRow(title: "Anzahl Trades", value: "\(instrument.volume / 100)")
                            SimpleStatRow(title: "VWAP", value: String(format: "%.2f", instrument.currentPrice * 0.995))
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
                    // Historical Data
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            SectionHeader(title: "Historische Daten")
                            
                            Text("Detaillierte historische Kursdaten und Charts")
                                .font(DesignSystem.Typography.body2)
                                .foregroundColor(DesignSystem.Colors.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, DesignSystem.Spacing.xl)
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                }
                .padding(.vertical, DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Marktdaten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func formatVolume(_ volume: Int) -> String {
        if volume >= 1_000_000 {
            return String(format: "%.1fM", Double(volume) / 1_000_000)
        } else if volume >= 1_000 {
            return String(format: "%.1fK", Double(volume) / 1_000)
        } else {
            return "\(volume)"
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        if value >= 1_000_000_000 {
            return String(format: "%.1f Mrd. €", value / 1_000_000_000)
        } else if value >= 1_000_000 {
            return String(format: "%.1f Mio. €", value / 1_000_000)
        } else {
            return String(format: "%.0f €", value)
        }
    }
}

// MARK: - Helper Views
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(DesignSystem.Typography.headline)
                .foregroundColor(DesignSystem.Colors.onCard)
            Spacer()
        }
        .padding(.bottom, DesignSystem.Spacing.sm)
    }
}

struct RatingRow: View {
    let rating: String
    let count: Int
    let total: Int
    let color: Color
    
    var body: some View {
        HStack {
            Text(rating)
                .font(DesignSystem.Typography.caption1)
                .foregroundColor(DesignSystem.Colors.secondary)
                .frame(width: 100, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(DesignSystem.Colors.separator)
                        .frame(height: 4)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(count) / CGFloat(total), height: 4)
                }
            }
            .frame(height: 4)
            
            Text("\(count)")
                .font(DesignSystem.Typography.caption2)
                .foregroundColor(DesignSystem.Colors.secondary)
                .frame(width: 20, alignment: .trailing)
        }
    }
}

struct PerformanceRow: View {
    let period: String
    let value: Double
    let isPositive: Bool
    
    var body: some View {
        HStack {
            Text(period)
                .font(DesignSystem.Typography.body2)
                .foregroundColor(DesignSystem.Colors.secondary)
            
            Spacer()
            
            HStack(spacing: DesignSystem.Spacing.xs) {
                Text(String(format: "%+.2f%%", value))
                    .font(DesignSystem.Typography.body1)
                    .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                
                Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                    .font(.system(size: 10))
                    .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
            }
        }
    }
}

struct SimpleStatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(DesignSystem.Typography.body2)
                    .foregroundColor(DesignSystem.Colors.secondary)
                Spacer()
                Text(value)
                    .font(DesignSystem.Typography.body1)
                    .foregroundColor(DesignSystem.Colors.onCard)
            }
            .padding(.vertical, DesignSystem.Spacing.md)
            
            DSSeparator()
        }
    }
}