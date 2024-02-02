//
//  ViewController.swift
//  WeatherNow
//
//  Created by Lauri Leskinen on 5.1.2024.
//

import UIKit
import CoreLocation
import CoreData

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
    
    @IBOutlet weak var savedLocations: UIPickerView!
    
    var weatherMgr = WeatherMgr()
    let locationManager = CLLocationManager()
    // CoreData
    var savedLocationsArray = [SavedLocation]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    var latitudeInfo: Double = 0.0
    var longitudeInfo: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocations()
       
        // Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Delegates
        weatherMgr.delegate = self
        searchField.delegate = self
        savedLocations.delegate = self
        
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToInfo", sender: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let location = cityNameInfo
        let alert = UIAlertController(title: "Add \(location)?", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            let newLocation = SavedLocation(context: self.context)
            newLocation.name = location
            
            self.savedLocationsArray.append(newLocation)
            
            self.saveLocation()
            self.loadLocations()
            self.savedLocations.reloadAllComponents()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToInfo" {
            let destinationVC = segue.destination as! InfoViewController
            destinationVC.cityName = cityNameInfo
            destinationVC.latitude = latitudeInfo
            destinationVC.longitude = longitudeInfo
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
        latitudeInfo = weather.latitude
        longitudeInfo = weather.longitude
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
    
    // MARK: - Data Manipulation Methods
    
    func saveLocation() {
        do {
            try context.save()
         } catch {
            print("Error saving context, \(error)")
        }
    }
    
    func loadLocations(with request: NSFetchRequest<SavedLocation> = SavedLocation.fetchRequest()) {
        do {
            savedLocationsArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherMgr.fetchWeatherData(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - UIPickerView DataSource & Delegate

extension WeatherViewController: UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return savedLocationsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return savedLocationsArray[row].name!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedLocation = savedLocationsArray[row].name!
        weatherMgr.fetchWeatherData(cityName: selectedLocation)
    }
}
