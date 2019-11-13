//
//  ViewController.swift
//  Soulab
//
//  Created by Jabir Momin on 12/11/19.
//  Copyright © 2019 Yash Barot. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import MapKit

class DistanceViewController: UIViewController {
 @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var labelDis: UILabel!
    var currentLatitude:Double?
    var currentLongitude:Double?
     var locationManager = LocationManager.sharedInstance
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var startDate: Date!
    var traveledDistance: Double = 0
    var tempTraveledDistance: Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       UNUserNotificationCenter.current().delegate = self
       
       
    }

    func fireNotification(dis: Double) {
        
        
        let content = UNMutableNotificationContent()
        let requestIdentifier = "rajanNotification"
        
        content.badge = 1
        content.title = "Distance"
        content.subtitle = "Total Distance : \(self.traveledDistance)"
        content.body = "\(Date())"
        content.categoryIdentifier = "actionCategory"
        content.sound = UNNotificationSound.default
        
        // If you want to attach any image to show in local notification
//        let url = Bundle.main.url(forResource: "notificationImage", withExtension: ".jpg")
//        do {
//            let attachment = try? UNNotificationAttachment(identifier: requestIdentifier, url: url!, options: nil)
//            content.attachments = [attachment!]
//        }
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 3.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            
            if error != nil {
                print(error?.localizedDescription)
            }else{
                let userInfo = [ "total" : "\(self.traveledDistance)" , "dis" : "\(dis)" , "date" : Date()] as [String : Any]
//                let userInfo = [ "total" : traveledDistance ]

                NotificationCenter.default.post(name: .myNotificationKey, object: nil, userInfo: userInfo)

            }
            print("Notification Register Success")
            
        }
        
//        let center = UNUserNotificationCenter.current()
//        let options: UNAuthorizationOptions = [.alert, .sound];
//        center.requestAuthorization(options: options) { (granted, error) in
//            if !granted {
//                print("Something went wrong")
//            }
//        }
//        center.getNotificationSettings { (settings) in
//            if settings.authorizationStatus != .authorized {
//                // Notifications not allowed
//            }
//        }
//        let content = UNMutableNotificationContent()
//        content.title = "Distance "
//        content.body = "Total Distance : \(self.traveledDistance)"
//        content.sound = UNNotificationSound.default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//
//        let identifier = "UYLLocalNotification"
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
//            if let error = error {
//                // Something went wrong
////                let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
////                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
////                self.present(alert, animated: true, completion: nil)
//            }else{
////                let alert = UIAlertController(title: "Success", message: "Total Distance : \(self.traveledDistance)", preferredStyle: UIAlertController.Style.alert)
////                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
////                self.present(alert, animated: true, completion: nil)
//            }
//        })
////        center.add(request, withCompletionHandler: { (error) in
////            if let error = error {
////                // Something went wrong
////                let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
////                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
////                self.present(alert, animated: true, completion: nil)
////            }else{
////                let alert = UIAlertController(title: "Success", message: "Total Distance : \(self.traveledDistance)", preferredStyle: UIAlertController.Style.alert)
////                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
////                self.present(alert, animated: true, completion: nil)
////            }
////
////        })

    }
    
    @IBAction func click_Start(_ sender: UIButton) {
//        sender.isHidden = true
        locationManager.showVerboseMessage = true
        locationManager.autoUpdate = true
        locationManager.startNewUpdatingLocationWithCompletionHandler { (manager, locations) in
            if self.startDate == nil {
                self.startDate = Date()
            } else {
                print("elapsedTime:", String(format: "%.0fs", Date().timeIntervalSince(self.startDate)))
            }
            if self.startLocation == nil {
                self.startLocation = locations.first
            } else if let location = locations.last {
                self.traveledDistance += self.lastLocation.distance(from: location)
                 self.tempTraveledDistance += self.lastLocation.distance(from: location)
                if self.tempTraveledDistance > 50 {
                    self.fireNotification(dis: self.tempTraveledDistance)
                    self.tempTraveledDistance = 0.0
                }
                print("Traveled Distance:",  self.traveledDistance)
                print("Straight Distance:", self.startLocation.distance(from: locations.last!))
                self.labelDis.text = "\(self.traveledDistance) Meters"
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.map.setRegion(region, animated: true)
            }
            self.lastLocation = locations.last
        }
        
    }
    
}

extension DistanceViewController: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }
    
}
