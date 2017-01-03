//
//  ViewController.m
//  AppletvOSSampleWithInApp
//
//  Created by Ramachandra Naragund on 21/12/16.
//  Copyright © 2016 Pyze Inc. All rights reserved.
//

#import "ViewController.h"
#import <Pyze/Pyze.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showInAppMessages {
    [Pyze showInAppNotificationUIForDisplayMessages:PyzeInAppTypeAll
                                navigationTextColor:[UIColor whiteColor]
                              withCompletionHandler:^(PyzeInAppStatus *inAppStatus) {
                                  NSLog(@"PyzeInAppStatus returned");
                              }];
}

@end
