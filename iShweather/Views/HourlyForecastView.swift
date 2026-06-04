import SwiftUI

struct HourlyForecastView: View {
    let hours: [HourlyForecastHour]
    @State private var expandedId: String?

    var body: some View {
        List {
            ForEach(hours) { hour in
                VStack(spacing: 0) {
                    HourlyForecastRow(hour: hour, isExpanded: expandedId == hour.id)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                expandedId = expandedId == hour.id ? nil : hour.id
                            }
                        }
                    if expandedId == hour.id {
                        HourlyForecastDetailView(hour: hour)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

struct HourlyForecastRow: View {
    let hour: HourlyForecastHour
    let isExpanded: Bool

    var body: some View {
        HStack(spacing: 8) {
            // Time
            Text(timeLabel)
                .frame(width: 56, alignment: .leading)
                .font(.subheadline.weight(.medium))

            // Icon
            Image(systemName: sfSymbol(for: hour.weatherCondition.type))
                .symbolRenderingMode(.multicolor)
                .font(.title3)
                .frame(width: 28)

            // Condition
            Text(hour.weatherCondition.description.text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Precip
            if let precip = precipPercent {
                HStack(spacing: 2) {
                    Image(systemName: "drop.fill").foregroundStyle(.blue).font(.caption)
                    Text("\(precip)%").font(.caption).foregroundStyle(.secondary)
                }
                .frame(width: 48)
            } else {
                Spacer().frame(width: 48)
            }

            // Temp
            Text(hour.temperature.displayString)
                .font(.subheadline.weight(.semibold))
                .frame(width: 36, alignment: .trailing)

            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 10)
    }

    private var timeLabel: String {
        let dt = hour.displayDateTime
        let hour12 = dt.hours % 12 == 0 ? 12 : dt.hours % 12
        let ampm = dt.hours < 12 ? "AM" : "PM"
        return "\(hour12) \(ampm)"
    }

    private var precipPercent: Int? {
        guard let p = hour.precipitation?.probability?.percent else { return nil }
        return Int(p.rounded())
    }
}
