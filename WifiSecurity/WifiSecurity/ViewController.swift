//
//  ViewController.swift
//  WifiSecurity
//
//  Created by Mayuraa on 08/12/23.
//

import UIKit
import CoreLocation
import NetworkExtension
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork



class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var imgView: UIImageView!
    var locationManger = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManger.delegate = self
        locationManger.requestAlwaysAuthorization()
        locationManger.startMonitoringSignificantLocationChanges()
        locationManger.startUpdatingLocation()
        callLocation()
        imgView.isHidden = true
    }
    
    

    func callLocation(){
        DispatchQueue.global().async {
            
            if CLLocationManager.locationServicesEnabled() {

                let locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.distanceFilter = kCLDistanceFilterNone
                locationManager.startUpdatingLocation()
                
                if #available(iOS 14.0, *) {
                    DispatchQueue.main.async {
                        self.imgView.isHidden = false
                    }
                    let status = CLLocationManager.authorizationStatus
                    if status() == .authorizedAlways {
                        print("Allowed")
                   
                    }else if status() == .authorizedWhenInUse{
                        print("Allowed When in use ")
                    } else if status() == .denied {
                        exit(0)
                        print("Denied")
                }}
           }}
       }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        print("locations:\(locations)")
        if #available(iOS 15.0, *) {
        NEHotspotNetwork.fetchCurrent(completionHandler: { (network) in
            if let unwrappedNetwork = network {
                let networkSSID = unwrappedNetwork.ssid
                let securitySSID = unwrappedNetwork.securityType.rawValue
                let networkSsidType = (securitySSID == 0) ? "Open Network" : "Secure Network"
                print("WIFI TYPE is :::: \(networkSsidType)")
            } else {
                print("No available network")
            }
         })
      }
    }
    

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:\(error)")
        
    }
}

 //NOTE: SIGNING  Capability : 1)NEtwork Extension  2)Access WiFi Information Entitlement" (see here) and

//NOTe: Dont forget to Additional things  -><   Info.plist
//is one of 1) Core Location , 2) using NEHotspotConfiguration to connect current Wi-Fi Network, and 3) VPN app.
