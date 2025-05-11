import Foundation
import Combine

class DatabaseManager: ObservableObject {
    private let supabaseService = SupabaseService.shared
    
    // MARK: - Trip Methods
    
    func getTrips(for userId: String) async throws -> [Trip] {
        return try await supabaseService.getTrips(for: userId)
    }
    
    func getUpcomingTrips(for userId: String) async throws -> [Trip] {
        let allTrips = try await getTrips(for: userId)
        return allTrips.filter { $0.startDate > Date() }
            .sorted { $0.startDate < $1.startDate }
    }
    
    func getPastTrips(for userId: String) async throws -> [Trip] {
        let allTrips = try await getTrips(for: userId)
        return allTrips.filter { $0.endDate < Date() }
            .sorted { $0.endDate > $1.endDate }
    }
    
    func getCurrentTrips(for userId: String) async throws -> [Trip] {
        let allTrips = try await getTrips(for: userId)
        let now = Date()
        return allTrips.filter { $0.startDate <= now && $0.endDate >= now }
            .sorted { $0.endDate < $1.endDate }
    }
    
    func getFavoriteTrips(for userId: String) async throws -> [Trip] {
        let allTrips = try await getTrips(for: userId)
        return allTrips.filter { $0.isFavorite }
            .sorted { $0.startDate < $1.startDate }
    }
    
    func getTrip(id: String) async throws -> Trip {
        return try await supabaseService.getTrip(id: id)
    }
    
    func createTrip(_ trip: Trip) async throws -> Trip {
        return try await supabaseService.createTrip(trip)
    }
    
    func updateTrip(_ trip: Trip) async throws -> Trip {
        return try await supabaseService.updateTrip(trip)
    }
    
    func deleteTrip(id: String) async throws {
        try await supabaseService.deleteTrip(id: id)
    }
    
    func toggleFavorite(for trip: Trip) async throws -> Trip {
        var updatedTrip = trip
        updatedTrip.isFavorite.toggle()
        return try await updateTrip(updatedTrip)
    }
    
    // MARK: - Accommodation Methods
    
    func getAccommodations(for tripId: String) async throws -> [Accommodation] {
        return try await supabaseService.getAccommodations(for: tripId)
    }
    
    func createAccommodation(_ accommodation: Accommodation) async throws -> Accommodation {
        return try await supabaseService.createAccommodation(accommodation)
    }
    
    func updateAccommodation(_ accommodation: Accommodation) async throws -> Accommodation {
        return try await supabaseService.updateAccommodation(accommodation)
    }
    
    func deleteAccommodation(id: String) async throws {
        try await supabaseService.deleteAccommodation(id: id)
    }
    
    // MARK: - Expense Methods
    
    func getExpenses(for tripId: String) async throws -> [Expense] {
        return try await supabaseService.getExpenses(for: tripId)
    }
    
    func getExpensesByCategory(for tripId: String) async throws -> [ExpenseCategory: [Expense]] {
        let expenses = try await getExpenses(for: tripId)
        return Dictionary(grouping: expenses, by: { $0.category })
    }
    
    func getExpenseSummary(for tripId: String) async throws -> [ExpenseCategory: Double] {
        let expenses = try await getExpenses(for: tripId)
        var summary: [ExpenseCategory: Double] = [:]
        
        for category in ExpenseCategory.allCases {
            let totalForCategory = expenses
                .filter { $0.category == category }
                .reduce(0) { $0 + $1.amount }
            
            if totalForCategory > 0 {
                summary[category] = totalForCategory
            }
        }
        
        return summary
    }
    
    func getTotalExpense(for tripId: String) async throws -> Double {
        let expenses = try await getExpenses(for: tripId)
        return expenses.reduce(0) { $0 + $1.amount }
    }
    
    func createExpense(_ expense: Expense) async throws -> Expense {
        return try await supabaseService.createExpense(expense)
    }
    
    func updateExpense(_ expense: Expense) async throws -> Expense {
        return try await supabaseService.updateExpense(expense)
    }
    
    func deleteExpense(id: String) async throws {
        try await supabaseService.deleteExpense(id: id)
    }
    
    // MARK: - Storage Methods
    
    func uploadProfileImage(userId: String, imageData: Data) async throws -> String {
        return try await supabaseService.uploadProfileImage(userId: userId, imageData: imageData)
    }
    
    func getProfileImageURL(path: String) -> URL? {
        return supabaseService.getProfileImageURL(path: path)
    }
    
    func uploadTripImage(tripId: String, imageData: Data) async throws -> String {
        return try await supabaseService.uploadTripImage(tripId: tripId, imageData: imageData)
    }
    
    func getTripImageURL(path: String) -> URL? {
        return supabaseService.getTripImageURL(path: path)
    }
} 