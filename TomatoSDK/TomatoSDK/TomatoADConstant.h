//
//  TomatoADConstant.h
//  TomatoSDK
//
//  Created by xin suo on 12-4-25.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#ifndef TomatoSDK_TomatoADConstant_h
#define TomatoSDK_TomatoADConstant_h

#define REQUEST_TIME        10
#define SDK_VERSION         2
#define TEST                @"test=true"

//URL MACRO
#define SERVER_URL          @"http://192.168.202.49/TestADSDK"
#define REQUEST_SESSION     @"/ses/?"
#define APP_ACTIVE          @"/atv/?"
#define APP_EVENT           @"/evt/?"
#define VIDEO_PLAY_STATS    @"/vps/?"
#define PERSISTENT_AD       @"/imp/?"

//BASIC-DATAS MACRO
#define APPUID              @"APPUID"
#define APPVERSION          @"APPVERSION"
#define PARTID              @"PARTID"       
#define SDKVERSION          @"SDKVERSION"

#define URLVersion          @"URLVersion"
#define UDID                @"UDID"
#define CKID                @"CKID"
#define PUID                @"PUID"
#define OSTYPE              @"OSTYPE"
#define OSVERSION           @"OSVERSION"
#define OSNAME              @"OSNAME"
#define TERMINALTYPE        @"TERMINALTYPE"
#define JAILBREAK           @"JAILBREAK"
#define RESOLUTION          @"RESOLUTION"
#define ORIENTATION         @"ORIENTATION"

#define COORDINATE          @"COORDINATE"
#define NETTYPE             @"NETTYPE"
#define CC                  @"CC"
#define LANG                @"LANG"
#define WMAC                @"WMAC"                
//#define DEVUID              @"DEVUID"





typedef enum {
    ADHtml4Type = 0,
    ADHtml5Type,
    ADVideoType,
    ADScoreRankingType,
    
    ADMax
}ADType;



#endif
