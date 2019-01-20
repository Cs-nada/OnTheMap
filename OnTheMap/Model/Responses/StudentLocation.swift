
import Foundation

struct StudentLocation: Codable {
    
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
    
}

extension StudentLocation {
    
    func getFullName() -> String {
        return "\(firstName ?? "Anonymous") \(lastName ?? "Student")"
    }
    
    func getUrlString() -> String {
        return "\(mediaURL ?? "No URL provided for student")"
    }
}
