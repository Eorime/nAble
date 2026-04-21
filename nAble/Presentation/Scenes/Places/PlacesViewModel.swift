import Foundation
import Combine
internal import _LocationEssentials

class PlacesViewModel: ObservableObject {
    //MARK: Properties
    @Published var places: [Place] = []
    @Published var savedPlaces: [Place] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private let getCurrentLocation: GetCurrentLocationUseCaseProtocol
    private let fetchNearbyPlaces: FetchNearbyPlacesUseCase
    private let savePlaceUseCase: SavePlaceUseCase
    private let removeSavedPlaceUseCase: RemoveSavedPlaceUseCase
    private let fetchSavedPlacesUseCase: FetchSavedPlacesUseCase
    
    init(
        getCurrentLocation: GetCurrentLocationUseCaseProtocol,
        fetchNearbyPlaces: FetchNearbyPlacesUseCase = FetchNearbyPlacesUseCase(),
        savePlaceUseCase: SavePlaceUseCase = SavePlaceUseCase(),
        removeSavedPlaceUseCase: RemoveSavedPlaceUseCase = RemoveSavedPlaceUseCase(),
        fetchSavedPlacesUseCase: FetchSavedPlacesUseCase = FetchSavedPlacesUseCase()
    ) {
        self.getCurrentLocation = getCurrentLocation
        self.fetchNearbyPlaces = fetchNearbyPlaces
        self.savePlaceUseCase = savePlaceUseCase
        self.removeSavedPlaceUseCase = removeSavedPlaceUseCase
        self.fetchSavedPlacesUseCase = fetchSavedPlacesUseCase
    }
    
    func loadNearbyPlaces() {
        isLoading = true
        getCurrentLocation.execute { [weak self] result in
            switch result {
            case .success(let coordinate):
                Task {
                    do {
                        let places = try await self?.fetchNearbyPlaces.execute(
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude
                        )
                        await MainActor.run {
                            self?.places = places ?? []
                            self?.isLoading = false
                        }
                    } catch {
                        await MainActor.run {
                            self?.error = error
                            self?.isLoading = false
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                    self?.isLoading = false
                }
            }
        }
    }
    
    func savePlace(userId: String, place: Place) {
        Task {
            do {
                try await savePlaceUseCase.execute(userId: userId, place: place)
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
    
    func removeSavedPlace(userId: String, placeId: String) {
        Task {
            do {
                try await removeSavedPlaceUseCase.execute(userId: userId, placeId: placeId)
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
    
    func loadSavedPlaces(userId: String) {
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
