import MapKit
import SwiftUI
import WeatherKit

struct WeatherView: View {
    // デバイスがダークモードかを判定
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var weatherModel = WeatherModel.shared
    // デバイスのサイズ取得
    let screen: CGRect = UIScreen.main.bounds
    // 1時間ごとの天気を24時間分
    var hourlyWeatherData: [HourWeather] {
        if let hourlyWeather = weatherModel.weather?.hourlyForecast {
            return Array(hourlyWeather.filter { hourlyWeather in
                // timeIntervalSinceで取得した日付と比較
                hourlyWeather.date.timeIntervalSince(Date()) >= 0
            }.prefix(24))
        } else {
            return []
        }
    }

    var body: some View {
        // デバイス判定
        if UIDevice.current.userInterfaceIdiom == .pad {
            ScrollView {
                VStack {
                    if let weather = weatherModel.weather {
                        VStack {
                            HStack {
                                VStack {
                                    Text(Date().formatAsToday())
                                        .font(.system(size: screen.width * 0.03))
                                        .padding(.top, screen.height * 0.0045)
                                        .padding(.bottom, screen.height * 0.0043)
                                    Text("九州産業大学")
                                        .font(.system(size: screen.width * 0.037))
                                        .fontWeight(.bold)
                                    Text("\(Int(weather.currentWeather.temperature.value.rounded()))°")
                                        .font(.system(size: screen.width * 0.065))
                                }
                                .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.247, green: 0.247, blue: 0.247))
                                Spacer()
                                VStack {
                                    Image("\(weather.currentWeather.symbolName).fill")
                                        .symbolRenderingMode(.multicolor)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: screen.height * 0.14, height: screen.height * 0.14)
                                        .padding(.bottom, screen.height * 0.0040)
                                    Text(weather.currentWeather.condition.accessibilityDescription)
                                        .font(.system(size: screen.width * 0.039))
                                        .fontWeight(.medium)
                                        .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.247, green: 0.247, blue: 0.247))
                                }
                            }
                            .padding(.top)
                        }
                        .padding(.horizontal, 25)
                        .frame(maxHeight: screen.height * 0.29)
                        // 1時間ごとの天気予報
                        HourlyForcastView(hourWeatherList: hourlyWeatherData)
                        // 10日間天気予報
                        TenDayForcastView(dayWeatherList: weather.dailyForecast.forecast)
                        // AppleWeatherの商標とデータソース
                        AppleAttribution()
                    }
                }
                .onAppear {
                    loadingWeather()
                }
                .onDisappear {
                    loadingWeather()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .background {
                    colorScheme == .dark ? Color(red: 0.066, green: 0.062, blue: 0.231) : .white
                }
            }
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            ScrollView {
                VStack {
                    if let weather = weatherModel.weather {
                        VStack {
                            HStack {
                                VStack {
                                    Text(Date().formatAsToday())
                                        .font(.system(size: screen.width * 0.06))
                                        .padding(.bottom, screen.height * 0.006)
                                    Text("九州産業大学")
                                        .font(.system(size: screen.width * 0.08))
                                        .fontWeight(.bold)
                                    Text("\(Int(weather.currentWeather.temperature.value.rounded()))°")
                                        .font(.system(size: screen.width * 0.18))
                                }
                                .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.247, green: 0.247, blue: 0.247))
                                Spacer()
                                VStack {
                                    Image("\(weather.currentWeather.symbolName).fill")
                                        .symbolRenderingMode(.multicolor)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: screen.height * 0.14, height: screen.height * 0.14)
                                        .padding(.bottom)
                                    Text(weather.currentWeather.condition.accessibilityDescription)
                                        .font(.system(size: screen.width * 0.05))
                                        .fontWeight(.medium)
                                        .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.247, green: 0.247, blue: 0.247))
                                }
                            }
                            .padding(.top)
                        }
                        .padding(.horizontal, 25)
                        .frame(maxHeight: screen.height * 0.29)
                        // 1時間ごとの天気予報
                        HourlyForcastView(hourWeatherList: hourlyWeatherData)
                        // 10日間天気予報
                        TenDayForcastView(dayWeatherList: weather.dailyForecast.forecast)
                        // AppleWeatherの商標とデータソース
                        AppleAttribution()
                    }
                }
                .onAppear {
                    loadingWeather()
                }
                .onDisappear {
                    loadingWeather()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .background {
                    colorScheme == .dark ? Color(red: 0.066, green: 0.062, blue: 0.231) : .white
                }
            }
        }
    }

    func loadingWeather() {
        Task {
            weatherModel.updateWeather()
            weatherModel.updateAttributionInfo()
        }
    }
}

struct HourlyForcastView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let hourWeatherList: [HourWeather]
    let screen: CGRect = UIScreen.main.bounds

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(hourWeatherList, id: \.date) { hourWeatherItem in
                        let rainyPercent = round(hourWeatherItem.precipitationChance * 10) / 1
                        let precipitationAmount = round(hourWeatherItem.precipitationAmount.value * 10) / 10
                        VStack {
                            Text(hourWeatherItem.date.formatAsAbbreviatedTime())
                            Image("\(hourWeatherItem.symbolName).fill")
                                .symbolRenderingMode(.multicolor)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: screen.height * 0.04, height: screen.height * 0.04)
                                .padding(.bottom, 5)
                            Text("\(Int(hourWeatherItem.temperature.value.rounded()))°")
                            Text("\(Int(rainyPercent * 10))%")
                            if precipitationAmount > 0, precipitationAmount < 1 {
                                Text("\(String(precipitationAmount)) mm")
                            } else {
                                Text("\(Int(precipitationAmount)) mm")
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .padding(.vertical, screen.height * 0.047)
            }
        }
        .frame(maxHeight: screen.height * 0.22)
        .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.247, green: 0.247, blue: 0.247))
        .cardStyle(appearanceMode: colorScheme, cornerRadius: 10)
    }
}

struct TenDayForcastView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let dayWeatherList: [DayWeather]
    let screen: CGRect = UIScreen.main.bounds

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                ForEach(dayWeatherList, id: \.date) { dailyWeather in
                    let rainyPercent = round(dailyWeather.precipitationChance * 10) / 1
                    HStack {
                        Text(dailyWeather.date.formatAsdays())
                            .frame(maxWidth: screen.width * 0.16, alignment: .leading)
                        Spacer()
                        Image("\(dailyWeather.symbolName).fill")
                            .symbolRenderingMode(.multicolor)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: screen.height * 0.04, height: screen.height * 0.04)
                        Spacer()
                        Text("\(Int(dailyWeather.highTemperature.value.rounded()))°")
                            .frame(width: 40, alignment: .trailing)
                            .foregroundColor(Color.orange)
                        Text("\(Int(dailyWeather.lowTemperature.value.rounded()))°")
                            .frame(width: 40, alignment: .trailing)
                            .foregroundColor(Color.blue)
                        Text("\(Int(rainyPercent * 10))%")
                            .frame(width: 48, alignment: .trailing)
                    }
                    .padding(.horizontal, 30)
                    .frame(height: 45)
                    .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.247, green: 0.247, blue: 0.247))
                }
            }
        }
        .frame(maxHeight: screen.height * 0.47)
        .cardStyle(appearanceMode: colorScheme, cornerRadius: 15)
    }
}

struct AppleAttribution: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var weatherDataHelper = WeatherModel.shared

    var body: some View {
        VStack {
            HStack {
                if let attribution = weatherDataHelper.attributionInfo {
                    // AppleWeatherの商標の表示
                    AsyncImage(url: URL(string: "\(colorScheme == .dark ? attribution.combinedMarkDarkURL : attribution.combinedMarkLightURL)")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 10)
                    } placeholder: {
                        ProgressView()
                    }
                    // 天気のデータソースへの法的リンク
                    Link("天気のデータソース", destination: attribution.legalPageURL)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .font(.system(size: 8))
                        .offset(y: 1)
                }
            }
        }
        .padding(.bottom, 10)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
