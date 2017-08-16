//
//  ReachabilityManager.swift
//  Shirt Store
//
//  Created by Sergey S. on 16/08/2017.
//  Copyright © 2017 Unwire. All rights reserved.
//

import UIKit
import ReachabilitySwift


class ReachabilityManager: NSObject {

    static let shared = ReachabilityManager()

    var isNetworkAvailable : Bool {
        return reachabilityStatus != .notReachable
    }
    
    private var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    
    private let reachability = Reachability()!
    
    
    /// Called whenever there is a change in NetworkReachibility Status
    ///
    /// — parameter notification: Notification with the Reachability instance
    func reachabilityChanged(notification: Notification) {
        
        let reachability = notification.object as! Reachability
        
        reachabilityStatus = reachability.currentReachabilityStatus
        
        if reachabilityStatus == .notReachable {
            let alertController = UIAlertController(title: "No Internet Connection",
                                                    message: "To send the order you need an internet connection.",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "Ok",
                                         style: UIAlertActionStyle.default,
                                         handler: nil)
            
            alertController.addAction(okAction)
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                topController.present(alertController, animated: true, completion: nil)
            }
        }

    }
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            //debug
            print("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: ReachabilityChangedNotification,
                                                  object: reachability)
    }
}
