//
//  NSData+Base64.h
//  AugmentedTest
//
//  Created by Daren Chen on 8/10/13.
//  Copyright (c) 2013 Daren Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;

@end
