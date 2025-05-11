import Foundation

struct Trip: Identifiable, Codable {
    var id: String
    var title: String
    var destination: String
    var startDate: Date
    var endDate: Date
    var description: String?
    var isFavorite: Bool = false
    var userId: String
    var imageUrl: String?
    var budget: Double?
    var currency: String = "USD"
    var travelMethod: TravelMethod?
    var status: TripStatus = .planned
    
    init(id: String = UUID().uuidString, title: String, destination: String, 
         startDate: Date, endDate: Date, description: String? = nil, 
         isFavorite: Bool = false, userId: String, imageUrl: String? = nil,
         budget: Double? = nil, currency: String = "USD", 
         travelMethod: TravelMethod? = nil, status: TripStatus = .planned) {
        self.id = id
        self.title = title
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.isFavorite = isFavorite
        self.userId = userId
        self.imageUrl = imageUrl
        self.budget = budget
        self.currency = currency
        self.travelMethod = travelMethod
        self.status = status
    }
}

enum TravelMethod: String, Codable, CaseIterable {
    case flight = "Flight"
    case train = "Train"
    case car = "Car"
    case bus = "Bus"
    case ship = "Ship"
    case other = "Other"
}

enum TripStatus: String, Codable, CaseIterable {
    case planned = "Planned"
    case active = "Active"
    case completed = "Completed"
    case cancelled = "Cancelled"
} 