//
//  UpcomginAuction.m
//  BidrBird
//
//  Created by Zachary Glazer on 3/7/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import "UpcomingAuction.h"

@implementation UpcomingAuction

- (id) initWithItems:(NSMutableDictionary*)items name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture minBidInc:(int)minBidInc {
    self->items = items;
    self->name = name;
    self->picture = picture;
    self->auctionID = auctionid;
    self->minBidInc = minBidInc;
    
    return self;
}

- (NSDictionary*) getItems {
    return self->items;
}

@end
