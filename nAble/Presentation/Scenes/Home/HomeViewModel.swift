import SwiftUI
import Combine
import CoreLocation

class HomeViewModel: ObservableObject {
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var error: Error?
    
    private var getCurrentLocation: GetCurrentLocationUseCaseProtocol
    private let locationService: LocationServiceProtocol

    init(
        getCurrentLocation: GetCurrentLocationUseCaseProtocol,
        locationService: LocationServiceProtocol
    ) {
        self.getCurrentLocation = getCurrentLocation
        self.locationService = locationService
    }
    
    func requestLocation() {
        getCurrentLocation.execute { [weak self] result in
            switch result {
            case .success(let coordinate):
                DispatchQueue.main.async {
                    self?.userLocation = coordinate
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
            }
        }
    }
    
    func startTrackingLocation() {
        locationService.startMonitoringLocation { [weak self] coordinate in
            DispatchQueue.main.async {
                self?.userLocation = coordinate
            }
        }
    }
    
    func stopTrackingLocation() {
        locationService.stopMonitoringLocation()
    }
}
