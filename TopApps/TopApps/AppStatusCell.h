//
//  AppStatusCell.h
//  NSURLSessionExample
//
//  Created by Ramachandra Naragund on 07/08/15.
//  Copyright (c) 2015 Robosoft Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppStoreDataModel;

@interface AppStatusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageIconView;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *appPrice;

@property (nonatomic) AppStoreDataModel *appRecord;

-(void) constructAppStoreDetails:(AppStoreDataModel *) dataModel;
@end
