//
//  PostNewTarget.m
//  AugmentedTest
//
//  Created by Daren Chen on 8/10/13.
//  Copyright (c) 2013 Daren Chen. All rights reserved.
//

#import "PostNewTarget.h"

// Change the access key/secret key of the cloud database here
static NSString *const accessKey = @"ac89e4d6dbf9fa49c650670af43c55a4b175d3e1";
static NSString *const secretKey = @"11636e7443fead60aa3ea4cc0cffb45d9a6fb63a";

// Destination server
static NSString *const url = @"https://vws.vuforia.com/targets";

@implementation PostNewTarget

@synthesize targetName;
@synthesize imageTarget;
@synthesize metaData;
@synthesize resultCode;


- (NSString *)postTarget
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    // Set the body and the header
    // Note that settting the header must be done after setting the body
    // becasuse one of the required elements in header - authorization string, is
    // calculated based on the body
    [self setRequestBody:request];
    [self setHeaders:request];
    
    // Test
    // NSString* testString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    // NSLog(@"%@", testString);
    //
    
    // Call out to the server and get the response
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Process the response
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *jsonString = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    // Log out the full response from the server
    NSLog(@"Response from the server: %@", responseString);
    
    NSString *uniqueTargetId = [jsonString objectForKey:@"target_id"];
    self.resultCode = [jsonString objectForKey:@"result_code"];
    
    // Log the created target id out
    if (uniqueTargetId != nil)
        NSLog(@"Created target with id: %@", uniqueTargetId);
    
    // Need to check if any target id is returned at all
    return uniqueTargetId;
}

- (void)setRequestBody:(NSMutableURLRequest *)request
{
    NSData *imageData = UIImagePNGRepresentation(self.imageTarget);
    NSString *imageDataString = [imageData base64EncodedString];
    
    NSString *metaDataString = [[metaData dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];

    // Name, width, image are mandatory, while active_flag is optional
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:targetName, @"name", [NSNumber numberWithFloat:320.0], @"width", imageDataString, @"image", metaDataString, @"application_metadata", nil];
    
    // Create a JSON message
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    // Set the JSON body of the HTTP POST
    [request setHTTPBody:jsonData];
}

- (void)setHeaders:(NSMutableURLRequest *)request
{
    NSDate *now = [NSDate date];
    NSString *dateString = [self getUTCFormateDate:now];
    
    // Log the time out
    NSLog(@"PostNewTarget executed at: %@", dateString);
    
    [request setValue:dateString forHTTPHeaderField:@"Date"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
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
