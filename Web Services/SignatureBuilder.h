//
//  SignatureBuilder.h
//  AugmentedTest
//
//  Created by Daren Chen on 8/10/13.
//  Copyright (c) 2013 Daren Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonHMAC.h>
#import "NSData+MD5.h"
#import "NSData+Base64.h"


@interface SignatureBuilder : NSObject

+ (NSString *)tmsSignature:(NSMutableURLRequest *)request withSecretKey:(NSString *)secretKey;
+ (NSString *)contentMD5:(NSMutableURLRequest *)request;
+ (NSString *)calculateRFC2104HMAC:(NSString *)key withData:(NSString *)data;

@end
