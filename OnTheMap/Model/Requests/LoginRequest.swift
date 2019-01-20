
import Foundation

struct LoginRequest: Codable {
    let udacity: CredentialsRequest
}

struct CredentialsRequest: Codable {
    let username: String
    let password: String
}
