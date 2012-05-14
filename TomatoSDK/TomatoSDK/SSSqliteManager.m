//
//  SqliteManager.m
//  TomatoSDK
//
//  Created by Shin Suo on 12-5-9.
//  Copyright (c) 2012年 CocoaChina. All rights reserved.
//


/*
 
 EventRecord Table Formate:
         -------------------------
 field  |id   |url      |postData |     
         -------------------------
         -------------------------
 type   |int  |varchar  |         |
         -------------------------
         -------------------------
 value  |1    |1        |         |
         -------------------------
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
        
        [staticSqliteManager Create:nil];
    }
    return staticSqliteManager;
}

#pragma mark Private Method
- (BOOL)Create:(NSString *)sql
{
    NSString *path = [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0];
    NSLog(@"path:%@",path);
    if (sqlite3_open([[path stringByAppendingPathComponent:SQLITEFILE] UTF8String], &_database) != SQLITE_OK) {
        sqlite3_close(_database);
        NSLog(@"Error:open database file.");
        return NO;
    }
    
    sqlite3_stmt *statement;
    NSString *createSQL = [NSString stringWithFormat:
                           @"create table if not exists %@("
                           "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                           "url varchar,"
                           "postData varchar)",RECORDTABLE];
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, [createSQL UTF8String], -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        NSLog(@"Error:failed to prepare statement:create table");
        return NO;
    }
    
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        NSLog(@"Error:failed to dehydrate:create table");
        return NO;
    }
    return YES;
}

- (void)DeleteAll
{
    
}

#pragma mark Public Method
- (BOOL)Insert:(NSArray *)sqlArray
{
    NSLog(@"insert");
    if (![self Create:nil] && !sqlArray) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(url,postData) VALUES ('%@','%@')",RECORDTABLE,[sqlArray objectAtIndex:0],[sqlArray objectAtIndex:1]];

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

- (NSArray *)Select
{
    if (![self Create:nil]) {
        return NO;
    }
    sqlite3_stmt *statement = nil;
    NSString *sql = [NSString stringWithFormat:@"select id,url,postData from %@",RECORDTABLE];
    NSArray *array = nil;
    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error:failed to prepare statement with message:get testValue");
        return NO;
    }else {
        sqlite3_step(statement);
            const unsigned char *url = sqlite3_column_text(statement, 1);
            const unsigned char *postData = sqlite3_column_text(statement, 2);
            array = [NSArray arrayWithObjects:
                     [NSNumber numberWithInt:sqlite3_column_int(statement, 0)],
                      [NSString stringWithCString:(const char *)url encoding:NSUTF8StringEncoding],
                      [NSString stringWithCString:(const char *)postData encoding:NSUTF8StringEncoding], nil];
    }
    sqlite3_finalize(statement);
    sqlite3_close(_database);
    return array;
}

- (BOOL)Delete:(NSUInteger )index
{
    if (![self Create:nil]) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where id = %i",RECORDTABLE,index];
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
    if (![self Create:nil]) {
        return NO;
    }
    sqlite3_stmt *statement = nil;
    NSString *sql = [NSString stringWithFormat:@"select count(id) from %@",RECORDTABLE];
    int count = 0;
    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error:failed to prepare statement with message");
        return NO;
    }else {
        sqlite3_step(statement);
        count = sqlite3_column_int(statement, 0);
    }
    return count;
}

@end
