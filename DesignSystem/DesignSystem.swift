//
//  DesignSystem.swift
//  FinanzNachrichten
//
//  Zentrales Design-System für konsistentes UI über alle Plattformen
//
//  WICHTIG: SINGLE SOURCE OF TRUTH für alle visuellen Konstanten
//  - Spacing: 4pt-Basis-System (xs: 4, sm: 8, md: 12, lg: 16, xl: 24, xxl: 32)
//  - Colors: 12 adaptive Color Assets mit Dark Mode Support
//  - Typography: Semantische Text-Styles (largeTitle → caption)
//  - Shadows: 3 Elevation-Level (low, medium, high)
//  - Animation: Standard-Timings und Spring-Kurven
//
//  USAGE GUIDE:
//  Verwende diese Werte IMMER anstatt Hard-Coded Values!
//  Beispiel: .padding(DesignSystem.Spacing.md) statt .padding(12)
//
//  Für andere Entwickler:
//  - **Android/Jetpack Compose**: CGFloat → dp, Font → sp, siehe PlatformNotes
//  - **Web/CSS**: Spacing → rem, Colors → hex, siehe Examples
//  - **Accessibility**: Minimum 44pt Tap-Target, 4.5:1 Text-Kontrast
//

import SwiftUI

// MARK: - Core Design System

struct DesignSystem {
    
    // MARK: - Spacing
    /// Consistent spacing values for layout and component padding
    /// Usage: Use smaller values (xs, sm) for tight spaces within components,
    /// medium values (md, lg) for general spacing, and larger values (xl, xxl) for major sections
    struct Spacing {
        // Base spacing values - use these for most spacing needs
        static let xs: CGFloat = 4    // Tight spacing within components
        static let sm: CGFloat = 8    // Small gaps between related elements
        static let md: CGFloat = 12   // Medium spacing for component padding
        static let lg: CGFloat = 16   // Standard spacing between components
        static let xl: CGFloat = 24   // Large spacing between sections
        static let xxl: CGFloat = 32  // Extra large spacing for major divisions
        
        // Section-specific spacing - use for consistent layout sections
        struct Section {
            static let between: CGFloat = 24      // Between major sections (e.g., between "Top Performer" and "Schedule")
            static let headerGap: CGFloat = 12    // From section header to its content
            static let withinSection: CGFloat = 16 // Between items within a section
        }
        
        // Card and shadow spacing - specific to card components
        struct Cards {
            static let gap: CGFloat = 12          // Horizontal/vertical gap between cards in a grid
            static let shadowPadding: CGFloat = 15 // Extra invisible padding to prevent shadow clipping
        }
        
        // Page-level spacing - for screen margins and safe areas
        struct Page {
            static let horizontal: CGFloat = 16   // Left and right page margins
            static let top: CGFloat = 16          // Top margin (below navigation)
            static let bottom: CGFloat = 100      // Bottom margin (accounts for tab bar)
        }
    }
    
    // MARK: - Corner Radius
    /// Standard corner radius values for rounded elements
    /// Usage: sm for subtle rounding, md for buttons, lg for cards, xl for modals
    struct CornerRadius {
        static let sm: CGFloat = 4    // Subtle rounding for small elements
        static let md: CGFloat = 8    // Standard button rounding
        static let lg: CGFloat = 12   // Card corners
        static let xl: CGFloat = 16   // Large cards and modals
        static let full: CGFloat = 999 // Fully rounded (pills, circles)
    }
    
    // MARK: - Shadows & Elevation
    /// Shadow definitions for depth and hierarchy
    /// Usage: Apply shadows to cards, buttons, and floating elements
    struct Shadows {
        static let card = Color.black.opacity(0.1)
        static let cardRadius: CGFloat = 4
        static let cardOffset = CGSize(width: 0, height: 2)
        
        // Elevation levels (following Material Design principles)
        struct Elevation {
            static let low = (color: Color.black.opacity(0.08), radius: 4.0, y: 2.0)
            static let medium = (color: Color.black.opacity(0.12), radius: 8.0, y: 4.0)
            static let high = (color: Color.black.opacity(0.16), radius: 16.0, y: 8.0)
        }
    }
    
    // MARK: - Animation
    /// Standard animation durations and curves
    /// Usage: Keep animations consistent across the app
    struct Animation {
        static let fast: Double = 0.2      // Quick transitions (e.g., button press)
        static let medium: Double = 0.3    // Standard transitions
        static let slow: Double = 0.5      // Deliberate animations
        
        // Spring animations for natural motion
        static let springResponse: Double = 0.4
        static let springDamping: Double = 0.8
        
        // Easing curves
        static let easeIn = SwiftUI.Animation.easeIn(duration: medium)
        static let easeOut = SwiftUI.Animation.easeOut(duration: medium)
        static let spring = SwiftUI.Animation.spring(response: springResponse, dampingFraction: springDamping)
    }
    
    // MARK: - Icon Sizes
    /// Consistent icon sizing across the app
    /// Usage: Match icon size to its context (navigation, buttons, inline)
    struct IconSize {
        static let xs: CGFloat = 12   // Inline small icons
        static let sm: CGFloat = 16   // Small buttons and labels
        static let md: CGFloat = 24   // Standard icons (navigation, buttons)
        static let lg: CGFloat = 32   // Prominent feature icons
        static let xl: CGFloat = 48   // Large feature icons
        static let xxl: CGFloat = 64  // Hero icons
    }
    
    // MARK: - Component Heights
    /// Standard heights for interactive components
    struct ComponentHeight {
        static let buttonLarge: CGFloat = 56    // Primary action buttons
        static let buttonMedium: CGFloat = 48   // Standard buttons
        static let buttonSmall: CGFloat = 32    // Compact buttons
        static let inputField: CGFloat = 48     // Text input fields
        static let tabBar: CGFloat = 80         // Bottom navigation
        static let navigationBar: CGFloat = 64  // Top navigation
    }
}

// MARK: - Extended Design System

extension DesignSystem {
    
    // MARK: - Colors
    /// Core color palette with semantic naming
    /// For Android: Convert RGB values to hex codes
    /// For Dark Mode: Define alternative color sets
    struct Colors {
        // Brand Colors
        static let primary = Color(red: 0.8, green: 0.2, blue: 0.2)      // #CC3333 - FN logo red
        static let primaryDark = Color(red: 0.6, green: 0.15, blue: 0.15) // #991A1A - Darker variant
        static let primaryLight = Color(red: 0.9, green: 0.3, blue: 0.3)  // #E64D4D - Lighter variant
        
        // Background Colors - Adaptive
        static let background = Color("Background")         // Light: White, Dark: Black
        static let surface = Color("Surface")              // Light: White, Dark: Gray
        static let surfaceVariant = Color("SurfaceVariant") // Light: Light Gray, Dark: Darker Gray
        
        // Text Colors - Adaptive
        static let onBackground = Color("OnBackground")     // Light: Black, Dark: White
        static let onSurface = Color("OnSurface")          // Light: Black, Dark: White
        static let onPrimary = Color.white                  // Always white on primary
        
        // Semantic Colors
        static let secondary = Color("Secondary")           // Light: Gray, Dark: Light Gray
        static let tertiary = Color("Tertiary")            // Light: Light Gray, Dark: Medium Gray
        static let success = Color.green                    // #00C853 - Positive changes
        static let error = Color(red: 0.8, green: 0.2, blue: 0.2) // #CC3333 - Negative changes
        static let warning = Color.orange                   // #FFA726 - Warning states
        static let info = Color.blue                       // #2196F3 - Information
        
        // Component-specific Colors - Adaptive
        static let cardBackground = Color("CardBackground") // Light: White, Dark: Dark Gray
        static let onCard = Color("OnCard")                // Light: Black, Dark: White
        static let border = Color("Border")                // Light: Very Light Gray, Dark: Dark Gray
        static let separator = Color("Separator")          // Light: Light Gray, Dark: Dark Gray
        static let inputBackground = Color("InputBackground") // Light: Light Gray, Dark: Dark Gray
        
        // Shadow Colors
        static let shadowLight = Color.black.opacity(0.1)   // 10% black
        static let shadowMedium = Color.black.opacity(0.15) // 15% black
        static let shadowStrong = Color.black.opacity(0.2)  // 20% black
        
        // State Colors
        struct States {
            static let hover = Color.black.opacity(0.04)    // Hover overlay
            static let pressed = Color.black.opacity(0.08)  // Pressed overlay
            static let disabled = Color.gray.opacity(0.3)   // Disabled elements
            static let focus = primary.opacity(0.12)        // Focus ring
        }
    }
    
    // MARK: - Typography
    /// Consistent text styles throughout the app
    /// Usage Guidelines:
    /// - largeTitle: Main screen headers
    /// - title1-3: Section headers (decreasing importance)
    /// - body1-2: Main content text
    /// - caption: Metadata and supplementary info
    struct Typography {
        // Display Styles
        static let largeTitle = Font.system(size: 28, weight: .bold)      // Screen titles
        static let title1 = Font.system(size: 22, weight: .bold)          // Primary headings
        static let title2 = Font.system(size: 18, weight: .bold)          // Secondary headings
        static let title3 = Font.system(size: 16, weight: .semibold)      // Tertiary headings
        // Content Styles
        static let headline = Font.system(size: 16, weight: .semibold)    // Article headlines
        static let body = Font.system(size: 16, weight: .regular)         // Default body text
        static let body1 = Font.system(size: 16, weight: .regular)        // Primary content
        static let body2 = Font.system(size: 14, weight: .regular)        // Secondary content
        static let callout = Font.system(size: 14, weight: .regular)      // Highlighted info
        static let subheadline = Font.system(size: 14, weight: .medium)   // Sub-headers
        static let footnote = Font.system(size: 12, weight: .regular)     // Small print
        static let caption1 = Font.system(size: 12, weight: .medium)      // Image captions
        static let caption2 = Font.system(size: 10, weight: .medium)      // Tiny labels
        
        // Component-specific Styles
        static let sectionHeader = Font.system(size: 12, weight: .semibold)  // "TOP PERFORMER", "SCHEDULE"
        static let cardTitle = Font.system(size: 12, weight: .medium)        // Market card names
        static let cardValue = Font.system(size: 16, weight: .bold)          // Market values
        static let cardChange = Font.system(size: 12, weight: .medium)       // +/- percentages
        static let newsTag = Font.system(size: 10, weight: .bold)            // News category tags
        static let newsHeadline = Font.system(size: 16, weight: .semibold)   // News titles
        static let newsTime = Font.system(size: 12, weight: .regular)        // Timestamps
        static let buttonText = Font.system(size: 16, weight: .semibold)     // Button labels
        static let tabLabel = Font.system(size: 11, weight: .medium)         // Tab bar labels
    }
}

// MARK: - Usage Examples & Best Practices

extension DesignSystem {
    
    /// Example usage patterns for common UI components
    struct Examples {
        
        /// Card Component Example
        /// ```swift
        /// DSCard(
        ///     backgroundColor: Colors.surface,
        ///     cornerRadius: CornerRadius.lg,
        ///     padding: Spacing.md,
        ///     hasShadow: true
        /// ) {
        ///     // Card content
        /// }
        /// ```
        
        /// Button Example
        /// ```swift
        /// Button(action: {}) {
        ///     Text("Action")
        ///         .font(Typography.buttonText)
        ///         .foregroundColor(Colors.onPrimary)
        ///         .frame(height: ComponentHeight.buttonMedium)
        ///         .padding(.horizontal, Spacing.lg)
        ///         .background(Colors.primary)
        ///         .cornerRadius(CornerRadius.md)
        /// }
        /// ```
        
        /// Section Layout Example
        /// ```swift
        /// VStack(spacing: Spacing.Section.between) {
        ///     // Section 1
        ///     VStack(spacing: Spacing.Section.headerGap) {
        ///         Text("SECTION TITLE")
        ///             .font(Typography.sectionHeader)
        ///         // Section content
        ///     }
        ///     
        ///     // Section 2
        ///     VStack(spacing: Spacing.Section.withinSection) {
        ///         // Items within section
        ///     }
        /// }
        /// .padding(.horizontal, Spacing.Page.horizontal)
        /// ```
    }
    
    /// Platform-specific conversion notes
    struct PlatformNotes {
        /// iOS to Android (Jetpack Compose) Conversion:
        /// - CGFloat → dp (density-independent pixels)
        /// - Font sizes → sp (scale-independent pixels)
        /// - Color(red:green:blue:) → Color(0xFF...)
        /// - VStack → Column, HStack → Row, ZStack → Box
        /// - .padding() → Modifier.padding()
        /// - @State → remember { mutableStateOf() }
        
        /// Web (CSS) Conversion:
        /// - Spacing values → rem (1 rem = 16px typically)
        /// - Colors → CSS hex values or rgba()
        /// - Shadows → box-shadow property
        /// - Corner radius → border-radius
    }
    /// Accessibility Guidelines
    struct Accessibility {
        /// Minimum tap target size: 44x44 points (iOS) / 48x48 dp (Android)
        static let minTapTarget: CGFloat = 44
        
        /// Text contrast ratios:
        /// - Normal text: 4.5:1 minimum
        /// - Large text: 3:1 minimum
        /// - Always test with system accessibility settings
        
        /// Focus indicators:
        /// - Use Colors.States.focus for keyboard navigation
        /// - Ensure all interactive elements are reachable
        
        /// Screen reader support:
        /// - Add meaningful labels to all UI elements
        /// - Group related content
        /// - Provide hints for complex interactions
    }
}