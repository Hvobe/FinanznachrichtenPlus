//
//  AddStockView.swift
//  FinanzNachrichten
//
//  Created on 03.07.2025
//

import SwiftUI

// MARK: - Stock Logo Helper Functions

func stockLogo(for symbol: String, size: CGFloat) -> some View {
    let (bgColor, fgColor, text) = getLogoStyle(for: symbol)
    
    return Circle()
        .fill(bgColor)
        .frame(width: size, height: size)
        .overlay(
            Text(text)
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundColor(fgColor)
        )
}

func getLogoStyle(for symbol: String) -> (Color, Color, String) {
    let grayColor = Color.gray.opacity(0.7)
    switch symbol {
    case "AAPL": return (grayColor, .white, "A")
    case "NVDA": return (grayColor, .white, "N")
    case "TSLA": return (grayColor, .white, "T")
    case "MSFT": return (grayColor, .white, "M")
    case "AMZN": return (grayColor, .white, "A")
    case "GOOGL": return (grayColor, .white, "G")
    case "META": return (grayColor, .white, "M")
    case "NFLX": return (grayColor, .white, "N")
    case "DIS": return (grayColor, .white, "D")
    case "BMW": return (grayColor, .white, "B")
    case "SAP": return (grayColor, .white, "S")
    case "SIE": return (grayColor, .white, "S")
    case "VOW3": return (grayColor, .white, "V")
    case "BAS": return (grayColor, .white, "B")
    case "ALV": return (grayColor, .white, "A")
    case "DBK": return (grayColor, .white, "D")
    case "EONGY", "EOAN": return (grayColor, .white, "E")
    case "BTC": return (grayColor, .white, "B")
    case "ETH": return (grayColor, .white, "E")
    case "GLD": return (grayColor, .white, "G")
    default: 
        let firstChar = String(symbol.prefix(1))
        return (grayColor, .white, firstChar)
    }
}

func marketInstrumentNameToSymbol(_ name: String) -> String {
    switch name {
    case "Apple Inc.": return "AAPL"
    case "Microsoft Corp.": return "MSFT"
    case "NVIDIA Corp.": return "NVDA"
    case "Tesla Inc.": return "TSLA"
    case "Amazon.com Inc.": return "AMZN"
    case "Alphabet Inc.": return "GOOGL"
    case "Meta Platforms Inc.": return "META"
    case "Siemens AG": return "SIE"
    case "Volkswagen AG": return "VOW3"
    case "BASF SE": return "BAS"
    case "Allianz SE": return "ALV"
    case "Deutsche Bank AG": return "DBK"
    case "SAP SE": return "SAP"
    case "BMW AG": return "BMW"
    case "E.ON SE": return "EOAN"
    case "Bitcoin": return "BTC"
    case "Ethereum": return "ETH"
    case "Gold": return "GLD"
    default: return String(name.prefix(3).uppercased())
    }
}

// MARK: - Watchlist Item Row

struct WatchlistItemRow: View {
    let item: WatchlistItem
    let onRemove: () -> Void
    @State private var showingRemoveAlert = false
    @State private var showingInstrument = false
    
    var body: some View {
        Button(action: {
            showingInstrument = true
        }) {
            HStack {
                // Stock logo
                stockLogo(for: item.symbol, size: 40)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(item.symbol)
                        .font(DesignSystem.Typography.headline)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .fontWeight(.bold)
                    Text(item.name)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                    Text(item.price)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .fontWeight(.bold)
                    
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Text(item.change)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(item.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                        Text(item.changePercent)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(item.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                        Image(systemName: item.isPositive ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 10))
                            .foregroundColor(item.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.cardBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onRemove()
            } label: {
                Label("Entfernen", systemImage: "trash")
            }
        }
        .fullScreenCover(isPresented: $showingInstrument) {
            InstrumentView(instrument: convertWatchlistItemToInstrumentData(from: item))
        }
    }
    
    private func convertWatchlistItemToInstrumentData(from watchlistItem: WatchlistItem) -> InstrumentData {
        let price = Double(watchlistItem.price.replacingOccurrences(of: "$", with: "")) ?? 100.0
        let changeValue = Double(watchlistItem.change.replacingOccurrences(of: "+", with: "")) ?? 0.0
        let changePercent = Double(watchlistItem.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0.0
        
        return InstrumentData(
            symbol: watchlistItem.symbol,
            name: watchlistItem.name,
            isin: "US0378331005", // Sample ISIN
            wkn: "865985", // Sample WKN
            exchange: "NYSE",
            currentPrice: price,
            change: changeValue,
            changePercent: changePercent,
            dayLow: price * 0.97,
            dayHigh: price * 1.03,
            weekLow52: price * 0.75,
            weekHigh52: price * 1.35,
            volume: Int.random(in: 100_000...10_000_000),
            marketCap: generateMarketCapForWatchlistStock(price: price),
            pe: Double.random(in: 15...35),
            beta: Double.random(in: 0.8...1.5),
            dividendYield: Double.random(in: 0.5...3.0),
            nextEarningsDate: Date().addingTimeInterval(86400 * Double.random(in: 30...90)),
            bid: price - 0.05,
            ask: price + 0.05,
            lastUpdate: Date(),
            chartData: InstrumentData.generateSampleChartData(isPositive: watchlistItem.isPositive),
            isPositive: watchlistItem.isPositive
        )
    }
    
    private func generateMarketCapForWatchlistStock(price: Double) -> String {
        let marketCap = price * Double.random(in: 100_000_000...1_000_000_000)
        if marketCap >= 1_000_000_000 {
            return String(format: "%.1fB", marketCap / 1_000_000_000)
        } else {
            return String(format: "%.0fM", marketCap / 1_000_000)
        }
    }
}

// MARK: - Add Stock View

struct AddStockView: View {
    @Binding var isPresented: Bool
    let onAdd: (String, String) -> Void
    @State private var searchText = ""
    
    let stockSuggestions = [
        ("AAPL", "Apple Inc."),
        ("MSFT", "Microsoft Corp."),
        ("GOOGL", "Alphabet Inc."),
        ("AMZN", "Amazon.com Inc."),
        ("TSLA", "Tesla Inc."),
        ("META", "Meta Platforms Inc."),
        ("NVDA", "NVIDIA Corp."),
        ("NFLX", "Netflix Inc.")
    ]
    
    var filteredSuggestions: [(String, String)] {
        if searchText.isEmpty {
            return stockSuggestions
        } else {
            return stockSuggestions.filter { suggestion in
                suggestion.0.lowercased().contains(searchText.lowercased()) ||
                suggestion.1.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                // Search Field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(DesignSystem.Colors.secondary)
                    
                    TextField("Aktie oder Symbol suchen...", text: $searchText)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(DesignSystem.Spacing.md)
                .background(DesignSystem.Colors.surface)
                .cornerRadius(DesignSystem.CornerRadius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                        .stroke(DesignSystem.Colors.border, lineWidth: 1)
                )
                
                // Stock Suggestions
                Text("Vorschläge")
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.onBackground)
                
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.md) {
                        ForEach(filteredSuggestions, id: \.0) { suggestion in
                            Button(action: {
                                onAdd(suggestion.0, suggestion.1)
                                isPresented = false
                            }) {
                                HStack {
                                    // Stock logo
                                    stockLogo(for: suggestion.0, size: 40)
                                    
                                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                        Text(suggestion.0)
                                            .font(DesignSystem.Typography.headline)
                                            .foregroundColor(DesignSystem.Colors.onCard)
                                            .fontWeight(.bold)
                                        Text(suggestion.1)
                                            .font(DesignSystem.Typography.body2)
                                            .foregroundColor(DesignSystem.Colors.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "plus.circle")
                                        .font(.system(size: 20))
                                        .foregroundColor(DesignSystem.Colors.primary)
                                }
                                .padding(DesignSystem.Spacing.lg)
                                .background(DesignSystem.Colors.cardBackground)
                                .cornerRadius(DesignSystem.CornerRadius.lg)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                                        .stroke(DesignSystem.Colors.border, lineWidth: 1)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                Spacer()
            }
            .padding(DesignSystem.Spacing.lg)
            .background(DesignSystem.Colors.background)
            .navigationTitle("Aktie hinzufügen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        isPresented = false
                    }
                }
            }
        }
    }
}