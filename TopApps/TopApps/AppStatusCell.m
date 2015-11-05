//
//  AppStatusCell.m
//  NSURLSessionExample
//
//  Created by Ramachandra Naragund on 07/08/15.
//  Copyright (c) 2015 Robosoft Technologies Pvt Ltd. All rights reserved.
//

#import "AppStatusCell.h"
#import "UIImageView+ImageCaching.h"
#import "AppStoreDataModel.h"

@implementation AppStatusCell

-(void) constructAppStoreDetails:(AppStoreDataModel *) dataModel {
    self.appRecord = dataModel;
    [self.imageIconView setImage:[UIImage imageNamed:@"appLogo.png"]];
    [self.imageIconView setImageURL:[NSURL URLWithString:self.appRecord.iconURLString]];
    self.appName.text = self.appRecord.name;
    self.appPrice.text = self.appRecord.price;
}

@end
