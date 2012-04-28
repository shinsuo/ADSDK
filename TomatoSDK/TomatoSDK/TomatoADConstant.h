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
#define APPUID              @"app"
#define APPVERSION          @"appv"
#define PARTID              @"part"       
#define SDKVERSION          @"sdk"

#define URLVERSION          @"v"
#define UDID                @"uid"
#define CKID                @"ckid"
#define PUID                @"puid"
#define OSTYPE              @"ost"
#define OSVERSION           @"osv"
#define OSNAME              @"os"
#define TERMINALTYPE        @"dt"
#define JAILBREAK           @"jb"
#define RESOLUTION          @"sr"
#define ORIENTATION         @"ori"

#define COORDINATE          @"gps"
#define NETTYPE             @"net"
#define CC                  @"cc"
#define LANG                @"lang"
#define WMAC                @"wmac"                
//#define DEVUID              @"dev"

//ONLINE OFFLINE
#define ONLINEOFFLINE       @"oo"

//EVENT-BASIC-DATAS MACRO
#define EVENTNAME           @"n"
#define EVENTTYPE           @"t"

#define TOMATORANDOM        @"rnd"

//EVENT-PURCHASE MACRO
#define BUYCOUNT            @"dn"
//#define TAKEMONEY           @"dm"
//#define CASHUNIT            @"cu"

//EVENT-SCORE MACRO
#define SCORE               @"ds"

//EVENT-SPENDSECONDS MACRO
#define SPENDSECONDS        @"spt"
#define ENDTIME             @"to"



typedef enum {
    ADHtml4Type = 0,
    ADHtml5Type,
    ADVideoType,
    ADScoreRankingType,
    
    ADMax
}ADType;

typedef enum {
    EventOnLine = 0,
    EventOffLine,
    
    EventSingle = 1,
    EventPurchase,
    EventScore,
    EventSpendSeconds,
    
    EventMax,
}EventType;

#endif
