import Foundation
import Observation

enum ForecastView: String, CaseIterable {
    case daily, hourly
}

enum ForecastState<T> {
    case idle
    case loading
    case loaded(T)
    case error(String)
}

@Observable
final class AppViewModel {
    // Location
    var selectedLocation: ShweatherLocation? {
        didSet { persistLastLocation(); loadForecast() }
    }
    var recentLocations: [ShweatherLocation] = [] {
        didSet { persistRecentLocations() }
    }

    // Search
    var searchText: String = ""
    var searchResults: [PlacePrediction] = []
    var isSearching: Bool = false

    // Forecast
    var forecastViewType: ForecastView = .daily {
        didSet {
            UserDefaults.standard.set(forecastViewType.rawValue, forKey: "forecastView")
            loadForecast()
        }
    }
    var dailyState: ForecastState<[DailyForecastDay]> = .idle
    var hourlyState: ForecastState<[HourlyForecastHour]> = .idle

    private var searchTask: Task<Void, Never>?

    init() {
        loadPersistedData()
    }

    // MARK: - Search

    func updateSearch(_ text: String) {
        searchText = text
        searchTask?.cancel()
        guard !text.isEmpty else { searchResults = []; return }
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            do {
                let results = try await PlacesService.shared.autocomplete(query: text)
                await MainActor.run { self.searchResults = results }
            } catch {}
        }
    }

    func selectPlace(_ prediction: PlacePrediction) {
        searchText = ""
        searchResults = []
        Task {
            do {
                let location = try await PlacesService.shared.fetchDetails(placeId: prediction.place_id)
                await MainActor.run {
                    self.selectedLocation = location
                    self.addToRecents(location)
                }
            } catch {}
        }
    }

    func selectRecentLocation(_ location: ShweatherLocation) {
        selectedLocation = location
        addToRecents(location)
    }

    private func addToRecents(_ location: ShweatherLocation) {
        var recents = recentLocations.filter { $0.id != location.id }
        recents.insert(location, at: 0)
        if recents.count > 15 { recents = Array(recents.prefix(15)) }
        recentLocations = recents
    }

    // MARK: - Forecast Loading

    func loadForecast() {
        guard let loc = selectedLocation else { return }
        switch forecastViewType {
        case .daily: loadDaily(lat: loc.latitude, lng: loc.longitude)
        case .hourly: loadHourly(lat: loc.latitude, lng: loc.longitude)
        }
    }

    private func loadDaily(lat: Double, lng: Double) {
        dailyState = .loading
        Task {
            do {
                let response = try await WeatherService.shared.fetchDailyForecast(lat: lat, lng: lng)
                await MainActor.run { self.dailyState = .loaded(response.days) }
            } catch {
                await MainActor.run { self.dailyState = .error(error.localizedDescription) }
            }
        }
    }

    private func loadHourly(lat: Double, lng: Double) {
        hourlyState = .loading
        Task {
            do {
                let response = try await WeatherService.shared.fetchHourlyForecast(lat: lat, lng: lng)
                await MainActor.run { self.hourlyState = .loaded(response.hours) }
            } catch {
                await MainActor.run { self.hourlyState = .error(error.localizedDescription) }
            }
        }
    }

    // MARK: - Persistence

    private func loadPersistedData() {
        if let raw = UserDefaults.standard.string(forKey: "forecastView"),
           let view = ForecastView(rawValue: raw) {
            forecastViewType = view
        }
        if let data = UserDefaults.standard.data(forKey: "recentLocations"),
           let locations = try? JSONDecoder().decode([ShweatherLocation].self, from: data) {
            recentLocations = locations
        }
        if let data = UserDefaults.standard.data(forKey: "lastLocation"),
           let location = try? JSONDecoder().decode(ShweatherLocation.self, from: data) {
            // Set without triggering didSet persistence cycle
            _selectedLocation = location
        }
    }

    private func persistLastLocation() {
        if let loc = selectedLocation,
           let data = try? JSONEncoder().encode(loc) {
            UserDefaults.standard.set(data, forKey: "lastLocation")
        }
    }

    private func persistRecentLocations() {
        if let data = try? JSONEncoder().encode(recentLocations) {
            UserDefaults.standard.set(data, forKey: "recentLocations")
        }
    }
}
