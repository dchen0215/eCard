//
//  SignatureBuilder.m
//  AugmentedTest
//
//  Created by Daren Chen on 8/10/13.
//  Copyright (c) 2013 Daren Chen. All rights reserved.
//

#import "SignatureBuilder.h"


@implementation SignatureBuilder

+ (NSString *)tmsSignature:(NSMutableURLRequest *)request withSecretKey:(NSString *)secretKey
{
    NSString *method = request.HTTPMethod;
    NSString *contentType = @"";
    NSString *hexDigest = @"d41d8cd98f00b204e9800998ecf8427e";  // Hex digest of an empty string
    
    if ([method.uppercaseString isEqualToString:@"GET"] || [method.uppercaseString isEqualToString:@"DELETE"]) {
        NSLog(@"GET/DELETE");
        // Do nothing because the strings are already set correctly
    }
    else if ([method.uppercaseString isEqualToString:@"POST"] || [method.uppercaseString isEqualToString:@"PUT"]) {
        contentType = @"application/json";
        
        // Calculate the hexadecimal MD5 hash of the whole request body
        hexDigest = [self contentMD5:request];
    }
    else {
        NSLog(@"ERROR: Invalid content type passed to Sig Builder");
    }
    
    // Date in the header and date used to calculate the hash must be the same
    NSString *dateValue = [request valueForHTTPHeaderField:(@"Date")];
    // The result is /targets
    NSString *requestPath = request.URL.path;
    // Put all the stuff together
    NSString *toDigest = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@", method, hexDigest, contentType, dateValue, requestPath];
    
    // Create the signature
    NSString *shaHashed = [self calculateRFC2104HMAC:secretKey withData:toDigest];
    
    return shaHashed;
}

+ (NSString *)contentMD5:(NSMutableURLRequest *)request;
{
    return [[request HTTPBody] MD5];
}

+ (NSString *)calculateRFC2104HMAC:(NSString *)key withData:(NSString *)data
{
    NSData *cKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cData = [data dataUsingEncoding:NSUTF8StringEncoding];
    // const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    // const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    // OMG!!!!!!
    // Should have used kCCHmacAlgSHA1 instead of kCCHmacAlgSHA256 as the CCHmacAlgorithm
    // CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    CCHmac(kCCHmacAlgSHA1, [cKey bytes], [cKey length], [cData bytes], [cData length], cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    return [HMAC base64EncodedString];
}

@end
