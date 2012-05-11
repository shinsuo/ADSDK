//
//  TomatoSDKConnection.h
//  TomatoSDK
//
//  Created by Shin Suo on 12-4-26.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "TomatoAdDelegate.h"
#import "TomatoADConstant.h"

#import "PBASIHTTPRequestDelegate.h"

@protocol PBASIHTTPRequestDelegate;

@interface TomatoSDKConnection : NSObject <PBASIHTTPRequestDelegate,CLLocationManagerDelegate >
{
    NSMutableData           *receivedData_;
    NSMutableDictionary     *basicDataDicts_;
    NSString                *basicDataString_;
    NSMutableArray          *eventIdArray_;
    NSUInteger              eventCount;
    NSString                *currentEventName_;
    UIWebView               *webView_;
    MPMoviePlayerController *movieController_;
    NSMutableDictionary     *urlArray_;
    id<TomatoAdDelegate>    delegate_;
}

@property (nonatomic,retain)NSString *apiKey;
@property (nonatomic) BOOL apiKeyValid;
@property (nonatomic,assign) id<TomatoAdDelegate> delegate;

- (void)requestSession:(NSString *)apiKey_;
- (void)requestEventName:(NSString *)eventName withType:(EVENT_TYPE)eventType;

+ (void)setDebugMode;
@end
