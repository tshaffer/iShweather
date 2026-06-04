import SwiftUI

struct DailyForecastView: View {
    let days: [DailyForecastDay]
    @State private var expandedId: String?

    // Filter out any days before today (fixes the web app bug)
    private var todayAndFuture: [DailyForecastDay] {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        return days.filter { day in
            guard let date = day.displayDate.date else { return false }
            return date >= startOfToday
        }
    }

    var body: some View {
        List {
            ForEach(todayAndFuture) { day in
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
        HStack(alignment: .center, spacing: 8) {
            // Date: stacked "Wed" / "Jun 10", or "Today" centered
            dateLabel
                .frame(width: 52, alignment: .leading)

            // Condition icon
            weatherIcon
                .frame(width: 28)

            // Condition text
            Text(conditionText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Precip — fixed width, right-aligned
            HStack(spacing: 2) {
                Image(systemName: "drop.fill")
                    .foregroundStyle(.blue)
                    .font(.caption)
                Text(precipPercent.map { "\($0)%" } ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 44, alignment: .trailing)

            // High / Low — fixed widths so they always line up
            Text(day.maxTemperature?.displayString ?? "--")
                .font(.subheadline.weight(.semibold))
                .frame(width: 32, alignment: .trailing)
            Text(day.minTemperature?.displayString ?? "--")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 32, alignment: .trailing)

            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }

    private var dateLabel: some View {
        guard let date = day.displayDate.date else {
            return AnyView(Text("").font(.subheadline))
        }
        if Calendar.current.isDateInToday(date) {
            return AnyView(
                Text("Today")
                    .font(.subheadline.weight(.medium))
            )
        }
        let dow = date.formatted(.dateTime.weekday(.abbreviated))  // "Wed"
        let mon = date.formatted(.dateTime.month(.abbreviated))    // "Jun"
        let d   = date.formatted(.dateTime.day())                  // "10"
        return AnyView(
            VStack(alignment: .leading, spacing: 0) {
                Text(dow)
                    .font(.subheadline.weight(.medium))
                Text("\(mon) \(d)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        )
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
            .foregroundStyle(iconColor(for: condition))
            .font(.title3)
    }
}
