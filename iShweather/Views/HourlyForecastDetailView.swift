import SwiftUI

struct HourlyForecastDetailView: View {
    let hour: HourlyForecastHour

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                detailCell(
                    icon: "humidity.fill",
                    label: "Humidity",
                    value: "\(Int(hour.relativeHumidity.rounded()))%",
                    color: .blue
                )
                Divider().frame(height: 44)
                detailCell(
                    icon: "sun.max.fill",
                    label: "UV Index",
                    value: "\(Int(hour.uvIndex.rounded()))",
                    color: .orange
                )
                Divider().frame(height: 44)
                detailCell(
                    icon: "thermometer.medium",
                    label: "Feels Like",
                    value: hour.feelsLikeTemperature.displayString,
                    color: .red
                )
                if let wind = hour.wind {
                    Divider().frame(height: 44)
                    detailCell(
                        icon: "wind",
                        label: "Wind",
                        value: wind.speed.displayString,
                        color: .secondary
                    )
                }
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
}
