import Foundation

struct GroomingSession: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var petName: String
    var groomingType: String
    var date: Date = Date()
    var notes: String = ""
}
