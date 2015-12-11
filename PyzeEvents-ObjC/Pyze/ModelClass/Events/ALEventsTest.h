//
//  ALEventsTest.h
//  AppLifecycle
//
//  Created by Ramachandra Naragund on 21/09/15.
//  Copyright (c) 2015 CollaboRight. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef void (^completionHandler) (NSArray * eventValueList);

@interface ALEventsTest : NSObject

+(void) executeTestEventsInBackgroundWithIndexPath:(NSIndexPath *) indexPath shouldExecute:(BOOL) shouldExecute withCompletionHandler:(void (^)(NSArray * result))completionHandler;

@end
