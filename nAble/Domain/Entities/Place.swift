import UIKit

struct Place {
    let name: String
    let address: String
    let rating: Double
    let accessibilityOptions: AccessibilityOptions
    let reviews: [Review]
    let photos: [Photo]
    let location: Location
    
    struct AccessibilityOptions {
        let hasWheelchairEntrance: Bool
        let hasWheelchairRestroom: Bool
        let hasWheelchairParking: Bool
        let hasWheelchairSeating: Bool
    }
    
    struct Review {
        let rating: Int
        let text: String
        let relativeTime: String
        let authorName: String
        let authorPhotoUrl: String?
    }
    
    struct Photo {
        let reference: String
        let width: Int
        let height: Int
    }
    
    struct Location {
        let latitude: Double
        let longitude: Double
    }
}
