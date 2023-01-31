import UIKit
import SwiftUI
import MapKit
import WeatherKit

class WeatherViewController: UIViewController {

    @IBOutlet var weatherView: UIView! {
        didSet {
            weatherView.alpha = 0
        }
    }

    @IBOutlet var weatherButton: UIButton! {
        didSet {
            weatherButton.setTitleColor(UIColor.white, for: .normal)
            weatherButton.sizeToFit()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 九州産業大学の座標
        let ksuLocation = CLLocation(latitude: 33.669266, longitude: 130.444895)
        loadCurrentWeather(ksuLocation)
    }

    func loadCurrentWeather(_ location: CLLocation) {
        WeatherModel().updateWeather(location: location, service: { (forecast: Weather) in
            let currentTemperature = String("\(Int(forecast.currentWeather.temperature.value))° ")
            let weatherImage = UIImage(systemName: "\(forecast.currentWeather.symbolName)")

            DispatchQueue.main.async {
                UIView.transition(with: self.weatherView, duration: 0.5, options: .curveEaseInOut, animations: {
                    self.weatherView.alpha = 1
                })
                self.weatherButton.setTitle(currentTemperature, for: .normal)
                self.weatherButton.setImage(weatherImage, for: .normal)
            }
        })
    }
    
    @IBAction func weatherButtonTapped(_ sender: Any) {
        // 天気画面へ画面遷移
        let view = UIHostingController(rootView: WeatherView())
        present(view, animated: true, completion: nil)
    }
}
