//
//  GetAllLocationsUseCaseProtocol.swift
//  nAble
//
//  Created by Eorime on 22.04.26.
//


import UIKit

protocol GetAllLocationsUseCaseProtocol {
    func execute(completion: @escaping (Result<[UserLocationModel], Error>) -> Void)
}

class GetAllLocationsUseCase: GetAllLocationsUseCaseProtocol {
    private let repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result<[UserLocationModel], Error>) -> Void) {
        repository.getAllLocations(completion: completion)
    }
}
