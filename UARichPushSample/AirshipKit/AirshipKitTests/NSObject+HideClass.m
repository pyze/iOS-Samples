/* Copyright 2017 Urban Airship and Contributors */

#import "NSObject+HideClass.h"
#import "JRSwizzle.h"

@implementation NSObject (HideClass)

+ (void)hideClass {
    if ([self class]) {
        [self jr_swizzleClassMethod:@selector(class) withClassMethod:@selector(nilClass) error:nil];
    }
}

+ (void)revealClass {
    if (![self class]) {
        [self jr_swizzleClassMethod:@selector(nilClass) withClassMethod:@selector(class) error:nil];
    }
}

+ (Class)nilClass {
    return nil;
}

@end
