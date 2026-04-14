//
//  FirebaseAuthRepository.swift
//  nAble
//
//  Created by Eorime on 14.04.26.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
//TODO: google sign in usecase da repo

class FirebaseAuthUseCases: AuthRepository {
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
        }
    }
    
    func changePassword(currentPassword: String?, newPassword: String?, completion: @escaping (Result<User, any Error>) -> Void) {
        <#code#>
    }
    
    func deleteAccount(password: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        <#code#>
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
