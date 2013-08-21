//
//  CheckTargetStatus.m
//  HelloWorld
//
//  Created by Daren Chen on 8/11/13.
//  Copyright (c) 2013 Daren Chen. All rights reserved.
//

#import "CheckTargetStatus.h"

@implementation CheckTargetStatus

@synthesize targetId;

// Status codes
#define TARGET_ACTIVE 0
#define TARGET_FAILURE 1
#define TARGET_PROCESSING 2
#define TARGET_INACTIVE 3
#define FAIL_TO_CONNECT 101
#define UNKNOWN_PROBLEM 102

// Change the access key/secret key of the cloud database here
static NSString *const accessKey = @"ac89e4d6dbf9fa49c650670af43c55a4b175d3e1";
static NSString *const secretKey = @"11636e7443fead60aa3ea4cc0cffb45d9a6fb63a";


// Destination server
static NSString *const url = @"https://vws.vuforia.com/targets";

- (int)checkStatus
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:
                                                                         [NSString stringWithFormat:@"%@/%@", url, self.targetId]]];
    [request setHTTPMethod:@"GET"];
    
    // The body is empty for this service call
    [self setHeaders:request];
    
    // Call out to the server and get the response
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *jsonString = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    // See if the service call is executed successfully
    NSString *resultCode = [jsonString objectForKey:@"result_code"];
    if (![resultCode isEqualToString:@"Success"])
    {
        return FAIL_TO_CONNECT;  // There was a problem retrieving the list
    }
    else {
        NSString *status = [jsonString objectForKey:@"status"];
        if (![status isEqualToString:@"success"]) {
            if ([status isEqualToString:@"failed"])
                return TARGET_FAILURE;  // The created target is in failure status
            else if ([status isEqualToString:@"processing"])
                return TARGET_PROCESSING;  //The created target is under processing
            else return UNKNOWN_PROBLEM;
        }
        else {
            NSDictionary *targetRecord = [jsonString objectForKey:@"target_record"];
            NSNumber *activeFlag = [targetRecord objectForKey:@"active_flag"];
            if ([activeFlag isEqualToNumber:[NSNumber numberWithBool:TRUE]])
                return TARGET_ACTIVE;  // The target is created successfully and is not active
            else
                return TARGET_INACTIVE;  // The target is set to be active yet
        }
    }
}

- (int)checkRating
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:
                                                                         [NSString stringWithFormat:@"%@/%@", url, self.targetId]]];
    [request setHTTPMethod:@"GET"];
    
    // The body is empty for this service call
    [self setHeaders:request];
    
    // Call out to the server and get the response
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *jsonString = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    // See if the service call is executed successfully
    NSString *resultCode = [jsonString objectForKey:@"result_code"];
    if (![resultCode isEqualToString:@"Success"])
    {
        return FAIL_TO_CONNECT;  // There was a problem retrieving the list
    }
    else {
        NSDictionary *targetRecord = [jsonString objectForKey:@"target_record"];
        NSNumber *trackingRating = [targetRecord objectForKey:@"tracking_rating"];
        return [trackingRating intValue];
    }
}

- (void)setHeaders:(NSMutableURLRequest *)request
{
    NSDate *now = [NSDate date];
    NSString *dateString = [self getUTCFormateDate:now];
    
    // Log the time out
    NSLog(@"CheckTargetStatus executed at: %@", dateString);
    
    [request setValue:dateString forHTTPHeaderField:@"Date"];
    
    // Set the authorization string
    NSString *authorizationString = [NSString stringWithFormat:@"VWS %@:%@", accessKey, [SignatureBuilder tmsSignature:request withSecretKey:secretKey]];
    // Log it out
    // Delete befotre production, please
    // NSLog(@"The authorization string is: %@", authorizationString);
    [request setValue:authorizationString forHTTPHeaderField:@"Authorization"];
}

// Format the data time
- (NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"];
    
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    
    return dateString;
}

@end
