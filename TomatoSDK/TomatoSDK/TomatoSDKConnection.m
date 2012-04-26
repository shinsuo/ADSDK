//
//  TomatoSDKConnection.m
//  TomatoSDK
//
//  Created by xin suo on 12-4-26.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import "TomatoSDKConnection.h"
#import "PBASIHTTPRequest.h"

static UIView *adParentView = nil;

@interface TomatoSDKConnection()

- (void)addWebAD;
- (void)addVideoAD;

@end

@implementation TomatoSDKConnection

#pragma mark Public Method
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
