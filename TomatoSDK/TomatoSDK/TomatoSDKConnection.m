//
//  TomatoSDKConnection.m
//  TomatoSDK
//
//  Created by xin suo on 12-4-26.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import "TomatoSDKConnection.h"
#import "PBASIHTTPRequest.h"
#import "TomatoSDK.h"

static UIView *adParentView = nil;

@interface TomatoSDKConnection()

- (void)addWebAD;
- (void)addVideoAD;

@end

@implementation TomatoSDKConnection

@synthesize apiKey;
@synthesize apiKeyValid;

#pragma mark Public Method
- (void)requestSession:(NSString *)apiKey_
{
    //默认apiKeyValid为NO
    self.apiKeyValid = NO;
    //保存一份apiKey_
    self.apiKey = apiKey_;
    //向server发送apiKey_，验证apiKey是否合法
    
}

- (void)requestURL:(NSURL *)url withView:(UIView *)view
{
    adParentView = view;
    
    PBASIHTTPRequest *request = [PBASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark Private Method
- (void)addWebAD
{

}

- (void)addVideoAD
{
    
}

#pragma mark PBASIHttpRequest Delegate
- (void)requestFinished:(PBASIHTTPRequest *)request
{
    //apiKey验证完成,设置apiKeyValid
    
    //
    NSLog(@"requestFinished:%@",[request responseString]);
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.202.49/TestADSDK/iPhone_gangtie1.png"];
}

- (void)requestFailed:(PBASIHTTPRequest *)request
{
    NSLog(@"requestFailed");
}

- (void)request:(PBASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"didReceiveData:%@",dataString);
}

@end
