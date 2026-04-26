import FirebaseFirestore

protocol UserRepositoryProtocol {
    func updateFullName(userId: String, fullName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUsername(userId: String, userName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateImageUrl(userId: String, imageUrl: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class UserRepository: UserRepositoryProtocol {
    private let db = Firestore.firestore()
    
    func updateFullName(userId: String, fullName: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        db.collection("users").document(userId).updateData([
            "fullName": fullName
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateUsername(userId: String, userName: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        db.collection("users").document(userId).updateData([
            "username": userName
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateImageUrl(userId: String, imageUrl: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userId).updateData([
            "imageUrl": imageUrl
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
