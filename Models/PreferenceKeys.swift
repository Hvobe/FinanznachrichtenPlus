//
//  PreferenceKeys.swift
//  FinanzNachrichten
//
//  SwiftUI PreferenceKeys für UI-Tracking
//  Wird verwendet um Scroll-Position zu tracken (z.B. für aktives Segment in horizontal scroll)
//

import SwiftUI

// MARK: - View Offset Data

/// Data structure for tracking view offset in horizontal scrolls
struct ViewOffsetData: Equatable {
    let index: Int
    let offset: CGFloat
}

// MARK: - View Offset Key

struct ViewOffsetKey: PreferenceKey {
    typealias Value = ViewOffsetData
    static var defaultValue = ViewOffsetData(index: 0, offset: 0)
    
    static func reduce(value: inout ViewOffsetData, nextValue: () -> ViewOffsetData) {
        let next = nextValue()
        let screenMidX = UIScreen.main.bounds.width / 2
        
        // Keep the value that's closest to center
        if abs(next.offset - screenMidX) < abs(value.offset - screenMidX) {
            value = next
        }
    }
}