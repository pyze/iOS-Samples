//
//  ViewController.m
//  iOSCrashException
//
//  Created by Ramachandra Naragund on 11/01/16.
//  Copyright © 2016 Pyze. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import <Pyze/Pyze.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Pyze sharedPyze] initializeWithKey:@"WgdvOC7PQpOJ3rn55GXaJw"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object: nil];

    // Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
//    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
}

@end
