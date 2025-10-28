import SwiftUI

// MARK: - Market Summary View
struct MarketSummaryView: View {
    @Binding var currentIndex: Int
    
    // Market summaries for each category
    private let marketSummaries = [
        // Europa (Index 0-4: DAX, MDAX, SDAX, TecDAX, EuroStoxx 50)
        "Europa": "Die europäischen Märkte zeigen sich heute überwiegend freundlich. Positive Impulse kommen von robusten Unternehmenszahlen und der stabilen Konjunkturlage in der Eurozone. Der DAX profitiert besonders von starken Autowerten.",
        
        // Nordamerika (Index 5-7: DJ Industrial, Nasdaq 100, S&P 500)
        "Nordamerika": "Die US-Märkte tendieren fest. Tech-Werte führen die Rally an, unterstützt von optimistischen Wachstumsprognosen. Die Fed-Politik bleibt im Fokus der Anleger, während Inflationsdaten Entspannung signalisieren.",
        
        // Asien (Index 8: Nikkei)
        "Asien": "Die asiatischen Börsen zeigen ein gemischtes Bild. Der Nikkei profitiert von der Yen-Schwäche und positiven Exportdaten. Chinesische Konjunkturmaßnahmen sorgen für vorsichtigen Optimismus in der Region.",
        
        // Rohstoffe & Devisen (Index 9-12: Gold, Brent Oil, EUR/Dollar, Bitcoin)
        "Rohstoffe": "Gold bleibt als sicherer Hafen gefragt. Öl-Preise stabilisieren sich auf hohem Niveau durch OPEC-Förderkürzungen. Der Euro zeigt Stärke gegenüber dem Dollar, während Bitcoin neue Jahreshochs testet."
    ]
    
    private var currentCategory: String {
        switch currentIndex {
        case 0...4:
            return "Europa"
        case 5...7:
            return "Nordamerika"
        case 8:
            return "Asien"
        case 9...12:
            return "Rohstoffe"
        default:
            return "Europa"
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
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                Text(marketSummaries[currentCategory] ?? "")
                    .font(DesignSystem.Typography.body1)
                    .foregroundColor(DesignSystem.Colors.onCard)
                    .lineSpacing(4)
                    .animation(.easeInOut(duration: 0.15), value: currentIndex)
                    .id(currentCategory) // Force view refresh for smooth animation
            }
        }
    }
}

// MARK: - Enhanced Market Cards Section
struct EnhancedMarketCardsSection: View {
    @State private var currentIndex = 0
    
    let marketData = [
        // Europa
        MarketCard(name: "DAX", value: "19,432.56", change: "+0.52%", isPositive: true),
        MarketCard(name: "MDAX", value: "26,189.34", change: "+0.74%", isPositive: true),
        MarketCard(name: "SDAX", value: "13,876.42", change: "-0.89%", isPositive: false),
        MarketCard(name: "TecDAX", value: "3,342.18", change: "+1.23%", isPositive: true),
        MarketCard(name: "EuroStoxx 50", value: "4,987.65", change: "+0.65%", isPositive: true),
        // Nordamerika
        MarketCard(name: "DJ Industrial", value: "43,729.93", change: "+0.38%", isPositive: true),
        MarketCard(name: "Nasdaq 100", value: "21,456.32", change: "+1.12%", isPositive: true),
        MarketCard(name: "S&P 500", value: "6,032.38", change: "+0.73%", isPositive: true),
        // Asien
        MarketCard(name: "Nikkei", value: "38,596.47", change: "-0.15%", isPositive: false),
        // Rohstoffe
        MarketCard(name: "Gold", value: "2,654.32", change: "+0.28%", isPositive: true),
        MarketCard(name: "Brent Oil", value: "74.38", change: "-1.45%", isPositive: false),
        MarketCard(name: "EUR/Dollar", value: "1.0532", change: "+0.18%", isPositive: true),
        MarketCard(name: "Bitcoin", value: "96,432.18", change: "+2.87%", isPositive: true)
    ]
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // Market Cards
            TabView(selection: $currentIndex) {
                ForEach(Array(marketData.enumerated()), id: \.offset) { index, card in
                    MarketCardView(card: card)
                        .padding(.horizontal, DesignSystem.Spacing.sm)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 120)
            
            // Dynamic Market Summary
            MarketSummaryView(currentIndex: $currentIndex)
                .padding(.horizontal, DesignSystem.Spacing.md)
        }
    }
}

// Market Card View (reused from existing implementation)
struct MarketCardView: View {
    let card: MarketCard
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(card.name)
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.secondary)
                
                Text(card.value)
                    .font(DesignSystem.Typography.title2)
                    .foregroundColor(DesignSystem.Colors.onBackground)
                
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Image(systemName: card.isPositive ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 12))
                    Text(card.change)
                        .font(DesignSystem.Typography.caption)
                }
                .foregroundColor(card.isPositive ? .green : .red)
            }
            
            Spacer()
            
            // Mini chart placeholder
            MiniChartView(isPositive: card.isPositive)
                .frame(width: 80, height: 40)
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.cardBackground)
        .cornerRadius(DesignSystem.CornerRadius.medium)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Preview
struct MarketSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EnhancedMarketCardsSection()
                .padding()
                .background(DesignSystem.Colors.background)
        }
    }
}