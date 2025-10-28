//
//  MenuView.swift
//  FinanzNachrichten
//
//  Created on 03.07.2025.
//

import SwiftUI

// MARK: - MenuView

struct MenuView: View {
    @State private var showingProfile = false
    @State private var showingOnboarding = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    private var menuSections: [MenuSection] {
        [
            MenuSection(title: "Profil", items: [
                MenuItem(title: "Persönliche Daten"),
                MenuItem(title: "Einstellungen"),
                MenuItem(title: "App-Bewertung", hasChevron: false),
                MenuItem(title: "Onboarding erneut anzeigen", hasChevron: false)
            ]),
            MenuSection(title: "Erscheinungsbild", items: [
                MenuItem(title: "Dark Mode", hasChevron: false, hasToggle: true)
            ]),
            MenuSection(title: "Über diese App", items: [
                MenuItem(title: "Impressum"),
                MenuItem(title: "Kontakt", subtitle: "Feedback zu dieser App"),
                MenuItem(title: "Nutzerdatenerfassung"),
                MenuItem(title: "Lizenzen")
            ]),
            MenuSection(title: "FN Wissen", items: [
                MenuItem(title: "Watchlist", subtitle: "Was bringt mir eine Watchlist?"),
                MenuItem(title: "Xetra-Orderbuch", subtitle: "Was bringt mir das Xetra-Orderbuch?")
            ]),
            MenuSection(title: "Benachrichtigungen", items: [
                MenuItem(title: "Mitteilungen", subtitle: "Push - Benachrichtigungen")
            ])
        ]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.Section.between) {
                    // Profile Header
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        // Avatar
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [DesignSystem.Colors.primary, DesignSystem.Colors.primary.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 80, height: 80)
                            
                            Text("SH")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        // User Info
                        VStack(spacing: DesignSystem.Spacing.xs) {
                            Text("Sascha Huber")
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                            
                            Text("Premium Mitglied")
                                .font(DesignSystem.Typography.caption1)
                                .foregroundColor(DesignSystem.Colors.secondary)
                        }
                    }
                    .padding(.top, DesignSystem.Spacing.lg)
                    .padding(.bottom, DesignSystem.Spacing.xl)
                    
                    ForEach(Array(menuSections.enumerated()), id: \.offset) { index, section in
                        VStack(spacing: DesignSystem.Spacing.Section.withinSection) {
                            MenuSectionHeader(title: section.title)
                            
                            DSCard(
                                backgroundColor: DesignSystem.Colors.cardBackground,
                                borderColor: DesignSystem.Colors.border,
                                cornerRadius: DesignSystem.CornerRadius.lg,
                                padding: 0,
                                hasShadow: true
                            ) {
                                VStack(spacing: 0) {
                                    ForEach(Array(section.items.enumerated()), id: \.offset) { itemIndex, item in
                                        if item.hasToggle && item.title == "Dark Mode" {
                                            MenuItemToggleRow(item: item, isOn: $isDarkMode)
                                        } else {
                                            MenuItemRow(item: item) {
                                                if item.title == "Onboarding erneut anzeigen" {
                                                    showingOnboarding = true
                                                }
                                            }
                                        }
                                        
                                        if itemIndex < section.items.count - 1 {
                                            Divider()
                                                .background(DesignSystem.Colors.separator)
                                                .padding(.leading, DesignSystem.Spacing.Page.horizontal)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
                .padding(.top, DesignSystem.Spacing.Page.top)
                .padding(.bottom, DesignSystem.Spacing.Page.bottom)
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingView(showOnboarding: $showingOnboarding)
        }
    }
}

struct MenuSectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(DesignSystem.Typography.title2)
                .foregroundColor(DesignSystem.Colors.onBackground)
            Spacer()
        }
    }
}

struct MenuItemRow: View {
    let item: MenuItem
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(DesignSystem.Typography.body1)
                    .foregroundColor(DesignSystem.Colors.onBackground)
                
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
            }
            
            Spacer()
            
            if item.hasChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(DesignSystem.Colors.secondary)
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
        .padding(.vertical, DesignSystem.Spacing.Section.withinSection)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

struct MenuItemToggleRow: View {
    let item: MenuItem
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(DesignSystem.Typography.body1)
                    .foregroundColor(DesignSystem.Colors.onBackground)
                
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(DesignSystem.Colors.primary)
        }
        .padding(.horizontal, DesignSystem.Spacing.Page.horizontal)
        .padding(.vertical, DesignSystem.Spacing.Section.withinSection)
    }
}