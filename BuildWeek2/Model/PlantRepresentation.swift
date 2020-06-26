import Foundation

struct PlantRepresentation: Equatable, Codable {
    var id: Int
    var nickname: String
    var species: String?
    var h20Frequencey: Int?
    var userId: Int?
    var avatarUrl: String?
    var happiness: Bool?
    var lastWateredAt: Date?
}
