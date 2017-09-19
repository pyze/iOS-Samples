

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import <Pyze/Pyze.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Pyze initialize:@"<PYZE APP KEY>" withLogThrottling:PyzelogLevelAll];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if ([UNUserNotificationCenter instancesRespondToSelector:@selector(requestAuthorizationWithOptions:completionHandler:)]) {
        
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionSound |
                                                                                               UNAuthorizationOptionAlert |
                                                                                               UNAuthorizationOptionBadge)
                                                                            completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                                                                
                                                                                if (!error) {
                         
                                                                                    //If the app make use of default notification categories provided by Pyze call 'getPyzeDefaultNotificationCategories' method to get the categories and set it.
                                                                                    // You can also include the custom categories defined along with these, if any.
                                                                                    NSSet *pyzeDefaultCategorySet = [PyzeNotification getPyzeDefaultNotificationCategories];
                                                                                    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:pyzeDefaultCategorySet];
                                                                                    
                                                                                    [[UIApplication sharedApplication] registerForRemoteNotifications];
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
        [application registerForRemoteNotifications];
    }
    
    return YES;
}


#pragma mark - Remote notification registration

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"DEVICE TOKEN : %@",token);
    [Pyze setRemoteNotificationDeviceToken:deviceToken];
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error : %@",error.debugDescription);
}



#pragma mark - iOS 10 and above

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    // Call below Pyze SDK method in order to handle the selected notification action by Pyze SDK.
    [PyzeNotification handlePushNotificationResponseWithUserinfo:response.notification.request.content.userInfo
                                                actionIdentifier:response.actionIdentifier];
    
    
    /*

     OR
     
    // Call below Pyze SDK method to get the notification payload parsed as a 'PyzeNotificationContent' object and proceed further.
    [PyzeNotification parsePushNotificatoinResponseWithUserinfo:response.notification.request.content.userInfo
                                               actionIdentifier:response.actionIdentifier
                                              completionHandler:^(PyzeNotificationContent *pyzePushObject) {
                                                  
                                                  if (pyzePushObject) {
                                                    
                                                      NSLog(@"\n\n******************************************************");
                                                      NSLog(@"******************************************************");
                                                      NSLog(@"*** Pyze Push Notification Objsect ***");
                                                      NSLog(@"******************************************************\n");
                                                      
                                                      NSLog(@"Title : %@", pyzePushObject.title);
                                                      NSLog(@"SubTitle : %@", pyzePushObject.subTitle);
                                                      NSLog(@"Body : %@", pyzePushObject.body);
                                                      NSLog(@"MediaURL : %@", pyzePushObject.mediaURL);
                                                      NSLog(@"Category : %@", pyzePushObject.categoryIdentifier);
                                                      
                                                      if (pyzePushObject.selectedAction) {
                                                          NSLog(@"------------------------------------------------------");
                                                          NSLog(@"*** Selected Action ***");
                                                          NSLog(@"Selected Action name : %@\n",pyzePushObject.selectedAction.buttonName);
                                                          NSLog(@"Selected Action identifier : %@",pyzePushObject.selectedAction.buttonActionIdentifier);
                                                          NSLog(@"Selected Action type : %@",pyzePushObject.selectedAction.buttonActionTypeString);
                                                          NSLog(@"WebPageURL : %@",pyzePushObject.selectedAction.webPageURL);
                                                          NSLog(@"DeepLinkURL : %@",pyzePushObject.selectedAction.deepLinkURL);
                                                          NSLog(@"ShareText : %@",pyzePushObject.selectedAction.shareText);
                                                          NSLog(@"------------------------------------------------------");
                                                      }
                                                      
                                                      
                                                      NSLog(@"All actions : %@",pyzePushObject.allActions);
                                                      
                                                      NSLog(@"******************************************************");
                                                      NSLog(@"******************************************************\n\n");
                                                      
                                                  }
                                                  
                                              }];
     */
    
    
    completionHandler();
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNNotificationPresentationOptionAlert);
}

#pragma mark - iOS 8 and 9

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Call below Pyze SDK method to get the notification payload parsed as a 'PyzeNotificationContent' object and proceed further.
    [PyzeNotification parsePushNotificatoinResponseWithUserinfo:userInfo
                                              completionHandler:^(PyzeNotificationContent *pyzePushObject) {
                                                  
                                                  if (pyzePushObject) {
                                                      
                                                      NSLog(@"\n\n******************************************************");
                                                      NSLog(@"******************************************************");
                                                      NSLog(@"*** Pyze Push Notification Objsect ***");
                                                      NSLog(@"******************************************************\n");
                                                      
                                                      NSLog(@"Title : %@", pyzePushObject.title);
                                                      NSLog(@"SubTitle : %@", pyzePushObject.subTitle);
                                                      NSLog(@"Body : %@", pyzePushObject.body);
                                                      NSLog(@"MediaURL : %@", pyzePushObject.mediaURL);
                                                      NSLog(@"Category : %@", pyzePushObject.categoryIdentifier);
                                                      
                                                      if (pyzePushObject.selectedAction) {
                                                          NSLog(@"------------------------------------------------------");
                                                          NSLog(@"*** Selected Action ***");
                                                          NSLog(@"Selected Action name : %@\n",pyzePushObject.selectedAction.buttonName);
                                                          NSLog(@"Selected Action identifier : %@",pyzePushObject.selectedAction.buttonActionIdentifier);
                                                          NSLog(@"Selected Action type : %@",pyzePushObject.selectedAction.buttonActionTypeString);
                                                          NSLog(@"WebPageURL : %@",pyzePushObject.selectedAction.webPageURL);
                                                          NSLog(@"DeepLinkURL : %@",pyzePushObject.selectedAction.deepLinkURL);
                                                          NSLog(@"ShareText : %@",pyzePushObject.selectedAction.shareText);
                                                          NSLog(@"------------------------------------------------------");
                                                      }
                                                      
                                                      NSLog(@"All actions : %@",pyzePushObject.allActions);
                                                      
                                                      NSLog(@"******************************************************");
                                                      NSLog(@"******************************************************\n\n");
                                                      
                                                  }
                                                  
                                              }];
    
    /*
     
     OR
     
     If you have any action type set for the default tap of the notification in Pyze dashboard and if you want Pyze to handle the action when app launched from push, can call "handlePushNotificationResponseWithUserinfo:actionIdentifier:" method with 'k_PyzeDefaultNotificationAction' as action identifier
    
     [PyzeNotification handlePushNotificationResponseWithUserinfo:userInfo actionIdentifier:k_PyzeDefaultNotificationAction];
     
     */
    
}



-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(nonnull NSDictionary *)userInfo completionHandler:(nonnull void (^)())completionHandler {
    
    // Call below Pyze SDK method in order to handle the selected notification action by Pyze SDK.
    [PyzeNotification handlePushNotificationResponseWithUserinfo:userInfo
                                                actionIdentifier:identifier];
    
    
    /*
     
     OR
    
    // Call below Pyze SDK method to get the notification payload parsed as a 'PyzeNotificationContent' object and proceed further.
    [PyzeNotification parsePushNotificatoinResponseWithUserinfo:userInfo
                                               actionIdentifier:identifier
                                              completionHandler:^(PyzeNotificationContent *pyzePushObject) {
                                                  
                                                  if (pyzePushObject) {
                                                    
                                                      NSLog(@"\n\n******************************************************");
                                                      NSLog(@"******************************************************");
                                                      NSLog(@"*** Pyze Push Notification Objsect ***");
                                                      NSLog(@"******************************************************\n");
                                                      
                                                      NSLog(@"Title : %@", pyzePushObject.title);
                                                      NSLog(@"SubTitle : %@", pyzePushObject.subTitle);
                                                      NSLog(@"Body : %@", pyzePushObject.body);
                                                      NSLog(@"MediaURL : %@", pyzePushObject.mediaURL);
                                                      NSLog(@"Category : %@", pyzePushObject.categoryIdentifier);
                                                      
                                                      if (pyzePushObject.selectedAction) {
                                                          NSLog(@"------------------------------------------------------");
                                                          NSLog(@"*** Selected Action ***");
                                                          NSLog(@"Selected Action name : %@\n",pyzePushObject.selectedAction.buttonName);
                                                          NSLog(@"Selected Action identifier : %@",pyzePushObject.selectedAction.buttonActionIdentifier);
                                                          NSLog(@"Selected Action type : %@",pyzePushObject.selectedAction.buttonActionTypeString);
                                                          NSLog(@"WebPageURL : %@",pyzePushObject.selectedAction.webPageURL);
                                                          NSLog(@"DeepLinkURL : %@",pyzePushObject.selectedAction.deepLinkURL);
                                                          NSLog(@"ShareText : %@",pyzePushObject.selectedAction.shareText);
                                                          NSLog(@"------------------------------------------------------");
                                                      }
                                                      
                                                      NSLog(@"All actions : %@",pyzePushObject.allActions);
                                                      
                                                      NSLog(@"******************************************************");
                                                      NSLog(@"******************************************************\n\n");
                                                      
                                                  }
                                                  
                                              }];
    */
    
    
    completionHandler();
}


#pragma mark - Handle deep link

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"%s",__func__);
    NSLog(@"Deep link URL : %@", url);
    return NO;
}

#pragma mark - Application life cycle


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
