import SwiftUI

struct PlaceCard: View {
    let place: Place
    let onSave: (Place) -> Void
    let initialIsSaved: Bool
    let isLoggedIn: Bool
    @State private var isSaved: Bool
    @State private var showDetail = false

    init(place: Place, initialIsSaved: Bool = false, isLoggedIn: Bool = false, onSave: @escaping (Place) -> Void) {
        self.place = place
        self.onSave = onSave
        self.initialIsSaved = initialIsSaved
        self.isLoggedIn = isLoggedIn
        self._isSaved = State(initialValue: initialIsSaved)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CachedAsyncImage(url: PlacesService.shared.getPhotoURL(photoName: place.photos.first?.reference ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color("AppGreen").opacity(0.2))
            }
            .frame(height: 180)
            .clipped()

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(place.name)
                        .font(.custom("FiraGO-Regular", size: 18))
                        .foregroundColor(Color("AppBlack"))
                        .lineLimit(1)

                    Spacer()

                    if isLoggedIn {
                        
                    Button {
                        isSaved.toggle()
                        onSave(place)
                    } label: {
                        Image(systemName: isSaved ? "heart.fill" : "heart")
                            .foregroundColor(isSaved ? Color("AppRed") : Color("AppGray"))
                        }
                    }
                }

                Text(place.address)
                    .font(.custom("FiraGO-Regular", size: 14))
                    .foregroundColor(Color("AppGray").opacity(0.5))
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", place.rating))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 8) {
                    if place.accessibilityOptions.hasWheelchairEntrance {
                        AccessibilityBadge(icon: "figure.roll", label: "Entrance")
                    }
                    if place.accessibilityOptions.hasWheelchairRestroom {
                        AccessibilityBadge(icon: "toilet", label: "Restroom")
                    }
                    if place.accessibilityOptions.hasWheelchairParking {
                        AccessibilityBadge(icon: "car", label: "Parking")
                    }
                    if place.accessibilityOptions.hasWheelchairSeating {
                        AccessibilityBadge(icon: "chair", label: "Seating")
                    }
                }
            }
            .padding(10)
        }
        .background(Color("AppWhite"))
        .cornerRadius(8)
        .onTapGesture {
            showDetail = true
        }
        .sheet(isPresented: $showDetail) {
            PlaceDetailView(place: place)
                .presentationBackground(Color("AppBG"))
                .presentationDetents([.large])
        }
        .onChange(of: initialIsSaved) { newValue in
            isSaved = newValue
        }
    }
}
