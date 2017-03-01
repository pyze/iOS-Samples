
#import <Foundation/Foundation.h>
#import "CAProductList.h"

@interface CADataManager : NSObject

+ (instancetype) sharedInstance;

- (void) fetchProductList;
- (NSArray *) getProductList;

@end
