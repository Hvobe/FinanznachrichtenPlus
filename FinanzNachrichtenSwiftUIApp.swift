import SwiftUI

@main
struct FinanzNachrichtenSwiftUIApp: App {
    @StateObject private var bookmarkService = BookmarkService()
    @StateObject private var notificationService = NotificationService()
    @StateObject private var watchlistService = WatchlistService.shared
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if showOnboarding {
                    OnboardingView(showOnboarding: $showOnboarding)
                } else {
                    ContentView()
                        .environmentObject(bookmarkService)
                        .environmentObject(notificationService)
                        .environmentObject(watchlistService)
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}