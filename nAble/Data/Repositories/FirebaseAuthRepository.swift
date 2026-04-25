import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
//TODO: google sign in usecase da repo

class FirebaseAuthRepository: AuthRepository {
    private let db = Firestore.firestore()
    
    func login(email: String, password: String, completion: @escaping (Result<User, any Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = authResult?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1)))
                return
            }
            
            self?.fetchUser(userId: firebaseUser.uid, completion: completion)
        }
    }
    
    func logout(completion: @escaping (Result<Void, any Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func signUp(email: String, password: String, username: String, fullName: String, completion: @escaping (Result<User, any Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = authResult?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1)))
                return
            }
            
            let user = User(id: firebaseUser.uid, fullName: fullName, userName: username, email: email, userLocations: [], imageUrl: "")
            
            self?.saveUser(user: user) { result in
                switch result {
                case .success:
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func changePassword(currentPassword: String?, newPassword: String?, completion: @escaping (Result<User, any Error>) -> Void) {
        print("daamate")
    }
    
    func deleteAccount(password: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])))
            return
        }
        
        guard let email = user.email, let password = password else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email and password required"])))
            return
        }
        
        let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user.reauthenticate(with: credentials) { [weak self] _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self?.finalizeDeletion(userId: user.uid, completion: completion)
        }
    }
    
    func finalizeDeletion(userId: String, completion: @escaping (Result <Void, Error>) -> Void) {
        db.collection("users").document(userId).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            Auth.auth().currentUser?.delete { error in
                if let error = error {
                    completion(.failure(error))
                    return
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    func saveUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let userData: [String: Any] = [
            "id": user.id,
            "fullName": user.fullName,
            "username": user.userName,
            "email": user.email,
            "imageUrl": user.imageUrl,
            "userLocations": []
        ]
        
        db.collection("users").document(user.id).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userData = snapshot?.data() else {
                completion(.failure(NSError(domain: "AuthError", code: -2)))
                return
            }
            
            let user = User(id: userData["id"] as? String ?? userId,
                            fullName: userData["fullName"] as? String ?? "",
                            userName: userData["userName"] as? String ?? "",
                            email: userData["email"] as? String ?? "",
                            userLocations: userData["userLocations"] as? [UserLocationModel] ?? [],
                            imageUrl: userData["imageUrl"] as? String ?? "")
            
            completion(.success(user))
            
        }
    }
}

//TODO: places details sheet + open in maps
//TODO: add google sign in
//TODO: profile page favorited places horizontal scroll + page for your locations/remove
//TODO: added location details (vin daamata, rodis, foto)
//TODO: add picture field to user, optional
