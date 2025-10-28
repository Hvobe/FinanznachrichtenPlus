import SwiftUI

// MARK: - InstrumentData model has been moved to Models/InstrumentModels.swift

struct ChartDataPoint {
    let id = UUID()
    let timestamp: Date
    let price: Double
}

struct KeyMetric {
    let title: String
    let value: String
    let subtitle: String?
}

// MARK: - Main Instrument View

struct InstrumentView: View {
    let instrument: InstrumentData
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTimeRange = 0
    @EnvironmentObject var watchlistService: WatchlistService
    @State private var showingAddedAlert = false
    
    let timeRanges = ["1T", "1W", "1M", "3M", "1J", "5J"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                        HStack {
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                Text(instrument.symbol)
                                    .font(DesignSystem.Typography.title1)
                                    .foregroundColor(DesignSystem.Colors.onBackground)
                                Text(instrument.name)
                                    .font(DesignSystem.Typography.body2)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if watchlistService.isInWatchlist(symbol: instrument.symbol) {
                                    watchlistService.removeFromWatchlist(symbol: instrument.symbol)
                                } else {
                                    watchlistService.addToWatchlist(
                                        symbol: instrument.symbol,
                                        name: instrument.name,
                                        price: instrument.currentPrice,
                                        change: instrument.change,
                                        changePercent: instrument.changePercent,
                                        isPositive: instrument.isPositive
                                    )
                                    showingAddedAlert = true
                                    
                                    // Hide alert after 2 seconds
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showingAddedAlert = false
                                    }
                                }
                            }) {
                                Image(systemName: watchlistService.isInWatchlist(symbol: instrument.symbol) ? "bookmark.fill" : "bookmark")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(watchlistService.isInWatchlist(symbol: instrument.symbol) ? DesignSystem.Colors.primary : DesignSystem.Colors.secondary)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                            .fill(DesignSystem.Colors.surface)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
                                            )
                                    )
                            }
                        }
                        
                        HStack(alignment: .bottom) {
                            Text(String(format: "%.2f", instrument.currentPrice))
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(DesignSystem.Colors.onBackground)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: DesignSystem.Spacing.xs) {
                                    Image(systemName: instrument.isPositive ? "arrow.up" : "arrow.down")
                                        .font(.system(size: 12))
                                    Text(String(format: "%.2f (%.2f%%)", instrument.change, instrument.changePercent))
                                        .font(DesignSystem.Typography.body1)
                                }
                                .foregroundColor(instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    .padding(.top, DesignSystem.Spacing.Page.top)
                    
                    // Chart
                    VStack(spacing: DesignSystem.Spacing.Section.withinSection) {
                        // Time range selector
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: DesignSystem.Spacing.md) {
                                ForEach(Array(timeRanges.enumerated()), id: \.offset) { index, range in
                                    Button(action: {
                                        selectedTimeRange = index
                                    }) {
                                        Text(range)
                                            .font(DesignSystem.Typography.body2)
                                            .foregroundColor(selectedTimeRange == index ? .white : DesignSystem.Colors.secondary)
                                            .padding(.horizontal, DesignSystem.Spacing.md)
                                            .padding(.vertical, DesignSystem.Spacing.xs)
                                            .background(selectedTimeRange == index ? DesignSystem.Colors.primary : DesignSystem.Colors.surface)
                                            .cornerRadius(DesignSystem.CornerRadius.md)
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                        }
                        
                        // Chart placeholder
                        ZStack {
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                                .fill(DesignSystem.Colors.surface)
                                .frame(height: 200)
                            
                            // Simple line chart visualization
                            GeometryReader { geometry in
                                Path { path in
                                    let points = instrument.chartData
                                    guard !points.isEmpty else { return }
                                    
                                    let minValue = points.map { $0.value }.min() ?? 0
                                    let maxValue = points.map { $0.value }.max() ?? 100
                                    let valueRange = maxValue - minValue
                                    
                                    for (index, point) in points.enumerated() {
                                        let x = CGFloat(index) / CGFloat(points.count - 1) * geometry.size.width
                                        let y = (1 - CGFloat((point.value - minValue) / valueRange)) * geometry.size.height
                                        
                                        if index == 0 {
                                            path.move(to: CGPoint(x: x, y: y))
                                        } else {
                                            path.addLine(to: CGPoint(x: x, y: y))
                                        }
                                    }
                                }
                                .stroke(instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error, lineWidth: 2)
                            }
                            .padding()
                        }
                        .frame(height: 200)
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    }
                    .padding(.top, DesignSystem.Spacing.Section.between)
                    
                    // Key Stats
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                        Text("Kennzahlen")
                            .font(DesignSystem.Typography.title3)
                            .foregroundColor(DesignSystem.Colors.onBackground)
                        
                        DSCard(
                            backgroundColor: DesignSystem.Colors.cardBackground,
                            borderColor: DesignSystem.Colors.border,
                            cornerRadius: DesignSystem.CornerRadius.lg,
                            padding: DesignSystem.Spacing.lg,
                            hasShadow: true
                        ) {
                            VStack(spacing: DesignSystem.Spacing.md) {
                                StatRow(title: "Tageshoch", value: String(format: "%.2f", instrument.dayHigh))
                                DSSeparator()
                                StatRow(title: "Tagestief", value: String(format: "%.2f", instrument.dayLow))
                                DSSeparator()
                                StatRow(title: "Volumen", value: formatVolume(instrument.volume))
                                DSSeparator()
                                StatRow(title: "Marktkapitalisierung", value: instrument.marketCap)
                                if let pe = instrument.pe {
                                    DSSeparator()
                                    StatRow(title: "KGV", value: String(format: "%.2f", pe))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    .padding(.top, DesignSystem.Spacing.Section.between)
                    
                    // News Section
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                        Text("Aktuelle Nachrichten")
                            .font(DesignSystem.Typography.title3)
                            .foregroundColor(DesignSystem.Colors.onBackground)
                        
                        DSCard(
                            backgroundColor: DesignSystem.Colors.cardBackground,
                            borderColor: DesignSystem.Colors.border,
                            cornerRadius: DesignSystem.CornerRadius.lg,
                            padding: DesignSystem.Spacing.lg,
                            hasShadow: true
                        ) {
                            VStack(spacing: 0) {
                                ForEach(0..<3) { index in
                                    NewsListItem(
                                        title: "Beispiel Nachricht zu \(instrument.symbol)",
                                        category: "Analyse",
                                        time: "vor \(index + 1) Stunden"
                                    )
                                    
                                    if index < 2 {
                                        DSSeparator()
                                            .padding(.vertical, DesignSystem.Spacing.md)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    .padding(.top, DesignSystem.Spacing.Section.between)
                    .padding(.bottom, DesignSystem.Spacing.Page.bottom)
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(DesignSystem.Colors.onBackground)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Share action
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(DesignSystem.Colors.onBackground)
                    }
                }
            }
        }
        .overlay(
            // Success notification
            showingAddedAlert ? 
            VStack {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                    Text("Zu Watchlist hinzugefügt")
                        .font(DesignSystem.Typography.body2)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.vertical, DesignSystem.Spacing.md)
                .background(DesignSystem.Colors.success)
                .cornerRadius(DesignSystem.CornerRadius.md)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                .padding(.top, 50)
                
                Spacer()
            }
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.easeInOut(duration: 0.3), value: showingAddedAlert)
            : nil
        )
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

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(DesignSystem.Typography.body2)
                .foregroundColor(DesignSystem.Colors.secondary)
            
            Spacer()
            
            Text(value)
                .font(DesignSystem.Typography.body1)
                .foregroundColor(DesignSystem.Colors.onCard)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Preview

struct InstrumentView_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentView(
            instrument: InstrumentData(
                symbol: "AAPL",
                name: "Apple Inc.",
                currentPrice: 182.52,
                change: 2.24,
                changePercent: 1.23,
                dayLow: 180.12,
                dayHigh: 183.45,
                volume: 52_345_678,
                marketCap: "2.89T",
                pe: 29.45,
                chartData: InstrumentData.generateSampleChartData(isPositive: true),
                isPositive: true
            )
        )
    }
}