//
//  ViewController.swift
//  Soulab
//
//  Created by Jabir Momin on 12/11/19.
//  Copyright © 2019 Yash Barot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var location: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
    }

    @IBAction func click_Start(_ sender: UIButton) {
        var locationManager = LocationManager.sharedInstance
        locationManager.showVerboseMessage = true
        locationManager.autoUpdate = true
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            
            print("lat:\(latitude) lon:\(longitude) status:\(status) error:\(error)")
            
            print(verboseMessage)
            
            //var locationManager = LocationManager.sharedInstance
            locationManager.reverseGeocodeLocationWithLatLon(latitude: latitude, longitude: longitude) { (reverseGecodeInfo,placemark,error) -> Void in
                
                if(error != nil){
                    
                    print(error)
                }else{
                    if let address : String = reverseGecodeInfo!["formattedAddress"] as! String {
                        self.location.text = address
                    }
                    
                    print(reverseGecodeInfo!)
                }
                
            }
            
        }
        
    }

}

