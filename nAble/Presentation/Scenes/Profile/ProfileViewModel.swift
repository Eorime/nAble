import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var favoritePlaces: [Place] = []
    @Published var addedLocations: [UserLocationModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var profile: User?
    var username: String { profile?.userName ?? "" }
    var email: String { profile?.email ?? "" }
    var isLoggedIn: Bool { profile != nil }
    var coordinator: AppCoordinator?
    
    private let fetchFavoritePlaces: FetchSavedPlacesUseCase
    private let getLocationsUseCase: GetLocationsUseCaseProtocol
    private let logoutUseCase: LogoutUseCase
    private let deleteAccountUseCase: DeleteAccountUseCase
    
    init(
           profile: User?,
           fetchSavedPlacesUseCase: FetchSavedPlacesUseCase,
           getLocationsUseCase: GetLocationsUseCaseProtocol
       ) {
           self.profile = profile
           self.fetchFavoritePlaces = fetchSavedPlacesUseCase
           self.getLocationsUseCase = getLocationsUseCase
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
}
