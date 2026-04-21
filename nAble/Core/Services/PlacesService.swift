import UIKit

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}

class PlacesService {
    static let shared = PlacesService()
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "GooglePlacesAPIKey") as? String ?? ""
    private let baseURL = "https://places.googleapis.com/v1/places"
    
    private init() {}
    
    func post<T: Decodable>(endpoint: String, body: [String: Any], fieldMask: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-Goog-Api-Key")
        request.setValue(fieldMask, forHTTPHeaderField: "X-Goog-FieldMask")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func get<T: Decodable>(endpoint: String, fieldMask: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)?key=\(apiKey)&fields=\(fieldMask)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func getPhotoURL(photoName: String, maxWidth: Int = 400) -> URL? {
        guard !photoName.isEmpty else { return nil }
        let urlString = "https://places.googleapis.com/v1/\(photoName)/media?maxWidthPx=\(maxWidth)&key=\(apiKey)"
        return URL(string: urlString)
    }
}
