//
//  NotificationService.swift
//  FinanzNachrichten
//
//  Service für In-App-Benachrichtigungen und verpasste Ereignisse
//
//  WICHTIG: Dies sind KEINE Push-Notifications, sondern In-App-Meldungen
//  - Zeigt verpasste Marktbewegungen, News und Earnings-Termine
//  - Keine UserDefaults-Persistierung (wird bei jedem Start neu geladen)
//  - In Production würden Daten von API kommen
//

import SwiftUI

/// Service managing in-app notifications for missed market events
/// Tracks unread count and provides mark-as-read functionality
/// Note: Uses mock data - real implementation would fetch from API
class NotificationService: ObservableObject {
    /// Number of unread notification items
    @Published var unreadCount: Int = 0

    /// Array of notification items (alerts, earnings, market events)
    @Published var missedItems: [MissedItem] = []

    /// Initializes service and loads notification items
    init() {
        loadMissedItems()
        updateUnreadCount()
    }

    /// Loads notification items
    /// Currently uses mock data - in production would fetch from API based on user's watchlist and interests
    func loadMissedItems() {
        // Mock-Daten für Entwicklung - in Production von API laden
        missedItems = [
            MissedItem(
                id: UUID(),
                type: .marketAlert,
                title: "DAX erreicht neues Jahreshoch",
                subtitle: "Index steigt über 16.000 Punkte",
                time: Date().addingTimeInterval(-3600), // 1 hour ago
                priority: .high
            ),
            MissedItem(
                id: UUID(),
                type: .newsAlert,
                title: "EZB erhöht Leitzins um 25 Basispunkte",
                subtitle: "Geldpolitische Entscheidung",
                time: Date().addingTimeInterval(-7200), // 2 hours ago
                priority: .high
            ),
            MissedItem(
                id: UUID(),
                type: .watchlistAlert,
                title: "Apple erreicht Kursziel",
                subtitle: "AAPL: $185 (+2.5%)",
                time: Date().addingTimeInterval(-10800), // 3 hours ago
                priority: .medium
            ),
            MissedItem(
                id: UUID(),
                type: .earnings,
                title: "Microsoft Quartalszahlen heute",
                subtitle: "Earnings Call um 22:00 Uhr",
                time: Date().addingTimeInterval(-14400), // 4 hours ago
                priority: .medium
            ),
            MissedItem(
                id: UUID(),
                type: .newsAlert,
                title: "Tesla kündigt neue Gigafactory an",
                subtitle: "Standort in Mexiko bestätigt",
                time: Date().addingTimeInterval(-18000), // 5 hours ago
                priority: .low
            )
        ]
    }

    /// Recalculates the unread count based on missedItems array
    /// Called after marking items as read
    func updateUnreadCount() {
        // Zähle alle ungelesenen Items
        unreadCount = missedItems.filter { !$0.isRead }.count
    }

    /// Marks a single notification item as read
    /// Automatically updates the unread count
    /// - Parameter item: The notification item to mark as read
    func markAsRead(_ item: MissedItem) {
        if let index = missedItems.firstIndex(where: { $0.id == item.id }) {
            missedItems[index].isRead = true
            updateUnreadCount()
        }
    }

    /// Marks all notification items as read
    /// Resets unread count to zero
    func markAllAsRead() {
        // Markiere alle Items als gelesen
        for index in missedItems.indices {
            missedItems[index].isRead = true
        }
        unreadCount = 0
    }
}