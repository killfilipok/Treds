//
//  RealmConfig.swift
//  Treds
//
//  Created by Philip on 4/11/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig {
    
    static var runDataConfig : Realm.Configuration {
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)
        
        let config = Realm.Configuration(
            fileURL: realmPath,  schemaVersion: 0,migrationBlock: { (migration, oldSchemaVersion) in
                if oldSchemaVersion < 0 {
                    
                }}
        )
        
        return config
    }
}
