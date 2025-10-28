//
//  CombinedWatchlistCard.swift
//  FinanzNachrichten
//
//  Combined watchlist info card with integrated donut chart
//

import SwiftUI
import Charts

struct CombinedWatchlistCard: View {
    let watchlist: Watchlist
    let onEdit: () -> Void

    // Industry mapping for symbols
    private func getIndustry(for symbol: String) -> String {
        let industryMap: [String: String] = [
            // Tech
            "AAPL": "Technologie",
            "MSFT": "Technologie",
            "NVDA": "Technologie",
            "GOOGL": "Technologie",
            "AMZN": "Technologie",
            // Auto
            "TSLA": "Automobil",
            "VOW3": "Automobil",
            "BMW": "Automobil",
            "MBG": "Automobil",
            // Finance
            "DBK": "Finanzen",
            "ALV": "Finanzen",
            // Software
            "SAP": "Software",
            // Industry
            "SIE": "Industrie",
            "BAS": "Chemie"
        ]
        return industryMap[symbol] ?? "Sonstige"
    }

    // Donut chart data grouped by industry
    private var chartData: [(String, Int, Color)] {
        // Group items by industry
        var industryCount: [String: Int] = [:]
        for item in watchlist.items {
            let industry = getIndustry(for: item.symbol)
            industryCount[industry, default: 0] += 1
        }

        // Define colors for industries
        let industryColors: [String: Color] = [
            "Technologie": .blue,
            "Automobil": .orange,
            "Finanzen": .green,
            "Software": .purple,
            "Industrie": .cyan,
            "Chemie": .yellow,
            "Sonstige": .gray
        ]

        // Convert to array and sort by count (descending)
        let sortedData = industryCount.sorted { $0.value > $1.value }

        return sortedData.map { (industry, count) in
            (industry, count, industryColors[industry] ?? .gray)
        }
    }

    private var totalItems: Int {
        watchlist.items.count
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                // Donut Chart + Item count (no header)
                HStack(spacing: DesignSystem.Spacing.lg) {
                // Donut Chart
                if !watchlist.items.isEmpty {
                    Chart(chartData, id: \.0) { item in
                        SectorMark(
                            angle: .value("Anzahl", item.1),
                            innerRadius: .ratio(0.6),
                            angularInset: 2
                        )
                        .foregroundStyle(item.2)
                    }
                    .frame(width: 120, height: 120)
                } else {
                    // Empty state donut
                    ZStack {
                        Circle()
                            .stroke(DesignSystem.Colors.border, lineWidth: 20)
                            .frame(width: 120, height: 120)

                        Text("Leer")
                            .font(.system(size: 14))
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                }

                // Info: Item count + Legend
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    Text("\(watchlist.items.count) Wertpapiere")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.onBackground)

                    // Legend: All industries with count
                    if !watchlist.items.isEmpty {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                            ForEach(chartData, id: \.0) { item in
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(item.2)
                                        .frame(width: 8, height: 8)

                                    Text(item.0)
                                        .font(.system(size: 12))
                                        .foregroundColor(DesignSystem.Colors.secondary)

                                    Text("(\(item.1))")
                                        .font(.system(size: 11))
                                        .foregroundColor(DesignSystem.Colors.tertiary)
                                }
                            }
                        }
                    } else {
                        Text("Füge Wertpapiere hinzu")
                            .font(.system(size: 12))
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.top, DesignSystem.Spacing.lg)
            .padding(.bottom, DesignSystem.Spacing.lg)
        }
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
                .fill(DesignSystem.Colors.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
                .stroke(DesignSystem.Colors.border.opacity(0.5), lineWidth: 1)
        )
        .shadow(color: DesignSystem.Shadows.card, radius: DesignSystem.Shadows.cardRadius, x: 0, y: 2)

            // Edit button in bottom right corner (outside main content)
            Button(action: onEdit) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16))
                    .foregroundColor(DesignSystem.Colors.secondary)
                    .rotationEffect(.degrees(90))
                    .frame(width: 32, height: 32)
            }
            .padding(.trailing, DesignSystem.Spacing.md)
            .padding(.bottom, DesignSystem.Spacing.md)
        }
    }
}
