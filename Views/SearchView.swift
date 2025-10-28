//
//  SearchView.swift
//  FinanzNachrichten
//
//  Search functionality for stocks, markets, news and schedules
//

import SwiftUI

// MARK: - Search View

struct SearchView: View {
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @State private var selectedCategory = 0
    @State private var recentSearches: [String] = []
    
    let categories = ["Werte", "Nachrichten"]
    
    let stockResults = [
        ("AAPL", "Apple Inc.", "$182.52", "+1.23%", true),
        ("MSFT", "Microsoft Corp.", "$378.85", "+0.87%", true),
        ("NVDA", "NVIDIA Corp.", "$724.31", "+2.14%", true),
        ("TSLA", "Tesla Inc.", "$234.67", "-1.87%", false),
        ("AMZN", "Amazon.com Inc.", "$145.73", "-0.45%", false)
    ]
    
    let marketResults = [
        ("DAX", "15,234.56", "+0.78%", true),
        ("S&P 500", "4,567.89", "+0.45%", true),
        ("NASDAQ", "14,123.45", "-0.23%", false),
        ("Bitcoin", "$43,567.89", "+2.34%", true)
    ]
    
    let newsResults = [
        ("Apple kündigt neue MacBook Pro Serie an", "Technologie", "vor 1 Stunde"),
        ("Tesla erweitert Produktionskapazitäten in Deutschland", "Automobilbranche", "vor 2 Stunden"),
        ("Neue EU-Regulierung für Kryptowährungen tritt in Kraft", "Politik", "vor 3 Stunden"),
        ("Tech-Aktien setzen Rallye fort - NVIDIA erreicht neues Allzeithoch", "Technologie", "vor 4 Stunden")
    ]
    
    let scheduleResults = [
        ("Apple Q4 Earnings", "28. Jan", "22:00", ScheduleType.earnings),
        ("Tesla Ex-Dividend", "29. Jan", "09:00", ScheduleType.exDividend),
        ("Microsoft Dividende", "30. Jan", "16:00", ScheduleType.dividend),
        ("Inflationsdaten EU", "1. Feb", "11:00", ScheduleType.economicData)
    ]
    
    var filteredStockResults: [(String, String, String, String, Bool)] {
        if searchText.isEmpty {
            return stockResults
        }
        return stockResults.filter { result in
            result.0.lowercased().contains(searchText.lowercased()) ||
            result.1.lowercased().contains(searchText.lowercased())
        }
    }
    
    var filteredMarketResults: [(String, String, String, Bool)] {
        if searchText.isEmpty {
            return marketResults
        }
        return marketResults.filter { result in
            result.0.lowercased().contains(searchText.lowercased())
        }
    }
    
    var filteredNewsResults: [(String, String, String)] {
        if searchText.isEmpty {
            return newsResults
        }
        return newsResults.filter { result in
            result.0.lowercased().contains(searchText.lowercased()) ||
            result.1.lowercased().contains(searchText.lowercased())
        }
    }
    
    var filteredScheduleResults: [(String, String, String, ScheduleType)] {
        if searchText.isEmpty {
            return scheduleResults
        }
        return scheduleResults.filter { result in
            result.0.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(DesignSystem.Colors.secondary)
                    
                    TextField("Aktien, Märkte, News durchsuchen...", text: $searchText)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(DesignSystem.Colors.secondary)
                        }
                    }
                }
                .padding(DesignSystem.Spacing.md)
                .background(DesignSystem.Colors.surface)
                .cornerRadius(DesignSystem.CornerRadius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                        .stroke(DesignSystem.Colors.border, lineWidth: 1)
                )
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.top, DesignSystem.Spacing.lg)
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.Spacing.lg) {
                        ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedCategory = index
                                }
                            }) {
                                VStack(spacing: DesignSystem.Spacing.xs) {
                                    Text(category)
                                        .font(.system(size: 14, weight: selectedCategory == index ? .semibold : .medium))
                                        .foregroundColor(selectedCategory == index ? DesignSystem.Colors.primary : DesignSystem.Colors.secondary)
                                    
                                    RoundedRectangle(cornerRadius: 1)
                                        .fill(selectedCategory == index ? DesignSystem.Colors.primary : Color.clear)
                                        .frame(height: 2)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                }
                .padding(.vertical, DesignSystem.Spacing.lg)
                
                DSSeparator()
                
                // Search Results
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.xl) {
                        if searchText.isEmpty {
                            // Show popular/recent searches when no search text
                            VStack(spacing: DesignSystem.Spacing.xl) {
                                // Recent searches section
                                if !recentSearches.isEmpty {
                                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                                        HStack {
                                            Text("Zuletzt gesucht")
                                                .font(DesignSystem.Typography.title3)
                                                .foregroundColor(DesignSystem.Colors.onBackground)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                clearRecentSearches()
                                            }) {
                                                Text("Löschen")
                                                    .font(DesignSystem.Typography.caption1)
                                                    .foregroundColor(DesignSystem.Colors.primary)
                                            }
                                        }
                                        
                                        VStack(spacing: DesignSystem.Spacing.sm) {
                                            ForEach(recentSearches.prefix(5), id: \.self) { term in
                                                Button(action: {
                                                    searchText = term
                                                }) {
                                                    HStack {
                                                        Image(systemName: "clock.arrow.circlepath")
                                                            .font(.system(size: 14))
                                                            .foregroundColor(DesignSystem.Colors.secondary)
                                                        
                                                        Text(term)
                                                            .font(DesignSystem.Typography.body1)
                                                            .foregroundColor(DesignSystem.Colors.onBackground)
                                                        
                                                        Spacer()
                                                        
                                                        Button(action: {
                                                            removeFromRecentSearches(term)
                                                        }) {
                                                            Image(systemName: "xmark")
                                                                .font(.system(size: 12))
                                                                .foregroundColor(DesignSystem.Colors.secondary)
                                                        }
                                                    }
                                                    .padding(.vertical, DesignSystem.Spacing.sm)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                    }
                                }
                                
                                // Popular searches section
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                                    Text("Beliebte Suchen")
                                        .font(DesignSystem.Typography.title3)
                                        .foregroundColor(DesignSystem.Colors.onBackground)
                                    
                                    VStack(spacing: DesignSystem.Spacing.sm) {
                                        ForEach(["Apple", "Tesla", "Bitcoin", "DAX", "NVIDIA"], id: \.self) { term in
                                            Button(action: {
                                                searchText = term
                                                addToRecentSearches(term)
                                            }) {
                                                HStack {
                                                    Image(systemName: "magnifyingglass")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(DesignSystem.Colors.secondary)
                                                    
                                                    Text(term)
                                                        .font(DesignSystem.Typography.body1)
                                                        .foregroundColor(DesignSystem.Colors.onBackground)
                                                    
                                                    Spacer()
                                                    
                                                    Image(systemName: "arrow.up.left")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(DesignSystem.Colors.secondary)
                                                }
                                                .padding(.vertical, DesignSystem.Spacing.sm)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                        } else {
                            // Show search results
                            VStack(spacing: DesignSystem.Spacing.xl) {
                                if selectedCategory == 0 {
                                    // Values Results (Stocks + Markets)
                                    if !filteredStockResults.isEmpty || !filteredMarketResults.isEmpty {
                                        SearchResultSection(title: "Werte") {
                                            VStack(spacing: DesignSystem.Spacing.md) {
                                                // Show stocks
                                                ForEach(Array(filteredStockResults.enumerated()), id: \.offset) { index, stock in
                                                    SearchStockRow(
                                                        symbol: stock.0,
                                                        name: stock.1,
                                                        price: stock.2,
                                                        change: stock.3,
                                                        isPositive: stock.4
                                                    )
                                                }
                                                
                                                // Show markets
                                                ForEach(Array(filteredMarketResults.enumerated()), id: \.offset) { index, market in
                                                    SearchMarketRow(
                                                        name: market.0,
                                                        value: market.1,
                                                        change: market.2,
                                                        isPositive: market.3
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                if selectedCategory == 1 {
                                    // News Results (News + Schedule)
                                    if !filteredNewsResults.isEmpty || !filteredScheduleResults.isEmpty {
                                        SearchResultSection(title: "Nachrichten") {
                                            VStack(spacing: DesignSystem.Spacing.md) {
                                                // Show news
                                                ForEach(Array(filteredNewsResults.enumerated()), id: \.offset) { index, news in
                                                    SearchNewsRow(
                                                        title: news.0,
                                                        category: news.1,
                                                        time: news.2
                                                    )
                                                }
                                                
                                                // Show schedule items as news
                                                ForEach(Array(filteredScheduleResults.enumerated()), id: \.offset) { index, schedule in
                                                    SearchScheduleRow(
                                                        title: schedule.0,
                                                        date: schedule.1,
                                                        time: schedule.2,
                                                        type: schedule.3
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                // No results message
                                if searchText.count > 2 && 
                                   filteredStockResults.isEmpty && 
                                   filteredMarketResults.isEmpty && 
                                   filteredNewsResults.isEmpty && 
                                   filteredScheduleResults.isEmpty {
                                    VStack(spacing: DesignSystem.Spacing.md) {
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 48))
                                            .foregroundColor(DesignSystem.Colors.secondary)
                                        
                                        Text("Keine Ergebnisse gefunden")
                                            .font(DesignSystem.Typography.title3)
                                            .foregroundColor(DesignSystem.Colors.onBackground)
                                        
                                        Text("Versuchen Sie einen anderen Suchbegriff")
                                            .font(DesignSystem.Typography.body2)
                                            .foregroundColor(DesignSystem.Colors.secondary)
                                    }
                                    .padding(.top, DesignSystem.Spacing.xxl)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    .padding(.vertical, DesignSystem.Spacing.lg)
                }
                .background(DesignSystem.Colors.background)
            }
            .navigationTitle("Suche")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        isPresented = false
                    }
                }
            }
            .onAppear {
                loadRecentSearches()
            }
            .onSubmit {
                if !searchText.isEmpty {
                    addToRecentSearches(searchText)
                }
            }
        }
    }
    
    // MARK: - Recent Searches Management
    
    private func loadRecentSearches() {
        if let saved = UserDefaults.standard.array(forKey: "recentSearches") as? [String] {
            recentSearches = saved
        }
    }
    
    private func addToRecentSearches(_ term: String) {
        // Remove if already exists to avoid duplicates
        recentSearches.removeAll { $0 == term }
        // Add to beginning
        recentSearches.insert(term, at: 0)
        // Keep only last 10 searches
        if recentSearches.count > 10 {
            recentSearches = Array(recentSearches.prefix(10))
        }
        // Save to UserDefaults
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
    }
    
    private func removeFromRecentSearches(_ term: String) {
        recentSearches.removeAll { $0 == term }
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
    }
    
    private func clearRecentSearches() {
        recentSearches.removeAll()
        UserDefaults.standard.removeObject(forKey: "recentSearches")
    }
}

// MARK: - Search Result Section

struct SearchResultSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            Text(title)
                .font(DesignSystem.Typography.title3)
                .foregroundColor(DesignSystem.Colors.onBackground)
            
            content
        }
    }
}

// MARK: - Search Stock Row

struct SearchStockRow: View {
    let symbol: String
    let name: String
    let price: String
    let change: String
    let isPositive: Bool
    
    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: false
        ) {
            HStack {
                // Stock logo
                stockLogo(for: symbol, size: 40)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(symbol)
                        .font(DesignSystem.Typography.headline)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.bold)
                    Text(name)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                    Text(price)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.semibold)
                    Text(change)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(DesignSystem.Colors.secondary)
                    .padding(.leading, DesignSystem.Spacing.sm)
            }
        }
    }
}

// MARK: - Search Market Row

struct SearchMarketRow: View {
    let name: String
    let value: String
    let change: String
    let isPositive: Bool
    
    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: false
        ) {
            HStack {
                // Market logo
                stockLogo(for: marketInstrumentNameToSymbol(name), size: 40)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(name)
                        .font(DesignSystem.Typography.headline)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.semibold)
                    Text("Index")
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                    Text(value)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.semibold)
                    Text(change)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(DesignSystem.Colors.secondary)
                    .padding(.leading, DesignSystem.Spacing.sm)
            }
        }
    }
}

// MARK: - Search News Row

struct SearchNewsRow: View {
    let title: String
    let category: String
    let time: String
    
    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: false
        ) {
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(title)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Text(category)
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.primary)
                        
                        Text("•")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                        
                        Text(time)
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(DesignSystem.Colors.secondary)
            }
        }
    }
}

// MARK: - Search Schedule Row

struct SearchScheduleRow: View {
    let title: String
    let date: String
    let time: String
    let type: ScheduleType
    
    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: false
        ) {
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(title)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.medium)
                    
                    HStack {
                        Text(date)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.secondary)
                        
                        Text("•")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                        
                        Text(time)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                }
                
                Spacer()
                
                Text(type.displayName)
                    .font(DesignSystem.Typography.caption2)
                    .foregroundColor(type.color)
                    .padding(.horizontal, DesignSystem.Spacing.sm)
                    .padding(.vertical, DesignSystem.Spacing.xs)
                    .background(type.color.opacity(0.1))
                    .cornerRadius(DesignSystem.CornerRadius.sm)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(DesignSystem.Colors.secondary)
                    .padding(.leading, DesignSystem.Spacing.sm)
            }
        }
    }
}