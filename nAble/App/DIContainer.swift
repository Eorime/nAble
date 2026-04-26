import Foundation

class AppDIContainer {
    //MARK: Core
    let locationService: LocationServiceProtocol
    
    //MARK: Repositories
    let locationRepository: LocationRepositoryProtocol
    let authRepository: FirebaseAuthRepository
    let userRepository: UserRepositoryProtocol
    let imageRepository: ImageRepositoryProtocol
    let placesRepository: PlacesRepositoryProtocol
    
    //MARK: Location use cases
    lazy var addLocationUseCase: AddLocationUseCaseProtocol = AddLocationUseCase(repository: locationRepository)
    lazy var removeLocationUseCase: RemoveLocationUseCaseProtocol = RemoveLocationUseCase(repository: locationRepository)
    lazy var getAllLocationsUseCase: GetAllLocationsUseCaseProtocol = GetAllLocationsUseCase(repository: locationRepository)
    lazy var getLocationsUseCase: GetLocationsUseCaseProtocol = GetLocationsUseCase(repository: locationRepository)
    lazy var getCurrentLocationUseCase: GetCurrentLocationUseCaseProtocol = GetCurrentLocationUseCase(locationService: locationService)
    
    //MARK: Place use cases
    lazy var fetchSavedPlacesUseCase: FetchSavedPlacesUseCase = FetchSavedPlacesUseCase()
    lazy var removeSavedPlaceUseCase: RemoveSavedPlaceUseCase = RemoveSavedPlaceUseCase()
    lazy var fetchNearbyPlacesUseCase: FetchNearbyPlacesUseCase = FetchNearbyPlacesUseCase()
    lazy var savePlaceUseCase: SavePlaceUseCase = SavePlaceUseCase()
    
    //MARK: Auth use cases
    lazy var logoutUseCase: LogoutUseCase = LogoutUseCase(authRepo: authRepository)
    lazy var deleteAccountUseCase: DeleteAccountUseCase = DeleteAccountUseCase(authRepo: authRepository)
    
    //MARK: User use cases
    lazy var updateFullNameUseCase: UpdateFullNameUseCase = UpdateFullNameUseCase(userRepository: userRepository as! UserRepository)
    lazy var updateUsernameUseCase: UpdateUsernameUseCase = UpdateUsernameUseCase(userRepository: userRepository as! UserRepository)
    lazy var updateAvatarUseCase: UpdateAvatarUseCase = UpdateAvatarUseCase(imageRepository: imageRepository, userRepository: userRepository)
    
    init() {
        self.locationService = LocationService()
        self.locationRepository = LocationRepository()
        self.authRepository = FirebaseAuthRepository()
        self.userRepository = UserRepository()
        self.imageRepository = ImageRepository()
        self.placesRepository = PlacesRepository()
    }
}
