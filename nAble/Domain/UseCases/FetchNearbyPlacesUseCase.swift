class FetchNearbyPlacesUseCase {
    private let repository: PlacesRepositoryProtocol
    
    init(repository: PlacesRepositoryProtocol = PlacesRepository()) {
        self.repository = repository
    }
    
    func execute(latitude: Double, longitude: Double, radius: Double = 1000) async throws -> [Place] {
        try await repository.fetchNearbyPlaces(latitude: latitude, longitude: longitude, radius: radius)
    }
}
