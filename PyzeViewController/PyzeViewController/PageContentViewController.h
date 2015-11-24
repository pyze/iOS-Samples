//
//  PageContentViewController.h
//  PyzeViewController
//
//  Created by Ramachandra Naragund on 17/11/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) NSString * stringTxt;
@property NSUInteger pageIndex;

@end
