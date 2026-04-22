import UIKit
import CoreLocation

struct UserLocationModel: Identifiable, Codable, Hashable {
    var id: String
    let latitude: Double
    let longitude: Double
    let locationId: String
    let userId: String
    let username: String
    let timeStamp: Date
    let imageURL: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case locationId
        case userId
        case username
        case timeStamp
        case imageURL
    }
}
