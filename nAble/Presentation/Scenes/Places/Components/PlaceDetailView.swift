import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let place: Place

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                CachedAsyncImage(url: PlacesService.shared.getPhotoURL(photoName: place.photos.first?.reference ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color("AppGreen").opacity(0.2))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .clipped()

                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(place.name)
                            .font(.custom("FiraGO-SemiBold", size: 22))
                            .foregroundColor(Color("AppBlack"))

                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                            Text(String(format: "%.1f", place.rating))
                                .font(.custom("FiraGO-Regular", size: 14))
                                .foregroundColor(.secondary)
                        }

                        Text(place.address)
                            .font(.custom("FiraGO-Regular", size: 14))
                            .foregroundColor(Color("AppGray"))
                    }

                    if place.accessibilityOptions.hasWheelchairEntrance ||
                       place.accessibilityOptions.hasWheelchairRestroom ||
                       place.accessibilityOptions.hasWheelchairParking ||
                       place.accessibilityOptions.hasWheelchairSeating {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Accessibility")
                                .font(.custom("FiraGO-SemiBold", size: 16))
                                .foregroundColor(Color("AppBlack"))

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
                    }

                    VStack(spacing: 10) {
                        Button {
                            openInAppleMaps()
                        } label: {
                            HStack {
                                Image(systemName: "map.fill")
                                Text("Open in Apple Maps")
                                    .font(.custom("FiraGO-Medium", size: 15))
                            }
                            .foregroundColor(Color("AppWhite"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color("AppGreen"))
                            .cornerRadius(8)
                        }

                        Button {
                            openInGoogleMaps()
                        } label: {
                            HStack {
                                Image(systemName: "map")
                                Text("Open in Google Maps")
                                    .font(.custom("FiraGO-Medium", size: 15))
                            }
                            .foregroundColor(Color("AppGreen"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color("AppGreen").opacity(0.1))
                            .cornerRadius(8)
                        }
                    }

                    if !place.reviews.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Reviews")
                                .font(.custom("FiraGO-SemiBold", size: 16))
                                .foregroundColor(Color("AppBlack"))

                            ScrollView {
                                LazyVStack(spacing: 10) {
                                    ForEach(place.reviews, id: \.authorName) { review in
                                        ReviewCard(review: review)
                                    }
                                }
                            }
                            .frame(maxHeight: 250)
                        }
                    }
                }
                .padding(16)
            }
        }
    }

    private func openInAppleMaps() {
        let coordinate = CLLocationCoordinate2D(
            latitude: place.location.latitude,
            longitude: place.location.longitude
        )
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = place.name
        mapItem.openInMaps()
    }

    private func openInGoogleMaps() {
        let lat = place.location.latitude
        let lng = place.location.longitude
        if let url = URL(string: "comgooglemaps://?q=\(lat),\(lng)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: "https://www.google.com/maps?q=\(lat),\(lng)") {
            UIApplication.shared.open(url)
        }
    }
}
