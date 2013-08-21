//
//  PostNewTarget.h
//  AugmentedTest
//
//  Created by Daren Chen on 8/10/13.
//  Copyright (c) 2013 Daren Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignatureBuilder.h"

@interface PostNewTarget : NSObject

@property (readwrite, nonatomic) NSString *targetName;
@property (readwrite, nonatomic) UIImage *imageTarget;
@property (readwrite, nonatomic) NSString *metaData;

@property (readwrite, nonatomic) NSString *resultCode;

- (NSString *)postTarget;
- (void)setRequestBody:(NSMutableURLRequest *)request;
- (void)setHeaders:(NSMutableURLRequest *)request;
- (NSString *)getUTCFormateDate:(NSDate *)localDate;

@end
