//
//  WeatherData.swift
//  WeatherNow
//
//  Created by Lauri Leskinen on 9.1.2024.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let sys: Sys
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Decodable {
    let id: Int
}

struct Wind: Decodable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Sys: Decodable {
    let sunrise: Int
    let sunset: Int
}
