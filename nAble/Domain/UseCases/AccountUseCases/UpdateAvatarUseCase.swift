import UIKit

class UpdateAvatarUseCase {
    private let imageRepository: ImageRepositoryProtocol
    private let userRepository: UserRepositoryProtocol

    init(imageRepository: ImageRepositoryProtocol, userRepository: UserRepositoryProtocol) {
        self.imageRepository = imageRepository
        self.userRepository = userRepository
    }

    func execute(userId: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let path = "avatars/\(userId).jpg"
        imageRepository.uploadImage(image, path: path) { [weak self] result in
            switch result {
            case .success(let url):
                self?.userRepository.updateImageUrl(userId: userId, imageUrl: url) { updateResult in
                    switch updateResult {
                    case .success:
                        completion(.success(url))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
