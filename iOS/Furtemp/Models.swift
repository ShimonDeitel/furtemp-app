import Foundation

struct FurtempEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var temperature: Double
    var notes: String
}
