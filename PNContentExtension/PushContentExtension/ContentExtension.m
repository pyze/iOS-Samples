//
//  ContentExtension.m
//  PNContentExtension
//
//  Created by Ramachandra Naragund on 22/06/17.
//  Copyright © 2017 Ramachandra Naragund. All rights reserved.
//

#import "ContentExtension.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface ContentExtension () <UNNotificationContentExtension>

@property (strong, nonatomic) UNNotification *notif;

@end

@implementation ContentExtension

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Utility methods

- (void) setUpNotificationActionsForType:(NSString *)type {
    
    // Create action buttons
    
    NSString *action1Id = @"Open";
    NSString *action2Id = @"Read later";
    
    
    NSMutableArray *actions = [NSMutableArray array];

    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:action1Id
                                                                         title:action1Id
                                                                       options:UNNotificationActionOptionForeground];
    [actions addObject:action1];
    
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:action2Id
                                                                         title:action2Id
                                                                       options:UNNotificationActionOptionForeground];
    [actions addObject:action2];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:type
                                                                              actions:actions
                                                                    intentIdentifiers:@[]
                                                                              options:UNNotificationCategoryOptionCustomDismissAction];
    
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObject:category]];
    
}

- (void) buildCustomNotificationUI {
    
    /* NOTE : The payload used to test
     
     {
     "mediaUrl": "https://pyzeexportstore.blob.core.windows.net/exportdata/andre-3000.jpg",
     "aps": {
     "alert": {
     "body": "Test Message",
     "title": "Test Title"
     },
     "category": "Template1"
     },
     "pnty": "pyze",
     "mid": "efgh",
     "deeplinkUrl": "myapp://deeplinkurl.com/",
     "mediaType": "jpg",
     "cid": "abcd"
     }
     */
    
    NSDictionary *userInfo = self.notif.request.content.userInfo[@"aps"];
    NSString *pushCategory = [userInfo objectForKey:@"category"];
    [self setUpNotificationActionsForType:pushCategory];
    
    NSLog(@"%@",self.notif.request.content.userInfo);
    NSString *mediaUrlString = self.notif.request.content.userInfo[@"mediaUrl"];
    
    
    //Draw an imageview
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 250.0)];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:imageView];
    [self.view bringSubviewToFront:imageView];
    
    
    // Draw a label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 265.0, self.view.frame.size.width, 50.0)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"PYZE-NOTIFICATION CUSTOM UI"];
    [self.view addSubview:label];
    [self.view bringSubviewToFront:label];
    
    
    NSURL *mediaUrl = [NSURL URLWithString:mediaUrlString];

    //Download media
    [[[NSURLSession sharedSession] dataTaskWithURL:mediaUrl
                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
                [imageView setImage:[UIImage imageWithData:data]];
            });
        
    }] resume];
    
}

#pragma mark - Callback on reciept of notification

- (void)didReceiveNotification:(UNNotification *)notification {
    NSLog(@"\n%s",__func__);
    self.notif = notification;
    [self buildCustomNotificationUI];
    
}

#pragma mark - Memory handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
