//
//  MarketComponents.swift
//  FinanzNachrichten
//
//  Markt-bezogene UI-Komponenten für Finanzinstrumente und Marktdaten
//  Cards für Märkte, Securities, Watchlist-Items, etc.
//

import SwiftUI

// MARK: - DS Market Card

/// Market overview card displaying index/commodity/forex data
/// Tappable to view full instrument details
struct DSMarketCard: View {
    let market: MarketCard
    @State private var showingInstrument = false
    
    var body: some View {
        Button(action: {
            showingInstrument = true
        }) {
            DSCard(
                backgroundColor: DesignSystem.Colors.cardBackground,
                borderColor: DesignSystem.Colors.border,
                cornerRadius: DesignSystem.CornerRadius.xl,
                padding: DesignSystem.Spacing.lg,
                hasShadow: true
            ) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    HStack {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                            Text(market.name)
                                .font(DesignSystem.Typography.cardTitle)
                                .foregroundColor(DesignSystem.Colors.secondary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Text(market.value)
                                .font(DesignSystem.Typography.cardValue)
                                .foregroundColor(DesignSystem.Colors.onCard)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer(minLength: 0)
                    }
                    
                    HStack {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(market.isPositive ? DesignSystem.Colors.success.opacity(0.12) : DesignSystem.Colors.error.opacity(0.12))
                                .frame(width: 6, height: 12)
                            
                            Text(market.change)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(market.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                        }
                        
                        Spacer()
                        
                        Image(systemName: market.isPositive ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(market.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingInstrument) {
            // Nutze DataMapper für Type-Conversion
            InstrumentView(instrument: DataMapper.toInstrumentData(from: market))
        }
    }
}

// MARK: - Watchlist Teaser Card

/// Compact watchlist item card for horizontal scrolling
/// Used in top performers section on HomeView
struct WatchlistTeaserCard: View {
    let symbol: String
    let name: String
    let price: String
    let change: String
    let isPositive: Bool
    @State private var showingInstrument = false
    
    var body: some View {
        Button(action: {
            showingInstrument = true
        }) {
            DSCard(
                backgroundColor: DesignSystem.Colors.cardBackground,
                borderColor: DesignSystem.Colors.border,
                cornerRadius: DesignSystem.CornerRadius.lg,
                padding: DesignSystem.Spacing.md,
                hasShadow: true
            ) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    HStack {
                        Text(symbol)
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                        
                        Spacer()
                        
                        Text(change)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    Text(name)
                        .font(DesignSystem.Typography.body2)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(price)
                        .font(.system(size: 10))
                        .foregroundColor(DesignSystem.Colors.onCard.opacity(0.8))
                        .fontWeight(.medium)
                }
            }
            .frame(width: 150, height: 80)
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingInstrument) {
            // Erstelle temporäres WatchlistItem für DataMapper
            let item = WatchlistItem(
                symbol: symbol,
                name: name,
                price: price,
                change: change,
                changePercent: change,
                isPositive: isPositive
            )
            InstrumentView(instrument: DataMapper.toInstrumentData(from: item))
        }
    }
}

// MARK: - Market Movement Row

/// Row component for displaying market movers (top/bottom performers)
/// Shows company name, symbol, and performance indicator
struct MarketMovementRow: View {
    let title: String
    let companyName: String
    let change: String
    let symbol: String
    let isPositive: Bool
    @State private var showingInstrument = false
    
    var body: some View {
        Button(action: {
            showingInstrument = true
        }) {
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(title)
                        .font(DesignSystem.Typography.body2)
                        .foregroundColor(DesignSystem.Colors.secondary)
                    Text(companyName)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.semibold)
                    Text(change)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                }
                Spacer()
                Image(systemName: isPositive ? "arrow.up.right.circle.fill" : "arrow.down.right.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingInstrument) {
            // Erstelle temporäres WatchlistItem für DataMapper
            // Mock-Preis basiert auf Symbol (für Demo-Zwecke)
            let basePrice = symbol == "AAPL" ? 182.52 : 234.67
            let item = WatchlistItem(
                symbol: symbol,
                name: companyName,
                price: "$\(String(format: "%.2f", basePrice))",
                change: change,
                changePercent: change,
                isPositive: isPositive
            )
            InstrumentView(instrument: DataMapper.toInstrumentData(from: item))
        }
    }
}

// MARK: - Security Row

/// List row component for displaying securities (stocks, ETFs)
/// Shows name, symbol, current price, and price change
struct SecurityRow: View {
    let security: Security
    @State private var showingInstrument = false
    
    var body: some View {
        Button(action: {
            showingInstrument = true
        }) {
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(security.name)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.medium)
                    Text(security.symbol)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                    Text(security.price)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.semibold)
                    Text(security.change)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(security.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingInstrument) {
            // Nutze DataMapper für Type-Conversion
            InstrumentView(instrument: DataMapper.toInstrumentData(from: security))
        }
    }
}

// MARK: - Market Instrument Row

/// Card row component for displaying market instruments (indices, commodities, forex)
/// Shows instrument name, current value, and change percentage with trend indicator
struct MarketInstrumentRow: View {
    let instrument: MarketInstrument
    @State private var showingInstrument = false
    
    var body: some View {
        Button(action: {
            showingInstrument = true
        }) {
            DSCard(
                backgroundColor: DesignSystem.Colors.cardBackground,
                borderColor: DesignSystem.Colors.border,
                cornerRadius: DesignSystem.CornerRadius.lg,
                padding: DesignSystem.Spacing.lg,
                hasShadow: true
            ) {
                HStack {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        Text(instrument.name)
                            .font(DesignSystem.Typography.body1)
                            .foregroundColor(DesignSystem.Colors.onCard)
                            .fontWeight(.medium)
                        Text(instrument.value)
                            .font(DesignSystem.Typography.body2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                        Text(instrument.change)
                            .font(DesignSystem.Typography.body1)
                            .foregroundColor(instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                            .fontWeight(.semibold)
                        Image(systemName: instrument.isPositive ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 12))
                            .foregroundColor(instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingInstrument) {
            // Nutze DataMapper für Type-Conversion
            InstrumentView(instrument: DataMapper.toInstrumentData(from: instrument))
        }
    }
}

// MARK: - Index Grid Card

/// Compact grid card for displaying market indices
/// Used in 2-column grid layout on MarketsView
struct IndexGridCard: View {
    let index: MarketInstrument

    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.md,
            hasShadow: true
        ) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                // Symbol and Change (top row)
                HStack {
                    Text(getIndexSymbol())
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.secondary)

                    Spacer()

                    Text(index.change)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(index.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                        .fontWeight(.semibold)
                }

                Spacer()

                // Index Name (middle)
                Text(index.name)
                    .font(DesignSystem.Typography.body2)
                    .foregroundColor(DesignSystem.Colors.onCard)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                // Index Value (bottom)
                Text(index.value)
                    .font(.system(size: 10))
                    .foregroundColor(DesignSystem.Colors.onCard.opacity(0.8))
                    .fontWeight(.medium)
            }
        }
        .frame(height: 80)
    }

    private func getIndexSymbol() -> String {
        // Extract short symbol from index name
        let components = index.name.components(separatedBy: " ")
        if components.count == 1 {
            return index.name
        }
        // For multi-word names, take first word or abbreviation
        return components.first ?? index.name
    }
}