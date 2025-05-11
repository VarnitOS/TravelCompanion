import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var upcomingTrips: [Trip] = []
    @Published var recentExpenses: [Expense] = []
    @Published var isLoading = false
    
    init() {
        // Will fetch data when we have models and database set up
    }
    
    func fetchData() {
        isLoading = true
        // Data fetching will be implemented later
        isLoading = false
    }
    
    func signOut() {
        // Will be implemented with AuthViewModel
    }
} 