

import UIKit
import UserNotifications
import Pyze

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        Pyze.initialize("<PYZE APP KEY>", withLogThrottling: .PyzelogLevelMinimal);
        return  true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                if granted == true {
                    
                    //If the app make use of default notification categories provided by Pyze call this to get the categories and set it.
                    // You can also include the custom categories defined along with these, if any.
                    
                    if let pyzeDefaultCategorySet = PyzeNotification.getPyzeDefaultNotificationCategories() as? Set<UNNotificationCategory> {
                        UNUserNotificationCenter.current().setNotificationCategories(pyzeDefaultCategorySet)
                    }
                    
                    UNUserNotificationCenter.current().delegate = self
                    application.registerForRemoteNotifications()
                }
            }
            
        } else {
            
            // If the app make use of default notification categories provided by Pyze call this to get the categories and set it.
            // You can also include the custom categories defined along with these, if any.
            
            if let pyzeDefaultCategorySet = PyzeNotification.getPyzeDefaultNotificationCategories() as? Set<UIUserNotificationCategory> {
                
                let userNotificationTypes = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: pyzeDefaultCategorySet)
                
                UIApplication.shared.registerUserNotificationSettings(userNotificationTypes)
            }
            
            application.registerForRemoteNotifications()
        }
        
        return true
    }

    
    // MARK: Register for remote notification
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map({ String(format: "%02.2hhx", $0)}).joined()
        print("DEVICE TOKEN : \(token)")
        Pyze.setRemoteNotificationDeviceToken(deviceToken)
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error in registering the device for remote notification : \(error.localizedDescription)");
    }
    
    // MARK:
    // MARK: Handling received notifications
    
    // MARK:
    // MARK: iOS 10 and above
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
        // Call below Pyze SDK method in order to handle the selected notification action by Pyze SDK.
        PyzeNotification.handlePushResponse(withUserinfo: response.notification.request.content.userInfo, actionIdentifier: response.actionIdentifier);
        
        
        /*
        
        OR
         
        // Call below Pyze SDK method to get the notification payload parsed as a 'PyzeNotificationContent' object and proceed further.
        PyzeNotification.parsePushNotificatoinResponse(withUserinfo: response.notification.request.content.userInfo, actionIdentifier: response.actionIdentifier) { (pyzePushObject) in
            if let pyzePushObject = pyzePushObject {
         
                print("\n\n******************************************************")
                print("******************************************************")
                print("*** Pyze Push Notification Object ***")
                print("******************************************************\n")
         
                print("Title : \(pyzePushObject.title ?? "")")
                print("SubTitle : \(pyzePushObject.subTitle ?? "")")
                print("Body : \(pyzePushObject.body)")
         
                if let mediaURL = pyzePushObject.mediaURL {
                    print("MediaURL : \(mediaURL)")
                }
         
                print("Category : \(pyzePushObject.categoryIdentifier ?? "")")
         
                if let selectedAction = pyzePushObject.selectedAction {
         
                    print("------------------------------------------------------")
                    print("*** Selected Action ***")
                    print("Selected Action name : \(selectedAction.buttonName ?? "")")
                    print("Selected Action identifier : \(selectedAction.buttonActionIdentifier ?? "")")
                    print("Selected Action type :\(selectedAction.buttonActionTypeString ?? "")")
         
                    if let webPageURL = selectedAction.webPageURL {
                        print("WebPageURL : \(webPageURL)")
                    }
         
                    if let deepLinkURL = selectedAction.deepLinkURL {
                        print("DeepLinkURL : \(deepLinkURL)")
                    }
         
                    print("ShareText : \(selectedAction.shareText ?? "")")
                    print("------------------------------------------------------")
         
                }
         
                print("All actions",pyzePushObject.allActions)
            }
        }
        */
        
        
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    
    // MARK:
    // MARK: iOS 8 and 9
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        // Call below Pyze SDK method to get the notification payload parsed as a 'PyzeNotificationContent' object and proceed further.
        PyzeNotification.parsePushNotificatoinResponse(withUserinfo: userInfo) { (pyzePushObject) in
            if let pyzePushObject = pyzePushObject {
                
                print("\n\n******************************************************")
                print("******************************************************")
                print("*** Pyze Push Notification Objsect ***")
                print("******************************************************\n")
                
                print("Title : \(pyzePushObject.title ?? "")")
                print("SubTitle : \(pyzePushObject.subTitle ?? "")")
                print("Body : \(pyzePushObject.body)")
                
                if let mediaURL = pyzePushObject.mediaURL {
                    print("MediaURL : \(mediaURL)")
                }
                
                print("Category : \(pyzePushObject.categoryIdentifier ?? "")")
                
                if let selectedAction = pyzePushObject.selectedAction {
                    print("------------------------------------------------------")
                    print("*** Selected Action ***")
                    print("Selected Action name : \(selectedAction.buttonName ?? "")")
                    print("Selected Action identifier : \(selectedAction.buttonActionIdentifier ?? "")")
                    print("Selected Action type :\(selectedAction.buttonActionTypeString ?? "")")
                    
                    if let webPageURL = selectedAction.webPageURL {
                        print("WebPageURL : \(webPageURL)")
                    }
                    
                    if let deepLinkURL = selectedAction.deepLinkURL {
                        print("DeepLinkURL : \(deepLinkURL)")
                    }
                    
                    print("ShareText : \(selectedAction.shareText ?? "")")
                    print("------------------------------------------------------")
                }
                print("All actions : \(pyzePushObject.allActions)")
            }
            
        }
 
        
        /*
         OR
         
        If you have any action type set for the 'default tap' of the notification in Pyze dashboard and if you want Pyze to handle the action when app launched from push, can call "handlePushResponse(withUserinfo:actionIdentifier:)" method with 'k_PyzeDefaultNotificationAction' as action identifier parameter
        
         PyzeNotification.handlePushResponse(withUserinfo: userInfo, actionIdentifier: k_PyzeDefaultNotificationAction);
         */
    }
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        
        // Call below Pyze SDK method in order to handle the selected notification action by Pyze SDK.
        PyzeNotification.handlePushResponse(withUserinfo: userInfo, actionIdentifier: identifier);
        
        
        /*
 
         OR
        
        // Call below Pyze SDK method to get the notification payload parsed as a 'PyzeNotificationContent' object and proceed further.
        PyzeNotification.parsePushNotificatoinResponse(withUserinfo: userInfo, actionIdentifier: identifier) { (pyzePushObject) in
         
            if let pyzePushObject = pyzePushObject {
         
                print("\n\n******************************************************")
                print("******************************************************")
                print("*** Pyze Push Notification Objsect ***")
                print("******************************************************\n")
         
                print("Title : \(pyzePushObject.title ?? "")")
                print("SubTitle : \(pyzePushObject.subTitle ?? "")")
                print("Body : \(pyzePushObject.body)")
         
                if let mediaURL = pyzePushObject.mediaURL {
                    print("MediaURL : \(mediaURL)")
                }
         
                print("Category : \(pyzePushObject.categoryIdentifier ?? "")")
         
                if let selectedAction = pyzePushObject.selectedAction {
                    print("------------------------------------------------------")
                    print("*** Selected Action ***")
                    print("Selected Action name : \(selectedAction.buttonName ?? "")")
                    print("Selected Action identifier : \(selectedAction.buttonActionIdentifier ?? "")")
                    print("Selected Action type :\(selectedAction.buttonActionTypeString ?? "")")
         
                    if let webPageURL = selectedAction.webPageURL {
                        print("WebPageURL : \(webPageURL)")
                    }
         
                    if let deepLinkURL = selectedAction.deepLinkURL {
                        print("DeepLinkURL : \(deepLinkURL)")
                    }
         
                    print("ShareText : \(selectedAction.shareText ?? "")")
                    print("------------------------------------------------------")
                }
                print("All actions \(pyzePushObject.allActions)")
            }
         
        }
         */
        
        completionHandler()
    }
    
    // MARK:
    // MARK: Handle deep link
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("Deep link URL : \(url)")
        return false
    }
    
    
    // MARK:
    // MARK: Application life cycle
    
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


}
