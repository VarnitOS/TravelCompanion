import Foundation

enum ExpenseCategory: String, Codable, CaseIterable {
    case food = "Food"
    case transportation = "Transportation"
    case accommodation = "Accommodation"
    case activities = "Activities"
    case shopping = "Shopping"
    case other = "Other"
}

struct Expense: Identifiable, Codable {
    var id: String
    var tripId: String
    var amount: Double
    var currency: String
    var date: Date
    var category: ExpenseCategory
    var description: String
    
    init(id: String = UUID().uuidString, tripId: String, amount: Double, 
         currency: String, date: Date, category: ExpenseCategory, 
         description: String) {
        self.id = id
        self.tripId = tripId
        self.amount = amount
        self.currency = currency
        self.date = date
        self.category = category
        self.description = description
    }
} 