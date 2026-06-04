import Foundation

struct ShweatherLocation: Codable, Identifiable, Equatable {
    let id: String           // Google Place ID
    let friendlyName: String
    let latitude: Double
    let longitude: Double

    static func == (lhs: ShweatherLocation, rhs: ShweatherLocation) -> Bool {
        lhs.id == rhs.id
    }
}
