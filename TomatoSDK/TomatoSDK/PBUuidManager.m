//
//  PBUuidManager.m
//  PBOffer_Demo
//
//  Created by XiaoFeng on 12-3-26.
//  Copyright (c) 2012年 PunchBox. All rights reserved.
//

#import "PBUuidManager.h"

//#import <CommonCrypto/CommonHMAC.h>
//#import <Security/Security.h>
//#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#define PB_UUID_KEY     @"pbuuid"
#define PB_UUID_LENGTH  40

@interface PBUuidManager()
{
    NSString *  _uuidMark;
}

@property (nonatomic, retain) NSString *    uuidMark;

- (NSData *)getHashBytes:(NSData *)plainText;
- (NSString *)sha1:(NSString *)hashkey;

@end

@implementation PBUuidManager

@synthesize uuidMark = _uuidMark;

static PBUuidManager *  _sharedUuidManager = nil;

+(id)sharedManager
{
    @synchronized(self)
    {
        if(!_sharedUuidManager)
            _sharedUuidManager = [[super allocWithZone:nil] init];

        return _sharedUuidManager;
    }
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}


-(id)init
{
    self = [super init];
    if (self)
    {
        NSUserDefaults *handler = [NSUserDefaults standardUserDefaults];
        self.uuidMark = [NSString stringWithFormat:@"%@", [handler objectForKey:PB_UUID_KEY]];
        
        if (nil == self.uuidMark || PB_UUID_LENGTH > [self.uuidMark length])
        {
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);

            NSString *result = [NSString stringWithFormat:@"%@", uuidStr];
            self.uuidMark = [self sha1:result];

            CFRelease(uuidStr);
            CFRelease(uuid);
            [handler setObject:self.uuidMark forKey:PB_UUID_KEY];
            [handler synchronize];
        }
    }

    return self;
}


-(void)dealloc
{
    self.uuidMark = nil;
    [super dealloc];
}


-(NSString *)currentUuid
{
    return self.uuidMark;
}


- (NSData *)getHashBytes:(NSData *)plainText
{
    CC_SHA1_CTX ctx;
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;
    
    // Malloc a buffer to hold hash.
    hashBytes = malloc( CC_SHA1_DIGEST_LENGTH * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, CC_SHA1_DIGEST_LENGTH);
    
    // Initialize the context.
    CC_SHA1_Init(&ctx);
    // Perform the hash.
    CC_SHA1_Update(&ctx, (void *)[plainText bytes], [plainText length]);
    // Finalize the output.
    CC_SHA1_Final(hashBytes, &ctx);
    
    // Build up the SHA1 blob.
    hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)CC_SHA1_DIGEST_LENGTH];
    
    if (hashBytes)
        free(hashBytes);
    
    return hash;
}


- (NSString *)sha1:(NSString *)hashkey
{
	const char *s = [hashkey cStringUsingEncoding:NSASCIIStringEncoding];
	NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
	
	NSData *result = [self getHashBytes:keyData];
    
	NSString *hash = [result description];
	hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
	hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
	hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
	return hash;
}

- (NSString *)getCKID:(NSString *)macAddr
{
    return [self sha1:macAddr];
}

@end
