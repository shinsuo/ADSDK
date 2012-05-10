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

- (void)Insert:(NSString *)sql;
- (void)Select;
- (void)Delete:(NSUInteger )index;

@end
