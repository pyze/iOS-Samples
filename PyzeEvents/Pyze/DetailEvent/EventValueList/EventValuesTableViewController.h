//
//  EventValuesTableViewController.h
//  Pyze
//
//  Created by Ramachandra Naragund on 14/10/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventValuesTableViewController : UITableViewController
-(void)setModelData:(NSArray *) modelData forMethodName:(NSString *) methodName withIndexPath:(NSIndexPath *) indexPath;
@end
