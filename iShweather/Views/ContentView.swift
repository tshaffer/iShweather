import SwiftUI

struct ContentView: View {
    @State private var vm = AppViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                LocationSearchBar(vm: vm)
                if let location = vm.selectedLocation {
                    Text("\(vm.forecastViewType == .daily ? "10 Day" : "Hourly") Weather — \(location.friendlyName)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                }
                ForecastToggle(vm: vm)
                ForecastContainerView(vm: vm)
            }
            .navigationTitle("iShweather")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await PlacesService.shared.loadAPIKey()
            vm.loadForecast()
        }
    }
}
