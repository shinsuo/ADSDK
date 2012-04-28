//
//  TomatoSDK.h
//  TomatoSDK
//
//  Created by xin suo on 12-4-19.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface TomatoSDK : NSObject

/*
 start session, attempt to send saved sessions to server 
 */
+ (void)startSession:(NSString *)apiKey;
+ (void)endSession;


/*
 log Event Method
 */

+ (void)logSingleEvent:(NSString *)eventName withView:(UIView *)adParentView;
+ (void)logPurchaseEvent:(NSString *)eventName withView:(UIView *)adParentView;
+ (void)logScoreEvent:(NSString *)eventName withView:(UIView *)adParentView;
+ (void)logSpendSecondsEvnet:(NSString *)eventName withView:(UIView *)adParentView;

+ (void)logError:(NSString *)errorID message:(NSString *)message exception:(NSException *)exception;
+ (void)logError:(NSString *)errorID message:(NSString *)message error:(NSError *)error;

+ (void)endTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;	// non-nil parameters will update the parameters

@end
