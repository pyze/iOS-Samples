//
//  ALRandomDictionaryGenerator.m
//  AppLifecycle
//
//  Created by Ramachandra Naragund on 22/09/15.
//  Copyright (c) 2015 CollaboRight. All rights reserved.
//

#import "ALRandomDictionaryGenerator.h"

@implementation ALRandomDictionaryGenerator

+(NSArray *) arrayofDictionaries {
    NSArray * array = @[ @{ @"Interface": @"Bar Code",
                            @"Store": @"Stanford, CA",
                            @"Shelf": [NSNull null],
                            @"SKU": @"SKU222222222"},
                         @{
                             @"Mercedes-Benz SLK250" : [NSNumber numberWithInt:13],
                             @"Mercedes-Benz E350" : [NSNumber numberWithInt:22],
                             @"BMW M3 Coupe" : [NSNumber numberWithInt:19],
                             @"BMW X6" : [NSNumber numberWithInt:16],
                             },
                         @{
                             @"Audi TT" : @"John",
                             @"Audi Quattro (Black)" : @"Mary",
                             @"Audi Quattro (Silver)" : @"Bill",
                             @"Audi A7" : @"Bill"
                             },
                         @{
                             @"category": @"c",
                             @"title": @"crd",
                             @"id": @"65"
                             },
                         @{
                             @"name": @"Hayagreeva",  //String
                             @"age": @3,        //Number
                             @"date": @"2008-02-16T10:06:00Z"  //Date
                             }
                         ,
                         @{
                             @"lead singer": @"Marc",
                             @"drummer": @"Chris",
                             @"lead guitar": @"Richard",
                             @"bass guitar": @"Benj",
                             @"saxophonist": @"Jerry"
                             },
                         
                         @{ @"1": @"red", @"2": @"green", @"3": @"blue" },
                         
                         @{ @"Character" : @"Zelda",
                            @"Weapon" : @"Sword",
                            @"Hitpoints" : @50
                            },
                         @{
                             @"DrinkKey" : @"Beer",
                             @"StyleKey" : @"Stout",
                             @"ColorKey" : @"Jet Black"
                             },
                         @{
                             @"cat" :@"Fancy Feast",
                             @"dog" : @"Happidog"
                             }
                         ,
                         @{
                             @"anObject" : @55,
                             @"helloString" : @"Hello, World!",
                             @"magicNumber" : @42,
                             @"aValue" : @5.54
                             }
                         ,
                         @{
                             @"Interface": @"",
                             @"Store": @"Stanford, CA",
                             @"Shelf": @"Accessories",
                             @"SKU": @"SKU222222222",
                             },
                         @{@"javaStudents" : @1128, @"iosStudents" : @12},
                         @{
                             @"firstName" : @"Matt",
                             @"lastName" : @"Galloway",
                             @"age" : @28
                             },
                         @{@"name": @"Macbook Pro", @"price": @"1,799$"},
                         @{
                             @"Interface": @"Bar Code",
                             @"Store": @"Stanford, CA",
                             @"Shelf": [NSNull null],//@"Accessories",
                             @"SKU": @"SKU222222222",
                             },
                         @{
                             @"Interface": @"Bar Code",
                             @"Store": @"Stanford, CA",
                             @"Shelf": [NSNull null],//@"Accessories",
                             @"SKU": @"SKU222222222",
                             },
                         @{
                             @"Interface": @"Bar Code",
                             @"Store": @"Stanford, CA",
                             @"Shelf": [NSNull null],//@"Accessories",
                             @"SKU": @"SKU222222222",
                             },
                         @{
                             @"Interface": @"Bar Code",
                             @"Store": @"Stanford, CA",
                             @"Shelf": [NSNull null],//@"Accessories",
                             @"SKU": @"SKU222222222",
                             },
                         @{
                             @"Interface": @"Bar Code",
                             @"Store": @"Stanford, CA",
                             @"Shelf": [NSNull null],//@"Accessories",
                             @"SKU": @"SKU222222222",
                             },
                         @{
                             }
                         ];
    
    return array;
    
}
+(NSDictionary *) attributesDictionary
{
    NSInteger index = [self randomNumberBetween:0 to:20];
    NSLog(@"Random index = %d", (int) index );
    return [[self arrayofDictionaries] objectAtIndex:index];
}

+(NSInteger)randomNumberBetween:(NSInteger)from to:(NSInteger)to {
    
    return (NSInteger)from + arc4random() % (to-from+1);
}

@end
