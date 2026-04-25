import FirebaseFirestore

protocol PlacesRepositoryProtocol {
    func fetchNearbyPlaces(latitude: Double, longitude: Double, radius: Double) async throws -> [Place]
    func savePlace(userId: String, place: Place) async throws
    func removeSavedPlace(userId: String, placeId: String) async throws
    func fetchSavedPlaces(userId: String) async throws -> [Place]
}

import FirebaseFirestore

class PlacesRepository: PlacesRepositoryProtocol {
    private let db = Firestore.firestore()
    private let service = PlacesService.shared
    private let fieldMask = "places.displayName,places.rating,places.reviews,places.photos,places.accessibilityOptions,places.formattedAddress,places.location,places.id"
    
    func fetchNearbyPlaces(latitude: Double, longitude: Double, radius: Double = 1000) async throws -> [Place] {
        let body: [String: Any] = [
            "locationRestriction": [
                "circle": [
                    "center": [
                        "latitude": latitude,
                        "longitude": longitude
                    ],
                    "radius": radius
                ]
            ]
        ]
        
        let response: NearbySearchResponseDTO = try await service.post(
            endpoint: ":searchNearby",
            body: body,
            fieldMask: fieldMask
        )
        
        return (response.places ?? []).map { $0.toEntity() }
    }
    
    func savePlace(userId: String, place: Place) async throws {
        let placeData: [String: Any] = [
            "id": place.id,
            "name": place.name,
            "address": place.address,
            "rating": place.rating,
            "latitude": place.location.latitude,
            "longitude": place.location.longitude,
            "hasWheelchairEntrance": place.accessibilityOptions.hasWheelchairEntrance,
            "hasWheelchairRestroom": place.accessibilityOptions.hasWheelchairRestroom,
            "hasWheelchairParking": place.accessibilityOptions.hasWheelchairParking,
            "hasWheelchairSeating": place.accessibilityOptions.hasWheelchairSeating,
            "photos": place.photos.map { [
                "reference": $0.reference,
                "width": $0.width,
                "height": $0.height
            ]}
        ]
        
        try await db.collection("users")
            .document(userId)
            .collection("savedPlaces")
            .document(place.id)
            .setData(placeData)
    }
    
    func removeSavedPlace(userId: String, placeId: String) async throws {
        try await db.collection("users")
            .document(userId)
            .collection("savedPlaces")
            .document(placeId)
            .delete()
    }
    
    func fetchSavedPlaces(userId: String) async throws -> [Place] {
        let snapshot = try await db.collection("users")
            .document(userId)
            .collection("savedPlaces")
            .getDocuments()
        
        return snapshot.documents.compactMap { doc -> Place? in
            let data = doc.data()
            guard let id = data["id"] as? String,
                  let name = data["name"] as? String,
                  let address = data["address"] as? String,
                  let rating = data["rating"] as? Double,
                  let latitude = data["latitude"] as? Double,
                  let longitude = data["longitude"] as? Double else {
                return nil
            }
            
            let photos = (data["photos"] as? [[String: Any]] ?? []).map {
                Place.Photo(
                    reference: $0["reference"] as? String ?? "",
                    width: $0["width"] as? Int ?? 0,
                    height: $0["height"] as? Int ?? 0
                )
            }
            
            return Place(
                id: id,
                name: name,
                address: address,
                rating: rating,
                accessibilityOptions: Place.AccessibilityOptions(
                    hasWheelchairEntrance: data["hasWheelchairEntrance"] as? Bool ?? false,
                    hasWheelchairRestroom: data["hasWheelchairRestroom"] as? Bool ?? false,
                    hasWheelchairParking: data["hasWheelchairParking"] as? Bool ?? false,
                    hasWheelchairSeating: data["hasWheelchairSeating"] as? Bool ?? false
                ),
                reviews: [],
                photos: photos,
                location: Place.Location(
                    latitude: latitude,
                    longitude: longitude
                )
            )
        }
    }
}
