//
//  ViewController.m
//  PyzeRichNotificationDemo
//
//  Created by Ramachandra Naragund on 23/11/16.
//  Copyright © 2016 Pyze Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.delegate = [[UIApplication sharedApplication] delegate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scheduleNotification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectNotificationForDate:)])
    {
        [self.delegate selectNotificationForDate:[NSDate dateWithTimeInterval:120 sinceDate:[NSDate date]]];
    }
}



@end
