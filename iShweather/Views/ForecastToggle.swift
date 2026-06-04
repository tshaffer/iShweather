import SwiftUI

struct ForecastToggle: View {
    @Bindable var vm: AppViewModel

    var body: some View {
        Picker("Forecast", selection: $vm.forecastViewType) {
            Text("10-Day").tag(ForecastView.daily)
            Text("72-Hour").tag(ForecastView.hourly)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}
