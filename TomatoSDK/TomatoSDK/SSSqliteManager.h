//
//  SqliteManager.h
//  TomatoSDK
//
//  Created by Shin Suo on 12-5-9.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <sqlite3.h>

@interface SSSqliteManager : NSObject
{
    sqlite3 *_database;
}

+ (SSSqliteManager *)shareSqliteManager;

- (NSUInteger)Insert:(NSString *)urlString_ withPostString:(NSString *)postString_;
- (NSArray *)SelectBut:(NSUInteger)sessionID;
- (BOOL)Delete:(NSUInteger )index;
- (NSUInteger)getCount;
- (BOOL)Update:(NSUInteger)rowID withString:(NSString *)urlString_;

@end
