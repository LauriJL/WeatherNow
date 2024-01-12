//
//  InfoViewController.swift
//  WeatherNow
//
//  Created by Lauri Leskinen on 11.1.2024.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirLabel: UILabel!
    @IBOutlet weak var gustSpeedLabel: UILabel!
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

    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameLabel.text = cityName
        temperatureLabel.text = temperature
        feelsLikeLabel.text = feelsLike
        maxTempLabel.text = maxTemp
        minTempLabel.text = minTemp
        pressureLabel.text = pressure
        humidityLabel.text = humidity
        windSpeedLabel.text = windSpeed
        windDirLabel.text = windDir
        gustSpeedLabel.text = windGust
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
}