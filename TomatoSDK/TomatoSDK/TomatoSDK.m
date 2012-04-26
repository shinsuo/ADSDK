//
//  TomatoSDK.m
//  TomatoSDK
//
//  Created by xin suo on 12-4-19.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import "TomatoSDK.h"
#import "PBHardwareUtil.h"
#import "PBASIHTTPRequest.h"
#import "PBASIHTTPRequestDelegate.h"
#import "TomatoADConstant.h"
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

static BOOL apiKeyValid = false;
static UIView *adParentView = nil;

@interface TomatoSDK()

+ (BOOL)checkApiKey:(NSString *)apiKey;
+ (void)getBaseInfo;

@end

@implementation TomatoSDK


#pragma mark Private Method
+ (BOOL)checkApiKey:(NSString *)apiKey
{
    apiKeyValid = YES;
    return YES;
}

+ (void)getBaseInfo
{
    /*
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSLog(@"name:%@",currentDevice.name);
    NSLog(@"model:%@",currentDevice.model);
    NSLog(@"localizedModel:%@",currentDevice.localizedModel);
    NSLog(@"systemName:%@",currentDevice.systemName);
    NSLog(@"systemVersion:%@",currentDevice.systemVersion);
    NSLog(@"orientation:%i",currentDevice.orientation);
    NSLog(@"uniqueIdentifier:%@",currentDevice.uniqueIdentifier);
    */
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
    if ([self checkApiKey:apiKey]) {
        [TomatoSDK getBaseInfo];
    }else {
        NSLog(@"apiKey invalid!");
    }
}

+ (void)setDelegate:(id<TomatoSDKDelegate>)delegate
{/*
  testViewIndex = 1;
  if ([delegate respondsToSelector:@selector(addADView:)]) {
  UIView *view = nil;
  NSURL *movieURL = [NSURL URLWithString:@"http://p.you.video.sina.com.cn/swf/quotePlayer20100721_V4_4_39_0.swf?autoPlay=1&as=0&vid=75320134&uid=1883974510"];
  if (testViewIndex == 2) {
  
  MPMoviePlayerController *player = [[MPMoviePlayerController alloc] 
  initWithContentURL:movieURL];
  player.repeatMode = MPMovieRepeatModeOne;
  player.controlStyle = MPMovieControlStyleNone;
  [player setContentURL:movieURL];
  [player setMovieSourceType:MPMovieSourceTypeFile];
  
  player.view.frame = CGRectMake(0, 0, 320, 240);
  view = player.view;
  [player play];
  
  }else {
  movieURL = [NSURL URLWithString:@"http://www.baidu.com"];
  UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
  NSURLRequest *request = [NSURLRequest requestWithURL:movieURL];
  [webView loadRequest:request];
  view = webView;
  }
  
  
  [delegate addADView:view];
  [view release];
  }*/
}

+ (void)logEvent:(NSString *)eventName withView:(UIView *)view
{
    if (apiKeyValid) {
        adParentView = view;
        NSString *urlString = [NSString stringWithFormat:@"%@/_index.php",SERVER_URL];
        NSURL *url = [NSURL URLWithString:urlString];
        PBASIHTTPRequest *request = [PBASIHTTPRequest requestWithURL:url];
        
        [request setDelegate:self];
        [request startAsynchronous];
        
        NSURL *movieURL = [NSURL URLWithString:@"http://192.168.202.49/TestADSDK/sanguo.mp4"];

        /* webView Test
        // http://192.168.202.49/TestADSDK/iPhone_gangtie1.png
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        NSURLRequest *_request = [NSURLRequest requestWithURL:movieURL];
        [webView loadRequest:_request];
        [view addSubview:webView];
        
        [webView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:5];
         //*/
        
        /* video Test
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] 
                                           initWithContentURL:movieURL];
        player.repeatMode = MPMovieRepeatModeOne;
        player.controlStyle = MPMovieControlStyleEmbedded;
        [player setContentURL:movieURL];
        [player setMovieSourceType:MPMovieSourceTypeFile];
        
        player.view.frame = CGRectMake(0, 0, 320, 240);
        [adParentView addSubview:player.view];
        [player play];
        
        [player.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:10];
        // */
    }
}

#pragma mark PBASIHttpRequest Delegate Method
- (void)requestFinished:(PBASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    
    NSString *tempString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",responseString);
    NSLog(@"%@",tempString);
    
    NSURL *movieURL = [NSURL URLWithString:@"http://192.168.202.49/TestADSDK/iPhone_gangtie1.png"];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    NSURLRequest *_request = [NSURLRequest requestWithURL:movieURL];
    [webView loadRequest:_request];
    [adParentView addSubview:webView];
    
    [webView release];
    [movieURL release];
}

- (void)requestFailed:(PBASIHTTPRequest *)request
{

}

- (void)request:(PBASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    
}

@end
