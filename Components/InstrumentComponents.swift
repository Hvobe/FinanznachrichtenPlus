//
//  InstrumentComponents.swift
//  FinanzNachrichten
//
//  Components for the enhanced instrument detail view
//

import SwiftUI

// MARK: - Section Navigation Pills

struct SectionNavigationPills: View {
    @Binding var activeSection: String
    let sections: [(id: String, title: String)]
    let onTap: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                ForEach(sections, id: \.id) { section in
                    Button(action: {
                        onTap(section.id)
                    }) {
                        Text(section.title)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(activeSection == section.id ? .white : DesignSystem.Colors.secondary)
                            .padding(.horizontal, DesignSystem.Spacing.md)
                            .padding(.vertical, DesignSystem.Spacing.xs)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
                                    .fill(activeSection == section.id ? DesignSystem.Colors.primary : DesignSystem.Colors.surface)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
                                    .stroke(DesignSystem.Colors.border, lineWidth: activeSection == section.id ? 0 : 1)
                            )
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
        }
    }
}

// MARK: - Performance Indicators Row

struct PerformanceIndicatorsRow: View {
    let performances: [(period: String, value: Double, isPositive: Bool)]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.lg) {
                ForEach(performances, id: \.period) { perf in
                    VStack(spacing: DesignSystem.Spacing.xs) {
                        Text(perf.period)
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                        
                        Text("\(perf.isPositive ? "+" : "")\(String(format: "%.1f", perf.value))%")
                            .font(DesignSystem.Typography.caption1)
                            .fontWeight(.semibold)
                            .foregroundColor(perf.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
        }
    }
}

// MARK: - Analytics & Performance Card

struct AnalyticsPerformanceCard: View {
    let instrument: InstrumentData
    @State private var sentimentValue: Double = 0.75 // 75% buy sentiment
    
    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                Text("Analysen & Performance")
                    .font(DesignSystem.Typography.title3)
                    .foregroundColor(DesignSystem.Colors.onCard)
                
                // Community Sentiment
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    Text("Community Stimmung")
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                    
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Text("Verkaufen")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.error)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(DesignSystem.Colors.separator)
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [DesignSystem.Colors.error, DesignSystem.Colors.success]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                                    .frame(width: geometry.size.width * CGFloat(sentimentValue), height: 8)
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 16, height: 16)
                                    .overlay(
                                        Circle()
                                            .stroke(DesignSystem.Colors.primary, lineWidth: 2)
                                    )
                                    .offset(x: geometry.size.width * CGFloat(sentimentValue) - 8)
                            }
                        }
                        .frame(height: 16)
                        
                        Text("Kaufen")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.success)
                    }
                }
                
                DSSeparator()
                
                // Analyst Consensus
                HStack {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        Text("Analysten Konsens")
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.secondary)
                        
                        Text("KAUFEN")
                            .font(DesignSystem.Typography.body1)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignSystem.Colors.success)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < 4 ? "star.fill" : "star")
                                .font(.system(size: 12))
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                    }
                }
                
                DSSeparator()
                
                // 52 Week Range
                if let low52 = instrument.weekLow52, let high52 = instrument.weekHigh52 {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("52 Wochen Spanne")
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.secondary)
                        
                        HStack {
                            Text(String(format: "%.2f", low52))
                                .font(DesignSystem.Typography.caption2)
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(DesignSystem.Colors.separator)
                                        .frame(height: 4)
                                    
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(DesignSystem.Colors.primary)
                                        .frame(width: geometry.size.width * CGFloat((instrument.currentPrice - low52) / (high52 - low52)), height: 4)
                                    
                                    Circle()
                                        .fill(DesignSystem.Colors.primary)
                                        .frame(width: 8, height: 8)
                                        .offset(x: geometry.size.width * CGFloat((instrument.currentPrice - low52) / (high52 - low52)) - 4)
                                }
                            }
                            .frame(height: 8)
                            
                            Text(String(format: "%.2f", high52))
                                .font(DesignSystem.Typography.caption2)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Market Data Card

struct MarketDataCard: View {
    let instrument: InstrumentData
    
    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                Text("Handelsdaten")
                    .font(DesignSystem.Typography.title3)
                    .foregroundColor(DesignSystem.Colors.onCard)
                
                VStack(spacing: DesignSystem.Spacing.md) {
                    // Bid/Ask Spread
                    if let bid = instrument.bid, let ask = instrument.ask {
                        HStack {
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                Text("Geld")
                                    .font(DesignSystem.Typography.caption2)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                                Text(String(format: "%.2f", bid))
                                    .font(DesignSystem.Typography.body1)
                                    .fontWeight(.medium)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .center, spacing: DesignSystem.Spacing.xs) {
                                Text("Spread")
                                    .font(DesignSystem.Typography.caption2)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                                Text(String(format: "%.2f", ask - bid))
                                    .font(DesignSystem.Typography.caption1)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                                Text("Brief")
                                    .font(DesignSystem.Typography.caption2)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                                Text(String(format: "%.2f", ask))
                                    .font(DesignSystem.Typography.body1)
                                    .fontWeight(.medium)
                            }
                        }
                        
                        DSSeparator()
                    }
                    
                    // Volume with visual bar
                    HStack {
                        Text("Volumen")
                            .font(DesignSystem.Typography.body2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(formatVolume(instrument.volume))
                                .font(DesignSystem.Typography.body1)
                                .fontWeight(.medium)
                            
                            // Volume bar
                            GeometryReader { geometry in
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(DesignSystem.Colors.primary)
                                        .frame(width: geometry.size.width * 0.7) // 70% of average volume
                                    Rectangle()
                                        .fill(DesignSystem.Colors.separator)
                                }
                            }
                            .frame(height: 4)
                            .cornerRadius(2)
                        }
                        .frame(width: 100)
                    }
                    
                    DSSeparator()
                    
                    // Day's Range
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("Tagesspanne")
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.secondary)
                        
                        HStack {
                            Text(String(format: "%.2f", instrument.dayLow))
                                .font(DesignSystem.Typography.caption2)
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(DesignSystem.Colors.separator)
                                        .frame(height: 4)
                                    
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                                        .frame(width: geometry.size.width * CGFloat((instrument.currentPrice - instrument.dayLow) / (instrument.dayHigh - instrument.dayLow)), height: 4)
                                }
                            }
                            .frame(height: 4)
                            
                            Text(String(format: "%.2f", instrument.dayHigh))
                                .font(DesignSystem.Typography.caption2)
                        }
                    }
                    
                    if let exchange = instrument.exchange, let lastUpdate = instrument.lastUpdate {
                        DSSeparator()
                        
                        HStack {
                            Text(exchange)
                                .font(DesignSystem.Typography.caption1)
                                .foregroundColor(DesignSystem.Colors.secondary)
                            
                            Spacer()
                            
                            Text("Stand: \(formatTime(lastUpdate))")
                                .font(DesignSystem.Typography.caption2)
                                .foregroundColor(DesignSystem.Colors.tertiary)
                        }
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
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Events Card

struct EventsCard: View {
    let events: [CompanyEvent]
    
    struct CompanyEvent {
        let id = UUID()
        let title: String
        let date: Date
        let type: EventType
        
        enum EventType {
            case earnings
            case dividend
            case conference
            case other
            
            var icon: String {
                switch self {
                case .earnings: return "chart.bar.fill"
                case .dividend: return "dollarsign.circle.fill"
                case .conference: return "person.3.fill"
                case .other: return "calendar"
                }
            }
            
            var color: Color {
                switch self {
                case .earnings: return DesignSystem.Colors.primary
                case .dividend: return DesignSystem.Colors.success
                case .conference: return Color.blue
                case .other: return DesignSystem.Colors.secondary
                }
            }
            
            var displayName: String {
                switch self {
                case .earnings: return "Earnings"
                case .dividend: return "Dividende"
                case .conference: return "Konferenz"
                case .other: return "Termin"
                }
            }
        }
    }
    
    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                Text("Wichtige Termine")
                    .font(DesignSystem.Typography.title3)
                    .foregroundColor(DesignSystem.Colors.onCard)
                
                VStack(spacing: DesignSystem.Spacing.md) {
                    ForEach(events.prefix(4), id: \.id) { event in
                        HStack(spacing: DesignSystem.Spacing.md) {
                            Image(systemName: event.type.icon)
                                .font(.system(size: 16))
                                .foregroundColor(event.type.color)
                                .frame(width: 24, height: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(event.title)
                                    .font(DesignSystem.Typography.body2)
                                    .foregroundColor(DesignSystem.Colors.onCard)
                                
                                Text(formatEventDate(event.date))
                                    .font(DesignSystem.Typography.caption2)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                            }
                            
                            Spacer()
                        }
                        
                        if event.id != events.prefix(4).last?.id {
                            DSSeparator()
                        }
                    }
                }
            }
        }
    }
    
    private func formatEventDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd. MMM yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - News Filter Chips

struct NewsFilterChips: View {
    @Binding var selectedFilter: String
    let filters = ["Alle", "Analysen", "Unternehmen", "Empfehlungen"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                ForEach(filters, id: \.self) { filter in
                    Button(action: {
                        selectedFilter = filter
                    }) {
                        Text(filter)
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(selectedFilter == filter ? .white : DesignSystem.Colors.secondary)
                            .padding(.horizontal, DesignSystem.Spacing.md)
                            .padding(.vertical, DesignSystem.Spacing.xs)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .fill(selectedFilter == filter ? DesignSystem.Colors.primary : DesignSystem.Colors.surface)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .stroke(DesignSystem.Colors.border, lineWidth: selectedFilter == filter ? 0 : 1)
                            )
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
        }
    }
}

// MARK: - Enhanced News Item

struct EnhancedNewsItem: View {
    let title: String
    let source: String
    let time: String
    let readerCount: Int
    let rating: Int? // 1-5 stars for analyst reports
    let hasImage: Bool
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            if hasImage {
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                    .fill(DesignSystem.Colors.separator)
                    .frame(width: 80, height: 60)
            }
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(title)
                    .font(DesignSystem.Typography.body2)
                    .foregroundColor(DesignSystem.Colors.onCard)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Text(source)
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.secondary)
                    
                    Text("•")
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.separator)
                    
                    Text(time)
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.tertiary)
                    
                    if readerCount > 0 {
                        Text("•")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.separator)
                        
                        Text("\(readerCount) Leser")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.tertiary)
                    }
                    
                    Spacer()
                    
                    if let rating = rating {
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < rating ? "star.fill" : "star")
                                    .font(.system(size: 10))
                                    .foregroundColor(DesignSystem.Colors.primary)
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}