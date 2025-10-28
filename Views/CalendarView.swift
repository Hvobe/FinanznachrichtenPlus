//
//  CalendarView.swift
//  FinanzNachrichten
//
//  Financial calendar view showing earnings, dividends, and other market events
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @Binding var selectedFilter: Int
    
    // Sample calendar events
    let calendarEvents = [
        CalendarEvent(
            title: "Apple Q1 2024 Earnings",
            date: Date(),
            time: "22:00",
            type: .earnings,
            symbol: "AAPL",
            impact: .high
        ),
        CalendarEvent(
            title: "Microsoft Dividende",
            date: Date().addingTimeInterval(86400),
            time: "09:00",
            type: .dividend,
            symbol: "MSFT",
            impact: .medium
        ),
        CalendarEvent(
            title: "US Arbeitsmarktdaten",
            date: Date().addingTimeInterval(172800),
            time: "14:30",
            type: .economicData,
            symbol: nil,
            impact: .high
        ),
        CalendarEvent(
            title: "Tesla Ex-Dividende",
            date: Date().addingTimeInterval(259200),
            time: "09:00",
            type: .exDividend,
            symbol: "TSLA",
            impact: .low
        ),
        CalendarEvent(
            title: "EZB Zinsentscheidung",
            date: Date().addingTimeInterval(345600),
            time: "13:45",
            type: .economicData,
            symbol: nil,
            impact: .high
        ),
        CalendarEvent(
            title: "US Börsenfeiertag",
            date: Date().addingTimeInterval(432000),
            time: "Ganztägig",
            type: .holiday,
            symbol: nil,
            impact: .medium
        )
    ]
    
    var filteredEvents: [CalendarEvent] {
        if selectedFilter == 0 {
            return calendarEvents
        } else {
            let filterType: ScheduleType = {
                switch selectedFilter {
                case 1: return .earnings
                case 2: return .dividend
                case 3: return .economicData
                case 4: return .holiday
                default: return .earnings
                }
            }()
            return calendarEvents.filter { $0.type == filterType || ($0.type == .exDividend && filterType == .dividend) }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.lg) {
                // Calendar Events
                VStack(spacing: DesignSystem.Spacing.lg) {
                    ForEach(groupEventsByDate(), id: \.key) { dateGroup in
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            // Date Header
                            Text(formatDateHeader(dateGroup.key))
                                .font(DesignSystem.Typography.title3)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                                .padding(.horizontal, DesignSystem.Spacing.lg)
                            
                            // Events for this date
                            VStack(spacing: DesignSystem.Spacing.md) {
                                ForEach(dateGroup.value) { event in
                                    CalendarEventRow(event: event)
                                }
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                        }
                    }
                }
            }
            .padding(.top, DesignSystem.Spacing.Section.headerGap)
            .padding(.bottom, 100)
        }
        .background(DesignSystem.Colors.background)
    }
    
    private func groupEventsByDate() -> [(key: Date, value: [CalendarEvent])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredEvents) { event in
            calendar.startOfDay(for: event.date)
        }
        return grouped.sorted { $0.key < $1.key }
    }
    
    private func formatDateHeader(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Heute"
        } else if calendar.isDateInTomorrow(date) {
            return "Morgen"
        } else {
            formatter.dateFormat = "EEEE, d. MMMM"
            return formatter.string(from: date)
        }
    }
}

// MARK: - Calendar Event Model

struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let time: String
    let type: ScheduleType
    let symbol: String?
    let impact: EventImpact
}

enum EventImpact {
    case low
    case medium
    case high
    
    var color: Color {
        switch self {
        case .low: return .gray
        case .medium: return .orange
        case .high: return .red
        }
    }
}


// MARK: - Calendar Event Row Component

struct CalendarEventRow: View {
    let event: CalendarEvent
    @State private var showingInstrument = false
    
    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            HStack {
                // Time and Type Indicator
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(event.time)
                        .font(DesignSystem.Typography.headline)
                        .foregroundColor(DesignSystem.Colors.onCard)
                    
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Circle()
                            .fill(event.type.color)
                            .frame(width: 8, height: 8)
                        
                        Text(event.type.displayName)
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(event.type.color)
                    }
                }
                .frame(width: 80, alignment: .leading)
                
                // Event Details
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(event.title)
                        .font(DesignSystem.Typography.body1)
                        .foregroundColor(DesignSystem.Colors.onCard)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if let symbol = event.symbol {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Text(symbol)
                                .font(DesignSystem.Typography.caption1)
                                .foregroundColor(DesignSystem.Colors.secondary)
                                .padding(.horizontal, DesignSystem.Spacing.sm)
                                .padding(.vertical, 2)
                                .background(DesignSystem.Colors.secondary.opacity(0.1))
                                .cornerRadius(DesignSystem.CornerRadius.sm)
                            
                            // Impact Indicator
                            HStack(spacing: 2) {
                                ForEach(0..<3) { index in
                                    Circle()
                                        .fill(index < impactLevel(event.impact) ? event.impact.color : Color.gray.opacity(0.3))
                                        .frame(width: 4, height: 4)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Chevron for tappable events
                if event.symbol != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
            }
        }
        .onTapGesture {
            if event.symbol != nil {
                showingInstrument = true
            }
        }
        .fullScreenCover(isPresented: $showingInstrument) {
            if let symbol = event.symbol {
                InstrumentView(instrument: createInstrumentData(for: symbol))
            }
        }
    }
    
    private func impactLevel(_ impact: EventImpact) -> Int {
        switch impact {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        }
    }
    
    private func createInstrumentData(for symbol: String) -> InstrumentData {
        // Create sample instrument data based on symbol
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
            isin: "US0378331005", // Sample ISIN
            wkn: "865985", // Sample WKN
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

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(selectedFilter: .constant(0))
    }
}