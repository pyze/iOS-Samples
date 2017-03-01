

#import "CAProduct.h"

@implementation CAProduct

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.price = dictionary[@"price"];
        self.image = dictionary[@"image"];
    }
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [aDecoder decodeObjectForKey:@"name"];
        [aDecoder decodeObjectForKey:@"price"];
        [aDecoder decodeObjectForKey:@"image"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.image forKey:@"image"];
}

@end
