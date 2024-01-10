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
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
}

struct Weather: Decodable {
    let id: Int
}
