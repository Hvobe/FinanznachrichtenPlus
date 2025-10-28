//
//  NavigationModels.swift
//  FinanzNachrichten
//
//  Models für Navigation und Menü-Strukturen
//  Verwendet in MenuView für Settings-Bereiche
//

import Foundation

// MARK: - Menu Section

/// Menu section grouping related menu items
struct MenuSection {
    let title: String
    let items: [MenuItem]
}

// MARK: - Menu Item

struct MenuItem {
    let title: String
    let subtitle: String?
    let hasChevron: Bool
    let hasToggle: Bool
    
    init(title: String, subtitle: String? = nil, hasChevron: Bool = true, hasToggle: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.hasChevron = hasChevron
        self.hasToggle = hasToggle
    }
}