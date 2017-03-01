
#import "CAProductList.h"

@implementation CAProductList

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        self.productList = [NSMutableArray array];
        NSArray *productArray = dictionary[@"products"];
        
        
        for (NSDictionary *hotelDict in productArray) {
            CAProduct *product = [[CAProduct alloc] initWithDictionary:hotelDict];
            [self.productList addObject:product];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.productList = [aDecoder decodeObjectForKey:@"productList"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.productList forKey:@"productList"];
}

@end
