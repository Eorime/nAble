extension PlaceDTO {
    func toEntity() -> Place {
        Place(
            name: displayName?.text ?? "Unknown",
            address: formattedAddress ?? "No address",
            rating: rating ?? 0.0,
            accessibilityOptions: Place.AccessibilityOptions(
                hasWheelchairEntrance: accessibilityOptions?.wheelchairAccessibleEntrance ?? false,
                hasWheelchairRestroom: accessibilityOptions?.wheelchairAccessibleRestroom ?? false,
                hasWheelchairParking: accessibilityOptions?.wheelchairAccessibleParking ?? false,
                hasWheelchairSeating: accessibilityOptions?.wheelchairAccessibleSeating ?? false
            ),
            reviews: reviews?.map {
                Place.Review(
                    rating: $0.rating ?? 0,
                    text: $0.text?.text ?? "",
                    relativeTime: $0.relativePublishTimeDescription ?? "",
                    authorName: $0.authorAttribution?.displayName ?? "Anonymous",
                    authorPhotoUrl: $0.authorAttribution?.photoUri
                )
            } ?? [],
            photos: photos?.map {
                Place.Photo(
                    reference: $0.name ?? "",
                    width: $0.widthPx ?? 0,
                    height: $0.heightPx ?? 0
                )
            } ?? [],
            location: Place.Location(
                latitude: location?.latitude ?? 0.0,
                longitude: location?.longitude ?? 0.0
            )
        )
    }
}
