//
//  SXViewController.m
//  TestADSDK
//
//  Created by xin suo on 12-4-19.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import "SXViewController.h"
#import "TomatoSDK.h"

@interface SXViewController ()

@end

@implementation SXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [TomatoSDK startSession:@"apiKey"];
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
    [TomatoSDK logEvent:[NSString stringWithFormat:@"Event%i",btn.tag] withView:self.view];
    
}
@end