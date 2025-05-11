import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Text("Home Dashboard")
                .font(.largeTitle)
                .padding()
            
            Text("Welcome to Travel Companion")
                .font(.headline)
        }
        .navigationTitle("Home")
    }
} 