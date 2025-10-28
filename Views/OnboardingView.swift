//
//  OnboardingView.swift
//  FinanzNachrichten
//
//  User onboarding flow with interest and stock selection
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    @State private var selectedInterests: Set<String> = []
    @State private var selectedStocks: Set<String> = []
    
    let interests = [
        "Aktien", "ETFs", "Krypto", "Rohstoffe", 
        "Devisen", "Anleihen", "Optionen", "Futures"
    ]
    
    let popularStocks = [
        ("Apple", "AAPL", "Tech-Gigant"),
        ("Microsoft", "MSFT", "Software & Cloud"),
        ("NVIDIA", "NVDA", "KI-Leader"),
        ("Tesla", "TSLA", "E-Mobilität"),
        ("Amazon", "AMZN", "E-Commerce"),
        ("Alphabet", "GOOGL", "Tech & Search"),
        ("SAP", "SAP", "Software"),
        ("Siemens", "SIE", "Industrie"),
        ("Volkswagen", "VOW3", "Automobil"),
        ("BASF", "BAS", "Chemie"),
        ("Allianz", "ALV", "Versicherung"),
        ("Deutsche Bank", "DBK", "Banking")
    ]
    
    var body: some View {
        ZStack {
            // Solid background
            Color.white
                .ignoresSafeArea()
            
            VStack {
                // Skip button
                HStack {
                    Spacer()
                    Button("Überspringen") {
                        completeOnboarding()
                    }
                    .foregroundColor(.gray)
                    .padding()
                }
                
                // Content
                TabView(selection: $currentPage) {
                    // Welcome page
                    WelcomePageView()
                        .tag(0)
                    
                    // Interests selection page
                    InterestsSelectionView(selectedInterests: $selectedInterests, interests: interests)
                        .tag(1)
                    
                    // Stocks selection page
                    StocksSelectionView(selectedStocks: $selectedStocks, stocks: popularStocks)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Custom page indicator and buttons
                VStack(spacing: 20) {
                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.red : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }) {
                                Text("Zurück")
                                    .fontWeight(.medium)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                            }
                        }
                        
                        Button(action: {
                            if currentPage < 2 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                savePreferencesAndComplete()
                            }
                        }) {
                            Text(getButtonText())
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(getButtonColor())
                                .cornerRadius(12)
                        }
                        .disabled(currentPage == 1 && selectedInterests.isEmpty)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    private func getButtonText() -> String {
        switch currentPage {
        case 0: return "Los geht's"
        case 1: return selectedInterests.isEmpty ? "Wähle mindestens ein Interesse" : "Weiter"
        case 2: return "Fertig"
        default: return "Weiter"
        }
    }
    
    private func getButtonColor() -> Color {
        if currentPage == 1 && selectedInterests.isEmpty {
            return Color.gray
        }
        return Color.red
    }
    
    private func savePreferencesAndComplete() {
        // Save selected stocks to UserDefaults for the watchlist
        if !selectedStocks.isEmpty {
            UserDefaults.standard.set(Array(selectedStocks), forKey: "initialWatchlist")
        }
        
        // Save interests
        UserDefaults.standard.set(Array(selectedInterests), forKey: "userInterests")
        
        completeOnboarding()
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        showOnboarding = false
        // The ContentView will now show HomeView automatically
    }
}

// MARK: - Welcome Page

struct WelcomePageView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // FN Logo
            FNLogoView(size: 100)
            
            VStack(spacing: 8) {
                Text("Willkommen bei")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                
                Text("Finanz Nachrichten")
                    .font(.system(size: 32, weight: .bold))
            }
            
            Text("Bleibe immer informiert über die\nneuesten Entwicklungen an den Finanzmärkten")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
}

// MARK: - Interests Selection View

struct InterestsSelectionView: View {
    @Binding var selectedInterests: Set<String>
    let interests: [String]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Was interessiert dich?")
                    .font(.system(size: 28, weight: .bold))
                
                Text("Wähle deine Interessensgebiete aus")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.top, 40)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(interests, id: \.self) { interest in
                    InterestChip(
                        title: interest,
                        isSelected: selectedInterests.contains(interest),
                        action: {
                            if selectedInterests.contains(interest) {
                                selectedInterests.remove(interest)
                            } else {
                                selectedInterests.insert(interest)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

// MARK: - Interest Chip

struct InterestChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isSelected ? Color.red : Color.gray.opacity(0.1))
                .cornerRadius(12)
        }
    }
}

// MARK: - Stocks Selection View

struct StocksSelectionView: View {
    @Binding var selectedStocks: Set<String>
    let stocks: [(String, String, String)]
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Erste Werte für deine Watchlist")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("Wähle beliebte Aktien aus oder überspringe diesen Schritt")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(stocks, id: \.1) { stock in
                        StockSelectionRow(
                            name: stock.0,
                            symbol: stock.1,
                            category: stock.2,
                            isSelected: selectedStocks.contains(stock.1),
                            action: {
                                if selectedStocks.contains(stock.1) {
                                    selectedStocks.remove(stock.1)
                                } else {
                                    selectedStocks.insert(stock.1)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

// MARK: - Stock Selection Row

struct StockSelectionRow: View {
    let name: String
    let symbol: String
    let category: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(symbol)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    Text(name)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text(category)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .red : .gray)
            }
            .padding(16)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.red : Color.clear, lineWidth: 2)
            )
        }
    }
}