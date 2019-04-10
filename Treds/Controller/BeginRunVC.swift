//
//  BeginRunVC.swift
//  Treds
//
//  Created by Philip on 3/22/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import UIKit
import MapKit

class BeginRunVC: LocationVC {

    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoctionAuthStatus()
        mapView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate  = self
        manager?.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    @IBAction func locationCenterBtnPressed(_ sender: Any) {
        
    }
}

extension BeginRunVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLoctionAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        } 
    }
}

