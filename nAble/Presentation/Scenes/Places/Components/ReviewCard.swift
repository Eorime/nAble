import SwiftUI

struct ReviewCard: View {
    let review: Place.Review

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                if let photoUrl = review.authorPhotoUrl, let url = URL(string: photoUrl) {
                    CachedAsyncImage(url: url) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle().fill(Color("AppGreen").opacity(0.2))
                    }
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color("AppGreen").opacity(0.4))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(review.authorName)
                        .font(.custom("FiraGO-Medium", size: 13))
                        .foregroundColor(Color("AppBlack"))
                    Text(review.relativeTime)
                        .font(.custom("FiraGO-Regular", size: 11))
                        .foregroundColor(.secondary)
                }

                Spacer()

                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption2)
                    Text("\(review.rating)")
                        .font(.custom("FiraGO-Regular", size: 12))
                        .foregroundColor(.secondary)
                }
            }

            Text(review.text)
                .font(.custom("FiraGO-Regular", size: 13))
                .foregroundColor(Color("AppBlack"))
                .lineLimit(4)
        }
        .padding(12)
        .background(Color("AppWhite"))
        .cornerRadius(8)
    }
}
