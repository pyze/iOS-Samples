
#import "CADataManager.h"
#import "CAFeedManager.h"

static CADataManager *sharedInstance;

@interface CADataManager ()

@property (strong, nonatomic) CAProductList *productInfo;

@end

@implementation CADataManager

#pragma mark - Class methods

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CADataManager alloc] init];
    });
    return sharedInstance;
}


#pragma mark - Instance methods

- (void) fetchProductList {
    [CAFeedManager fetchProductList:^(CAProductList *productList) {
        self.productInfo = productList;
    }];
}

- (NSArray *) getProductList {
    return self.productInfo.productList;
}

@end
