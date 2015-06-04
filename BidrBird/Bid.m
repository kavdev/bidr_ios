//
//  Bid.m
//  BidrBird
//
//  Created by Zachary Glazer on 3/8/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import "Bid.h"

@implementation Bid

-(id) initWithAmount:(int)amount userID:(int)userID displayName:(NSString *)displayName; {
    self->amount = amount;
    self->userID = userID;
    self->displayName = displayName;
    
    return self;
}

@end
