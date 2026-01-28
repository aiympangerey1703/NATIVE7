import Foundation
import SwiftUI
import Combine

enum TemperatureUnit: String, CaseIterable, Identifiable, Codable {
    case celsius
    case fahrenheit

    var id: String { rawValue }

    var display: String {
        switch self {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        }
    }

    var openMeteoParam: String? {
        switch self {
        case .celsius: return nil
        case .fahrenheit: return "fahrenheit"
        }
    }
}

final class SettingsStore: ObservableObject {
    @AppStorage("temperatureUnit") private var unitRaw: String = TemperatureUnit.celsius.rawValue

    var unit: TemperatureUnit {
        get { TemperatureUnit(rawValue: unitRaw) ?? .celsius }
        set {
            unitRaw = newValue.rawValue
            objectWillChange.send()
        }
    }
}
