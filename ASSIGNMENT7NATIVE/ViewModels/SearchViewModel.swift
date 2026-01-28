import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var cityQuery: String = ""
    @Published var isLoading: Bool = false
    @Published var alertMessage: String? = nil
    @Published var result: WeatherScreenData? = nil

    private let repo: WeatherRepository

    init(repo: WeatherRepository = WeatherRepository()) {
        self.repo = repo
    }

    func search(unit: TemperatureUnit) async {
        alertMessage = nil
        result = nil

        let trimmed = cityQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            alertMessage = "Введите название города."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let data = try await repo.fetchWeather(city: trimmed, unit: unit)
            result = data
            if data.isOffline {
                alertMessage = "Не корректно.Ошибка."
            }
        } catch let apiErr as APIError {
            alertMessage = apiErr.localizedDescription
        } catch {
            alertMessage = "Ошибка."
        }

    }
}
