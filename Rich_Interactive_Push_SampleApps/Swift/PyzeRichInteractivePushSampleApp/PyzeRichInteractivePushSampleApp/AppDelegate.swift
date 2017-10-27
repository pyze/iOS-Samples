
import UIKit
import UserNotifications
import Pyze

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    // MARK:
    // MARK: Launch setup
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Initialise Pyze with <YOUR APP KEY>
        Pyze.initialize("<YOUR APP KEY>", withLogThrottling: .PyzelogLevelAll)
        return true
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                if granted == true {
                    
                    //If the app make use of default notification categories provided by Pyze, call 'getPyzeDefaultNotificationCategories’ method to get the categories and set it.
                    // You can also include the custom categories defined along with these, if any.
                    
                    if let pyzeDefaultCategorySet = PyzeNotification.getPyzeDefaultNotificationCategories() as? Set<UNNotificationCategory> {
                        UNUserNotificationCenter.current().setNotificationCategories(pyzeDefaultCategorySet)
                    }
                    
                    UNUserNotificationCenter.current().delegate = self
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
            
        } else {
            
            // If the app make use of default notification categories provided by Pyze, call ‘getPyzeDefaultNotificationCategories’ to get the categories and set it.
            // You can also include the custom categories defined along with these, if any.
            
            if let pyzeDefaultCategorySet = PyzeNotification.getPyzeDefaultNotificationCategories() as? Set<UIUserNotificationCategory> {
                let userNotificationTypes = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: pyzeDefaultCategorySet)
                UIApplication.shared.registerUserNotificationSettings(userNotificationTypes)
            }
            
            application.registerForRemoteNotifications()
        }
        
        return true
    }
    
    // MARK:
    // MARK: Registering to remote notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //Send device token obtained from APNS to Pyze
        Pyze.setRemoteNotificationDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("\n\nFailed to register to remote notifications \(error.localizedDescription)")
    }
    
    
    // MARK:
    // MARK: Handling recieved push notifications
    // MARK: iOS 10 and above
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        // This method will get called when
        // - app is in BACKGROUND or TERMINATED state
        // - for iOS 10 and above devices
        // - for both 'interactive action' and 'default notification tap'
        // -------------------------------------------------------------------------------------------------------------------
        
        
        
        /* -----------------------------------------------------------------------------------------------------------------------------------------------------------------
              Possible ways to handle the recieved payload using Pyze SDK
 
             // Option 1 : */
         
             PyzeNotification.handlePushResponse(withUserinfo: response.notification.request.content.userInfo, actionIdentifier: response.actionIdentifier)
        
        /*
             // The above method does the following:
             // a. If the action selected is of type 'Share text', above method call will present a share dialog.
             // b. If the action selected is of type 'Follow Deeplink', above method call will process payload and give callback to the method :
                     func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {}
                     So implement this in your AppDelegate to handle it further
             // c. If the action selected is of type 'Open Webpage' the respective url will open in Safari.
         ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
        
        
        /*
        
             // Option 2 :
        
            PyzeNotification.parsePushNotificatoinResponse(withUserinfo: response.notification.request.content.userInfo, actionIdentifier: response.actionIdentifier) { (pyzePushObject) in
            
                if let pyzePushObject = pyzePushObject {
                    if let selectedAction = pyzePushObject.selectedAction {
                    
                        switch selectedAction.buttonActionType {
                            
                        case .ePyzeNotificationActionTypeShare:
                            guard let shareText = selectedAction.shareText else { print("No Share text available") }
                        case .ePyzeNotificationActionTypeDeepLink:
                            guard let deepLinkURL = selectedAction.deepLinkURL else { print("No Deep link url available") }
                        case .ePyzeNotificationActionTypeWebLink:
                            guard let shareText = selectedAction.shareText else { print("No web url available") }
                            
                        case .ePyzeNotificationActionTypeNone:
                            print("Action type : \(selectedAction.buttonActionTypeString)")
                        case .ePyzeNotificationActionTypeHome:
                            print("Action type : \(selectedAction.buttonActionTypeString)")
                        }
                    }
                }
         
             // The above method will parse the payload and return 'PyzeNotificationContent' object. from which the required info like 'share text' 'deep link url' or 'webpage url' can be obtained as shown above
         */
        
        completionHandler()
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // This method will get called when
        // - app is in ACTIVE state
        // - for iOS 10 and above devices
        // ----------------------------------------------------------------------------------------------------------------------------------
        completionHandler(.alert) // This line of code will make iOS show the notification as alert even if the application is in foreground.
    }
 
 
    // MARK:
    // MARK: iOS 8 and 9
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        // This method gets called
        // - when user taps on notification (not interactive action) and when app is ACTIVE
        // - for iOS 8 and 9 devices
        // ----------------------------------------------------------------------------------------------------------------------------------
        
        
        switch application.applicationState {
            
            case .active: print("App in foreground")
        
        /*
             - Since app is in foreground, there will be no action identifier. So can call below method to get the payload parsed.
             - Call 'PyzeNotification.parsePushNotificatoinResponse' without any action identifier, where Pyze will just parse the payload and return 'PyzeNotificationContent' object.
             - As no 'actionIdentifier' is passed here, 'selectedAction' will be 'nil'.
         */
        
                PyzeNotification.parsePushNotificatoinResponse(withUserinfo: userInfo) { (pyzePushObject) in
                    
                    if let pyzePushObject = pyzePushObject {
                        
                        print("\n\n******************************************************")
                        print("******************************************************")
                        print("*** Pyze Push Notification Objsect ***")
                        print("******************************************************\n")
                        
                        print("Title : \(pyzePushObject.title ?? "")")
                        print("SubTitle : \(pyzePushObject.subTitle ?? "")")
                        print("Body : \(pyzePushObject.body)")
                        
                        print("******************************************************\n")
                    }
                    
                }
        
            break
            
        default:
            /* -----------------------------------------------------------------------------------------------------------------------------------------------------------------
             Possible ways to handle the recieved payload using Pyze SDK
             
             // Option 1 : */
            
            PyzeNotification.handlePushResponse(withUserinfo: userInfo, actionIdentifier: k_PyzeDefaultNotificationAction)
            
            
            // 'k_PyzeDefaultNotificationAction' is the default action which can be used when notification is tapped
            
            /*
             // The above method does the following:
             // a. If the action selected is of type 'Share text', above method call will present a share dialog.
             // b. If the action selected is of type 'Follow Deeplink', above method call will process payload and give callback to the method :
                     func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {}
                     So implement this in your AppDelegate to handle it further
             // c. If the action selected is of type 'Open Webpage' the respective url will open in Safari.
             ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
            
            /*
             
             // Option 2 :
             
             PyzeNotification.parsePushNotificatoinResponse(withUserinfo: userInfo, actionIdentifier: k_PyzeDefaultNotificationAction) { (pyzePushObject) in
             
                 if let pyzePushObject = pyzePushObject {
                     if let selectedAction = pyzePushObject.selectedAction {
             
                         switch selectedAction.buttonActionType {
             
                         case .ePyzeNotificationActionTypeShare:
                             guard let shareText = selectedAction.shareText else { print("No Share text available") }
                         case .ePyzeNotificationActionTypeDeepLink:
                             guard let deepLinkURL = selectedAction.deepLinkURL else { print("No Deep link url available") }
                         case .ePyzeNotificationActionTypeWebLink:
                             guard let shareText = selectedAction.shareText else { print("No web url available") }
             
                         case .ePyzeNotificationActionTypeNone:
                             print("type : \(selectedAction.buttonActionTypeString)")
                         case .ePyzeNotificationActionTypeHome:
                             print("type : \(selectedAction.buttonActionTypeString)")
                     }
                 }
             }
             
             // The above method will parse the payload and return 'PyzeNotificationContent' object. from which the required info can be obtained.
             ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
            break
        }
    }
    
    
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        
        // This method will get called when
        // - app is in BACKGROUND or TERMINATED state
        // - for iOS 8 and 9 devices
        // - for both 'interactive actions'
        // -------------------------------------------------------------------------------------------------------------------
        
        
        
        /* -----------------------------------------------------------------------------------------------------------------------------------------------------------------
             Possible ways to handle the recieved payload using Pyze SDK
 
             // Option 1 : */
        
             PyzeNotification.handlePushResponse(withUserinfo:userInfo, actionIdentifier: identifier)
        
        /*
             // The above method does the following:
             // a. If the action selected is of type 'Share text', above method call will present a share dialog.
             // b. If the action selected is of type 'Follow Deeplink', above method call will process payload and give callback to the method :
                     func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {}
                     So implement this in your AppDelegate to handle it further
             // c. If the action selected is of type 'Open Webpage' the respective url will open in Safari.
         ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
        
        
        /*
        
             // Option 2 :
        
            PyzeNotification.parsePushNotificatoinResponse(withUserinfo: userInfo, actionIdentifier: identifier) { (pyzePushObject) in
         
                if let pyzePushObject = pyzePushObject {
                    if let selectedAction = pyzePushObject.selectedAction {
         
                        switch selectedAction.buttonActionType {
                        
                        case .ePyzeNotificationActionTypeShare:
                            guard let shareText = selectedAction.shareText else { print("No Share text available") }
                        case .ePyzeNotificationActionTypeDeepLink:
                            guard let deepLinkURL = selectedAction.deepLinkURL else { print("No Deep link url available") }
                        case .ePyzeNotificationActionTypeWebLink:
                            guard let shareText = selectedAction.shareText else { print("No web url available") }
                            
                        case .ePyzeNotificationActionTypeNone:
                            print("type : \(selectedAction.buttonActionTypeString)")
                        case .ePyzeNotificationActionTypeHome:
                            print("type : \(selectedAction.buttonActionTypeString)")
                        }
                    }
                }
         
             // The above method will parse the payload and return 'PyzeNotificationContent' object. from which the required info like 'share text' 'deep link url' or 'webpage url' can be obtained as shown above
         */
        
            completionHandler()
    }
    
    
    // MARK:
    // MARK: Handling deep link

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("Deep link URL : \(url)")
        return false
    }
    
    // MARK:
    // MARK: App life cycle  methods
    
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
