//
//  SXViewController.h
//  TestADSDK
//
//  Created by xin suo on 12-4-19.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TomatoAdDelegate.h"

@interface SXViewController : UIViewController <TomatoAdDelegate>

- (IBAction)btnClicked:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *label;
- (IBAction)btnInsert:(id)sender;
- (IBAction)btnDelete:(id)sender;

@end
