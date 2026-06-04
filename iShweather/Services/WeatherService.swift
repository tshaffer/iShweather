import Foundation

enum WeatherServiceError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid request URL."
        case .networkError(let e): return e.localizedDescription
        case .decodingError(let e): return "Could not parse weather data: \(e.localizedDescription)"
        }
    }
}

final class WeatherService {
    static let shared = WeatherService()
    private let baseURL = "https://shweather-2a66bb6234aa.herokuapp.com"
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        return d
    }()

    private init() {}

    func fetchDailyForecast(lat: Double, lng: Double) async throws -> DailyForecastResponse {
        let locationJSON = "{\"lat\":\(lat),\"lng\":\(lng)}"
        var components = URLComponents(string: "\(baseURL)/api/v1/dailyForecast")!
        components.queryItems = [
            URLQueryItem(name: "location", value: locationJSON)
        ]
        guard let url = components.url else { throw WeatherServiceError.invalidURL }
        return try await fetch(url: url)
    }

    func fetchHourlyForecast(lat: Double, lng: Double) async throws -> HourlyForecastResponse {
        let locationJSON = "{\"lat\":\(lat),\"lng\":\(lng)}"
        var components = URLComponents(string: "\(baseURL)/api/v1/hourlyForecast")!
        components.queryItems = [
            URLQueryItem(name: "location", value: locationJSON)
        ]
        guard let url = components.url else { throw WeatherServiceError.invalidURL }
        return try await fetch(url: url)
    }

    private func fetch<T: Decodable>(url: URL) async throws -> T {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw WeatherServiceError.decodingError(error)
            }
        } catch let error as WeatherServiceError {
            throw error
        } catch {
            throw WeatherServiceError.networkError(error)
        }
    }
}
