//
//  UpdateUsernameUseCase 2.swift
//  nAble
//
//  Created by Eorime on 25.04.26.
//


class UpdateUsernameUseCase {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func execute(userId: String, username: String, completion: @escaping (Result<Void, Error>) -> Void) {
        userRepository.updateUsername(userId: userId, userName: username, completion: completion)
    }
}
