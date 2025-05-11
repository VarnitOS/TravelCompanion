import Foundation

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var displayName: String
    var profileImageUrl: String?
    var createdDate: Date
    var preferences: UserPreferences
    
    init(id: String = UUID().uuidString, email: String, displayName: String, 
         profileImageUrl: String? = nil, 
         createdDate: Date = Date(), 
         preferences: UserPreferences = UserPreferences()) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.profileImageUrl = profileImageUrl
        self.createdDate = createdDate
        self.preferences = preferences
    }
}

struct UserPreferences: Codable {
    var defaultCurrency: String = "USD"
    var notificationsEnabled: Bool = true
    var darkModeEnabled: Bool = false
    var languageCode: String = "en"
    
    init(defaultCurrency: String = "USD", 
         notificationsEnabled: Bool = true, 
         darkModeEnabled: Bool = false, 
         languageCode: String = "en") {
        self.defaultCurrency = defaultCurrency
        self.notificationsEnabled = notificationsEnabled
        self.darkModeEnabled = darkModeEnabled
        self.languageCode = languageCode
    }
} 