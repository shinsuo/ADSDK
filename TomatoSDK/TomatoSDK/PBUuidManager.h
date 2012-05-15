//
//  PBUuidManager.h
//  PBOffer_Demo
//
//  Created by XiaoFeng on 12-3-26.
//  Copyright (c) 2012年 PunchBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBUuidManager : NSObject
{

}

+(id)sharedManager;

-(NSString *)currentUuid;

//Shin add
- (NSString *)getCKID:(NSString *)macAddr;

@end
