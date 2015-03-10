//
//  NavigationController.h
//  BidrBird
//
//  Created by Zachary Glazer on 1/22/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPRequest.h"

@interface NavigationController : UINavigationController <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSMutableData *responseData;
}

@property (nonatomic) NSString *auth_token;
@property (nonatomic) NSString *user_email;
@property (nonatomic) NSString *user_id;
@property (nonatomic) NSString *user_name;
@property (nonatomic) NSString *user_phone_number;


@end
