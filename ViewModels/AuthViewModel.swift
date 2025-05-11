import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    // This will be implemented when we set up Supabase integration
    func signIn(email: String, password: String) {
        // Authentication logic will go here
    }
    
    func signUp(email: String, password: String) {
        // Sign up logic will go here
    }
    
    func signOut() {
        // Sign out logic will go here
    }
} 