//
//  AppDelegate.m
//  PNContentExtension
//
//  Created by Ramachandra Naragund on 21/06/17.
//  Copyright © 2017 Ramachandra Naragund. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate () <UNUserNotificationCenterDelegate>

@property (nonatomic, strong) NSDictionary * apsDictionary;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    // Request for authorization to register for remote notification
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionSound |
                                                                                           UNAuthorizationOptionAlert |
                                                                                           UNAuthorizationOptionBadge)
                                                                        completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            
            [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];  // Subscribe to the UNUserNotificationCenterDelegate, needed to handle notification action callbacks
            [[UIApplication sharedApplication] registerForRemoteNotifications]; //Register for remote notifications
            
        }
    }];
    
    return YES;
}


#pragma mark - Notification registration

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%s",__func__);
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"DEVICE TOKEN : %@",token);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%s",__func__);
    NSLog(@"Error : %@",error.debugDescription);
}


#pragma mark - Notification recieve

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"%s",__func__);
    NSLog(@"USERINFO : %@",userInfo);
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)())completionHandler {
    
    
    if ([response.actionIdentifier isEqualToString:@"Open"]) { //response.actionIdentifier should match the action-Id what is been given during the UNNotificationAction creation for the respective category
        NSLog(@"Open action clicked");
        
    } else if ([response.actionIdentifier isEqualToString:@"Read later"]) {
        NSLog(@"Read later action clicked");
    }
    
    completionHandler();
    
}

#pragma mark - Application life cycle methods

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
