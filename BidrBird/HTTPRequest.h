//
//  HTTPRequest.h
//  BidrBird
//
//  Created by Zachary Glazer on 2/15/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const WebAddress;

@interface HTTPRequest : NSObject

+ (void) POST:(NSString *)post toExtension:(NSString *)extension delegate:(id)delegate;
+ (void) POST:(NSString *)post toExtension:(NSString *)extension withAuthToken:(NSString*)token delegate:(id)delegate;
+ (void) PUT:(NSString *)put toExtension:(NSString *)extension withAuthToken:(NSString*)token delegate:(id)delegate;
+ (void) GET:(NSString *)get toExtension:(NSString *)extension withAuthToken:(NSString*)token delegate:(id)delegate;

+ (UIImage *) getImageFromFileExtension:(NSString*)extension;

@end
