//
//  Location.swift
//  Treds
//
//  Created by Philip on 4/10/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic public private(set) var latitude = 0.0
    @objc dynamic public private(set) var longitude = 0.0
    
    convenience init(lat: Double, long: Double){
        self.init()
        self.latitude = lat
        self.longitude = long
    }
}
