
#import "NotificationController.h"
#import <UserNotifications/UserNotifications.h>
#import <Pyze/Pyze.h>

@interface NotificationController()

@end


@implementation NotificationController

- (instancetype)init {
    self = [super init];
    if (self){
        // Initialize variables here.
        // Configure interface objects here.
        
    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - Handling Push notifications

#pragma mark - watchOS2

-(void)didReceiveRemoteNotification:(NSDictionary *)remoteNotification withCompletion:(void (^)(WKUserNotificationInterfaceType))completionHandler {
    
    NSDictionary *userInfo = [[remoteNotification objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *title = [userInfo objectForKey:@"title"];
    NSString *message = [userInfo objectForKey:@"body"];
    
    WKAlertAction *act = [WKAlertAction actionWithTitle:@"OK"
                                                  style:WKAlertActionStyleCancel
                                                handler:^{
                                                    NSLog(@"Alert action 'OK' performed");
                                                }];
    NSArray *actions = @[act];
    
    [self presentAlertControllerWithTitle:title
                                  message:message
                           preferredStyle:WKAlertControllerStyleAlert
                                  actions:actions];
    
    [Pyze processReceivedRemoteNotification:userInfo];
    
}

#pragma mark - watchOS3

- (void)didReceiveNotification:(UNNotification *)notification withCompletion:(void(^)(WKUserNotificationInterfaceType interface)) completionHandler {
    
    NSDictionary *userInfo = [[notification.request.mutableCopy content] userInfo];
    NSDictionary *alertDict = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *title = [alertDict objectForKey:@"title"];
    NSString *message = [alertDict objectForKey:@"body"];
    
    
    WKAlertAction *act = [WKAlertAction actionWithTitle:@"OK"
                                                  style:WKAlertActionStyleCancel
                                                handler:^{
                                                    NSLog(@"Alert action 'OK' performed");
                                                }];
    NSArray *actions = @[act];
    
    [self presentAlertControllerWithTitle:title
                                  message:message
                           preferredStyle:WKAlertControllerStyleAlert
                                  actions:actions];
    
    [Pyze processReceivedRemoteNotification:userInfo];
    
    completionHandler(WKUserNotificationInterfaceTypeCustom);
}


@end



