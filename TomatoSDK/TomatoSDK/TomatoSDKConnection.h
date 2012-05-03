//
//  TomatoSDKConnection.h
//  TomatoSDK
//
//  Created by xin suo on 12-4-26.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PBASIHTTPRequestDelegate;

@interface TomatoSDKConnection : NSObject <PBASIHTTPRequestDelegate >
{
    NSData          *receivedData_;
    NSDictionary    *basicDatas_;
}

@property (nonatomic,retain)NSString *apiKey;
@property (nonatomic) BOOL apiKeyValid;

- (void)requestSession:(NSString *)apiKey_;
- (void)requestURL:(NSURL *)url withView:(UIView *)view;

@end
