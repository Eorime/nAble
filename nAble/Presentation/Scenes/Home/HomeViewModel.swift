import SwiftUI
import MapKit
import Combine
import CoreLocation

class HomeViewModel: ObservableObject {
    // MARK: Published
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var locations: [UserLocationModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAddingLocation = false
    @Published var currentStep: AddLocationStep = .selectType
    @Published var selectedType: String?
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.7151, longitude: 44.8271),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))
    
    // MARK: Properties
    var profile: User?
    var isLoggedIn: Bool { profile != nil }
    
    // MARK: Use Cases
    private let getCurrentLocation: GetCurrentLocationUseCaseProtocol
    private let locationService: LocationServiceProtocol
    private let addLocationUseCase: AddLocationUseCaseProtocol
    private let getAllLocationsUseCase: GetAllLocationsUseCaseProtocol
    private let removeLocationUseCase: RemoveLocationUseCaseProtocol
    
    // MARK: Enums
    enum AddLocationStep {
        case selectType
        case markLocation
    }
    
    // MARK: Init
    init(
        getCurrentLocation: GetCurrentLocationUseCaseProtocol,
        locationService: LocationServiceProtocol,
        addLocationUseCase: AddLocationUseCaseProtocol,
        getAllLocationsUseCase: GetAllLocationsUseCaseProtocol,
        removeLocationUseCase: RemoveLocationUseCaseProtocol
    ) {
        self.getCurrentLocation = getCurrentLocation
        self.locationService = locationService
        self.addLocationUseCase = addLocationUseCase
        self.getAllLocationsUseCase = getAllLocationsUseCase
        self.removeLocationUseCase = removeLocationUseCase
    }
    
    // MARK: Location Tracking
    func requestLocation() {
        getCurrentLocation.execute { [weak self] result in
            switch result {
            case .success(let coordinate):
                DispatchQueue.main.async {
                    self?.userLocation = coordinate
                    self?.cameraPosition = .region(MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
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
    
    // MARK: Load Locations
    @MainActor
    func loadLocations() async {
        isLoading = true
        errorMessage = nil
        
        await withCheckedContinuation { continuation in
            getAllLocationsUseCase.execute { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let locations):
                        self?.locations = locations
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                    continuation.resume()
                }
            }
        }
    }
    
    // MARK: Add Location
    func startAddingLocation() {
        guard isLoggedIn else {
            errorMessage = "You must be logged in to add a location"
            return
        }
        isAddingLocation = true
        currentStep = .selectType
    }
    
    func cancelAddingLocation() {
        isAddingLocation = false
        currentStep = .selectType
        selectedType = nil
        selectedCoordinate = nil
    }
    
    func selectType(_ type: String) {
        selectedType = type
        currentStep = .markLocation
    }
    
    func handleMapTap(at coordinate: CLLocationCoordinate2D) {
        guard currentStep == .markLocation else { return }
        selectedCoordinate = coordinate
        addLocation()
    }
    
    func addLocation() {
        guard let userId = profile?.id,
              let username = profile?.userName,
              let coordinate = selectedCoordinate,
              let type = selectedType else {
            errorMessage = "Missing required information"
            return
        }
        
        let newLocation = UserLocationModel(
            id: UUID().uuidString,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            locationId: type,
            userId: userId,
            username: username,
            timeStamp: Date()
        )
        
        isLoading = true
        errorMessage = nil
        
        addLocationUseCase.execute(userId: userId, location: newLocation) { [weak self] result in
            Task { @MainActor in
                self?.isLoading = false
                switch result {
                case .success:
                    self?.cancelAddingLocation()
                    await self?.loadLocations()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: Remove Location
    func removeLocation(userId: String, locationId: String) {
        isLoading = true
        
        removeLocationUseCase.execute(userId: userId, locationId: locationId) { [weak self] result in
            Task { @MainActor in
                self?.isLoading = false
                switch result {
                case .success:
                    await self?.loadLocations()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
