//
//  BeginRunVC.swift
//  Treds
//
//  Created by Philip on 3/22/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class BeginRunVC: LocationVC {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lastRunView: UIView!
    @IBOutlet weak var lastRunPaceLbl: UILabel!
    @IBOutlet weak var lastRunDistanceLbl: UILabel!
    @IBOutlet weak var lastRunDurationLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoctionAuthStatus()
        print("RUNS: \(Run.getAllRuns())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate  = self
        mapView.delegate = self
        manager?.startUpdatingLocation()
        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpMapView()
    }
    
    func setUpMapView(){
        if let overlay = addLastRunToMap() {
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
            lastRunView.isHidden = false
        } else {
            lastRunView.isHidden = true
            centerMapOnUserLocation()
        }
    }
    
    func addLastRunToMap() -> MKPolyline?{
        guard let lastRun = Run.getAllRuns()?.first else {return nil}
        
        lastRunPaceLbl.text = "\(lastRun.pace.formatTimeDurationToString()) /ml"
        lastRunDistanceLbl.text = "\(lastRun.distance.metersToMiles(places: 2)) ml"
        lastRunDurationLbl.text = "\(lastRun.duration.formatTimeDurationToString())"
        
        var coordinats = [CLLocationCoordinate2D]()
        
        for location in lastRun.locations {
            coordinats.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        
        guard let locations = Run.getRun(byId: lastRun.id)?.locations else {
            return nil
        }
        
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapOnPreviusRoute(locations: locations), animated: true)
        
        return MKPolyline(coordinates: coordinats, count: coordinats.count)
    }
    
    func centerMapOnUserLocation(){
        mapView.userTrackingMode = .follow
        
        let coordinateRegion = MKCoordinateRegion.init(center: mapView.userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnPreviusRoute(locations: List<Location>) -> MKCoordinateRegion {
        guard let initialLoc = locations.first else {return MKCoordinateRegion()}
        
        var minLat = initialLoc.latitude
        var minLong = initialLoc.longitude
        
        var maxLat = minLat
        var maxLong = minLong
        
        for location in locations {
            minLat = min(minLat, location.latitude)
            minLong = min(minLong, location.longitude)
            maxLat = max(maxLat, location.latitude)
            maxLong = max(maxLong, location.longitude)
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (maxLat + minLat)/2, longitude: (maxLong + minLong)/2), span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.4 , longitudeDelta: (maxLong - minLong) * 1.4))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    @IBAction func lastRunCloseBtnPressed(_ sender: Any) {
        lastRunView.isHidden = true
        centerMapOnUserLocation()
    }
    
    @IBAction func locationCenterBtnPressed(_ sender: Any) {
        centerMapOnUserLocation()
    }
}

extension BeginRunVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLoctionAuthStatus()
            mapView.showsUserLocation = true
        } 
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let render = MKPolylineRenderer(polyline: polyline)
        
        render.strokeColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        render.lineWidth = 4
        
        return render
    }
}

