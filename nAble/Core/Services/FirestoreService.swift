import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    let db = Firestore.firestore()
    
    private init() {}
    
    func fetchCollection<T: Codable>(_ collectionName: String) async throws -> [(id: String, data: T)] {
        let snapshot = try await db.collection(collectionName).getDocuments()
        
        return snapshot.documents.compactMap { document in
            guard let data = try? document.data(as: T.self) else {
                return nil
            }
            return (id: document.documentID, data: data)
        }
    }
    
    func fetchDocument<T: Codable>(_ collectionName: String, id: String) async throws -> T {
        let document = try await db.collection(collectionName).document(id).getDocument()
        
        guard let data = try? document.data(as: T.self) else {
            throw NSError()
        }
        
        return data
    }
}
