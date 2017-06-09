//
//  AppDelegate.m
//  PyzeRichNotificationDemo
//
//  Created by Ramachandra Naragund on 23/11/16.
//  Copyright © 2016 Pyze Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import <Pyze/Pyze.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@property (nonatomic, strong) NSDictionary * apsDictionary;

//-(void) getAppCategoresFromPyze;
@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Pyze initialize:@"vywbsks1RaKRnZ1GLL3hBA" withLogThrottling:PyzelogLevelMinimal];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    // #InteractivePushNotifications
    // Request for permissions to play sound and to display push notification.
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }];

//    [self getAppCategoriesFromPyze];
    //    // #InteractivePushNotifications
    //    // Create a button: Learn More
    //    UNNotificationAction * learn = [UNNotificationAction actionWithIdentifier:@"Learn"
    //                                                                         title:@"Learn More"
    //                                                                       options:UNNotificationActionOptionNone];
    //
    //    // #InteractivePushNotifications
    //    // Create a button: Sign up
    //    UNNotificationAction * signup = [UNNotificationAction actionWithIdentifier:@"Sign up"
    //                                                                         title:@"Sign up"
    //                                                                       options:UNNotificationActionOptionNone];
    //
    //    // #InteractivePushNotifications
    //    // Create a button: Read Blog
    //    UNNotificationAction * readBlog = [UNNotificationAction actionWithIdentifier:@"Read Blog"
    //                                                                         title:@"Read Blog"
    //                                                                       options:UNNotificationActionOptionNone];
    //
    //    // #InteractivePushNotifications
    //    // Create a category of these actions and registers them with NotificationCenter.
    //    UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:@"PyzeCategory"
    //                                                                               actions:@[learn, signup, readBlog]
    //                                                                     intentIdentifiers:@[]
    //                                                                               options:UNNotificationCategoryOptionNone];
    //    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category, nil]];
    //    

    return YES;
}



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

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"%s",__func__);
    NSLog(@"USERINFO : %@",userInfo);
}


-(void) getAppCategoriesFromPyze {
    // Use completion handlers to minimise the code that developers have to write as helper method.[From below line to line_numb 79]
    
    
 /*   [Pyze getPushCategoriesWithActionPayload:^(NSDictionary *payload) {
        self.apsDictionary = [NSDictionary dictionaryWithDictionary:payload];
        if (self.apsDictionary && self.apsDictionary.count) {
            NSString * category = [[self.apsDictionary objectForKey:@"aps"] objectForKey:@"category"];
            if (category && category.length) {
                NSDictionary * pyzeObject = [self.apsDictionary objectForKey:@"Pyze"];
                if (pyzeObject && pyzeObject.count) {
                    NSDictionary * buttons = [pyzeObject objectForKey:@"buttons"];
                    NSMutableArray * actions = [NSMutableArray array];
                    if (buttons && buttons.count) {
                        for (NSString * key in [buttons allKeys]) {
                            UNNotificationAction * action = [UNNotificationAction actionWithIdentifier:key
                                                                                                 title:key
                                                                                               options:UNNotificationActionOptionNone];
                            [actions addObject:action];
                        }
                    }
                    if (actions.count) {
                        UNNotificationCategory * notificationcategory = [UNNotificationCategory categoryWithIdentifier:category
                                                                                                               actions:actions
                                                                                                     intentIdentifiers:@[]
                                                                                                               options:UNNotificationCategoryOptionNone];
                        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:notificationcategory, nil]];
                        
                    }
                }
            }
        }
    }]; */
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSDictionary * buttons = nil;
    if (self.apsDictionary) {
        NSDictionary * pyzeObject =[self.apsDictionary objectForKey:@"Pyze"];
        if (pyzeObject && pyzeObject.count) {
            if ([pyzeObject objectForKey:@"buttons"]) {
                buttons = [pyzeObject objectForKey:@"buttons"];
            }
        }
    }
    
    if (buttons && buttons.count) {
        if ([[buttons allKeys] containsObject:response.actionIdentifier]) {
            NSLog(@"response.actionIdentifier = %@",response.actionIdentifier);
            // Handle for response.actionIdentifier
        }
    }
}

-(void) selectNotificationForDate:(NSDate *) date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * components = [calendar componentsInTimeZone:calendar.timeZone fromDate:date];
    NSDateComponents * newComponents = [[NSDateComponents alloc] init];
    newComponents.calendar = calendar;
    newComponents.timeZone = calendar.timeZone;
    newComponents.month = components.month;
    newComponents.day = components.day;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    
    UNCalendarNotificationTrigger * trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:newComponents
                                                                                                       repeats:NO];
    
    UNMutableNotificationContent * mutableContent = [[UNMutableNotificationContent alloc] init];
    mutableContent.title = @"Schedule a Notification";
    mutableContent.body = @"Pyze introduces User Notification Demo with this sample app.";
    mutableContent.sound = [UNNotificationSound defaultSound];
    self.apsDictionary = [NSDictionary dictionaryWithDictionary:self.apsDictionary];
    if (self.apsDictionary && self.apsDictionary.count) {
        NSString * category = [[self.apsDictionary objectForKey:@"aps"] objectForKey:@"category"];
        if (category && category.length)
        mutableContent.categoryIdentifier = category;
    }
    
    NSURL * urlForImage = [[NSBundle mainBundle] URLForResource:@"pyzeLogo" withExtension:@"png"];
    if (urlForImage) {
        UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:@"pyzeLogo"
                                                                                               URL:urlForImage
                                                                                           options:nil
                                                                                             error:nil];
        if (attachment) {
            mutableContent.attachments = @[attachment];
        }
    }
    
    UNNotificationRequest * notificationRequest = [UNNotificationRequest requestWithIdentifier:@"notificationRequest"
                                                                                       content:mutableContent
                                                                                       trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest
                                                           withCompletionHandler:^(NSError * error) {
                                                               if (error) NSLog(@"Problem in creating notificationRequest");
                                                           }];
    
}

@end
