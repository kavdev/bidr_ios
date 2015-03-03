//
//  Item.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id) initWithName:(NSString*)name description:(NSString*)description highestBid:(double)highestBid condition:(NSString*)condition picture:(UIImage *)picture itemID:(int)itemID {
   self->name = name;
   self->description = description;
   self->highestBid = highestBid;
   self->condition = condition;
   self->picture = picture;
   self->itemID = itemID;
   
   return self;
}

- (NSString*) getName {
   return self->name;
}

- (NSString*) getDescription {
   return self->description;
}

- (double) getHightestBid {
   return self->highestBid;
}

- (NSString*) getCondition {
   return self->condition;
}

- (UIImage*) getPicture {
   return self->picture;
}


@end
