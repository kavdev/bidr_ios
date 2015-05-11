//
//  UserSessionInfo.m
//  BidrBird
//
//  Created by Zachary Glazer on 4/14/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import "UserSessionInfo.h"

@implementation UserSessionInfo

-(id) initWithUserEmail:(NSString *)userEmail userID:(NSString *)userID userName:(NSString *)userName userPhoneNumber:(NSString *)userPhoneNumber {
    self.user_email = userEmail;
    self.user_id = userID;
    self.user_name = userName;
    self.user_phone_number = userPhoneNumber;
    
    return self;
}

@end