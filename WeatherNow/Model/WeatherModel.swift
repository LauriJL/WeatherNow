//
//  WeatherModel.swift
//  WeatherNow
//
//  Created by Lauri Leskinen on 9.1.2024.
//

import Foundation

struct WeatherModel {
    // Stored properties
    let cityName: String
    let latitude: Double
    let longitude: Double
    let conditionId: Int
    let temperature: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let wind_speed: Double
    let wind_direction: Int
    let wind_gust: Double

    
    
    // Computed properties
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
    
    var latitudeString: String {
        return String(format: "%.4f", latitude)
    }
    
    var longitudeString: String {
        return String(format: "%.4f", longitude)
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var feelsLikeString: String {
        return String(format: "%.1f", feels_like)
    }
    
    var temp_minString: String {
        return String(format: "%.1f", temp_min)
    }
    
    var temp_maxString: String {
        return String(format: "%.1f", temp_max)
    }
    
    var pressureString: String {
        return String(pressure)
    }
    
    var humidityString: String {
        return String(humidity)
    }
    
    var windSpeedString: String {
        if wind_speed == -1 {
            return("N/A")
        } else {
            return String(format: "%.1f", wind_speed)
        }
    }
 
    var windDirString: String {
        if wind_direction == -1 {
            return("N/A")
        } else {
            return String(wind_direction)
        }
    }
    
    var windGustString: String {
        if wind_gust == -1 {
            return("N/A")
        } else {
            return String(format: "%.1f", wind_gust)
        }
    }
}
