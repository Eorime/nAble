import UIKit
import FirebaseFirestore

protocol LocationRepositoryProtocol {
    func addLocation(userId: String, location: UserLocationModel, completion: @escaping (Result<Void, Error>) -> Void)
    func removeLocation(userId: String, locationId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getLocations(userId: String, completion: @escaping (Result<[UserLocationModel], Error>) -> Void)
    func getAllLocations(completion: @escaping (Result<[UserLocationModel], Error>) -> Void)
}

class LocationRepository: LocationRepositoryProtocol {
    private let db = Firestore.firestore()
    
    func addLocation(userId: String, location: UserLocationModel, completion: @escaping (Result<Void, Error>) -> Void) {
        var locationData: [String: Any] = [
            "id": location.id,
            "latitude": location.latitude,
            "longitude": location.longitude,
            "locationId": location.locationId,
            "userId": location.userId,
            "username": location.username,
            "timestamp": Timestamp(date: location.timeStamp)
        ]

        if let imageURL = location.imageURL {
            locationData["imageURL"] = imageURL
        }

        db.collection("users")
            .document(userId)
            .collection("locations")
            .document(location.id)
            .setData(locationData) { error in
                if let error = error { completion(.failure(error)) }
                else { completion(.success(())) }
            }
    }
    
    func removeLocation(userId: String, locationId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        db.collection("users")
            .document(userId)
            .collection("locations")
            .document(locationId)
            .delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    func getLocations(userId: String, completion: @escaping (Result<[UserLocationModel], any Error>) -> Void) {
        db.collection("users")
            .document(userId)
            .collection("locations")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let locations = documents.compactMap { doc -> UserLocationModel? in
                    let data = doc.data()
                    guard let id = data["id"] as? String,
                          let latitude = data["latitude"] as? Double,
                          let longitude = data["longitude"] as? Double,
                          let locationId = data["locationId"] as? String,
                          let userId = data["userId"] as? String,
                          let username = data["username"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    return UserLocationModel(
                        id: id,
                        latitude: latitude,
                        longitude: longitude,
                        locationId: locationId,
                        userId: userId,
                        username: username,
                        timeStamp: timestamp.dateValue(),
                        imageURL: data["imageURL"] as? String
                    )
                }
                completion(.success(locations))
            }
    }
    
    func getAllLocations(completion: @escaping (Result<[UserLocationModel], any Error>) -> Void) {
        db.collectionGroup("locations")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let locations = documents.compactMap { doc -> UserLocationModel? in
                    let data = doc.data()
                    guard let id = data["id"] as? String,
                          let latitude = data["latitude"] as? Double,
                          let longitude = data["longitude"] as? Double,
                          let locationId = data["locationId"] as? String,
                          let userId = data["userId"] as? String,
                          let username = data["username"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    
                    return UserLocationModel(
                        id: id,
                        latitude: latitude,
                        longitude: longitude,
                        locationId: locationId,
                        userId: userId,
                        username: username,
                        timeStamp: timestamp.dateValue(),
                        imageURL: data["imageURL"] as? String
                    )
                }
                completion(.success(locations))
            }
    }
}
