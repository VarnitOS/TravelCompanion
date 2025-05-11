import Foundation

struct Accommodation: Identifiable, Codable {
    var id: String
    var tripId: String
    var name: String
    var address: String
    var checkInDate: Date
    var checkOutDate: Date
    var price: Double?
    var bookingReference: String?
    var notes: String?
    
    init(id: String = UUID().uuidString, tripId: String, name: String, 
         address: String, checkInDate: Date, checkOutDate: Date, 
         price: Double? = nil, bookingReference: String? = nil, notes: String? = nil) {
        self.id = id
        self.tripId = tripId
        self.name = name
        self.address = address
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.price = price
        self.bookingReference = bookingReference
        self.notes = notes
    }
} 