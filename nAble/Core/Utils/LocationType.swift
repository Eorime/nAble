enum LocationType {
        static let all: [(id: String, name: String)] = [
            ("friendly", "Friendly"),
            ("friendlyParking", "Friendly Parking"),
            ("friendlyWC", "Friendly WC"),
            ("mildElevation", "Mild Elevation"),
            ("mildRoad", "Mild Road"),
            ("railedStairs", "Railed Stairs"),
            ("roughElevation", "Rough Elevation"),
            ("roughRoad", "Rough Road"),
            ("stairs", "Stairs")
        ]
        
        static func displayName(for id: String) -> String {
            all.first { $0.id == id }?.name ?? id
        }
    }
