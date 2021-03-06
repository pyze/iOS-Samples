
@import Foundation;

// Identity of the user of the app would be gathered using PyzeIdentity class.

@interface PyzeIdentity : NSObject

+(void) setAppSpecificUserId:(nonnull NSString *) appSpecificUserId;

+(void) setFbID:(nonnull NSString *) fbId;

+(void) setTwitterId: (nonnull NSString *) twitterId;

+(void) setEmail:(nonnull NSString *) emailId;

+(void) setPhoneNumber:(nonnull NSString *) phoneNumber;

+(void) setPushNotificationRegistrationId:(nonnull NSString *) pushNotificatioId;

+(void) setUserName:(nonnull NSString *) userName;

+(void) setCustomUserIdentifier:(nonnull NSString *) identifier forKey:(nonnull NSString *) key;

+(nullable NSDictionary *) identities;

+(void) postIfChanged; // call after the fields are set.

@end

/**
 *  PyzeCustomEvent
 *  Base class for events
 */
@interface PyzeCustomEvent : NSObject

/**
 *  Base class method which will post the data to server.
 *
 *  @param eventName  The event name to capture.
 *  @param attributes Additional custom attributes the app would want to share with server.
 */
+(void) postWithEventName:(nonnull NSString *) eventName withAttributes:(nullable NSDictionary *)attributes;

@end

@interface PyzeExplicitActivation : PyzeCustomEvent

+ (void) post;

+ (void) post: (nullable NSDictionary *)attributeDictionary;

@end

#pragma mark - Ad


/**
 *  ### PyzeAd
 *  Subclass of PyzeCustomEvent. This class can be used for posting events related to ads in your apps. 
 */
@interface PyzeAd : PyzeCustomEvent

/**
 *  Post the event to server once the ad request has successfully been sent to the server.
 *
 *  @param adNetwork  The ad network the app referring to.
 *  @param appScreen  ViewController name where ad would be shown.
 *  @param size       Size of the ad.
 *  @param type       Type of ad for example Interstitial, Banner Ads, DFP ads etc.,
 *  @param attributes Additional custom attributes app would like to share with server.
 */
+(void) postAdRequested:(nullable NSString *)adNetwork
          fromAppScreen:(nonnull NSString *)appScreen
             withAdSize:(CGSize)size
                 adType:(nonnull NSString *) type
         withAttributes:(nullable NSDictionary *)attributes;

/**
 *  Post the event to server once the ad data received from the provider.
 *
 *  @param adNetwork  The ad network the app referring to.
 *  @param appScreen  ViewController name where ad would be shown.
 *  @param resultCode Result code received, if any.
 *  @param success    Success or failed to load the ad.
 *  @param attributes Additional custom attributes app would like to share with server.
 */
+(void) postAdReceived:(nullable NSString *)adNetwork
         fromAppScreen:(nonnull NSString *)appScreen
        withResultCode:(nullable NSString *) resultCode
             isSuccess:(BOOL) success
        withAttributes:(nullable NSDictionary *)attributes;

/**
 *  Post the event to server when user taps on ad.
 *
 *  @param adNetwork  The ad network the app referring to.
 *  @param appScreen  ViewController name where ad would be shown.
 *  @param adCode     Ad code received from the server, if any.
 *  @param success    Success or failed to load the ad.
 *  @param errorCode  Pass the errorCode if ad click operation fails.
 *  @param attributes Additional custom attributes app would like to share with server.
 */

+(void) postAdClicked:(nullable NSString *)adNetwork
        fromAppScreen:(nonnull NSString *)appScreen
               adCode:(nonnull NSString *) adCode
            isSuccess:(BOOL) success
        withErrorCode:(nullable NSString *) errorCode
       withAttributes:(nullable NSDictionary *)attributes;

@end

NS_ASSUME_NONNULL_BEGIN
/**
 *  ### PyzeAdvocacy
 *  Subclass of PyzeCustomEvent class used for posting support for feedbacks.
 */
@interface PyzeAdvocacy : PyzeCustomEvent

/**
 *  Post request for feedback.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 */
+(void) postRequestForFeedback:(NSDictionary *)attributes;

/**
 *  Post the feedback received.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 */
+(void) postFeedbackProvided:(NSDictionary *)attributes;

/**
 *  Post request rating.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 */
+(void) postRequestRating:(NSDictionary *)attributes;

@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
/**
 *  ### PyzeAccount
 *  Subclass of PyzeCustomEvent class used to post the details related to Accounts.
 */
@interface PyzeAccount : PyzeCustomEvent

/**
 *  Post registration offered details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 */
+(void) postRegistrationOffered:(NSDictionary *) attributes;

/**
 *  Post registration started details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 */
+(void) postRegistrationStarted:(NSDictionary *) attributes;

/**
 *  Post registration completed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 */
+(void) postRegistrationCompleted:(NSDictionary *) attributes;

/**
 *  Post the login operation completion details.
 *
 *  @param success    a status to indicate the operation successful or failed.
 *  @param errCodeStr On error, pass the localizedDescription to this parameter.
 *  @param dictionary Additional custom attributes app would like to share with server.
 */
+(void) postLoginCompleted:(BOOL) success withErrCode:(NSString *) errCodeStr withAttributes:(NSDictionary *) dictionary;

/**
 *  Post logout details
 *
 *  @param logoutExplicit A boolean status to determine whether logout is explicit logout or not.
 *  @param dictionary     Additional custom attributes app would like to share with server.
 */
+(void) postLogoutCompleted:(BOOL)logoutExplicit withAttributes:(NSDictionary *) dictionary;

/**
 *  Post password reset request details.
 *
 *  @param dictionary Additional custom attributes app would like to share with server.
 */
+(void) postPasswordResetRequest:(NSDictionary *) dictionary;

@end

/**
 *  ### PyzeCommerceDiscovery
 *  Subclass of PyzeCustomEvent used to post the details of events related to Discovery of a item in particular category.
 */
@interface PyzeCommerceDiscovery : PyzeCustomEvent

/**
 *  Post the search details, latency value with details.
 *
 *  @param searchString Search string used
 *  @param latency      Latency to complete the operation.
 *  @param attributes   Additional custom attributes app would like to share with server.
 */

+(void) postSearched:(NSString *) searchString
         withLatency:(NSNumber *) latency
      withAttributes:(NSDictionary *)attributes;
/**
 *  Post browsed category details.
 *
 *  @param category   Category name
 *  @param attributes Additional custom attributes app would like to share with server.
 */
+(void) postBrowsedCategory:(NSString *) category
             withAttributes:(NSDictionary *)attributes;

/**
 *  Post browsed deal details
 *
 *  @param uniqueDealID Unique deal identification string/number.
 *  @param attributes   Additional custom attributes app would like to share with server.
 */
+(void) postBrowsedDeals:(NSString *) uniqueDealID
          withAttributes:(NSDictionary *)attributes;

/**
 *  Post browsed recommendation details.
 *
 *  @param uniqueRecommendationID uniqueRecommendationID containing a string/number.
 *  @param attributes             Additional custom attributes app would like to share with server.
 */
+(void) postBrowsedRecommendations:(NSString *) uniqueRecommendationID
                    withAttributes:(NSDictionary *)attributes;

/**
 *  Post browsed previous order details.
 *
 *  @param rangeStart Starting range of the order browsed.
 *  @param rangeEnd   Ending range of the order browsed.
 *  @param attributes Additional custom attributes app would like to share with server.
 */
+(void) postBrowsedPrevOrders:(NSString *) rangeStart
                      withEnd:(NSString *) rangeEnd
               withAttributes:(NSDictionary *)attributes;
@end

/**
 *  ### PyzeCommerceCuratedList
 *  Subclass of PyzeCustomEvent class used post details of the events related to curated list.
 */
@interface PyzeCommerceCuratedList: PyzeCustomEvent

/**
 *  Post creation details of curated list.
 *
 *  @param uniqueCuratedListID Curated list id.
 *  @param curatedListType     Type of curated list.
 *  @param attributes          Additional custom attributes app would like to share with server.
 */
+(void) postCreated:(NSString *) uniqueCuratedListID
           withType:(NSString *) curatedListType
     withAttributes:(NSDictionary *)attributes;

/**
 *  Post browsed details of curated list.
 *
 *  @param curatedList        Curated list id.
 *  @param curatedListCreator Curated list creation id.
 *  @param attributes         Additional custom attributes app would like to share with server.
 */
+(void) postBrowsed:(NSString *) curatedList
        withCreator:(NSString *) curatedListCreator
     withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of adding an item to curated list.
 *
 *  @param uniqueCuratedListId Curated list id.
 *  @param itemCategory        Category name to add the item.
 *  @param itemID              Item id details.
 *  @param attributes          Additional custom attributes app would like to share with server.
 */
+(void) postAddedItem:(NSString *) uniqueCuratedListId
         withCategory:(NSString *) itemCategory
           withItemId:(NSString *) itemID
       withAttributes:(NSDictionary *)attributes;

/**
 *  <#Description#>
 *
 *  @param uniqueCuratedListID <#uniqueCuratedListID description#>
 *  @param curatedListType     <#curatedListType description#>
 *  @param itemID              <#itemID description#>
 *  @param attributes          <#attributes description#>
 */
+(void) postRemovedItem:(NSString *) uniqueCuratedListID
           withListType:(NSString *) curatedListType
             withItemID:(NSString *) itemID
         withAttributes:(NSDictionary *)attributes;

+(void) postShared:(NSString *) curatedList
       withCreator:(NSString *) curatedListCreator
    withAttributes:(NSDictionary *)attributes;

+(void) postPublished:(NSString *) curatedList
          withCreator:(NSString *) curatedListCreator
       withAttributes:(NSDictionary *)attributes;
@end



@interface PyzeCommerceWishList : PyzeCustomEvent

+(void) postCreated:(NSString *) uniqueWishListId
   withWishListType:(NSString *) wishListtype
     withAttributes:(NSDictionary *)attributes;

+(void) postBrowsed:(NSString *) uniqueWishListId
     withAttributes:(NSDictionary *)attributes;

+(void) postAddedItem:(NSString *) uniqueWishListId
     withItemCategory:(NSString *) itemCategory
           withItemId:(NSString *) itemId
       withAttributes:(NSDictionary *)attributes;

+(void) postRemovedItem:(NSString *) uniqueWishListId
       withItemCategory:(NSString *) itemCategory
             withItemId:(NSString *) itemId
         withAttributes:(NSDictionary *)attributes;

+(void) postShared:(NSString *) uniqueWishListId
    withAttributes:(NSDictionary *)attributes;

@end

#pragma  mark - CommerceBeacon

@interface PyzeCommerceBeacon : PyzeCustomEvent

/**
 *  <#Description#>
 *
 *  @param iBeaconUUID            <#iBeaconUUID description#>
 *  @param iBeaconMajor           <#iBeaconMajor description#>
 *  @param iBeaconMinor           <#iBeaconMinor description#>
 *  @param uniqueRegionIdentifier <#uniqueRegionIdentifier description#>
 *  @param attributes             <#attributes description#>
 */
+(void) postEnteredRegion:(NSString *) iBeaconUUID
          withBeaconMajor:(NSString *) iBeaconMajor
          withBeaconMinor:(NSString *) iBeaconMinor
withUniqueRegionIdentifier:(NSString *)uniqueRegionIdentifier
           withAttributes:(NSDictionary *)attributes;

+(void) postExitedRegion:(NSString *) iBeaconUUID
         withBeaconMajor:(NSString *) iBeaconMajor
         withBeaconMinor:(NSString *) iBeaconMinor
withUniqueRegionIdentifier:(NSString *)uniqueRegionIdentifier
          withAttributes:(NSDictionary *)attributes;

+(void) postTransactedInRegion:(NSString *) iBeaconUUID
               withBeaconMajor:(NSString *) iBeaconMajor
               withBeaconMinor:(NSString *) iBeaconMinor
    withUniqueRegionIdentifier:(NSString *) uniqueRegionIdentifier
                 withProximity:(NSString *) proximity
                  withActionId:(NSString *) actionId
                withAttributes:(NSDictionary *)attributes;
@end


@interface PyzeCommerceCart : PyzeCustomEvent

+(void) postAddItem:(NSString *) cartId
   withItemCategory:(NSString *) itemCatefory
         withItemId:(NSString *) itemId
     withAttributes:(NSDictionary *)attributes;

+(void) postAddItemFromDeals:(NSString *) cartId
            withItemCategory:(NSString *) itemCatefory
                  withItemId:(NSString *) itemId
            withUniqueDealId:(NSString *) uniqueDealId
              withAttributes:(NSDictionary *)attributes;

+(void) postAddItemFromWishList:(NSString *) cartId
               withItemCategory:(NSString *) itemCatefory
                     withItemId:(NSString *) itemId
           withUniqueWishListId:(NSString *) uniqueWishListId
                 withAttributes:(NSDictionary *)attributes;

+(void) postAddItemFromCuratedList:(NSString *) cartId
                  withItemCategory:(NSString *) itemCatefory
                        withItemId:(NSString *) itemId
           withUniqueCuratedListId:(NSString *) uniqueCuratedListId
                    withAttributes:(NSDictionary *)attributes;

+(void) postAddItemFromRecommendations:(NSString *) cartId
                      withItemCategory:(NSString *) itemCatefory
                            withItemId:(NSString *) itemId
            withUniqueRecommendationId:(NSString *) uniqueRecommendationId
                        withAttributes:(NSDictionary *)attributes;

+(void) postAddItemFromPreviousOrders:(NSString *) cartId
                     withItemCategory:(NSString *) itemCatefory
                           withItemId:(NSString *) itemId
                  withPreviousOrderId:(NSString *) previousOrderId
                       withAttributes:(NSDictionary *)attributes;

+(void) postAddItemFromSearchResults:(NSString *) cartId
                    withItemCategory:(NSString *) itemCatefory
                          withItemId:(NSString *) itemId
                    withSearchString:(NSString *) searchString
                      withAttributes:(NSDictionary *)attributes;

+(void) postAddItemFromSubcriptionList:(NSString *) cartId
                      withItemCategory:(NSString *) itemCatefory
                            withItemId:(NSString *) itemId
                      withUniqueDealId:(NSString *) uniqueDealId
                        withAttributes:(NSDictionary *)attributes;


+(void) postRemoveItemFromCart:(NSString *) cartId
              withItemCategory:(NSString *) itemCatefory
                    withItemId:(NSString *) itemId
                withAttributes:(NSDictionary *)attributes;

+(void) postView:(NSString *) cartId
  withAttributes:(NSDictionary *)attributes;

+(void) postShare:(NSString *) cartId
withItemSharedWith:(NSString *) sharedWith
       withItemId:(NSString *) itemId
   withAttributes:(NSDictionary *)attributes;
@end


@interface PyzeCommerceItem : PyzeCustomEvent

+(void) postViewedItem:(NSDictionary *) attributes;

+(void) postScannedItem:(NSDictionary *) attributes;

+(void) postViewedReviews:(NSDictionary *) attributes;

+(void) postViewedDetails:(NSDictionary *) attributes;

+(void) postViewedPrice:(NSDictionary *) attributes;

+(void) postItemShareItem:(NSDictionary *) attributes;

+(void) postItemRateOn5Scale:(NSString *) itemSKU withRating:(NSString *) rating withAttributes:(NSDictionary *)attributes;

@end

@interface PyzeCommerceCheckout : PyzeCustomEvent

+(void) postCheckoutStarted:(NSDictionary *) attributes;

+(void) postCheckoutCompleted:(NSDictionary *) attributes;

+(void) postCheckoutAbandoned:(NSDictionary *) attributes;

+(void) postCheckoutFailed:(NSDictionary *) attributes;

@end


@interface PyzeCommerceShipping : PyzeCustomEvent

+(void) postShippingStarted:(NSDictionary *) attributes;

+(void) postShippingCompleted:(NSDictionary *) attributes;

+(void) postShippingAbandoned:(NSDictionary *) attributes;

+(void) postShippingFailed:(NSDictionary *) attributes;

@end

@interface PyzeCommerceBilling : PyzeCustomEvent

+(void) postBillingStarted:(NSDictionary *) attributes;

+(void) postBillingCompleted:(NSDictionary *) attributes;

+(void) postBillingAbandoned:(NSDictionary *) attributes;

+(void) postBillingFailed:(NSDictionary *) attributes;

@end

@interface PyzeCommercePayment : PyzeCustomEvent

+(void) postPaymentStarted:(NSDictionary *) attributes;

+(void) postPaymentCompleted:(NSDictionary *) attributes;

+(void) postPaymentAbandoned:(NSDictionary *) attributes;

+(void) postPaymentFailed:(NSDictionary *) attributes;

@end

@interface PyzeCommerceRevenue : PyzeCustomEvent
+(void) postRevenue:(NSNumber*) revenue withAttributes:(NSDictionary*) attributes;
+(void) postRevenueUsingApplePay:(NSNumber*) revenue withAttributes:(NSDictionary*) attributes;
+(void) postRevenueUsingSamsungPay:(NSNumber*) revenue withAttributes:(NSDictionary*) attributes;
+(void) postRevenueUsingGooglePay:(NSNumber*) revenue withAttributes:(NSDictionary*) attributes;
+(void) postRevenue:(NSNumber*) revenue withPaymentInstrument: (NSString*) paymentInstrument withAttributes:(NSDictionary*) attributes;
@end


@interface PyzeGaming : PyzeCustomEvent

+(void) postLevelStarted:(NSString *) level
          withAttributes:(NSDictionary *)attributes;

+(void) postLevelEnded:(NSString *) level
            withScore:(NSString *) score
  withSuccessOrFailure:(NSString *) success
        withAttributes:(NSDictionary*) attributes;

+(void) postPowerUpConsumed:(NSString *) level
                   withType:(NSString *) type
                  withValue:(NSString *) value
             withAttributes:(NSDictionary*) attributes;

+(void) postInGameItemPurchased:(NSString *) uniqueItemId
                   withItemType:(NSString *) itemType
                  withItemValue:(NSString *) value
                 withAttributes:(NSDictionary*) attributes;

+(void) postAchievementEarned:(NSString *) uniqueAchievementId
                     withType:(NSString *) type
               withAttributes:(NSDictionary*) attributes;

+(void) postSummaryViewed:(NSString*) level
                withScore:(NSString *) score
           withAttributes:(NSDictionary*) attributes;

+(void) postLeaderBoardViewed:(NSString*) level
                    withScore:(NSString *) score
               withAttributes:(NSDictionary*) attributes;

+(void) postScorecardViewed:(NSString*) level
                  withScore:(NSString *) score
             withAttributes:(NSDictionary*) attributes;

+(void) postHelpViewed:(NSString *) helpTopicId
        withAttributes:(NSDictionary *) dictionary;

+(void) postTutorialViewed:(NSString *) helpTopicId
            withAttributes:(NSDictionary *) dictionary;

+(void) postFriendChallenged:(NSDictionary *) attributes;

+(void) postChallengeAccepted:(NSDictionary *) attributes;

+(void) postChallengeDeclined:(NSDictionary *) attributes;

+(void) postGameStart:(NSString *) level
       withAttributes:(NSDictionary *)attributes;

+(void) postGameEnd:(NSString *) levelsPlayed
      withLevelsWon:(NSString *) levelsWon
     withAttributes:(NSDictionary *)attributes;

@end

@interface PyzeHealthAndFitness : PyzeCustomEvent

+(void) postStarted:(NSDictionary *) attributes;

+(void) postEnded:(NSDictionary *) attributes;

+(void) postAchievementReceived:(NSDictionary *) attributes;

+(void) postStepGoalCompleted:(NSDictionary *) attributes;

+(void) postGoalCompleted:(NSDictionary *) attributes;

+(void) postChallengedFriend:(NSDictionary *) attributes;

+(void) postChallengeAccepted:(NSDictionary *) attributes;

@end

#pragma mark - Pyze Content

@interface PyzeContent : PyzeCustomEvent

+(void) postViewed:(NSString *) contentName
          category:(NSString *) categoryName
withUniqueContentId:(NSString *) contentId
    withAttributes:(NSDictionary *)attributes;

+(void) postSearched:(NSString *) searchString withAttributes:(NSDictionary *)attributes;

+(void) postRatedOn5PointScale:(NSString *) contentName
                      category:(NSString *) categoryName
           withUniqueContentId:(NSString *) contentId
                 contentRating:(NSDecimalNumber *) rating
                withAttributes:(NSDictionary *)attributes;

+(void) postRatedThumbsUp:(NSString *) contentName
                 category:(NSString *) categoryName
      withUniqueContentId:(NSString *) contentId
           withAttributes:(NSDictionary *)attributes;

+(void) postRatedThumbsDown:(NSString *) contentName
                   category:(NSString *) categoryName
        withUniqueContentId:(NSString *) contentId
             withAttributes:(NSDictionary *)attributes;
@end


@interface PyzeMessaging : PyzeCustomEvent

+(void) postMessageSMS:(NSString *) uniqueId withAttributes:(NSDictionary *) dictionary;

+(void) postMessageSent:(NSString *) uniqueId withAttributes:(NSDictionary *) dictionary;

+(void) postMessageReceived:(NSString *) uniqueId withAttributes:(NSDictionary *) dictionary;

+(void) postMessageNewConversation:(NSString *) uniqueId withAttributes:(NSDictionary *) dictionary;

+(void) postMessageVoiceCall:(NSString *) uniqueId withAttributes:(NSDictionary *) dictionary;


@end


@interface  PyzeInAppPurchaseRevenue : PyzeCustomEvent

+(void) postPriceListViewViewed:(NSString *) appScreenRequestFromId withAttributes:(NSDictionary *) attributes;

+(void) postBuyItem:(NSString *) itemName
              price:(NSDecimalNumber *) revenue
           currency:(NSString *) currencyISO4217Code
     withAttributes:(NSDictionary *) attributes;

+(void) postBuyItemInUSD:(NSString *) itemName
                   price:(NSDecimalNumber *) revenue
          withAttributes:(NSDictionary *) attributes;

+(void) postBuyItem:(NSString *) itemName
              price:(NSDecimalNumber *) revenue
           currency:(NSString *) currencyISO4217Code
           itemType:(NSString *) itemType
            itemSKU:(NSString *) itemSKU
           quantity:(NSString *) quantity
          requestId:(NSString *) appScreenRequestFromId
             status: (BOOL) success
        successCode:(NSString *) successOrErrorCode
     withAttributes:(NSDictionary *)attributes;
@end



@interface PyzeTasks: PyzeCustomEvent

+(void)  addToCalendarwithAttributes:(NSDictionary *)attributes;

@end


@interface PyzeSocial: PyzeCustomEvent

+(void) postSocialContentShareForNetworkName:(NSString *) socialNetworkName
                         forContentReference:(NSString *) contentReference
                                    category:(NSString *) category
                              withAttributes:(NSDictionary *) dictionary;

+(void) postLiked:(NSString *) socialNetworkName
forContentReference:(NSString *) contentReference
         category:(NSString *) category
   withAttributes:(NSDictionary *) dictionary;

+(void) postFollowed:(NSString *) socialNetworkName
 forContentReference:(NSString *) contentReference
            category:(NSString *) category
      withAttributes:(NSDictionary *) dictionary;

+(void) postSubscibed:(NSString *) socialNetworkName
  forContentReference:(NSString *) contentReference
             category:(NSString *) category
       withAttributes:(NSDictionary *) dictionary;

+(void) postInvitedFriend: (NSString *) socialNetworkName withAttributes:(NSDictionary *)attributes;

+(void) postFoundFriends:(NSString *) source withAtrributes:(NSDictionary *) attributes;


@end


@interface PyzeMedia : PyzeCustomEvent

+(void) postPlayedMedia:(NSString *) contentName
              mediaType:(NSString *) type
               category:(NSString *) categoryName
          percentPlayed:(NSString *) percent
    withUniqueContentId:(NSString *) contentId
         withAttributes:(NSDictionary *)attributes;

+(void) postSearched:(NSString *) searchString withAttributes:(NSDictionary *)attributes;

+(void) postRatedOn5PointScale:(NSString *) contentName
                      category:(NSString *) categoryName
             withUniqueContentId:(NSString *) mediaId
                 contentRating:(NSDecimalNumber *) rating
                withAttributes:(NSDictionary *)attributes;

+(void) postRatedThumbsUp:(NSString *) contentName
                 category:(NSString *) categoryName
      withUniqueContentId:(NSString *) contentId
           withAttributes:(NSDictionary *)attributes;

+(void) postRatedThumbsDown:(NSString *) contentName
                   category:(NSString *) categoryName
        withUniqueContentId:(NSString *) contentId
             withAttributes:(NSDictionary *)attributes;

@end

@interface PyzeBitcoin : PyzeCustomEvent

+(void) postSentBitcoins:(NSDictionary *) attributes;

+(void) postRequestedBitcoins:(NSDictionary *) attributes;

+(void) postReceivedBitcoins:(NSDictionary *) attributes;

+(void) postViewedTransactions:(NSDictionary *) attributes;

+(void) postImportedPrivateKey:(NSDictionary *) attributes;

+(void) postScannedPrivateKey:(NSDictionary *) attributes;

@end

NS_ASSUME_NONNULL_END

