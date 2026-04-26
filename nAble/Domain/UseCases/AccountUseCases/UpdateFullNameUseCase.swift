class UpdateFullNameUseCase {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func execute(userId: String, fullName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        userRepository.updateFullName(userId: userId, fullName: fullName, completion: completion)
    }
}
