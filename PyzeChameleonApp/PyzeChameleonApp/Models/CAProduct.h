
#import <Foundation/Foundation.h>

@interface CAProduct : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *image;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
