//
//  UIImageView+ImageCaching.h
//  NSURLSessionExample
//
//  Created by Ramachandra Naragund on 10/08/15.
//  Copyright (c) 2015 Robosoft Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageCaching)

-(void) setImageURL:(NSURL *) url;

-(NSString *) urlString;

@end
