//
//  Auction.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CompleteAuction.h"

@implementation CompleteAuction

- (id) initWithWonItems:(NSMutableDictionary*)wonItems lostItems:(NSMutableDictionary *)lostItems name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture minBidInc:(int)minBidInc {
    self->wonItems = wonItems;
    self->lostItems = lostItems;
    self->name = name;
    self->picture = picture;
    self->auctionID = auctionid;
    self->minBidInc =  minBidInc;
   
   return self;
}

- (NSMutableDictionary*) getWonItems {
    return self->wonItems;
}

- (NSMutableDictionary *) getLostItems {
    return  self->lostItems;
}

@end