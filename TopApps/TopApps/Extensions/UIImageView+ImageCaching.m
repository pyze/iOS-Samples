//
//  UIImageView+ImageCaching.m
//  NSURLSessionExample
//
//  Created by Ramachandra Naragund on 10/08/15.
//  Copyright (c) 2015 Robosoft Technologies Pvt Ltd. All rights reserved.
//

#import "UIImageView+ImageCaching.h"
#import <objc/runtime.h>

typedef void (^DownloadCompletionBlock) (BOOL succes, UIImage *image, NSError *error);


@interface  UIImageView (ImageCachingPrivate)
@property(nonatomic) NSURL * imageURL;
@property(nonatomic) NSString *URLId;
@end


//CompletionBlock ImageDownloader which get actual Image on succes and error on failure in completionBlock
typedef void (^CompletionBlock) (BOOL succes, UIImage *image, NSURL *url, NSError *error);

//Class resposible for downloading actual image takes session and imageurl as arguments
//performs the download task on the given session and call the respective completionBlock

@interface ImageDownloader : NSObject
@property (nonatomic, strong) NSURLSession *connectionSession;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, copy) CompletionBlock downloadedBlock;

- (ImageDownloader *)startDownloadForURL:(NSURL *)URL
                                   cache:(NSCache *)cache
                                 session:(NSURLSession *)session
                         completionBlock:(CompletionBlock)completionBlock;

@end


@implementation ImageDownloader

- (ImageDownloader *)startDownloadForURL:(NSURL *)URL
                                   cache:(NSCache *)cache
                                 session:(NSURLSession *)session
                         completionBlock:(CompletionBlock)completionBlock
{
    if (URL)
    {
        self.URL = URL;
        self.cache = cache;
        self.connectionSession = session;
        self.downloadedBlock = completionBlock;
        [self start];
    }
    return self;
}



- (void)cacheImage:(UIImage *)image
{
    if (image && self.URL)
    {
        [self.cache setObject:image forKey:self.URL];
    }
}

- (void)start
{
    NSURLSessionDownloadTask *downloadImage = [self.connectionSession downloadTaskWithRequest:[NSURLRequest requestWithURL:self.URL] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            [self cacheImage:image];
            if (self.downloadedBlock)
            {
                self.downloadedBlock(YES, image, response.URL, nil);
            }
        }
        else
        {
            if (self.downloadedBlock)
            {
                self.downloadedBlock(NO, nil, response.URL, error);
            }
        }
    }];
    
    [downloadImage resume];
}

@end

@implementation UIImageView (ImageCaching)

const char *keyForURLID = "imageURLID";
const char *keyForCompletionBlock = "completionBlockID";


- (NSString *)URLId
{
    return objc_getAssociatedObject(self, keyForURLID);
}

- (void)setURLId:(NSString *)urlId
{
    objc_setAssociatedObject(self, keyForURLID, urlId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSCache *)defaultCache
{
    static NSCache *sharedCache = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[NSCache alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(__unused NSNotification *note) {
            [sharedCache removeAllObjects];
        }];
    });
    
    return sharedCache;
}

+ (NSURLSession *)defaultSession
{
    static NSURLSession *sharedSession = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return sharedSession;
}

-(void) setImageURL:(NSURL *) url {
    [self setImageURL:url withCompletionBlock:nil];
}

-(NSString *) urlString {
    return self.URLId;
}


- (void)setImageURL:(NSURL *)imageURL withCompletionBlock:(DownloadCompletionBlock)block
{
    self.URLId = [imageURL absoluteString];
    UIImage *img = [[UIImageView defaultCache] objectForKey:imageURL];
    if (!img)
    {
        ImageDownloader *dowloader = [[ImageDownloader alloc] init];
        [dowloader startDownloadForURL:imageURL  cache:[UIImageView defaultCache] session:[UIImageView defaultSession] completionBlock:^(BOOL succes, UIImage *image, NSURL *imgURL, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (succes)
                {
                    if ([[imgURL absoluteString] isEqualToString:self.URLId])
                    {
                        self.image = image;
                        [self setContentMode:UIViewContentModeScaleAspectFit];
                        if (block)
                        {
                            block(YES, image, nil);
                        }
                    }
                }
                else
                {
                    if (block)
                    {
                        block(NO, nil, error);
                    }
                }
            });
        }];
    }
    else
    {
        self.image = img;
    }
}

@end
