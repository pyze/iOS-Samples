//
//  EventListingTableViewController.h
//  PyzeEvents-Swift
//
//  Created by Ramachandra Naragund on 11/12/15.
//  Copyright © 2015 Pyze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListingTableViewController : UITableViewController

@property (nonatomic,strong) NSIndexPath * indexpath;
@property (nonatomic,strong) NSString * methodName;
@property (nonatomic,strong) NSArray * modelData;

@end
