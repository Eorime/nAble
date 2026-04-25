protocol GetLocationsUseCaseProtocol {
    func execute(userId: String) async throws -> [UserLocationModel]
}

class GetLocationsUseCase: GetLocationsUseCaseProtocol {
    private let repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(userId: String) async throws -> [UserLocationModel] {
        try await withCheckedThrowingContinuation { continuation in
            repository.getLocations(userId: userId) { result in
                switch result {
                case .success(let locations):
                    continuation.resume(returning: locations)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
