import SwiftUI

struct ContentView: View {
    @State private var vm = AppViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                LocationSearchBar(vm: vm)
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
