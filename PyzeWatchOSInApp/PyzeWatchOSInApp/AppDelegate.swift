import UIKit
import Pyze
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    // MARK: - App life cycle
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
         Pyze.initialize("", withLogThrottling: .PyzelogLevelMinimal)
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 10, *) {
            
            let notificationCenter : UNUserNotificationCenter = UNUserNotificationCenter.current()
            notificationCenter.delegate = self
            notificationCenter.requestAuthorization(options: [.sound, .badge, .alert, .carPlay], completionHandler: { (accessGranted, error) in
                
                if nil == error {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            })
            
        } else {
            
            let types: UIUserNotificationType = [.alert, .badge, .sound]
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    // MARK: - Push notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEVICE TOKEN : \(String(data: deviceToken, encoding: .utf8) ?? "")")
        
        Pyze.setRemoteNotificationDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("REMOTE NOTIFICATION REGISTRATION FAILED!!! : \(error.localizedDescription)")
    }
    
    // MARK: - iOS9 and below
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let title = alert["title"] as? NSString {
                    if let body = alert["body"] as? NSString {
                        
                        print("Push Notification Recieved!!!")
                        print("Title: \(title), Message: \(body)")
                        
                        Pyze.processReceivedRemoteNotification(userInfo)
                    }
                }
            }
        }
    }
    
    // MARK: - iOS10
    
    @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        let userInfo = response.notification.request.content.userInfo
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let title = alert["title"] as? NSString {
                    if let body = alert["body"] as? NSString {
                        
                        print("Push Notification Recieved!!!")
                        print("Title: \(title), Message: \(body)")
                        
                        Pyze.processReceivedRemoteNotification(userInfo)
                    }
                }
            }
        }
        
    }
    
}

