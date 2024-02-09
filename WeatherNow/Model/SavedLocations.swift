//
//  SavedLocations.swift
//  WeatherNow
//
//  Created by Lauri Leskinen on 9.2.2024.
//

import Foundation
import RealmSwift

class SavedLocations: Object {
    @objc dynamic var savedLocation: String = ""
}
