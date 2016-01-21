//
//  PyzeClassParser.m
//  Pyze
//
//  Created by Ramachandra Naragund on 01/10/15.
//  Copyright © 2015 Pyze Technologies Pvt Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <Pyze/Pyze.h>

#import "PyzeClassParser.h"
#import "PyzeTableViewSrc.h"

@interface PyzeClassParser()

@property(nonatomic,strong) NSMutableArray * classNames;

@property(nonatomic,strong) NSMutableArray * menuConstructs;

-(void) parseClassesInPyze;

-(NSArray *)subclassesFromParentClass:(Class) parentClass;

@end

@implementation PyzeClassParser

-(instancetype)initWithDelegate:(id<PyzeClassParserDelegate>) delegate
{
    _delegate = nil;
    if( delegate != nil) {
        _delegate = delegate;
        self.menuConstructs = [NSMutableArray new];
        [self parseClassesInPyze];
    }
    return self;
}

-(void) parseClassesInPyze
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.classNames = [NSMutableArray arrayWithArray:[self subclassesFromParentClass:[PyzeCustomEvent class]]];
        [self.classNames addObject:NSStringFromClass([PyzeCustomEvent class])];
        
        self.classNames = (NSMutableArray*)[self.classNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        [self.classNames enumerateObjectsUsingBlock:^(NSString * _Nonnull className, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PyzeTableViewSrc * tableSrc = [[PyzeTableViewSrc alloc] init];
            tableSrc.title = className;
            tableSrc.items = [self parseMethodsForClass:NSClassFromString(className)];
            
            [self.menuConstructs addObject:tableSrc];
            if (idx == self.classNames.count-1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate didParserCompleteParsing:self.menuConstructs];
                });
            }
        }];
    });
}

-(NSArray *) parseMethodsForClass:(Class) aClass
{
    u_int count;
    
    Method* methods = class_copyMethodList(object_getClass(aClass), &count);
    NSMutableArray* methodArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        SEL selector = method_getName(methods[i]);
        const char* methodName = sel_getName(selector);
        [methodArray addObject:[NSString  stringWithCString:methodName encoding:NSUTF8StringEncoding]];
    }
    free(methods);
    return methodArray;
}


-(NSArray *)subclassesFromParentClass:(Class) parentClass
{
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    classes = NULL;
    classes = (Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++)
    {
        Class superClass = classes[i];
        do
        {
            superClass = class_getSuperclass(superClass);
        } while(superClass && superClass != parentClass);
        
        if (superClass == nil)
        {
            continue;
        }
        
        [result addObject:NSStringFromClass(classes[i])];
    }
    
    free(classes);
    
    return result;
}

@end
