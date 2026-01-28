import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidInput
    case cityNotFound
    case noInternet
    case timeout
    case badStatus(Int)
    case decoding
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Введите название города."
        case .cityNotFound:
            return "Город не найден. Проверьте написание."
        case .noInternet:
            return "Нет интернета. Показываю последние сохранённые данные (если есть)."
        case .timeout:
            return "Слишком долго нет ответа от сервера. Попробуйте ещё раз."
        case .badStatus(let code):
            return "Ошибка сервера (HTTP \(code)). Попробуйте позже."
        case .decoding:
            return "Не удалось прочитать ответ сервера (JSON)."
        case .invalidURL:
            return "Неверный URL запроса."
        case .unknown:
            return "Неизвестная ошибка."
        }
    }
}
