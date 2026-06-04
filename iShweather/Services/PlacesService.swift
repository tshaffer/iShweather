import Foundation

// Calls Google Places REST API directly.
// API key is fetched from the backend at startup so it never lives in the app binary.

enum PlacesServiceError: LocalizedError {
    case notConfigured
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .notConfigured: return "Places API key not yet loaded."
        case .invalidURL: return "Invalid request URL."
        case .networkError(let e): return e.localizedDescription
        case .decodingError(let e): return "Could not parse place data: \(e.localizedDescription)"
        case .apiError(let s): return s
        }
    }
}

final class PlacesService {
    static let shared = PlacesService()
    private let backendURL = "https://shweather-2a66bb6234aa.herokuapp.com"
    private var apiKey: String?

    private init() {}

    // Call once at startup — fetches the key from our backend proxy
    func loadAPIKey() async {
        guard let url = URL(string: "\(backendURL)/env-config.json") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: String] {
                apiKey = json["GOOGLE_MAPS_API_KEY"]
            }
        } catch {}
    }

    func autocomplete(query: String) async throws -> [PlacePrediction] {
        guard let key = apiKey else { throw PlacesServiceError.notConfigured }
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return [] }

        var components = URLComponents(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json")!
        components.queryItems = [
            URLQueryItem(name: "input", value: query),
            URLQueryItem(name: "key", value: key)
        ]
        guard let url = components.url else { throw PlacesServiceError.invalidURL }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PlaceAutocompleteResponse.self, from: data)
        return response.predictions
    }

    func fetchDetails(placeId: String) async throws -> ShweatherLocation {
        guard let key = apiKey else { throw PlacesServiceError.notConfigured }

        var components = URLComponents(string: "https://maps.googleapis.com/maps/api/place/details/json")!
        components.queryItems = [
            URLQueryItem(name: "place_id", value: placeId),
            URLQueryItem(name: "fields", value: "geometry,name,formatted_address"),
            URLQueryItem(name: "key", value: key)
        ]
        guard let url = components.url else { throw PlacesServiceError.invalidURL }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PlaceDetailsResponse.self, from: data)

        guard response.status == "OK" else {
            throw PlacesServiceError.apiError("Places API status: \(response.status)")
        }

        let geo = response.result.geometry.location
        let name = response.result.formatted_address ?? response.result.name
        return ShweatherLocation(id: placeId, friendlyName: name, latitude: geo.lat, longitude: geo.lng)
    }
}
