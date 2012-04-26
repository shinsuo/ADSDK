//
//  TomatoSDK.m
//  TomatoSDK
//
//  Created by xin suo on 12-4-19.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import "TomatoSDK.h"
#import "PBHardwareUtil.h"
//#import "PBASIHTTPRequest.h"
#import "TomatoADConstant.h"
#import "TomatoSDKConnection.h"
/*
//URL接口版本
static NSUInteger   URLVersion      = 2;
//终端设备唯一标识串
static NSString     *UDID;
//触控UUID
static NSString     *CKID;
//OS类型:0、Unknown1、iOS  2、Android  3、BlackBerry4、iOS模拟器5、Android模拟器
static NSUInteger   osType;
//终端类型:iPhone、iPad、Android、Android_Pad
static NSString     *terminalType;
//OS版本
static NSString     *osVersion;
//OS名称
static NSString     *osName;
//是否是破解平台:0=非破解平台，1=破解平台
static NSUInteger   isCrack;
//屏幕分辨率
static NSString     *Screen_Resolution;
//设备方向:0=Unknown,1=Portrait，2=PortraitUpsideDown，3=LandscapeLeft，4=LandscapeRight，5=FaceUp，6=FaceDown
static NSUInteger   Orientation;
//GPS坐标信息
static CLLocationCoordinate2D     coordinate;
//网络类型:1、Wifi  2、移动网络3、Proxy4、其它
static NSUInteger   NetType;
//APPUID:app唯一标识(全部大写存储)
static NSString     *appUID;
//APP版本好
static NSString     *appVersion;
//渠道ID
static NSString     *partId         = @"DF557FA2-C304-556BA442-960AB835CB5D";
//国家代码:如US
static NSString     *CC;
//终端语言:如en
static NSString     *Lang;
//SDK版本号
static NSString     *SDKVersion;
//开发者ID
static NSString     *devUID         = @"DF557FA2-C304-556BA442-960AB835CB5D";


static NSString     *puid;
static NSString     *wmac;

static NSUInteger testViewIndex;

 */

static TomatoSDKConnection *connection = nil;

@interface TomatoSDK()

+ (void)getBaseInfo;

@end

@implementation TomatoSDK


#pragma mark Private Method

+ (void)getBaseInfo
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
}

#pragma mark Public Method
+ (void)startSession:(NSString *)apiKey
{
    if (!connection) {
        //        [TomatoSDK getBaseInfo];
        connection = [[TomatoSDKConnection alloc] init];
        [connection requestSession:apiKey];
    }
}

+ (void)logEvent:(NSString *)eventName withView:(UIView *)view
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.baidu.com"];
    NSURL *url = [NSURL URLWithString:urlString];
    [connection requestURL:url withView:view];
}

@end
