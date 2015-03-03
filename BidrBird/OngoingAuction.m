//
//  OngoingAuction.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "OngoingAuction.h"

@implementation OngoingAuction

-(id) initWithBidOnItems:(NSArray*)items otherItems:(NSArray*)otherItems name:(NSString*)name picture:(UIImage*)picture {
   self->bidOnItems = items;
   self->otherItems = otherItems;
   self->name = name;
   self->picture = picture;
   
   return self;
}

- (NSArray*) getBidOnItems {
   return self->bidOnItems;
}

- (NSArray*) getOtherItems {
   return self->otherItems;
}

- (NSString*) getName {
   return self->name;
}

- (UIImage*) getPicture {
   return self->picture;
}

@end