#import <Foundation/Foundation.h>

@interface PABlog : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *blogId;

- (instancetype) initWithDictionary:(NSDictionary *)blogItemDict;
@end
