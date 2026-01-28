import Foundation

final class CacheStore {
    private let key = "lastWeatherScreenData"

    func save(_ data: WeatherScreenData) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encoded = try encoder.encode(data)
        UserDefaults.standard.set(encoded, forKey: key)
    }

    func load() -> WeatherScreenData? {
        guard let raw = UserDefaults.standard.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(WeatherScreenData.self, from: raw)
    }
}
