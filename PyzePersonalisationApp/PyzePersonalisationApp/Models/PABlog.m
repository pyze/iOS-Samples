
#import "PABlog.h"

@interface PABlog() <NSCoding>

@end

@implementation PABlog

#pragma mark - Init

- (instancetype) initWithDictionary:(NSDictionary *)blogItemDict {
    self = [super init];
    if (self) {
        self.title = (blogItemDict[@"title"] != nil) ? blogItemDict[@"title"] : @"";
        self.subTitle = (blogItemDict[@"subTitle"] != nil) ? blogItemDict[@"subTitle"] : @"";
        self.imageURL = (blogItemDict[@"imageURL"] != nil) ? blogItemDict[@"imageURL"] : @"";
        self.blogId = (blogItemDict[@"blogId"] != nil) ? blogItemDict[@"blogId"] : @"";
    }
    return self;
}

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.subTitle forKey:@"subTitle"];
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeObject:self.blogId forKey:@"blogId"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.subTitle = [aDecoder decodeObjectForKey:@"subTitle"];
        self.imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
        self.blogId = [aDecoder decodeObjectForKey:@"blogId"];
    }
    return self;
}

@end
