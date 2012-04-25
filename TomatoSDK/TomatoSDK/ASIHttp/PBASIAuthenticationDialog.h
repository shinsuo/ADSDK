//
//  ASIAuthenticationDialog.h
//  Part of ASIHTTPRequest -> http://allseeing-i.com/ASIHTTPRequest
//
//  Created by Ben Copsey on 21/08/2009.
//  Copyright 2009 All-Seeing Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PBASIHTTPRequest;

typedef enum _ASIAuthenticationType {
	ASIStandardAuthenticationType = 0,
    ASIProxyAuthenticationType = 1
} PBASIAuthenticationType;

@interface PBASIAutorotatingViewController : UIViewController
@end

@interface PBASIAuthenticationDialog : PBASIAutorotatingViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {
	PBASIHTTPRequest *request;
	PBASIAuthenticationType type;
	UITableView *tableView;
	UIViewController *presentingController;
	BOOL didEnableRotationNotifications;
}
+ (void)presentAuthenticationDialogForRequest:(PBASIHTTPRequest *)request;
+ (void)dismiss;

@property (retain) PBASIHTTPRequest *request;
@property (assign) PBASIAuthenticationType type;
@property (assign) BOOL didEnableRotationNotifications;
@property (retain, nonatomic) UIViewController *presentingController;
@end
