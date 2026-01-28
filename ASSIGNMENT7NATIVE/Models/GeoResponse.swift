import Foundation

struct GeoResponse: Codable {
    let results: [GeoResult]?
}

struct GeoResult: Codable {
    let name: String
    let country: String?
    let latitude: Double
    let longitude: Double
}
