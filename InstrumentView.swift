import SwiftUI

// MARK: - Enhanced Instrument View (Refactored)

struct InstrumentView: View {
    let instrument: InstrumentData
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTimeRange = 0
    @State private var selectedChartType: ChartType = .line
    @State private var showPriceOnChart = false
    @State private var chartTapLocation: CGPoint = .zero
    @State private var chartData: [InstrumentData.ChartPoint] = []
    @EnvironmentObject var watchlistService: WatchlistService
    @State private var showingAddedAlert = false
    @State private var showingMarketplaceSelector = false
    @State private var selectedMarketplace: String = "Frankfurt (EUR)"
    @State private var showingNewsDetail = false
    @State private var showingMetricsDetail = false
    @State private var showingAnalysisDetail = false
    @State private var showingMarketDataDetail = false
    @State private var selectedNewsIndex: Int? = nil
    @State private var showingNewsList = false
    @State private var dragAmount = CGSize.zero
    
    let timeRanges = ["1T", "1W", "1M", "3M", "1J", "5J"]
    
    // Removed sections - no longer needed
    
    // Sample performance data
    let performanceData = [
        (period: "1T", value: 0.5, isPositive: true),
        (period: "1W", value: 2.1, isPositive: true),
        (period: "1M", value: -1.3, isPositive: false),
        (period: "3M", value: 12.5, isPositive: true),
        (period: "YTD", value: 45.2, isPositive: true),
        (period: "1J", value: 67.8, isPositive: true)
    ]
    
    // Sample events
    let sampleEvents = [
        EventsCard.CompanyEvent(title: "Q4 2025 Earnings Call", date: Date().addingTimeInterval(86400 * 30), type: .earnings),
        EventsCard.CompanyEvent(title: "Dividende 0.50€", date: Date().addingTimeInterval(86400 * 45), type: .dividend),
        EventsCard.CompanyEvent(title: "JP Morgan Conference", date: Date().addingTimeInterval(86400 * 60), type: .conference),
        EventsCard.CompanyEvent(title: "Hauptversammlung", date: Date().addingTimeInterval(86400 * 90), type: .other)
    ]
    
    var body: some View {
        NavigationView {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 0) {
                        headerSection
                        
                        // Content Sections
                        VStack(spacing: DesignSystem.Spacing.Section.between) {
                            overviewSection
                            
                            // Kennzahlen
                            metricsSection
                            
                            // Nachrichten
                            newsSection
                            
                            // Analysen & Performance
                            analysisSection
                            
                            // Marktdaten
                            marketDataSection
                            
                            // Termine
                            eventsSection
                        }
                        .padding(.bottom, DesignSystem.Spacing.Page.bottom)
                    }
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(DesignSystem.Colors.onBackground)
                },
                trailing: HStack(spacing: DesignSystem.Spacing.md) {
                    // Bookmark button
                    Button(action: {
                        guard let activeWatchlist = watchlistService.activeWatchlist else { return }

                        if let existingItem = activeWatchlist.items.first(where: { $0.symbol == instrument.symbol }) {
                            watchlistService.removeFromWatchlist(existingItem, fromWatchlist: activeWatchlist)
                        } else {
                            watchlistService.addToWatchlist(
                                symbol: instrument.symbol,
                                name: instrument.name,
                                price: instrument.currentPrice,
                                change: instrument.change,
                                changePercent: instrument.changePercent,
                                isPositive: instrument.isPositive,
                                toWatchlist: activeWatchlist
                            )
                            showingAddedAlert = true
                            
                            // Hide alert after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showingAddedAlert = false
                            }
                        }
                    }) {
                        Image(systemName: watchlistService.isInWatchlist(symbol: instrument.symbol) ? "bookmark.fill" : "bookmark")
                            .foregroundColor(watchlistService.isInWatchlist(symbol: instrument.symbol) ? DesignSystem.Colors.primary : DesignSystem.Colors.onBackground)
                    }
                    
                    // Share button
                    Button(action: {
                        shareInstrument()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(DesignSystem.Colors.onBackground)
                    }
                }
            )
            .onAppear {
                // Initialize chart data only once
                if chartData.isEmpty {
                    chartData = getChartDataForTimeRange()
                }
            }
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
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        withAnimation(.easeOut(duration: 0.2)) {
                            dragAmount = .zero
                        }
                    }
                }
        )
        .overlay(successNotification)
        .sheet(isPresented: $showingMarketplaceSelector) {
            MarketplaceSelectorView(instrument: instrument, selectedMarketplace: $selectedMarketplace)
        }
        .sheet(isPresented: $showingNewsDetail) {
            if let index = selectedNewsIndex {
                NewsDetailView(article: createNewsArticle(for: index))
            }
        }
        .sheet(isPresented: $showingMetricsDetail) {
            InstrumentMetricsDetailView(instrument: instrument)
        }
        .sheet(isPresented: $showingAnalysisDetail) {
            InstrumentAnalysisDetailView(instrument: instrument)
        }
        .sheet(isPresented: $showingMarketDataDetail) {
            InstrumentMarketDataDetailView(instrument: instrument)
        }
        .sheet(isPresented: $showingNewsList) {
            InstrumentNewsDetailView(instrument: instrument)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    companyInfo
                    isinWknInfo
                }
                
                Spacer()
                
                // Marketplace selector button
                Button(action: {
                    showingMarketplaceSelector = true
                }) {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Text(selectedMarketplace)
                            .font(DesignSystem.Typography.body2)
                            .foregroundColor(DesignSystem.Colors.onBackground)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.md)
                    .padding(.vertical, DesignSystem.Spacing.sm)
                    .background(DesignSystem.Colors.surface)
                    .cornerRadius(DesignSystem.CornerRadius.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                            .stroke(DesignSystem.Colors.border, lineWidth: 1)
                    )
                }
            }
            
            priceInfo
        }
        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
        .padding(.top, DesignSystem.Spacing.Page.top)
    }
    
    private var companyInfo: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            // Company logo
            stockLogo(for: instrument.symbol, size: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(instrument.symbol.replacingOccurrences(of: "^", with: ""))
                    .font(DesignSystem.Typography.title1)
                    .foregroundColor(DesignSystem.Colors.onBackground)
                Text(instrument.name)
                    .font(DesignSystem.Typography.body2)
                    .foregroundColor(DesignSystem.Colors.secondary)
            }
        }
    }
    
    private var isinWknInfo: some View {
        Group {
            if let isin = instrument.isin, let wkn = instrument.wkn {
                HStack(spacing: DesignSystem.Spacing.md) {
                    Text("ISIN: \(isin)")
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.tertiary)
                    
                    Text("|")
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.separator)
                    
                    Text("WKN: \(wkn)")
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.tertiary)
                }
                .padding(.leading, 44) // Align with company name
            }
        }
    }
    
    private var priceInfo: some View {
        HStack(alignment: .bottom) {
            Text(String(format: "%.2f", instrument.currentPrice))
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(DesignSystem.Colors.onBackground)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Image(systemName: instrument.isPositive ? "arrow.up" : "arrow.down")
                        .font(.system(size: 12))
                    Text(String(format: "%.2f (%.2f%%)", instrument.change, instrument.changePercent))
                        .font(DesignSystem.Typography.body1)
                }
                .foregroundColor(instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            // Chart
            VStack(spacing: DesignSystem.Spacing.md) {
                chartView

                // Chart Type Section
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text("Chart-Typ")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.tertiary)
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)

                    chartTypeSelector
                }

                // Divider
                Rectangle()
                    .fill(DesignSystem.Colors.border)
                    .frame(height: 1)
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)

                // Time Range Section
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text("Zeitraum")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.tertiary)
                        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)

                    timeRangeSelector
                }
            }
        }
    }

    private var chartTypeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                ForEach(ChartType.allCases, id: \.self) { type in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedChartType = type
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: type.icon)
                                .font(.system(size: 11))
                            Text(type.rawValue)
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(selectedChartType == type ? .white : DesignSystem.Colors.secondary)
                        .padding(.horizontal, DesignSystem.Spacing.md)
                        .padding(.vertical, DesignSystem.Spacing.sm)
                        .background(selectedChartType == type ? DesignSystem.Colors.primary : DesignSystem.Colors.surface)
                        .cornerRadius(DesignSystem.CornerRadius.md)
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
        }
    }

    private var timeRangeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.md) {
                ForEach(Array(timeRanges.enumerated()), id: \.offset) { index, range in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTimeRange = index
                            chartData = getChartDataForTimeRange()
                        }
                    }) {
                        Text(range)
                            .font(DesignSystem.Typography.body2)
                            .foregroundColor(selectedTimeRange == index ? .white : DesignSystem.Colors.secondary)
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                            .padding(.vertical, DesignSystem.Spacing.sm)
                            .background(selectedTimeRange == index ? DesignSystem.Colors.primary : DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.CornerRadius.md)
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
        }
    }
    
    private var chartView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                .fill(DesignSystem.Colors.surface)
                .frame(height: 200)

            // Use stored chart data - prevents regeneration on state changes
            GeometryReader { geometry in
                ZStack {
                    // Render chart based on selected type
                    switch selectedChartType {
                    case .line:
                        lineChart(geometry: geometry)
                    case .area:
                        areaChart(geometry: geometry)
                    case .candle:
                        candleChart(geometry: geometry)
                    case .ohlc:
                        ohlcChart(geometry: geometry)
                    case .percent:
                        percentChart(geometry: geometry)
                    }

                    // Price indicator on tap
                    if showPriceOnChart {
                        VStack {
                            Text(String(format: "%.2f €", instrument.currentPrice))
                                .font(DesignSystem.Typography.caption1)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(DesignSystem.Colors.primary)
                                .cornerRadius(DesignSystem.CornerRadius.sm)
                        }
                        .position(chartTapLocation)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { location in
                    chartTapLocation = location
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showPriceOnChart = true
                    }

                    // Hide after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            showPriceOnChart = false
                        }
                    }
                }
            }
            .padding()
        }
        .frame(height: 200)
        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
    }
    
    // MARK: - Other Sections
    private var analysisSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
            Button(action: {
                showingAnalysisDetail = true
            }) {
                HStack {
                    Text("Analysen & Performance")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
            
            Button(action: {
                showingAnalysisDetail = true
            }) {
                simpleAnalysisCard
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var marketDataSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
            Button(action: {
                showingMarketDataDetail = true
            }) {
                HStack {
                    Text("Marktdaten")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
            
            Button(action: {
                showingMarketDataDetail = true
            }) {
                simpleMarketDataCard
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
            Button(action: {
                showingMetricsDetail = true
            }) {
                HStack {
                    Text("Kennzahlen")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
            
            Button(action: {
                showingMetricsDetail = true
            }) {
                metricsCard
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var metricsCard: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            VStack(spacing: 0) {
                // Show only first 3 metrics in preview
                SimpleStatRow(title: "Tageshoch", value: String(format: "%.2f", instrument.dayHigh))
                SimpleStatRow(title: "Tagestief", value: String(format: "%.2f", instrument.dayLow))
                SimpleStatRow(title: "Volumen", value: formatVolume(instrument.volume))
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
    }
    
    private var newsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
            Button(action: {
                showingNewsList = true
            }) {
                HStack {
                    Text("Nachrichten")
                        .font(DesignSystem.Typography.title2)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
            
            newsCard
        }
    }
    
    private var newsCard: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            VStack(spacing: DesignSystem.Spacing.md) {
                ForEach(0..<3) { index in
                    Button(action: {
                        selectedNewsIndex = index
                        showingNewsDetail = true
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                Text(getNewsTitle(for: index))
                                    .font(DesignSystem.Typography.body2)
                                    .foregroundColor(DesignSystem.Colors.onCard)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                                
                                Text("vor \(index + 1) Stunden")
                                    .font(DesignSystem.Typography.caption2)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(DesignSystem.Colors.secondary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if index < 2 {
                        DSSeparator()
                    }
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
    }
    
    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
            Text("Termine")
                .font(DesignSystem.Typography.title2)
                .foregroundColor(DesignSystem.Colors.onBackground)
                .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.Spacing.Cards.gap) {
                    ForEach(sampleEvents, id: \.title) { event in
                        EventCard(event: event)
                            .frame(width: 280)
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                .padding(.vertical, DesignSystem.Spacing.Cards.shadowPadding)
            }
        }
    }
    
    // MARK: - Simple Cards
    private var simpleAnalysisCard: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            VStack(spacing: DesignSystem.Spacing.lg) {
                // Community Stimmung - Simplified
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("Community Stimmung")
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.tertiary)
                        
                        HStack {
                            Text("70% Kaufen")
                                .font(DesignSystem.Typography.body2)
                                .foregroundColor(DesignSystem.Colors.success)
                            Spacer()
                            Text("30% Verkaufen")
                                .font(DesignSystem.Typography.body2)
                                .foregroundColor(DesignSystem.Colors.error)
                        }
                    }
                    
                    // Analysten Konsens
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("Analysten Konsens")
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.tertiary)
                        
                        HStack {
                            Text("KAUFEN")
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.success)
                            
                            Spacer()
                            
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < 4 ? "star.fill" : "star")
                                        .font(.system(size: 12))
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                    }
                    
                    // 52 Wochen Spanne
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("52 Wochen Spanne")
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.tertiary)
                        
                        HStack {
                            Text(String(format: "%.2f", instrument.weekLow52 ?? 0))
                                .font(DesignSystem.Typography.body2)
                                .foregroundColor(DesignSystem.Colors.secondary)
                            
                            Spacer()
                            
                            Text(String(format: "%.2f", instrument.weekHigh52 ?? 0))
                                .font(DesignSystem.Typography.body2)
                                .foregroundColor(DesignSystem.Colors.secondary)
                        }
                    }
                }
            }
        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
    }
    
    private func getNewsTitle(for index: Int) -> String {
        let titles = [
            "Analysten sehen weiteres Kurspotenzial",
            "Quartalszahlen übertreffen Erwartungen deutlich",
            "Neue Partnerschaft mit führendem Technologieunternehmen",
            "Expansion in den asiatischen Markt geplant",
            "CEO kündigt strategische Neuausrichtung an"
        ]
        return titles[index % titles.count]
    }
    
    private func getNewsSource(for index: Int) -> String {
        let sources = ["Handelsblatt", "FAZ", "Reuters", "Bloomberg", "CNBC"]
        return sources[index % sources.count]
    }
    
    private var simpleMarketDataCard: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            VStack(spacing: 0) {
                SimpleStatRow(title: "Börse", value: instrument.exchange ?? "NASDAQ")
                SimpleStatRow(title: "Geld", value: String(format: "%.2f", instrument.bid ?? 0))
                SimpleStatRow(title: "Brief", value: String(format: "%.2f", instrument.ask ?? 0))
                SimpleStatRow(title: "Spread", value: String(format: "%.2f", (instrument.ask ?? 0) - (instrument.bid ?? 0)))
                SimpleStatRow(title: "Letztes Update", value: formatTime(instrument.lastUpdate ?? Date()))
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    // MARK: - Success Notification
    private var successNotification: some View {
        Group {
            if showingAddedAlert {
                VStack {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                        Text("Zu Watchlist hinzugefügt")
                            .font(DesignSystem.Typography.body2)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    .padding(.vertical, DesignSystem.Spacing.md)
                    .background(DesignSystem.Colors.success)
                    .cornerRadius(DesignSystem.CornerRadius.md)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .padding(.top, 50)
                    
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: showingAddedAlert)
            }
        }
    }
    
    // MARK: - Chart Rendering Functions

    private func lineChart(geometry: GeometryProxy) -> some View {
        Path { path in
            guard !chartData.isEmpty else { return }

            let minValue = chartData.map { $0.value }.min() ?? 0
            let maxValue = chartData.map { $0.value }.max() ?? 100
            let valueRange = maxValue - minValue

            for (index, point) in chartData.enumerated() {
                let x = CGFloat(index) / CGFloat(chartData.count - 1) * geometry.size.width
                let y = (1 - CGFloat((point.value - minValue) / valueRange)) * geometry.size.height

                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        .stroke(instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error, lineWidth: 2)
    }

    private func areaChart(geometry: GeometryProxy) -> some View {
        ZStack {
            // Fill area
            Path { path in
                guard !chartData.isEmpty else { return }

                let minValue = chartData.map { $0.value }.min() ?? 0
                let maxValue = chartData.map { $0.value }.max() ?? 100
                let valueRange = maxValue - minValue

                // Start at bottom left
                path.move(to: CGPoint(x: 0, y: geometry.size.height))

                for (index, point) in chartData.enumerated() {
                    let x = CGFloat(index) / CGFloat(chartData.count - 1) * geometry.size.width
                    let y = (1 - CGFloat((point.value - minValue) / valueRange)) * geometry.size.height

                    if index == 0 {
                        path.addLine(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }

                // Close path at bottom right
                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    colors: [
                        (instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error).opacity(0.3),
                        (instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error).opacity(0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            // Line on top
            lineChart(geometry: geometry)
        }
    }

    private func candleChart(geometry: GeometryProxy) -> some View {
        // Calculate min/max including high/low values
        var allValues: [Double] = []
        for point in chartData {
            let open = point.open ?? point.value * 0.995
            let close = point.close ?? point.value
            let high = point.high ?? max(open, close) * 1.002
            let low = point.low ?? min(open, close) * 0.998
            allValues.append(contentsOf: [open, close, high, low])
        }
        let minValue = allValues.min() ?? 0
        let maxValue = allValues.max() ?? 100
        let valueRange = maxValue - minValue
        let candleWidth = geometry.size.width / CGFloat(chartData.count) * 0.6

        return ZStack {
            ForEach(Array(chartData.enumerated()), id: \.offset) { index, point in
                let x = CGFloat(index) / CGFloat(chartData.count - 1) * geometry.size.width
                let open = point.open ?? point.value * 0.995
                let close = point.close ?? point.value
                let high = point.high ?? max(open, close) * 1.002
                let low = point.low ?? min(open, close) * 0.998

                let isPositive = close >= open

                let yHigh = (1 - CGFloat((high - minValue) / valueRange)) * geometry.size.height
                let yLow = (1 - CGFloat((low - minValue) / valueRange)) * geometry.size.height
                let yOpen = (1 - CGFloat((open - minValue) / valueRange)) * geometry.size.height
                let yClose = (1 - CGFloat((close - minValue) / valueRange)) * geometry.size.height

                ZStack {
                    // Wick (high-low line)
                    Path { path in
                        path.move(to: CGPoint(x: x, y: yHigh))
                        path.addLine(to: CGPoint(x: x, y: yLow))
                    }
                    .stroke(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error, lineWidth: 1)

                    // Body (open-close rectangle)
                    Rectangle()
                        .fill(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                        .frame(width: candleWidth, height: abs(yClose - yOpen) + 1)
                        .position(x: x, y: (yOpen + yClose) / 2)
                }
            }
        }
    }

    private func ohlcChart(geometry: GeometryProxy) -> some View {
        // Calculate min/max including high/low values
        var allValues: [Double] = []
        for point in chartData {
            let open = point.open ?? point.value * 0.995
            let close = point.close ?? point.value
            let high = point.high ?? max(open, close) * 1.002
            let low = point.low ?? min(open, close) * 0.998
            allValues.append(contentsOf: [open, close, high, low])
        }
        let minValue = allValues.min() ?? 0
        let maxValue = allValues.max() ?? 100
        let valueRange = maxValue - minValue
        let tickWidth = geometry.size.width / CGFloat(chartData.count) * 0.3

        return ZStack {
            ForEach(Array(chartData.enumerated()), id: \.offset) { index, point in
                let x = CGFloat(index) / CGFloat(chartData.count - 1) * geometry.size.width
                let open = point.open ?? point.value * 0.995
                let close = point.close ?? point.value
                let high = point.high ?? max(open, close) * 1.002
                let low = point.low ?? min(open, close) * 0.998

                let isPositive = close >= open

                let yHigh = (1 - CGFloat((high - minValue) / valueRange)) * geometry.size.height
                let yLow = (1 - CGFloat((low - minValue) / valueRange)) * geometry.size.height
                let yOpen = (1 - CGFloat((open - minValue) / valueRange)) * geometry.size.height
                let yClose = (1 - CGFloat((close - minValue) / valueRange)) * geometry.size.height

                Path { path in
                    // Vertical line (high to low)
                    path.move(to: CGPoint(x: x, y: yHigh))
                    path.addLine(to: CGPoint(x: x, y: yLow))

                    // Left tick (open)
                    path.move(to: CGPoint(x: x - tickWidth, y: yOpen))
                    path.addLine(to: CGPoint(x: x, y: yOpen))

                    // Right tick (close)
                    path.move(to: CGPoint(x: x, y: yClose))
                    path.addLine(to: CGPoint(x: x + tickWidth, y: yClose))
                }
                .stroke(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error, lineWidth: 1.5)
            }
        }
    }

    private func percentChart(geometry: GeometryProxy) -> some View {
        guard let firstValue = chartData.first?.value, firstValue > 0 else {
            return AnyView(EmptyView())
        }

        let percentData = chartData.map { ($0.value - firstValue) / firstValue * 100 }
        let minPercent = percentData.min() ?? 0
        let maxPercent = percentData.max() ?? 100
        let percentRange = maxPercent - minPercent

        return AnyView(
            ZStack {
                // Zero line
                Path { path in
                    let zeroY = percentRange > 0 ? (1 - CGFloat((0 - minPercent) / percentRange)) * geometry.size.height : geometry.size.height / 2
                    path.move(to: CGPoint(x: 0, y: zeroY))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: zeroY))
                }
                .stroke(DesignSystem.Colors.secondary.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5]))

                // Percent line
                Path { path in
                    for (index, percent) in percentData.enumerated() {
                        let x = CGFloat(index) / CGFloat(percentData.count - 1) * geometry.size.width
                        let y = percentRange > 0 ? (1 - CGFloat((percent - minPercent) / percentRange)) * geometry.size.height : geometry.size.height / 2

                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error, lineWidth: 2)
            }
        )
    }

    // MARK: - Helper Methods

    private func getChartDataForTimeRange() -> [InstrumentData.ChartPoint] {
        // Generate different data based on selected time range
        let basePrice = instrument.currentPrice
        let volatility: Double
        let dataPoints: Int
        
        switch selectedTimeRange {
        case 0: // 1T
            dataPoints = 24
            volatility = 0.5
        case 1: // 1W
            dataPoints = 7
            volatility = 2.0
        case 2: // 1M
            dataPoints = 30
            volatility = 5.0
        case 3: // 3M
            dataPoints = 90
            volatility = 10.0
        case 4: // 1J
            dataPoints = 52
            volatility = 20.0
        case 5: // 5J
            dataPoints = 60
            volatility = 50.0
        default:
            dataPoints = 24
            volatility = 0.5
        }
        
        var chartData: [InstrumentData.ChartPoint] = []
        var currentValue = basePrice * (1 - volatility / 100)

        for i in 0..<dataPoints {
            let date = Date().addingTimeInterval(-Double(dataPoints - i) * 86400)
            let randomChange = Double.random(in: -volatility...volatility) / 100
            currentValue *= (1 + randomChange)

            // Generate OHLC data for candle/OHLC charts
            let open = currentValue * (1 + Double.random(in: -0.5...0.5) / 100)
            let close = currentValue
            let high = max(open, close) * (1 + Double.random(in: 0...1) / 100)
            let low = min(open, close) * (1 - Double.random(in: 0...1) / 100)

            chartData.append(InstrumentData.ChartPoint(
                time: date,
                value: currentValue,
                open: open,
                high: high,
                low: low,
                close: close
            ))
        }

        // Ensure last point is current price
        if let lastIndex = chartData.indices.last {
            let lastDate = chartData[lastIndex].time
            let open = basePrice * 0.998
            let high = basePrice * 1.002
            let low = basePrice * 0.997
            chartData[lastIndex] = InstrumentData.ChartPoint(
                time: lastDate,
                value: basePrice,
                open: open,
                high: high,
                low: low,
                close: basePrice
            )
        }

        return chartData
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
    
    private func createNewsArticle(for index: Int) -> NewsArticle {
        let title = getNewsTitle(for: index)
        return NewsArticle(
            title: title,
            category: "Unternehmensnachrichten",
            time: "vor \(index + 1) Stunden",
            source: "FinanzNachrichten",
            hasImage: true,
            body: """
            \(title)
            
            Die neuesten Entwicklungen rund um \(instrument.name) zeigen interessante Marktbewegungen. Der aktuelle Kurs liegt bei \(String(format: "%.2f", instrument.currentPrice)) EUR mit einer Veränderung von \(instrument.isPositive ? "+" : "")\(String(format: "%.2f%%", instrument.changePercent)).
            
            Analysten sehen weiterhin Potenzial in der Aktie und bewerten die jüngsten Unternehmensentscheidungen positiv. Die Marktkapitalisierung beträgt derzeit \(instrument.marketCap).
            
            In den kommenden Wochen werden weitere wichtige Unternehmensereignisse erwartet, die den Kurs beeinflussen könnten.
            """,
            mentionedInstruments: [
                NewsInstrument(
                    symbol: instrument.symbol,
                    name: instrument.name,
                    price: String(format: "€%.2f", instrument.currentPrice),
                    change: String(format: "%.2f%%", instrument.changePercent),
                    isPositive: instrument.isPositive
                )
            ]
        )
    }
    
    private func shareInstrument() {
        let shareText = "\(instrument.name) (\(instrument.symbol))\nAktueller Kurs: \(String(format: "%.2f", instrument.currentPrice)) \(instrument.change >= 0 ? "+" : "")\(String(format: "%.2f", instrument.change)) (\(instrument.change >= 0 ? "+" : "")\(String(format: "%.2f%%", instrument.changePercent)))\n\nGeteilt aus der FinanzNachrichten App"
        
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

// MARK: - Supporting Views

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(DesignSystem.Typography.body2)
                .foregroundColor(DesignSystem.Colors.secondary)
            
            Spacer()
            
            Text(value)
                .font(DesignSystem.Typography.body1)
                .foregroundColor(DesignSystem.Colors.onCard)
                .fontWeight(.medium)
        }
    }
}

struct SimpleStatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(DesignSystem.Typography.body2)
                .foregroundColor(DesignSystem.Colors.tertiary)
            
            Spacer()
            
            Text(value)
                .font(DesignSystem.Typography.body1)
                .foregroundColor(DesignSystem.Colors.onCard)
                .fontWeight(.semibold)
        }
        .padding(.vertical, DesignSystem.Spacing.sm)
    }
}

// MARK: - Event Card
struct EventCard: View {
    let event: EventsCard.CompanyEvent
    
    var body: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                // Event Type Badge
                HStack {
                    Text(event.type.displayName)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(.white)
                        .padding(.horizontal, DesignSystem.Spacing.sm)
                        .padding(.vertical, 4)
                        .background(event.type.color)
                        .cornerRadius(DesignSystem.CornerRadius.sm)
                    
                    Spacer()
                }
                
                // Event Title
                Text(event.title)
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.onCard)
                    .lineLimit(2)
                
                // Date
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(DesignSystem.Colors.secondary)
                    
                    Text(formatEventDate(event.date))
                        .font(DesignSystem.Typography.body2)
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
            }
        }
    }
    
    private func formatEventDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "dd. MMM yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Marketplace Selector View 
struct MarketplaceSelectorView: View {
    let instrument: InstrumentData
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedMarketplace: String
    @State private var dragAmount = CGSize.zero
    
    let marketplaces = [
        MarketplaceData(name: "Berlin (EUR)", time: "20.06.25, 19:45 Uhr", volume: "1.600 Stk.", dayHigh: 15.515, dayLow: 15.230, bid: 15.495, bidVolume: "1.500 Stk.", ask: 15.525, askVolume: "1.500 Stk."),
        MarketplaceData(name: "Düsseldorf (EUR)", time: "20.06.25, 19:31 Uhr", volume: "2.660 Stk.", dayHigh: 15.460, dayLow: 15.170, bid: 15.480, bidVolume: "900 Stk.", ask: 15.545, askVolume: "900 Stk."),
        MarketplaceData(name: "Frankfurt (EUR)", time: "20.06.25, 19:45 Uhr", volume: "10.563 Stk.", dayHigh: 15.540, dayLow: 15.145, bid: 15.495, bidVolume: "1.500 Stk.", ask: 15.520, askVolume: "2.000 Stk."),
        MarketplaceData(name: "Hamburg (EUR)", time: "20.06.25, 12:01 Uhr", volume: "200 Stk.", dayHigh: 15.250, dayLow: 15.225, bid: 15.495, bidVolume: "646 Stk.", ask: 15.520, askVolume: "645 Stk."),
        MarketplaceData(name: "Hannover (EUR)", time: "20.06.25, 08:16 Uhr", volume: "0 Stk.", dayHigh: 15.225, dayLow: 15.225, bid: 15.495, bidVolume: "646 Stk.", ask: 15.520, askVolume: "645 Stk."),
        MarketplaceData(name: "Lang & Schwarz (EUR)", time: "21.06.25, 13:04 Uhr", volume: "0 Stk.", dayHigh: 15.518, dayLow: 15.518, bid: 15.505, bidVolume: "0 Stk.", ask: 15.530, askVolume: "0 Stk."),
        MarketplaceData(name: "München (EUR)", time: "20.06.25, 19:45 Uhr", volume: "4.100 Stk.", dayHigh: 15.515, dayLow: 15.235, bid: 15.495, bidVolume: "2.000 Stk.", ask: 15.525, askVolume: "1.500 Stk."),
        MarketplaceData(name: "Stuttgart (EUR)", time: "20.06.25, 21:59 Uhr", volume: "0 Stk.", dayHigh: 0.0, dayLow: 0.0, bid: 0.0, bidVolume: "0 Stk.", ask: 0.0, askVolume: "0 Stk.")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with instrument info (fixed at top)
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        HStack(spacing: DesignSystem.Spacing.sm) {
                            // Company logo
                            stockLogo(for: instrument.symbol, size: 40)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(instrument.name)
                                    .font(DesignSystem.Typography.title2)
                                    .foregroundColor(DesignSystem.Colors.onBackground)
                                HStack(spacing: DesignSystem.Spacing.sm) {
                                    if let isin = instrument.isin {
                                        Text("ISIN: \(isin)")
                                            .font(DesignSystem.Typography.caption2)
                                            .foregroundColor(DesignSystem.Colors.secondary)
                                    }
                                    if instrument.isin != nil && instrument.wkn != nil {
                                        Text("|")
                                            .font(DesignSystem.Typography.caption2)
                                            .foregroundColor(DesignSystem.Colors.separator)
                                    }
                                    if let wkn = instrument.wkn {
                                        Text("WKN: \(wkn)")
                                            .font(DesignSystem.Typography.caption2)
                                            .foregroundColor(DesignSystem.Colors.secondary)
                                    }
                                }
                            }
                        }
                    }
                    .padding(DesignSystem.Spacing.lg)
                    .background(DesignSystem.Colors.surface)
                
                // Marketplace list (scrollable)
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(marketplaces, id: \.name) { marketplace in
                            MarketplaceRow(
                                marketplace: marketplace,
                                isSelected: selectedMarketplace == marketplace.name,
                                onTap: {
                                    selectedMarketplace = marketplace.name
                                    presentationMode.wrappedValue.dismiss()
                                }
                            )
                        }
                    }
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Marktplatz auswählen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Zurück")
                                .font(DesignSystem.Typography.body1)
                        }
                        .foregroundColor(DesignSystem.Colors.onBackground)
                    }
                }
                
            }
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
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        withAnimation(.easeOut(duration: 0.2)) {
                            dragAmount = .zero
                        }
                    }
                }
        )
    }
}

struct MarketplaceData {
    let name: String
    let time: String
    let volume: String
    let dayHigh: Double
    let dayLow: Double
    let bid: Double
    let bidVolume: String
    let ask: Double
    let askVolume: String
}

struct MarketplaceRow: View {
    let marketplace: MarketplaceData
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            DSCard(
                backgroundColor: DesignSystem.Colors.cardBackground,
                borderColor: isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.border,
                cornerRadius: DesignSystem.CornerRadius.lg,
                padding: DesignSystem.Spacing.lg,
                hasShadow: true
            ) {
                VStack(spacing: DesignSystem.Spacing.md) {
                    // Header: Title, Time, and Selection
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                            Text(marketplace.name.replacingOccurrences(of: " (EUR)", with: ""))
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.onCard)
                            
                            HStack(spacing: DesignSystem.Spacing.xs) {
                                Image(systemName: "clock")
                                    .font(.system(size: 10))
                                    .foregroundColor(DesignSystem.Colors.secondary)
                                Text(marketplace.time)
                                    .font(DesignSystem.Typography.caption2)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                    }
                    
                    DSSeparator()
                    
                    // Trading Data
                    HStack(spacing: DesignSystem.Spacing.xl) {
                        // Volume
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                            HStack(spacing: DesignSystem.Spacing.xs) {
                                Image(systemName: "chart.bar")
                                    .font(.system(size: 10))
                                    .foregroundColor(DesignSystem.Colors.tertiary)
                                Text("Umsatz")
                                    .font(DesignSystem.Typography.caption2)
                                    .foregroundColor(DesignSystem.Colors.tertiary)
                            }
                            Text(marketplace.volume)
                                .font(DesignSystem.Typography.body1)
                                .foregroundColor(DesignSystem.Colors.onCard)
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        // High/Low
                        VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                            HStack(spacing: DesignSystem.Spacing.md) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Hoch")
                                        .font(DesignSystem.Typography.caption2)
                                        .foregroundColor(DesignSystem.Colors.tertiary)
                                    Text(marketplace.dayHigh > 0 ? String(format: "%.3f", marketplace.dayHigh) : "-")
                                        .font(DesignSystem.Typography.body2)
                                        .foregroundColor(DesignSystem.Colors.success)
                                        .fontWeight(.medium)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Tief")
                                        .font(DesignSystem.Typography.caption2)
                                        .foregroundColor(DesignSystem.Colors.tertiary)
                                    Text(marketplace.dayLow > 0 ? String(format: "%.3f", marketplace.dayLow) : "-")
                                        .font(DesignSystem.Typography.body2)
                                        .foregroundColor(DesignSystem.Colors.error)
                                        .fontWeight(.medium)
                                }
                            }
                        }
                    }
                    
                    // Bid/Ask Section
                    HStack(spacing: DesignSystem.Spacing.md) {
                        // Bid
                        HStack(spacing: 0) {
                            Spacer()
                            VStack(spacing: 2) {
                                Text("Geld")
                                    .font(DesignSystem.Typography.caption1)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                                HStack(spacing: DesignSystem.Spacing.xs) {
                                    Text(marketplace.bid > 0 ? String(format: "%.3f", marketplace.bid) : "-")
                                        .font(DesignSystem.Typography.headline)
                                        .foregroundColor(DesignSystem.Colors.success)
                                        .fontWeight(.bold)
                                    Text("EUR")
                                        .font(DesignSystem.Typography.caption1)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                }
                                Text(marketplace.bidVolume)
                                    .font(DesignSystem.Typography.caption2)
                                    .foregroundColor(DesignSystem.Colors.tertiary)
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignSystem.Spacing.sm)
                        .background(DesignSystem.Colors.secondary.opacity(0.08))
                        .cornerRadius(DesignSystem.CornerRadius.md)
                        
                        // Ask
                        HStack(spacing: 0) {
                            Spacer()
                            VStack(spacing: 2) {
                                Text("Brief")
                                    .font(DesignSystem.Typography.caption1)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                                HStack(spacing: DesignSystem.Spacing.xs) {
                                    Text(marketplace.ask > 0 ? String(format: "%.3f", marketplace.ask) : "-")
                                        .font(DesignSystem.Typography.headline)
                                        .foregroundColor(DesignSystem.Colors.error)
                                        .fontWeight(.bold)
                                    Text("EUR")
                                        .font(DesignSystem.Typography.caption1)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                }
                                Text(marketplace.askVolume)
                                    .font(DesignSystem.Typography.caption2)
                                    .foregroundColor(DesignSystem.Colors.tertiary)
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignSystem.Spacing.sm)
                        .background(DesignSystem.Colors.secondary.opacity(0.08))
                        .cornerRadius(DesignSystem.CornerRadius.md)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
        .padding(.vertical, DesignSystem.Spacing.sm)
    }
}

// MARK: - News Detail View
struct InstrumentNewsDetailView: View {
    let instrument: InstrumentData
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategory = "Alle"
    
    let newsCategories = ["Alle", "Pressemitteilungen", "Empfehlungen", "Chartanalysen", "Berichte"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category Segmented Control
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.Spacing.sm) {
                        ForEach(newsCategories, id: \.self) { category in
                            Button(action: {
                                withAnimation(DesignSystem.Animation.spring) {
                                    selectedCategory = category
                                }
                            }) {
                                Text(category)
                                    .font(DesignSystem.Typography.body2)
                                    .foregroundColor(selectedCategory == category ? DesignSystem.Colors.onPrimary : DesignSystem.Colors.onBackground)
                                    .padding(.horizontal, DesignSystem.Spacing.lg)
                                    .padding(.vertical, DesignSystem.Spacing.sm)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.full)
                                            .fill(selectedCategory == category ? DesignSystem.Colors.primary : DesignSystem.Colors.surface)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.full)
                                                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
                                            )
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    .padding(.vertical, DesignSystem.Spacing.md)
                }
                
                DSSeparator()
                
                ScrollView {
                    newsContent
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Nachrichten zu \(instrument.symbol.replacingOccurrences(of: "^", with: ""))")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private var newsContent: some View {
        VStack(spacing: 0) {
            ForEach(Array(filteredNewsItems.enumerated()), id: \.offset) { index, newsItem in
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: DesignSystem.Spacing.md) {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                            Text(newsItem.title)
                                .font(DesignSystem.Typography.body1)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            
                            HStack {
                                Text(newsItem.source)
                                    .font(DesignSystem.Typography.caption1)
                                    .foregroundColor(DesignSystem.Colors.primary)
                                
                                Text("•")
                                    .font(DesignSystem.Typography.caption1)
                                    .foregroundColor(DesignSystem.Colors.tertiary)
                                
                                Text(newsItem.time)
                                    .font(DesignSystem.Typography.caption1)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    .padding(.vertical, DesignSystem.Spacing.xl)
                    
                    if index < filteredNewsItems.count - 1 {
                        DSSeparator()
                            .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    }
                }
            }
        }
    }
    
    private var newsItems: [(title: String, time: String, source: String, category: String)] {
        [
            (title: "\(instrument.name) meldet Rekordumsatz im letzten Quartal", time: "vor 1 Stunden", source: "Nachrichten", category: "Berichte"),
            (title: "Analysten erhöhen Kursziel für \(instrument.symbol)", time: "vor 2 Stunden", source: "Nachrichten", category: "Empfehlungen"),
            (title: "\(instrument.name) kündigt neue Produktlinie an", time: "vor 3 Stunden", source: "Nachrichten", category: "Pressemitteilungen"),
            (title: "Starke Nachfrage treibt \(instrument.symbol) Aktie", time: "vor 4 Stunden", source: "Nachrichten", category: "Chartanalysen"),
            (title: "\(instrument.name) übertrifft Gewinnerwartungen", time: "vor 5 Stunden", source: "Nachrichten", category: "Berichte"),
            (title: "Neue Partnerschaft stärkt \(instrument.name) Position", time: "vor 6 Stunden", source: "Nachrichten", category: "Pressemitteilungen"),
            (title: "\(instrument.symbol): Positive Analystenkommentare", time: "vor 7 Stunden", source: "Nachrichten", category: "Empfehlungen"),
            (title: "\(instrument.name) expandiert in neue Märkte", time: "vor 8 Stunden", source: "Nachrichten", category: "Pressemitteilungen")
        ]
    }
    
    private var filteredNewsItems: [(title: String, time: String, source: String, category: String)] {
        if selectedCategory == "Alle" {
            return newsItems
        } else {
            return newsItems.filter { $0.category == selectedCategory }
        }
    }
    
    private func getNewsTitle(for index: Int) -> String {
        let titles = [
            "\(instrument.name) meldet Rekordumsatz im letzten Quartal",
            "Analysten erhöhen Kursziel für \(instrument.symbol)",
            "\(instrument.name) kündigt neue Produktlinie an",
            "Starke Nachfrage treibt \(instrument.symbol) Aktie",
            "\(instrument.name) übertrifft Gewinnerwartungen",
            "Neue Partnerschaft stärkt \(instrument.name) Position",
            "\(instrument.symbol): Positive Analystenkommentare",
            "\(instrument.name) expandiert in neue Märkte"
        ]
        return titles[index % titles.count]
    }
    
    private func getNewsSource(for index: Int) -> String {
        let sources = ["Reuters", "Bloomberg", "CNBC", "Financial Times", "Wall Street Journal", "Handelsblatt"]
        return sources[index % sources.count]
    }
}

// MARK: - Metrics Detail View
struct InstrumentMetricsDetailView: View {
    let instrument: InstrumentData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.Section.between) {
                    // Basic Metrics
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: 0) {
                            SectionHeader(title: "Handelsdaten")
                            
                            DetailStatRow(title: "Aktueller Kurs", value: String(format: "%.2f", instrument.currentPrice))
                            DetailStatRow(title: "Tageshoch", value: String(format: "%.2f", instrument.dayHigh))
                            DetailStatRow(title: "Tagestief", value: String(format: "%.2f", instrument.dayLow))
                            DetailStatRow(title: "52W Hoch", value: String(format: "%.2f", instrument.weekHigh52 ?? 0.0))
                            DetailStatRow(title: "52W Tief", value: String(format: "%.2f", instrument.weekLow52 ?? 0.0))
                            DetailStatRow(title: "Volumen", value: formatVolume(instrument.volume))
                            DetailStatRow(title: "Ø Volumen (30T)", value: formatVolume(Int(Double(instrument.volume) * 0.85)))
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
                    // Valuation Metrics
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: 0) {
                            SectionHeader(title: "Bewertung")
                            
                            DetailStatRow(title: "Marktkapitalisierung", value: instrument.marketCap)
                            DetailStatRow(title: "KGV", value: String(format: "%.2f", instrument.pe ?? 0.0))
                            DetailStatRow(title: "Beta", value: String(format: "%.2f", instrument.beta ?? 0.0))
                            DetailStatRow(title: "Dividendenrendite", value: String(format: "%.2f%%", instrument.dividendYield ?? 0.0))
                            DetailStatRow(title: "EPS", value: String(format: "%.2f", instrument.currentPrice / (instrument.pe ?? 1.0)))
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
                    // Trading Info
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: 0) {
                            SectionHeader(title: "Handelsinfo")
                            
                            DetailStatRow(title: "Geld", value: String(format: "%.2f", instrument.bid ?? 0.0))
                            DetailStatRow(title: "Brief", value: String(format: "%.2f", instrument.ask ?? 0.0))
                            DetailStatRow(title: "Spread", value: String(format: "%.2f", (instrument.ask ?? 0.0) - (instrument.bid ?? 0.0)))
                            DetailStatRow(title: "Börse", value: instrument.exchange ?? "N/A")
                            DetailStatRow(title: "Währung", value: "EUR")
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                }
                .padding(.vertical, DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Kennzahlen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        presentationMode.wrappedValue.dismiss()
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
}

// MARK: - Analysis Detail View
struct InstrumentAnalysisDetailView: View {
    let instrument: InstrumentData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.Section.between) {
                    // Analyst Ratings
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            SectionHeader(title: "Analystenempfehlungen")
                            
                            HStack(spacing: DesignSystem.Spacing.xl) {
                                VStack {
                                    Text("KAUFEN")
                                        .font(DesignSystem.Typography.title1)
                                        .foregroundColor(DesignSystem.Colors.success)
                                    Text("Konsens")
                                        .font(DesignSystem.Typography.caption1)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    HStack(spacing: 2) {
                                        ForEach(0..<5) { index in
                                            Image(systemName: index < 4 ? "star.fill" : "star")
                                                .font(.system(size: 16))
                                                .foregroundColor(DesignSystem.Colors.primary)
                                        }
                                    }
                                    Text("4.2/5.0")
                                        .font(DesignSystem.Typography.caption1)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                }
                            }
                            
                            DSSeparator()
                            
                            // Rating Distribution
                            VStack(spacing: DesignSystem.Spacing.sm) {
                                RatingRow(rating: "Starker Kauf", count: 8, total: 20, color: DesignSystem.Colors.success)
                                RatingRow(rating: "Kauf", count: 7, total: 20, color: Color.green.opacity(0.8))
                                RatingRow(rating: "Halten", count: 3, total: 20, color: Color.yellow)
                                RatingRow(rating: "Verkauf", count: 1, total: 20, color: Color.orange)
                                RatingRow(rating: "Starker Verkauf", count: 1, total: 20, color: DesignSystem.Colors.error)
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
                    // Price Targets
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            SectionHeader(title: "Kursziele")
                            
                            VStack(spacing: DesignSystem.Spacing.md) {
                                HStack {
                                    Text("Durchschnitt")
                                        .font(DesignSystem.Typography.body2)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                    Spacer()
                                    Text(String(format: "%.2f €", instrument.currentPrice * 1.15))
                                        .font(DesignSystem.Typography.headline)
                                        .foregroundColor(DesignSystem.Colors.onCard)
                                }
                                
                                HStack {
                                    Text("Höchstes")
                                        .font(DesignSystem.Typography.body2)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                    Spacer()
                                    Text(String(format: "%.2f €", instrument.currentPrice * 1.35))
                                        .font(DesignSystem.Typography.body1)
                                        .foregroundColor(DesignSystem.Colors.success)
                                }
                                
                                HStack {
                                    Text("Niedrigstes")
                                        .font(DesignSystem.Typography.body2)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                    Spacer()
                                    Text(String(format: "%.2f €", instrument.currentPrice * 0.95))
                                        .font(DesignSystem.Typography.body1)
                                        .foregroundColor(DesignSystem.Colors.error)
                                }
                                
                                HStack {
                                    Text("Potenzial")
                                        .font(DesignSystem.Typography.body2)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                    Spacer()
                                    Text("+15%")
                                        .font(DesignSystem.Typography.body1)
                                        .foregroundColor(DesignSystem.Colors.success)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                    
                    // Performance
                    DSCard(
                        backgroundColor: DesignSystem.Colors.cardBackground,
                        borderColor: DesignSystem.Colors.border,
                        cornerRadius: DesignSystem.CornerRadius.lg,
                        padding: DesignSystem.Spacing.lg,
                        hasShadow: true
                    ) {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            SectionHeader(title: "Performance")
                            
                            VStack(spacing: DesignSystem.Spacing.md) {
                                PerformanceRow(period: "1 Tag", value: 0.5, isPositive: true)
                                PerformanceRow(period: "1 Woche", value: 2.1, isPositive: true)
                                PerformanceRow(period: "1 Monat", value: -1.3, isPositive: false)
                                PerformanceRow(period: "3 Monate", value: 12.5, isPositive: true)
                                PerformanceRow(period: "YTD", value: 45.2, isPositive: true)
                                PerformanceRow(period: "1 Jahr", value: 67.8, isPositive: true)
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                }
                .padding(.vertical, DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Analysen & Performance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Market Data Detail View
struct InstrumentMarketDataDetailView: View {
    let instrument: InstrumentData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                marketDataContent
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Marktdaten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private var marketDataContent: some View {
        VStack(spacing: DesignSystem.Spacing.Section.between) {
            orderBookCard
            tradingStatisticsCard
            historicalDataCard
        }
        .padding(.vertical, DesignSystem.Spacing.lg)
    }
    
    private var orderBookCard: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            SectionHeader(title: "Orderbuch")
                            
                            HStack(spacing: DesignSystem.Spacing.xl) {
                                // Bid Side
                                VStack(alignment: .leading) {
                                    Text("Geld")
                                        .font(DesignSystem.Typography.caption1)
                                        .foregroundColor(DesignSystem.Colors.success)
                                    
                                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                        ForEach(0..<5) { index in
                                            HStack {
                                                Text(String(format: "%.2f", (instrument.bid ?? 0.0) - Double(index) * 0.05))
                                                    .font(DesignSystem.Typography.caption2)
                                                Spacer()
                                                Text("\(1000 + index * 200)")
                                                    .font(DesignSystem.Typography.caption2)
                                                    .foregroundColor(DesignSystem.Colors.secondary)
                                            }
                                        }
                                    }
                                }
                                
                                // Ask Side
                                VStack(alignment: .trailing) {
                                    Text("Brief")
                                        .font(DesignSystem.Typography.caption1)
                                        .foregroundColor(DesignSystem.Colors.error)
                                    
                                    VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                                        ForEach(0..<5) { index in
                                            HStack {
                                                Text("\(800 + index * 150)")
                                                    .font(DesignSystem.Typography.caption2)
                                                    .foregroundColor(DesignSystem.Colors.secondary)
                                                Spacer()
                                                Text(String(format: "%.2f", (instrument.ask ?? 0.0) + Double(index) * 0.05))
                                                    .font(DesignSystem.Typography.caption2)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
    }
    
    private var tradingStatisticsCard: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            VStack(spacing: 0) {
                SectionHeader(title: "Handelsstatistik")
                
                DetailStatRow(title: "Eröffnung", value: String(format: "%.2f", instrument.currentPrice * 0.98))
                DetailStatRow(title: "Vortagesschluss", value: String(format: "%.2f", instrument.currentPrice - instrument.change))
                DetailStatRow(title: "Handelsvolumen", value: formatVolume(instrument.volume))
                DetailStatRow(title: "Handelsumsatz", value: formatCurrency(Double(instrument.volume) * instrument.currentPrice))
                DetailStatRow(title: "Anzahl Trades", value: "\(instrument.volume / 100)")
                DetailStatRow(title: "VWAP", value: String(format: "%.2f", instrument.currentPrice * 0.995))
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
    }
    
    private var historicalDataCard: some View {
        DSCard(
            backgroundColor: DesignSystem.Colors.cardBackground,
            borderColor: DesignSystem.Colors.border,
            cornerRadius: DesignSystem.CornerRadius.lg,
            padding: DesignSystem.Spacing.lg,
            hasShadow: true
        ) {
            VStack(spacing: DesignSystem.Spacing.lg) {
                SectionHeader(title: "Historische Daten")
                
                Text("Detaillierte historische Kursdaten und Charts")
                    .font(DesignSystem.Typography.body2)
                    .foregroundColor(DesignSystem.Colors.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignSystem.Spacing.xl)
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
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
    
    private func formatCurrency(_ value: Double) -> String {
        if value >= 1_000_000_000 {
            return String(format: "%.1f Mrd. €", value / 1_000_000_000)
        } else if value >= 1_000_000 {
            return String(format: "%.1f Mio. €", value / 1_000_000)
        } else {
            return String(format: "%.0f €", value)
        }
    }
}

// MARK: - Helper Views
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(DesignSystem.Typography.headline)
                .foregroundColor(DesignSystem.Colors.onCard)
            Spacer()
        }
        .padding(.bottom, DesignSystem.Spacing.sm)
    }
}

struct RatingRow: View {
    let rating: String
    let count: Int
    let total: Int
    let color: Color
    
    var body: some View {
        HStack {
            Text(rating)
                .font(DesignSystem.Typography.caption1)
                .foregroundColor(DesignSystem.Colors.secondary)
                .frame(width: 100, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(DesignSystem.Colors.separator)
                        .frame(height: 4)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(count) / CGFloat(total), height: 4)
                }
            }
            .frame(height: 4)
            
            Text("\(count)")
                .font(DesignSystem.Typography.caption2)
                .foregroundColor(DesignSystem.Colors.secondary)
                .frame(width: 20, alignment: .trailing)
        }
    }
}

struct PerformanceRow: View {
    let period: String
    let value: Double
    let isPositive: Bool
    
    var body: some View {
        HStack {
            Text(period)
                .font(DesignSystem.Typography.body2)
                .foregroundColor(DesignSystem.Colors.secondary)
            
            Spacer()
            
            HStack(spacing: DesignSystem.Spacing.xs) {
                Text(String(format: "%+.2f%%", value))
                    .font(DesignSystem.Typography.body1)
                    .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                
                Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                    .font(.system(size: 10))
                    .foregroundColor(isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
            }
        }
    }
}

struct DetailStatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(DesignSystem.Typography.body2)
                    .foregroundColor(DesignSystem.Colors.secondary)
                Spacer()
                Text(value)
                    .font(DesignSystem.Typography.body1)
                    .foregroundColor(DesignSystem.Colors.onCard)
            }
            .padding(.vertical, DesignSystem.Spacing.md)
            
            DSSeparator()
        }
    }
}