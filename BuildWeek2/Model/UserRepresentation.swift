import Foundation

struct UserRepresentation: Codable {
    var id: Int?
    var username: String
    var password: String
    var phoneNumber: String?
    var avatarUrl: String?
    var bearer: String?
}
