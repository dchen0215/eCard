//
//  CheckTargetStatus.h
//  HelloWorld
//
//  Created by Daren Chen on 8/11/13.
//  Copyright (c) 2013 Daren Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignatureBuilder.h"

@interface CheckTargetStatus : NSObject

@property (readwrite, nonatomic) NSString *targetId;

- (int)checkStatus;
- (int)checkRating;
- (void)setHeaders:(NSMutableURLRequest *)request;

- (NSString *)getUTCFormateDate:(NSDate *)localDate;

@end
