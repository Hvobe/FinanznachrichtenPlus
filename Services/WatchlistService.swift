//
//  WatchlistService.swift
//  FinanzNachrichten
//
//  Multi-Watchlist-Verwaltungsservice für die gesamte App
//
//  WICHTIG: Dieser Service verwaltet MEHRERE Watchlists:
//  - User kann beliebig viele Watchlists erstellen, umbenennen, löschen
//  - Eine Watchlist ist immer "aktiv" (wird gerade angezeigt)
//  - Jede Watchlist hat eigene Items, Namen und Farbe
//  - Legacy-Support: Alte Single-Watchlist-Daten werden automatisch migriert
//  - Persistierung: UserDefaults mit JSON-Encoding
//
//  ARCHITEKTUR:
//  - Singleton-Pattern: WatchlistService.shared
//  - ObservableObject: UI aktualisiert sich automatisch bei Änderungen
//  - @Published Properties: watchlists, activeWatchlistId, watchlistItems (legacy)
//

import Foundation
import SwiftUI

/// Central service managing multiple user watchlists with persistence
/// Supports creating, switching, and managing multiple watchlists
/// Automatically migrates legacy single-watchlist data to multi-watchlist system
class WatchlistService: ObservableObject {
    /// Shared singleton instance for app-wide access
    static let shared = WatchlistService()

    // MARK: - Published Properties

    /// All watchlists created by the user
    /// Automatically triggers UI updates when modified
    @Published var watchlists: [Watchlist] = []

    /// ID of the currently active/selected watchlist
    /// Used to determine which watchlist to display and modify
    @Published var activeWatchlistId: UUID?

    /// Legacy property for backward compatibility with old single-watchlist UI code
    /// Always contains items from the active watchlist
    @Published var watchlistItems: [WatchlistItem] = []

    // MARK: - Private Properties

    private let userDefaults = UserDefaults.standard
    private let watchlistsKey = "watchlists_v2"          // Multi-watchlist persistence key
    private let activeWatchlistKey = "activeWatchlistId" // Active watchlist ID persistence
    private let legacyWatchlistKey = "watchlistItems"    // Old single-watchlist key for migration

    /// Returns the currently active watchlist
    /// Falls back to first watchlist if no active ID is set
    var activeWatchlist: Watchlist? {
        get {
            // Suche nach aktiver Watchlist anhand der ID
            if let id = activeWatchlistId {
                return watchlists.first { $0.id == id }
            }
            // Fallback: Erste Watchlist verwenden
            return watchlists.first
        }
    }

    /// Private initializer for singleton pattern
    /// Loads persisted watchlists and performs legacy migration if needed
    private init() {
        loadWatchlists()
        migrateFromLegacyIfNeeded()

        // Halte Legacy-Property synchron für rückwärtskompatiblen Code
        updateLegacyWatchlistItems()
    }

    // MARK: - Loading & Saving

    /// Loads all watchlists from UserDefaults persistence
    /// Creates default watchlist if none exist
    /// Ensures activeWatchlistId is valid
    func loadWatchlists() {
        // Lade Watchlists aus UserDefaults
        if let data = userDefaults.data(forKey: watchlistsKey),
           let decoded = try? JSONDecoder().decode([Watchlist].self, from: data) {
            watchlists = decoded
        }

        // Lade ID der aktiven Watchlist
        if let idString = userDefaults.string(forKey: activeWatchlistKey),
           let id = UUID(uuidString: idString) {
            activeWatchlistId = id
        }

        // Falls keine Watchlists existieren, erstelle Standard-Watchlist
        if watchlists.isEmpty {
            let defaultWatchlist = Watchlist(name: "Meine Watchlist", color: .blue)
            watchlists.append(defaultWatchlist)
            activeWatchlistId = defaultWatchlist.id
            saveWatchlists()
        }

        // Stelle sicher, dass activeWatchlistId valide ist
        if activeWatchlistId == nil || !watchlists.contains(where: { $0.id == activeWatchlistId }) {
            activeWatchlistId = watchlists.first?.id
        }
    }

    /// Persists all watchlists and active watchlist ID to UserDefaults
    /// Also updates legacy watchlistItems property for backward compatibility
    func saveWatchlists() {
        if let encoded = try? JSONEncoder().encode(watchlists) {
            userDefaults.set(encoded, forKey: watchlistsKey)
        }

        if let id = activeWatchlistId {
            userDefaults.set(id.uuidString, forKey: activeWatchlistKey)
        }

        updateLegacyWatchlistItems()
    }

    // MARK: - Migration from Legacy Single Watchlist

    /// Migrates old single-watchlist data to new multi-watchlist system
    /// Only runs if no watchlists exist but legacy data is present
    /// Removes legacy UserDefaults key after successful migration
    private func migrateFromLegacyIfNeeded() {
        // Prüfe ob Legacy-Daten vorhanden sind, aber keine neuen Watchlists
        guard watchlists.isEmpty else { return }

        if let data = userDefaults.data(forKey: legacyWatchlistKey),
           let decoded = try? JSONDecoder().decode([SavedWatchlistItem].self, from: data) {

            // Konvertiere Legacy-Daten zu neuen WatchlistItems
            let items = decoded.map { savedItem in
                WatchlistItem(
                    symbol: savedItem.symbol,
                    name: savedItem.name,
                    price: savedItem.price,
                    change: savedItem.change,
                    changePercent: savedItem.changePercent,
                    isPositive: savedItem.isPositive
                )
            }

            // Erstelle Standard-Watchlist mit migrierten Items
            let migratedWatchlist = Watchlist(
                name: "Meine Watchlist",
                items: items,
                color: .blue
            )

            watchlists = [migratedWatchlist]
            activeWatchlistId = migratedWatchlist.id
            saveWatchlists()

            // Entferne Legacy-Key nach erfolgreicher Migration
            userDefaults.removeObject(forKey: legacyWatchlistKey)

            print("✅ Migrated \(items.count) items from legacy watchlist")
        }
    }

    /// Updates legacy watchlistItems property to match active watchlist
    /// Used for backward compatibility with old UI code
    private func updateLegacyWatchlistItems() {
        // Synchronisiere Legacy-Property mit aktiver Watchlist
        watchlistItems = activeWatchlist?.items ?? []
    }

    // MARK: - Watchlist Management

    /// Creates a new watchlist with the specified name and color
    /// - Parameters:
    ///   - name: Display name for the watchlist
    ///   - color: Theme color for the watchlist
    /// - Returns: The newly created watchlist
    func createWatchlist(name: String, color: Color = .blue) -> Watchlist {
        let newWatchlist = Watchlist(name: name, color: color)
        watchlists.append(newWatchlist)
        saveWatchlists()
        return newWatchlist
    }

    /// Deletes a watchlist from the collection
    /// Prevents deletion if it's the last remaining watchlist
    /// Automatically switches to first watchlist if deleted watchlist was active
    /// - Parameter watchlist: The watchlist to delete
    func deleteWatchlist(_ watchlist: Watchlist) {
        // Verhindere Löschen der letzten Watchlist
        guard watchlists.count > 1 else {
            print("⚠️ Cannot delete last watchlist")
            return
        }

        watchlists.removeAll { $0.id == watchlist.id }

        // Falls die aktive Watchlist gelöscht wurde, wechsle zur ersten
        if activeWatchlistId == watchlist.id {
            activeWatchlistId = watchlists.first?.id
        }

        saveWatchlists()
    }

    /// Renames a watchlist
    /// - Parameters:
    ///   - watchlist: The watchlist to rename
    ///   - newName: The new display name
    func renameWatchlist(_ watchlist: Watchlist, newName: String) {
        if let index = watchlists.firstIndex(where: { $0.id == watchlist.id }) {
            watchlists[index].name = newName
            saveWatchlists()
        }
    }

    /// Updates the theme color of a watchlist
    /// - Parameters:
    ///   - watchlist: The watchlist to update
    ///   - color: The new theme color
    func updateWatchlistColor(_ watchlist: Watchlist, color: Color) {
        if let index = watchlists.firstIndex(where: { $0.id == watchlist.id }) {
            watchlists[index].color = color.toHex()
            saveWatchlists()
        }
    }

    /// Switches to a different watchlist, making it the active one
    /// - Parameter watchlist: The watchlist to activate
    func switchToWatchlist(_ watchlist: Watchlist) {
        activeWatchlistId = watchlist.id
        saveWatchlists()
    }

    // MARK: - Item Management

    /// Adds a financial instrument to a watchlist
    /// Prevents duplicate symbols within the same watchlist
    /// - Parameters:
    ///   - symbol: Stock symbol (e.g., "AAPL", "MSFT")
    ///   - name: Company/instrument name
    ///   - price: Optional current price
    ///   - change: Optional absolute change value
    ///   - changePercent: Optional percentage change
    ///   - isPositive: Whether the change is positive
    ///   - watchlist: Target watchlist (defaults to active watchlist)
    func addToWatchlist(symbol: String, name: String, price: Double? = nil, change: Double? = nil, changePercent: Double? = nil, isPositive: Bool = true, toWatchlist watchlist: Watchlist? = nil) {
        let targetWatchlist = watchlist ?? activeWatchlist
        guard let targetWatchlist = targetWatchlist else { return }
        guard let index = watchlists.firstIndex(where: { $0.id == targetWatchlist.id }) else { return }

        // Prüfe ob Symbol bereits in Watchlist vorhanden ist
        if watchlists[index].items.contains(where: { $0.symbol == symbol }) {
            return
        }

        // Erstelle neues WatchlistItem mit formatierten Werten
        let newItem = WatchlistItem(
            symbol: symbol,
            name: name,
            price: price != nil ? String(format: "$%.2f", price!) : "$0.00",
            change: change != nil ? String(format: "%+.2f", change!) : "+0.00",
            changePercent: changePercent != nil ? String(format: "%+.2f%%", changePercent!) : "+0.00%",
            isPositive: isPositive
        )

        watchlists[index].items.append(newItem)
        saveWatchlists()
    }

    /// Removes an item from a watchlist
    /// - Parameters:
    ///   - item: The watchlist item to remove
    ///   - watchlist: Target watchlist (defaults to active watchlist)
    func removeFromWatchlist(_ item: WatchlistItem, fromWatchlist watchlist: Watchlist? = nil) {
        let targetWatchlist = watchlist ?? activeWatchlist
        guard let targetWatchlist = targetWatchlist else { return }
        guard let index = watchlists.firstIndex(where: { $0.id == targetWatchlist.id }) else { return }

        watchlists[index].items.removeAll { $0.id == item.id }
        saveWatchlists()
    }

    /// Checks if a symbol is present in a watchlist
    /// - Parameters:
    ///   - symbol: The stock symbol to check
    ///   - watchlist: Target watchlist (defaults to active watchlist)
    /// - Returns: True if the symbol exists in the watchlist
    func isInWatchlist(symbol: String, watchlist: Watchlist? = nil) -> Bool {
        let targetWatchlist = watchlist ?? activeWatchlist
        return targetWatchlist?.items.contains { $0.symbol == symbol } ?? false
    }

    /// Reorders items within a watchlist (for drag-and-drop)
    /// - Parameters:
    ///   - source: Source index set
    ///   - destination: Destination index
    ///   - watchlist: The watchlist to modify
    func moveItem(from source: IndexSet, to destination: Int, in watchlist: Watchlist) {
        guard let index = watchlists.firstIndex(where: { $0.id == watchlist.id }) else { return }
        watchlists[index].items.move(fromOffsets: source, toOffset: destination)
        saveWatchlists()
    }

    // MARK: - Legacy Methods (for backward compatibility)

    @available(*, deprecated, message: "Use addToWatchlist(toWatchlist:) instead")
    func addToWatchlist(symbol: String, name: String) {
        addToWatchlist(symbol: symbol, name: name, price: nil, change: nil, changePercent: nil, isPositive: true, toWatchlist: nil)
    }

    @available(*, deprecated, message: "Use removeFromWatchlist(fromWatchlist:) instead")
    func removeFromWatchlist(_ item: WatchlistItem) {
        removeFromWatchlist(item, fromWatchlist: nil)
    }
}

// MARK: - Helper Structs

// Legacy struct for migration
private struct SavedWatchlistItem: Codable {
    let symbol: String
    let name: String
    let price: String
    let change: String
    let changePercent: String
    let isPositive: Bool
}
