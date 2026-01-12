//
//  NotificationAndSettingsView.swift
//  FinanzNachrichten
//
//  Combined view for feed personalization and notifications
//  Opened via bell icon in FNHeaderView
//

import SwiftUI

/// Combined view showing:
/// 1. Top section: Feed personalization (interest selection)
/// 2. Bottom section: Missed notifications
struct NotificationAndSettingsView: View {
    @Binding var isPresented: Bool
    @ObservedObject var notificationService: NotificationService

    // Interest selection state (loaded from UserDefaults)
    @State private var selectedInterests: Set<String>

    let availableInterests = [
        "Aktien", "ETFs", "Krypto", "Rohstoffe",
        "Devisen", "Anleihen", "Optionen", "Futures"
    ]

    // Load saved interests on init
    init(isPresented: Binding<Bool>, notificationService: NotificationService) {
        self._isPresented = isPresented
        self.notificationService = notificationService

        // Load saved interests from UserDefaults
        let savedInterests = UserDefaults.standard.stringArray(forKey: "userInterests") ?? []
        self._selectedInterests = State(initialValue: Set(savedInterests))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // SECTION 1: Feed Personalisierung
                    VStack(alignment: .center, spacing: DesignSystem.Spacing.xl) {
                        // Header (centered)
                        VStack(alignment: .center, spacing: DesignSystem.Spacing.xs) {
                            Text("Personalisiere deinen Feed")
                                .font(DesignSystem.Typography.title1)
                                .fontWeight(.bold)
                                .foregroundColor(DesignSystem.Colors.onBackground)
                                .multilineTextAlignment(.center)

                            Text("Wähle Themen aus, die dich interessieren")
                                .font(DesignSystem.Typography.body2)
                                .foregroundColor(DesignSystem.Colors.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.top, DesignSystem.Spacing.xxl)

                        // Interest Grid
                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]

                        LazyVGrid(columns: columns, spacing: DesignSystem.Spacing.md) {
                            ForEach(availableInterests, id: \.self) { interest in
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
                        .padding(.horizontal, DesignSystem.Spacing.lg)

                        // Save button
                        Button(action: saveInterests) {
                            Text("Speichern")
                                .font(DesignSystem.Typography.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, DesignSystem.Spacing.lg)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                                        .fill(selectedInterests.isEmpty ? DesignSystem.Colors.secondary.opacity(0.5) : DesignSystem.Colors.primary)
                                )
                                .shadow(
                                    color: selectedInterests.isEmpty ? Color.clear : DesignSystem.Colors.primary.opacity(0.4),
                                    radius: 12,
                                    x: 0,
                                    y: 4
                                )
                        }
                        .disabled(selectedInterests.isEmpty)
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.top, DesignSystem.Spacing.xl)
                    }
                    .padding(.bottom, DesignSystem.Spacing.xxl)

                    DSSeparator()
                        .padding(.vertical, DesignSystem.Spacing.xl)

                    // SECTION 2: Verpasste Benachrichtigungen
                    VStack(alignment: .center, spacing: DesignSystem.Spacing.lg) {
                        // Header (centered)
                        VStack(spacing: DesignSystem.Spacing.xs) {
                            Text("Benachrichtigungen")
                                .font(DesignSystem.Typography.title2)
                                .fontWeight(.bold)
                                .foregroundColor(DesignSystem.Colors.onBackground)

                            if notificationService.unreadCount > 0 {
                                Text("\(notificationService.unreadCount) neu")
                                    .font(DesignSystem.Typography.caption1)
                                    .foregroundColor(DesignSystem.Colors.primary)
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, DesignSystem.Spacing.lg)

                        // Notification List or Empty State
                        if notificationService.missedItems.isEmpty {
                            // Empty State
                            VStack(spacing: DesignSystem.Spacing.md) {
                                Image(systemName: "bell.slash")
                                    .font(.system(size: 50))
                                    .foregroundColor(DesignSystem.Colors.secondary.opacity(0.3))

                                Text("Keine neuen Benachrichtigungen")
                                    .font(DesignSystem.Typography.body2)
                                    .foregroundColor(DesignSystem.Colors.secondary)

                                Text("Wir halten dich über wichtige Ereignisse auf dem Laufenden")
                                    .font(DesignSystem.Typography.caption1)
                                    .foregroundColor(DesignSystem.Colors.tertiary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, DesignSystem.Spacing.lg)
                            }
                            .padding(.vertical, DesignSystem.Spacing.xxl)
                        } else {
                            // Notification Items
                            VStack(spacing: 0) {
                                ForEach(notificationService.missedItems) { item in
                                    NotificationItemRow(
                                        item: item,
                                        notificationService: notificationService
                                    )
                                    .padding(.horizontal, DesignSystem.Spacing.lg)

                                    if item.id != notificationService.missedItems.last?.id {
                                        DSSeparator()
                                            .padding(.horizontal, DesignSystem.Spacing.lg)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, DesignSystem.Spacing.xxl)
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationBarHidden(true)
            .overlay(
                // Close Button (top-right)
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(DesignSystem.Colors.secondary.opacity(0.6))
                        .background(Circle().fill(DesignSystem.Colors.background))
                }
                .padding(DesignSystem.Spacing.lg),
                alignment: .topTrailing
            )
        }
    }

    // MARK: - Helper Functions

    /// Save selected interests to UserDefaults and close sheet
    private func saveInterests() {
        // Save to UserDefaults
        UserDefaults.standard.set(Array(selectedInterests), forKey: "userInterests")

        // Notify other views that interests have changed
        NotificationCenter.default.post(name: .userInterestsDidChange, object: nil)

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        // Close the sheet after saving
        isPresented = false
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let userInterestsDidChange = Notification.Name("userInterestsDidChange")
}

// MARK: - Preview

struct NotificationAndSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationAndSettingsView(
            isPresented: .constant(true),
            notificationService: NotificationService()
        )
    }
}
