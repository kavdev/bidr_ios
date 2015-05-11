//
//  UserSessionInfo.h
//  BidrBird
//
//  Created by Zachary Glazer on 4/14/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#ifndef BidrBird_UserSessionInfo_h
#define BidrBird_UserSessionInfo_h

#import <Foundation/Foundation.h>

@interface UserSessionInfo : NSObject {}

@property (nonatomic) NSString *auth_token;
@property (nonatomic) NSString *user_email;
@property (nonatomic) NSString *user_id;
@property (nonatomic) NSString *user_name;
@property (nonatomic) NSString *user_phone_number;

-(id) initWithUserEmail:(NSString *)amount userID:(NSString *)userID userName:(NSString *)userName userPhoneNumber:(NSString *)userPhoneNumber;

@end

#endif
