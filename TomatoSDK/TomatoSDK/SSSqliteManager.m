//
//  SqliteManager.m
//  TomatoSDK
//
//  Created by Shin Suo on 12-5-9.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//


/*
 
 EventRecord Table Formate:
         ---------------------------------------------------------------------------
 field  |id   |type|fr     |to       |n      |t  |dn |dm   |cu     |ds |spt|tp |vpos|      
         ---------------------------------------------------------------------------
         ---------------------------------------------------------------------------
 type   |int  |int |varchar|varchar  |varchar|int|int|float|varchar|int|int|int|int |      
         ---------------------------------------------------------------------------
         ---------------------------------------------------------------------------
 value  |1    |1   |1336551380.698816|pause  |1  |10 |0.99 |RMB    |10 |20 |30 |130 |      
         ---------------------------------------------------------------------------
 */

#import "SSSqliteManager.h"

#import "TomatoADConstant.h"

@interface SSSqliteManager()

- (BOOL)Create:(NSString *)sql;
- (void)DeleteAll;

@end

static SSSqliteManager *staticSqliteManager = nil;

@implementation SSSqliteManager

+ (SSSqliteManager *)shareSqliteManager
{
    if (!staticSqliteManager) {
        staticSqliteManager = [[SSSqliteManager alloc] init];
        NSString *createSQL = [NSString stringWithFormat:
                               @"create table if not exists EventRecord("
                                "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                                "type int,"
                                "fr varchar,"
                                "to varchar,"
                                "n varchar,"
                                "t int,"
                                "dn int,"
                                "dm float,"
                                "cu varchar,"
                                "ds int,"
                                "spt int,"
                                "tp int,"
                                "vpos int)"];
        [staticSqliteManager Create:createSQL];
    }
    return staticSqliteManager;
}

#pragma mark Private Method
- (BOOL)Create:(NSString *)sql
{
    NSString *path = [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0];
    if (sqlite3_open([[path stringByAppendingPathComponent:SQLITEFILE] UTF8String], &_database) != SQLITE_OK) {
        sqlite3_close(_database);
        NSLog(@"Error:open database file.");
        return NO;
    }
    
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        NSLog(@"Error:failed to prepare statement:create test table");
        return NO;
    }
    
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        NSLog(@"Error:failed to dehydrate:create table test");
        return NO;
    }
    NSLog(@"Create table 'testTable' successed.");
    return YES;
}

- (void)DeleteAll
{
    
}

#pragma mark Public Method
- (void)Insert:(NSString *)sql
{
    NSLog(@"insert");
    if (!sql) {
        sql = @"";
    }
}

- (void)Select
{
    NSLog(@"select");
    
}

- (void)Delete:(NSUInteger )index
{
    NSLog(@"delete");
    
    NSString *sql = nil;
    if (!index) {
        sql = @"";
    }
}

@end
