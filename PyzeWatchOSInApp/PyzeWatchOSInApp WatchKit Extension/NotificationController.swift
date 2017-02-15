import WatchKit
import Foundation
import UserNotifications
import Pyze


class NotificationController: WKUserNotificationInterfaceController {

    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: - WatchOS2
    
    override func didReceiveRemoteNotification(_ remoteNotification: [AnyHashable : Any], withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Void) {
        
        if let aps = remoteNotification["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let title = alert["title"] as? NSString {
                    if let body = alert["body"] as? NSString {
                        
                        
                        let alert:WKAlertAction = WKAlertAction(title: "OK", style: .default, handler: {
                            print("Alert action 'OK' performed")
                        })
                        let actions = [alert]
                        self.presentAlert(withTitle: title as String, message: body as String, preferredStyle: .alert, actions: actions)
                        
                        Pyze.processReceivedRemoteNotification(remoteNotification)
                    }
                }
            }
        }
        
    }
    

    // MARK: - WatchOS3
    
    @available(watchOSApplicationExtension 3.0, *)
    override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Swift.Void) {
        
        
        let userInfo = notification.request.content.userInfo
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let title = alert["title"] as? NSString {
                    if let body = alert["body"] as? NSString {
                        
                        let alert:WKAlertAction = WKAlertAction(title: "OK", style: .default, handler: {
                            print("Alert action 'OK' performed")
                        })
                        let actions = [alert]
                        self.presentAlert(withTitle: title as String, message: body as String, preferredStyle: .alert, actions: actions)
                        
                        
                        Pyze.processReceivedRemoteNotification(userInfo)
                    }
                }
            }
        }
        
        
        completionHandler(.custom)
    }
    
}
