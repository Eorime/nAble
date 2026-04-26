import SwiftUI

struct PlacesView: View {
    @ObservedObject var viewModel: PlacesViewModel
    var placesHeader = PlacesHeader()

    var body: some View {
        ScrollView {
            placesHeader
            LazyVStack(spacing: 16) {
                ForEach(viewModel.places, id: \.id) { place in
                    PlaceCard(
                        place: place,
                        initialIsSaved: viewModel.savedPlaceIds.contains(place.id),
                        isLoggedIn: !viewModel.userId.isEmpty,
                        onSave: { place in
                            viewModel.toggleSavePlace(place: place)
                        }
                    )
                    .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 16)
        }
        .background(Color("AppBG"))
        .onAppear {
            viewModel.loadInitialPlaces()
            viewModel.startLocationMonitoring()
        }
        .onDisappear {
            viewModel.stopLocationMonitoring()
            LoaderManager.shared.reset() 
        }
        .onChange(of: viewModel.isLoading) { isLoading in
            if isLoading {
                LoaderManager.shared.show()
            } else {
                LoaderManager.shared.hide()
            }
        }
    }
}
