
#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Pyze initialize:@"" withLogThrottling:PyzelogLevelAll];
    return true;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        
        UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        notificationCenter.delegate = self;
        [notificationCenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionCarPlay | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (nil == error) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
            
        }];
        
    } else {
        
        UIUserNotificationType types = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
    
    
    return YES;
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

#pragma mark - Push notification Registration


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"DEVICE TOKEN : %@", [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding]);
    
    [Pyze setRemoteNotificationDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"REMOTE NOTIFICATION REGISTRATION FAILED!!! : %@", [error localizedDescription]);
}

#pragma mark - Handling Push notifications

#pragma mark - iOS10

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    
    NSDictionary *userInfo = [[notification.request.mutableCopy content] userInfo];
    NSDictionary *alertDict = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *title = [alertDict objectForKey:@"title"];
    NSString *message = [alertDict objectForKey:@"body"];
    
    NSLog(@"PUSH NOTIFICATION RECIEVED!!!");
    NSLog(@"TITLE : %@, \nMESSAGE : %@", title, message);
    
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    
    NSDictionary *userInfo = [[response.notification.request.mutableCopy content] userInfo];
    NSDictionary *alertDict = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *title = [alertDict objectForKey:@"title"];
    NSString *message = [alertDict objectForKey:@"body"];
    
    NSLog(@"PUSH NOTIFICATION RECIEVED!!!");
    NSLog(@"TITLE : %@, \nMESSAGE : %@", title, message);
    
    [Pyze processReceivedRemoteNotification:userInfo];
}

#pragma mark - iOS9 and below

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSDictionary *alertDict = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *title = [alertDict objectForKey:@"title"];
    NSString *message = [alertDict objectForKey:@"body"];
    
    NSLog(@"PUSH NOTIFICATION RECIEVED!!!");
    NSLog(@"TITLE : %@, \nMESSAGE : %@", title, message);
    
    [Pyze processReceivedRemoteNotification:userInfo];

}

@end
