//
//  InstrumentNewsListView.swift
//  FinanzNachrichten
//
//  News list view for a specific instrument
//

import SwiftUI

struct InstrumentNewsListView: View {
    let instrument: InstrumentData
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedNewsIndex: Int? = nil
    @State private var showingNewsDetail = false
    @State private var selectedCategory = "Alle"
    
    let newsCategories = ["Alle", "Pressemitteilungen", "Empfehlungen", "Chartanalysen", "Berichte"]
    
    // Sample news items for the instrument
    var newsItems: [(title: String, time: String, source: String, category: String)] {
        [
            (title: "\(instrument.name) übertrifft Quartalsprognosen deutlich", time: "vor 2 Stunden", source: "Handelsblatt", category: "Berichte"),
            (title: "Analysten heben Kursziel für \(instrument.name) an", time: "vor 4 Stunden", source: "Reuters", category: "Empfehlungen"),
            (title: "\(instrument.name) kündigt neue Produktlinie an", time: "vor 6 Stunden", source: "FAZ", category: "Pressemitteilungen"),
            (title: "Starke Nachfrage treibt \(instrument.name)-Aktie", time: "vor 8 Stunden", source: "Bloomberg", category: "Chartanalysen"),
            (title: "\(instrument.name) expandiert in neue Märkte", time: "vor 12 Stunden", source: "CNBC", category: "Pressemitteilungen"),
            (title: "CEO von \(instrument.name) optimistisch für 2025", time: "vor 1 Tag", source: "Financial Times", category: "Berichte"),
            (title: "\(instrument.name) investiert in KI-Technologie", time: "vor 2 Tagen", source: "WSJ", category: "Pressemitteilungen"),
            (title: "Dividendenerhöhung bei \(instrument.name) erwartet", time: "vor 3 Tagen", source: "Börse Online", category: "Empfehlungen"),
            (title: "\(instrument.name) schließt strategische Partnerschaft", time: "vor 4 Tagen", source: "MarketWatch", category: "Pressemitteilungen"),
            (title: "Institutionelle Anleger setzen auf \(instrument.name)", time: "vor 5 Tagen", source: "Seeking Alpha", category: "Chartanalysen")
        ]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Instrument Header
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        HStack {
                            Text(instrument.symbol)
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text(String(format: "%.2f €", instrument.currentPrice))
                                    .font(DesignSystem.Typography.headline)
                                    .foregroundColor(DesignSystem.Colors.onBackground)
                                
                                HStack(spacing: DesignSystem.Spacing.xs) {
                                    Image(systemName: instrument.isPositive ? "arrow.up" : "arrow.down")
                                        .font(.system(size: 10))
                                    Text(String(format: "%.2f (%.2f%%)", instrument.change, instrument.changePercent))
                                        .font(DesignSystem.Typography.caption1)
                                }
                                .foregroundColor(instrument.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                            }
                        }
                        
                        Text("Alle Nachrichten zu \(instrument.name)")
                            .font(DesignSystem.Typography.body2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                    .padding(DesignSystem.Spacing.Page.horizontal)
                    .padding(.vertical, DesignSystem.Spacing.lg)
                    .background(DesignSystem.Colors.surface)
                    
                    DSSeparator()
                    
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
                    
                    // News List
                    VStack(spacing: 0) {
                        ForEach(Array(filteredNewsItems.enumerated()), id: \.offset) { index, newsItem in
                            Button(action: {
                                selectedNewsIndex = index
                                showingNewsDetail = true
                            }) {
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
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if index < filteredNewsItems.count - 1 {
                                DSSeparator()
                                    .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                            }
                        }
                    }
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Nachrichten zu \(instrument.symbol)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(DesignSystem.Colors.onBackground)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Fertig")
                            .font(DesignSystem.Typography.body1)
                            .foregroundColor(DesignSystem.Colors.primary)
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewsDetail) {
            if let index = selectedNewsIndex {
                NewsDetailView(article: createNewsArticle(for: index))
            }
        }
    }
    
    var filteredNewsItems: [(title: String, time: String, source: String, category: String)] {
        if selectedCategory == "Alle" {
            return newsItems
        } else {
            return newsItems.filter { $0.category == selectedCategory }
        }
    }
    
    private func createNewsArticle(for index: Int) -> NewsArticle {
        let newsItem = filteredNewsItems[index]
        return NewsArticle(
            title: newsItem.title,
            category: "Aktien",
            time: newsItem.time,
            source: newsItem.source,
            hasImage: true,
            body: generateArticleBody(for: newsItem.title),
            mentionedInstruments: [
                NewsInstrument(
                    symbol: instrument.symbol,
                    name: instrument.name,
                    price: String(format: "%.2f €", instrument.currentPrice),
                    change: String(format: "%+.2f%%", instrument.changePercent),
                    isPositive: instrument.isPositive
                )
            ],
            rating: Double.random(in: 3.5...5.0),
            readerCount: Int.random(in: 500...5000)
        )
    }
    
    private func generateArticleBody(for title: String) -> String {
        return """
        \(title)
        
        Die Aktie von \(instrument.name) zeigt sich heute in guter Verfassung. Mit einem aktuellen Kurs von \(String(format: "%.2f", instrument.currentPrice)) Euro notiert das Papier \(instrument.isPositive ? "im Plus" : "im Minus").
        
        Analysten zeigen sich weiterhin optimistisch für die weitere Entwicklung. Die durchschnittliche Kurszielschätzung liegt bei \(String(format: "%.2f", instrument.currentPrice * 1.15)) Euro, was einem Potenzial von rund 15% entspricht.
        
        Das Handelsvolumen liegt heute bei \(formatVolume(instrument.volume)) Stück und damit \(Bool.random() ? "über" : "unter") dem Durchschnitt der letzten 30 Tage.
        
        Für das laufende Geschäftsjahr erwarten Experten eine Dividende von \(String(format: "%.2f", Double.random(in: 0.5...3.0))) Euro je Aktie. Die nächsten Quartalszahlen werden für den \(Date().addingTimeInterval(86400 * Double.random(in: 30...90)).formatted(date: .abbreviated, time: .omitted)) erwartet.
        """
    }
    
    private func formatVolume(_ volume: Int) -> String {
        if volume > 1_000_000 {
            return String(format: "%.1f Mio.", Double(volume) / 1_000_000)
        } else if volume > 1_000 {
            return String(format: "%.0fk", Double(volume) / 1_000)
        } else {
            return "\(volume)"
        }
    }
}

struct InstrumentNewsListView_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentNewsListView(instrument: InstrumentData(
            symbol: "AAPL",
            name: "Apple Inc.",
            currentPrice: 182.52,
            change: 2.24,
            changePercent: 1.23,
            isPositive: true,
            dayHigh: 183.45,
            dayLow: 180.23,
            volume: 52_345_678,
            weekHigh52: 199.62,
            weekLow52: 154.24,
            isin: "US0378331005",
            wkn: "865985",
            exchange: "NASDAQ",
            bid: 182.50,
            ask: 182.54,
            lastUpdate: Date()
        ))
    }
}