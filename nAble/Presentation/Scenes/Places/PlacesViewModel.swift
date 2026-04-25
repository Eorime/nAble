import Foundation
import Combine
internal import _LocationEssentials

class PlacesViewModel: ObservableObject {
    //MARK: Properties
    @Published var places: [Place] = []
    @Published var savedPlaces: [Place] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private let locationService: LocationServiceProtocol
    private let fetchNearbyPlaces: FetchNearbyPlacesUseCase
    private let savePlaceUseCase: SavePlaceUseCase
    private let removeSavedPlaceUseCase: RemoveSavedPlaceUseCase
    private let fetchSavedPlacesUseCase: FetchSavedPlacesUseCase
    
    private var userId: String
    var savedPlaceIds: Set<String> {
        Set(savedPlaces.map { $0.id })
    }
    
    init(
        userId: String,
        locationService: LocationServiceProtocol = LocationService(),
        fetchNearbyPlaces: FetchNearbyPlacesUseCase = FetchNearbyPlacesUseCase(),
        savePlaceUseCase: SavePlaceUseCase = SavePlaceUseCase(),
        removeSavedPlaceUseCase: RemoveSavedPlaceUseCase = RemoveSavedPlaceUseCase(),
        fetchSavedPlacesUseCase: FetchSavedPlacesUseCase = FetchSavedPlacesUseCase()
    ) {
        self.locationService = locationService
        self.fetchNearbyPlaces = fetchNearbyPlaces
        self.savePlaceUseCase = savePlaceUseCase
        self.removeSavedPlaceUseCase = removeSavedPlaceUseCase
        self.fetchSavedPlacesUseCase = fetchSavedPlacesUseCase
        self.userId = userId
    }
    
    func startLocationMonitoring() {
        locationService.startMonitoringLocation { [weak self] coordinate in
            DispatchQueue.main.async {
                self?.loadNearbyPlaces(coordinate: coordinate)
            }
        }
    }

    func stopLocationMonitoring() {
        locationService.stopMonitoringLocation()
    }
    
    private func loadNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        isLoading = true
        Task {
            do {
                let places = try await fetchNearbyPlaces.execute(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
                await MainActor.run {
                    self.places = places
                    self.isLoading = false
                }
            } catch {
                print("Places error: \(error)")
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    func loadInitialPlaces() {
        locationService.getCurrentLocation { [weak self] result in
            switch result {
            case .success(let coordinate):
                DispatchQueue.main.async {
                    self?.loadNearbyPlaces(coordinate: coordinate)
                    self?.loadSavedPlaces() 
                }
            case .failure(let error):
                print("Location error: \(error)")
            }
        }
    }
    
    func toggleSavePlace(place: Place) {
        if savedPlaceIds.contains(place.id) {
            removeSavedPlace(placeId: place.id)
        } else {
            savePlace(place: place)
        }
    }
    
    private func savePlace(place: Place) {
        Task {
            do {
                try await savePlaceUseCase.execute(userId: userId, place: place)
                await MainActor.run {
                    if !savedPlaces.contains(where: { $0.id == place.id }) {
                        self.savedPlaces.append(place)
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
    
    private func removeSavedPlace(placeId: String) {
        Task {
            do {
                try await removeSavedPlaceUseCase.execute(userId: userId, placeId: placeId)
                await MainActor.run {
                    self.savedPlaces.removeAll { $0.id == placeId }
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
    
    func loadSavedPlaces() {
        Task {
            do {
                let places = try await fetchSavedPlacesUseCase.execute(userId: userId)
                await MainActor.run {
                    self.savedPlaces = places
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
}
