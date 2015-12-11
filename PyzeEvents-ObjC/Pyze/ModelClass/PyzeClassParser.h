//
//  PyzeClassParser.h
//  Pyze
//
//  Created by Ramachandra Naragund on 01/10/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PyzeClassParserDelegate;

@interface PyzeClassParser : NSObject
{
    id _delegate;
}

-(instancetype) init NS_UNAVAILABLE;

-(instancetype) initWithDelegate:(id <PyzeClassParserDelegate>) delegate NS_DESIGNATED_INITIALIZER;

@end



@protocol PyzeClassParserDelegate <NSObject>
@required
-(void) didParserCompleteParsing:(NSArray *) menuItems;
@end
