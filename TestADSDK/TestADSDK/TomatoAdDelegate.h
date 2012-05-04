//
//  TomatoAdDelegate.h
//  TomatoSDK
//
//  Created by Shin Suo on 12-5-3.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TomatoAdView;

@protocol TomatoAdDelegate <NSObject>

@required
- (void)didReceived:(TomatoAdView *)adView withParameters:(NSDictionary *)parameters;
- (void)didFailWithMessage:(NSString *)msg;

@end
