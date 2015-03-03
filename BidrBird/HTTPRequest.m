//
//  HTTPRequest.m
//  BidrBird
//
//  Created by Zachary Glazer on 2/15/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import "HTTPRequest.h"

@implementation HTTPRequest

+ (void) POST:(NSString *)post toExtension:(NSString *)extension delegate:(id)delegate {
    NSString *url = [NSString stringWithFormat:@"http://bidr-staging.herokuapp.com/api/%@", extension];
    post = @"name=test&email=test@test.com&phone_number=+18052088178&password=test";
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:FALSE];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLConnection *con = [NSURLConnection connectionWithRequest:request delegate:delegate];
    
    if(con) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

+ (void) POST:(NSString *)post toExtension:(NSString *)extension withAuthToken:(NSString*)token delegate:(id)delegate {
    NSString *url = [NSString stringWithFormat:@"http://bidr-staging.herokuapp.com/api/%@", extension];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    
    
    //find out correct place from alex
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:[NSString stringWithFormat:@"Token %@", token] forHTTPHeaderField:@"Authorization"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLConnection *con = [NSURLConnection connectionWithRequest:request delegate:delegate];
    
    if(con) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

@end
