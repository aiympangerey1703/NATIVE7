import Foundation

final class WeatherRepository {
    private let api: APIClient
    private let cache: CacheStore

    init(api: APIClient = APIClient(), cache: CacheStore = CacheStore()) {
        self.api = api
        self.cache = cache
    }

    func fetchWeather(city: String, unit: TemperatureUnit) async throws -> WeatherScreenData {
        let trimmed = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw APIError.invalidInput }

        do {
            // 1) Geocoding
            let geoURL = try Endpoints.geocoding(city: trimmed)
            let geo = try await api.get(geoURL, as: GeoResponse.self)
            guard let first = geo.results?.first else { throw APIError.cityNotFound }

            // 2) Forecast (current + daily)
            let weatherURL = try Endpoints.forecast(lat: first.latitude, lon: first.longitude, unit: unit)
            let w = try await api.get(weatherURL, as: WeatherResponse.self)

            // 3) UI model + 3-day forecast
            let forecast3 = make3DayForecast(from: w)

            let data = WeatherScreenData(
                id: UUID(),
                cityDisplayName: [first.name, first.country].compactMap { $0 }.joined(separator: ", "),
                latitude: first.latitude,
                longitude: first.longitude,
                fetchedAt: Date(),
                unit: unit,
                isOffline: false,
                temperature: w.current.temperature2m,
                feelsLike: w.current.apparentTemperature,
                humidity: w.current.relativeHumidity2m,
                windSpeed: w.current.windSpeed10m,
                condition: WeatherScreenData.conditionText(from: w.current.weatherCode),
                forecast3Days: forecast3
            )

            try cache.save(data)
            return data

        } catch let err as APIError {
            // ✅ Offline fallback только при проблемах сети/таймаут/сервер
            switch err {
            case .noInternet, .timeout, .badStatus:
                if let cached = cache.load() {
                    return WeatherScreenData(
                        id: cached.id,
                        cityDisplayName: cached.cityDisplayName,
                        latitude: cached.latitude,
                        longitude: cached.longitude,
                        fetchedAt: cached.fetchedAt,
                        unit: cached.unit,
                        isOffline: true,
                        temperature: cached.temperature,
                        feelsLike: cached.feelsLike,
                        humidity: cached.humidity,
                        windSpeed: cached.windSpeed,
                        condition: cached.condition,
                        forecast3Days: cached.forecast3Days
                    )
                }
                throw err

            // ❌ если город не найден/ввод плохой — НЕ показываем кэш
            case .invalidInput, .cityNotFound, .invalidURL, .decoding, .unknown:
                throw err
            }

        } catch {
            // если это не APIError — считаем неизвестной
            throw APIError.unknown
        }
    }

    // ✅ Важно: эта функция должна быть на уровне класса, НЕ внутри fetchWeather
    private func make3DayForecast(from w: WeatherResponse) -> [DailyForecastItem] {
        let dates = w.daily.time
        let mins = w.daily.temperature2mMin
        let maxs = w.daily.temperature2mMax
        let codes = w.daily.weatherCode

        let count = min(3, dates.count, mins.count, maxs.count, codes.count)
        return (0..<count).map { i in
            DailyForecastItem(
                id: UUID(),
                date: dates[i],
                min: mins[i],
                max: maxs[i],
                condition: WeatherScreenData.conditionText(from: codes[i])
            )
        }
    }
}
