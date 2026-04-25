import SwiftUI

struct FavoritePlaceCard: View {
    let place: Place
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: PlacesService.shared.getPhotoURL(photoName: place.photos.first?.reference ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color("AppGreen").opacity(0.2))
            }
            .frame(width: 160, height: 120)
            .clipped()
            .cornerRadius(5)
            
            Text(place.name)
                .font(.custom("FiraGO-Medium", size: 13))
                .foregroundColor(Color("AppBlack"))
                .lineLimit(1)
            
            Text(place.address)
                .font(.custom("FiraGO-Regular", size: 11))
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption2)
                Text(String(format: "%.1f", place.rating))
                    .font(.custom("FiraGO-Regular", size: 11))
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 160)
        .padding(10)
        .background(Color("AppWhite"))
        .cornerRadius(8)
    }
}
