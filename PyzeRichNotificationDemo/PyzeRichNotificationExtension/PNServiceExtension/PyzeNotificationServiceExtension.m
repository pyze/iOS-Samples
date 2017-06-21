//
//  PyzeNotificationServiceExtension.m
//  Pyze
//
//  Created by Ramachandra Naragund on 21/06/17.
//  Copyright © 2017 Pyze Technologies. All rights reserved.
//

#import "PyzeNotificationServiceExtension.h"

@interface PyzeNotificationServiceExtension ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;


@end

@implementation PyzeNotificationServiceExtension

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    NSLog(@"%s",__func__);
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"Pyze : %@", self.bestAttemptContent.title];
    //    self.bestAttemptContent.subtitle = @"Pyze : Subtitle";
    
    NSString *mediaUrlString = request.content.userInfo[@"mediaUrl"];
    NSLog(@"mediaUrlString : %@",mediaUrlString);
    
    NSURL *mediaUrl = [NSURL URLWithString:mediaUrlString];
    
    
    [[[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] downloadTaskWithURL:mediaUrl completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error;
            
            //getting application's document directory path
            NSArray * domainDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [domainDirectories objectAtIndex:0];
            
            //adding a new folder to the documents directory path
            NSString *appDir = [documentsDirectory stringByAppendingPathComponent:@"/Pyze/"];
            
            //Checking for directory existence and creating if not already exists
            if(![fileManager fileExistsAtPath:appDir]) {
                [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error];
            }
            
            //retrieving the filename from the response and appending it again to the path
            //this path "appDir" will be used as the target path
            appDir =  [appDir stringByAppendingFormat:@"/%@",[response suggestedFilename]];
            
            //checking for file existence and deleting if already present.
            if([fileManager fileExistsAtPath:appDir]) {
                NSLog([fileManager removeItemAtPath:appDir error:&error]? @"deleted" : @"not deleted");
            }
            
            //moving the file from temp location to app's own directory
            BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:appDir error:&error];
            NSLog(@"%@",((fileCopied) ? @"YES" : @"NO"));
            
            NSURL *mediaFileURL = [NSURL fileURLWithPath:appDir];
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:[response suggestedFilename]
                                                                                                  URL:mediaFileURL
                                                                                              options:nil
                                                                                                error:&error];
            if (attachment) {
                self.bestAttemptContent.attachments = @[attachment];
            }
            
            
            
        } else {
            NSLog(@"Error in downloading the image : %@",error.localizedDescription);
            
        }
        
        self.contentHandler(self.bestAttemptContent);
        
    }] resume];
    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    
    NSLog(@"%s",__func__);
    self.contentHandler(self.bestAttemptContent);
}


@end
