struct ReviewDTO: Codable {
    let name: String?
    let rating: Int?
    let text: LocalizedTextDTO?
    let originalText: LocalizedTextDTO?
    let relativePublishTimeDescription: String?
    let publishTime: String?
    let authorAttribution: AuthorAttributionDTO?
    let flagContentUri: String?
    let googleMapsUri: String?
}
