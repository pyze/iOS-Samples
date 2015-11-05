//
//  ViewController.m
//  TestCocoapods
//
//  Created by Ramachandra Naragund on 04/11/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import <Pyze/Pyze.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self yourMethod];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) yourMethod
{
    [PyzeAd postAdRequested:@"google.com"
              fromAppScreen:@"home"
                 withAdSize:CGSizeMake(320, 160)
                     adType:@"banner"
             withAttributes:@{
                              @"firstName" : @"John",
                              @"lastName" : @"Smith",
                              @"age" : @28
                              }];
}
@end
