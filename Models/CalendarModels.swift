//
//  CalendarModels.swift
//  FinanzNachrichten
//
//  Models für Kalender und Termin-Ereignisse
//
//  ENTHÄLT:
//  - ScheduleItem: Termin-Ereignisse (Earnings, Dividenden, Feiertage, Wirtschaftsdaten)
//  - ScheduleType: Typen von Termin-Ereignissen mit Farb-Coding
//

import SwiftUI

// MARK: - Schedule Item

/// Calendar event item displayed in schedule sections
struct ScheduleItem {
    let title: String
    let date: String
    let time: String
    let type: ScheduleType
}

// MARK: - Schedule Type

enum ScheduleType {
    case earnings
    case exDividend
    case dividend
    case holiday
    case economicData
    
    var color: Color {
        switch self {
        case .earnings: return .blue
        case .exDividend: return Color.orange.opacity(0.8)
        case .dividend: return .orange
        case .holiday: return Color.red.opacity(0.6)
        case .economicData: return .gray
        }
    }
    
    var displayName: String {
        switch self {
        case .earnings: return "Quartalszahlen"
        case .exDividend: return "Ex-Dividende"
        case .dividend: return "Dividende"
        case .holiday: return "Feiertag"
        case .economicData: return "Wirtschaftsdaten"
        }
    }
}