import UIKit

protocol AddLocationUseCaseProtocol {
    func execute(userId: String, location: UserLocationModel, completion: @escaping (Result<Void, Error>) -> Void)
}

class AddLocationUseCase: AddLocationUseCaseProtocol {
    private let repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(userId: String, location: UserLocationModel, completion: @escaping (Result<Void, any Error>) -> Void) {
        repository.addLocation(userId: userId, location: location, completion: completion)
    }
}
