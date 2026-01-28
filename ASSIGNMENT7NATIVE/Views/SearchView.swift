import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var settings: SettingsStore
    @StateObject private var vm = SearchViewModel()
    @State private var showWeather = false
    @State private var showErrorAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Enter city (e.g., Astana)", text: $vm.cityQuery)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(12)

                Button {
                    Task {
                        await vm.search(unit: settings.unit)
                        showWeather = (vm.result != nil)
                    }
                } label: {
                    HStack {
                        Image(systemName: "cloud.sun")
                        Text("Get Weather")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.isLoading)

                if vm.isLoading { ProgressView() }

                if let msg = vm.alertMessage {
                    Text(msg)
                        .foregroundStyle(.red)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer()

                NavigationLink(isActive: $showWeather) {
                    if let data = vm.result {
                        WeatherView(data: data)
                    } else {
                        Text("No data")
                    }
                } label: { EmptyView() }
            }
            .padding()
            .navigationTitle("Weather Search")
            .onChange(of: vm.alertMessage) { _, newValue in
                showErrorAlert = (newValue != nil)
            }
            .alert("Message", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(vm.alertMessage ?? "")
            }
        }
    }
}
