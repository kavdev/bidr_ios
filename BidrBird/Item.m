//
//  Item.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id) initWithName:(NSString*)name description:(NSString*)description highestBid:(Bid *)highestBid condition:(NSString*)condition picture:(UIImage *)picture itemID:(int)itemID minimumBid:(int)minBid usersHighestBid:(Bid*)uHBid {
    self->name = name;
    self->description = description;
    self->highestBid = highestBid;
    self->condition = condition;
    self->picture = picture;
    self->itemID = itemID;
    self->minBid = minBid;
    self->usersHighestBid = uHBid;
   
   return self;
}

- (NSString*) getName {
   return self->name;
}

- (NSString*) getDescription {
   return self->description;
}

- (Bid *) getHightestBid {
   return self->highestBid;
}

- (NSString*) getCondition {
   return self->condition;
}

- (UIImage*) getPicture {
   return self->picture;
}


@end
