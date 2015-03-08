//
//  OngoingAuction.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "OngoingAuction.h"

@implementation OngoingAuction

-(id) initWithBidOnItems:(NSMutableArray*)items otherItems:(NSMutableArray*)otherItems name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture {
   self->bidOnItems = items;
   self->otherItems = otherItems;
   self->name = name;
   self->picture = picture;
    self->auctionID = auctionid;
   
   return self;
}

- (NSMutableArray*) getBidOnItems {
   return self->bidOnItems;
}

- (NSMutableArray*) getOtherItems {
   return self->otherItems;
}

@end