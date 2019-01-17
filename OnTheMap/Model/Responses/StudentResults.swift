//
// {"results":[{"objectId":"ojdMSAgq0M","uniqueKey":"1234","firstName":"John","lastName":"Doe","mapString":"Mountain View, CA","mediaURL":"https://udacity.com","latitude":37.386052,"longitude":-122.083851,"createdAt":"2019-01-17T11:16:39.692Z","updatedAt":"2019-01-17T11:16:39.692Z"}
//

import Foundation

struct StudentResults: Codable {
    
    let results: [StudentLocation]

}
