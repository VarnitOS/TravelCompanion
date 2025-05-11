import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationView {
                TripListView()
            }
            .tabItem {
                Label("Trips", systemImage: "airplane")
            }
            
            NavigationView {
                ExpenseListView()
            }
            .tabItem {
                Label("Expenses", systemImage: "dollarsign.circle")
            }
            
            NavigationView {
                ChatView()
            }
            .tabItem {
                Label("Assistant", systemImage: "message")
            }
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
} 