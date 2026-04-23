import UIKit

protocol RemoveLocationUseCaseProtocol {
    func execute(userId: String, locationId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class RemoveLocationUseCase: RemoveLocationUseCaseProtocol {
    private let repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(userId: String, locationId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.removeLocation(userId: userId, locationId: locationId, completion: completion)
    }
}
