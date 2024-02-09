//
//  InfoViewController.swift
//  WeatherNow
//
//  Created by Lauri Leskinen on 11.1.2024.
//

import UIKit
import MapKit

class InfoViewController: UIViewController {
    
//    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windMSLabel: UILabel!
    @IBOutlet weak var windDirLabel: UILabel!
    @IBOutlet weak var windDegLabel: UILabel!
    @IBOutlet weak var gustSpeedLabel: UILabel!
    @IBOutlet weak var gustMSLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    var cityName: String?
    var temperature: String?
    var feelsLike: String?
    var maxTemp: String?
    var minTemp: String?
    var pressure: String?
    var humidity: String?
    var windSpeed: String?
    var windDir: String?
    var windGust: String?
    var latitude: Double?
    var longitude: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
//        cityNameLabel.text = cityName
        temperatureLabel.text = temperature
        feelsLikeLabel.text = feelsLike
        maxTempLabel.text = maxTemp
        minTempLabel.text = minTemp
        pressureLabel.text = pressure
        humidityLabel.text = humidity
        windSpeedLabel.text = windSpeed
        if windSpeedLabel.text == "N/A" {
            windMSLabel.isHidden = true
        }
        windDirLabel.text = windDir
        if windDirLabel.text == "N/A" {
            windDegLabel.isHidden = true
        }
        gustSpeedLabel.text = windGust
        if gustSpeedLabel.text == "N/A" {
            gustMSLabel.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = cityName
    }
}
