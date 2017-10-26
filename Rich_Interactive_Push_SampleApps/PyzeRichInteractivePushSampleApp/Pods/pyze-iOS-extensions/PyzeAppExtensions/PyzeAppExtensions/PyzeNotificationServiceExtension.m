
//  Copyright © 2017 Pyze Technologies. All rights reserved.

#import "PyzeNotificationServiceExtension.h"

NSString *const k_PyzeRichPushMediaURLKey = @"mediaUrl";

@interface PyzeNotificationServiceExtension ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;


@end

@implementation PyzeNotificationServiceExtension

#pragma mark - Utility methods

- (NSURL *) attachmentFileURLWithTempLocation:(NSURL *)location name:(NSString *)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    //getting application's document directory path
    NSArray * domainDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [domainDirectories objectAtIndex:0];
    
    //appending the path component for saving the media file
    NSString *attachmentLocalFilePath = [documentsDirectory stringByAppendingPathComponent:@"/Pyze/"];
    
    //Checking for directory existence to store the media file and creating if it does not exist
    if(![fileManager fileExistsAtPath:attachmentLocalFilePath]) {
        [fileManager createDirectoryAtPath:attachmentLocalFilePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    //append filename to the directory path
    attachmentLocalFilePath =  [attachmentLocalFilePath stringByAppendingFormat:@"/%@",fileName];
    
    //remove old media file if already exist
    if([fileManager fileExistsAtPath:attachmentLocalFilePath]) {
        [fileManager removeItemAtPath:attachmentLocalFilePath error:&error];
        if (error) {
            NSLog(@"Error in removing file : %@", error.debugDescription);
        }
    }
    
    //moving the file from temp location to the specified directory
    [fileManager moveItemAtPath:[location path] toPath:attachmentLocalFilePath error:&error];
    if (error) {
        NSLog(@"Error in moving file to location : %@", error.debugDescription);
    }
    
    NSURL *mediaFileURL = [NSURL fileURLWithPath:attachmentLocalFilePath];
    
    return mediaFileURL;
}

- (NSURLSessionDownloadTask *) loadAttachmentsWithURLString:(NSString *)urlString {
    
    NSURL *mediaURL = [NSURL URLWithString:urlString];
    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession]
                                      downloadTaskWithURL:mediaURL
                                      completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          
                                          if (error) {
                                              NSLog(@"Error in fetching the attachment : %@", error.debugDescription);
                                              self.contentHandler(self.bestAttemptContent);
                                              return ;
                                          }
                                          
                                          NSURL *mediaFileURL = [self attachmentFileURLWithTempLocation:location name:[response suggestedFilename]];
                                          UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:[response suggestedFilename]
                                                                                                                                URL:mediaFileURL
                                                                                                                            options:nil
                                                                                                                              error:&error];
                                          if (attachment) {
                                              self.bestAttemptContent.attachments = @[attachment];
                                          }
                                          self.contentHandler(self.bestAttemptContent);
                                      }];
    return task;
}

#pragma mark - UNNotificationServiceExtension delegate

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request
                   withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    self.bestAttemptContent.title = self.bestAttemptContent.title;
    self.bestAttemptContent.subtitle = self.bestAttemptContent.subtitle;
    
    NSString *mediaUrlString = request.content.userInfo[k_PyzeRichPushMediaURLKey];
    NSURLSessionDownloadTask *task = [self loadAttachmentsWithURLString:mediaUrlString];
    [task resume];
    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    
    self.contentHandler(self.bestAttemptContent);
}


@end
