import CoreLocation

protocol GetCurrentLocationUseCaseProtocol {
    func execute(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void)
}

class GetCurrentLocationUseCase: GetCurrentLocationUseCaseProtocol {
    private let locationService: LocationServiceProtocol
    
    init(locationService: LocationServiceProtocol) {
            self.locationService = locationService
    }
    
    func execute(completion: @escaping (Result<CLLocationCoordinate2D, any Error>) -> Void) {
        locationService.getCurrentLocation(completion: completion)
    }
}

