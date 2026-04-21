import UIKit
import _LocationEssentials

class PlacesViewModel {
    private let getCurrentLocation: GetCurrentLocationUseCaseProtocol
    private let fetchPlacesUseCase: FetchNearbyPlacesUseCase
    private let savePlaceUseCase: SavePlaceUseCase
    private let removeSavedPlaceUseCase: RemoveSavedPlaceUseCase
    private let fetchSavedPlacesUseCase: FetchSavedPlacesUseCase

    var onPlacesLoaded: (([Place]) -> Void)?
    var onSavedPlacesLoaded: (([Place]) -> Void)?
    var onError: ((Error) -> Void)?
    
    init(getCurrentLocation: GetCurrentLocationUseCaseProtocol, fetchPlacesUseCase: FetchNearbyPlacesUseCase, savePlaceUseCase: SavePlaceUseCase, removeSavedPlaceUseCase: RemoveSavedPlaceUseCase, fetchSavedPlacesUseCase: FetchSavedPlacesUseCase) {
        self.getCurrentLocation = getCurrentLocation
        self.fetchPlacesUseCase = fetchPlacesUseCase
        self.savePlaceUseCase = savePlaceUseCase
        self.removeSavedPlaceUseCase = removeSavedPlaceUseCase
        self.fetchSavedPlacesUseCase = fetchSavedPlacesUseCase
    }
    
    func loadNearbyPlaces() {
        getCurrentLocation.execute { [weak self] result in
            switch result {
            case .success(let coordinate):
                Task {
                    do {
                        let places = try await self?.fetchPlacesUseCase.execute(latitude: coordinate.latitude, longitude: coordinate.longitude)
                        DispatchQueue.main.async {
                            self?.onPlacesLoaded?(places ?? [])
                        }
                        } catch {
                            DispatchQueue.main.async {
                                self?.onError?(error)
                            }
                        }
                    }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?(error)
                }
            }
        }
    }
    
    func savePlace(userId: String, place: Place) {
        Task {
            do {
                try await savePlaceUseCase.execute(userId: userId, place: place)
            } catch {
                DispatchQueue.main.async {
                    self.onError?(error)
                }
            }
        }
    }
    
    func removeSavedPlace(userId: String, placeId: String) {
        Task {
            do {
                try await removeSavedPlaceUseCase.execute(userId: userId, placeId: placeId)
            } catch {
                DispatchQueue.main.async {
                    self.onError?(error)
                }
            }
        }
    }
    
    func loadSavedPlaces(userId: String) {
        Task {
            do {
                let places = try await fetchSavedPlacesUseCase.execute(userId: userId)
                DispatchQueue.main.async {
                    self.onSavedPlacesLoaded?(places)
                }
            } catch {
                DispatchQueue.main.async {
                    self.onError?(error)
                }
            }
        }
    }
    
}
