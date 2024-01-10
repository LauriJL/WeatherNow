//
//  ViewController.swift
//  WeatherNow
//
//  Created by Lauri Leskinen on 5.1.2024.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
   
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherSymbolImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var degreeLabel2: UILabel!
    @IBOutlet weak var celsiusLabel2: UILabel!
    
    var weatherMgr = WeatherMgr()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherSymbolImageView.isHidden = true
        temperatureLabel.isHidden = true
        degreeLabel.isHidden = true
        celsiusLabel.isHidden = true
        feelsLikeLabel.isHidden = true
        feelsLikeTempLabel.isHidden = true
        degreeLabel2.isHidden = true
        celsiusLabel2.isHidden = true
        
        // Delegates
        weatherMgr.delegate = self
        searchField.delegate = self
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        cityLabel.text = searchField.text!
        searchField.endEditing(true)
    }
    
    // Process pressing of Return button on keypad
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //cityLabel.text = searchField.text!
        searchField.endEditing(true)
        return true
    }
    
    // Validate contents of text field
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter city name"
            return false
        }
    }
    
    // Empty text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchField.text {
            weatherMgr.fetchWeatherData(cityName: city)
        }
        searchField.text = ""
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.isHidden = false
            self.temperatureLabel.text = weather.temperatureString
            self.degreeLabel.isHidden = false
            self.celsiusLabel.isHidden = false
            self.weatherSymbolImageView.isHidden = false
            self.weatherSymbolImageView.image = UIImage(systemName: weather.conditionName)
            self.feelsLikeLabel.isHidden = false
            self.feelsLikeTempLabel.isHidden = false
            self.feelsLikeTempLabel.text = weather.feelsLikeString
            self.degreeLabel2.isHidden = false
            self.celsiusLabel2.isHidden = false
        }
    }
}

