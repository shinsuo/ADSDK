//
//  TomatoSDKConnection.m
//  TomatoSDK
//
//  Created by Shin Suo on 12-4-26.
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

#import "SSSqliteManager.h"

@interface TomatoSDKConnection()

- (void)getBasicDatas;
- (void)sendActivity;
- (void)requestOffLine;

- (NSString *)addRND:(NSString *)string;
- (NSString *)getURL:(NSString *)string;
- (void)changedOrientation:(NSNotification *)notification;
- (void)changedGPS:(NSNotification *)notification;
- (void)changedNetType:(NSNotification *)notification;

@end

static NSUInteger debugMode = 0;

@implementation TomatoSDKConnection

@synthesize apiKey;
@synthesize apiKeyValid;
@synthesize delegate = delegate_;

@synthesize dn;
@synthesize dm;
@synthesize cu;
@synthesize score;

#pragma mark Public Method
+ (void)setDebugMode
{
    debugMode = 1;
}

- (id)init
{
    if (self = [super init]) {
        //init received Data
        receivedData_ = [[NSMutableData alloc] init];
        
        //get EventRecord Count
        eventCount = [[SSSqliteManager shareSqliteManager] getCount];
        if (eventCount) {
            [[SSSqliteManager shareSqliteManager] Select];
        }
        
        //init event Array
        
        //set Debug
        if (debugMode) {
            isDebug_ = [NSString stringWithFormat:@"&test=1"];
        }else {
            isDebug_ = [NSString stringWithFormat:@"&test=0"];
        }
        //get Hardware Info
        UIDeviceExtend *device = [UIDeviceExtend currentDevice];
        
        PBReachability *r = [[PBReachability reachabilityForInternetConnection] retain];
        [r connectionRequired];
        [r startNotifier];

        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];

        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        
        //get Version,platform runed
         NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
         
         NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
         
         NSString *version1 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
         NSLog(@"executableFile:%@---version:%@----version1:%@",executableFile,version,version1);
        
        NSString *family = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIDeviceFamily"]];
        NSUInteger index = [family rangeOfString:@"2"].location;
        if (index == 6) {
            //iPad
        }else if (index == 13) {
            //Universal
        }else {
            //iPhone
        }
        
        
        //init BasicData Dict
        basicDataDicts_ = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                       @"11111111",APPUID, 
                       [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey],APPVERSION,
                       @"",PARTID,
                       @"2",URLVERSION,
                       device.uniqueIdentifier,UDID,
                       @"",CKID,
                       @"",PUID,
                       device.systemName,OSTYPE,
                       device.systemVersion,OSVERSION,
                       device.platform,DEVICETYPE,
                       [NSString stringWithFormat:@"%i",device.isJailBroken],ISJAILBREAK,
                       [NSString stringWithFormat:@"%.f,%.f",screenSize.width*screenScale,screenSize.height*screenScale],RESOLUTION,
                       [NSString stringWithFormat:@"%i",device.orientation],ORIENTATION,                 //can Changed
                       @"",GPS,                         //can Changed
                       [NSString stringWithFormat:@"%i",[r currentReachabilityStatus]],NETTYPE,   //can Changed
                       [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode],CC,
                       [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0],LANG,
                       device.getMacAddress,WMAC,
                       nil];
        NSLog(@"device:%@",device.uniqueIdentifier);
        //init BasicData String
        basicDataString_ = [NSString stringWithFormat:@"&v=%i&uid=%@&ckid=%@&dt=%@&osv=%@&os=%@&jb=%@&sr=%@&ori=%@&gps=%@&net=%i&app=%@&appv=%@&cc=%@&lang=%@&sdk=%@&dev=%@&puid=%@&wmac=%@",SDKVERSION,//v
                            [basicDataDicts_ objectForKey:UDID],//uid
                            [basicDataDicts_ objectForKey:CKID],//ckid
                            [basicDataDicts_ objectForKey:DEVICETYPE],//dt
                            [basicDataDicts_ objectForKey:OSVERSION],//osv
                            [basicDataDicts_ objectForKey:OSVERSION],//os
                            [basicDataDicts_ objectForKey:ISJAILBREAK],//jb
                            [basicDataDicts_ objectForKey:RESOLUTION],//sr
                            [basicDataDicts_ objectForKey:ORIENTATION],//ori
                            [basicDataDicts_ objectForKey:GPS],//gps
                            [basicDataDicts_ objectForKey:NETTYPE],//net
                            [basicDataDicts_ objectForKey:APPUID],//app
                             version,//appv
                             [basicDataDicts_ objectForKey:CC],//cc
                             [basicDataDicts_ objectForKey:LANG],//lang
                             [basicDataDicts_ objectForKey:UDID],//sdk
                             [basicDataDicts_ objectForKey:UDID],//dev
                            [basicDataDicts_ objectForKey:OSTYPE],//puid
                            [basicDataDicts_ objectForKey:WMAC]//wmac
                            ];
        
        
        
        //register Notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name: PBkReachabilityChangedNotification
                                                   object: nil];
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [receivedData_ release];
    [basicDataDicts_ release];
    [webView_ release];
}

- (void)requestSession:(NSString *)apiKey_
{
    //defaule apiKeyValid value
    self.apiKeyValid = NO;
    //save apiKey
    self.apiKey = apiKey_;
    //向server发送apiKey_，验证apiKey是否合法
    
    //send Session
    
    
    //send Activity
    [self sendActivity];
}

- (void)requestEventName:(NSString *)eventName withType:(EVENT_TYPE)eventType
{
    //*
//    NSURL *url = [urlArray objectAtIndex:eventType];
    urlString_ = [urlDict_ objectForKey:APP_EVENT];
    urlString_ = [urlString_  stringByAppendingString:[NSString stringWithFormat:@"&t=%i",eventType]];
    urlString_ = [urlString_  stringByAppendingString:[NSString stringWithFormat:@"&rnd=%i",arc4random()%10000]];
    
    url_ = [NSURL URLWithString:urlString_];
    PBASIFormDataRequest *formRequest = [PBASIFormDataRequest requestWithURL:url_];
    
    [formRequest setPostValue:eventName forKey:@"n"];
    [formRequest setPostValue:@"1" forKey:@"oo"];
    [formRequest setPostValue:[NSString stringWithFormat:@"%i",(int)[[NSDate date] timeIntervalSince1970]] forKey:@"fr"];
    [formRequest setPostValue:eventName forKey:@"n"];
    
    switch (eventType) {
        case EVENTSINGLE:
            
            break;
        case EVENTPURCHASE:
            [formRequest setPostValue:[NSString stringWithFormat:@"%i",self.dn] forKey:@"dn"];
            [formRequest setPostValue:[NSString stringWithFormat:@"%f",self.dm] forKey:@"dm"];
            [formRequest setPostValue:[NSString stringWithFormat:@"%s",self.cu] forKey:@"cu"];
            break;
        case EVENTSCORE:
            [formRequest setPostValue:[NSString stringWithFormat:@"%i",self.score] forKey:@"ds"];
            break;
        case EVENTSPENDSECONDS:

            break;
        default:
            break;
    }
    
    [formRequest setDelegate:self];
    [formRequest startAsynchronous];
    //*/
}

#pragma mark Private Method

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

- (void)sendActivity
{
    urlString_ = [self getURL:APP_ACTIVE];
    url_ = [NSURL URLWithString:[self addRND:urlString_]];
    PBASIFormDataRequest *formRequest = [PBASIFormDataRequest requestWithURL:url_];
    
    [formRequest setDelegate:self];
    [formRequest startAsynchronous];
}

- (void)requestOffLine
{
    if (eventCount) {
        NSArray *array = [NSArray arrayWithArray:[[SSSqliteManager shareSqliteManager] Select]];
        NSNumber *idNumber = (NSNumber *)[array objectAtIndex:0];
        NSString *postBodyString = [array objectAtIndex:2];
        
        NSString *tempURLString = [array objectAtIndex:1];
        PBASIHTTPRequest *request = [PBASIHTTPRequest requestWithURL:[NSURL URLWithString:[tempURLString stringByAppendingString:@"&oo=0"]]];
        request.sxId = idNumber.intValue;
        request.isOffLine = YES;
        request.postBody = (NSMutableData *)[postBodyString dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setDelegate:self];
        [request startSynchronous];
    }
}

- (NSString *)addRND:(NSString *)string
{
    string = [string stringByAppendingString:isDebug_];
    string = [string stringByAppendingString:[NSString stringWithFormat:@"&rnd=%i",arc4random()%10000]];
    string = [string stringByAppendingString:[NSString stringWithFormat:@"&fr=%i",(int)[[NSDate date] timeIntervalSince1970]]];
    //&oo=1 放在最后，偏于requestFail后删除该后缀，然后添加到数据库中
    string = [string stringByAppendingString:[NSString stringWithFormat:@"&oo=1"]];
    return string;
}

- (NSString *)getURL:(NSString *)string
{

    NSString *tempURL = nil;
    if ([string isEqualToString:REQUEST_SESSION]) {
        tempURL = [NSString stringWithFormat:@"%@%@%@",SERVER_URL,REQUEST_SESSION,basicDataString_];
    }else if ([string isEqualToString:APP_ACTIVE]) {
        tempURL = [NSString stringWithFormat:@"%@%@%@",SERVER_URL,APP_ACTIVE,basicDataString_];
    }else if ([string isEqualToString:APP_EVENT]) {
        tempURL = [NSString stringWithFormat:@"%@%@%@",SERVER_URL,APP_EVENT,basicDataString_];
    }else if ([string isEqualToString:VIDEO_PLAY_STATS]) {
        tempURL = [NSString stringWithFormat:@"%@%@%@",SERVER_URL,VIDEO_PLAY_STATS,basicDataString_];
    }else if ([string isEqualToString:PERSISTENT_AD]) {
        tempURL = [NSString stringWithFormat:@"%@%@%@",SERVER_URL,PERSISTENT_AD,basicDataString_];
    }
    NSLog(@"tempURL:%@",tempURL);
    return tempURL;
}

#pragma mark PBASIHttpRequest Delegate
- (void)requestFinished:(PBASIHTTPRequest *)request
{
//    NSLog(@"requestFinished:postBody:%@--url:%@",[[NSString alloc] initWithData:[request postBody] encoding:NSUTF8StringEncoding],[[request url] absoluteURL]);
    
    //if isOffLine eventCount will reduce
    if (request.isOffLine) {
        eventCount--;
        [[SSSqliteManager shareSqliteManager] Delete:request.sxId];
    }else {
        if ([receivedData_ length]) {
            NSError *error = nil;
            NSMutableDictionary *dataDict = [[PBCJSONDeserializer deserializer] deserialize:receivedData_ error:&error];
            if (error) {
                NSLog(@"error:%@",[error userInfo]);
            }
            
            NSString *result        = [dataDict objectForKey:@"result"];
            NSString *ver           = [dataDict objectForKey:@"ver"];
            NSString *items         = [dataDict objectForKey:@"items"];
            NSArray *datas          = [dataDict objectForKey:@"datas"];
            NSDictionary *adData    = [datas objectAtIndex:items.intValue-1];
            NSString *type          = [adData objectForKey:@"type"];
            NSString *body          = [adData objectForKey:@"body"];
            NSString *pos           = [adData objectForKey:@"pos"];
            NSString *size          = [adData objectForKey:@"size"];
            
            UIView *view = nil;
            CGPoint tempPos;
            CGSize tempSize;
            switch (type.intValue) {
                case ADHTML4TYPE:
                case ADHTML5TYPE:
                {   
                    if (!webView_) {
                        webView_ = [[UIWebView alloc] initWithFrame:CGRectMake(tempPos.x , tempPos.y , tempSize.width, tempSize.height)];
                        webView_.backgroundColor = [UIColor clearColor];
                        webView_.scrollView.scrollEnabled = NO;
                    }
                    [webView_ loadHTMLString:body baseURL:nil];
                    
                    view = webView_;
                }
                    break;
                case ADSCROERANKINGTYPE:
                    
                    break;
                case ADVIDEOTYPE:
                {
                     if (!movieController_) {
                     movieController_ = [[MPMoviePlayerController alloc] init ];
                     movieController_.view.backgroundColor = [UIColor clearColor];
                     movieController_.view.frame =CGRectMake(tempPos.x , tempPos.y , tempSize.width, tempSize.height);
                     movieController_.shouldAutoplay = YES;
                     movieController_.controlStyle = MPMovieControlStyleEmbedded;      
                     }
                     movieController_.contentURL = [NSURL URLWithString:body];
                    
                     view = movieController_.view;
                } 
                    break;
                default:
                    break;
            }
            
            if ([delegate_ respondsToSelector:@selector(didReceived:withParameters:)]) {
                [delegate_ didReceived:(TomatoAdView *)view withParameters:nil];  
            }
            [receivedData_ setData:nil ];
        }
    }
}

- (void)requestFailed:(PBASIHTTPRequest *)request
{
    NSString *postString = [[NSString alloc] initWithData:[request postBody] encoding:NSUTF8StringEncoding];
    NSString *tempURLString = [[request url] absoluteString];
    if ([tempURLString hasSuffix:@"&oo=1"]) {
        NSRange range = [tempURLString rangeOfString:@"&oo=1"];
        tempURLString = [tempURLString substringToIndex:range.location];
    };
    NSArray *tempData = [NSArray arrayWithObjects:tempURLString,postString, nil];
    if ([[SSSqliteManager shareSqliteManager] Insert:tempData]) {
        eventCount++;
    };
}

- (void)request:(PBASIHTTPRequest *)request didReceiveData:(NSData *)data
{   
//    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"dataString:%@",dataString);
//    [dataString release];
    [receivedData_ appendData:data];
}

#pragma mark Notification Method
- (void)reachabilityChanged:(NSNotification *)notification
{
//    NSLog(@"reachabilityChanged:notification:%@",notification);
    PBReachability *curReach = [notification object];
    NSParameterAssert([curReach isKindOfClass: [PBReachability class]]);
    switch ([curReach currentReachabilityStatus]) {
        case kNotReachable: // Apple's code depends upon 'NotReachable' being the same value as 'NO'.
            NSLog(@"reachabilityChanged kNotReachable");
            break;
        case kReachableViaWWAN:    // Switched order from Apple's enum. WWAN is active before WiFi.
            NSLog(@"reachabilityChanged kReachableViaWWAN");
            [self requestOffLine];
            break;
        case kReachableViaWiFi:
            NSLog(@"reachabilityChanged kReachableViaWiFi");
            [self requestOffLine];
            break;
            
        default:
            break;
    }
}

- (void)changedOrientation:(NSNotification *)notification
{
    [basicDataDicts_ setObject:[NSString stringWithFormat:@"%i",[UIDevice currentDevice].orientation] forKey:ORIENTATION];
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
            webView_.frame =CGRectMake(10, 10, 300, 50);
            [webView_ loadHTMLString:@"<html><body>UIDeviceOrientationPortrait</body></html>" baseURL:nil];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            webView_.frame =CGRectMake(10, 10, 300, 50);
            [webView_ loadHTMLString:@"<html><body>UIDeviceOrientationPortraitUpsideDown</body></html>" baseURL:nil];
            break;
        case UIDeviceOrientationLandscapeLeft:
            webView_.frame =CGRectMake(10, 10, 460, 50);
            [webView_ loadHTMLString:@"<html><body>UIDeviceOrientationLandscapeLeft</body></html>" baseURL:nil];
            break;
        case UIDeviceOrientationLandscapeRight:
            webView_.frame =CGRectMake(10, 10, 460, 50);
            [webView_ loadHTMLString:@"<html><body>UIDeviceOrientationLandscapeRight</body></html>" baseURL:nil];
            break;
        default:
            break;
    }
}

#pragma mark LocationDelegate Method
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [basicDataDicts_ setObject:[NSString stringWithFormat:@"%.2f,%.2f",newLocation.coordinate.latitude,newLocation.coordinate.longitude] forKey:GPS];
//    NSLog(@"%@",[NSString stringWithFormat:@"%.2f,%.2f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
}

//

@end
