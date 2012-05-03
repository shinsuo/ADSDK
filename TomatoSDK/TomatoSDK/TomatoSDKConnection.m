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

#import "PBReachability.h"

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
- (id)init
{
    if (self = [super init]) {
        //init received Data
        receivedData_ = [[NSMutableData alloc] init];
        //get Hardware Info
        UIDeviceExtend *device = [UIDeviceExtend currentDevice];
        
        PBReachability *r = [PBReachability reachabilityWithHostName:@"atm.punchbox.org"];
        NSLog(@"current ReachabilityStatus:%i",[r currentReachabilityStatus]);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name: PBkReachabilityChangedNotification
                                                   object: nil];
        
        NSLog(@"startNotifier:%i",[r startNotifier]);
        
        NSLog(@"Mac Address:%@",device.getMacAddress);
        
        //get Location(GPS)
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];//
        NSLog(@"CLLocationManager:%f,%f",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude);
        
        //screen resolution
        UIScreen *screen = [UIScreen mainScreen];
        NSLog(@"uiScreen:%f,%f,%f",screen.currentMode.size.height,screen.currentMode.size.width,screen.currentMode.pixelAspectRatio);
        
        //init Basic Data
        basicDatas_ = [[NSDictionary alloc] initWithObjectsAndKeys:
                       @"",APPUID, 
                       @"",APPVERSION,
                       @"",PARTID,
                       @"2",SDKVERSION,
                       @"2",URLVERSION,
                       device.uniqueIdentifier,UDID,
                       @"",CKID,
                       @"",PUID,
                       device.systemName,OSTYPE,
                       device.systemVersion,OSVERSION,
                       device.model,TERMINALTYPE,
                       device.isJailBroken,JAILBREAK,
                       @"",RESOLUTION,
                       device.orientation,ORIENTATION,                 //can Changed
                       @"",GPS,                         //can Changed
                       [r currentReachabilityStatus],NETTYPE,   //can Changed
                       [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode],CC,
                       [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0],LANG,
                       device.getMacAddress,WMAC,
                       nil];
        
        [self getBasicDatas];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [receivedData_ release];
}

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
    //*
    PBASIHTTPRequest *request = [PBASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
     //*/
    /*
    PBASIFormDataRequest *formRequest = [PBASIFormDataRequest requestWithURL:url];
    
    [formRequest setPostValue:@"suoxinname" forKey:@"username"];
    [formRequest setPostValue:@"suoxinpasswor" forKey:@"password"];
    
    [formRequest setDelegate:self];
    [formRequest startAsynchronous];
    //*/
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
    NSLog(@"device.PBIdentifier:%@",[device.PBIdentifier uppercaseString]);
    NSLog(@"device.platform:%@",device.platform);
    NSLog(@"device.hwmodel:%@",device.hwmodel);
    NSLog(@"device.platformType:%i",device.platformType);
    NSLog(@"device.platformString:%@",device.platformString);
    NSLog(@"device.platformCode:%@",device.platformCode);
//    NSLog(@"device.cpuFrequency:%i",device.cpuFrequency);
//    NSLog(@"device.busFrequency:%i",device.busFrequency);
//    NSLog(@"device.totalMemory:%i",device.totalMemory);
//    NSLog(@"device.freeDiskSpace:%@",device.freeDiskSpace);
//    NSLog(@"device.macaddress:%@",device.macaddress);
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
    [receivedData_ appendData:data];
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
    NSInteger type = [(NSNumber *)[data1 valueForKey:@"type"] integerValue];
    NSLog(@"nsuinteger type:%i",type);
     //*/
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    NSLog(@"notification:%@",notification);
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"newLocation:%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    NSLog(@"oldLocation:%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
}

@end
