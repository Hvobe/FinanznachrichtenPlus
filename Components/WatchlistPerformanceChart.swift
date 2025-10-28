//
//  WatchlistPerformanceChart.swift
//  FinanzNachrichten
//
//  Performance chart for watchlist portfolio
//

import SwiftUI
import Charts

struct WatchlistPerformanceChart: View {
    let watchlist: Watchlist
    @State private var selectedTimeRange: TimeRange = .oneWeek

    enum TimeRange: String, CaseIterable {
        case oneWeek = "1W"
        case oneMonth = "1M"
        case threeMonths = "3M"
        case oneYear = "1J"

        var days: Int {
            switch self {
            case .oneWeek: return 7
            case .oneMonth: return 30
            case .threeMonths: return 90
            case .oneYear: return 365
            }
        }
    }

    // Mock performance data
    private var performanceData: [PerformanceDataPoint] {
        let baseValue = 10000.0
        let trend = watchlist.averageChange / 100.0
        let days = selectedTimeRange.days

        return (0..<days).map { day in
            let progress = Double(day) / Double(days)
            let randomVariation = Double.random(in: -0.02...0.02)
            let value = baseValue * (1 + (trend * progress) + randomVariation)

            return PerformanceDataPoint(
                day: day,
                value: value,
                date: Calendar.current.date(byAdding: .day, value: -days + day, to: Date()) ?? Date()
            )
        }
    }

    private var currentValue: Double {
        performanceData.last?.value ?? 0
    }

    private var totalChange: Double {
        guard let first = performanceData.first?.value,
              let last = performanceData.last?.value else { return 0 }
        return ((last - first) / first) * 100
    }

    private var isPositive: Bool {
        totalChange >= 0
    }

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            // Header with performance stats
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text("Portfolio-Wert")
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.secondary)

                    Text(String(format: "%.2f €", currentValue))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.onBackground)

                    HStack(spacing: 4) {
                        Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 12, weight: .semibold))

                        Text(String(format: "%+.2f%%", totalChange))
                            .font(DesignSystem.Typography.body2)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                }

                Spacer()

                // Time range selector
                HStack(spacing: 4) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTimeRange = range
                            }
                        }) {
                            Text(range.rawValue)
                                .font(.system(size: 12, weight: selectedTimeRange == range ? .semibold : .regular))
                                .foregroundColor(selectedTimeRange == range ? .white : DesignSystem.Colors.secondary)
                                .frame(width: 36, height: 28)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(selectedTimeRange == range ? DesignSystem.Colors.primary : Color.clear)
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)

            // Chart
            Chart(performanceData) { dataPoint in
                LineMark(
                    x: .value("Tag", dataPoint.day),
                    y: .value("Wert", dataPoint.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .lineStyle(StrokeStyle(lineWidth: 2))

                AreaMark(
                    x: .value("Tag", dataPoint.day),
                    y: .value("Wert", dataPoint.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            (isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error).opacity(0.15),
                            (isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error).opacity(0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(position: .trailing) { value in
                    AxisValueLabel()
                        .font(.system(size: 10))
                        .foregroundStyle(DesignSystem.Colors.tertiary)
                }
            }
            .frame(height: 140)
            .padding(.horizontal, DesignSystem.Spacing.md)
        }
        .padding(.vertical, DesignSystem.Spacing.lg)
        .background(DesignSystem.Colors.cardBackground)
        .cornerRadius(DesignSystem.CornerRadius.lg)
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                .stroke(DesignSystem.Colors.border, lineWidth: 1)
        )
        .shadow(color: DesignSystem.Shadows.card, radius: DesignSystem.Shadows.cardRadius, x: 0, y: 2)
    }
}

// MARK: - Performance Data Point

struct PerformanceDataPoint: Identifiable {
    let id = UUID()
    let day: Int
    let value: Double
    let date: Date
}
