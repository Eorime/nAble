//
//  FetchSavedPlacesUseCase.swift
//  nAble
//
//  Created by Eorime on 20.04.26.
//


class FetchSavedPlacesUseCase {
    private let repository: PlacesRepositoryProtocol
    
    init(repository: PlacesRepositoryProtocol = PlacesRepository()) {
        self.repository = repository
    }
    
    func execute(userId: String) async throws -> [Place] {
        try await repository.fetchSavedPlaces(userId: userId)
    }
}
