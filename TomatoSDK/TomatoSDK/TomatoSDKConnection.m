//
//  TomatoSDKConnection.m
//  TomatoSDK
//
//  Created by xin suo on 12-4-26.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import "TomatoSDKConnection.h"
#import "TomatoSDK.h"
#import "TomatoADConstant.h"

#import "PBHardwareUtil.h"
#import "PBASIHTTPRequest.h"
#import "PBCJSONDeserializer.h"
#import "PBCJSONSerializer.h"
#import "PBASIFormDataRequest.h"

static UIView *adParentView = nil;

@interface TomatoSDKConnection()

- (void)addWebAD;
- (void)addVideoAD;
- (void)getBasicDatas;

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
    /*
    PBASIHTTPRequest *request = [PBASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
     */
    
    PBASIFormDataRequest *formRequest = [PBASIFormDataRequest requestWithURL:url];
    
    [formRequest setPostValue:@"suoxinname" forKey:@"username"];
    [formRequest setPostValue:@"suoxinpasswor" forKey:@"password"];
    
    [formRequest setDelegate:self];
    [formRequest startAsynchronous];
    
}

#pragma mark Private Method
- (void)addWebAD
{

}

- (void)addVideoAD
{
    
}

- (void)getBasicDatas
{
    UIDeviceExtend *device = [UIDeviceExtend currentDevice];
    NSLog(@"device.name:%@",device.name);
    NSLog(@"device.model:%@",device.model);
    NSLog(@"device.systemName:%@",device.systemName);
    NSLog(@"device.systemVersion:%@",device.systemVersion);
    NSLog(@"device.orientation:%i",device.orientation);
    NSLog(@"device.PBIdentifier:%@",device.PBIdentifier);
    NSLog(@"device.platform:%@",device.platform);
    NSLog(@"device.hwmodel:%@",device.hwmodel);
    NSLog(@"device.platformType:%i",device.platformType);
    NSLog(@"device.platformString:%@",device.platformString);
    NSLog(@"device.platformCode:%@",device.platformCode);
    NSLog(@"device.cpuFrequency:%i",device.cpuFrequency);
    NSLog(@"device.busFrequency:%i",device.busFrequency);
    NSLog(@"device.totalMemory:%i",device.totalMemory);
    NSLog(@"device.freeDiskSpace:%@",device.freeDiskSpace);
    NSLog(@"device.macaddress:%@",device.macaddress);
        
    NSDictionary *basicData = [[NSDictionary alloc] initWithObjectsAndKeys:@"suoxinusername",@"username",@"suoxinpassword",@"password", nil];
    NSString *requestString = [[PBCJSONSerializer serializer] serializeDictionary:basicData];
    NSData *requestData = [requestString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    
    
    
}

#pragma mark PBASIHttpRequest Delegate
- (void)requestFinished:(PBASIHTTPRequest *)request
{
    //apiKey验证完成,设置apiKeyValid
    
    //
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
    /*
    PBCJSONDeserializer *jsonDeserializer = [PBCJSONDeserializer deserializer];
    NSError *error = nil;
    NSDictionary *jsonDict = [jsonDeserializer deserializeAsDictionary:data error:&error];
    if (error) {
        NSLog(@"error:%@",[error userInfo]);
    }
    
    NSLog(@"jsonDict:%@",jsonDict);
    NSLog(@"ver:%@",[jsonDict valueForKey:@"ver"]);
    NSLog(@"result:%@",[jsonDict valueForKey:@"result"]);
    NSLog(@"items:%@",[jsonDict valueForKey:@"items"]);
    NSArray *datas = [jsonDict valueForKey:@"datas"];
    NSDictionary *data1 = [datas objectAtIndex:0];
    NSLog(@"data1 body:%@",[data1 valueForKey:@"body"]);
    NSLog(@"data1 type:%@",[data1 valueForKey:@"type"]);
     */
}

@end
