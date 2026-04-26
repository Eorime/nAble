import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var favoritePlaces: [Place] = []
    @Published var addedLocations: [UserLocationModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var profile: User?
    var username: String { profile?.userName ?? "" }
    var fullName: String { profile?.fullName ?? "" }
    var email: String { profile?.email ?? "" }
    var userAvatar: String { profile?.imageUrl ?? ""}
    var isLoggedIn: Bool { profile != nil }
    var coordinator: AppCoordinator?
    
    private let fetchFavoritePlaces: FetchSavedPlacesUseCase
    private let getLocationsUseCase: GetLocationsUseCaseProtocol
    private let logoutUseCase: LogoutUseCase
    private let deleteAccountUseCase: DeleteAccountUseCase
    private let updateFullNameUseCase: UpdateFullNameUseCase
    private let updateUsernameUseCase: UpdateUsernameUseCase
    private let removeLocationUseCase: RemoveLocationUseCaseProtocol
    private let removeSavedPlaceUseCase: RemoveSavedPlaceUseCase
    private let updateAvatarUseCase: UpdateAvatarUseCase
    
    init(
        profile: User?,
        fetchSavedPlacesUseCase: FetchSavedPlacesUseCase,
        getLocationsUseCase: GetLocationsUseCaseProtocol,
        logoutUseCase: LogoutUseCase,
        deleteAccountUseCase: DeleteAccountUseCase,
        updateFullNameUseCase: UpdateFullNameUseCase,
        updateUsernameUseCase: UpdateUsernameUseCase,
        removeLocationUseCase: RemoveLocationUseCaseProtocol,
        removeSavedPlaceUseCase: RemoveSavedPlaceUseCase,
        updateAvatarUseCase: UpdateAvatarUseCase
    ) {
        self.profile = profile
        self.fetchFavoritePlaces = fetchSavedPlacesUseCase
        self.getLocationsUseCase = getLocationsUseCase
        self.logoutUseCase = logoutUseCase
        self.deleteAccountUseCase = deleteAccountUseCase
        self.updateFullNameUseCase = updateFullNameUseCase
        self.updateUsernameUseCase = updateUsernameUseCase
        self.removeLocationUseCase = removeLocationUseCase
        self.removeSavedPlaceUseCase = removeSavedPlaceUseCase
        self.updateAvatarUseCase = updateAvatarUseCase
    }
    
    @MainActor
    private func loadFavorites(userId: String) async {
        do {
            favoritePlaces = try await fetchFavoritePlaces.execute(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    private func loadAddedLocations(userId: String) async {
        do {
            addedLocations = try await getLocationsUseCase.execute(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadData() {
        guard let userId = profile?.id else { return }
        Task {
            await loadFavorites(userId: userId)
            await loadAddedLocations(userId: userId)
        }
    }
    
    func logOut() {
        logoutUseCase.execute { [weak self] result in
            switch result {
            case .success:
                self?.coordinator?.showAuth()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteAccount(password: String) {
        deleteAccountUseCase.execute(password: password) { [weak self] result in
            switch result {
            case .success:
                self?.coordinator?.showAuth()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func updateFullName(_ fullName: String) {
        guard let userId = profile?.id else { return }
        updateFullNameUseCase.execute(userId: userId, fullName: fullName) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.profile?.fullName = fullName
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func updateUsername(_ username: String) {
        guard let userId = profile?.id else { return }
        updateUsernameUseCase.execute(userId: userId, username: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.profile?.userName = username
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func updateAvatar(_ image: UIImage) {
        guard let userId = profile?.id else { return }
        updateAvatarUseCase.execute(userId: userId, image: image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    self?.profile?.imageUrl = url
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteLocation(_ location: UserLocationModel) {
        guard let userId = profile?.id else { return }
        removeLocationUseCase.execute(userId: userId, locationId: location.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.addedLocations.removeAll { $0.id == location.id}
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
            
        }
    }
    
    func deleteFavoritePlace(_ place: Place) {
        guard let userId = profile?.id else { return }
        Task {
            do {
                try await removeSavedPlaceUseCase.execute(userId: userId, placeId: place.id)
                await MainActor.run {
                    self.favoritePlaces.removeAll { $0.id == place.id }
                }
            }
        }
    }
}
