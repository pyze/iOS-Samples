//
//  ViewController.h
//  PyzeRichNotificationDemo
//
//  Created by Ramachandra Naragund on 23/11/16.
//  Copyright © 2016 Pyze Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateProtocol <NSObject>
@optional
-(void) selectNotificationForDate:(NSDate *) date;
@end

@interface ViewController : UIViewController
@property (nonatomic,weak) id<DateProtocol> delegate;
@end

