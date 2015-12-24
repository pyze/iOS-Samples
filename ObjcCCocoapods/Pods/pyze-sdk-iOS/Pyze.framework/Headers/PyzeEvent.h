
@import Foundation;

#pragma mark - Pyze Custom Events 

/**
 *  PyzeCustomEvent
 *  If the built in event classes do not serve the purpose of your requirement, you can use Custom Events.
 */
@interface PyzeCustomEvent : NSObject

/// @name Class Methods

/**
 *  Base class method which will post the data to server.
 *
 *  @param eventName  The event name to capture.
 *  @param attributes Additional custom attributes the app would want to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postWithEventName:(nonnull NSString *) eventName withAttributes:(nullable NSDictionary *)attributes;

@end


#pragma mark - Pyze  Explicit Activation 

/**
 *  ### PyzeExplicitActivation
 *  Subclass of PyzeCustomEvent class used to send an explicit activation.
 */
@interface PyzeExplicitActivation : PyzeCustomEvent

/**
 *  Post explicit activation convenience method
 */
+ (void) post;

/**
 *  Post explicit activation convenience method with parameters.
 *
 *  @param attributeDictionary Additional custom attributes app would like to share with server.
 */
+ (void) post: (nullable NSDictionary *)attributeDictionary;

@end

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Pyze Account and Identity

/**
 *  ### PyzeAccount
 *  Subclass of PyzeCustomEvent class used to post the details related to Accounts.
 
 *  @since v1.0.0
 */

@interface PyzeAccount : PyzeCustomEvent

/// @name Registration

/**
 *  Post registration offered details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 */
+(void) postRegistrationOffered:( NSDictionary *) attributes;

/**
 *  Post registration started details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 */
+(void) postRegistrationStarted:(NSDictionary *) attributes;

/**
 *  Post registration completed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 */
+(void) postRegistrationCompleted:(NSDictionary *) attributes;

/// @name Login / Logout

/**
 *  Post the login operation completion details.
 *
 *  @param success    a status to indicate the operation successful or failed.
 *  @param errCodeStr On error, pass the localizedDescription to this parameter.
 *  @param dictionary Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postLoginCompleted:(BOOL) success withErrCode:(NSString *) errCodeStr withAttributes:(NSDictionary *) dictionary;

/**
 *  Post logout details
 *
 *  @param logoutExplicit A boolean status to determine whether logout is explicit logout or not.
 *  @param dictionary     Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postLogoutCompleted:(BOOL)logoutExplicit withAttributes:(NSDictionary *) dictionary;

/// @name Password Reset

/**
 *  Post password reset request details.
 *
 *  @param dictionary Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postPasswordResetRequest:(NSDictionary *) dictionary;

@end


/**
 *  PyzeIdentity
 *  You can use this class to send the user's traits to Pyze.  This information is solely used to reachout to the user via channels you provide (email, SMS, MMS, Push Notifications, etc).  Pyze does not require or track user information.  Set the identifers you want to send and then call postIfChanged.
 
 *  @since v1.0.0
 
 */
@interface PyzeIdentity : NSObject

/// @name Set Identities Locally

/**
 *  Set App specific User Identifer.  Use this to identify users by an app specific trait. Examples include: username, userid, hashedid.  It is highly recommended you do not send PII.  Call postIfChanged after setting all identifiers.
 *
 *  @param appSpecificUserId An app specific user identifer
 
 *  @since v1.0.0
 
 *  @see postIfChanged
 */
+(void) setAppSpecificUserId:(nonnull NSString *) appSpecificUserId;

/**
 *  Set user's Facebook Identifer. Call postIfChanged after setting all identifiers.
 *
 *  @param fbId facebook identifer
 
 *  @since v1.0.0
 
 *  @see postIfChanged
 */
+(void) setFbID:(nonnull NSString *) fbId;

/**
 *  Set user's twitter Identifer. Call postIfChanged after setting all identifiers.
 *
 *  @param twitterId twitter identifer
 
 *  @since v1.0.0
 
 *  @see postIfChanged
 */
+(void) setTwitterId: (nonnull NSString *) twitterId;

/**
 *  Set user's email address if you use email to reachout to users. Call postIfChanged after setting all identifiers.
 *
 *  @param emailAddress Email address to reachout to users.
 
 *  @since v1.0.0
 
 *  @see postIfChanged
 */
+(void) setEmail:(nonnull NSString *) emailAddress;

/**
 *  Set user's phone number. Call postIfChanged after setting all identifiers.
 *
 *  @param phoneNumber Phone number to reachout.
 
 *  @since v1.0.0
 
 *  @see postIfChanged
 */
+(void) setPhoneNumber:(nonnull NSString *) phoneNumber;

/**
 *  Set user's push Notification Identifer. Call postIfChanged after setting all identifiers.
 *
 *  @param pushNotificationId Notification Identifer.
 
 *  @since v1.0.0
 
 *  @see postIfChanged
 */
+(void) setPushNotificationRegistrationId:(nonnull NSString *) pushNotificationId;

/**
 *  Set user's username. Call postIfChanged after setting all identifiers.
 *
 *  @param userName User name to track.
 
 *  @since v1.0.0
 
 *  @see postIfChanged
 */
+(void) setUserName:(nonnull NSString *) userName;

/**
 *  Set any custom information for user in key value pair format. Call postIfChanged after setting all identifiers.
 *
 *  @param value Custom value to add to identity object.
 *  @param key   Key for the custom value.
 
 *  @since v1.0.0
 
 *  @see postIfChanged
 */
+(void) setCustomUserIdentifier:(nonnull NSString *) value forKey:(nonnull NSString *) key;

/// @name Retrieve Identities Set Locally

/**
 *  Retrieving method for identities.
 *
 *  @return identities Set of key-value pairs of NSDictionary object containing Identities set or nil.
 
 *  @since v1.0.0
 
 */
+(nullable NSDictionary *) identities;

/// @name Post Set Identities to Pyze

/**
 *  Call this method after all the identifers are set.  This sends changed traits to Pyze Servers.
 
 *  @since v1.0.0
 
 *  @warning Call this to send traits to Pyze
 *  @see identities
 */
+(void) postIfChanged; // call after the fields are set.

@end


#pragma mark - Pyze In-App Advertisement Tracking


/**
 *  ### PyzeAd
 *  Subclass of PyzeCustomEvent. This class can be used for posting events related to ads in your apps. 
 */
@interface PyzeAd : PyzeCustomEvent

/// @name Class Methods


/**
 *  Post the event to server once the ad request has successfully been sent to the server.
 *
 *  @param adNetwork  The ad network the app referring to.
 *  @param appScreen  ViewController name where ad would be shown.
 *  @param size       Size of the ad.
 *  @param type       Type of ad for example Interstitial, Banner Ads, DFP ads etc.,
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
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
 
 *  @since v1.0.0
 
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
 
 *  @since v1.0.0
 
 */
+(void) postAdClicked:(nullable NSString *)adNetwork
        fromAppScreen:(nonnull NSString *)appScreen
               adCode:(nonnull NSString *) adCode
            isSuccess:(BOOL) success
        withErrorCode:(nullable NSString *) errorCode
       withAttributes:(nullable NSDictionary *)attributes;

@end

#pragma mark - Pyze Advocacy and Feedback Class

/**
 *  ### PyzeAdvocacy
 *  Subclass of PyzeCustomEvent class used for posting support for feedbacks.
 
 *  @since v1.0.0
 
 */
@interface PyzeAdvocacy : PyzeCustomEvent

/// @name Class Methods

/**
 *  Post request for feedback.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRequestForFeedback:(NSDictionary *)attributes;

/**
 *  Post the feedback received.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postFeedbackProvided:(NSDictionary *)attributes;

/**
 *  Post request rating.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRequestRating:(NSDictionary *)attributes;

@end

#pragma mark - Pyze Mobile Commerce

/**
 *  ### PyzeCommerceDiscovery
 *  Subclass of PyzeCustomEvent used to post the details of events related to Discovery of a item in particular category.
 
 *  @since v1.0.0
 
 */
@interface PyzeCommerceDiscovery : PyzeCustomEvent

/// @name Class Methods

/**
 *  Post the search details, latency value with details.
 *
 *  @param searchString Search string used
 *  @param latency      Latency to complete the operation.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */

+(void) postSearched:(NSString *) searchString
         withLatency:(NSNumber *) latency
      withAttributes:(NSDictionary *)attributes;
/**
 *  Post browsed category details.
 *
 *  @param category   Category name
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postBrowsedCategory:(NSString *) category
             withAttributes:(NSDictionary *)attributes;

/**
 *  Post browsed deal details
 *
 *  @param uniqueDealID Unique deal identification string/number.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postBrowsedDeals:(NSString *) uniqueDealID
          withAttributes:(NSDictionary *)attributes;

/**
 *  Post browsed recommendation details.
 *
 *  @param uniqueRecommendationID uniqueRecommendationID containing a string/number.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postBrowsedRecommendations:(NSString *) uniqueRecommendationID
                    withAttributes:(NSDictionary *)attributes;

/**
 *  Post browsed previous order details.
 *
 *  @param rangeStart Starting range of the order browsed.
 *  @param rangeEnd   Ending range of the order browsed.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postBrowsedPrevOrders:(NSString *) rangeStart
                      withEnd:(NSString *) rangeEnd
               withAttributes:(NSDictionary *)attributes;
@end

/**
 *  ### PyzeCommerceCuratedList
 *  Subclass of PyzeCustomEvent class used post details of the events related to curated list.
 
 *  @since v1.0.0
 
 */
@interface PyzeCommerceCuratedList: PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post creation details of curated list.
 *
 *  @param uniqueCuratedListID Curated list id.
 *  @param curatedListType     Type of curated list.
 *  @param attributes          Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
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
 
 *  @since v1.0.0
 
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
 
 *  @since v1.0.0
 
 */
+(void) postAddedItem:(NSString *) uniqueCuratedListId
         withCategory:(NSString *) itemCategory
           withItemId:(NSString *) itemID
       withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of removed items of curated list
 *
 *  @param uniqueCuratedListID Curated list id.
 *  @param curatedListType     Curated list type.
 *  @param itemID              Item id details.
 *  @param attributes          Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRemovedItem:(NSString *) uniqueCuratedListID
           withListType:(NSString *) curatedListType
             withItemID:(NSString *) itemID
         withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of shared curated list details.
 *
 *  @param curatedList        Curated list name
 *  @param curatedListCreator Creator id of curated list.
 *  @param attributes         Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postShared:(NSString *) curatedList
       withCreator:(NSString *) curatedListCreator
    withAttributes:(NSDictionary *)attributes;

/**
 *  Post published details of curated list.
 *
 *  @param curatedList        Curated list name.
 *  @param curatedListCreator Curated list creator id.
 *  @param attributes         Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postPublished:(NSString *) curatedList
          withCreator:(NSString *) curatedListCreator
       withAttributes:(NSDictionary *)attributes;
@end


/**
 *  ### PyzeCommerceWishList
 *  Subclass of PyzeCustomEvent class used post details of the events related to wish list.
 
 *  @since v1.0.0
 
 */
@interface PyzeCommerceWishList : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post details of wish lists created.
 *
 *  @param uniqueWishListId Unique wish list id.
 *  @param wishListtype     Wish list type.
 *  @param attributes       Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postCreated:(NSString *) uniqueWishListId
   withWishListType:(NSString *) wishListtype
     withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of the browsed wish list.
 *
 *  @param uniqueWishListId Wish list identifier.
 *  @param attributes       Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postBrowsed:(NSString *) uniqueWishListId
     withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of the added item to the wish list.
 *
 *  @param uniqueWishListId Wish list identifier.
 *  @param itemCategory     Item category the item added to.
 *  @param itemId           Item id details.
 *  @param attributes       Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postAddedItem:(NSString *) uniqueWishListId
     withItemCategory:(NSString *) itemCategory
           withItemId:(NSString *) itemId
       withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of the item removed from the wish list.
 *
 *  @param uniqueWishListId Wish list identifier.
 *  @param itemCategory     Item category the item removed from.
 *  @param itemId           Item id details.
 *  @param attributes       Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRemovedItem:(NSString *) uniqueWishListId
       withItemCategory:(NSString *) itemCategory
             withItemId:(NSString *) itemId
         withAttributes:(NSDictionary *)attributes;

/**
 *  Post shared details of the wish list.
 *
 *  @param uniqueWishListId Wish list identitier.
 *  @param attributes       Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postShared:(NSString *) uniqueWishListId
    withAttributes:(NSDictionary *)attributes;

@end

/**
 *  ### PyzeCommerceBeacon
 *  Subclass of PyzeCustomEvent class used post details of the events related to beacon.
 
 *  @since v1.0.0
 
 */
@interface PyzeCommerceBeacon : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post entered region of beacon details.
 *
 *  @param iBeaconUUID            Beacon UUID.
 *  @param iBeaconMajor           Beacon major identifier.
 *  @param iBeaconMinor           Beacon minor identifier.
 *  @param uniqueRegionIdentifier Registration identifier.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postEnteredRegion:(NSString *) iBeaconUUID
          withBeaconMajor:(NSString *) iBeaconMajor
          withBeaconMinor:(NSString *) iBeaconMinor
withUniqueRegionIdentifier:(NSString *)uniqueRegionIdentifier
           withAttributes:(NSDictionary *)attributes;

/**
 *  Post exited region detaikls.
 *
 *  @param iBeaconUUID            Beacon UUID.
 *  @param iBeaconMajor           Beacon major identifier.
 *  @param iBeaconMinor           Beacon minor identifier.
 *  @param uniqueRegionIdentifier Registration identifier.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postExitedRegion:(NSString *) iBeaconUUID
         withBeaconMajor:(NSString *) iBeaconMajor
         withBeaconMinor:(NSString *) iBeaconMinor
withUniqueRegionIdentifier:(NSString *)uniqueRegionIdentifier
          withAttributes:(NSDictionary *)attributes;

/**
 *  Post transaction details of Beacon.
 *
 *  @param iBeaconUUID            Beacon UUID.
 *  @param iBeaconMajor           Beacon major identifier.
 *  @param iBeaconMinor           Beacon minor identifier.
 *  @param uniqueRegionIdentifier Registration identifier.
 *  @param proximity              Proximity state i.e. near or far.
 *  @param actionId               Action identifier.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postTransactedInRegion:(NSString *) iBeaconUUID
               withBeaconMajor:(NSString *) iBeaconMajor
               withBeaconMinor:(NSString *) iBeaconMinor
    withUniqueRegionIdentifier:(NSString *) uniqueRegionIdentifier
                 withProximity:(NSString *) proximity
                  withActionId:(NSString *) actionId
                withAttributes:(NSDictionary *)attributes;
@end

/**
 *  ### PyzeCommerceCart
 *  Subclass of PyzeCustomEvent class used post details of the events related to Cart.
 
 *  @since v1.0.0
 
 */
@interface PyzeCommerceCart : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post details of item added to the cart.
 *
 *  @param cartId       Cart identifier.
 *  @param itemCategory Item category identifier.
 *  @param itemId       Item id details.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postAddItem:(NSString *) cartId
   withItemCategory:(NSString *) itemCategory
         withItemId:(NSString *) itemId
     withAttributes:(NSDictionary *)attributes;

/**
 *  Post detials of item added to cart from the deals.
 *
 *  @param cartId       Cart identifier.
 *  @param itemCategory Item category identifier.
 *  @param itemId       Item id details.
 *  @param uniqueDealId Unique deal identifier.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postAddItemFromDeals:(NSString *) cartId
            withItemCategory:(NSString *) itemCategory
                  withItemId:(NSString *) itemId
            withUniqueDealId:(NSString *) uniqueDealId
              withAttributes:(NSDictionary *)attributes;
/**
 *  Post details of item added to cart from wish list.
 *
 *  @param cartId           Cart identifier.
 *  @param itemCategory     Item category identifier.
 *  @param itemId           Item id details.
 *  @param uniqueWishListId Unique wish list identifier.
 *  @param attributes       Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postAddItemFromWishList:(NSString *) cartId
               withItemCategory:(NSString *) itemCategory
                     withItemId:(NSString *) itemId
           withUniqueWishListId:(NSString *) uniqueWishListId
                 withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of item added to cart from curated list.
 *
 *  @param cartId              Cart identifier.
 *  @param itemCategory        Item category identifier.
 *  @param itemId              Item id details.
 *  @param uniqueCuratedListId Unique curated list identifier.
 *  @param attributes          Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postAddItemFromCuratedList:(NSString *) cartId
                  withItemCategory:(NSString *) itemCategory
                        withItemId:(NSString *) itemId
           withUniqueCuratedListId:(NSString *) uniqueCuratedListId
                    withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of item added to cart from Recommendations.
 *
 *  @param cartId                 Cart identifier.
 *  @param itemCategory           Item category.
 *  @param itemId                 Item id detials.
 *  @param uniqueRecommendationId Unique recommendation identifier.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postAddItemFromRecommendations:(NSString *) cartId
                      withItemCategory:(NSString *) itemCategory
                            withItemId:(NSString *) itemId
            withUniqueRecommendationId:(NSString *) uniqueRecommendationId
                        withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of item added to cart from Previous orders.
 *
 *  @param cartId          Cart identifiers.
 *  @param itemCategory    Item category identifier.
 *  @param itemId          Item id details.
 *  @param previousOrderId Previous order identifier.
 *  @param attributes      Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postAddItemFromPreviousOrders:(NSString *) cartId
                     withItemCategory:(NSString *) itemCategory
                           withItemId:(NSString *) itemId
                  withPreviousOrderId:(NSString *) previousOrderId
                       withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of item added to cart from search results.
 *
 *  @param cartId       Cart identifier.
 *  @param itemCategory Item category identifier.
 *  @param itemId       Item id details.
 *  @param searchString Search string.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postAddItemFromSearchResults:(NSString *) cartId
                    withItemCategory:(NSString *) itemCategory
                          withItemId:(NSString *) itemId
                    withSearchString:(NSString *) searchString
                      withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of item added to cart from subscription list.
 *
 *  @param cartId       Cart identifier.
 *  @param itemCategory Item category identifier.
 *  @param itemId       Item id details.
 *  @param uniqueDealId Unique deal identifier.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postAddItemFromSubcriptionList:(NSString *) cartId
                      withItemCategory:(NSString *) itemCategory
                            withItemId:(NSString *) itemId
                      withUniqueDealId:(NSString *) uniqueDealId
                        withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of the item removed from the Cart.
 *
 *  @param cartId       Cart identifier.
 *  @param itemCategory Item category identifier.
 *  @param itemId       Item id details.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRemoveItemFromCart:(NSString *) cartId
              withItemCategory:(NSString *) itemCategory
                    withItemId:(NSString *) itemId
                withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of view of items in cart.
 *
 *  @param cartId     Cart
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postView:(NSString *) cartId
  withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of the item shared from Cart.
 *
 *  @param cartId     Cart identifier.
 *  @param sharedWith Shared with details FB/Twitter/G+ etc.
 *  @param itemId     Item id details.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postShare:(NSString *) cartId
withItemSharedWith:(NSString *) sharedWith
       withItemId:(NSString *) itemId
   withAttributes:(NSDictionary *)attributes;
@end



/**
 *  ### PyzeCommerceItem
 *  Subclass of PyzeCustomEvent class used post details of the events related to Item.
 
 *  @since v1.0.0
 
 */

@interface PyzeCommerceItem : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post detials of the item viewed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postViewedItem:(NSDictionary *) attributes;

/**
 *  Post detials of the item scanned details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */

+(void) postScannedItem:(NSDictionary *) attributes;


/**
 *  Post detials of the item viewed reviews details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postViewedReviews:(NSDictionary *) attributes;


/**
 *  Post detials of the item viewed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postViewedDetails:(NSDictionary *) attributes;


/**
 *  Post detials of the item viewed price details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postViewedPrice:(NSDictionary *) attributes;


/**
 *  Post detials of the item shared details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postItemShareItem:(NSDictionary *) attributes;


/**
 *  Post details of the item rating details.
 *
 *  @param itemSKU    Item SKU identifier.
 *  @param rating     Rating number out of 5/10.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postItemRateOn5Scale:(NSString *) itemSKU withRating:(NSString *) rating withAttributes:(NSDictionary *)attributes;

@end

/**
 *  ### PyzeCommerceCheckout
 *  Subclass of PyzeCustomEvent class used post details of the events related to Item checkout.
 
 *  @since v1.0.0
 
 */
@interface PyzeCommerceCheckout : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post checkout started details of the item.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postCheckoutStarted:(NSDictionary *) attributes;

/**
 *  Post checkout completion details of the item.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postCheckoutCompleted:(NSDictionary *) attributes;

/**
 *  Post checkout abondonment details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postCheckoutAbandoned:(NSDictionary *) attributes;

/**
 *  Post checkpit failed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postCheckoutFailed:(NSDictionary *) attributes;

@end

/**
 *  ### PyzeCommerceShipping
 *  Subclass of PyzeCustomEvent class used post details of the events related to Item shipping.
 
 *  @since v1.0.0
 
 */

@interface PyzeCommerceShipping : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post shipping started details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postShippingStarted:(NSDictionary *) attributes;

/**
 *  Post shipping completed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postShippingCompleted:(NSDictionary *) attributes;

/**
 *  Post shipping abandonment details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postShippingAbandoned:(NSDictionary *) attributes;

/**
 *  Post shipping failed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 *  @since v1.0.0
 
 */
+(void) postShippingFailed:(NSDictionary *) attributes;

@end

/**
 *  ### PyzeCommerceBilling
 *  Subclass of PyzeCustomEvent class used post details of the events related to Item billing.
 
 *  @since v1.0.0
 
 */

@interface PyzeCommerceBilling : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post billing started details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */

+(void) postBillingStarted:(NSDictionary *) attributes;

/**
 *  Post billing completed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postBillingCompleted:(NSDictionary *) attributes;

/**
 *  Post billing abandonment details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postBillingAbandoned:(NSDictionary *) attributes;

/**
 *  Post billing failed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postBillingFailed:(NSDictionary *) attributes;

@end

/**
 *  ### PyzeCommercePayment
 *  Subclass of PyzeCustomEvent class used post details of the events related to Item payment.
 
 *  @since v1.0.0
 
 */

@interface PyzeCommercePayment : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post payment started details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postPaymentStarted:(NSDictionary *) attributes;

/**
 *  Post payment completed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postPaymentCompleted:(NSDictionary *) attributes;

/**
 *  Post payment abandonment details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postPaymentAbandoned:(NSDictionary *) attributes;

/**
 *  Post payment failed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postPaymentFailed:(NSDictionary *) attributes;

@end

/**
 *  ### PyzeCommerceRevenue
 *  Subclass of PyzeCustomEvent class used post details of the events related to Revenue.
 
 *  @since v1.0.0
 
 */
@interface PyzeCommerceRevenue : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post details of revenue details.
 *
 *  @param revenue    Revenue value.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRevenue:(NSNumber*) revenue withAttributes:(NSDictionary*) attributes;

/**
 *  Post revenue using apple pay details.
 *
 *  @param revenue    Revenue value.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRevenueUsingApplePay:(NSNumber*) revenue withAttributes:(NSDictionary*) attributes;

/**
 *  Post revenue details using Samsung play details.
 *
 *  @param revenue    Revenue value.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRevenueUsingSamsungPay:(NSNumber*) revenue withAttributes:(NSDictionary*) attributes;

/**
 *  Post details of revenue done by GooglePay
 *
 *  @param revenue    Revenue value
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRevenueUsingGooglePay:(NSNumber*) revenue withAttributes:(NSDictionary*) attributes;

/**
 *  Post revenue details
 *
 *  @param revenue           Revenue value.
 *  @param paymentInstrument Payment instrument used.
 *  @param attributes        Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRevenue:(NSNumber*) revenue withPaymentInstrument: (NSString*) paymentInstrument withAttributes:(NSDictionary*) attributes;
@end



#pragma mark - Pyze Mobile Gaming

/**
 *  ### PyzeGaming
 *  Subclass of PyzeCustomEvent class used post details of the events related to Gaming.
 
 *  @since v1.0.0
 
 */
@interface PyzeGaming : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post details of Gaming level the app is in.
 *
 *  @param level      Level started number.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postLevelStarted:(NSString *) level
          withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of Game level completed.
 *
 *  @param level      Level number.
 *  @param score      Current score at the level.
 *  @param success    Success or failure reason.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postLevelEnded:(NSString *) level
             withScore:(NSString *) score
  withSuccessOrFailure:(NSString *) success
        withAttributes:(NSDictionary*) attributes;

/**
 *  Post details of power up consumed during Game play details
 *
 *  @param level      Level number.
 *  @param type       Type of Power-up used.
 *  @param value      Value for the power-up
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postPowerUpConsumed:(NSString *) level
                   withType:(NSString *) type
                  withValue:(NSString *) value
             withAttributes:(NSDictionary*) attributes;

/**
 *  Post details of items purchased in a Game.
 *
 *  @param uniqueItemId Item identifier.
 *  @param itemType     Item type details
 *  @param value        Value of the item.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postInGameItemPurchased:(NSString *) uniqueItemId
                   withItemType:(NSString *) itemType
                  withItemValue:(NSString *) value
                 withAttributes:(NSDictionary*) attributes;

/**
 *  Post achievement details
 *
 *  @param uniqueAchievementId Achievement identifier.
 *  @param type                Type of achievement.
 *  @param attributes          Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postAchievementEarned:(NSString *) uniqueAchievementId
                     withType:(NSString *) type
               withAttributes:(NSDictionary*) attributes;

/**
 *  Post summary details viewed.
 *
 *  @param level      Level number.
 *  @param score      Score at the level.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postSummaryViewed:(NSString*) level
                withScore:(NSString *) score
           withAttributes:(NSDictionary*) attributes;

/**
 *  Post leader board viewed details
 *
 *  @param level Level number.
 *  @param score Score at the level.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postLeaderBoardViewed:(NSString*) level
                    withScore:(NSString *) score
               withAttributes:(NSDictionary*) attributes;

/**
 *  Post details of scorecard view details
 *
 *  @param level      Level number
 *  @param score      Score at the level
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postScorecardViewed:(NSString*) level
                  withScore:(NSString *) score
             withAttributes:(NSDictionary*) attributes;

/**
 *  Post details of the Help view.
 *
 *  @param helpTopicId Help Topic identifier used.
 *  @param dictionary  Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postHelpViewed:(NSString *) helpTopicId
        withAttributes:(NSDictionary *) dictionary;

/**
 *  Post details of tutorial viewed.
 *
 *  @param helpTopicId Help topic identifier used.
 *  @param dictionary  Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postTutorialViewed:(NSString *) helpTopicId
            withAttributes:(NSDictionary *) dictionary;

/**
 *  Post details of the challenging a friend.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postFriendChallenged:(NSDictionary *) attributes;

/**
 *  Post details of the accepted challenge from friend.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postChallengeAccepted:(NSDictionary *) attributes;

/**
 *  Post declined challenge request.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postChallengeDeclined:(NSDictionary *) attributes;

/**
 *  Post Game start details.
 *
 *  @param level      Level number
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postGameStart:(NSString *) level
       withAttributes:(NSDictionary *)attributes;

/**
 *  Post game end details.
 *
 *  @param levelsPlayed Level played at the current session
 *  @param levelsWon    Levels actually won/completed.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postGameEnd:(NSString *) levelsPlayed
      withLevelsWon:(NSString *) levelsWon
     withAttributes:(NSDictionary *)attributes;

@end

#pragma mark - Pyze Mobile Health and Fitness class

/**
 *  ### PyzeHealthAndFitness
 *  Subclass of PyzeCustomEvent class used post details of the events related to Health and Fitness.
 
 *  @since v1.0.0
 
 */

@interface PyzeHealthAndFitness : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post details of health and fitness routine start.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postStarted:(NSDictionary *) attributes;

/**
 *  Post details of health and fitness routine ended.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postEnded:(NSDictionary *) attributes;

/**
 *  Post details of health and fitness routine achievement.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postAchievementReceived:(NSDictionary *) attributes;

/**
 *  Post details of health and fitness routine step-goal completion.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postStepGoalCompleted:(NSDictionary *) attributes;

/**
 *  Post details of health and fitness routine goal completion.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postGoalCompleted:(NSDictionary *) attributes;

/**
 *  Post details of health and fitness routine friend challenge.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postChallengedFriend:(NSDictionary *) attributes;

/**
 *  Post details of health and fitness routine friend challenge acceptance.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postChallengeAccepted:(NSDictionary *) attributes;

@end

#pragma mark - Pyze Content, Messaging, Tasks and Social

/**
 *  ### PyzeContent
 *  Subclass of PyzeCustomEvent class used post details of the events related to Content.
 
 *  @since v1.0.0
 
 */

@interface PyzeContent : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post details of the content viewed.
 *
 *  @param contentName  Content name.
 *  @param categoryName Category of the content.
 *  @param contentId    Content identifier.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postViewed:(NSString *) contentName
          category:(NSString *) categoryName
withUniqueContentId:(NSString *) contentId
    withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of content searched
 *
 *  @param searchString Search string
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postSearched:(NSString *) searchString withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of the content rating.
 *
 *  @param contentName  Content name.
 *  @param categoryName Category name of the content.
 *  @param contentId    Content identifier.
 *  @param rating       Rating value.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRatedOn5PointScale:(NSString *) contentName
                      category:(NSString *) categoryName
           withUniqueContentId:(NSString *) contentId
                 contentRating:(NSDecimalNumber *) rating
                withAttributes:(NSDictionary *)attributes;

/**
 *  Post detials if content is thumbs up.
 *
 *  @param contentName  Content name.
 *  @param categoryName Category of the content.
 *  @param contentId    Content id details.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRatedThumbsUp:(NSString *) contentName
                 category:(NSString *) categoryName
      withUniqueContentId:(NSString *) contentId
           withAttributes:(NSDictionary *)attributes;

/**
 *  Post detials of the content is thumbs down.
 *
 *  @param contentName  Content name.
 *  @param categoryName Category of the content.
 *  @param contentId    Content id details.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRatedThumbsDown:(NSString *) contentName
                   category:(NSString *) categoryName
        withUniqueContentId:(NSString *) contentId
             withAttributes:(NSDictionary *)attributes;
@end


/**
 *  ### PyzeMessaging
 *  Subclass of PyzeCustomEvent class used post details of the events related to Messaging.
 
 *  @since v1.0.0
 
 */

@interface PyzeMessaging : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post message SMS details
 *
 *  @param uniqueId   SMS identifier.
 *  @param dictionary Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postMessageSMS:(NSString *) uniqueId withAttributes:(NSDictionary *) dictionary;

/**
 *  Post details of SMS sent
 *
 *  @param uniqueId   SMS identifier.
 *  @param dictionary Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postMessageSent:(NSString *) uniqueId withAttributes:(NSDictionary *) dictionary;

/**
 *  Post details of SMS received.
 *
 *  @param uniqueId   SMS identifier
 *  @param dictionary Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postMessageReceived:(NSString *) uniqueId withAttributes:(NSDictionary *) dictionary;

/**
 *  Post details of the New conversation created.
 *
 *  @param uniqueId   Conversation identifier.
 *  @param dictionary Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postMessageNewConversation:(NSString *) uniqueId withAttributes:(NSDictionary *) dictionary;

/**
 *  Post voice call details.
 *
 *  @param uniqueId   Call identifier.
 *  @param dictionary Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postMessageVoiceCall:(NSString *) uniqueId withAttributes:(NSDictionary *) dictionary;


@end

/**
 *  ### PyzeTasks
 *  Subclass of PyzeCustomEvent class used post details of the events related to Tasks.
 
 *  @since v1.0.0
 
 */
@interface PyzeTasks: PyzeCustomEvent

/// @name Class Methods

/**
 *  Add the current task to the calendar.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void)  addToCalendarwithAttributes:(NSDictionary *)attributes;

@end


/**
 *  ### PyzeSocial
 *  Subclass of PyzeCustomEvent class used post details of the events related to Social media.
 
 *  @since v1.0.0
 
 */
@interface PyzeSocial: PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post detials of social content shared.
 *
 *  @param socialNetworkName Social network name FB/G+/t
 *  @param contentReference  Content reference URL string shared.
 *  @param category          Category of the content.
 *  @param dictionary        Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postSocialContentShareForNetworkName:(NSString *) socialNetworkName
                         forContentReference:(NSString *) contentReference
                                    category:(NSString *) category
                              withAttributes:(NSDictionary *) dictionary;

/**
 *  Post detials of the Social content liked.
 *
 *  @param socialNetworkName Social network name FB/t/G+
 *  @param contentReference  Content reference URL shared.
 *  @param category          Catefory of the content.
 *  @param dictionary        Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postLiked:(NSString *) socialNetworkName
forContentReference:(NSString *) contentReference
         category:(NSString *) category
   withAttributes:(NSDictionary *) dictionary;

/**
 *  Post details of the social content followed
 *
 *  @param socialNetworkName Social network name FB/t/G+.
 *  @param contentReference  Content reference.
 *  @param category          Category identifier of the Content.
 *  @param dictionary        Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postFollowed:(NSString *) socialNetworkName
 forContentReference:(NSString *) contentReference
            category:(NSString *) category
      withAttributes:(NSDictionary *) dictionary;

/**
 *  Post details of the conten subscribed.
 *
 *  @param socialNetworkName Social network name FB/t/G+
 *  @param contentReference  Content reference.
 *  @param category          Category identifier of the content.
 *  @param dictionary        Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postSubscribed:(NSString *) socialNetworkName
   forContentReference:(NSString *) contentReference
              category:(NSString *) category
        withAttributes:(NSDictionary *) dictionary;

/**
 *  Post details of friend invite.
 *
 *  @param socialNetworkName Social network name FB/t/G+
 *  @param attributes        Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postInvitedFriend: (NSString *) socialNetworkName withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of friend search.
 *
 *  @param source     Source where content searched.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postFoundFriends:(NSString *) source withAtrributes:(NSDictionary *) attributes;


@end

#pragma mark - Pyze Media: Video, Audio, Pictures etc.

/**
 *  ### PyzeMedia
 *  Subclass of PyzeCustomEvent class used post details of the events related to Media.
 
 *  @since v1.0.0
 
 */

@interface PyzeMedia : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post details of the media played.
 *
 *  @param contentName  Content name.
 *  @param type         Type i.e., Audio, video etc.,
 *  @param categoryName Category of the media.
 *  @param percent      Percentage of content played.
 *  @param contentId    Content identifier.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postPlayedMedia:(NSString *) contentName
              mediaType:(NSString *) type
               category:(NSString *) categoryName
          percentPlayed:(NSString *) percent
    withUniqueContentId:(NSString *) contentId
         withAttributes:(NSDictionary *)attributes;

/**
 *  Post details of the search in media.
 *
 *  @param searchString Search string.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postSearched:(NSString *) searchString withAttributes:(NSDictionary *)attributes;

/**
 *  Post detials of the media rating.
 *
 *  @param contentName  Content name.
 *  @param categoryName Category type
 *  @param mediaId      Media identifier.
 *  @param rating       Rating value.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRatedOn5PointScale:(NSString *) contentName
                      category:(NSString *) categoryName
           withUniqueContentId:(NSString *) mediaId
                 contentRating:(NSDecimalNumber *) rating
                withAttributes:(NSDictionary *)attributes;

/**
 *  Post details if media is liked.
 *
 *  @param contentName  Content name.
 *  @param categoryName Content category name.
 *  @param contentId    Content identifier.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRatedThumbsUp:(NSString *) contentName
                 category:(NSString *) categoryName
      withUniqueContentId:(NSString *) contentId
           withAttributes:(NSDictionary *)attributes;

/**
 *  Post details if media is disliked.
 *
 *  @param contentName  Content name.
 *  @param categoryName Content category name.
 *  @param contentId    Content identifier.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRatedThumbsDown:(NSString *) contentName
                   category:(NSString *) categoryName
        withUniqueContentId:(NSString *) contentId
             withAttributes:(NSDictionary *)attributes;

@end

#pragma mark - Pyze In-App Purchases and Bitcoin

/**
 *  ### PyzeInAppPurchaseRevenue
 *  Subclass of PyzeCustomEvent class used post details of the events related to In-App purchase.
 
 *  @since v1.0.0
 
 */

@interface  PyzeInAppPurchaseRevenue : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post price list viewed in purchases
 *
 *  @param appScreenRequestFromId App screen requested identifier.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postPriceListViewViewed:(NSString *) appScreenRequestFromId withAttributes:(NSDictionary *) attributes;

/**
 *  Post details of item bought.
 *
 *  @param itemName            Item name.
 *  @param revenue             Revenue value.
 *  @param currencyISO4217Code Currency code $ or Rs.
 *  @param attributes          Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postBuyItem:(NSString *) itemName
              price:(NSDecimalNumber *) revenue
           currency:(NSString *) currencyISO4217Code
     withAttributes:(NSDictionary *) attributes;

/**
 *  Post details of item bought in USD.
 *
 *  @param itemName   Item name.
 *  @param revenue    Revenue value.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postBuyItemInUSD:(NSString *) itemName
                   price:(NSDecimalNumber *) revenue
          withAttributes:(NSDictionary *) attributes;

/**
 *  Post details of the item bought
 *
 *  @param itemName               Item name.
 *  @param revenue                Revenue value.
 *  @param currencyISO4217Code    Currency code.
 *  @param itemType               Item type.
 *  @param itemSKU                Item SKU.
 *  @param quantity               Number of item purchased.
 *  @param appScreenRequestFromId App screen requested identifier.
 *  @param success                Success or failure.
 *  @param successOrErrorCode     Error code on fail.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
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


/**
 *  ### PyzeBitcoin
 *  Subclass of PyzeCustomEvent class used post details of the events related to Bitcoins.
 
 *  @since v1.0.0
 
 */
@interface PyzeBitcoin : PyzeCustomEvent

/// @name Class Methods
/// @name Class Methods

/**
 *  Post sent bitcoin details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postSentBitcoins:(NSDictionary *) attributes;

/**
 *  Post requested bitcoin details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postRequestedBitcoins:(NSDictionary *) attributes;

/**
 *  Post received bitcoin details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postReceivedBitcoins:(NSDictionary *) attributes;

/**
 *  Post viewed transaction details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postViewedTransactions:(NSDictionary *) attributes;

/**
 *  Post imported private key details of bitcoin.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postImportedPrivateKey:(NSDictionary *) attributes;

/**
 *  Post scanned private key details of bitcoin.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *  @since v1.0.0
 
 */
+(void) postScannedPrivateKey:(NSDictionary *) attributes;

@end

#pragma mark - Pyze Drone and Quadcopter Event tracking

/**
 *  ### PyzeDrone
 *  Subclass of PyzeCustomEvent class used post details of the events related to management of Drones, Quadcopters and other iOS controlled devices over bluetooth, and or adhoc WiFi.
 *  @since v1.6.0
 */
@interface PyzeDrone : PyzeCustomEvent

/// @name Class Methods

/**
 *  Post Preflight health check
 *  Before begining a flight it is a good idea to do a quick health check of both the drone and
 *  transmitter / controller (i.e. the device and app). A Preflight health check could include the
 *  storage (usually a micro SD card) presence and status if the drone is equipped with a camera,
 *  battery status of drone and device, calibration status and satellite lock status for GPS equipped drones.
 *
 *  @param overallStatus summary of overall status
 *  @param storageStatus storage (usually a micro SD card) presence and status if the drone is equipped with a camera
 *  @param droneBatteryChargePercent drone battery status
 *  @param deviceBatteryChargePercent controller device status
 *  @param calibrationStatus callibration status
 *  @param gpsStatus gps Status if drone is GPS equipped
 *  @param attributes Additional custom attributes
 *  @since v1.6.0
 */
+(void) postPreflightCheckCompleted:(NSString *) overallStatus
                  withStorageStatus:(NSString *) storageStatus
                   withDroneBattery:(NSInteger) droneBatteryChargePercent
             withTransmitterBattery:(NSInteger) deviceBatteryChargePercent
              withCalibrationStatus:(NSString *) calibrationStatus
                      withGPSStatus:(NSString *) gpsStatus
                     withAttributes:(NSDictionary *) attributes;

/**
 *  Inflight health check
 *  @param overallStatus summary of overall status
 *  @param rollStatus - acomplished by controlling the Aileron (moving right stick to the left or right) which maneuvers the drone / quadcopter left or right.
 *  @param pitchStatus - acomplished by controlling the Elevator (moving right stick forwards or backwards) which maneuvers the drone / quadcopter forwards or backwards.
 *  @param yawStatus – acomplished by controlling Rudder (moving the left stick to the left or to the right)  Rotates the drone / quadcopter left or right. Points the front of the drone / quadcopter different directions and helps with changing directions while flying.
 *  @param throttleStatus – acomplished by controlling Throttle. Engaged by pushing the left stick forwards. Disengaged by pulling the left stick backwards. This adjusts the altitude, or height, of the quadcopter.
 *  @param trimmingSettings - Adjust roll, pitch, yaw, and throttle if they are off balance. e.g. "+20-20+4+0" would mean adjustments in percent of 20%, -20%, +4% and 0% for roll, pitch, yaw, and throttle respectively.
 *  @param attributes Additional custom attributes
 *  @since v1.6.0
 */
+(void) postInflightCheckCompleted:(NSString *) overallStatus
                          withRoll:(NSString *) rollStatus
                         withPitch:(NSString *) pitchStatus
                           withYaw:(NSString *) yawStatus
                      withThrottle:(NSString *) throttleStatus
                          withTrim:(NSString *) trimmingSettings
                    withAttributes:(NSDictionary *)attributes;

/**
 *  Drone is connected to controlling device.  Time to connect depends on surroundings and interference. Post this after successfully connecting
 *  @param attributes Additional custom attributes
 */
+(void) postConnected:(NSDictionary *)attributes ;

/**
 *  Drone is disconnected from controlling device either explicitly or because of environment or distance
 *  @param code disconnection code indicating how disconnected from the controller's point of view
 *  @param attributes Additional custom attributes
 */
+(void) postDisconnected:(NSString *) code
          withAttributes:(NSDictionary *) attributes;

/**
 *  Drone is Airborne
 *  @param status Drone status if any
 *  @param attributes Additional custom attributes
 */
+(void) postAirborne:(NSString *) status
      withAttributes:(NSDictionary *)attributes ;

/**
 * Drone Landed
 *  @param status Drone status if any
 *  @param attributes Additional custom attributes
 */
+(void)  postLanded:(NSString *) status
     withAttributes:(NSDictionary *)attributes ;

/**
 *  New Flight path created
 *  @param uniqueFlightPathId - Every Flight Path should be associated with a unique identifier or name
 *  @param attributes Additional custom attributes
 */
+(void) postFlightPathCreated:(NSString *) uniqueFlightPathId
               withAttributes:(NSDictionary *)attributes ;

/**
 *  Flight path uploaded to drone
 *  @param uniqueFlightPathId - Every Flight Path should be associated with a unique identifier or name
 *  @param attributes Additional custom attributes
 */
+(void)  postFlightPathUploaded:(NSString *) uniqueFlightPathId
                 withAttributes:(NSDictionary *)attributes ;

/**
 *  Flight path created edited on controller and should be re-uplooaded
 *  @param uniqueFlightPathId - Every Flight Path should be associated with a unique identifier or name
 *  @param attributes Additional custom attributes
 */
+(void)  postFlightPathEdited:(NSString *) uniqueFlightPathId
               withAttributes:(NSDictionary *)attributes ;

/**
 *  Flight path deleted
 *  @param uniqueFlightPathId - Every Flight Path should be associated with a unique identifier or name
 *  @param attributes Additional custom attributes
 */
+(void)  postFlightPathDeleted:(NSString *) uniqueFlightPathId
                withAttributes:(NSDictionary *)attributes ;

/**
 *  Flight path flown
 *  @param uniqueFlightPathId - Every Flight Path should be associated with a unique identifier or name
 *  @param attributes Additional custom attributes
 */
+(void)  postFlightPathCompleted:(NSString *) uniqueFlightPathId
                  withAttributes:(NSDictionary *)attributes;

/**
 *  First Person View Enabled.  this allows a lower quality video to be transmitted to controller in near realtime with an acceptable lag
 *  @param status - status on FPV
 *  @param attributes Additional custom attributes
 */
+(void)  postFirstPersonViewEnabled:(NSString *) status
                     withAttributes:(NSDictionary *)attributes ;

/**
 *  First Person View Disabled.
 *  @param status - status on FPV
 *  @param attributes Additional custom attributes
 */
+(void)  postFirstPersonViewDisabled:(NSString *) status
                      withAttributes:(NSDictionary *)attributes ;

/**
 *  Started taking aerial video identifed by video identifier
 *  @param status - status
 *  @param attributes Additional custom attributes
 */
+(void)  postStartedAerialVideo:(NSString *) status
                 withAttributes:(NSDictionary *)attributes ;

/**
 *  Started taking aerial video identifed by video identifier
 *  @param status - status
 *  @param videoIdentifer - Video Identifier
 *  @param attributes Additional custom attributes
 */
+(void)  postStartedAerialVideo:(NSString *) status
                 videoIdentifer:(NSString *) videoIdentifer
                 withAttributes:(NSDictionary *)attributes;

/**
 *  Stopped taking aerial video
 *  @param videoIdentifer - Video Identifier
 *  @param attributes Additional custom attributes
 */
+(void)  postStoppedAerialVideo:(NSString *) videoIdentifer
                     withLength:(NSString *) secondsLength
                 withAttributes:(NSDictionary *)attributes ;


/**
 *  Took Aerial Picture
 *  @param status - status
 *  @param attributes Additional custom attributes
 */
+(void)  postTookAerialPicture:(NSString *) status
                withAttributes:(NSDictionary *)attributes ;

/**
 *  Started taking Aerial Timelapse - In Time-lapse drone photography the frequency at which frames are captured
 *  (the frame rate) is much lower than that used to view the sequence. When played at normal speed, time appears
 *  to be moving faster and thus lapsing. For example, an image of a scene may be captured once every second,
 *  then played back at 30 frames per second; the result is an apparent 30 times speed increase.  Specify total shots
 *  and seconds between shots.  The playback time would be approximately be the product of total shots and seconds betwwen shots
 *
 *  @param status - status
 *  @param totalshots - Total Number of shots
 *  @param secondsBetweenShots - delay between shots
 *  @param attributes Additional custom attributes
 */
+(void)  postStartedAerialTimelapse:(NSString *) status
                         totalShots:(NSInteger) totalshots
                  delayBetweenShots:(NSInteger) secondsBetweenShots
                     withAttributes:(NSDictionary *) attributes ;

/**
 *  Stopped Aerial Timelapse
 *  @param status - status (interupted / completed)
 *  @param attributes Additional custom attributes
 */
+(void)  postStoppedAerialTimelapse:(NSString *) status
                     withAttributes:(NSDictionary *) attributes ;

/**
 *  Requested Drone to return to base
 *  @param attributes Additional custom attributes
 */
+(void)  postRequestedReturnToBase:(NSDictionary *)attributes ;

/**
 *  Switched to Helicopter flying mode.  Similar to flying a helicopter,
 *  once you tilt the quadcopter (roll) it will not auto-level itself back to
 *  its original position. Even if you let go of the stick and it returns to
 *  the middle, the drone will stay tilted.  Not all drones support this Manual mode.
 *
 *  @param attributes Additional custom attributes
 */
+(void)  postSwitchedToHelicopterFlyingMode:(NSDictionary *)attributes ;

/**
 *  Switched to Attitude or Auto-level flying mode.  Once the sticks are centered, the drone will level itself out
 *
 *  @param attributes Additional custom attributes
 */
+(void)  postSwitchedToAttitudeFlyingMode:(NSDictionary *)attributes ;

/**
 *  Switched to GPS Hold flying mode – Returns the drone's position once the sticks have been centered.
 *  The same as attitude mode (auto-level) but using an on-board GPS.  Drones that support GPS usually have this mode.
 *
 *  @param attributes Additional custom attributes
 */
+(void)  postSwitchedToGPSHoldFlyingMode:(NSDictionary *)attributes ;

/**
 *  Switched to Custom Device Mode identified by a numeric mode.  Some drones have numbered modes 1, 2, 3.
 *
 *  @param mode - Numeric custom mode
 *  @param attributes Additional custom attributes
 */
+(void)  postSwitchedToCustomFlyingMode: (NSInteger) mode
                         withAttributes: (NSDictionary *)attributes ;

/**
 *  Drones that support GPS can limit the altitude to avoid flying into restricted airspace
 *
 *  @param altitudeInMeters - altitude in meters. One foot is 0.3048 meters.
 *  @param attributes Additional custom attributes
 */
+(void)  postSetMaxAltitude:(NSInteger) altitudeInMeters
             withAttributes:(NSDictionary *)attributes ;

/**
 *  This feature is avilable on drones that are used for surveying.  If the drone has to survey 4 jobs you can specify the time in seconds for a job to ensure enough battery is available for subsequent jobs.  The math is performed by app
 *
 *  @param seconds - seconds to return in
 *  @param attributes Additional custom attributes
 */
+(void)  postSetAutoReturnInSeconds:(NSInteger) seconds
                     withAttributes:(NSDictionary *)attributes ;

/**
 *  The drone can be requested to return when storage memory reaches a low threshold. (See customer ticket #2312)
 *
 *  @param memoryLeftInKilobytes - return when storage is below memoryLeftInKilobytes
 *  @param attributes Additional custom attributes
 */
+(void)  postSetAutoReturnWhenLowMemory:(NSInteger) memoryLeftInKilobytes
                         withAttributes:(NSDictionary *)attributes ;
/**
 *  The drone can be requested to return when battery reaches a low threshold.
 *
 *  @param batterylevelPercent - return when battery is below batterylevelPercent
 *  @param attributes Additional custom attributes
 */
+(void)  postSetAutoReturnWhenLowBattery:(NSInteger) batterylevelPercent
                          withAttributes:(NSDictionary *)attributes ;

@end

NS_ASSUME_NONNULL_END

