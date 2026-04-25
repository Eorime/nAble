//
//  UserLocationCard.swift
//  nAble
//
//  Created by Eorime on 25.04.26.
//


import SwiftUI

struct UserLocationCard: View {
    let location: UserLocationModel

    var body: some View {
        HStack(spacing: 12) {
            if let imageURL = location.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color("AppGreen").opacity(0.2))
                }
                .frame(width: 64, height: 64)
                .clipped()
                .cornerRadius(8)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("AppGreen").opacity(0.2))
                    .frame(width: 64, height: 64)
                    .overlay(
                        Image(systemName: "mappin.circle")
                            .foregroundColor(Color("AppGreen"))
                            .font(.title2)
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(location.locationId)
                    .font(.custom("FiraGO-Medium", size: 14))
                    .foregroundColor(Color("AppBlack"))
                    .lineLimit(1)

                Text(String(format: "%.4f, %.4f", location.latitude, location.longitude))
                    .font(.custom("FiraGO-Regular", size: 12))
                    .foregroundColor(.secondary)

                Text(location.timeStamp.formatted(date: .abbreviated, time: .omitted))
                    .font(.custom("FiraGO-Regular", size: 11))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(10)
        .background(Color("AppWhite"))
        .cornerRadius(8)
    }
}
