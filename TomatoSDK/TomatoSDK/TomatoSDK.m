//
//  TomatoSDK.m
//  TomatoSDK
//
//  Created by Shin Suo on 12-4-19.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import "TomatoSDK.h"
//#import "PBASIHTTPRequest.h"
#import "TomatoADConstant.h"
#import "TomatoSDKConnection.h"

static TomatoSDKConnection *connection = nil;

@interface TomatoSDK()


/*
 log events or errors after session has started
 */
+ (void)logEvent:(NSString *)eventName withEventType:(EVENT_TYPE)eventType;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters withEventType:(EVENT_TYPE)eventType;

/* 
 start or end timed events
 */
+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed withEventType:(EVENT_TYPE)eventType;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed withEventType:(EVENT_TYPE)eventType;

@end

@implementation TomatoSDK

#pragma mark Private Method



#pragma mark Public Method

+ (void)setDebugMode
{
    [TomatoSDKConnection setDebugMode];
}

+ (void)startSession:(NSString *)apiKey withDEVID:(NSString *)devID withPUID:(NSString *)puID
{
    if (!connection) {
        //        [TomatoSDK getBaseInfo];
        connection = [[TomatoSDKConnection alloc] initWithAppKey:apiKey withDEVID:devID withPUID:puID];
        [connection requestSession];
    }
}

+ (void)endSession
{
    [connection release];
    connection = nil;
}

+ (void)setDelegate:(id<TomatoAdDelegate>)delegate_
{
    connection.delegate = delegate_;
}

+ (void)logSingleEvent:(NSString *)eventName
{
    [connection requestEventName:eventName withType:EVENTSINGLE];
}

+ (void)logPurchaseEvent:(NSString *)eventName withDN:(NSUInteger)dn withDM:(float)dm withCU:(NSString *)cu
{
    connection.dn = dn;
    connection.dm = dm;
    connection.cu = cu;
    [connection requestEventName:eventName withType:EVENTPURCHASE];
}

+ (void)logScoreEvent:(NSString *)eventName withScore:(NSUInteger)score
{
    connection.score = score;
    [connection requestEventName:eventName withType:EVENTSCORE];
}

+ (void)logSpendSecondsEvnet:(NSString *)eventName
{
    [connection requestEventName:eventName withType:EVENTSPENDSECONDS];
}

@end
