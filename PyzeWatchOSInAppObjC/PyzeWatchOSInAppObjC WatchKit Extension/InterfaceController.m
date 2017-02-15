
#import <Pyze/Pyze.h>

#import "InterfaceController.h"
#import "InAppMessageManager.h"

@interface InterfaceController()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *unreadbutton;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    [Pyze countNewUnFetched:^(NSInteger count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.unreadbutton setTitle:[NSString stringWithFormat:@"Show Unread (%d)",count]];
        });
    }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - Action methods

- (IBAction)showUnread {
    [[InAppMessageManager sharedManager] fetchHeadersForType:PyzeInAppTypeUnread completionHandler:^{
        [self pushControllerWithName:@"InAppMessageUIController" context:nil];
    }];
}

- (IBAction)showRead {
    [[InAppMessageManager sharedManager] fetchHeadersForType:PyzeInAppTypeRead completionHandler:^{
        [self pushControllerWithName:@"InAppMessageUIController" context:nil];
    }];
}

- (IBAction)showAll {
    [[InAppMessageManager sharedManager] fetchHeadersForType:PyzeInAppTypeAll completionHandler:^{
        [self pushControllerWithName:@"InAppMessageUIController" context:nil];
    }];
}


@end



