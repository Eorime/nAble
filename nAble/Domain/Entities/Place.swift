import UIKit

struct Place: Codable {
    let id: String
    let name: String
    let address: String
    let rating: Double
    let accessibilityOptions: AccessibilityOptions
    let reviews: [Review]
    let photos: [Photo]
    let location: Location
    
    struct AccessibilityOptions: Codable {
        let hasWheelchairEntrance: Bool
        let hasWheelchairRestroom: Bool
        let hasWheelchairParking: Bool
        let hasWheelchairSeating: Bool
    }
    
    struct Review: Codable {
        let rating: Int
        let text: String
        let relativeTime: String
        let authorName: String
        let authorPhotoUrl: String?
    }
    
    struct Photo: Codable {
        let reference: String
        let width: Int
        let height: Int
    }
    
    struct Location: Codable {
        let latitude: Double
        let longitude: Double
    }
}
