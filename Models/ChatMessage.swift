import Foundation

enum MessageSender: String, Codable {
    case user = "User"
    case assistant = "Assistant"
}

struct ChatMessage: Identifiable, Codable {
    var id: String
    var text: String
    var sender: MessageSender
    var timestamp: Date
    var isLoading: Bool = false
    var relatedTripId: String?
    
    init(id: String = UUID().uuidString, text: String, sender: MessageSender, 
         timestamp: Date = Date(), isLoading: Bool = false, relatedTripId: String? = nil) {
        self.id = id
        self.text = text
        self.sender = sender
        self.timestamp = timestamp
        self.isLoading = isLoading
        self.relatedTripId = relatedTripId
    }
}

struct ChatSession: Identifiable, Codable {
    var id: String
    var title: String
    var messages: [ChatMessage]
    var createdDate: Date
    var lastUpdated: Date
    
    init(id: String = UUID().uuidString, title: String, messages: [ChatMessage] = [], 
         createdDate: Date = Date(), lastUpdated: Date = Date()) {
        self.id = id
        self.title = title
        self.messages = messages
        self.createdDate = createdDate
        self.lastUpdated = lastUpdated
    }
} 