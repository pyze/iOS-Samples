//
//  AppDelegate.m
//  PyzeRichInteractivePushSampleApp
//
//  Created by Anoop Athmaram Gunaga on 26/10/17.
//  Copyright © 2017 Anoop Athmaram Gunaga. All rights reserved.
//

#import "AppDelegate.h"
#import <Pyze/Pyze.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

// MARK:
// MARK: Launch setup

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


// MARK:
// MARK: Registering to remote notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [Pyze setRemoteNotificationDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@",error.localizedDescription);
}


// MARK:
// MARK: Handling recieved push notifications
// MARK: iOS 10 and above

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    // This method will get called when
    // - app is in BACKGROUND or TERMINATED state
    // - for iOS 10 and above devices
    // - for both 'interactive action' and 'default notification tap'
    // -------------------------------------------------------------------------------------------------------------------
 
    completionHandler();
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
        completionHandler(UNNotificationPresentationOptionAlert);
}

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
