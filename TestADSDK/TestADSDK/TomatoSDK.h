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

typedef enum {
    EventGeneral = 0,
    EventPurchase,
    EventScore,
    EventSpendSeconds,
    
    EventMax,
}EventType;

@interface TomatoSDK : NSObject

/*
 start session, attempt to send saved sessions to server 
 */
+ (void)startSession:(NSString *)apiKey;
+ (void)endSession;

/*
 log events or errors after session has started
 */
+ (void)logEvent:(NSString *)eventName withEventType:(EventType)eventType withView:(UIView *)view;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters withEventType:(EventType)eventType withView:(UIView *)view;
+ (void)logError:(NSString *)errorID message:(NSString *)message exception:(NSException *)exception;
+ (void)logError:(NSString *)errorID message:(NSString *)message error:(NSError *)error;

/* 
 start or end timed events
 */
+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed withEventType:(EventType)eventType withView:(UIView *)view;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed withEventType:(EventType)eventType withView:(UIView *)view;
+ (void)endTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;	// non-nil parameters will update the parameters

@end
