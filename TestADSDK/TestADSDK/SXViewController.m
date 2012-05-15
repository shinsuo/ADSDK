//
//  SXViewController.m
//  TestADSDK
//
//  Created by xin suo on 12-4-19.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import "SXViewController.h"
#import "TomatoSDK.h"

#import <MediaPlayer/MediaPlayer.h>

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

//#import "ASIHTTPRequest.h"
//#import "ASIHTTPRequestDelegate.h"

@interface SXViewController ()

@end

@implementation SXViewController
@synthesize label;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [TomatoSDK startSession:@"1234567890" withDEVID:@"34565456" withPUID:@"37856483"];
    [TomatoSDK setDelegate:self];
    /*
    MPMoviePlayerController *movieController = [[MPMoviePlayerController alloc] init];
//    movieController.view.backgroundColor = [UIColor clearColor];
    movieController.view.frame = CGRectMake(10, 10, 300, 460);
    movieController.contentURL = [NSURL URLWithString:@"http://192.168.202.49/TestADSDK/sanguo.mp4"];
    movieController.shouldAutoplay = YES;
    movieController.controlStyle = MPMovieControlStyleEmbedded;
    [self.view addSubview:movieController.view];
    
//    [movieController play];
     //*/
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSLog(@"carrier:%@", [carrier description]);
    label.text = carrier.carrierName;
    
    NSLog(@"%@",label.text);
}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    [TomatoSDK logSingleEvent:[NSString stringWithFormat:@"Event%i",btn.tag]];
}

#pragma mark TomatoAdDelegate Method
- (void)didReceived:(TomatoAdView *)adView withParameters:(NSDictionary *)parameters
{
    [self.view addSubview:adView];
}

- (void)didFailWithMessage:(NSString *)msg
{
    
}

- (void)dealloc {
    [label release];
    [super dealloc];
}
@end
