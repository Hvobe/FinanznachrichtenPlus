//
//  NotificationView.swift
//  FinanzNachrichten
//
//  Created on 03.07.2025.
//

import SwiftUI

// MARK: - Notification View

struct NotificationView: View {
    @Binding var isPresented: Bool
    @ObservedObject var notificationService: NotificationService
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Benachrichtigungen")
                        .font(DesignSystem.Typography.title1)
                        .foregroundColor(DesignSystem.Colors.onBackground)
                    
                    Spacer()
                }
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.vertical, DesignSystem.Spacing.lg)
                
                DSSeparator()
                
                if notificationService.missedItems.isEmpty {
                    // Empty State
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        Image(systemName: "bell.slash")
                            .font(.system(size: 60))
                            .foregroundColor(DesignSystem.Colors.secondary.opacity(0.3))
                        
                        Text("Keine neuen Benachrichtigungen")
                            .font(DesignSystem.Typography.body1)
                            .foregroundColor(DesignSystem.Colors.secondary)
                        
                        Text("Wir halten dich über wichtige Ereignisse auf dem Laufenden")
                            .font(DesignSystem.Typography.caption1)
                            .foregroundColor(DesignSystem.Colors.tertiary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 100)
                    
                    Spacer()
                } else {
                    // Notification List
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(notificationService.missedItems) { item in
                                NotificationItemRow(item: item, notificationService: notificationService)
                                
                                if item.id != notificationService.missedItems.last?.id {
                                    DSSeparator()
                                        .padding(.horizontal, DesignSystem.Spacing.lg)
                                }
                            }
                        }
                    }
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationBarHidden(true)
            .overlay(
                // Close Button
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
}

struct NotificationItemRow: View {
    let item: MissedItem
    @ObservedObject var notificationService: NotificationService
    
    var body: some View {
        Button(action: {
            notificationService.markAsRead(item)
        }) {
            HStack(alignment: .center, spacing: DesignSystem.Spacing.md) {
                // Content
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(item.title)
                        .font(DesignSystem.Typography.headline)
                        .foregroundColor(item.isRead ? DesignSystem.Colors.secondary : DesignSystem.Colors.onBackground)
                        .lineLimit(2)
                    
                    Text(item.subtitle)
                        .font(DesignSystem.Typography.body2)
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .lineLimit(1)
                    
                    Text(item.timeAgo)
                        .font(DesignSystem.Typography.caption2)
                        .foregroundColor(DesignSystem.Colors.tertiary)
                }
                
                Spacer()
                
                if !item.isRead {
                    Circle()
                        .fill(DesignSystem.Colors.primary)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.lg)
            .background(item.isRead ? Color.clear : DesignSystem.Colors.surface)
        }
        .buttonStyle(PlainButtonStyle())
    }
}