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
 field  |id   |type|fr     |tt(to)   |n      |t  |dn |dm   |cu     |ds |spt|tp |vpos|      
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
                               @"create table if not exists %@("
                                "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                                "type int,"
                                "fr varchar,"
                                "tt varchar,"
                                "n varchar,"
                                "t int,"
                                "dn int,"
                                "dm float,"
                                "cu varchar,"
                                "ds int,"
                                "spt int,"
                                "tp int,"
                                "vpos int)",RECORDTABLE];
        [staticSqliteManager Create:createSQL];
    }
    return staticSqliteManager;
}

#pragma mark Private Method
- (BOOL)Create:(NSString *)sql
{
    NSString *path = [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0];
//    NSLog(@"path:%@",path);
    if (sqlite3_open([[path stringByAppendingPathComponent:SQLITEFILE] UTF8String], &_database) != SQLITE_OK) {
        sqlite3_close(_database);
        NSLog(@"Error:open database file.");
        return NO;
    }
    
    sqlite3_stmt *statement;
//    NSString *aString = [NSString stringWithFormat:@"%f",[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]];
//    NSString *tsql = @"create table if not exists testTable(ID INTEGER PRIMARY KEY AUTOINCREMENT, testID int,testValue text)";
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
- (BOOL)Insert:(NSString *)sql
{
    NSLog(@"insert");
    if (![self Create:nil]) {
        return ;
    }
    
    sqlite_int64 t = sqlite3_last_insert_rowid(_database);
    if (!sql) {
        sql = [NSString stringWithFormat:@"INSERT INTO testTable(testID,testValue) VALUES(2,'texttest')"];
    }
    
    sqlite3_stmt *statement;
    char *error;
//    sqlite3_exec(_database, [sql UTF8String], nil, nil, &error);
    
    char *tsql = "INSERT INTO testTable(testID,testValue) VALUES(NULL,'texttest')";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, tsql, -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        NSLog(@"Error:failed to prepare statement:insert into ");
        return NO;
    }
    
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error:failed to insert into the database");
        sqlite3_close(_database);
        return NO;
    }
    
    sqlite3_close(_database);
    return YES;
}

- (BOOL)Select
{
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    if (![self Create:nil]) {
        return NO;
    }
    sqlite3_stmt *statement = nil;
//    char *sql = "select testID,testValue from testTable";
    NSString *sql = @"select ";
    
    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error:failed to prepare statement with message:get testValue");
        return NO;
    }else {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            printf("sqlite_row:%d,%s\n",sqlite3_column_int(statement, 0),sqlite3_column_text(statement, 1));
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(_database);
    return YES;
}

- (BOOL)Delete:(NSUInteger )index
{
    NSLog(@"delete");
    if (![self Create:nil]) {
        return NO;
    }
    
    NSString *sql = nil;
    if (!index) {
        sql = @"delete from testTable  where ID = 12";
    }
    sqlite3_stmt *statement;    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        NSLog(@"Error:failed to prepare statement:insert into ");
        return NO;
    }
    
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error:failed to insert into the database");
        sqlite3_close(_database);
        return NO;
    }
    
    sqlite3_close(_database);
    return YES;
}

- (NSUInteger)getCount
{
    
}

@end
