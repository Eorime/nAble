import SwiftUI

struct PlacesView: View {
    @ObservedObject var viewModel: PlacesViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.places, id: \.id) { place in
                    PlaceCard(place: place, onSave: { place in
                        viewModel.savePlace(userId: "CURRENT_USER_ID", place: place)
                    })
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
