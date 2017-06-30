/* Copyright 2017 Urban Airship and Contributors */

#import <Foundation/Foundation.h>
#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);

@end


@implementation NotificationService

-(void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    self.bestAttemptContent.title = [self.bestAttemptContent.title stringByAppendingString:@"Pyze"];;
    self.bestAttemptContent.subtitle = self.bestAttemptContent.subtitle;
    self.contentHandler(self.bestAttemptContent);
    
}


@end
