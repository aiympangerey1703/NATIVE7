import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Units")) {
                    Picker("Temperature", selection: Binding(
                        get: { settings.unit },
                        set: { settings.unit = $0 }
                    )) {
                        ForEach(TemperatureUnit.allCases) { u in
                            Text(u.display).tag(u)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    Text("Switch °C/°F for the API data.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
