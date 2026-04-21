import SwiftUI

struct PlacesView: View {
    @StateObject var viewModel: PlacesViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(places, id: \.id) { place in
                    PlaceCard(place: place, onSave: onSave)
                }
            }
            .padding(.vertical, 8)
        }
//        .backgroundColor
        .onAppear {
            v
        }
    }
}
