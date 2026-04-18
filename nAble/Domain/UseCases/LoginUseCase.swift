import Foundation

class LoginUseCase {
    private let authRepo: AuthRepository
    
    init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }
    
    func execute(email: String, password: String, completion: @escaping(Result<User, Error>)-> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            completion(.failure(NSError(domain: "ValidationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email and password can't be empty"])))
            return
        }
        
        authRepo.login(email: email, password: password, completion: completion)
    }
}
