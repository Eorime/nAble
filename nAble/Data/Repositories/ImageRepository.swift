import FirebaseStorage
import UIKit

protocol ImageRepositoryProtocol {
    func uploadImage(_ image: UIImage, path: String, completion: @escaping (Result<String, Error>) -> Void)
}

class ImageRepository: ImageRepositoryProtocol {
    private let storage = Storage.storage()

    func uploadImage(_ image: UIImage, path: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image"])))
            return
        }

        let ref = storage.reference().child(path)
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            ref.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
}
