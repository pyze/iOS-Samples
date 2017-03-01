
#import "CAFeedManager.h"

@implementation CAFeedManager

+ (void) fetchProductList:(void (^)(CAProductList * productList)) completionHandler {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PyzeE-Cart" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    __block CAProductList *productList = nil;
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        productList = [[CAProductList alloc] initWithDictionary:json];
    }
    completionHandler(productList);
}




@end
