//
//  DSComponents.swift
//  FinanzNachrichten
//
//  Core design system components for consistent UI styling
//

import SwiftUI

// MARK: - DS Card Component

struct DSCard<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    let borderColor: Color?
    let cornerRadius: CGFloat
    let padding: CGFloat
    let hasShadow: Bool
    
    init(
        backgroundColor: Color = DesignSystem.Colors.surface,
        borderColor: Color? = DesignSystem.Colors.border,
        cornerRadius: CGFloat = DesignSystem.CornerRadius.lg,
        padding: CGFloat = DesignSystem.Spacing.lg,
        hasShadow: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.hasShadow = hasShadow
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor ?? Color.clear, lineWidth: borderColor != nil ? 1 : 0)
            )
            .compositingGroup()
            .shadow(
                color: hasShadow ? DesignSystem.Colors.shadowLight : Color.clear,
                radius: hasShadow ? 10 : 0,
                x: 0,
                y: hasShadow ? 4 : 0
            )
    }
}

// MARK: - DS Separator Component

struct DSSeparator: View {
    enum Orientation {
        case horizontal
        case vertical
    }
    
    let orientation: Orientation
    
    init(orientation: Orientation = .horizontal) {
        self.orientation = orientation
    }
    
    var body: some View {
        Rectangle()
            .fill(DesignSystem.Colors.separator)
            .frame(
                width: orientation == .vertical ? 1 : nil,
                height: orientation == .horizontal ? 1 : nil
            )
    }
}

// MARK: - FN Logo View

struct FNLogoView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Rotated square background
            RoundedRectangle(cornerRadius: size * 0.15)
                .fill(Color(red: 0.8, green: 0.2, blue: 0.2)) // #CC3333 equivalent
                .frame(width: size, height: size)
                .rotationEffect(.degrees(45))
            
            // FN Text
            Text("FN")
                .font(.system(size: size * 0.5, weight: .bold, design: .default))
                .foregroundColor(.white)
        }
        .frame(width: size * 1.2, height: size * 1.2)
    }
}