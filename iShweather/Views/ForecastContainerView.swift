import SwiftUI

struct ForecastContainerView: View {
    @Bindable var vm: AppViewModel

    var body: some View {
        Group {
            if vm.selectedLocation == nil {
                emptyState
            } else {
                switch vm.forecastViewType {
                case .daily:  dailyContent
                case .hourly: hourlyContent
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var dailyContent: some View {
        switch vm.dailyState {
        case .idle:
            Color.clear.onAppear { vm.loadForecast() }
        case .loading:
            ProgressView("Loading forecast…")
        case .loaded(let days):
            DailyForecastView(days: days)
        case .error(let msg):
            ErrorView(message: msg) { vm.loadForecast() }
        }
    }

    @ViewBuilder
    private var hourlyContent: some View {
        switch vm.hourlyState {
        case .idle:
            Color.clear.onAppear { vm.loadForecast() }
        case .loading:
            ProgressView("Loading forecast…")
        case .loaded(let hours):
            HourlyForecastView(hours: hours)
        case .error(let msg):
            ErrorView(message: msg) { vm.loadForecast() }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "cloud.sun")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("Search for a location to see the forecast")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct ErrorView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.orange)
            Text(message)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Retry", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
