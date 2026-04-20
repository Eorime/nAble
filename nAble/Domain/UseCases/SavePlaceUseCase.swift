//
//  SavePlaceUseCase.swift
//  nAble
//
//  Created by Eorime on 20.04.26.
//



class SavePlaceUseCase {
    private let repository: PlacesRepositoryProtocol
    
    init(repository: PlacesRepositoryProtocol = PlacesRepository()) {
        self.repository = repository
    }
    
    func execute(userId: String, place: Place) async throws {
        try await repository.savePlace(userId: userId, place: place)
    }
}
