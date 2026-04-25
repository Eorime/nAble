import Foundation

class DeleteAccountUseCase {
    private let authRepo: AuthRepository
    
    init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }
    
    func execute(password: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        authRepo.deleteAccount(password: password, completion: completion)
    }
}
