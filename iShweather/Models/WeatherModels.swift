import Foundation

// MARK: - Shared

struct Temperature: Codable {
    let degrees: Double
    let unit: String

    var fahrenheit: Double {
        unit.uppercased().contains("CELSIUS") ? degrees * 9 / 5 + 32 : degrees
    }

    var displayString: String {
        "\(Int(fahrenheit.rounded()))°"
    }
}

struct WindInfo: Codable {
    struct Speed: Codable {
        let value: Double
        let unit: String

        var mph: Double {
            switch unit.uppercased() {
            case "KILOMETERS_PER_HOUR", "KMH": return value * 0.621371
            case "METERS_PER_SECOND", "M_S":   return value * 2.23694
            default:                            return value  // already mph
            }
        }

        var displayString: String { "\(Int(mph.rounded())) mph" }
    }
    struct Direction: Codable {
        let degrees: Double?
        let localizedDescription: String?
    }
    let speed: Speed
    let direction: Direction?
}

struct PrecipProbability: Codable {
    let type: String
    let percent: Double
}

struct Precipitation: Codable {
    struct Probability: Codable {
        let type: String
        let percent: Double
    }
    let probability: Probability?
}

// MARK: - Daily

struct DayPart: Codable {
    let weatherCondition: WeatherCondition?
    let precipitation: Precipitation?
    let wind: WindInfo?
    let relativeHumidity: Double?
    let uvIndex: Double?
    let thunderstormProbability: Double?
    let cloudCover: Double?
}

struct DisplayDate: Codable {
    let year: Int
    let month: Int
    let day: Int

    var date: Date? {
        var comps = DateComponents()
        comps.year = year; comps.month = month; comps.day = day
        return Calendar.current.date(from: comps)
    }
}

struct SunEvents: Codable {
    let sunriseTime: String?
    let sunsetTime: String?
    // backend key variant
    let sunrise: String?
    let sunset: String?

    var resolvedSunrise: String? { sunriseTime ?? sunrise }
    var resolvedSunset: String?  { sunsetTime  ?? sunset  }
}

struct DailyForecastDay: Codable, Identifiable {
    let displayDate: DisplayDate
    let maxTemperature: Temperature?
    let minTemperature: Temperature?
    let feelsLikeMaxTemperature: Temperature?
    let feelsLikeMinTemperature: Temperature?
    let daytimeForecast: DayPart?
    let nighttimeForecast: DayPart?
    let sunEvents: SunEvents?

    var id: String {
        "\(displayDate.year)-\(displayDate.month)-\(displayDate.day)"
    }
}

struct DailyForecastResponse: Codable {
    let days: [DailyForecastDay]
}

// MARK: - Hourly

struct DisplayDateTime: Codable {
    let year: Int
    let month: Int
    let day: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
    let utcOffset: String?
}

struct WeatherCondition: Codable {
    struct Description: Codable {
        let text: String
        let languageCode: String?
    }
    let description: Description
    let type: String
    let iconBaseUri: String?
}

struct HourlyForecastHour: Codable, Identifiable {
    let displayDateTime: DisplayDateTime
    let weatherCondition: WeatherCondition
    let temperature: Temperature
    let feelsLikeTemperature: Temperature
    let precipitation: Precipitation?
    let wind: WindInfo?
    let relativeHumidity: Double
    let uvIndex: Double
    let isDaytime: Bool
    let cloudCover: Double

    var id: String {
        let dt = displayDateTime
        return "\(dt.year)-\(dt.month)-\(dt.day)-\(dt.hours)-\(dt.minutes)"
    }
}

struct HourlyForecastResponse: Codable {
    let hours: [HourlyForecastHour]
}
