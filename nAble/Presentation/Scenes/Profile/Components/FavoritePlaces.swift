import SwiftUI

struct FavoritePlaces: View {
    let places: [Place]
    let onDelete: (Place) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Favorite Places")
                .font(.custom("FiraGO-Medium", size: 14))
                .foregroundColor(Color("AppBlack"))
                .padding(.horizontal)
            
            if places.isEmpty {
                Text("No saved places yet")
                    .font(.custom("FiraGO-Regular", size: 13))
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(places, id: \.id) { place in
                            FavoritePlaceCard(place: place, onDelete: { onDelete(place)
                            })
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
