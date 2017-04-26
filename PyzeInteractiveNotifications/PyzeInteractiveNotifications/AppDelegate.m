//
//  AppDelegate.m
//  PyzeInteractiveNotifications
//
//  Created by Ramachandra Naragund on 27/10/16.
//  Copyright © 2016 Pyze Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import <Pyze/Pyze.h>

NSString * const gCategory  = @"Category";
NSString * const gActionOne = @"ACTION_ONE";
NSString * const gActionTwo = @"ACTION_TWO";

@interface AppDelegate ()

@end

@implementation AppDelegate


-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Pyze initialize:@"plb7GPwDR6uLJk5-ABV_uw" withLogThrottling:PyzelogLevelAll];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    // Override point for customization after application launch.
    UIMutableUserNotificationAction * action = [[UIMutableUserNotificationAction alloc] init];
    action.title = @"Show meesage";
    action.activationMode = UIUserNotificationActivationModeBackground;
    action.destructive = YES;
    action.identifier = gActionOne;
    
    UIMutableUserNotificationAction * action2 = [[UIMutableUserNotificationAction alloc] init];
    action2.title = @"Show meesage2";
    action2.activationMode = UIUserNotificationActivationModeBackground;
    action2.destructive = YES;
    action2.identifier = gActionTwo;
    
    UIMutableUserNotificationCategory * category = [[UIMutableUserNotificationCategory alloc] init];
    [category setIdentifier:gCategory];
    [category setActions:@[action,action2] forContext:UIUserNotificationActionContextDefault];
    [category setActions:@[action,action2] forContext:UIUserNotificationActionContextMinimal];
    
    UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:[NSSet setWithObjects:category, nil]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    return YES;
}

-(void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if (application.scheduledLocalNotifications.count == 0) {
        UILocalNotification * notification = [UILocalNotification new];
        notification.alertBody = @"Hi there!!";
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.fireDate = [NSDate date];
        notification.category = gCategory;
        notification.repeatInterval = NSCalendarUnitMinute;
        [application scheduleLocalNotification:notification];
    }
}


-(void) application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    NSLog(@"%@", identifier);
    [Pyze processReceivedRemoteNotificationWithId:identifier withUserInfo:@{@"pnty":@"pyze"}];
    completionHandler();
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
