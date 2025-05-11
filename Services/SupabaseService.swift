import Foundation
import Supabase

enum SupabaseError: Error {
    case authenticationFailed(String)
    case databaseError(String)
    case storageError(String)
    case networkError(String)
    case decodingError(String)
    case userNotFound
    case unauthorized
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .authenticationFailed(let message):
            return "Authentication failed: \(message)"
        case .databaseError(let message):
            return "Database error: \(message)"
        case .storageError(let message):
            return "Storage error: \(message)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .decodingError(let message):
            return "Failed to decode data: \(message)"
        case .userNotFound:
            return "User not found"
        case .unauthorized:
            return "You are not authorized to perform this action"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

class SupabaseService {
    static let shared = SupabaseService()
    
    private let client: SupabaseClient
    
    private init() {
        // TODO: Replace these placeholder values with your actual Supabase credentials
        // 1. Go to your Supabase project dashboard: https://app.supabase.com
        // 2. Click on "Settings" in the sidebar, then "API"
        // 3. Copy the URL under "Project URL"
        // 4. Copy the "anon" public key under "Project API Keys"
        client = SupabaseClient(
            supabaseURL: URL(string: "YOUR_SUPABASE_URL")!,
            supabaseKey: "YOUR_SUPABASE_ANON_KEY"
        )
        
        // After updating with real values, it should look like:
        // client = SupabaseClient(
        //     supabaseURL: URL(string: "https://abcdefghijklm.supabase.co")!,
        //     supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
        // )
    }
    
    // MARK: - Auth Methods
    
    func getCurrentUser() async throws -> User? {
        do {
            let session = try await client.auth.session
            let user = session.user
            
            return User(
                id: user.id.uuidString,
                email: user.email ?? "",
                displayName: user.userMetadata["display_name"] as? String ?? "",
                profileImageUrl: user.userMetadata["avatar_url"] as? String,
                createdDate: user.createdAt ?? Date()
            )
        } catch {
            print("Error getting current user: \(error.localizedDescription)")
            return nil
        }
    }
    
    func signUp(email: String, password: String, displayName: String) async throws -> User {
        do {
            let authResponse = try await client.auth.signUp(
                email: email,
                password: password,
                data: ["display_name": displayName]
            )
            
            guard let user = authResponse.user else {
                throw SupabaseError.authenticationFailed("Failed to get user after sign up")
            }
            
            return User(
                id: user.id.uuidString,
                email: user.email ?? "",
                displayName: displayName,
                createdDate: user.createdAt ?? Date()
            )
        } catch {
            throw SupabaseError.authenticationFailed(error.localizedDescription)
        }
    }
    
    func signIn(email: String, password: String) async throws -> User {
        do {
            let authResponse = try await client.auth.signIn(
                email: email,
                password: password
            )
            
            guard let user = authResponse.user else {
                throw SupabaseError.authenticationFailed("Failed to get user after sign in")
            }
            
            return User(
                id: user.id.uuidString,
                email: user.email ?? "",
                displayName: user.userMetadata["display_name"] as? String ?? "",
                profileImageUrl: user.userMetadata["avatar_url"] as? String,
                createdDate: user.createdAt ?? Date()
            )
        } catch {
            throw SupabaseError.authenticationFailed(error.localizedDescription)
        }
    }
    
    func signOut() async throws {
        do {
            try await client.auth.signOut()
        } catch {
            throw SupabaseError.authenticationFailed(error.localizedDescription)
        }
    }
    
    func resetPassword(email: String) async throws {
        do {
            try await client.auth.resetPasswordForEmail(email)
        } catch {
            throw SupabaseError.authenticationFailed(error.localizedDescription)
        }
    }
    
    // MARK: - Database Methods - Trips
    
    func getTrips(for userId: String) async throws -> [Trip] {
        do {
            let response = try await client
                .from("trips")
                .select()
                .eq("user_id", value: userId)
                .execute()
            
            return try response.value.decode(as: [Trip].self)
        } catch {
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }
    
    func getTrip(id: String) async throws -> Trip {
        do {
            let response = try await client
                .from("trips")
                .select()
                .eq("id", value: id)
                .single()
                .execute()
            
            return try response.value.decode(as: Trip.self)
        } catch {
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }
    
    func createTrip(_ trip: Trip) async throws -> Trip {
        do {
            let response = try await client
                .from("trips")
                .insert(trip)
                .single()
                .execute()
            
            return try response.value.decode(as: Trip.self)
        } catch {
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }
    
    func updateTrip(_ trip: Trip) async throws -> Trip {
        do {
            let response = try await client
                .from("trips")
                .update(trip)
                .eq("id", value: trip.id)
                .single()
                .execute()
            
            return try response.value.decode(as: Trip.self)
        } catch {
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }
    
    func deleteTrip(id: String) async throws {
        do {
            _ = try await client
                .from("trips")
                .delete()
                .eq("id", value: id)
                .execute()
        } catch {
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }
    
    // MARK: - Database Methods - Accommodations
    
    func getAccommodations(for tripId: String) async throws -> [Accommodation] {
        do {
            let response = try await client
                .from("accommodations")
                .select()
                .eq("trip_id", value: tripId)
                .execute()
            
            return try response.value.decode(as: [Accommodation].self)
        } catch {
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }
    
    func createAccommodation(_ accommodation: Accommodation) async throws -> Accommodation {
        do {
            let response = try await client
                .from("accommodations")
                .insert(accommodation)
                .single()
                .execute()
            
            return try response.value.decode(as: Accommodation.self)
        } catch {
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }
    
    func updateAccommodation(_ accommodation: Accommodation) async throws -> Accommodation {
        do {
            let response = try await client
                .from("accommodations")
                .update(accommodation)
                .eq("id", value: accommodation.id)
                .single()
                .execute()
            
            return try response.value.decode(as: Accommodation.self)
        } catch {
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }
    
    func deleteAccommodation(id: String) async throws {
        do {
            _ = try await client
                .from("accommodations")
                .delete()
                .eq("id", value: id)
                .execute()
        } catch {
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }
    
    // MARK: - Database Methods - Expenses
    
    func getExpenses(for tripId: String) async throws -> [Expense] {
        do {
            let response = try await client
                .from("expenses")
                .select()
                .eq("trip_id", value: tripId)
                .execute()
            
            return try response.value.decode(as: [Expense].self)
        } catch {
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }
    
    func createExpense(_ expense: Expense) async throws -> Expense {
        do {
            let response = try await client
                .from("expenses")
                .insert(expense)
                .single()
                .execute()
            
            return try response.value.decode(as: Expense.self)
        } catch {
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }
    
    func updateExpense(_ expense: Expense) async throws -> Expense {
        do {
            let response = try await client
                .from("expenses")
                .update(expense)
                .eq("id", value: expense.id)
                .single()
                .execute()
            
            return try response.value.decode(as: Expense.self)
        } catch {
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }
    
    func deleteExpense(id: String) async throws {
        do {
            _ = try await client
                .from("expenses")
                .delete()
                .eq("id", value: id)
                .execute()
        } catch {
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }
    
    // MARK: - Storage Methods
    
    func uploadProfileImage(userId: String, imageData: Data) async throws -> String {
        do {
            let filePath = "profile_images/\(userId).jpg"
            
            _ = try await client.storage
                .from("avatars")
                .upload(
                    path: filePath,
                    file: imageData,
                    fileOptions: FileOptions(
                        cacheControl: "3600",
                        contentType: "image/jpeg"
                    )
                )
            
            return filePath
        } catch {
            throw SupabaseError.storageError(error.localizedDescription)
        }
    }
    
    func getProfileImageURL(path: String) -> URL? {
        return client.storage.from("avatars").getPublicURL(path: path)
    }
    
    func uploadTripImage(tripId: String, imageData: Data) async throws -> String {
        do {
            let filePath = "trip_images/\(tripId)/\(UUID().uuidString).jpg"
            
            _ = try await client.storage
                .from("trips")
                .upload(
                    path: filePath,
                    file: imageData,
                    fileOptions: FileOptions(
                        cacheControl: "3600",
                        contentType: "image/jpeg"
                    )
                )
            
            return filePath
        } catch {
            throw SupabaseError.storageError(error.localizedDescription)
        }
    }
    
    func getTripImageURL(path: String) -> URL? {
        return client.storage.from("trips").getPublicURL(path: path)
    }
} 