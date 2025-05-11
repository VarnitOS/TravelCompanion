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
    
    init(id: String = UUID().uuidString, title: String, destination: String, 
         startDate: Date, endDate: Date, description: String? = nil, 
         isFavorite: Bool = false, userId: String) {
        self.id = id
        self.title = title
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.isFavorite = isFavorite
        self.userId = userId
    }
} 