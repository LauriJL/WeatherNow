//
//  WeatherMgr.swift
//  WeatherNow
//
//  Created by Lauri Leskinen on 8.1.2024.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}

struct WeatherMgr {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeatherData(cityName: String? = nil,  latitude: Double? = nil, longitude: Double? = nil) {
        guard let api_key = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherAPIKey") as? String
            else { fatalError("not found") }
        if cityName != nil {
            let urlString = "\(weatherURL)&appid=\(api_key)&q=\(cityName ?? "Helsinki")"
            urlRequest(urlString: urlString)
        } else {
            let urlString = "\(weatherURL)&appid=\(api_key)&lat=\(latitude ?? 60.24416)&lon=\(longitude ?? 24.89239)"
            urlRequest(urlString: urlString)
         }
    }
    
    func urlRequest(urlString: String) {
        // Create URL
        if let url = URL(string: urlString) {
            // Create URL session
            let urlSession = URLSession(configuration: .default)
            // Task for URL session
            let task = urlSession.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let okData = data {
                    // add self. recommended inside a closure
                    if let weather = self.parseJSON(weatherData: okData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            // Start dataTask
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        // Wrap in do...catch because .decode throws possible error
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let latitude = decodedData.coord.lat
            let longitude = decodedData.coord.lon
            let temperature = decodedData.main.temp
            let feels_like = decodedData.main.feels_like
            let temp_max = decodedData.main.temp_max
            let temp_min = decodedData.main.temp_min
            let pressure = decodedData.main.pressure
            let humidity = decodedData.main.humidity 
            let wind_speed = decodedData.wind.speed ?? -1
            let wind_direction = decodedData.wind.deg ?? -1
            let wind_gust = decodedData.wind.gust ?? -1
            let conditionCode = decodedData.weather[0].id
            
            let weather = WeatherModel(cityName: name, latitude: latitude, longitude: longitude, conditionId: conditionCode, temperature: temperature, feels_like: feels_like, temp_min: temp_min, temp_max: temp_max, pressure: pressure, humidity: humidity, wind_speed: wind_speed, wind_direction: wind_direction, wind_gust: wind_gust)
            
            return weather
        } catch {
            print(error)
            return nil
        }
    }
}
