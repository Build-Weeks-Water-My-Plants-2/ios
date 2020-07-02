import Foundation

struct UserLoginResults {
    var data: UserRepresentation
    var token: Bearer
}

struct UserRepresentation: Codable {

    var id: Int?
    var username: String
    var password: String
    var phoneNumber: String?
    var avatarUrl: String?
    var bearer: String?
}

struct Bearer: Codable {
    let token: String
}
