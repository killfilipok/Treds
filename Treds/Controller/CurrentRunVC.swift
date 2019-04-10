//
//  OnRunVC.swift
//  Treds
//
//  Created by Philip on 3/26/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import UIKit
import MapKit

class CurrentRunVC: LocationVC {
    
    @IBOutlet weak var swipeBgImg: UIImageView!
    @IBOutlet weak var sliderImg: UIImageView!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var timer = Timer()
    var runDistance = 0.0
    var peace = 0
    var timeCounter = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        sliderImg.addGestureRecognizer(swipeGesture)
        sliderImg.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
    }
    
    func startRun(){
        manager?.startUpdatingLocation()
        startTimer()
        pauseBtn.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
    }
    
    func startTimer(){
        durationLbl.text = timeCounter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCpunter(_:)), userInfo: nil, repeats: true)
    }
    
    func endRun(){
        manager?.stopUpdatingLocation()
        //add Obj to Realm
    }
    
    func pauseRun(){
        manager?.stopUpdatingLocation()
        timer.invalidate()
        pauseBtn.setImage(#imageLiteral(resourceName: "resumeButton"), for: .normal)
        startLocation = nil
        lastLocation = nil
    }
    
    @objc func updateCpunter(_ sender: Any){
        timeCounter += 1
        durationLbl.text = timeCounter.formatTimeDurationToString()
    }
    
    func calculatePeace(time seconds: Int, miles: Double) -> String{
        peace = Int(Double(seconds) / miles)
        return peace.formatTimeDurationToString()
    }
    
    @IBAction func pauseBtnPressed(_ sender: Any) {
        if timer.isValid {
            pauseRun()
        } else {
            startRun()
        }
    }
    
    @objc func onSwipe(_ sender: UIPanGestureRecognizer){
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat = 130
        
        if let sliderView = sender.view {
            if sender.state == .began || sender.state == .changed{
                let translation = sender.translation(in: self.view)
                if sliderView.center.x >= swipeBgImg.center.x - minAdjust && sliderView.center.x <= swipeBgImg.center.x + maxAdjust{
                    var targetPos = sliderView.center.x + translation.x
                    
                    if targetPos < swipeBgImg.center.x - maxAdjust {
                        targetPos = swipeBgImg.center.x - minAdjust
                    }
                    
                    sliderView.center.x = targetPos
                } else if sliderView.center.x >= swipeBgImg.center.x + maxAdjust {
                    sliderView.center.x = swipeBgImg.center.x + maxAdjust
                    endRun()
                    dismiss(animated: true, completion: nil)
                } else  {
                    sliderView.center.x = swipeBgImg.center.x - minAdjust
                }
                
                sender.setTranslation(CGPoint.zero, in: self.view)
            } else if sender.state == .ended {
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.swipeBgImg.center.x - minAdjust
                }
            }
        }
    }
}
extension CurrentRunVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLoctionAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation  == nil {
           startLocation = locations.first
        } else if let location = locations.last {
           runDistance += lastLocation.distance(from: location)
           distanceLbl.text = "\(runDistance.metersToMiles(places: 2))"
            if timeCounter > 0 && runDistance > 0 {
                paceLbl.text = calculatePeace(time: timeCounter, miles: runDistance.metersToMiles(places: 2))
            }
        }
        lastLocation = locations.last
    }
}
