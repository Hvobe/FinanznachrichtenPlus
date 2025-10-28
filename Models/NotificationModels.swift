//
//  NotificationModels.swift
//  FinanzNachrichten
//
//  Models für In-App-Benachrichtigungen
//
//  ENTHÄLT:
//  - MissedItem: Verpasste Ereignisse (Markt-Alerts, News, Earnings)
//  - MissedItemType: Typen von Benachrichtigungen
//  - Priority: Prioritäts-Level für Benachrichtigungen
//

import SwiftUI

// MARK: - Missed Item

/// In-app notification item representing a missed event
/// Used in NotificationService and NotificationView
struct MissedItem: Identifiable {
    let id: UUID
    let type: MissedItemType
    let title: String
    let subtitle: String
    let time: Date
    let priority: Priority
    var isRead: Bool = false
    
    enum MissedItemType {
        case newsAlert
        case marketAlert
        case watchlistAlert
        case earnings
        
        var icon: String {
            switch self {
            case .newsAlert: return "newspaper.fill"
            case .marketAlert: return "chart.line.uptrend.xyaxis"
            case .watchlistAlert: return "eye.fill"
            case .earnings: return "calendar"
            }
        }
        
        var color: Color {
            switch self {
            case .newsAlert: return .blue
            case .marketAlert: return .green
            case .watchlistAlert: return .orange
            case .earnings: return .purple
            }
        }
    }
    
    enum Priority {
        case high, medium, low
        
        var color: Color {
            switch self {
            case .high: return .red
            case .medium: return .orange
            case .low: return .gray
            }
        }
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: time, relativeTo: Date())
    }
}