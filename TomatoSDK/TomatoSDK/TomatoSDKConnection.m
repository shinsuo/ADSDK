//
//  TomatoSDKConnection.m
//  TomatoSDK
//
//  Created by xin suo on 12-4-26.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import "TomatoSDKConnection.h"
#import "PBASIHTTPRequest.h"

@implementation TomatoSDKConnection

- (void)requestURL:(NSURL *)url
{
    PBASIHTTPRequest *request = [PBASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(PBASIHTTPRequest *)request
{
    NSLog(@"requestFinished:%@",[request responseString]);
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
