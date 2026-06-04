import SwiftUI

struct DailyForecastView: View {
    let days: [DailyForecastDay]
    @State private var expandedId: String?

    var body: some View {
        List {
            ForEach(days) { day in
                VStack(spacing: 0) {
                    DailyForecastRow(day: day, isExpanded: expandedId == day.id)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                expandedId = expandedId == day.id ? nil : day.id
                            }
                        }
                    if expandedId == day.id {
                        DailyForecastDetailView(day: day)
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

struct DailyForecastRow: View {
    let day: DailyForecastDay
    let isExpanded: Bool

    var body: some View {
        HStack(spacing: 8) {
            // Date
            Text(dayLabel)
                .frame(width: 44, alignment: .leading)
                .font(.subheadline.weight(.medium))

            // Condition icon + description
            weatherIcon
                .frame(width: 28)
            Text(conditionText)
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

            // Temps
            HStack(spacing: 4) {
                Text(day.maxTemperature?.displayString ?? "--")
                    .font(.subheadline.weight(.semibold))
                Text(day.minTemperature?.displayString ?? "--")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 10)
    }

    private var dayLabel: String {
        guard let date = day.displayDate.date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = Calendar.current.isDateInToday(date) ? "'Today'" : "EEE"
        return formatter.string(from: date)
    }

    private var conditionText: String {
        day.daytimeForecast?.weatherCondition?.description.text
            ?? day.nighttimeForecast?.weatherCondition?.description.text
            ?? ""
    }

    private var precipPercent: Int? {
        let p = day.daytimeForecast?.precipitation?.probability?.percent
            ?? day.nighttimeForecast?.precipitation?.probability?.percent
        guard let p else { return nil }
        return Int(p.rounded())
    }

    private var weatherIcon: some View {
        let condition = day.daytimeForecast?.weatherCondition?.type
            ?? day.nighttimeForecast?.weatherCondition?.type
            ?? ""
        return Image(systemName: sfSymbol(for: condition))
            .symbolRenderingMode(.multicolor)
            .font(.title3)
    }
}
