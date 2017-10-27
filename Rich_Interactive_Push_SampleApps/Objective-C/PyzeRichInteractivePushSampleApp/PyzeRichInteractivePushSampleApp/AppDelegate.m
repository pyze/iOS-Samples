
#import "AppDelegate.h"
#import <Pyze/Pyze.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

#pragma mark -
#pragma mark - Launch setup

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Initialise Pyze with <YOUR APP KEY>
    [Pyze initialize:@"<YOUR APP KEY>" withLogThrottling:PyzelogLevelAll];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if (@available(iOS 10, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionSound |
                                                                                               UNAuthorizationOptionAlert |
                                                                                               UNAuthorizationOptionBadge)
                                                                            completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                                                                
                                                                                if (!error) {
                                                                                    
                                                                                    //If the app make use of default notification categories provided by Pyze call 'getPyzeDefaultNotificationCategories' method to get the categories and set it.
                                                                                    // You can also include the custom categories defined along with these, if any.
                                                                                    NSSet *pyzeDefaultCategorySet = [PyzeNotification getPyzeDefaultNotificationCategories];
                                                                                    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:pyzeDefaultCategorySet];
                                                                                    
                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                        [application registerForRemoteNotifications];
                                                                                    });
                                                                                    
                                                                                }
                                                                                
                                                                            }];
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
        
    } else if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {

        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert
                                                        | UIUserNotificationTypeBadge
                                                        | UIUserNotificationTypeSound);

        // If the app make use of default notification categories provided by Pyze call 'getPyzeDefaultNotificationCategories' method to get the categories and set it.
        // You can also include the custom categories defined along with these, if any.
        NSSet *categories = [PyzeNotification getPyzeDefaultNotificationCategories];
        UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings
                                                                settingsForTypes:userNotificationTypes categories:categories];
        [application registerUserNotificationSettings:userNotificationSettings];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [application registerForRemoteNotifications];
        });
        
    }

    return YES;
}


#pragma mark -
#pragma mark - Registering to remote notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //Send device token obtained from APNS to Pyze
    [Pyze setRemoteNotificationDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n\nFailed to register to remote notifications\nError : %@\n\n",error.localizedDescription);
}


#pragma mark -
#pragma mark - Handling recieved push notifications
#pragma mark - iOS 10 and above

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler NS_AVAILABLE_IOS(10_0) {

    // This method will get called when
    // - app is in BACKGROUND or TERMINATED state
    // - for iOS 10 and above devices
    // - for both 'interactive action' and 'default notification tap'
    // -------------------------------------------------------------------------------------------------------------------

    /* -----------------------------------------------------------------------------------------------------------------------------------------------------------------
     Possible ways to handle the recieved payload using Pyze SDK

     // Option 1 : */

    [PyzeNotification handlePushNotificationResponseWithUserinfo:response.notification.request.content.userInfo actionIdentifier:response.actionIdentifier];

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

    [PyzeNotification parsePushNotificatoinResponseWithUserinfo:response.notification.request.content.userInfo actionIdentifier:response.actionIdentifier
                                              completionHandler:^(PyzeNotificationContent *pyzePushObject) {

                                                  if (pyzePushObject) {
                                                      if (pyzePushObject.selectedAction) {

                                                          switch (pyzePushObject.selectedAction.buttonActionType) {

                                                              case ePyzeNotificationActionTypeShare: {
                                                                  if (pyzePushObject.selectedAction.shareText && pyzePushObject.selectedAction.shareText.length) {
                                                                      NSLog(@"%@",pyzePushObject.selectedAction.shareText);
                                                                  }
                                                              }
                                                                  break;
                                                              case ePyzeNotificationActionTypeDeepLink: {
                                                                  if (pyzePushObject.selectedAction.deepLinkURL && pyzePushObject.selectedAction.deepLinkURL) {
                                                                      NSLog(@"%@",pyzePushObject.selectedAction.deepLinkURL);
                                                                  }
                                                              }
                                                                  break;
                                                              case ePyzeNotificationActionTypeWebLink: {
                                                                  if (pyzePushObject.selectedAction.webPageURL && pyzePushObject.selectedAction.webPageURL) {
                                                                      NSLog(@"%@",pyzePushObject.selectedAction.webPageURL);
                                                                  }
                                                              }
                                                                  break;

                                                              case ePyzeNotificationActionTypeHome: NSLog(@"%@",pyzePushObject.selectedAction.buttonActionTypeString);
                                                                  break;
                                                              case ePyzeNotificationActionTypeNone: NSLog(@"%@",pyzePushObject.selectedAction.buttonActionTypeString);
                                                                  break;

                                                              default:
                                                                  break;
                                                          }
                                                      }
                                                  }

    }];

      */


    completionHandler();
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler NS_AVAILABLE_IOS(10_0) {

    // This method will get called when
    // - app is in ACTIVE state
    // - for iOS 10 and above devices
    // ----------------------------------------------------------------------------------------------------------------------------------
    completionHandler(UNNotificationPresentationOptionAlert); // This line of code will make iOS show the notification as alert even if the application is in foreground.
}


#pragma mark -
#pragma mark - iOS 8 and 9

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // This method gets called
    // - when user taps on notification (not interactive action) and when app is ACTIVE
    // - for iOS 8 and 9 devices
    // ----------------------------------------------------------------------------------------------------------------------------------
    
    switch (application.applicationState) {
        case UIApplicationStateActive: {
            NSLog(@"App in foreground");
            
            /*
             - Since app is in foreground, there will be no action identifier. So can call below method to get the payload parsed.
             - Call 'PyzeNotification.parsePushNotificatoinResponse' without any action identifier, where Pyze will just parse the payload and return 'PyzeNotificationContent' object.
             - As no 'actionIdentifier' is passed here, 'selectedAction' will be 'nil'.
             */
            
            [PyzeNotification parsePushNotificatoinResponseWithUserinfo:userInfo completionHandler:^(PyzeNotificationContent *pyzePushObject) {
                
                NSLog(@"\n\n******************************************************");
                NSLog(@"\n\n******************************************************");
                NSLog(@"*** Pyze Push Notification Objsect ***");
                
                NSLog(@"Title : %@",pyzePushObject.title);
                NSLog(@"SubTitle : %@",pyzePushObject.subTitle);
                NSLog(@"Body : %@",pyzePushObject.body);
                
                NSLog(@"******************************************************\n");
                
            }];
        }
            break;
            
        default: {
            
            /* -----------------------------------------------------------------------------------------------------------------------------------------------------------------
             Possible ways to handle the recieved payload using Pyze SDK
             
             // Option 1 : */
            
            [PyzeNotification handlePushNotificationResponseWithUserinfo:userInfo actionIdentifier:k_PyzeDefaultNotificationAction];
            
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
            
            [PyzeNotification parsePushNotificatoinResponseWithUserinfo:userInfo actionIdentifier:k_PyzeDefaultNotificationAction
                                                      completionHandler:^(PyzeNotificationContent *pyzePushObject) {
                                                          
                                                          if (pyzePushObject) {
                                                              if (pyzePushObject.selectedAction) {
                                                                  
                                                                  switch (pyzePushObject.selectedAction.buttonActionType) {
                                                                          
                                                                      case ePyzeNotificationActionTypeShare: {
                                                                          if (pyzePushObject.selectedAction.shareText && pyzePushObject.selectedAction.shareText.length) {
                                                                              NSLog(@"%@",pyzePushObject.selectedAction.shareText);
                                                                          }
                                                                      }
                                                                          break;
                                                                      case ePyzeNotificationActionTypeDeepLink: {
                                                                          if (pyzePushObject.selectedAction.deepLinkURL && pyzePushObject.selectedAction.deepLinkURL) {
                                                                              NSLog(@"%@",pyzePushObject.selectedAction.deepLinkURL);
                                                                          }
                                                                      }
                                                                          break;
                                                                      case ePyzeNotificationActionTypeWebLink: {
                                                                          if (pyzePushObject.selectedAction.webPageURL && pyzePushObject.selectedAction.webPageURL) {
                                                                              NSLog(@"%@",pyzePushObject.selectedAction.webPageURL);
                                                                          }
                                                                      }
                                                                          break;
                                                                          
                                                                      case ePyzeNotificationActionTypeHome: NSLog(@"%@",pyzePushObject.selectedAction.buttonActionTypeString);
                                                                          break;
                                                                      case ePyzeNotificationActionTypeNone: NSLog(@"%@",pyzePushObject.selectedAction.buttonActionTypeString);
                                                                          break;
                                                                          
                                                                      default:
                                                                          break;
                                                                  }
                                                              }
                                                          }
                                                          
                                                      }];
             // The above method will parse the payload and return 'PyzeNotificationContent' object. from which the required info can be obtained.
             ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
            
        }
            break;
    }
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {

    // This method will get called when
    // - app is in BACKGROUND or TERMINATED state
    // - for iOS 8 and 9 devices
    // - for both 'interactive actions'
    // -------------------------------------------------------------------------------------------------------------------



    /* -----------------------------------------------------------------------------------------------------------------------------------------------------------------
     Possible ways to handle the recieved payload using Pyze SDK

     // Option 1 : */


    [PyzeNotification handlePushNotificationResponseWithUserinfo:userInfo actionIdentifier:identifier];

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

    [PyzeNotification parsePushNotificatoinResponseWithUserinfo:userInfo actionIdentifier:identifier
                                              completionHandler:^(PyzeNotificationContent *pyzePushObject) {

                                                  if (pyzePushObject) {
                                                      if (pyzePushObject.selectedAction) {

                                                          switch (pyzePushObject.selectedAction.buttonActionType) {

                                                              case ePyzeNotificationActionTypeShare: {
                                                                  if (pyzePushObject.selectedAction.shareText && pyzePushObject.selectedAction.shareText.length) {
                                                                      NSLog(@"%@",pyzePushObject.selectedAction.shareText);
                                                                  }
                                                              }
                                                                  break;
                                                              case ePyzeNotificationActionTypeDeepLink: {
                                                                  if (pyzePushObject.selectedAction.deepLinkURL && pyzePushObject.selectedAction.deepLinkURL) {
                                                                      NSLog(@"%@",pyzePushObject.selectedAction.deepLinkURL);
                                                                  }
                                                              }
                                                                  break;
                                                              case ePyzeNotificationActionTypeWebLink: {
                                                                  if (pyzePushObject.selectedAction.webPageURL && pyzePushObject.selectedAction.webPageURL) {
                                                                      NSLog(@"%@",pyzePushObject.selectedAction.webPageURL);
                                                                  }
                                                              }
                                                                  break;

                                                              case ePyzeNotificationActionTypeHome: NSLog(@"%@",pyzePushObject.selectedAction.buttonActionTypeString);
                                                                  break;
                                                              case ePyzeNotificationActionTypeNone: NSLog(@"%@",pyzePushObject.selectedAction.buttonActionTypeString);
                                                                  break;

                                                              default:
                                                                  break;
                                                          }
                                                      }
                                                  }
                                              }];

         // The above method will parse the payload and return 'PyzeNotificationContent' object. from which the required info like 'share text' 'deep link url' or 'webpage url' can be obtained as shown above
      */

}

#pragma -
#pragma mark - Handling deep link

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"\nDeep link URL : %@\n", url);
    return NO;
}

#pragma mark -
#pragma mark - App life cycle methods

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
