//
//  PartialViewController.m
//  Pyze
//
//  Created by Ramachandra Naragund on 12/10/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//

#import "PartialViewController.h"

@interface PartialViewController ()<UIPopoverPresentationControllerDelegate>

@end

@implementation PartialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier compare:@"showpopover"] == NSOrderedSame) {
        UINavigationController * nvc = segue.destinationViewController;
        UIPopoverPresentationController * pc = nvc.popoverPresentationController;
        pc.delegate = self;
    }

}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}


@end
