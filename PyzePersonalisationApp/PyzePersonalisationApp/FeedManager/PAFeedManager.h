
#import <Foundation/Foundation.h>

@interface PAFeedManager : NSObject

+ (void) fetchBlogList:(void (^)(NSArray * blogList)) completionHandler;
+ (void) fetchBlogContentForId:(NSString *)blogId handler:(void (^)(NSString * blogList)) completionHandler;

@end
