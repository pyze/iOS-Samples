/* Copyright 2017 Urban Airship and Contributors */

#import "NSObject+AnonymousKVO.h"
#import "UAGlobal.h"
#import <objc/runtime.h>

@interface UAAnonymousObserver()

@property (nonatomic, strong) id object;
@property (nonatomic, strong) UAAnonymousKVOBlock block;

@end

@interface NSObject();
@property (nonatomic, strong) NSMutableSet *anonymousObservers;
@end

@implementation UAAnonymousObserver

- (void)observe:(id)obj atKeypath:(NSString *)path withBlock:(UAAnonymousKVOBlock)block {
    if (!block) {
        UA_LINFO(@"KVO block must be non-null");
        return;
    }
    self.object = obj;
    self.block = block;
    [obj addObserver:self forKeyPath:path options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    self.block([object valueForKey:keyPath]);
}

@end

@implementation NSObject(AnonymousKVO)

@dynamic anonymousObservers;

- (UADisposable *)observeAtKeyPath:(NSString *)keyPath withBlock:(UAAnonymousKVOBlock)block {

    if (!block) {
        UA_LINFO(@"KVO block must be non-null");
        return nil;
    }

    UAAnonymousObserver *obs = [UAAnonymousObserver new];

    @synchronized(self) {
        if (!self.anonymousObservers) {
            self.anonymousObservers = [NSMutableSet setWithObject:obs];
        } else {
            [self.anonymousObservers addObject:obs];
        }
    }

    [obs observe:self atKeypath:keyPath withBlock:block];

    __weak NSObject *weakSelf = self;
    return [UADisposable disposableWithBlock:^{
        NSObject *strongSelf = weakSelf;
        [strongSelf removeObserver:obs forKeyPath:keyPath];
        @synchronized(self) {
            [strongSelf.anonymousObservers removeObject:obs];
        }
    }];
}

- (void)setAnonymousObservers:(NSSet *)anonymousObservers {
    objc_setAssociatedObject(self, @"com.urbanairship.anonymousObservers", anonymousObservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSSet *)anonymousObservers {
    return objc_getAssociatedObject(self, @"com.urbanairship.anonymousObservers");
}

@end
