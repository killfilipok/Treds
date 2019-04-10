//
//  Run.swift
//  Treds
//
//  Created by Philip on 4/10/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import RealmSwift

class Run: Object {
    @objc dynamic public private(set) var id = ""
    @objc dynamic public private(set) var date = NSDate()
    @objc dynamic public private(set) var pace = 0
    @objc dynamic public private(set) var distance = 0.0
    @objc dynamic public private(set) var duration = 0
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override class func indexedProperties() -> [String]{
        return ["pace","duration", "date"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.duration = duration
        self.distance = distance
    }
}
