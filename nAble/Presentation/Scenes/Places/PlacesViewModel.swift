import UIKit
import _LocationEssentials

class PlacesViewModel {
    private let getCurrentLocation: GetCurrentLocationUseCaseProtocol
    private let fetchPlacesUseCase: FetchNearbyPlacesUseCase
    private let savePlaceUseCase: SavePlaceUseCase
    private let removeSavedPlaceUseCase: RemoveSavedPlaceUseCase

    var onPlacesLoaded: (([Place]) -> Void)?
    var onSavedPlacesLoaded: (([Place]) -> Void)?
    var onError: ((Error) -> Void)?
    
    init(getCurrentLocation: GetCurrentLocationUseCaseProtocol, fetchPlacesUseCase: FetchNearbyPlacesUseCase, savePlaceUseCase: SavePlaceUseCase, removeSavedPlaceUseCase: RemoveSavedPlaceUseCase) {
        self.getCurrentLocation = getCurrentLocation
        self.fetchPlacesUseCase = fetchPlacesUseCase
        self.savePlaceUseCase = savePlaceUseCase
        self.removeSavedPlaceUseCase = removeSavedPlaceUseCase
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
}
