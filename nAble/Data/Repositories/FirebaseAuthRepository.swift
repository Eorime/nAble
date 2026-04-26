import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn

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
    
    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Result<User, any Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing client ID"])))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
            
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
                
            guard let user = result?.user,
                    let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing Google credentials"])))
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
                
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let firebaseUser = authResult?.user else {
                    completion(.failure(NSError(domain: "AuthError", code: -1)))
                    return
                }
                    
                self?.db.collection("users").document(firebaseUser.uid).getDocument { snapshot, error in
                    if let data = snapshot?.data(), !data.isEmpty {
                        self?.fetchUser(userId: firebaseUser.uid, completion: completion)
                    } else {
                        let newUser = User(
                            id: firebaseUser.uid,
                            fullName: firebaseUser.displayName ?? "",
                            userName: firebaseUser.email?.components(separatedBy: "@").first ?? "",
                            email: firebaseUser.email ?? "",
                            userLocations: [],
                            imageUrl: firebaseUser.photoURL?.absoluteString ?? ""
                        )
                        self?.saveUser(user: newUser) { result in
                            switch result {
                            case .success:
                                completion(.success(newUser))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                }
            }
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
    
    func finalizeDeletion(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(userId)
        let group = DispatchGroup()
        var deletionError: Error?

        group.enter()
        userRef.collection("locations").getDocuments { snapshot, error in
            if let error = error {
                deletionError = error
                group.leave()
                return
            }
            let batch = self.db.batch()
            snapshot?.documents.forEach { batch.deleteDocument($0.reference) }
            batch.commit { error in
                if let error = error { deletionError = error }
                group.leave()
            }
        }

        group.enter()
        userRef.collection("savedPlaces").getDocuments { snapshot, error in
            if let error = error {
                deletionError = error
                group.leave()
                return
            }
            let batch = self.db.batch()
            snapshot?.documents.forEach { batch.deleteDocument($0.reference) }
            batch.commit { error in
                if let error = error { deletionError = error }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            if let error = deletionError {
                completion(.failure(error))
                return
            }

            userRef.delete { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                Auth.auth().currentUser?.delete { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
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
                            userName: userData["username"] as? String ?? "",
                            email: userData["email"] as? String ?? "",
                            userLocations: userData["userLocations"] as? [UserLocationModel] ?? [],
                            imageUrl: userData["imageUrl"] as? String ?? "")
            
            completion(.success(user))
            
        }
    }
}
