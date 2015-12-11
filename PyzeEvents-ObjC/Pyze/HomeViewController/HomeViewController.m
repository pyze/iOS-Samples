//
//  HomeViewController.m
//  Pyze
//
//  Created by Ramachandra Naragund on 09/10/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//

#import "HomeViewController.h"


@interface HomeViewController () <UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *eventsButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *ios7BlueColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];

    self.eventsButton.layer.borderColor = ios7BlueColor.CGColor;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
@end
