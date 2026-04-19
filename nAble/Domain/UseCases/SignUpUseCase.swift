import UIKit

class SignUpUseCase {
    private let authRepo: AuthRepository
    
    init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }
    
    func execute(email: String, password: String, fullName: String, userName: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard !email.isEmpty, !password.isEmpty, !fullName.isEmpty, !userName.isEmpty else {
            completion(.failure(NSError(domain: "ValidationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "All fields are required"])))
            return
        }
        
        authRepo.signUp(email: email, password: password, username: userName, fullName: fullName, completion: completion)
    }
}
