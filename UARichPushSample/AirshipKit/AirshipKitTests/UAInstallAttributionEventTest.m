/* Copyright 2017 Urban Airship and Contributors */

#import <XCTest/XCTest.h>
#import "UAInstallAttributionEvent.h"

@interface UAInstallAttributionEventTest : XCTestCase

@end

@implementation UAInstallAttributionEventTest

/**
 * Test the event's type.
 */
- (void)testType {
    XCTAssertEqualObjects(@"install_attribution", [UAInstallAttributionEvent event].eventType);
}

/**
 * Test the event's data with purchase and impression dates.
 */
- (void)testData {
    NSDate *purchaseDate = [NSDate dateWithTimeIntervalSince1970:100.0];
    NSDate *iAdImpressionDate = [NSDate dateWithTimeIntervalSince1970:1000.0];

    UAInstallAttributionEvent *event = [UAInstallAttributionEvent eventWithAppPurchaseDate:purchaseDate
                                                                         iAdImpressionDate:iAdImpressionDate];

    XCTAssertEqualObjects(@"100.000000", [event.data objectForKey:@"app_store_purchase_date"]);
    XCTAssertEqualObjects(@"1000.000000", [event.data objectForKey:@"app_store_ad_impression_date"]);
    XCTAssertTrue(event.isValid);
}

/**
 * Test the event's data with no dates.
 */
- (void)testDataNoDates {
    UAInstallAttributionEvent *event = [UAInstallAttributionEvent event];
    XCTAssertEqual(0, event.data.count);
    XCTAssertTrue(event.isValid);
}

@end
