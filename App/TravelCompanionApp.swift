import SwiftUI

@main
struct TravelCompanionApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var databaseManager = DatabaseManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(databaseManager)
                .onOpenURL { url in
                    // Handle deep links for authentication callbacks
                    print("Opening URL: \(url)")
                    // This will be used for auth callbacks from Supabase
                }
        }
    }
} 