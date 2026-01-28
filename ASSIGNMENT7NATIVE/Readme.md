# Title: Weather App 
## Overview
- This is a simple iOS Weather App built with SwiftUI. The user can search a city and view current weather and a 3-day forecast. The app supports unit switching (C/F), offline cache, loading state, and error handling.

##Used API
API Provider: Open-Meteo.

Endpoints & Parameters

Geocoding endpoint: used to convert city name → latitude/longitude.
Parameters: name (city query), limit

Forecast endpoint: used to get current weather and daily forecast.
Parameters: latitude, longitude, current weather fields, daily fields, temperature_unit (optional)

## How to Run:

Open the project in Xcode.

Select an iPhone simulator.

Press Run.

Enter a city name (e.g., Astana) and tap “Get Weather”.

Architecture
MVVM + Repository pattern:

Views: SwiftUI screens (Search, Weather, Settings).

ViewModel: handles state, calls repository, exposes loading/result/error states.

Repository: performs networking and converts API responses into UI models.

Networking: URLSession + Codable.

Storage: UserDefaults (cache last successful result).

###Offline / Caching
- The app saves the last successful weather result locally using UserDefaults. If the network is unavailable (no internet/timeout/server error), the app displays cached data and marks it as OFFLINE.

## Error Handling

Empty input: shows a user-friendly message.

City not found: shows “City not found” message.

No internet / timeout: shows cached data if available, otherwise shows a message.

Other errors: shows a readable error message.

##Known Limitations

Forecast is limited to 3 days (daily).

City suggestions/history is not implemented (optional feature).

Weather conditions are mapped from weather codes (basic mapping).

