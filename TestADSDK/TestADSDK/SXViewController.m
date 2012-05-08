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

//#import "ASIHTTPRequest.h"
//#import "ASIHTTPRequestDelegate.h"

@interface SXViewController ()

@end

@implementation SXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [TomatoSDK startSession:@"apiKey"];
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
}

- (void)viewDidUnload
{
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
 
    /*
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    */
    
}

#pragma mark TomatoAdDelegate Method
- (void)didReceived:(TomatoAdView *)adView withParameters:(NSDictionary *)parameters
{
    NSLog(@"developer didReceived");
    [self.view addSubview:adView];
    
    [adView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3];
}

- (void)didFailWithMessage:(NSString *)msg
{

}

@end
