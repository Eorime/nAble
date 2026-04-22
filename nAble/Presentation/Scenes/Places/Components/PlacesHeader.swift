import SwiftUI

struct PlacesHeader: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "figure.roll")
                .foregroundStyle(Color("AppBlack"))
                .font(.system(size: 22))
            VStack(alignment: .leading, spacing: 4) {
                Text("Accessible Places")
                    .foregroundStyle(Color("AppBlack"))
                    .font(.custom("FiraGO-Medium", size: 24))
                Text("Wheelchair friendly spots near you")
                    .foregroundStyle(Color("AppBlack").opacity(0.5))
                    .font(.custom("FiraGO-Regular", size: 14))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 10)
    }
}
