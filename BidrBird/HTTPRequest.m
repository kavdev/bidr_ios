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
    //NSString *url = [NSString stringWithFormat:@"http://bidr-staging.herokuapp.com/api/%@", extension];
    NSString *url = [NSString stringWithFormat:@"http://192.168.2.4:8020/api/%@", extension];

    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:FALSE];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *con = [NSURLConnection connectionWithRequest:request delegate:delegate];
    
    if(con) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

+ (void) POST:(NSString *)post toExtension:(NSString *)extension withAuthToken:(NSString*)token delegate:(id)delegate {
    //NSString *url = [NSString stringWithFormat:@"http://bidr-staging.herokuapp.com/api/%@", extension];
    NSString *url = [NSString stringWithFormat:@"http://192.168.2.4:8020/api/%@", extension];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    
    
    //find out correct place from alex
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:[NSString stringWithFormat:@"Token %@", token] forHTTPHeaderField:@"Authorization"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *con = [NSURLConnection connectionWithRequest:request delegate:delegate];
    
    if(con) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

+ (void) PUT:(NSString *)put toExtension:(NSString *)extension withAuthToken:(NSString*)token delegate:(id)delegate {
    //NSString *url = [NSString stringWithFormat:@"http://bidr-staging.herokuapp.com/api/%@", extension];
    NSString *url = [NSString stringWithFormat:@"http://192.168.2.4:8020/api/%@", extension];
    
    NSData *postData = [put dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[put length]];
    
    
    //find out correct place from alex
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"PUT"];
    [request addValue:[NSString stringWithFormat:@"Token %@", token] forHTTPHeaderField:@"Authorization"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *con = [NSURLConnection connectionWithRequest:request delegate:delegate];
    
    if(con) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

+ (void) GET:(NSString *)get toExtension:(NSString *)extension withAuthToken:(NSString*)token delegate:(id)delegate {
    //NSString *url = [NSString stringWithFormat:@"http://bidr-staging.herokuapp.com/api/%@", extension];
    NSString *url = [NSString stringWithFormat:@"http://192.168.2.4:8020/api/%@", extension];
    
    NSData *postData = [get dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[get length]];
    
    
    //find out correct place from alex
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:[NSString stringWithFormat:@"Token %@", token] forHTTPHeaderField:@"Authorization"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *con = [NSURLConnection connectionWithRequest:request delegate:delegate];
    
    if(con) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

@end
