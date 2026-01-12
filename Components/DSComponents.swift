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

// MARK: - Toast Notification Component

/// Toast notification that appears at the top of the screen
/// Used for temporary success messages (e.g., "Artikel gespeichert!")
struct DSToast: View {
    let message: String
    let icon: String
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            HStack(spacing: DesignSystem.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.primary)

                Text(message)
                    .font(DesignSystem.Typography.body2)
                    .foregroundColor(DesignSystem.Colors.onBackground)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(DesignSystem.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                    .fill(DesignSystem.Colors.surface)
                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 4)
            )
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.top, DesignSystem.Spacing.lg)

            Spacer()
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .onAppear {
            // Auto-dismiss after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    isPresented = false
                }
            }
        }
    }
}

// MARK: - Toast Modifier

/// ViewModifier to easily show toast notifications
struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let icon: String

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                DSToast(message: message, icon: icon, isPresented: $isPresented)
                    .zIndex(999)
            }
        }
    }
}

extension View {
    /// Show a toast notification
    func toast(isPresented: Binding<Bool>, message: String, icon: String = "checkmark.circle.fill") -> some View {
        modifier(ToastModifier(isPresented: isPresented, message: message, icon: icon))
    }
}