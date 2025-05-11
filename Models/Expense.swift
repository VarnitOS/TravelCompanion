import Foundation

enum ExpenseCategory: String, Codable, CaseIterable {
    case food = "Food"
    case transportation = "Transportation"
    case accommodation = "Accommodation"
    case activities = "Activities"
    case shopping = "Shopping"
    case medical = "Medical"
    case fees = "Fees"
    case other = "Other"
}

enum PaymentMethod: String, Codable, CaseIterable {
    case cash = "Cash"
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case mobilePayment = "Mobile Payment"
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
    var paymentMethod: PaymentMethod
    var location: String?
    var imageUrl: String?
    var isReimbursable: Bool = false
    
    init(id: String = UUID().uuidString, tripId: String, amount: Double, 
         currency: String, date: Date, category: ExpenseCategory, 
         description: String, paymentMethod: PaymentMethod = .cash,
         location: String? = nil, imageUrl: String? = nil,
         isReimbursable: Bool = false) {
        self.id = id
        self.tripId = tripId
        self.amount = amount
        self.currency = currency
        self.date = date
        self.category = category
        self.description = description
        self.paymentMethod = paymentMethod
        self.location = location
        self.imageUrl = imageUrl
        self.isReimbursable = isReimbursable
    }
} 