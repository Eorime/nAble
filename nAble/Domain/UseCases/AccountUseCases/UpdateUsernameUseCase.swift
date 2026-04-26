class UpdateUsernameUseCase {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func execute(userId: String, username: String, completion: @escaping (Result<Void, Error>) -> Void) {
        userRepository.updateUsername(userId: userId, userName: username, completion: completion)
    }
}
