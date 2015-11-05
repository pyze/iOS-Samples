//
//  TopAppsManager.m
//  NSURLSessionExample
//
//  Created by Ramachandra Naragund on 10/08/15.
//  Copyright (c) 2015 Robosoft Technologies Pvt Ltd. All rights reserved.
//

#import "TopAppsManager.h"
#import "AppStoreDataModel.h"


@interface TopAppsManager ()
@property (strong,nonatomic) NSMutableArray * tasksInProgress;
@property (copy,nonatomic) completionHandler  completionBlock;
@end

@implementation TopAppsManager

+(instancetype) sharedAppsManager
{
    static TopAppsManager * sManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sManager = [TopAppsManager new];
        sManager.tasksInProgress = [NSMutableArray array];
    });
    return sManager;
}

-(void) getTopPaidAppsFromiTunesWithCompletionBlock:(completionHandler) completionBlock
{
    __weak TopAppsManager * weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block BOOL isTasksInProgress = NO;
        __block NSUInteger index;
        NSString * appStoreURLString = @"http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=125/json";
        
        [weakSelf.tasksInProgress enumerateObjectsUsingBlock:^(NSURLSessionDataTask *task, NSUInteger idx, BOOL *stop) {
            if([task.originalRequest.URL.absoluteString isEqualToString:appStoreURLString]) {
                isTasksInProgress = YES;
                index = idx;
            }
        }];
        if(isTasksInProgress) {
            NSURLSessionDataTask *task = [weakSelf.tasksInProgress objectAtIndex:index];
            [weakSelf.tasksInProgress removeObjectAtIndex:index];
            [task cancel];
        }
        weakSelf.completionBlock = completionBlock;
        NSURL *url = [NSURL URLWithString:appStoreURLString];
        NSURLSession *urlSession = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *sessionDataTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                NSError *jsonParsingError = nil;
                NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
                if (jsonResults){
                    [self createAppStoreRecords:jsonResults[@"feed"][@"entry"]];
                }
            }
            else {
                completionBlock(error,nil);
            }
            
        }];
        
        [weakSelf.tasksInProgress addObject:sessionDataTask];
        [sessionDataTask resume];

    });
}

-(void) createAppStoreRecords:(NSArray *) dataRecords
{
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * records in dataRecords) {
        AppStoreDataModel * data = [AppStoreDataModel new];
        data.name = records[@"title"][@"label"];
        NSDictionary *imgDetail = [records[@"im:image"] lastObject];
        if (imgDetail)
            data.iconURLString = imgDetail[@"label"];
        
        data.price = records[@"im:price"][@"label"];
        [array addObject:data];
    }
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       self.completionBlock(nil,[NSArray arrayWithArray:array]);
                   });
}
@end
