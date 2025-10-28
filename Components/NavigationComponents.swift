//
//  NavigationComponents.swift
//  FinanzNachrichten
//
//  Navigation-related UI components including header and bottom navigation
//

import SwiftUI

// MARK: - FN Header View

struct FNHeaderView: View {
    @State private var showingSearch = false
    @State private var showingNotifications = false
    @StateObject private var notificationService = NotificationService()

    // Time-based greeting
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "Guten Morgen"
        case 12..<18:
            return "Guten Tag"
        case 18..<22:
            return "Guten Abend"
        default:
            return "Hallo"
        }
    }

    var body: some View {
        HStack {
            // FN Logo
            FNLogoView(size: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(greeting)
                    .font(DesignSystem.Typography.title1)
                    .foregroundColor(DesignSystem.Colors.onBackground)
                // TODO: Add user nickname support when UserService is implemented
                // Text("\(greeting), \(userService.nickname ?? "")")
            }
            
            Spacer()
            
            HStack(spacing: DesignSystem.Spacing.xl) {
                // Notification Bell with Badge
                Button(action: {
                    showingNotifications = true
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 24))
                            .foregroundColor(DesignSystem.Colors.onBackground.opacity(0.7))
                        
                        if notificationService.unreadCount > 0 {
                            ZStack {
                                Circle()
                                    .fill(DesignSystem.Colors.primary)
                                    .frame(width: 16, height: 16)
                                
                                Text("\(notificationService.unreadCount)")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .offset(x: 8, y: -8)
                        }
                    }
                }
                
                // Search Icon
                Button(action: {
                    showingSearch = true
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 24))
                        .foregroundColor(DesignSystem.Colors.onBackground.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.vertical, DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.surface)
        .overlay(
            DSSeparator(),
            alignment: .bottom
        )
        .sheet(isPresented: $showingSearch) {
            SearchView(isPresented: $showingSearch)
        }
        .sheet(isPresented: $showingNotifications) {
            NotificationView(isPresented: $showingNotifications, notificationService: notificationService)
        }
    }
}

// MARK: - Bottom Navigation View

struct BottomNavigationView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            ZStack {
                // Glassmorphic Background - less transparent
                RoundedRectangle(cornerRadius: 24)
                    .fill(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                    )
                
                // Navigation Items
                HStack(spacing: 0) {
                    BottomNavItem(icon: "house.fill", title: "HOME", isSelected: selectedTab == 0)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = 0
                            }
                        }
                    BottomNavItem(icon: "chart.line.uptrend.xyaxis", title: "MÄRKTE", isSelected: selectedTab == 1)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = 1
                            }
                        }
                    BottomNavItem(icon: "bookmark.fill", title: "WATCHLIST", isSelected: selectedTab == 2)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = 2
                            }
                        }
                    BottomNavItem(icon: "newspaper.fill", title: "NEWS", isSelected: selectedTab == 3)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = 3
                            }
                        }
                    BottomNavItem(icon: "person.crop.circle.fill", title: "PROFIL", isSelected: selectedTab == 4)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = 4
                            }
                        }
                }
                .padding(.horizontal, DesignSystem.Spacing.sm)
                .padding(.vertical, DesignSystem.Spacing.md)
            }
            .frame(height: 80)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.bottom, DesignSystem.Spacing.sm)
            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
        }
    }
}

// MARK: - Bottom Nav Item

struct BottomNavItem: View {
    let icon: String
    let title: String
    let isSelected: Bool

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 28, weight: isSelected ? .medium : .regular))
            .foregroundColor(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.secondary.opacity(0.7))
            .scaleEffect(isSelected ? 1.15 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Watchlist Selector Card

struct WatchlistSelectorCard: View {
    let watchlist: Watchlist
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: DesignSystem.Spacing.lg) {
                // Header with name
                VStack(spacing: DesignSystem.Spacing.xs) {
                    Text(watchlist.name)
                        .font(DesignSystem.Typography.title1)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                        .fontWeight(.semibold)
                        .lineLimit(1)

                    Text("\(watchlist.items.count) Wertpapiere")
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(DesignSystem.Colors.secondary)
                }

                // Performance Summary
                VStack(spacing: DesignSystem.Spacing.sm) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Image(systemName: watchlist.averageChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(watchlist.averageChange >= 0 ? DesignSystem.Colors.success : DesignSystem.Colors.error)

                        Text(String(format: "%.2f%%", abs(watchlist.averageChange)))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(watchlist.averageChange >= 0 ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                    }

                    Text("Durchschnittliche Performance")
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.tertiary)
                }

                // Optional: Top Performer Preview (if items exist)
                if !watchlist.items.isEmpty {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        Text("Top Performer")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                            .textCase(.uppercase)

                        if let topPerformer = watchlist.topPerformers.first {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(topPerformer.symbol)
                                        .font(DesignSystem.Typography.body2)
                                        .foregroundColor(DesignSystem.Colors.onCard)
                                        .fontWeight(.semibold)

                                    Text(topPerformer.name)
                                        .font(DesignSystem.Typography.caption2)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                        .lineLimit(1)
                                }

                                Spacer()

                                Text(topPerformer.changePercent)
                                    .font(DesignSystem.Typography.body2)
                                    .foregroundColor(topPerformer.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                                    .fontWeight(.semibold)
                            }
                            .padding(DesignSystem.Spacing.sm)
                            .background(DesignSystem.Colors.surface.opacity(0.5))
                            .cornerRadius(DesignSystem.CornerRadius.md)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(DesignSystem.Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
                    .fill(DesignSystem.Colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
                            .stroke(watchlist.themeColor.opacity(0.3), lineWidth: 2)
                    )
            )
            .shadow(color: DesignSystem.Shadows.card, radius: DesignSystem.Shadows.cardRadius, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Add Watchlist Card

struct AddWatchlistCard: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: DesignSystem.Spacing.lg) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(DesignSystem.Colors.primary.opacity(0.3))

                Text("Neue Watchlist")
                    .font(DesignSystem.Typography.title2)
                    .foregroundColor(DesignSystem.Colors.secondary)

                Text("Tippe hier, um eine weitere Watchlist zu erstellen")
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.tertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignSystem.Spacing.lg)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .padding(DesignSystem.Spacing.xl)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
                        .fill(DesignSystem.Colors.surface.opacity(0.5))
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                        .foregroundColor(DesignSystem.Colors.border)
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}