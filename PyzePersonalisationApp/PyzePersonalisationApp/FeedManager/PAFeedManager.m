
#import "PAFeedManager.h"
#import "PABlog.h"

@implementation PAFeedManager

+ (void) fetchBlogList:(void (^)(NSArray * blogList)) completionHandler {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PyzeBlogList" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    __block NSMutableArray *blogItemArray = [NSMutableArray array];
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        
        NSArray *blogList = json[@"blogList"];
        if (blogList && blogList.count) {
            
            for (NSDictionary *blogItemDict in blogList) {
                PABlog *blogItem = [[PABlog alloc] initWithDictionary:blogItemDict];
                [blogItemArray addObject:blogItem];
            }
        }
    }
    completionHandler(blogItemArray);
    
}


+ (void) fetchBlogContentForId:(NSString *)blogId handler:(void (^)(NSString * blogList)) completionHandler {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PyzeBlogContent" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    __block NSString *content = @"";
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        content = json[blogId];
    }
    completionHandler(content);
    
}

@end
