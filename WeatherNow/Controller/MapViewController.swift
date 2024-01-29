//
//  MapViewController.swift
//  WeatherNow
//
//  Created by Lauri Leskinen on 26.1.2024.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var cityName: String?
    var latitude: Double?
    var longitude: Double?
    
    @IBOutlet var mapView: MKMapView!
   
    override func viewDidLoad() {
        locateCity()
    }
    
    func locateCity() {
        
        let latitude: CLLocationDegrees = latitude!
        let longitude: CLLocationDegrees = longitude!
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = cityName
        mapItem.openInMaps(launchOptions: options)
    }
}
