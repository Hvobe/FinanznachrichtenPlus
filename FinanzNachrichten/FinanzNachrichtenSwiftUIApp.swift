import SwiftUI

// Temporary - remove these once files are properly added to Xcode project
#if canImport(Services)
import Services
#endif

@main
struct FinanzNachrichtenSwiftUIApp: App {
    // Temporarily comment out services until properly imported
    // @StateObject private var bookmarkService = BookmarkService()
    // @StateObject private var notificationService = NotificationService()
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // .environmentObject(bookmarkService)
                // .environmentObject(notificationService)
            // Onboarding temporarily disabled until proper module structure is implemented
            // if showOnboarding {
            //     OnboardingView(showOnboarding: $showOnboarding)
            //         .transition(AnyTransition.opacity)
            // }
        }
    }
}