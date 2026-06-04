import Foundation

struct PlaceAutocompleteResponse: Codable {
    let predictions: [PlacePrediction]
}

struct PlacePrediction: Codable, Identifiable {
    let place_id: String
    let description: String

    var id: String { place_id }
}

struct PlaceDetailsResponse: Codable {
    let result: PlaceDetailsResult
    let status: String
}

struct PlaceDetailsResult: Codable {
    let geometry: PlaceGeometry
    let name: String
    let formatted_address: String?
}

struct PlaceGeometry: Codable {
    let location: LatLng
}

struct LatLng: Codable {
    let lat: Double
    let lng: Double
}
