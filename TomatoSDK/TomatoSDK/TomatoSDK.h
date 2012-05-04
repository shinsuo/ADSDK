//
//  TomatoSDK.h
//  TomatoSDK
//
//  Created by Shin Suo on 12-4-19.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "TomatoAdDelegate.h"

@interface TomatoSDK : NSObject

/*
 start session, attempt to send saved sessions to server 
 end session
 */
+ (void)startSession:(NSString *)apiKey;
+ (void)endSession;

/*
 set Delegate
 */
+ (void)setDelegate:(id<TomatoAdDelegate>)delegate_;

/*
 add Persisted Ad
 */
+ (void)addPersistedAd:(NSString *)persistedAdName;

/*
 log Event Method
 */
+ (void)logSingleEvent:(NSString *)eventName;
+ (void)logPurchaseEvent:(NSString *)eventName ;
+ (void)logScoreEvent:(NSString *)eventName;
+ (void)logSpendSecondsEvnet:(NSString *)eventName;

+ (void)logError:(NSString *)errorID message:(NSString *)message exception:(NSException *)exception;
+ (void)logError:(NSString *)errorID message:(NSString *)message error:(NSError *)error;

+ (void)endTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;	// non-nil parameters will update the parameters

@end
