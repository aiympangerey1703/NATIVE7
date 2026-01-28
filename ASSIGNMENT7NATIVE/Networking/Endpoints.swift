import Foundation

enum Endpoints {
    static func geocoding(city: String) throws -> URL {
        var c = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")
        c?.queryItems = [
            .init(name: "name", value: city),
            .init(name: "count", value: "1"),
            .init(name: "language", value: "en"),
            .init(name: "format", value: "json")
        ]
        guard let url = c?.url else { throw APIError.invalidURL }
        return url
    }

    static func forecast(lat: Double, lon: Double, unit: TemperatureUnit) throws -> URL {
        var c = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
        var items: [URLQueryItem] = [
            .init(name: "latitude", value: "\(lat)"),
            .init(name: "longitude", value: "\(lon)"),
            .init(name: "current", value: "temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,weather_code"),
            .init(name: "daily", value: "temperature_2m_max,temperature_2m_min,weather_code"),
            .init(name: "timezone", value: "auto")
        ]
        if let u = unit.openMeteoParam {
            items.append(.init(name: "temperature_unit", value: u))
        }
        c?.queryItems = items
        guard let url = c?.url else { throw APIError.invalidURL }
        return url
    }
}
