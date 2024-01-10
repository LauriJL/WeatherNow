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
    
    func fetchWeatherData(cityName: String) {
        guard let api_key = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherAPIKey") as? String
            else { fatalError("not found") }
        let urlString = "\(weatherURL)&q=\(cityName)&appid=\(api_key)"
        urlRequest(urlString: urlString)
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
            let temperature = decodedData.main.temp
            let feels_like = decodedData.main.feels_like
            let conditionCode = decodedData.weather[0].id
            
            let weather = WeatherModel(cityName: name, temperature: temperature, feels_like: feels_like, conditionId: conditionCode)
            
            return weather
        } catch {
            print(error)
            return nil
        }
    }
}
