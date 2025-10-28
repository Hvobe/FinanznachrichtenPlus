//
//  WatchlistModels.swift
//  FinanzNachrichten
//
//  Models für das Multi-Watchlist-System
//
//  WICHTIG: Hauptmodel für Watchlist-Verwaltung
//  - Codable für UserDefaults-Persistierung
//  - Color als Hex-String gespeichert (für JSON-Encoding)
//  - Computed Properties für Statistiken (Gesamtwert, Performance, Top-Performer)
//

import SwiftUI
import Foundation

// MARK: - Watchlist

/// Main model for a user watchlist
/// Supports multiple watchlists with custom names, colors, and instruments
/// Codable for UserDefaults persistence with JSON encoding
struct Watchlist: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String              // User-defined watchlist name
    var items: [WatchlistItem]    // Financial instruments in this watchlist
    var color: String             // Theme color stored as hex string for Codable
    var createdAt: Date           // Creation timestamp

    init(id: UUID = UUID(), name: String, items: [WatchlistItem] = [], color: Color = .blue, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.items = items
        self.color = color.toHex()  // Convert Color to hex for storage
        self.createdAt = createdAt
    }

    // MARK: - Computed Properties

    /// Returns the theme color as SwiftUI Color
    /// Converts from stored hex string
    var themeColor: Color {
        Color(hex: color) ?? .blue
    }

    /// Returns mock total portfolio value
    /// In production: sum of (price * quantity) for all items
    var totalValue: Double {
        // Mock: 1000€ pro Item
        return Double(items.count) * 1000.0
    }

    /// Returns total percentage change across all items
    /// Sum of all individual change percentages
    var totalChange: Double {
        // Summiere alle Prozent-Änderungen
        return items.reduce(0.0) { sum, item in
            let percentString = item.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")
            let percent = Double(percentString) ?? 0.0
            return sum + percent
        }
    }

    /// Returns average percentage change across all items
    /// Returns 0.0 for empty watchlists
    var averageChange: Double {
        guard !items.isEmpty else { return 0.0 }
        return totalChange / Double(items.count)
    }

    /// Returns items sorted by performance (highest change % first)
    /// Used in HomeView to display top performers
    var topPerformers: [WatchlistItem] {
        items.sorted { item1, item2 in
            let percent1 = Double(item1.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            let percent2 = Double(item2.changePercent.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "+", with: "")) ?? 0
            return percent1 > percent2
        }
    }

    /// Equatable implementation - compares by ID only
    static func == (lhs: Watchlist, rhs: Watchlist) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Color Extensions for Codable

extension Color {
    /// Converts SwiftUI Color to hex string for JSON encoding
    /// Uses predefined color mappings for standard system colors
    func toHex() -> String {
        // Convert Color to hex string
        // For SwiftUI colors, we'll use predefined mappings
        if self == .blue { return "#007AFF" }
        if self == .green { return "#34C759" }
        if self == .orange { return "#FF9500" }
        if self == .red { return "#FF3B30" }
        if self == .purple { return "#AF52DE" }
        if self == .pink { return "#FF2D55" }
        if self == .teal { return "#5AC8FA" }
        if self == .indigo { return "#5856D6" }
        if self == .mint { return "#00C7BE" }
        if self == .cyan { return "#32ADE6" }
        if self == .brown { return "#A2845E" }
        return "#007AFF" // Default: blue
    }

    /// Initializes a Color from a hex string
    /// Supports 3, 6, and 8 character hex codes (RGB, RRGGBB, AARRGGBB)
    /// Returns nil if the hex string is invalid
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Predefined Theme Colors

extension Watchlist {
    /// Predefined theme colors for watchlist creation/editing
    /// Provides German color names and SwiftUI Color values
    static let themeColors: [(name: String, color: Color)] = [
        ("Blau", .blue),
        ("Grün", .green),
        ("Orange", .orange),
        ("Rot", .red),
        ("Lila", .purple),
        ("Pink", .pink),
        ("Türkis", .teal),
        ("Indigo", .indigo),
        ("Mint", .mint),
        ("Cyan", .cyan)
    ]
}
