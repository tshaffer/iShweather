import SwiftUI

struct DailyForecastDetailView: View {
    let day: DailyForecastDay

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                detailCell(
                    icon: "humidity.fill",
                    label: "Humidity",
                    value: humidityText,
                    color: .blue
                )
                Divider().frame(height: 44)
                detailCell(
                    icon: "sun.max.fill",
                    label: "UV Index",
                    value: uvText,
                    color: .orange
                )
                Divider().frame(height: 44)
                detailCell(
                    icon: "sunrise.fill",
                    label: "Sunrise",
                    value: sunriseText,
                    color: .yellow
                )
                Divider().frame(height: 44)
                detailCell(
                    icon: "sunset.fill",
                    label: "Sunset",
                    value: sunsetText,
                    color: .orange
                )
            }
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            Divider()
        }
    }

    private func detailCell(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title3)
            Text(value)
                .font(.subheadline.weight(.semibold))
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private var humidityText: String {
        let h = day.daytimeForecast?.relativeHumidity
            ?? day.nighttimeForecast?.relativeHumidity
        guard let h else { return "--" }
        return "\(Int(h.rounded()))%"
    }

    private var uvText: String {
        let uv = day.daytimeForecast?.uvIndex
            ?? day.nighttimeForecast?.uvIndex
        guard let uv else { return "--" }
        return "\(Int(uv.rounded()))"
    }

    private var sunriseText: String {
        guard let iso = day.sunEvents?.resolvedSunrise else { return "--" }
        return formatTime(iso)
    }

    private var sunsetText: String {
        guard let iso = day.sunEvents?.resolvedSunset else { return "--" }
        return formatTime(iso)
    }

    private func formatTime(_ iso: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: iso) ?? ISO8601DateFormatter().date(from: iso) {
            let tf = DateFormatter()
            tf.dateFormat = "h:mm a"
            return tf.string(from: date)
        }
        return "--"
    }
}
