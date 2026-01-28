import Foundation

struct DailyForecastItem: Identifiable, Codable {
    let id: UUID
    let date: String
    let min: Double
    let max: Double
    let condition: String
}

struct WeatherScreenData: Identifiable, Codable {
    let id: UUID
    let cityDisplayName: String
    let latitude: Double
    let longitude: Double
    let fetchedAt: Date
    let unit: TemperatureUnit
    let isOffline: Bool

    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let windSpeed: Double
    let condition: String

    let forecast3Days: [DailyForecastItem]
}

extension WeatherScreenData {
    static func conditionText(from code: Int) -> String {
        switch code {
        case 0: return "Clear"
        case 1, 2, 3: return "Partly cloudy"
        case 45, 48: return "Fog"
        case 51, 53, 55: return "Drizzle"
        case 61, 63, 65: return "Rain"
        case 71, 73, 75: return "Snow"
        case 80, 81, 82: return "Showers"
        case 95: return "Thunderstorm"
        default: return "Unknown"
        }
    }
}
