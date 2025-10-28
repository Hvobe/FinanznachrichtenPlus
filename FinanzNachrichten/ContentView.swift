import SwiftUI

// Import all components from AllComponents.swift
// This is a temporary solution until the file is properly added to the Xcode project

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Main content based on selected tab
            switch selectedTab {
            case 0:
                HomeView()
            case 1:
                MarketsView()
            case 2:
                WatchlistView()
            case 3:
                MediaView()
            case 4:
                MenuView()
            default:
                HomeView()
            }
            
            // Bottom Navigation
            VStack {
                Spacer()
                BottomNavigationView(selectedTab: $selectedTab)
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




