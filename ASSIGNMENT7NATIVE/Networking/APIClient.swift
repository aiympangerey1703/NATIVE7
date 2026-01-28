import Foundation

final class APIClient {
    private let session: URLSession

    init() {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 15
        cfg.timeoutIntervalForResource = 15
        self.session = URLSession(configuration: cfg)
    }

    func get<T: Decodable>(_ url: URL, as type: T.Type) async throws -> T {
        do {
            let (data, resp) = try await session.data(from: url)

            guard let http = resp as? HTTPURLResponse else { throw APIError.unknown }
            guard (200...299).contains(http.statusCode) else { throw APIError.badStatus(http.statusCode) }

            guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                throw APIError.decoding
            }
            return decoded

        } catch let urlErr as URLError {
            switch urlErr.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                throw APIError.noInternet
            case .timedOut:
                throw APIError.timeout
            default:
                throw APIError.noInternet
            }
        } catch let apiErr as APIError {
            throw apiErr
        } catch {
            throw APIError.unknown
        }
    }
}
