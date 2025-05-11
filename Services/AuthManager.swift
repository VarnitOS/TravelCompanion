import Foundation
import Combine
import SwiftUI

class AuthManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var authError: Error?
    
    private let supabaseService = SupabaseService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Check for existing session on startup
        Task {
            await checkAuthentication()
        }
    }
    
    func checkAuthentication() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.authError = nil
        }
        
        do {
            if let user = try await supabaseService.getCurrentUser() {
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                    self.currentUser = nil
                    self.isLoading = false
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.authError = error
                self.isAuthenticated = false
                self.currentUser = nil
                self.isLoading = false
            }
        }
    }
    
    func signUp(email: String, password: String, displayName: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.authError = nil
        }
        
        do {
            let user = try await supabaseService.signUp(
                email: email,
                password: password,
                displayName: displayName
            )
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.authError = error
                self.isLoading = false
            }
        }
    }
    
    func signIn(email: String, password: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.authError = nil
        }
        
        do {
            let user = try await supabaseService.signIn(
                email: email,
                password: password
            )
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.authError = error
                self.isLoading = false
            }
        }
    }
    
    func signOut() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.authError = nil
        }
        
        do {
            try await supabaseService.signOut()
            
            DispatchQueue.main.async {
                self.currentUser = nil
                self.isAuthenticated = false
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.authError = error
                self.isLoading = false
            }
        }
    }
    
    func resetPassword(email: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.authError = nil
        }
        
        do {
            try await supabaseService.resetPassword(email: email)
            DispatchQueue.main.async {
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.authError = error
                self.isLoading = false
            }
        }
    }
} 