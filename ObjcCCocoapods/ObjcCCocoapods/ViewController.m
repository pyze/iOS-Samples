//
//  ViewController.m
//  ObjcCCocoapods
//
//  Created by Ramachandra Naragund on 13/11/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:nil]
                                                                   delegate:self];
    [connection start];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
