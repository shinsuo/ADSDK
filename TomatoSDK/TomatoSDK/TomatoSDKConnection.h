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
    //sessionId
    NSUInteger              sessionID;
    NSString                *fr_;
    //Data
    NSMutableData           *receivedData_;
    NSMutableDictionary     *basicDataDicts_;
    NSString                *basicDataString_;
    
    NSString                *netType_;
    
    //Event
    NSMutableArray          *eventIdArray_;
    NSUInteger              eventCount;
    NSString                *currentEventName_;
    //Event Purchase
    NSUInteger              dn;
    float                   dm;
    NSString                *cu;
    //Event Score
    float                   ds;
    //Event Spend
    NSTimeInterval          to;
    NSUInteger              spt;
    
    //Video
    NSUInteger              tp;
    NSString                *sbd;
    
    //Container
    UIWebView               *webView_;
    MPMoviePlayerController *movieController_;
    
    //URL
    NSMutableDictionary     *urlDict_;
    NSString                *urlString_;
    NSURL                   *url_;
    
    CGSize                  currentLocation;
    NSString                *isDebug_;
    int                     *arcRandom;
    id<TomatoAdDelegate>    delegate_;
}

@property (nonatomic,assign) id<TomatoAdDelegate> delegate;

@property (nonatomic,retain) NSString       *appKey;
@property (nonatomic,retain) NSString       *devID;
@property (nonatomic,retain) NSString       *puID;
@property (nonatomic,assign) NSUInteger     dn;
@property (nonatomic,assign) float          dm;
@property (nonatomic,assign) NSString       *cu;
@property (nonatomic,assign) NSUInteger     score;

- (id)initWithAppKey:(NSString *)appKey_ withDEVID:(NSString *)devID_ withPUID:(NSString *)puID_;
- (void)requestSession;
- (void)requestEventName:   (NSString *)eventName withType:(EVENT_TYPE)eventType;

+ (void)setDebugMode;


@end
