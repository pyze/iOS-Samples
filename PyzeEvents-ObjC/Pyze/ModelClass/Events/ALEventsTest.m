//
//  ALEventsTest.m
//  AppLifecycle
//
//  Created by Ramachandra Naragund on 21/09/15.
//  Copyright (c) 2015 CollaboRight. All rights reserved.
//

#import "ALEventsTest.h"
#import <Pyze/Pyze.h>
#import "ALRandomDictionaryGenerator.h"
#import <objc/runtime.h>

#import <objc/message.h>


@interface ALEventsTest ()
+(NSArray *) executeExplicitEvents;

+(NSArray *) executeAdEvents;

+(NSArray *) executeAdvocacyEvents;

+(NSArray *) executeAccountsEvents;

+(NSArray *) executeCommerceDiscoveryEvents;

+(NSArray *) executeCommerceCuratedListEvents;

+(NSArray *) executeCommerceWishListEvents;

+(NSArray *) executeCommerceBeaconEvents;

+(NSArray *) executeCommerceCartEvents;

+(NSArray *) executeCommerceItemEvents;

+(NSArray *) executeCommerceCheckoutEvents;

+(NSArray *) executeCommerceShippingEvents;

+(NSArray *) executeCommerceBillingEvents;

+(NSArray *) executeCommercePaymentEvents;

+(NSArray *) executeCommerceRevenueEvents;

+(NSArray *) executeGamingEvents;

+(NSArray *) executeHealthAndFitnessEvents;

+(NSArray *) executeContentEvents;

+(NSArray *) executeMessagingEvents;

+(NSArray *) executeInAppPurchaseRevenueEvents;

+(NSArray *) executeTaskEvents;

+(NSArray *) executeSocialEvents;

+(NSArray *) executeMediaEvents;

+(NSArray *) executeBitcoinEvents;

+(NSArray *) executeCustomExample;

+(NSArray *) executeDroneEvents;

+(NSArray *) executeSupportEvents;

+(NSArray *) executeCommerceSupportEvents;

+(NSArray *) executeWeatherAndForecastEvents;
@end

@implementation ALEventsTest

#define MacroStr(cmd) NSStringFromSelector(@selector(cmd))
#define ExecuteSafely

NSIndexPath * g_indexPath;
BOOL g_shouldExecute;

+(void) executeTestEventsInBackgroundWithIndexPath:(NSIndexPath *) indexPath
                                     shouldExecute:(BOOL) shouldExecute
                             withCompletionHandler:(void (^)(NSArray * result))completionHandler
{
    g_indexPath = indexPath;
    g_shouldExecute = shouldExecute;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray * array = [NSArray arrayWithObjects:
                           MacroStr(executeExplicitEvents),
                           MacroStr(executeAdEvents) ,
                           MacroStr(executeAdvocacyEvents),
                           MacroStr(executeAccountsEvents),
                           MacroStr(executeCommerceDiscoveryEvents),
                           MacroStr(executeCommerceCuratedListEvents),
                           MacroStr(executeCommerceWishListEvents),
                           MacroStr(executeCommerceBeaconEvents),
                           MacroStr(executeCommerceCartEvents),
                           MacroStr(executeCommerceItemEvents),
                           MacroStr(executeCommerceCheckoutEvents),
                           MacroStr(executeCommerceShippingEvents),
                           MacroStr(executeCommerceBillingEvents),
                           MacroStr(executeCommercePaymentEvents),
                           MacroStr(executeCommerceRevenueEvents),
                           MacroStr(executeGamingEvents),
                           MacroStr(executeHealthAndFitnessEvents),
                           MacroStr(executeContentEvents),
                           MacroStr(executeMessagingEvents),
                           MacroStr(executeInAppPurchaseRevenueEvents),
                           MacroStr(executeTaskEvents),
                           MacroStr(executeSocialEvents),
                           MacroStr(executeMediaEvents),
                           MacroStr(executeBitcoinEvents),
                           MacroStr(executeDroneEvents),
                           MacroStr(executeSupportEvents),
                           MacroStr(executeCommerceSupportEvents),
                           MacroStr(executeWeatherAndForecastEvents),
                           nil];
        
        
        array = [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        if (g_shouldExecute)
            NSLog(@"%@",array);

        SEL selector = NSSelectorFromString([array objectAtIndex:indexPath.section]);
        
        NSMethodSignature *methodSig = [[self class] methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setSelector:selector];
        [invocation setTarget:self];
        [invocation invoke];
        void *tempResultSet;
        [invocation getReturnValue:&tempResultSet];
        NSArray * result = (__bridge NSArray *)tempResultSet;
        completionHandler(result);
    });
}

+(NSArray *) executeExplicitEvents
{
    NSDictionary * attributes = @{@"myAppKeyCode" : [ALRandomDictionaryGenerator new]};
    NSArray * result = g_shouldExecute ? nil : [NSArray arrayWithObjects:@[], attributes , nil];
    if (g_shouldExecute)
        [PyzeExplicitActivation post:attributes];
    return result;
}

+(NSArray *) executeAdEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    if (g_indexPath.row == 0) {
        arguments = @[@"", @"home", [NSValue valueWithCGSize:CGSizeMake(320, 160)], @"banner"];
        if (g_shouldExecute) {
            [PyzeAd postAdRequested:arguments[0]
                      fromAppScreen:arguments[1]
                         withAdSize:[arguments[2] CGSizeValue]
                             adType:arguments[3]
                     withAttributes:attributes];
        }
    }
    else if (g_indexPath.row == 1) {
        arguments = @[@"google", @"home", @"200",[NSNumber numberWithBool:YES]];
        if (g_shouldExecute)
            [PyzeAd postAdReceived:arguments[0]
                     fromAppScreen:arguments[1]
                    withResultCode:arguments[2]
                         isSuccess:[arguments[2] boolValue]
                    withAttributes:attributes];
    }
    else
    {
        arguments = @[@"google", @"home", @"tempADCODE",[NSNumber numberWithBool:YES],@"200"];
        if (g_shouldExecute)
            [PyzeAd postAdClicked:arguments[0]
                    fromAppScreen:arguments[1]
                           adCode:arguments[2]
                        isSuccess:arguments[3]
                    withErrorCode:arguments[4]
                   withAttributes:attributes];
    }
    return g_shouldExecute ? nil :[NSArray arrayWithObjects:arguments, attributes, nil];
    
}

+(NSArray *) executeAdvocacyEvents
{
    if (g_indexPath.row == 0) {
        NSDictionary * attributes = @{@"requestNo" : @"54321",
                                      @"feedbackText" : @"This is a lovely app"};
        NSArray * result = g_shouldExecute ? nil :[NSArray arrayWithObjects:@[], attributes, nil];
        if (g_shouldExecute)
            [PyzeAdvocacy postRequestForFeedback:attributes];
        
        return result;
    }
    else if (g_indexPath.row == 0) {
        NSDictionary * attributes = @{@"requestNo" : @"54321",
                                      @"feedbackRating": @"4",
                                      @"feedbackText" : @"This is a lovely app"};
        NSArray * result = g_shouldExecute ? nil :[NSArray arrayWithObjects:@[], attributes, nil];
        if (g_shouldExecute)
            [PyzeAdvocacy postRequestRating:attributes];
        return result;
    }
    else {
        NSDictionary * attributes = @{@"requestNo" : @"54321",
                                      @"feedbackResponse" : @"Your feedback is appreciated, we would get back to you shortly with detailed response"};
        NSArray * result = g_shouldExecute ? nil :[NSArray arrayWithObjects:@[], attributes, nil];
        if (g_shouldExecute)
            [PyzeAdvocacy postFeedbackProvided:attributes];
        return result;
    }
}

+(NSArray *) executeAccountsEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        if (g_shouldExecute)
            [PyzeAccount postRegistrationOffered:attributes];
    }
    else if (g_indexPath.row == 1)
    {
        if (g_shouldExecute)
            [PyzeAccount postRegistrationStarted:attributes];
    }
    else if (g_indexPath.row == 2){
        if (g_shouldExecute)
            [PyzeAccount postRegistrationCompleted:attributes];
        
    }
    else if (g_indexPath.row == 3){
        arguments = @[[NSNumber numberWithBool:YES], @"200"];
        if (g_shouldExecute)
            [PyzeAccount postLoginCompleted:[arguments[0] boolValue]
                                withErrCode:arguments[1]
                              withAttributes:attributes];
    }
    else if (g_indexPath.row == 4){
        if (g_shouldExecute)
            [PyzeAccount postPasswordResetRequested:attributes];
    }
    else {
        arguments = @[[NSNumber numberWithBool:YES]];
        
        if (g_shouldExecute)
            [PyzeAccount postLogoutCompleted:[arguments[0] boolValue]
                              withAttributes:attributes];
    }
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
    
}

+(NSArray *) executeCommerceDiscoveryEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        arguments = @[@"HelloWorld!",[NSNumber numberWithFloat:10.0f]];
        if (g_shouldExecute)
            [PyzeCommerceDiscovery postSearched:arguments[0]
                                    withLatency:arguments[1]
                                 withAttributes:attributes];
    }
    
    else if (g_indexPath.row == 1){
        arguments = @[@"general"];
        
        if (g_shouldExecute)
            [PyzeCommerceDiscovery postBrowsedCategory:arguments[0]
                                        withAttributes:attributes];
    }
    
    else if (g_indexPath.row == 2){
        arguments = @[@"offers"];
        if (g_shouldExecute)
            [PyzeCommerceDiscovery postBrowsedDeals:arguments[0]
                                     withAttributes:attributes];
    }
    
    else if (g_indexPath.row == 3){
        arguments = @[@"Todays Deals"];
        if (g_shouldExecute)
            [PyzeCommerceDiscovery postBrowsedRecommendations:arguments[0]
                                               withAttributes:attributes];
    }
    
    else {
        arguments = @[@"page1",@"page2"];
        if (g_shouldExecute)
            [PyzeCommerceDiscovery postBrowsedPrevOrders:arguments[0]
                                                 withEnd:arguments[1]
                                          withAttributes:attributes];
    }
    return  g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];;
    
}

+(NSArray *) executeCommerceCuratedListEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        arguments = @[@"54321",@"general"];
        if (g_shouldExecute)
            [PyzeCommerceCuratedList postCreated:arguments[0]
                                        withType:arguments[1]
                                  withAttributes:attributes];
    }
    
    else if (g_indexPath.row == 1) {
        arguments = @[@"general",@"default"];
        if (g_shouldExecute)
            [PyzeCommerceCuratedList postBrowsed:arguments[0]
                                     withCreator:arguments[1]
                                  withAttributes:attributes];
    }
    else if (g_indexPath.row == 2){
        arguments = @[@"987654",@"general",@"112233"];
        if (g_shouldExecute)
            [PyzeCommerceCuratedList postAddedItem:arguments[0]
                                      withCategory:arguments[1]
                                        withItemId:arguments[2]
                                    withAttributes:attributes];
    }
    
    else if (g_indexPath.row == 3){
        arguments = @[@"987654",@"general",@"112233"];
        if (g_shouldExecute)
            [PyzeCommerceCuratedList postRemovedItem:arguments[0]
                                        withListType:arguments[1]
                                          withItemID:arguments[2]
                                      withAttributes:attributes];
    }
    
    else if (g_indexPath.row == 4){
        arguments = @[@"general",@"default"];
        if (g_shouldExecute)[PyzeCommerceCuratedList postShared:arguments[0]
                                                    withCreator:arguments[1]
                                                 withAttributes:attributes];
    }
    
    else{
        arguments = @[@"general",@"default"];
        if (g_shouldExecute)[PyzeCommerceCuratedList postPublished:arguments[0]
                                                       withCreator:arguments[1]
                                                    withAttributes:attributes];
    }
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
    ;
}


+(NSArray *) executeCommerceWishListEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0) {
        arguments = @[@"654432",@"general"];
        if (g_shouldExecute)[PyzeCommerceWishList postCreated:arguments[0]
                                             withWishListType:arguments[1]
                                               withAttributes:attributes];
    }
    
    else if (g_indexPath.row == 1){
        arguments = @[@"654432"];
        if (g_shouldExecute)[PyzeCommerceWishList postBrowsed:arguments[0]
                                               withAttributes:attributes];
    }
    else if (g_indexPath.row == 2){
        arguments = @[@"432156",@"appliances",@"0012232"];
        if (g_shouldExecute)[PyzeCommerceWishList postAddedItem:arguments[0]
                                               withItemCategory:arguments[1]
                                                     withItemId:arguments[2]
                                                 withAttributes:attributes];
    }
    else if (g_indexPath.row == 3){
        arguments = @[@"432156",@"appliances",@"0012232"];
        if (g_shouldExecute)[PyzeCommerceWishList postRemovedItem:arguments[0]
                                                 withItemCategory:arguments[1]
                                                       withItemId:arguments[2]
                                                   withAttributes:attributes];
    }
    
    else{
        arguments = @[@"432156"];
        if (g_shouldExecute) [PyzeCommerceWishList postShared:arguments[0]
                                               withAttributes:attributes];
    }
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
    ;
    
}

+(NSArray *) executeCommerceBeaconEvents
{    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        arguments = @[@"11223344",@"321123",@"321122",@"44332211"];
        if (g_shouldExecute)[PyzeCommerceBeacon postEnteredRegion:arguments[0]
                                                  withBeaconMajor:arguments[1]
                                                  withBeaconMinor:arguments[2]
                                       withUniqueRegionIdentifier:arguments[3]
                                                   withAttributes:attributes];
    }
    else if (g_indexPath.row == 1){
        arguments = @[@"11223344",@"321123",@"321122",@"44332211"];
        if (g_shouldExecute)[PyzeCommerceBeacon postExitedRegion:arguments[0]
                                                 withBeaconMajor:arguments[1]
                                                 withBeaconMinor:arguments[2]
                                      withUniqueRegionIdentifier:arguments[3]
                                                  withAttributes:attributes];
    }
    
    else {
        arguments = @[@"11223344",@"321123",@"321122",@"44332211",@"near",@"post"];
        if (g_shouldExecute)[PyzeCommerceBeacon postTransactedInRegion:arguments[0]
                                                       withBeaconMajor:arguments[0]
                                                       withBeaconMinor:arguments[1]
                                            withUniqueRegionIdentifier:arguments[2]
                                                         withProximity:arguments[3]
                                                          withActionId:arguments[4]
                                                        withAttributes:attributes];
    }
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}


+(NSArray *) executeCommerceCartEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        arguments = @[@"data",@"category",@"112233"];
        if (g_shouldExecute)[PyzeCommerceCart postAddItem:arguments[0]
                                         withItemCategory:arguments[1]
                                               withItemId:arguments[2]
                                           withAttributes:attributes];
    }
    else if (g_indexPath.row == 1){
        arguments = @[@"deal321",@"general",@"112233",@"deal321"];
        if (g_shouldExecute)[PyzeCommerceCart postAddItemFromDeals:arguments[0]
                                                  withItemCategory:arguments[1]
                                                        withItemId:arguments[2]
                                                  withUniqueDealId:arguments[3]
                                                    withAttributes:attributes];
    }
    else if (g_indexPath.row == 2){
        arguments = @[@"32121",@"general",@"112233",@"wishList321"];
        if (g_shouldExecute)[PyzeCommerceCart postAddItemFromWishList:arguments[0]
                                                     withItemCategory:arguments[1]
                                                           withItemId:arguments[2]
                                                 withUniqueWishListId:arguments[3]
                                                       withAttributes:attributes];
    }
    else if (g_indexPath.row == 3){
        arguments = @[@"32121",@"general",@"112233",@"uniqueCuratedList4321"];
        if (g_shouldExecute)[PyzeCommerceCart postAddItemFromCuratedList:arguments[0]
                                                        withItemCategory:arguments[1]
                                                              withItemId:arguments[2]
                                                 withUniqueCuratedListId:arguments[3]
                                                          withAttributes:attributes];
        
    }
    else if (g_indexPath.row == 4){
        arguments = @[@"32121",@"general",@"112233",@"uniqueRecommendation321"];
        if (g_shouldExecute)[PyzeCommerceCart postAddItemFromRecommendations:arguments[0]
                                                            withItemCategory:arguments[1]
                                                                  withItemId:arguments[2]
                                                  withUniqueRecommendationId:arguments[3]
                                                              withAttributes:attributes];
    }
    else if (g_indexPath.row == 5){
        arguments = @[@"32121",@"general",@"112233",@"previousOrderId112233"];
        if (g_shouldExecute)[PyzeCommerceCart postAddItemFromPreviousOrders:arguments[0]
                                                           withItemCategory:arguments[1]
                                                                 withItemId:arguments[2]
                                                        withPreviousOrderId:arguments[3]
                                                             withAttributes:attributes];
    }
    else if (g_indexPath.row == 6){
        arguments = @[@"32121",@"general",@"112233",@"uniqueDealId4321"];
        if (g_shouldExecute)[PyzeCommerceCart postAddItemFromSubscriptionList:arguments[0]
                                                            withItemCategory:arguments[1]
                                                                  withItemId:arguments[2]
                                                            withUniqueDealId:arguments[3]
                                                              withAttributes:attributes];
    }
    else if (g_indexPath.row == 7){
        arguments = @[@"32121",@"general",@"112233"];
        if (g_shouldExecute)[PyzeCommerceCart postRemoveItemFromCart:arguments[0]
                                                    withItemCategory:arguments[1]
                                                          withItemId:arguments[2]
                                                      withAttributes:attributes];
    }
    else if (g_indexPath.row == 8){
        arguments = @[@"orders"];
        if (g_shouldExecute)[PyzeCommerceCart postView:arguments[0] withAttributes:attributes];
    }
    else if (g_indexPath.row == 8){
        arguments = @[@"321212",@"fb",@"121212"];
        if (g_shouldExecute) [PyzeCommerceCart postShare:arguments[0]
                                      withItemSharedWith:arguments[1]
                                              withItemId:arguments[2]
                                          withAttributes:attributes];
    }
    else {
        arguments = @[@"Test search", @"content search", @"322323", @"test"];
     if (g_shouldExecute) [PyzeCommerceCart postAddItemFromSearchResults:arguments[0]
                                                        withItemCategory:arguments[1]
                                                              withItemId:arguments[2]
                                                        withSearchString:arguments[3]
                                                          withAttributes:attributes];
    }
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}

+(NSArray *) executeCommerceItemEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        if (g_shouldExecute)[PyzeCommerceItem postViewedItem:attributes];
    }
    else if (g_indexPath.row == 1) {if (g_shouldExecute)[PyzeCommerceItem postScannedItem:attributes];}
    else if (g_indexPath.row == 2) {if (g_shouldExecute)[PyzeCommerceItem postViewedReviews:attributes];}
    else if (g_indexPath.row == 3) {if (g_shouldExecute)[PyzeCommerceItem postViewedDetails:attributes];}
    else if (g_indexPath.row == 4) {if (g_shouldExecute)[PyzeCommerceItem postViewedPrice:attributes];}
    else if (g_indexPath.row == 5) {if (g_shouldExecute)[PyzeCommerceItem postItemShareItem:attributes];}
    else {
        arguments = @[@"sku32121",@"4"];
        if (g_shouldExecute)
            [PyzeCommerceItem postItemRateOn5Scale:arguments[0]
                                        withRating:arguments[0]
                                    withAttributes:attributes];
    }
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}


+(NSArray *) executeCommerceCheckoutEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    
    if (g_indexPath.row == 0){if (g_shouldExecute)[PyzeCommerceCheckout postCheckoutStarted:attributes];}
    else if (g_indexPath.row == 1){if (g_shouldExecute)[PyzeCommerceCheckout postCheckoutCompleted:attributes];}
    else if (g_indexPath.row == 2){if (g_shouldExecute)[PyzeCommerceCheckout postCheckoutAbandoned:attributes];}
    else {if (g_shouldExecute)[PyzeCommerceCheckout postCheckoutFailed:attributes];}
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: @[],attributes,nil];
}


+(NSArray *) executeCommerceShippingEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    
    if (g_indexPath.row == 0){if (g_shouldExecute)[PyzeCommerceShipping postShippingStarted:attributes];}
    else if (g_indexPath.row == 1){if (g_shouldExecute)[PyzeCommerceShipping postShippingCompleted:attributes];}
    else if (g_indexPath.row == 2){if (g_shouldExecute)[PyzeCommerceShipping postShippingAbandoned:attributes];}
    else {if (g_shouldExecute)[PyzeCommerceShipping postShippingFailed:attributes];}
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: @[],attributes,nil];
}

+(NSArray *) executeCommerceBillingEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    
    if (g_indexPath.row == 0) {if (g_shouldExecute)[PyzeCommerceBilling postBillingStarted:attributes];}
    else if (g_indexPath.row == 1){if (g_shouldExecute)[PyzeCommerceBilling postBillingCompleted:attributes];}
    else if (g_indexPath.row == 2){if (g_shouldExecute)[PyzeCommerceBilling postBillingAbandoned:attributes];}
    else {if (g_shouldExecute) [PyzeCommerceBilling postBillingFailed:attributes];}
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: @[],attributes,nil];
}

+(NSArray *) executeCommercePaymentEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    
    if (g_indexPath.row == 0){if (g_shouldExecute)[PyzeCommercePayment postPaymentStarted:attributes];}
    else if (g_indexPath.row == 1){if (g_shouldExecute)[PyzeCommercePayment postPaymentCompleted:attributes];}
    else if (g_indexPath.row == 2){if (g_shouldExecute)[PyzeCommercePayment postPaymentAbandoned:attributes];}
    else {if (g_shouldExecute)[PyzeCommercePayment postPaymentFailed:attributes];}
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: @[],attributes,nil];
}


+(NSArray *) executeCommerceRevenueEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){if (g_shouldExecute)[PyzeCommerceRevenue postRevenue:[NSNumber numberWithInt:10000]
                                                                    withAttributes:attributes];}
    else if (g_indexPath.row == 1){if (g_shouldExecute)[PyzeCommerceRevenue postRevenueUsingApplePay:[NSNumber numberWithFloat:3.99]
                                                                                      withAttributes:attributes];}
    else if (g_indexPath.row == 2){if (g_shouldExecute)[PyzeCommerceRevenue postRevenueUsingSamsungPay:[NSNumber numberWithFloat:2.99]
                                                                                        withAttributes:attributes];}
    else if (g_indexPath.row == 3){if (g_shouldExecute)[PyzeCommerceRevenue postRevenueUsingGooglePay:[NSNumber numberWithFloat:1.99]
                                                                                       withAttributes:attributes];}
    else {
        arguments = @[[NSNumber numberWithInt:5],@"online"];
        if (g_shouldExecute)[PyzeCommerceRevenue postRevenue:arguments[0]
                                       withPaymentInstrument:arguments[1]
                                              withAttributes:attributes];
    }
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}

+(NSArray *) executeGamingEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        arguments = @[@"level1"];
        if (g_shouldExecute)
            [PyzeGaming postLevelStarted:arguments[0]
                          withAttributes:attributes];
    }
    else if (g_indexPath.row == 1){
        arguments = @[@"level1",@"10",@"success"];
        if (g_shouldExecute)[PyzeGaming postLevelEnded:arguments[0]
                                             withScore:arguments[1]
                                  withSuccessOrFailure:arguments[2]
                                        withAttributes:attributes];
    }
    else if (g_indexPath.row == 2){
        arguments = @[@"level1",@"boost",@"2"];
        if (g_shouldExecute)[PyzeGaming postPowerUpConsumed:arguments[0]
                                                   withType:arguments[1]
                                                  withValue:arguments[2]
                                             withAttributes:attributes];
    }
    else if (g_indexPath.row == 3){
        arguments = @[@"112233",@"powerup",@"1.99"];
        if (g_shouldExecute)[PyzeGaming postInGameItemPurchased:arguments[0]
                                                   withItemType:arguments[1]
                                                  withItemValue:arguments[2]
                                                 withAttributes:attributes];
    }
    else if (g_indexPath.row == 4){
        arguments = @[@"High score",@"general"];
        if (g_shouldExecute)[PyzeGaming postAchievementEarned:arguments[0]
                                                     withType:arguments[1]
                                               withAttributes:attributes];
    }
    else if (g_indexPath.row == 5){
        arguments = @[@"level1",@"10"];
        if (g_shouldExecute)[PyzeGaming postSummaryViewed:arguments[0]
                                                withScore:arguments[1]
                                           withAttributes:attributes];
    }
    else if (g_indexPath.row == 6){
        arguments = @[@"level1",@"10"];
        if (g_shouldExecute)[PyzeGaming postLeaderBoardViewed:arguments[0]
                                                    withScore:arguments[1]
                                               withAttributes:attributes];
        
    }
    else if (g_indexPath.row == 7){
        arguments = @[@"level1",@"10"];
        if (g_shouldExecute)[PyzeGaming postScorecardViewed:arguments[0]
                                                  withScore:arguments[1]
                                             withAttributes:attributes];
    }
    
    else if (g_indexPath.row == 8){
        arguments = @[@"4321123"];
        if (g_shouldExecute)[PyzeGaming postHelpViewed:arguments[0]
                                        withAttributes:attributes];
    }
    else if (g_indexPath.row == 9){
        arguments = @[@"How to controls"];
        if (g_shouldExecute)[PyzeGaming postTutorialViewed:arguments[0]
                                            withAttributes:attributes];
    }
    else if (g_indexPath.row == 10){ if (g_shouldExecute)[PyzeGaming postFriendChallenged:attributes];}
    else if (g_indexPath.row == 11){ if (g_shouldExecute)[PyzeGaming postChallengeAccepted:attributes];}
    else if (g_indexPath.row == 12){ if (g_shouldExecute)[PyzeGaming postChallengeDeclined:attributes];}
    else if (g_indexPath.row == 13){
        arguments = @[@"level2"];
        if (g_shouldExecute)
            [PyzeGaming postGameStart:arguments[0] withAttributes:attributes];
    }
    
    else {
        arguments = @[@"level12",@"11"];
        if (g_shouldExecute)[PyzeGaming postGameEnd:arguments[0]
                                      withLevelsWon:arguments[1]
                                     withAttributes:attributes];
    }
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}

+(NSArray *) executeHealthAndFitnessEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    
    if (g_indexPath.row == 0){ if (g_shouldExecute)[PyzeHealthAndFitness postStarted:attributes];}
    else if (g_indexPath.row == 1){ if (g_shouldExecute)[PyzeHealthAndFitness postEnded:attributes];}
    else if (g_indexPath.row == 2){ if (g_shouldExecute)[PyzeHealthAndFitness postAchievementReceived:attributes];}
    else if (g_indexPath.row == 3){ if (g_shouldExecute)[PyzeHealthAndFitness postStepGoalCompleted:attributes];}
    else if (g_indexPath.row == 4){ if (g_shouldExecute)[PyzeHealthAndFitness postGoalCompleted:attributes];}
    else if (g_indexPath.row == 5){ if (g_shouldExecute)[PyzeHealthAndFitness postChallengedFriend:attributes];}
    else { if (g_shouldExecute)[PyzeHealthAndFitness postChallengeAccepted:attributes];}
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: @[],attributes,nil];
}

+(NSArray *) executeContentEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    
    if (g_indexPath.row == 0){
        arguments = @[@"News",@"News",@"news/1232123"];
        if (g_shouldExecute)[PyzeContent postViewed:arguments[0]
                                           category:arguments[1]
                                withUniqueContentId:arguments[2]
                                     withAttributes:attributes];
    }
    
    else if (g_indexPath.row == 1){
        arguments = @[@"Narendra Modi"];
        if (g_shouldExecute)[PyzeContent postSearched:arguments[0]
                                       withAttributes:attributes];
    }
    else if (g_indexPath.row == 2){
        arguments = @[@"News",@"News",@"news/1232123",[NSDecimalNumber decimalNumberWithString:@"4"]];
        if (g_shouldExecute)[PyzeContent postRatedOn5PointScale:arguments[0]
                                                       category:arguments[1]
                                            withUniqueContentId:arguments[2]
                                                  contentRating:arguments[3]
                                                 withAttributes:attributes];
    }
    else if (g_indexPath.row == 3){
        arguments = @[@"News",@"Local News",@"1234321"];
        if (g_shouldExecute)[PyzeContent postRatedThumbsUp:arguments[10]
                                                  category:arguments[1]
                                       withUniqueContentId:arguments[2]
                                            withAttributes:attributes];
    } else {
        arguments = @[@"News",@"Local News",@"1234321"];
        if (g_shouldExecute)[PyzeContent postRatedThumbsDown:arguments[0]
                                                    category:arguments[1]
                                         withUniqueContentId:arguments[2]
                                              withAttributes:attributes];
    }
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}

+(NSArray *) executeMessagingEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){ arguments = @[@"1234321"];if (g_shouldExecute)[PyzeMessaging postMessageSent:arguments[0] withAttributes:attributes];}
    else if (g_indexPath.row == 1){ arguments = @[@"1234321"];if (g_shouldExecute)[PyzeMessaging postMessageSent:arguments[0] withAttributes:attributes];}
    else if (g_indexPath.row == 2){ arguments = @[@"1234321"]; if (g_shouldExecute)[PyzeMessaging postMessageReceived:arguments[0] withAttributes:attributes];}
    else if (g_indexPath.row == 3){ arguments = @[@"0987654321"]; if (g_shouldExecute)[PyzeMessaging postMessageNewConversation:arguments[0] withAttributes:attributes];}
    else { arguments = @[@"0987654321"];if (g_shouldExecute)[PyzeMessaging postMessageVoiceCall:arguments[0] withAttributes:attributes];}
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}

+(NSArray *) executeInAppPurchaseRevenueEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        arguments = @[@"4444"];
        if (g_shouldExecute)[PyzeInAppPurchaseRevenue postPriceListViewViewed:arguments[0]
                                                               withAttributes:attributes];
    }
    else if (g_indexPath.row == 1){
        arguments = @[@"myItem",[NSDecimalNumber decimalNumberWithString:@"9.99"],@"us-d"];
        if (g_shouldExecute)[PyzeInAppPurchaseRevenue postBuyItem:arguments[0]
                                                            price:arguments[1]
                                                         currency:arguments[2]
                                                   withAttributes:attributes];
    }
    else if (g_indexPath.row == 2){
        arguments = @[@"4444",[NSDecimalNumber decimalNumberWithString:@"9.99"]];
        if (g_shouldExecute)[PyzeInAppPurchaseRevenue postBuyItemInUSD:arguments[0]
                                                                 price:arguments[1]
                                                        withAttributes:attributes];
    }
    else{
        arguments = @[@"4444",[NSDecimalNumber decimalNumberWithString:@"9.99"],@"us-d",@"extraContent",@"extraContent",@"1",@"rq321431", [NSNumber numberWithBool:YES],@"300"];
        if (g_shouldExecute) [PyzeInAppPurchaseRevenue postBuyItem:arguments[0]
                                                             price:arguments[1]
                                                          currency:arguments[2]
                                                          itemType:arguments[3]
                                                           itemSKU:arguments[4]
                                                          quantity:arguments[5]
                                                         requestId:arguments[6]
                                                            status:[arguments[7] boolValue]
                                                       successCode:arguments[8]
                                                    withAttributes:attributes];
    }
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}

+(NSArray *) executeTaskEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    if (g_shouldExecute)
        [PyzeTasks addToCalendarwithAttributes:attributes];
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: @[],attributes,nil];
}

+(NSArray *) executeSocialEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        arguments = @[@"fb",@"fb/3212",@"social"];
        if (g_shouldExecute)[PyzeSocial postSocialContentShareForNetworkName:arguments[0]
                                                         forContentReference:arguments[1]
                                                                    category:arguments[2]
                                                              withAttributes:attributes];
    }
    else if (g_indexPath.row == 1){
        arguments = @[@"fb",@"fb/3212",@"friendPost"];
        if (g_shouldExecute)[PyzeSocial postLiked:arguments[0]
                              forContentReference:arguments[1]
                                         category:arguments[2]
                                   withAttributes:attributes];
    }
    else if (g_indexPath.row == 2){
        arguments = @[@"fb",@"fb/21212121212",@"Movies"];
        if (g_shouldExecute)[PyzeSocial postFollowed:arguments[0]
                                 forContentReference:arguments[1]
                                            category:@"Movies"
                                      withAttributes:attributes];
    }
    else if (g_indexPath.row == 3){
        arguments = @[@"fb",@"fb/21212121212",@"Robert Downey Jr."];
        if (g_shouldExecute)[PyzeSocial postSubscribed:arguments[0]
                                  forContentReference:arguments[1]
                                             category:arguments[1]
                                       withAttributes:attributes];
    }
    else if (g_indexPath.row == 4){
        arguments = @[@"fb/4323123121231"];
        if (g_shouldExecute)[PyzeSocial postInvitedFriend:arguments[0]
                                           withAttributes:attributes];
    }
    else {
        arguments = @[@"fb"];
        if (g_shouldExecute)[PyzeSocial postFoundFriends:arguments[0] withAtrributes:attributes];
    }
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}

+(NSArray *) executeMediaEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        arguments = @[@"breaking news",@"video",@"news",@"100",@"12343221"];
        if (g_shouldExecute)[PyzeMedia postPlayedMedia:arguments[0]
                                             mediaType:arguments[1]
                                              category:arguments[2]
                                         percentPlayed:arguments[3]
                                   withUniqueContentId:arguments[4]
                                        withAttributes:attributes];
    }
    else if (g_indexPath.row == 1){
        arguments = @[@"Robert Downey Jr."];
        if (g_shouldExecute)[PyzeMedia postSearched:arguments[0]
                                     withAttributes:attributes];
    }
    else if (g_indexPath.row == 2){
        arguments = @[@"breaking news",@"news",@"12343221",[NSDecimalNumber decimalNumberWithString:@"1"]];
        if (g_shouldExecute)[PyzeMedia postRatedOn5PointScale:arguments[0]
                                                     category:arguments[0]
                                          withUniqueContentId:arguments[2]
                                                contentRating:arguments[3]
                                               withAttributes:attributes];
    }
    else if (g_indexPath.row == 3){
        arguments = @[@"breaking news",@"news",@"12343221"];
        if (g_shouldExecute)[PyzeMedia postRatedThumbsUp:arguments[0]
                                                category:arguments[0]
                                     withUniqueContentId:arguments[2]
                                          withAttributes:attributes];
    }
    else{
        arguments = @[@"breaking news",@"news",@"12343221"];
        if (g_shouldExecute) [PyzeMedia postRatedThumbsDown:arguments[0]
                                                   category:arguments[1]
                                        withUniqueContentId:arguments[2]
                                             withAttributes:attributes];
    }
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}

+(NSArray *) executeBitcoinEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    
    if (g_indexPath.row == 0){ if (g_shouldExecute) [PyzeBitcoin postSentBitcoins:attributes];}
    else if (g_indexPath.row == 1){ if (g_shouldExecute) [PyzeBitcoin postRequestedBitcoins:attributes];}
    else if (g_indexPath.row == 2){ if (g_shouldExecute) [PyzeBitcoin postReceivedBitcoins:attributes];}
    else if (g_indexPath.row == 3){ if (g_shouldExecute) [PyzeBitcoin postViewedTransactions:attributes];}
    else if (g_indexPath.row == 4){ if (g_shouldExecute) [PyzeBitcoin postImportedPrivateKey:attributes];}
    else { if (g_shouldExecute) [PyzeBitcoin postScannedPrivateKey:attributes];}
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: @[],attributes,nil];

}

+(NSArray *)executeCustomExample
{
    //
    // Custom event handling.
    //
    [PyzeCustomEvent postWithEventName:@"Blog Read1" withAttributes:@{@"Author":@"Nav S",
                                                                        @"User status":@"Registered",
                                                                        @"Article Source" : @"CNN",
                                                                        @"Publish Time": @"12-17-2015"}];
    //
    // Alternate way to pass value1,key1, value2,key2 ...
    //
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Nav S", @"Author",
                                 @"Registered", @"User_Status",
                                 @"Article Source", @"CNN",
                                 @"Publish Time",@"12-17-2015",nil];
    
    [PyzeCustomEvent postWithEventName:@"Blog Read2" withAttributes:attributes];
    [PyzeCustomEvent postWithEventName:@"Blog Read3" withAttributes:nil];
    return  nil;
    
}

+(NSArray *) executeDroneEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        arguments = @[@"Good",@"Excellent",[@(90) stringValue], [@(90) stringValue], @"Working", @"Enabled"];
        if (g_shouldExecute)[PyzeDrone postPreflightCheckCompleted:arguments[0]
                                                 withStorageStatus:arguments[1]
                                                  withDroneBattery:[arguments[2] integerValue]
                                            withTransmitterBattery:[arguments[3] integerValue]
                                             withCalibrationStatus:arguments[4]
                                                     withGPSStatus:arguments[5]
                                                    withAttributes:attributes];
    }
    else if (g_indexPath.row == 1){
        arguments = @[@"Good",@"left",@"forward",@"left",@"forward", [@(45) stringValue]];
        
        if (g_shouldExecute)[PyzeDrone postInflightCheckCompleted:arguments[0]
                                                         withRoll:arguments[1]
                                                        withPitch:arguments[2]
                                                          withYaw:arguments[3]
                                                     withThrottle:arguments[4]
                                                         withTrim:arguments[5]
                                                   withAttributes:attributes];
    }
    else if (g_indexPath.row == 2){
        if (g_shouldExecute)[PyzeDrone postConnected:attributes];
    }
    else if (g_indexPath.row == 3){
        arguments = @[[@(1) stringValue]];
        if (g_shouldExecute) [PyzeDrone postDisconnected:arguments[0]
                                          withAttributes:attributes];
    }
    else if (g_indexPath.row == 4){
        arguments = @[@"DroneAirborne"];
        
        if (g_shouldExecute) [PyzeDrone postAirborne:arguments[0]
                                      withAttributes:attributes];
    }
    else if (g_indexPath.row == 5){
        arguments = @[@"DroneLanded"];
        if (g_shouldExecute) [PyzeDrone postLanded:arguments[0]
                                    withAttributes:attributes];
    }
    else if (g_indexPath.row == 6){
        arguments = @[@"uniquePathForward"];
        if (g_shouldExecute) [PyzeDrone postFlightPathCreated:arguments[0]
                                               withAttributes:attributes];
    }
    else if (g_indexPath.row == 7){
        arguments = @[@"uniquePathForward"];
        if (g_shouldExecute) [PyzeDrone postFlightPathUploaded:arguments[0]
                                                withAttributes:attributes];
    }
    else if (g_indexPath.row == 8){
        arguments = @[@"uniquePathForward"];
        if (g_shouldExecute) [PyzeDrone postFlightPathEdited:arguments[0]
                                              withAttributes:attributes];
    }
    else if (g_indexPath.row == 9){
        arguments = @[@"uniquePathForward"];
        if (g_shouldExecute) [PyzeDrone postFlightPathDeleted:arguments[0]
                                               withAttributes:attributes];
    }
    else if (g_indexPath.row == 10){
        arguments = @[@"uniquePathForward"];
        if (g_shouldExecute) [PyzeDrone postFlightPathCompleted:arguments[0]
                                                 withAttributes:attributes];
    }
    else if (g_indexPath.row == 11){
        arguments = @[@"ViewingEnabled"];
        if (g_shouldExecute) [PyzeDrone postFirstPersonViewEnabled:arguments[0]
                                                    withAttributes:attributes];
    }
    else if (g_indexPath.row == 12){
        arguments = @[@"ViewingDisabled"];
        if (g_shouldExecute) [PyzeDrone postFirstPersonViewDisabled:arguments[0]
                                                     withAttributes:attributes];
    }
    else if (g_indexPath.row == 12){
        arguments = @[@"ViewingDisabled"];
        if (g_shouldExecute) [PyzeDrone postFirstPersonViewDisabled:arguments[0]
                                                     withAttributes:attributes];
    }
    else if (g_indexPath.row == 13){
        arguments = @[@"videoplay"];
        if (g_shouldExecute) [PyzeDrone postStartedAerialVideo:arguments[0]
                                                withAttributes:attributes];
    }
    else if (g_indexPath.row == 14){
        arguments = @[@"videoplay",@"videoID1234"];
        if (g_shouldExecute) [PyzeDrone postStartedAerialVideo:arguments[0]
                                                videoIdentifer:arguments[1]
                                                withAttributes:attributes];
    }
    else if (g_indexPath.row == 15){
        arguments = @[@"videoID1234",@"3:14"];
        if (g_shouldExecute) [PyzeDrone postStoppedAerialVideo:arguments[0]
                                                    withLength:arguments[1]
                                                withAttributes:attributes];
    }
    else if (g_indexPath.row == 16){
        arguments = @[@"DCIM_20_10_2016.png"];
        if (g_shouldExecute) [PyzeDrone postTookAerialPicture:arguments[0]
                                               withAttributes:attributes];
    }
    else if (g_indexPath.row == 17){
        arguments = @[@"DCIM_20_10_2016.png",@"10", @"1"];
        if (g_shouldExecute) [PyzeDrone postStartedAerialTimelapse:arguments[0]
                                                        totalShots:[arguments[1] integerValue]
                                                 delayBetweenShots:[arguments[2] integerValue]
                                                    withAttributes:attributes];
    }
    else if (g_indexPath.row == 18){
        arguments = @[@"DCIM_20_10_2016.png",@"10", @"1"];
        if (g_shouldExecute) [PyzeDrone postStoppedAerialTimelapse:arguments[0]
                                                    withAttributes:attributes];
    }
    else if (g_indexPath.row == 19){
        if (g_shouldExecute) [PyzeDrone postRequestedReturnToBase:attributes];
    }
    else if (g_indexPath.row == 20){
        if (g_shouldExecute) [PyzeDrone postSwitchedToHelicopterFlyingMode:attributes];
    }
    else if (g_indexPath.row == 21){
        if (g_shouldExecute) [PyzeDrone postSwitchedToAttitudeFlyingMode:attributes];
    }
    else if (g_indexPath.row == 22){
        if (g_shouldExecute) [PyzeDrone postSwitchedToGPSHoldFlyingMode:attributes];
    }
    else if (g_indexPath.row == 23){
        arguments = @[@"10"];
        if (g_shouldExecute) [PyzeDrone postSwitchedToCustomFlyingMode:[arguments[0] integerValue]
                                                        withAttributes:attributes];
    }
    else if (g_indexPath.row == 24){
        arguments = @[@"14"];
        if (g_shouldExecute) [PyzeDrone postSetMaxAltitude:[arguments[0] integerValue]
                                            withAttributes:attributes];
    }
    else if (g_indexPath.row == 25){
        arguments = @[@"2048"];
        if (g_shouldExecute) [PyzeDrone postSetAutoReturnWhenLowMemory:[arguments[0] integerValue]
                                                        withAttributes:attributes];
    }
    else if (g_indexPath.row == 26){
        arguments = @[@"600"];
        if (g_shouldExecute) [PyzeDrone postSetAutoReturnInSeconds:[arguments[0] integerValue]
                                                    withAttributes:attributes];
    }
    else {
        arguments = @[@"10"];
        if (g_shouldExecute) [PyzeDrone postSetAutoReturnWhenLowBattery:[arguments[0] integerValue]
                                                         withAttributes:attributes];
    }
    
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}

+(NSArray *) executeSupportEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        if (g_shouldExecute)[PyzeSupport postRequestedPhoneCallback:attributes];
    }
    else if (g_indexPath.row == 1){
        arguments = @[@"Device Support"];
        if (g_shouldExecute)[PyzeSupport postLiveChatStartedWithTopic:arguments[0]
                                                       withAttributes:attributes];
    }
    else if (g_indexPath.row == 2){
        arguments = @[@"Device Support"];
        if (g_shouldExecute)[PyzeSupport postLiveChatEndedWithTopic:arguments[0]
                                                     withAttributes:attributes];
    }
    else if (g_indexPath.row == 3){
        arguments = @[@"12343221",@"Device Support"];
        if (g_shouldExecute)[PyzeSupport postTicketCreated:arguments[0]
                                                 withTopic:arguments[1]
                                            withAttributes:attributes];
    }
    else if (g_indexPath.row == 4){
        arguments = @[@"Device support addressed"];
        if (g_shouldExecute) [PyzeSupport postFeedbackReceived:arguments[0]
                                                withAttributes:attributes];
    }
    else {
        arguments = @[@"Device support addressed", @"4"];
        if (g_shouldExecute) [PyzeSupport postQualityOfServiceRated:arguments[0]
                                                       rateOn5Scale:arguments[1]
                                                     withAttributes:attributes];

    }
    
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}


+(NSArray *) executeCommerceSupportEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        arguments = @[@"Device Support",@"112233"];
        if (g_shouldExecute)[PyzeCommerceSupport postLiveChatStartedWithTopic:arguments[0]
                                                              withOrderNumber:arguments[1]
                                                               withAttributes:attributes];
    }
    else if (g_indexPath.row == 1){
        arguments = @[@"Device Support",@"112233"];
        if (g_shouldExecute)[PyzeCommerceSupport postLiveChatEndedWithTopic:arguments[0]
                                                            withOrderNumber:arguments[1]
                                                             withAttributes:attributes];
    }
    else if (g_indexPath.row == 2){
        arguments = @[@"12343221",@"Device Support",@"112233"];
        if (g_shouldExecute)[PyzeCommerceSupport postTicketCreated:arguments[0]
                                                         withTopic:arguments[1]
                                                   withOrderNumber:arguments[2]
                                                    withAttributes:attributes];
    }
    else if (g_indexPath.row == 3){
        arguments = @[@"Device support addressed",@"112233"];
        if (g_shouldExecute) [PyzeCommerceSupport postFeedbackReceived:arguments[0]
                                               withOrderNumber:arguments[2]
                                                withAttributes:attributes];
    }
    else {
        arguments = @[@"Device support addressed", @"4"];
        if (g_shouldExecute) [PyzeCommerceSupport postQualityOfServiceRated:arguments[0]
                                                            withOrderNumber:arguments[1]
                                                               rateOn5Scale:arguments[2]
                                                             withAttributes:attributes];
        
    }
    
    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}


+(NSArray *) executeWeatherAndForecastEvents
{
    NSDictionary * attributes = [ALRandomDictionaryGenerator attributesDictionary];
    NSArray * arguments = @[];
    
    if (g_indexPath.row == 0){
        arguments = @[@"2",[@(PyzeWeatherRequestByCityCode) stringValue]];
        if (g_shouldExecute)[PyzeWeatherAndForecast postWeatherRequestedForType:PyzeWeatherRequestByCityCode
                                                                        forDays:[arguments[0] integerValue]
                                                                 withAttributes:attributes];
    }
    else if (g_indexPath.row == 1){
        arguments = @[[@(NSTimeIntervalSince1970+24) stringValue],[@(NSTimeIntervalSince1970) stringValue]];

        if (g_shouldExecute)[PyzeWeatherAndForecast postWeatherHistoricalRequest:NSTimeIntervalSince1970
                                                                     withEndDate:NSTimeIntervalSince1970+24
                                                                  withAttributes:attributes];
    }
    else if (g_indexPath.row == 2){
        arguments = @[@"12343221"];
        PyzeGeoPoint point;
        point.GeoPointLat = 100.0f;
        point.GeoPointLon = point.GeoPointLat;
        
        if (g_shouldExecute)[PyzeWeatherAndForecast postWeatherStationsRequestWithClusterData:arguments[0]
                                                                                   atGeoPoint:&point
                                                                               withAttributes:attributes];
    }
    else if (g_indexPath.row == 3){
        arguments = @[@"Weather Map"];
        if (g_shouldExecute) [PyzeWeatherAndForecast postWeatherMapLayersRequested:arguments[0]
                                                                    withAttributes:attributes];
    }
    else if (g_indexPath.row == 4){
        PyzeGeoPoint point;
        point.GeoPointLat = 100.0f;
        point.GeoPointLon = point.GeoPointLat;

        if (g_shouldExecute) [PyzeWeatherAndForecast postWeatherRequestForUVIndexAtPoint:&point
                                                                          withAttributes:attributes];
        
    }
    else if (g_indexPath.row == 5){
        arguments = @[[@(PyzeWeatherRequestByCityCode) stringValue]];
        if (g_shouldExecute) [PyzeWeatherAndForecast postWeatherResponseForType:[arguments[0] integerValue]
                                                                 withAttributes:attributes];
    }
    else if (g_indexPath.row == 6){
        if (g_shouldExecute) [PyzeWeatherAndForecast postWeatherResponseForHistoricalData:attributes];
    }
    else if (g_indexPath.row == 7){
        if (g_shouldExecute) [PyzeWeatherAndForecast postWeatherStationResponseData:attributes];
    }
    else if (g_indexPath.row == 8){
        if (g_shouldExecute) [PyzeWeatherAndForecast postWeatherMapLayersResponse:attributes];
    }
    else if (g_indexPath.row == 9){
        if (g_shouldExecute) [PyzeWeatherAndForecast postWeatherResponseForUVIndex:attributes];
    }
    else if (g_indexPath.row == 10){
        arguments = @[@"Weather Map"];
        if (g_shouldExecute) [PyzeWeatherAndForecast postForecastRequestForKeywords:arguments[0]
                                                                     withAttributes:attributes];
    }
    else if (g_indexPath.row == 11){
        if (g_shouldExecute) [PyzeWeatherAndForecast postForecastResponseForKeywords:attributes];
    }
    else if (g_indexPath.row == 12){
        arguments = @[@"21"];
        if (g_shouldExecute) [PyzeWeatherAndForecast postForecastFetch:[arguments[0] integerValue]
                                                        withAttributes:attributes];
    }
    else {
        if (g_shouldExecute) [PyzeWeatherAndForecast postForecastFetchResponse:attributes];
    }

    return g_shouldExecute ? nil : [NSArray arrayWithObjects: arguments,attributes,nil];
}


@end
