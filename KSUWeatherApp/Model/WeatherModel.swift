import SwiftUI
import CoreLocation
import WeatherKit

class WeatherModel: ObservableObject {
    static let shared = WeatherModel()
    // 天気データへアクセス
    let service = WeatherService.shared

    @Published var weather: Weather?
    @Published var attributionInfo: WeatherAttribution?
    // 天気情報を更新するメソッド
    func updateWeather() {
        Task {
            do {
                // 九州産業大学の座標
                let location = CLLocation(latitude: 33.669266, longitude: 130.444895)
                let weather = try await self.service.weather(for: location)
                DispatchQueue.main.async {
                    self.weather = weather
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    // 天気情報を更新するメソッド
    func updateWeather(service: @escaping (_ result: Weather) -> Void) {
        // 九州産業大学の座標
        let location = CLLocation(latitude: 33.669266, longitude: 130.444895)
        Task {
            do {
                let weather = try await self.service.weather(for: location)
                service(weather)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    // 天気情報を更新するメソッド
    func updateWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, service: @escaping (_ result: Weather) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        Task {
            do {
                let weather = try await self.service.weather(for: location)
                service(weather)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // 天気情報を更新するメソッド
    func updateWeather(location: CLLocation, service: @escaping (_ result: Weather) -> Void) {
        Task {
            do {
                let weather = try await self.service.weather(for: location)
                service(weather)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    // Attribution取得のメソッド
    func updateAttributionInfo() {
        // 優先度backgroundの場合
        Task.detached(priority: .background) {
            let attribution = try await self.service.attribution
            DispatchQueue.main.async {
                self.attributionInfo = attribution
            }
        }
    }
}
