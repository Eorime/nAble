class FetchNearbyPlacesUseCase {
    private let repository: PlacesRepositoryProtocol
    
    init(repository: PlacesRepositoryProtocol = PlacesRepository()) {
        self.repository = repository
    }
    
    func execute(latitude: Double, longitude: Double, radius: Double = 1000) async throws -> [Place] {
        let places = try await repository.fetchNearbyPlaces(latitude: latitude, longitude: longitude, radius: radius)
        return places.filter {
            $0.accessibilityOptions.hasWheelchairEntrance ||
            $0.accessibilityOptions.hasWheelchairRestroom ||
            $0.accessibilityOptions.hasWheelchairParking ||
            $0.accessibilityOptions.hasWheelchairSeating
        }
    }
}
