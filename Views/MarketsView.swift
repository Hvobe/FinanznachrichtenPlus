//
//  MarketsView.swift
//  FinanzNachrichten
//
//  Markets overview with indices, stocks, commodities, and more
//

import SwiftUI

struct MarketsView: View {
    @State private var selectedCategory = 0
    @State private var currentMarketIndex = 0
    @State private var selectedCalendarFilter = 0 // Persistent calendar filter state
    @State private var selectedRegionFilter = 0 // Region filter for indices tab
    let categories = ["Übersicht", "Termine", "Indizes", "Branchen", "Aktien", "Aktien im Fokus", "Rohstoffe", "Devisen", "Krypto"]
    let filterOptions = ["Alle", "Earnings", "Dividenden", "Wirtschaftsdaten", "Feiertage"]
    let regionFilterOptions = ["Alle", "Deutschland", "Europa", "USA", "Asien"]
    
    let marketData = [
        MarketCard(name: "DAX", value: "15,234.56", change: "+0.78%", isPositive: true),
        MarketCard(name: "DOW JONES", value: "34,567.89", change: "+0.45%", isPositive: true),
        MarketCard(name: "NASDAQ", value: "14,123.45", change: "-0.23%", isPositive: false),
        MarketCard(name: "EUR/USD", value: "1.0234", change: "+0.12%", isPositive: true),
        MarketCard(name: "Bitcoin", value: "$43,567", change: "+2.34%", isPositive: true),
        MarketCard(name: "Gold", value: "$2,045", change: "+0.45%", isPositive: true)
    ]
    
    let securities = [
        Security(name: "Apple Inc.", symbol: "AAPL", price: "$182.52", change: "+1.23%", isPositive: true),
        Security(name: "Microsoft Corp.", symbol: "MSFT", price: "$378.85", change: "+0.87%", isPositive: true),
        Security(name: "NVIDIA Corp.", symbol: "NVDA", price: "$724.31", change: "+2.14%", isPositive: true),
        Security(name: "Tesla Inc.", symbol: "TSLA", price: "$201.45", change: "-1.87%", isPositive: false),
        Security(name: "Amazon.com Inc.", symbol: "AMZN", price: "$155.34", change: "+0.56%", isPositive: true)
    ]
    
    let instruments = [
        MarketInstrument(name: "DAX", value: "15,234.56", change: "+0.78%", isPositive: true),
        MarketInstrument(name: "S&P 500", value: "4,567.89", change: "+0.45%", isPositive: true),
        MarketInstrument(name: "NASDAQ", value: "14,123.45", change: "-0.23%", isPositive: false),
        MarketInstrument(name: "FTSE 100", value: "7,456.78", change: "+0.12%", isPositive: true),
        MarketInstrument(name: "Apple Inc.", value: "$182.52", change: "+1.23%", isPositive: true),
        MarketInstrument(name: "Microsoft Corp.", value: "$378.85", change: "+0.87%", isPositive: true),
        MarketInstrument(name: "NVIDIA Corp.", value: "$724.31", change: "+2.14%", isPositive: true),
        MarketInstrument(name: "Bitcoin", value: "$43,567.89", change: "+2.34%", isPositive: true),
        MarketInstrument(name: "Ethereum", value: "$2,678.45", change: "+1.78%", isPositive: true),
        MarketInstrument(name: "Gold", value: "$2,045.67", change: "+0.45%", isPositive: true)
    ]

    // Expanded focus stocks dataset for endless scrolling
    let focusStocks = [
        // DAX 40 Companies
        WatchlistItem(symbol: "SAP", name: "SAP SE", price: "132.45", change: "+2.89", changePercent: "+2.14%", isPositive: true),
        WatchlistItem(symbol: "ASML", name: "ASML Holding", price: "678.90", change: "+12.45", changePercent: "+1.87%", isPositive: true),
        WatchlistItem(symbol: "SIE", name: "Siemens AG", price: "178.25", change: "+4.32", changePercent: "+2.48%", isPositive: true),
        WatchlistItem(symbol: "BMW", name: "BMW AG", price: "89.76", change: "-1.23", changePercent: "-1.35%", isPositive: false),
        WatchlistItem(symbol: "MBG", name: "Mercedes-Benz", price: "63.42", change: "+0.98", changePercent: "+1.57%", isPositive: true),
        WatchlistItem(symbol: "ALV", name: "Allianz SE", price: "267.80", change: "+3.45", changePercent: "+1.31%", isPositive: true),
        WatchlistItem(symbol: "BAS", name: "BASF SE", price: "44.56", change: "-0.78", changePercent: "-1.72%", isPositive: false),
        WatchlistItem(symbol: "DTE", name: "Deutsche Telekom", price: "25.67", change: "+0.34", changePercent: "+1.34%", isPositive: true),
        WatchlistItem(symbol: "DBK", name: "Deutsche Bank", price: "16.89", change: "+0.67", changePercent: "+4.13%", isPositive: true),
        WatchlistItem(symbol: "CON", name: "Continental AG", price: "67.23", change: "-1.45", changePercent: "-2.11%", isPositive: false),

        // MDAX Companies
        WatchlistItem(symbol: "AIR", name: "Airbus SE", price: "134.67", change: "+2.34", changePercent: "+1.77%", isPositive: true),
        WatchlistItem(symbol: "DHER", name: "Delivery Hero", price: "23.45", change: "+1.23", changePercent: "+5.54%", isPositive: true),
        WatchlistItem(symbol: "HFG", name: "HelloFresh SE", price: "8.76", change: "-0.34", changePercent: "-3.74%", isPositive: false),
        WatchlistItem(symbol: "ZAL", name: "Zalando SE", price: "26.89", change: "+0.89", changePercent: "+3.42%", isPositive: true),
        WatchlistItem(symbol: "ADS", name: "Adidas AG", price: "218.45", change: "+4.23", changePercent: "+1.97%", isPositive: true),
        WatchlistItem(symbol: "PUM", name: "PUMA SE", price: "42.67", change: "-0.67", changePercent: "-1.54%", isPositive: false),
        WatchlistItem(symbol: "FME", name: "Fresenius Medical", price: "34.56", change: "+0.78", changePercent: "+2.31%", isPositive: true),
        WatchlistItem(symbol: "LEG", name: "LEG Immobilien", price: "89.34", change: "+1.45", changePercent: "+1.65%", isPositive: true),
        WatchlistItem(symbol: "EVK", name: "Evonik Industries", price: "18.90", change: "-0.23", changePercent: "-1.20%", isPositive: false),
        WatchlistItem(symbol: "WAC", name: "Wacker Chemie", price: "95.67", change: "+2.34", changePercent: "+2.51%", isPositive: true),

        // TecDAX Companies
        WatchlistItem(symbol: "TMV", name: "TeamViewer AG", price: "11.45", change: "+0.34", changePercent: "+3.07%", isPositive: true),
        WatchlistItem(symbol: "NEM", name: "Nemetschek SE", price: "87.23", change: "+1.67", changePercent: "+1.95%", isPositive: true),
        WatchlistItem(symbol: "COP", name: "CompuGroup Medical", price: "23.56", change: "-0.45", changePercent: "-1.87%", isPositive: false),
        WatchlistItem(symbol: "SGL", name: "SGL Carbon", price: "7.89", change: "+0.23", changePercent: "+3.01%", isPositive: true),
        WatchlistItem(symbol: "VAR1", name: "Varta AG", price: "4.23", change: "-0.12", changePercent: "-2.76%", isPositive: false),
        WatchlistItem(symbol: "DRW3", name: "Draegerwerk AG", price: "43.67", change: "+1.23", changePercent: "+2.90%", isPositive: true),
        WatchlistItem(symbol: "SHL", name: "Siemens Healthineers", price: "52.34", change: "+0.89", changePercent: "+1.73%", isPositive: true),
        WatchlistItem(symbol: "IFX", name: "Infineon Technologies", price: "32.45", change: "+0.67", changePercent: "+2.11%", isPositive: true),

        // US Tech Giants
        WatchlistItem(symbol: "AAPL", name: "Apple Inc.", price: "$182.52", change: "+2.24", changePercent: "+1.23%", isPositive: true),
        WatchlistItem(symbol: "MSFT", name: "Microsoft Corp.", price: "$378.85", change: "+3.32", changePercent: "+0.87%", isPositive: true),
        WatchlistItem(symbol: "NVDA", name: "NVIDIA Corp.", price: "$724.31", change: "+15.42", changePercent: "+2.14%", isPositive: true),
        WatchlistItem(symbol: "GOOGL", name: "Alphabet Inc.", price: "$138.45", change: "-0.66", changePercent: "-0.45%", isPositive: false),
        WatchlistItem(symbol: "AMZN", name: "Amazon.com Inc.", price: "$155.34", change: "+0.87", changePercent: "+0.56%", isPositive: true),
        WatchlistItem(symbol: "TSLA", name: "Tesla Inc.", price: "$201.45", change: "-3.78", changePercent: "-1.87%", isPositive: false),
        WatchlistItem(symbol: "META", name: "Meta Platforms", price: "$489.67", change: "+8.23", changePercent: "+1.71%", isPositive: true),
        WatchlistItem(symbol: "NFLX", name: "Netflix Inc.", price: "$623.45", change: "+12.34", changePercent: "+2.02%", isPositive: true),
        WatchlistItem(symbol: "AMD", name: "Advanced Micro", price: "$143.67", change: "+2.89", changePercent: "+2.05%", isPositive: true),
        WatchlistItem(symbol: "INTC", name: "Intel Corp.", price: "$25.67", change: "-0.34", changePercent: "-1.31%", isPositive: false),

        // Additional European Stocks
        WatchlistItem(symbol: "NOVO-B", name: "Novo Nordisk", price: "102.45", change: "+1.67", changePercent: "+1.66%", isPositive: true),
        WatchlistItem(symbol: "NESN", name: "Nestlé SA", price: "87.23", change: "+0.45", changePercent: "+0.52%", isPositive: true),
        WatchlistItem(symbol: "ROG", name: "Roche Holding", price: "256.78", change: "-2.34", changePercent: "-0.90%", isPositive: false),
        WatchlistItem(symbol: "UL", name: "Unilever PLC", price: "48.90", change: "+0.78", changePercent: "+1.62%", isPositive: true),
        WatchlistItem(symbol: "SHEL", name: "Shell PLC", price: "28.45", change: "+0.34", changePercent: "+1.21%", isPositive: true),
        WatchlistItem(symbol: "TTE", name: "TotalEnergies", price: "62.34", change: "+1.23", changePercent: "+2.01%", isPositive: true),
        WatchlistItem(symbol: "OR", name: "L'Oréal SA", price: "387.56", change: "+4.67", changePercent: "+1.22%", isPositive: true),
        WatchlistItem(symbol: "MC", name: "LVMH", price: "745.23", change: "+8.90", changePercent: "+1.21%", isPositive: true),
        WatchlistItem(symbol: "BN", name: "Danone SA", price: "59.67", change: "-0.45", changePercent: "-0.75%", isPositive: false),
        WatchlistItem(symbol: "CS", name: "AXA SA", price: "31.45", change: "+0.56", changePercent: "+1.81%", isPositive: true)
    ]

    // Computed property for sorted focus stocks (by performance)
    var sortedFocusStocks: [WatchlistItem] {
        focusStocks.sorted { item1, item2 in
            let percent1 = Double(item1.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            let percent2 = Double(item2.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            return percent1 > percent2
        }
    }

    // Helper computed property for calendar filter visibility (similar to MediaView)
    private var shouldShowCalendarFilter: Bool {
        selectedCategory == 1 // Termine Tab
    }

    // Helper computed property for region filter visibility
    private var shouldShowRegionFilter: Bool {
        selectedCategory == 2 // Indizes Tab
    }

    // Computed property for filtered indices
    private var filteredIndices: [MarketInstrument] {
        if selectedRegionFilter == 0 {
            return MarketInstrument.worldIndices
        }

        let selectedRegion: IndexRegion
        switch selectedRegionFilter {
        case 1:
            selectedRegion = .germany
        case 2:
            selectedRegion = .europe
        case 3:
            selectedRegion = .usa
        case 4:
            selectedRegion = .asia
        default:
            return MarketInstrument.worldIndices
        }

        return MarketInstrument.worldIndices.filter { $0.region == selectedRegion }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header with FN Logo
            FNHeaderView()
            
            // Markets Sub-Navigation
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.Spacing.xl) {
                    ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                        VStack(spacing: DesignSystem.Spacing.sm) {
                            Text(category)
                                .font(.system(size: 16, weight: selectedCategory == index ? .bold : .medium))
                                .foregroundColor(selectedCategory == index ? DesignSystem.Colors.onBackground : DesignSystem.Colors.secondary)
                            
                            RoundedRectangle(cornerRadius: 1)
                                .fill(selectedCategory == index ? DesignSystem.Colors.primary : Color.clear)
                                .frame(height: 3)
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedCategory = index
                            }
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
            }
            .padding(.vertical, DesignSystem.Spacing.Section.withinSection)
            .background(DesignSystem.Colors.surface)
            .overlay(
                DSSeparator(),
                alignment: .bottom
            )

            // Calendar Filter for Termine Tab (similar to MediaView time filter)
            if shouldShowCalendarFilter {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.Spacing.md) {
                        ForEach(Array(filterOptions.enumerated()), id: \.offset) { index, option in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedCalendarFilter = index
                                }
                            }) {
                                Text(option)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(selectedCalendarFilter == index ? .white : DesignSystem.Colors.secondary)
                                    .padding(.horizontal, DesignSystem.Spacing.md)
                                    .padding(.vertical, DesignSystem.Spacing.xs)
                                    .background(selectedCalendarFilter == index ? DesignSystem.Colors.primary : DesignSystem.Colors.surface)
                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                            .stroke(DesignSystem.Colors.border, lineWidth: selectedCalendarFilter == index ? 0 : 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                }
                .padding(.vertical, DesignSystem.Spacing.Section.withinSection)
                .background(DesignSystem.Colors.background)
            }

            // Region Filter for Indizes Tab
            if shouldShowRegionFilter {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.Spacing.md) {
                        ForEach(Array(regionFilterOptions.enumerated()), id: \.offset) { index, option in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedRegionFilter = index
                                }
                            }) {
                                Text(option)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(selectedRegionFilter == index ? .white : DesignSystem.Colors.secondary)
                                    .padding(.horizontal, DesignSystem.Spacing.md)
                                    .padding(.vertical, DesignSystem.Spacing.xs)
                                    .background(selectedRegionFilter == index ? DesignSystem.Colors.primary : DesignSystem.Colors.surface)
                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                            .stroke(DesignSystem.Colors.border, lineWidth: selectedRegionFilter == index ? 0 : 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                }
                .padding(.vertical, DesignSystem.Spacing.Section.withinSection)
                .background(DesignSystem.Colors.background)
            }

            // Content based on selected category
            if selectedCategory == 1 {
                CalendarView(selectedFilter: $selectedCalendarFilter)
            } else if selectedCategory == 3 {
                // Branchen Tab - Branch overview
                BranchesView()
            } else if selectedCategory == 0 {
                // Übersicht Tab - Market Overview with cards and top movers
                ScrollView {
                    VStack(spacing: 0) {
                        // Das bewegt die Märkte aktuell - Section with cards and summary
                        VStack(alignment: .leading, spacing: 8) { // Reduced spacing to 8px
                            Text("Das bewegt die Märkte aktuell")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                                .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                                .padding(.bottom, 8)
                            
                            // Market Cards (Swipeable)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: DesignSystem.Spacing.md) {
                                    ForEach(Array(marketData.enumerated()), id: \.offset) { index, market in
                                        DSMarketCard(market: market)
                                            .frame(width: 160, height: 100)
                                            // Gradient opacity based on distance from current index
                                            .opacity(opacityForCard(at: index))
                                            .animation(.easeInOut(duration: 0.2), value: currentMarketIndex)
                                            .overlay(
                                                GeometryReader { geometry in
                                                    Color.clear
                                                        .preference(
                                                            key: ViewOffsetKey.self,
                                                            value: ViewOffsetData(index: index, offset: geometry.frame(in: .named("scroll")).midX)
                                                        )
                                                }
                                            )
                                    }
                                }
                                .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                                .padding(.vertical, DesignSystem.Spacing.Cards.shadowPadding)
                            }
                            .coordinateSpace(name: "scroll")
                            .onPreferenceChange(ViewOffsetKey.self) { value in
                                let screenMidX = UIScreen.main.bounds.width / 2
                                if abs(value.offset - screenMidX) < 80 {
                                    if currentMarketIndex != value.index {
                                        withAnimation(.easeInOut(duration: 0.15)) {
                                            currentMarketIndex = value.index
                                        }
                                    }
                                }
                            }
                            .frame(height: 130)
                            
                            // Summary and Page Dots
                            VStack(spacing: 12) {
                                // Dynamic Market Summary
                                MarketSummaryView(currentIndex: $currentMarketIndex)
                                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                                
                                // Page Dots under the text
                                HStack(spacing: 4) {
                                    ForEach(0..<marketData.count, id: \.self) { index in
                                        Circle()
                                            .fill(currentMarketIndex == index 
                                                ? DesignSystem.Colors.primary 
                                                : DesignSystem.Colors.border.opacity(0.5))
                                            .frame(width: 6, height: 6)
                                            .animation(.easeInOut(duration: 0.2), value: currentMarketIndex)
                                    }
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.top, 32)
                        
                        // Market Movement Card
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                            Text("Marktbewegungen")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                            
                            DSCard(
                                backgroundColor: DesignSystem.Colors.cardBackground,
                                borderColor: DesignSystem.Colors.border,
                                cornerRadius: DesignSystem.CornerRadius.lg,
                                padding: DesignSystem.Spacing.lg,
                                hasShadow: true
                            ) {
                                VStack(spacing: DesignSystem.Spacing.md) {
                                    MarketMovementRow(
                                        title: "Gewinner des Tages",
                                        companyName: "Apple Inc.",
                                        change: "+2.34%",
                                        symbol: "AAPL",
                                        isPositive: true
                                    )
                                    
                                    DSSeparator()
                                    
                                    MarketMovementRow(
                                        title: "Verlierer des Tages",
                                        companyName: "Tesla Inc.",
                                        change: "-1.87%",
                                        symbol: "TSLA",
                                        isPositive: false
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                        .padding(.top, 32)
                        
                        // Top Securities Section
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                            Text("Top Wertpapiere")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                            
                            DSCard(
                                backgroundColor: DesignSystem.Colors.cardBackground,
                                borderColor: DesignSystem.Colors.border,
                                cornerRadius: DesignSystem.CornerRadius.lg,
                                padding: DesignSystem.Spacing.lg,
                                hasShadow: true
                            ) {
                                VStack(spacing: DesignSystem.Spacing.md) {
                                    ForEach(Array(securities.enumerated()), id: \.offset) { index, security in
                                        SecurityRow(security: security)
                                        
                                        if index < securities.count - 1 {
                                            DSSeparator()
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                        .padding(.top, 32)
                        .padding(.bottom, DesignSystem.Spacing.Page.bottom)
                    }
                }
                .background(DesignSystem.Colors.background)
            } else if selectedCategory == 5 {
                // Aktien im Fokus Tab - Endless scrolling focus stocks
                FocusStocksView(focusStocks: sortedFocusStocks)
            } else if selectedCategory == 2 {
                // Indizes Tab - 2-column grid layout
                ScrollView {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                        Text("Weltweite Indizes")
                            .font(DesignSystem.Typography.title2)
                            .foregroundColor(DesignSystem.Colors.onBackground)
                            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)

                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ],
                            spacing: 12
                        ) {
                            ForEach(filteredIndices) { index in
                                IndexGridCard(index: index)
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    }
                    .padding(.top, DesignSystem.Spacing.Section.headerGap)
                    .padding(.bottom, 100)
                }
                .background(DesignSystem.Colors.background)
            } else {
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.xl) {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                            Text(getCategoryTitle())
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)

                            VStack(spacing: DesignSystem.Spacing.md) {
                                ForEach(getFilteredInstruments(), id: \.name) { instrument in
                                    MarketInstrumentRow(instrument: instrument)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    .padding(.top, DesignSystem.Spacing.xl)
                    .padding(.bottom, 100)
                }
                .background(DesignSystem.Colors.background)
            }
        }
    }
    
    private func getCategoryTitle() -> String {
        switch selectedCategory {
        case 0: return "Marktübersicht"
        case 1: return "Finanztermine"
        case 2: return "Weltweite Indizes"
        case 3: return "Branchen"
        case 4: return "Top Aktien"
        case 5: return "Aktien im Fokus"
        case 6: return "Rohstoffe"
        case 7: return "Währungen"
        case 8: return "Kryptowährungen"
        default: return "Märkte"
        }
    }
    
    private func getFilteredInstruments() -> [MarketInstrument] {
        switch selectedCategory {
        case 0: return Array(instruments.prefix(6)) // Overview
        case 1: return [] // Termine - no instruments
        case 2: return Array(instruments.prefix(4)) // Indices
        case 3: return [] // Branchen - uses BranchesView instead
        case 4: return Array(instruments.dropFirst(4).prefix(3)) // Stocks
        case 5: return [] // Aktien im Fokus - uses FocusStocksView instead
        case 6: return [instruments.last!] // Commodities (Gold)
        case 7: return [instruments.first!] // Forex (using DAX as placeholder)
        case 8: return Array(instruments.dropFirst(7).prefix(2)) // Crypto
        default: return instruments
        }
    }
    
    // Calculate opacity based on distance from current index
    private func opacityForCard(at index: Int) -> Double {
        if index == currentMarketIndex {
            return 1.0
        }
        
        let distance = abs(index - currentMarketIndex)
        switch distance {
        case 1:
            return 0.75  // Direct neighbors
        case 2:
            return 0.65  // Two cards away
        default:
            return 0.6   // Further away
        }
    }
}

// MARK: - Focus Stocks View

struct FocusStocksView: View {
    let focusStocks: [WatchlistItem]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: DesignSystem.Spacing.md) {
                ForEach(focusStocks, id: \.symbol) { stock in
                    FullWidthStockCard(
                        symbol: stock.symbol,
                        name: stock.name,
                        price: stock.price,
                        change: stock.changePercent,
                        isPositive: stock.isPositive
                    )
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
            .padding(.top, DesignSystem.Spacing.Section.headerGap)
            .padding(.bottom, 100) // Extra bottom padding for tab bar
        }
        .background(DesignSystem.Colors.background)
        .scrollClipDisabled() // Prevents shadow clipping for cards
    }
}

// MARK: - Full Width Stock Card

struct FullWidthStockCard: View {
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
                padding: DesignSystem.Spacing.lg,
                hasShadow: true
            ) {
                HStack(spacing: DesignSystem.Spacing.md) {
                    // Stock logo on the left
                    createStockLogo(for: symbol, size: 40)

                    // Stock info in the middle
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        HStack {
                            Text(symbol)
                                .font(DesignSystem.Typography.caption2)
                                .foregroundColor(DesignSystem.Colors.secondary)

                            Spacer()
                        }

                        Text(name)
                            .font(DesignSystem.Typography.body2)
                            .foregroundColor(DesignSystem.Colors.onCard)
                            .fontWeight(.medium)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)

                        Text(price)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.onCard.opacity(0.8))
                            .fontWeight(.medium)
                    }

                    Spacer()

                    // Change percentage on the right
                    VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                        Text(change)
                            .font(DesignSystem.Typography.title3)
                            .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                            .fontWeight(.semibold)

                        HStack(spacing: DesignSystem.Spacing.xs) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(isPositive ? DesignSystem.Colors.success.opacity(0.12) : DesignSystem.Colors.error.opacity(0.12))
                                .frame(width: 6, height: 12)

                            Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 80)
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingInstrument) {
            InstrumentView(instrument: convertToInstrumentData())
        }
    }

    private func convertToInstrumentData() -> InstrumentData {
        let numericPrice = Double(price.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: "€", with: "").replacingOccurrences(of: ",", with: "")) ?? 100.0
        let changeValue = Double(change.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0.0

        // Generate sample chart data
        let chartData = Array((0..<30).map { i in
            InstrumentData.ChartPoint(
                time: Calendar.current.date(byAdding: .day, value: -i, to: Date()) ?? Date(),
                value: numericPrice * Double.random(in: 0.95...1.05)
            )
        }.reversed())

        return InstrumentData(
            symbol: symbol,
            name: name,
            isin: "DE000\(symbol.prefix(4))0000",
            wkn: String(symbol.prefix(6)),
            exchange: "XETRA",
            currentPrice: numericPrice,
            change: changeValue,
            changePercent: changeValue,
            dayLow: numericPrice * 0.95,
            dayHigh: numericPrice * 1.05,
            weekLow52: numericPrice * 0.7,
            weekHigh52: numericPrice * 1.3,
            volume: Int.random(in: 100000...5000000),
            marketCap: String(format: "%.2f Mrd. €", numericPrice * Double.random(in: 1...100)),
            pe: Double.random(in: 8...35),
            beta: Double.random(in: 0.5...2.0),
            dividendYield: Double.random(in: 0...5),
            nextEarningsDate: Calendar.current.date(byAdding: .day, value: Int.random(in: 1...90), to: Date()),
            bid: numericPrice * 0.999,
            ask: numericPrice * 1.001,
            lastUpdate: Date(),
            chartData: chartData,
            isPositive: isPositive
        )
    }
}

// Helper function for stock logos
private func createStockLogo(for symbol: String, size: CGFloat) -> some View {
    ZStack {
        Circle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        logoColor(for: symbol).opacity(0.8),
                        logoColor(for: symbol)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size, height: size)

        Text(String(symbol.prefix(2)))
            .font(.system(size: size * 0.35, weight: .bold))
            .foregroundColor(.white)
    }
}

private func logoColor(for symbol: String) -> Color {
    let colors: [Color] = [
        .blue, .green, .purple, .orange, .red, .pink, .indigo, .mint, .cyan, .teal
    ]
    let index = abs(symbol.hashValue) % colors.count
    return colors[index]
}

// MARK: - Branches View

struct BranchesView: View {
    @State private var showingBranchDetail = false
    @State private var selectedBranch: Branch?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Branch.sampleBranches, id: \.id) { branch in
                    BranchRow(branch: branch) {
                        selectedBranch = branch
                        showingBranchDetail = true
                    }

                    if branch.id != Branch.sampleBranches.last?.id {
                        DSSeparator()
                            .padding(.leading, DesignSystem.Spacing.Page.horizontal + 56) // Align with text
                    }
                }
            }
            .padding(.top, DesignSystem.Spacing.Section.headerGap)
            .padding(.bottom, 100)
        }
        .background(DesignSystem.Colors.background)
        .sheet(isPresented: $showingBranchDetail) {
            if let branch = selectedBranch {
                BranchDetailView(branch: branch)
            }
        }
    }
}

// MARK: - Branch Row Component

struct BranchRow: View {
    let branch: Branch
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DesignSystem.Spacing.md) {
                // Pie Chart Icon
                PieChartIcon(color: branch.color)

                // Branch Name
                Text(branch.name)
                    .font(DesignSystem.Typography.body1)
                    .foregroundColor(DesignSystem.Colors.onBackground)
                    .multilineTextAlignment(.leading)

                Spacer()

                // Chevron Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.secondary)
            }
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
            .padding(.vertical, DesignSystem.Spacing.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Pie Chart Icon Component

struct PieChartIcon: View {
    let color: Color
    let size: CGFloat

    init(color: Color, size: CGFloat = 40) {
        self.color = color
        self.size = size
    }

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: size, height: size)

            // Pie segments
            PieSegment(startAngle: 0, endAngle: 120, color: color)
            PieSegment(startAngle: 120, endAngle: 200, color: color.opacity(0.7))
            PieSegment(startAngle: 200, endAngle: 300, color: color.opacity(0.4))
            PieSegment(startAngle: 300, endAngle: 360, color: Color.gray.opacity(0.3))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Pie Segment Component

struct PieSegment: View {
    let startAngle: Double
    let endAngle: Double
    let color: Color

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2

                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: .degrees(startAngle - 90),
                    endAngle: .degrees(endAngle - 90),
                    clockwise: false
                )
                path.closeSubpath()
            }
            .fill(color)
        }
    }
}

// MARK: - Branch Detail View

struct BranchDetailView: View {
    let branch: Branch
    @Environment(\.dismiss) var dismiss
    @State private var selectedCategory: BranchStockCategory = .topFlop
    @State private var selectedNewsType: BranchNewsType = .allNews
    @State private var selectedRating: AnalystRating = .buy
    @State private var dragAmount = CGSize.zero

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.xl) {
                    branchHeaderSection
                    stocksSection
                    newsSection
                    analysisSection
                }
                .padding(.bottom, 100)
            }
            .background(DesignSystem.Colors.background)
            .navigationBarHidden(true)
            .overlay(customNavigationBar, alignment: .topLeading)
        }
        .offset(y: dragAmount.height)
        .gesture(swipeGesture)
    }

    // MARK: - View Components

    private var branchHeaderSection: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            // Branch Icon and Title
            HStack(spacing: DesignSystem.Spacing.md) {
                PieChartIcon(color: branch.color, size: 48)

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(branch.name)
                        .font(DesignSystem.Typography.largeTitle)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .fontWeight(.bold)

                    Text("\(branch.stocks.count) Aktien")
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                }

                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)

            // Branch Performance Summary
            HStack(spacing: DesignSystem.Spacing.lg) {
                VStack(spacing: DesignSystem.Spacing.xs) {
                    Text("Gewinner")
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                    Text("\(branch.topPerformers.prefix(3).count)")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                }

                VStack(spacing: DesignSystem.Spacing.xs) {
                    Text("Verlierer")
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                    Text("\(branch.worstPerformers.prefix(3).count)")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                }

                VStack(spacing: DesignSystem.Spacing.xs) {
                    Text("Dividenden")
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                    Text("\(branch.dividendStocks.count)")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                }

                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)
        }
        .padding(.top, DesignSystem.Spacing.lg)
    }

    private var stocksSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                Text("AKTIEN ZUR BRANCHE")
                    .font(DesignSystem.Typography.title2)
                    .foregroundColor(DesignSystem.Colors.onBackground)
                    .padding(.horizontal, DesignSystem.Spacing.lg)

                stockCategoryFilter
            }

            // Stock List
            LazyVStack(spacing: DesignSystem.Spacing.md) {
                ForEach(stocksForCategory(selectedCategory)) { stock in
                    FullWidthStockCard(
                        symbol: stock.symbol,
                        name: stock.name,
                        price: stock.price,
                        change: stock.changePercent,
                        isPositive: stock.isPositive
                    )
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                }
            }
        }
    }

    private var stockCategoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.md) {
                ForEach(BranchStockCategory.allCases, id: \.self) { category in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                        }
                    }) {
                        Text(category.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(selectedCategory == category ? .white : DesignSystem.Colors.secondary)
                            .padding(.horizontal, DesignSystem.Spacing.md)
                            .padding(.vertical, DesignSystem.Spacing.xs)
                            .background(selectedCategory == category ? DesignSystem.Colors.primary : DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.CornerRadius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .stroke(DesignSystem.Colors.border, lineWidth: selectedCategory == category ? 0 : 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
        }
        .padding(.vertical, DesignSystem.Spacing.Section.withinSection)
        .background(DesignSystem.Colors.background)
    }

    private var newsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                Text("NEWS ZUR BRANCHE")
                    .font(DesignSystem.Typography.title2)
                    .foregroundColor(DesignSystem.Colors.onBackground)
                    .padding(.horizontal, DesignSystem.Spacing.lg)

                newsTypeFilter
            }

            // News List
            LazyVStack(spacing: DesignSystem.Spacing.md) {
                ForEach(sampleNewsForBranch()) { newsItem in
                    BranchNewsCard(newsItem: newsItem)
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                }
            }
        }
    }

    private var newsTypeFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.md) {
                ForEach(BranchNewsType.allCases, id: \.self) { newsType in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedNewsType = newsType
                        }
                    }) {
                        Text(newsType.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(selectedNewsType == newsType ? .white : DesignSystem.Colors.secondary)
                            .padding(.horizontal, DesignSystem.Spacing.md)
                            .padding(.vertical, DesignSystem.Spacing.xs)
                            .background(selectedNewsType == newsType ? DesignSystem.Colors.primary : DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.CornerRadius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .stroke(DesignSystem.Colors.border, lineWidth: selectedNewsType == newsType ? 0 : 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
        }
        .padding(.vertical, DesignSystem.Spacing.Section.withinSection)
        .background(DesignSystem.Colors.background)
    }

    private var analysisSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                Text("ANALYSEN ZUR BRANCHE")
                    .font(DesignSystem.Typography.title2)
                    .foregroundColor(DesignSystem.Colors.onBackground)
                    .padding(.horizontal, DesignSystem.Spacing.lg)

                analystRatingFilter
            }

            // Analysis List
            LazyVStack(spacing: DesignSystem.Spacing.md) {
                ForEach(analysesForRating(selectedRating)) { analysis in
                    AnalysisCard(analysis: analysis)
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                }
            }
        }
    }

    private var analystRatingFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.md) {
                ForEach(AnalystRating.allCases, id: \.self) { rating in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedRating = rating
                        }
                    }) {
                        Text(rating.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(selectedRating == rating ? .white : DesignSystem.Colors.secondary)
                            .padding(.horizontal, DesignSystem.Spacing.md)
                            .padding(.vertical, DesignSystem.Spacing.xs)
                            .background(selectedRating == rating ? DesignSystem.Colors.primary : DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.CornerRadius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .stroke(DesignSystem.Colors.border, lineWidth: selectedRating == rating ? 0 : 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
        }
        .padding(.vertical, DesignSystem.Spacing.Section.withinSection)
        .background(DesignSystem.Colors.background)
    }

    private var customNavigationBar: some View {
        VStack {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .frame(width: 32, height: 32)
                        .background(DesignSystem.Colors.cardBackground)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.top, DesignSystem.Spacing.lg)

            Spacer()
        }
    }

    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if value.translation.height > 0 {
                    dragAmount = value.translation
                }
            }
            .onEnded { value in
                if value.translation.height > 100 {
                    dismiss()
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        dragAmount = .zero
                    }
                }
            }
    }

    // MARK: - Helper Functions

    private func stocksForCategory(_ category: BranchStockCategory) -> [WatchlistItem] {
        switch category {
        case .topFlop:
            return Array(branch.topPerformers.prefix(5)) + Array(branch.worstPerformers.prefix(5))
        case .potential:
            return branch.topPerformers
        case .focus:
            return Array(branch.stocks.sorted { $0.symbol < $1.symbol }.prefix(8))
        case .dividend:
            return branch.dividendStocks
        }
    }

    private func sampleNewsForBranch() -> [BranchNewsItem] {
        return [
            BranchNewsItem(
                id: UUID(),
                title: "\(branch.name): Starke Quartalszahlen treiben Kurse an",
                summary: "Die wichtigsten Unternehmen der \(branch.name)-Branche überzeugten mit soliden Geschäftszahlen.",
                time: "vor 2 Std.",
                category: "Unternehmen",
                source: "Börsen-Zeitung"
            ),
            BranchNewsItem(
                id: UUID(),
                title: "Analystenmeinungen zu \(branch.name)",
                summary: "Experten sehen weiteres Wachstumspotenzial in der Branche.",
                time: "vor 4 Std.",
                category: "Analyse",
                source: "Handelsblatt"
            ),
            BranchNewsItem(
                id: UUID(),
                title: "Branchenausblick \(branch.name) 2024",
                summary: "Die wichtigsten Trends und Entwicklungen für das kommende Jahr.",
                time: "vor 1 Tag",
                category: "Research",
                source: "manager magazin"
            )
        ]
    }

    private func analysesForRating(_ rating: AnalystRating) -> [AnalysisItem] {
        let sampleStocks = branch.stocks.prefix(5)

        return sampleStocks.map { stock in
            AnalysisItem(
                id: UUID(),
                symbol: stock.symbol,
                name: stock.name,
                rating: rating,
                targetPrice: "€\(String(format: "%.2f", Double(stock.price.replacingOccurrences(of: ",", with: ".")) ?? 100.0 * Double.random(in: 1.1...1.3)))",
                analyst: ["Goldman Sachs", "Deutsche Bank", "Morgan Stanley", "UBS", "JPMorgan"].randomElement() ?? "Goldman Sachs",
                date: Date().addingTimeInterval(-Double.random(in: 86400...604800)),
                summary: "Positive Entwicklung erwartet aufgrund starker Fundamentaldaten."
            )
        }
    }
}


// MARK: - Analysis Card Component

struct AnalysisCard: View {
    let analysis: AnalysisItem
    @State private var showingInstrument = false

    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                // Header with symbol and rating
                HStack {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        Text(analysis.symbol)
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(DesignSystem.Colors.onCard)
                            .fontWeight(.semibold)

                        Text(analysis.name)
                            .font(DesignSystem.Typography.body2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Circle()
                            .fill(analysis.rating.color)
                            .frame(width: 8, height: 8)

                        Text(analysis.rating.rawValue.split(separator: " ").first ?? "")
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(analysis.rating.color)
                            .fontWeight(.semibold)
                    }
                }

                // Analysis details
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    HStack {
                        Text("Kursziel:")
                            .font(DesignSystem.Typography.body2)
                            .foregroundColor(DesignSystem.Colors.secondary)

                        Text(analysis.targetPrice)
                            .font(DesignSystem.Typography.body1)
                            .foregroundColor(DesignSystem.Colors.onCard)
                            .fontWeight(.semibold)

                        Spacer()

                        Text(analysis.analyst)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }

                    Text(analysis.summary)
                        .font(DesignSystem.Typography.body2)
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .lineLimit(2)

                    Text(formatAnalysisDate(analysis.date))
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.secondary)
                }

                // Tap indicator
                HStack {
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
            }
        }
        .onTapGesture {
            showingInstrument = true
        }
        .fullScreenCover(isPresented: $showingInstrument) {
            InstrumentView(instrument: createInstrumentDataForAnalysis(for: analysis.symbol))
        }
    }

    private func formatAnalysisDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "d. MMM yyyy"
        return formatter.string(from: date)
    }

    private func createInstrumentDataForAnalysis(for symbol: String) -> InstrumentData {
        let stockData: [String: (String, Double, Bool)] = [
            "AAPL": ("Apple Inc.", 182.52, true),
            "MSFT": ("Microsoft Corp.", 378.85, true),
            "TSLA": ("Tesla Inc.", 234.67, false),
            "NVDA": ("NVIDIA Corp.", 724.31, true)
        ]

        let data = stockData[symbol] ?? ("Unknown", 100.0, true)
        let changePercent = Double.random(in: -3...3)

        return InstrumentData(
            symbol: symbol,
            name: data.0,
            isin: "US0378331005",
            wkn: "865985",
            exchange: "NASDAQ",
            currentPrice: data.1,
            change: changePercent * data.1 / 100,
            changePercent: changePercent,
            dayLow: data.1 * 0.97,
            dayHigh: data.1 * 1.03,
            weekLow52: data.1 * 0.70,
            weekHigh52: data.1 * 1.40,
            volume: Int.random(in: 1_000_000...50_000_000),
            marketCap: String(format: "%.1fB", data.1 * Double.random(in: 10...100)),
            pe: Double.random(in: 15...35),
            beta: Double.random(in: 0.9...1.4),
            dividendYield: Double.random(in: 0.5...2.5),
            nextEarningsDate: Date().addingTimeInterval(86400 * 30),
            bid: data.1 - 0.05,
            ask: data.1 + 0.05,
            lastUpdate: Date(),
            chartData: InstrumentData.generateSampleChartData(isPositive: data.2),
            isPositive: data.2
        )
    }
}

// MARK: - Branch News Card Component

struct BranchNewsCard: View {
    let newsItem: BranchNewsItem

    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                // Header with category and time
                HStack {
                    Text(newsItem.category)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.primary)
                        .padding(.horizontal, DesignSystem.Spacing.sm)
                        .padding(.vertical, 2)
                        .background(DesignSystem.Colors.primary.opacity(0.1))
                        .cornerRadius(DesignSystem.CornerRadius.sm)

                    Spacer()

                    Text(newsItem.time)
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.secondary)
                }

                // Title
                Text(newsItem.title)
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.onCard)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                // Summary
                Text(newsItem.summary)
                    .font(DesignSystem.Typography.body2)
                    .foregroundColor(DesignSystem.Colors.secondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                // Source and arrow
                HStack {
                    Text(newsItem.source)
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.secondary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
            }
        }
        .onTapGesture {
            // News tap action - could open news detail view
        }
    }
}