import SwiftUI

struct LocationSearchBar: View {
    @Bindable var vm: AppViewModel
    @State private var showRecents = false
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search location…", text: $vm.searchText)
                    .focused($focused)
                    .autocorrectionDisabled()
                    .onChange(of: vm.searchText) { _, new in vm.updateSearch(new) }
                    .onSubmit { focused = false }
                if !vm.searchText.isEmpty {
                    Button { vm.searchText = ""; vm.searchResults = [] } label: {
                        Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                    }
                }
                if vm.searchText.isEmpty && !vm.recentLocations.isEmpty {
                    Button {
                        showRecents.toggle()
                        focused = false
                    } label: {
                        Image(systemName: "clock")
                            .foregroundStyle(showRecents ? .blue : .secondary)
                    }
                }
            }
            .padding(10)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .padding(.vertical, 8)

            if !vm.searchResults.isEmpty {
                searchResultsList
            } else if showRecents && !vm.recentLocations.isEmpty {
                recentsList
            }
        }
    }

    private var searchResultsList: some View {
        List(vm.searchResults) { prediction in
            Button {
                vm.selectPlace(prediction)
                focused = false
            } label: {
                Label(prediction.description, systemImage: "mappin.and.ellipse")
                    .foregroundStyle(.primary)
            }
        }
        .listStyle(.plain)
        .frame(maxHeight: 240)
    }

    private var recentsList: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Recent Locations")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.top, 4)
                Spacer()
            }
            List {
                ForEach(vm.recentLocations) { location in
                    Button {
                        vm.selectRecentLocation(location)
                        showRecents = false
                    } label: {
                        Label(location.friendlyName, systemImage: "clock")
                            .foregroundStyle(.primary)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            vm.removeRecentLocation(location)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .frame(maxHeight: 240)
        }
    }
}
