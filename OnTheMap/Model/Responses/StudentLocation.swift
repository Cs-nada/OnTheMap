
/*
 "createdAt": "2015-02-25T01:10:38.103Z",
 "firstName": "Jarrod",
 "lastName": "Parkes",
 "latitude": 34.7303688,
 "longitude": -86.5861037,
 "mapString": "Huntsville, Alabama ",
 "mediaURL": "https://www.linkedin.com/in/jarrodparkes",
 "objectId": "JhOtcRkxsh",
 "uniqueKey": "996618664",
 "updatedAt": "2015-03-09T22:04:50.315Z"
 
 {"results":[{"objectId":"ojdMSAgq0M","uniqueKey":"1234","firstName":"John","lastName":"Doe","mapString":"Mountain View, CA","mediaURL":"https://udacity.com","latitude":37.386052,"longitude":-122.083851,"createdAt":"2019-01-17T11:16:39.692Z","updatedAt":"2019-01-17T11:16:39.692Z"}
 */
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
