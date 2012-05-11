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
- (void)requestActivity;
- (void)requestOffLine;

- (void)changedOrientation:(NSNotification *)notification;
- (void)changedGPS:(NSNotification *)notification;
- (void)changedNetType:(NSNotification *)notification;

@end

static NSUInteger debugMode = 0;

@implementation TomatoSDKConnection

@synthesize apiKey;
@synthesize apiKeyValid;
@synthesize delegate = delegate_;

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
        [[SSSqliteManager shareSqliteManager] Select];
        
        //init event Array
//        eventArray_ = [[NSMutableArray alloc] init];
        
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
        
        
        //init Basic Data
        basicDatas_ = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                       @"11111111",APPUID, 
                       [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey],APPVERSION,
                       @"",PARTID,
                       @"2",SDKVERSION,
                       @"2",URLVERSION,
                       device.uniqueIdentifier,UDID,
                       @"",CKID,
                       @"",PUID,
                       device.systemName,OSTYPE,
                       device.systemVersion,OSVERSION,
                       device.platform,DEVICETYPE,
                       [NSString stringWithFormat:@"%i",device.isJailBroken],JAILBREAK,
                       [NSString stringWithFormat:@"%.f,%.f",screenSize.width*screenScale,screenSize.height*screenScale],RESOLUTION,
                       [NSString stringWithFormat:@"%i",device.orientation],ORIENTATION,                 //can Changed
                       @"",GPS,                         //can Changed
                       [NSString stringWithFormat:@"%i",[r currentReachabilityStatus]],NETTYPE,   //can Changed
                       [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode],CC,
                       [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0],LANG,
                       device.getMacAddress,WMAC,
                       nil];
        
        //init url Array
        urlArray_ = [NSArray arrayWithObjects:@"",@"",@"",@"", nil];
        
        //register Notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name: PBkReachabilityChangedNotification
                                                   object: nil];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self 
//                                                 selector:@selector(changedOrientation:) 
//                                                     name:UIDeviceOrientationDidChangeNotification 
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self 
//                                                 selector:@selector(changedGPS:) 
//                                                     name:@""
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self 
//                                                 selector:@selector(changedNetType:) 
//                                                     name:PBkReachabilityChangedNotification 
//                                                   object:nil];
        [self getBasicDatas];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [receivedData_ release];
    [basicDatas_ release];
    [webView_ release];
}

- (void)requestSession:(NSString *)apiKey_
{
    //defaule apiKeyValid value
    self.apiKeyValid = NO;
    //save apiKey
    self.apiKey = apiKey_;
    //向server发送apiKey_，验证apiKey是否合法
    
    [self requestActivity];
    
}

- (void)requestEventName:(NSString *)eventName withType:(EVENT_TYPE)eventType
{
    //*
//    NSURL *url = [urlArray objectAtIndex:eventType];
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.8.184/TestADSDK/form.php?oo=123&tt=32"];
    NSURL *url = [NSURL URLWithString:urlString];
    /*
    PBASIHTTPRequest *request = [PBASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    currentEventName_ = [NSString stringWithFormat:eventName];
     //*/
    //*
    
    
    if (debugMode) {
        [urlString  stringByAppendingString:@"&test=1"];
    }
    PBASIFormDataRequest *formRequest = [PBASIFormDataRequest requestWithURL:url];
    
    [formRequest setPostValue:@"suoxinname" forKey:@"username"];
    [formRequest setPostValue:@"suoxinpasswor" forKey:@"password"];
    
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

- (void)requestActivity
{
    
}

- (void)requestOffLine
{
    if (eventCount > 0) {
        NSArray *array = [NSArray arrayWithArray:[[SSSqliteManager shareSqliteManager] Select]];
        NSNumber *idNumber = (NSNumber *)[array objectAtIndex:0];
        NSString *postBodyString = [array objectAtIndex:2];
        
        PBASIHTTPRequest *request = [PBASIHTTPRequest requestWithURL:[array objectAtIndex:1]];
        request.sxId = idNumber.intValue;
        request.isOffLine = YES;
        request.postBody = (NSMutableData *)[postBodyString dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setDelegate:self];
        [request startSynchronous];
    }
}


#pragma mark PBASIHttpRequest Delegate
- (void)requestFinished:(PBASIHTTPRequest *)request
{
    NSLog(@"requestFinished:postBody:%@--url:%@",[[NSString alloc] initWithData:[request postBody] encoding:NSUTF8StringEncoding],[[request url] absoluteURL]);
    
    //if isOffLine eventCount will reduce
    if (request.isOffLine) {
        eventCount--;
        [[SSSqliteManager shareSqliteManager] Delete:request.sxId];
    }else {
        if (receivedData_) {
            NSError *error = nil;
            NSMutableDictionary *dataDict = [[PBCJSONDeserializer deserializer] deserialize:receivedData_ error:&error];
            if (error) {
                NSLog(@"error:%@",[error userInfo]);
            }
            
            NSString *result = [dataDict objectForKey:@"result"];
            NSString *ver = [dataDict objectForKey:@"ver"];
            NSString *items = [dataDict objectForKey:@"items"];
            NSArray *datas = [dataDict objectForKey:@"datas"];
            NSDictionary *adData = [datas objectAtIndex:items.intValue-1];
            NSString *type = [adData objectForKey:@"type"];
            NSString *body = [adData objectForKey:@"body"];
            NSString *pos = [adData objectForKey:@"pos"];
            NSString *size = [adData objectForKey:@"size"];
            
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
            //
            //    NSLog(@"requestFinished:%@",[request responseString]);
            //for Testing
            
            int X = 10,Y = 10,W = 300,H = 50;
            NSData *bodyData = nil;
            UIView *view = nil;
            
            if (!webView_) {
                webView_ = [[UIWebView alloc] initWithFrame:CGRectMake(X , Y , W, H)];
                webView_.backgroundColor = [UIColor clearColor];
                webView_.scrollView.scrollEnabled = NO;
                view = webView_;
            }
            //    [webView_ loadData:bodyData MIMEType:nil textEncodingName:nil baseURL:nil];
            [webView_ loadHTMLString:[[NSString alloc] initWithData:receivedData_ encoding:NSUTF8StringEncoding] baseURL:nil];
            //    NSURLRequest *trequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"display_ad" ofType:@"htm"]]];
            //    [webView_ loadRequest:trequest];
            
            /*
             if (!movieController_) {
             movieController_ = [[MPMoviePlayerController alloc] init ];
             movieController_.view.backgroundColor = [UIColor clearColor];
             movieController_.view.frame =CGRectMake(10, 10, 300 , 200);
             movieController_.shouldAutoplay = YES;
             movieController_.controlStyle = MPMovieControlStyleEmbedded;
             //        view = movieController_.view;
             }
             movieController_.contentURL = [NSURL URLWithString:@"http://192.168.202.49/TestADSDK/sanguo.mp4"];
             */
            
            if ([delegate_ respondsToSelector:@selector(didReceived:withParameters:)]) {
                [delegate_ didReceived:(TomatoAdView *)view withParameters:nil];  
            }
        }
    }
}

- (void)requestFailed:(PBASIHTTPRequest *)request
{
    NSString *postString = [[NSString alloc] initWithData:[request postBody] encoding:NSUTF8StringEncoding];
    NSString *urlString = [[request url] absoluteString];
    
    NSArray *tempData = [NSArray arrayWithObjects:urlString,postString, nil];
    if ([[SSSqliteManager shareSqliteManager] Insert:tempData]) {
        eventCount++;
    };
}

- (void)request:(PBASIHTTPRequest *)request didReceiveData:(NSData *)data
{
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
    [basicDatas_ setObject:[NSString stringWithFormat:@"%i",[UIDevice currentDevice].orientation] forKey:ORIENTATION];
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
    [basicDatas_ setObject:[NSString stringWithFormat:@"%.2f,%.2f",newLocation.coordinate.latitude,newLocation.coordinate.longitude] forKey:GPS];
//    NSLog(@"%@",[NSString stringWithFormat:@"%.2f,%.2f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
}

//

@end
