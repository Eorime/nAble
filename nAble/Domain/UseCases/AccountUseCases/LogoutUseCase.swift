import Foundation

class LogoutUseCase {
    private let authRepo: AuthRepository
    
    init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }
    
    func execute(completion: @escaping (Result<Void, Error>) -> Void) {
           authRepo.logout(completion: completion)
       }
}
