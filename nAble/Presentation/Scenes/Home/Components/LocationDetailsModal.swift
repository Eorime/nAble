import SwiftUI

struct LocationDetailModal: View {
    let location: UserLocationModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let imageURL = location.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color("AppGreen").opacity(0.2))
                }
                .frame(maxWidth: .infinity)
                .frame(width: 280, height: 280)
                .clipped()
                .cornerRadius(8)
            }

            HStack(spacing: 8) {
                Image(location.locationId)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                Text(LocationType.displayName(for: location.locationId))
                    .font(.custom("FiraGO-Medium", size: 16))
                    .foregroundColor(Color("AppBlack"))
            }

            HStack(spacing: 6) {
                Image(systemName: "person.circle")
                    .foregroundColor(Color("AppGreen"))
                Text(location.username)
                    .font(.custom("FiraGO-Regular", size: 14))
                    .foregroundColor(Color("AppBlack"))
            }

            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .foregroundColor(Color("AppGreen"))
                Text(location.timeStamp.formatted(date: .long, time: .omitted))
                    .font(.custom("FiraGO-Regular", size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(Color("AppBG"))
        .cornerRadius(10)
        .frame(maxWidth: 340)
    }
}
