
#import <Foundation/Foundation.h>
#import "CAProductList.h"

@interface CAFeedManager : NSObject

+ (void) fetchProductList:(void (^)(CAProductList * productList)) completionHandler;

@end
