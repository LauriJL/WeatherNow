//
//  ViewController.swift
//  WeatherNow
//
//  Created by Lauri Leskinen on 5.1.2024.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
   
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
    @IBOutlet weak var infoButton: UIButton!
    
    var weatherMgr = WeatherMgr()
    let locationManager = CLLocationManager()
    
    // For info pane
    var cityNameInfo: String = ""
    var temperatureInfo: String = ""
    var feelsLikeInfo: String = ""
    var maxTempInfo: String = ""
    var minTempInfo: String = ""
    var pressureInfo: String = ""
    var humidityInfo: String = ""
    var windSpeedInfo: String = ""
    var windDirInfo: String = ""
    var windGustInfo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Delegates
        weatherMgr.delegate = self
        searchField.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        print("Info pressed")
        self.performSegue(withIdentifier: "goToInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToInfo" {
            let destinationVC = segue.destination as! InfoViewController
            destinationVC.cityName = cityNameInfo
            destinationVC.temperature = temperatureInfo
            destinationVC.feelsLike = feelsLikeInfo
            destinationVC.maxTemp = maxTempInfo
            destinationVC.minTemp = minTempInfo
            destinationVC.humidity = humidityInfo
            destinationVC.pressure = pressureInfo
            destinationVC.windSpeed = windSpeedInfo
            destinationVC.windDir = windDirInfo
            destinationVC.windGust = windGustInfo
        }
    }

}

// MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
    // Process pressing of Return button on keypad
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
}

// MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel) {
        cityNameInfo = weather.cityName
        temperatureInfo = weather.temperatureString
        feelsLikeInfo = weather.feelsLikeString
        maxTempInfo = weather.temp_maxString
        minTempInfo = weather.temp_minString
        pressureInfo = weather.pressureString
        humidityInfo = weather.humidityString
        windSpeedInfo = weather.windSpeedString
        windDirInfo = weather.windDirString
        windGustInfo = weather.windGustString
        
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.weatherSymbolImageView.image = UIImage(systemName: weather.conditionName)
            self.feelsLikeTempLabel.text = weather.feelsLikeString
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat,lon)
            weatherMgr.fetchWeatherData(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
