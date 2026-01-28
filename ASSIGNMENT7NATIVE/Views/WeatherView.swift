import SwiftUI

struct WeatherView: View {
    let data: WeatherScreenData

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {

                HStack {
                    Text(data.cityDisplayName)
                        .font(.title2).bold()
                    Spacer()
                    if data.isOffline {
                        Text("OFFLINE")
                            .font(.caption).bold()
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.orange.opacity(0.2))
                            .cornerRadius(10)
                    }
                }

                Text("Last update: \(data.fetchedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Now: \(format(data.temperature)) \(data.unit.display)")
                        .font(.headline)
                    Text("Feels like: \(format(data.feelsLike)) \(data.unit.display)")
                    Text("Condition: \(data.condition)")
                    Text("Humidity: \(data.humidity)%")
                    Text("Wind: \(format(data.windSpeed)) m/s")
                }

                Divider()

                Text("3-Day Forecast")
                    .font(.headline)

                ForEach(data.forecast3Days) { item in
                    HStack {
                        Text(item.date)
                            .frame(width: 110, alignment: .leading)
                        Spacer()
                        Text(item.condition)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(format(item.min))–\(format(item.max)) \(data.unit.display)")
                            .frame(width: 140, alignment: .trailing)
                    }
                    .padding(.vertical, 6)
                }
            }
            .padding()
        }
        .navigationTitle("Weather")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func format(_ v: Double) -> String {
        String(format: "%.1f", v)
    }
}
