//
//  FetchNearbyPlacesUseCase.swift
//  nAble
//
//  Created by Eorime on 20.04.26.
//


class FetchNearbyPlacesUseCase {
    private let repository: PlacesRepositoryProtocol
    
    init(repository: PlacesRepositoryProtocol = PlacesRepository()) {
        self.repository = repository
    }
    
    func execute(latitude: Double, longitude: Double, radius: Double = 1000) async throws -> [Place] {
        try await repository.fetchNearbyPlaces(latitude: latitude, longitude: longitude, radius: radius)
    }
}

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

class SavePlaceUseCase {
    private let repository: PlacesRepositoryProtocol
    
    init(repository: PlacesRepositoryProtocol = PlacesRepository()) {
        self.repository = repository
    }
    
    func execute(userId: String, place: Place) async throws {
        try await repository.savePlace(userId: userId, place: place)
    }
}

class RemoveSavedPlaceUseCase {
    private let repository: PlacesRepositoryProtocol
    
    init(repository: PlacesRepositoryProtocol = PlacesRepository()) {
        self.repository = repository
    }
    
    func execute(userId: String, placeId: String) async throws {
        try await repository.removeSavedPlace(userId: userId, placeId: placeId)
    }
}

class FetchSavedPlacesUseCase {
    private let repository: PlacesRepositoryProtocol
    
    init(repository: PlacesRepositoryProtocol = PlacesRepository()) {
        self.repository = repository
    }
    
    func execute(userId: String) async throws -> [Place] {
        try await repository.fetchSavedPlaces(userId: userId)
    }
}
