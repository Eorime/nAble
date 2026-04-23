class RemoveSavedPlaceUseCase {
    private let repository: PlacesRepositoryProtocol
    
    init(repository: PlacesRepositoryProtocol = PlacesRepository()) {
        self.repository = repository
    }
    
    func execute(userId: String, placeId: String) async throws {
        try await repository.removeSavedPlace(userId: userId, placeId: placeId)
    }
}
