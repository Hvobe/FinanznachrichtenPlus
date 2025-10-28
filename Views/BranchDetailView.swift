//
//  BranchDetailView.swift
//  FinanzNachrichten
//
//  Individual branch detail view showing stocks, news, and analyses for a specific industry branch
//

import SwiftUI

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
                    // Branch Header
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

                    // AKTIEN ZUR BRANCHE Section
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            Text("AKTIEN ZUR BRANCHE")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                                .fontWeight(.bold)
                                .padding(.horizontal, DesignSystem.Spacing.lg)

                            // Stock Category Filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: DesignSystem.Spacing.sm) {
                                    ForEach(BranchStockCategory.allCases, id: \.self) { category in
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                selectedCategory = category
                                            }
                                        }) {
                                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                                Text(category.rawValue)
                                                    .font(DesignSystem.Typography.body1)
                                                    .foregroundColor(selectedCategory == category ? branch.color : DesignSystem.Colors.secondary)
                                                    .fontWeight(selectedCategory == category ? .semibold : .regular)

                                                if !category.subtitle.isEmpty {
                                                    Text(category.subtitle)
                                                        .font(DesignSystem.Typography.caption2)
                                                        .foregroundColor(DesignSystem.Colors.secondary)
                                                        .multilineTextAlignment(.leading)
                                                }
                                            }
                                            .padding(.horizontal, DesignSystem.Spacing.md)
                                            .padding(.vertical, DesignSystem.Spacing.sm)
                                            .background(
                                                Rectangle()
                                                    .fill(selectedCategory == category ? branch.color.opacity(0.1) : Color.clear)
                                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, DesignSystem.Spacing.lg)
                            }
                        }

                        // Stock List
                        LazyVStack(spacing: DesignSystem.Spacing.md) {
                            ForEach(stocksForCategory(selectedCategory)) { stock in
                                FullWidthStockCard(item: stock)
                                    .padding(.horizontal, DesignSystem.Spacing.lg)
                            }
                        }
                    }

                    // NEWS ZUR BRANCHE Section
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            Text("NEWS ZUR BRANCHE")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                                .fontWeight(.bold)
                                .padding(.horizontal, DesignSystem.Spacing.lg)

                            // News Type Filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: DesignSystem.Spacing.sm) {
                                    ForEach(BranchNewsType.allCases, id: \.self) { newsType in
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                selectedNewsType = newsType
                                            }
                                        }) {
                                            Text(newsType.rawValue)
                                                .font(DesignSystem.Typography.body1)
                                                .foregroundColor(selectedNewsType == newsType ? branch.color : DesignSystem.Colors.secondary)
                                                .fontWeight(selectedNewsType == newsType ? .semibold : .regular)
                                                .padding(.horizontal, DesignSystem.Spacing.md)
                                                .padding(.vertical, DesignSystem.Spacing.sm)
                                                .background(
                                                    Rectangle()
                                                        .fill(selectedNewsType == newsType ? branch.color.opacity(0.1) : Color.clear)
                                                        .cornerRadius(DesignSystem.CornerRadius.md)
                                                )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, DesignSystem.Spacing.lg)
                            }
                        }

                        // News List (Sample news for the branch)
                        LazyVStack(spacing: DesignSystem.Spacing.md) {
                            ForEach(sampleNewsForBranch()) { newsItem in
                                NewsCard(newsItem: newsItem)
                                    .padding(.horizontal, DesignSystem.Spacing.lg)
                            }
                        }
                    }

                    // ANALYSEN ZUR BRANCHE Section
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            Text("ANALYSEN ZUR BRANCHE")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                                .fontWeight(.bold)
                                .padding(.horizontal, DesignSystem.Spacing.lg)

                            // Analyst Rating Filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: DesignSystem.Spacing.sm) {
                                    ForEach(AnalystRating.allCases, id: \.self) { rating in
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                selectedRating = rating
                                            }
                                        }) {
                                            HStack(spacing: DesignSystem.Spacing.xs) {
                                                Circle()
                                                    .fill(rating.color)
                                                    .frame(width: 8, height: 8)

                                                Text(rating.rawValue)
                                                    .font(DesignSystem.Typography.body1)
                                                    .foregroundColor(selectedRating == rating ? rating.color : DesignSystem.Colors.secondary)
                                                    .fontWeight(selectedRating == rating ? .semibold : .regular)
                                            }
                                            .padding(.horizontal, DesignSystem.Spacing.md)
                                            .padding(.vertical, DesignSystem.Spacing.sm)
                                            .background(
                                                Rectangle()
                                                    .fill(selectedRating == rating ? rating.color.opacity(0.1) : Color.clear)
                                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, DesignSystem.Spacing.lg)
                            }
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
                .padding(.bottom, 100)
            }
            .background(DesignSystem.Colors.background)
            .navigationBarHidden(true)
            .overlay(
                // Custom Navigation Bar
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
                },
                alignment: .topLeading
            )
        }
        .offset(y: dragAmount.height)
        .gesture(
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
        )
    }

    // MARK: - Helper Functions

    private func stocksForCategory(_ category: BranchStockCategory) -> [WatchlistItem] {
        switch category {
        case .topFlop:
            return Array(branch.topPerformers.prefix(5)) + Array(branch.worstPerformers.prefix(5))
        case .potential:
            return branch.topPerformers
        case .focus:
            return branch.stocks.shuffled().prefix(8).map { $0 }
        case .dividend:
            return branch.dividendStocks
        }
    }

    private func sampleNewsForBranch() -> [NewsItem] {
        return [
            NewsItem(
                id: UUID(),
                title: "\(branch.name): Starke Quartalszahlen treiben Kurse an",
                summary: "Die wichtigsten Unternehmen der \(branch.name)-Branche überzeugten mit soliden Geschäftszahlen.",
                time: "vor 2 Std.",
                category: "Unternehmen",
                source: "Börsen-Zeitung",
                imageURL: nil,
                isBookmarked: false,
                readCount: 1234
            ),
            NewsItem(
                id: UUID(),
                title: "Analystenmeinungen zu \(branch.name)",
                summary: "Experten sehen weiteres Wachstumspotenzial in der Branche.",
                time: "vor 4 Std.",
                category: "Analyse",
                source: "Handelsblatt",
                imageURL: nil,
                isBookmarked: false,
                readCount: 856
            ),
            NewsItem(
                id: UUID(),
                title: "Branchenausblick \(branch.name) 2024",
                summary: "Die wichtigsten Trends und Entwicklungen für das kommende Jahr.",
                time: "vor 1 Tag",
                category: "Research",
                source: "manager magazin",
                imageURL: nil,
                isBookmarked: false,
                readCount: 2341
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

// MARK: - Analysis Item Model

struct AnalysisItem: Identifiable {
    let id: UUID
    let symbol: String
    let name: String
    let rating: AnalystRating
    let targetPrice: String
    let analyst: String
    let date: Date
    let summary: String
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
            InstrumentView(instrument: createInstrumentData(for: analysis.symbol))
        }
    }

    private func formatAnalysisDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "d. MMM yyyy"
        return formatter.string(from: date)
    }

    private func createInstrumentData(for symbol: String) -> InstrumentData {
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

// MARK: - Preview

struct BranchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BranchDetailView(branch: Branch.sampleBranches[0])
    }
}