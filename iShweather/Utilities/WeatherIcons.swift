import SwiftUI

func sfSymbol(for conditionType: String) -> String {
    switch conditionType {
    case "CLEAR":                       return "sun.max.fill"
    case "MOSTLY_CLEAR":                return "sun.min.fill"
    case "PARTLY_CLOUDY":               return "cloud.sun.fill"
    case "MOSTLY_CLOUDY":               return "cloud.sun.fill"   // sun still peeking
    case "CLOUDY":                      return "cloud.fill"
    case "WINDY":                       return "wind"
    case "WIND_AND_RAIN":               return "wind"
    case "LIGHT_RAIN_SHOWERS",
         "CHANCE_OF_SHOWERS",
         "SCATTERED_SHOWERS",
         "RAIN_SHOWERS":               return "cloud.drizzle.fill"
    case "HEAVY_RAIN_SHOWERS",
         "MODERATE_TO_HEAVY_RAIN",
         "RAIN",
         "HEAVY_RAIN",
         "RAIN_PERIODICALLY_HEAVY":    return "cloud.heavyrain.fill"
    case "LIGHT_TO_MODERATE_RAIN",
         "LIGHT_RAIN":                 return "cloud.rain.fill"
    case "LIGHT_SNOW_SHOWERS",
         "CHANCE_OF_SNOW_SHOWERS",
         "SCATTERED_SNOW_SHOWERS",
         "SNOW_SHOWERS":              return "cloud.snow.fill"
    case "LIGHT_TO_MODERATE_SNOW",
         "LIGHT_SNOW",
         "SNOW",
         "MODERATE_TO_HEAVY_SNOW",
         "HEAVY_SNOW",
         "SNOW_PERIODICALLY_HEAVY",
         "HEAVY_SNOW_STORM",
         "SNOWSTORM":                 return "snowflake"
    case "BLOWING_SNOW":               return "wind.snow"
    case "RAIN_AND_SNOW":              return "cloud.sleet.fill"
    case "HAIL", "HAIL_SHOWERS":       return "cloud.hail.fill"
    case "THUNDERSTORM",
         "THUNDERSHOWER",
         "LIGHT_THUNDERSTORM_RAIN",
         "SCATTERED_THUNDERSTORMS",
         "HEAVY_THUNDERSTORM":        return "cloud.bolt.rain.fill"
    default:                           return "cloud.fill"
    }
}

// Returns a color to pair with the SF Symbol via .foregroundStyle()
func iconColor(for conditionType: String) -> Color {
    switch conditionType {
    case "CLEAR", "MOSTLY_CLEAR":       return .yellow
    case "PARTLY_CLOUDY",
         "MOSTLY_CLOUDY":               return .orange
    case "CLOUDY":                      return .gray
    case "WINDY", "WIND_AND_RAIN",
         "BLOWING_SNOW":               return .gray
    case "LIGHT_RAIN_SHOWERS",
         "CHANCE_OF_SHOWERS",
         "SCATTERED_SHOWERS",
         "RAIN_SHOWERS",
         "LIGHT_TO_MODERATE_RAIN",
         "LIGHT_RAIN",
         "MODERATE_TO_HEAVY_RAIN",
         "HEAVY_RAIN_SHOWERS",
         "RAIN", "HEAVY_RAIN",
         "RAIN_PERIODICALLY_HEAVY":    return .blue
    case "LIGHT_SNOW_SHOWERS",
         "CHANCE_OF_SNOW_SHOWERS",
         "SCATTERED_SNOW_SHOWERS",
         "SNOW_SHOWERS",
         "LIGHT_TO_MODERATE_SNOW",
         "LIGHT_SNOW", "SNOW",
         "MODERATE_TO_HEAVY_SNOW",
         "HEAVY_SNOW", "SNOWSTORM",
         "SNOW_PERIODICALLY_HEAVY",
         "HEAVY_SNOW_STORM",
         "BLOWING_SNOW", "RAIN_AND_SNOW": return .cyan
    case "HAIL", "HAIL_SHOWERS":       return .teal
    case "THUNDERSTORM",
         "THUNDERSHOWER",
         "LIGHT_THUNDERSTORM_RAIN",
         "SCATTERED_THUNDERSTORMS",
         "HEAVY_THUNDERSTORM":        return .indigo
    default:                           return .gray
    }
}
