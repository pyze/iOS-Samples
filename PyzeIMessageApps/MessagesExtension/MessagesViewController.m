//
//  MessagesViewController.m
//  MessagesExtension
//
//  Created by Ramachandra Naragund on 21/09/16.
//  Copyright © 2016 Ramachandra Naragund. All rights reserved.
//

#import "MessagesViewController.h"
#import <Pyze/Pyze.h>

@interface MessagesViewController ()
@property (nonatomic, assign) NSInteger tokenCounter;
@end

@implementation MessagesViewController

+(void) load
{
    [Pyze initialize:@"QF3zSg9SRwWdV6rsncEMBw" withLogThrottling:PyzelogLevelMinimal];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tokenCounter = 0;
    
    // Do any additional setup after loading the view.
    
}
- (IBAction)createiMessage {
    
    UIImage * image = [self snapShot];
    MSConversation * conversation = self.activeConversation;
    if (image && conversation) {
        MSMessageTemplateLayout * activeLayout = [[MSMessageTemplateLayout alloc] init];
        activeLayout.image = image;
        activeLayout.caption = @"Message Counter";
        activeLayout.subcaption = @"Message subcaption";
        activeLayout.trailingCaption = @"Trailing caption";
        activeLayout.trailingSubcaption = @"Trailing Subcaption";
        activeLayout.mediaFileURL = [NSURL URLWithString:@"Path to media URL"];
        activeLayout.imageTitle = @"Image counter";
        activeLayout.imageSubtitle = @"Image subtitle";
        
        MSMessage * message = [[MSMessage alloc] init];
        message.layout = activeLayout;
        message.URL = [NSURL URLWithString:@"Empty URL"];
        message.summaryText = @"This is Summary";
        
        [conversation insertMessage:message completionHandler:^(NSError * error) {
            NSLog(@"error %@",error);
            NSMutableDictionary * dictionary = [self fillMessagingAttributes:message conversation:conversation];
            [PyzeiMessageApps postInsertMessageWithAttributes: dictionary];
        }];
    }
}

- (IBAction)createSticker
{
    NSURL * urlPath = [[NSBundle mainBundle] URLForResource:@"pyzeLogo" withExtension:@"png"];
    if (urlPath) {
        MSSticker * sticker = [[MSSticker alloc] initWithContentsOfFileURL:urlPath
                                                      localizedDescription:@"Pyze logo" error:nil];
        MSConversation * conversation = self.activeConversation;
        if (conversation && sticker) {
            [conversation insertSticker:sticker completionHandler:^(NSError * error) {
                NSLog(@"error %@",error);
                NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
                
                // conversation details
                attributes[@"localParticipantHash"] = [Pyze hash:[conversation.localParticipantIdentifier UUIDString]];
                if (conversation.remoteParticipantIdentifiers)
                    attributes[@"remoteParticipants"] = @(conversation.remoteParticipantIdentifiers.count);
                
                NSMutableString * remoteParticipantHashes = [NSMutableString string];
                for (NSUUID * uuid in conversation.remoteParticipantIdentifiers) {
                    [remoteParticipantHashes appendString:[Pyze hash:[uuid UUIDString]]];
                }
                
                if (remoteParticipantHashes && remoteParticipantHashes.length)
                    attributes[@"remoteParticipantsHashes"] = remoteParticipantHashes;
                
                
                [PyzeiMessageApps postInsertStickerWithLocalizedDescription:true
                                              withStickerImageFileURLString:true
                                                             withAttributes:attributes];
            }];
        }
    }
}

- (IBAction)createAttachment
{
    NSURL * urlPath = [[NSBundle mainBundle] URLForResource:@"PyzeGrowthIntelligence" withExtension:@"pdf"];
    if (urlPath) {
        MSConversation * conversation = self.activeConversation;
        
        [conversation insertAttachment:urlPath
                 withAlternateFilename:nil
                     completionHandler:^(NSError * error) {
                         NSLog(@"error %@",error);
                         NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
                         
                         // conversation details
                         attributes[@"localParticipantHash"] = [Pyze hash:[conversation.localParticipantIdentifier UUIDString]];
                         if (conversation.remoteParticipantIdentifiers)
                             attributes[@"remoteParticipants"] = @(conversation.remoteParticipantIdentifiers.count);
                         
                         NSMutableString * remoteParticipantHashes = [NSMutableString string];
                         for (NSUUID * uuid in conversation.remoteParticipantIdentifiers) {
                             [remoteParticipantHashes appendString:[Pyze hash:[uuid UUIDString]]];
                         }
                         
                         if (remoteParticipantHashes && remoteParticipantHashes.length)
                             attributes[@"remoteParticipantsHashes"] = remoteParticipantHashes;
                         
                         [PyzeiMessageApps postInsertAttachmentWithURL:true
                                                 withAlternateFileName:true
                                                        withAttributes:attributes];
                         
                     }];
    }

}

-(UIImage *) snapShot {
    CGRect frameRect = CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 300, 300);
    UIView * frameView = [[UIView alloc] initWithFrame:frameRect];
    frameView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(75, 75, 150, 150)];
    [label setFont:[UIFont systemFontOfSize:40.0f]];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor colorWithRed:69 / 255.0f green:165 / 255.0f blue:238 / 255.0f alpha:1.0f];
    label.text = [NSString stringWithFormat:@"%d", (int)++self.tokenCounter];
    label.layer.cornerRadius = CGRectGetWidth(frameRect) / 2.0f;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    
    [frameView addSubview:label];
    [self.view addSubview:frameView];
    
    UIGraphicsBeginImageContextWithOptions(frameRect.size, NO, [[UIScreen mainScreen] scale]);
    [frameView drawViewHierarchyInRect:frameView.bounds afterScreenUpdates:YES];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [frameView removeFromSuperview];
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Conversation Handling

-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the inactive to active state.
    // This will happen when the extension is about to present UI.
    
    // Use this method to configure the extension and restore previously stored state.
}

-(void)willResignActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the active to inactive state.
    // This will happen when the user dissmises the extension, changes to a different
    // conversation or quits Messages.
    
    // Use this method to release shared resources, save user data, invalidate timers,
    // and store enough state information to restore your extension to its current state
    // in case it is terminated later.
}

-(void)didReceiveMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when a message arrives that was generated by another instance of this
    // extension on a remote device.
    // Use this method to trigger UI updates in response to the message.
    [PyzeiMessageApps postReceiveMessageWithAttributes:[self fillMessagingAttributes:message
                                                                        conversation:conversation]];

}

-(void)didStartSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user taps the send button.
    [PyzeiMessageApps postMessageStartSendingWithAttributes:[self fillMessagingAttributes:message
                                                                             conversation:conversation]];
}

-(void)didCancelSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user deletes the message without sending it.
    
    // Use this to clean up state related to the deleted message.
    [PyzeiMessageApps postCancelSendingMessageWithAttributes:[self fillMessagingAttributes:message
                                                                              conversation:conversation]];

}

-(void)willTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called before the extension transitions to a new presentation style.
    
    // Use this method to prepare for the change in presentation style.
}

-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called after the extension transitions to a new presentation style.
    
    // Use this method to finalize any behaviors associated with the change in presentation style.
}


-(NSMutableDictionary *) fillMessagingAttributes:(MSMessage *)message
                                    conversation:(MSConversation *)conversation
{
    NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
    // Message details
    if (message) {
        if (message.URL) attributes[@"URL"] = @"1";
        if (message.summaryText) attributes[@"summaryText"] = @"1";
    }
    // message layout details
    MSMessageTemplateLayout * layout = (MSMessageTemplateLayout *)message.layout;
    if (layout) {
        if (layout.caption) attributes[@"caption"] = @"1";
        if (layout.subcaption) attributes [@"subcaption"] = @"1";
        if (layout.trailingCaption) attributes[@"trailingCaption"] = @"1";
        if (layout.trailingSubcaption) attributes[@"trailingSubcaption"] = @"1";
        if (layout.image) attributes[@"image"] = @"1";
        if (layout.mediaFileURL) attributes[@"mediaFileURL"] =  @"1";
        if (layout.imageTitle) attributes[@"imageTitle"] = @"1";
        if (layout.imageSubtitle) attributes[@"imageSubtitle"] = @"1";
    }
    // conversation details
    if (conversation) {
        attributes[@"localParticipantHash"] = [Pyze hash:[conversation.localParticipantIdentifier UUIDString]];
        if (conversation.remoteParticipantIdentifiers)
            attributes[@"remoteParticipants"] = @(conversation.remoteParticipantIdentifiers.count);
        
        NSMutableString * remoteParticipantHashes = [NSMutableString string];
        for (NSUUID * uuid in conversation.remoteParticipantIdentifiers) {
            [remoteParticipantHashes appendString:[Pyze hash:[uuid UUIDString]]];
        }
        
        if (remoteParticipantHashes && remoteParticipantHashes.length)
            attributes[@"remoteParticipantsHashes"] = remoteParticipantHashes;
    }
    return attributes;
}
@end
