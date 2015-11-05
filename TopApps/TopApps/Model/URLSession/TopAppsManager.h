//
//  TopAppsManager.h
//  NSURLSessionExample
//
//  Created by Ramachandra Naragund on 10/08/15.
//  Copyright (c) 2015 Robosoft Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completionHandler)(NSError * error, NSArray * dataRecords);

@interface TopAppsManager : NSObject

+(instancetype) sharedAppsManager;

-(void) getTopPaidAppsFromiTunesWithCompletionBlock:(completionHandler) block;

@end
