//
//  Weather.swift
//  WeatherForecast
//
//  Created by 민선기 on 2021/10/27.
//

import Foundation

struct WeatherResult: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: String
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
}
