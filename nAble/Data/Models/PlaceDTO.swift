import UIKit

struct NearbySearchResponseDTO: Codable {
    let places: [PlaceDTO]?
}

struct PlaceDTO: Codable {
    let id: String?
    let rating: Double?
    let displayName: LocalizedTextDTO?
    let reviews: [ReviewDTO]?
    let photos: [PhotoDTO]?
    let accessibilityOptions: AccessibilityOptionsDTO?
    let formattedAddress: String?
    let location: LocationDTO?
}
