//
//  FetchAccessiblePlacesUseCase.swift
//  nAble
//
//  Created by Eorime on 20.04.26.
//


class FetchAccessiblePlacesUseCase {
    private let fetchNearbyPlaces: FetchNearbyPlacesUseCase
    
    init(fetchNearbyPlaces: FetchNearbyPlacesUseCase = FetchNearbyPlacesUseCase()) {
        self.fetchNearbyPlaces = fetchNearbyPlaces
    }
    
    func execute(latitude: Double, longitude: Double) async throws -> [Place] {
        let places = try await fetchNearbyPlaces.execute(latitude: latitude, longitude: longitude)
        return places.filter {
            $0.accessibilityOptions.hasWheelchairEntrance ||
            $0.accessibilityOptions.hasWheelchairRestroom ||
            $0.accessibilityOptions.hasWheelchairParking ||
            $0.accessibilityOptions.hasWheelchairSeating
        }
    }
}