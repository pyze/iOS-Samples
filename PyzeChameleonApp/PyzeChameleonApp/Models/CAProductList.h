
#import <Foundation/Foundation.h>
#import "CAProduct.h"

@interface CAProductList : NSObject <NSCoding>

@property (strong, nonatomic) NSMutableArray *productList;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
