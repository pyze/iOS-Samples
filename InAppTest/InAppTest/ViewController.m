//
//  ViewController.m
//  InAppTest
//
//  Created by Ramachandra Naragund on 19/08/16.
//  Copyright © 2016 Ramachandra Naragund. All rights reserved.
//

#import "ViewController.h"
#import <Pyze/Pyze.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *showMessagesButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Pyze countNewUnFetched:^(NSInteger result) {
        if (result > 0)
            [Pyze showUnreadInAppNotificationUIWithCompletionHandler:^(PyzeInAppStatus *inAppStatus) {
                NSLog(@"buttonIndex = %d", (int)inAppStatus.buttonIndex);
                NSLog(@"message-ID =%@" , inAppStatus.messageID);
                NSLog(@"campaign-ID = %@", inAppStatus.campaignID);
                NSLog(@"title = %@",inAppStatus.title);
                NSLog(@"urlString = %@",inAppStatus.urlString);
            }];
    }];

    [Pyze addBadge:self.showMessagesButton]; //1
}

- (IBAction)didTapShowMessage:(id)sender {
    [Pyze showInAppNotificationUIForDisplayMessages:PyzeInAppTypeAll
                          msgNavBarButtonsTextColor:[UIColor blackColor]
                            msgNavBarButtonsBgColor:[UIColor lightGrayColor]
                                   msgNavBarBgColor:[UIColor lightGrayColor]
                          msgNavBarCounterTextColor:[UIColor whiteColor]
                              withCompletionHandler:^(PyzeInAppStatus *inAppStatus) {
                                  NSLog(@"buttonIndex = %d", (int)inAppStatus.buttonIndex);
                                  NSLog(@"message-ID =%@" , inAppStatus.messageID);
                                  NSLog(@"campaign-ID = %@", inAppStatus.campaignID);
                                  NSLog(@"title = %@",inAppStatus.title);
                                  NSLog(@"urlString = %@",inAppStatus.urlString);
                              }];
}


@end

/* Swift -version

class ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Pyze.addBadge(self.showMessagesButton)
        //1
    }
    
    @IBAction func didTapShowMessage(sender: AnyObject) {
        Pyze.showInAppNotificationUIForDisplayMessages(PyzeInAppTypeAll, msgNavBarButtonsTextColor: UIColor.blackColor(), msgNavBarButtonsBgColor: UIColor.lightGrayColor(), msgNavBarBgColor: UIColor.lightGrayColor(), msgNavBarCounterTextColor: UIColor.whiteColor(), withCompletionHandler: {(inAppStatus: PyzeInAppStatus) -> Void in
            print("buttonIndex = \(Int(inAppStatus.buttonIndex))")
            print("message-ID =\(inAppStatus.messageID)")
            print("campaign-ID = \(inAppStatus.campaignID)")
            print("title = \(inAppStatus.title)")
            print("urlString = \(inAppStatus.urlString)")
        })
    }
}
*/

