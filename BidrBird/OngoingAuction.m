//
//  OngoingAuction.m
//  BidrBird
//
//  Created by Zachary Glazer on 12/3/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#import "OngoingAuction.h"

@implementation OngoingAuction

-(id) initWithWinningItems:(NSMutableDictionary*)winning losingItems:(NSMutableDictionary*)losing unbidItems:(NSMutableDictionary*)unbid name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture minBidInc:(int)minBidInc {
    self->winningItems = winning;
    self->losingItems = losing;
    self->unbidItems = unbid;
    self->name = name;
    self->picture = picture;
    self->auctionID = auctionid;
    self->minBidInc = minBidInc;
   
   return self;
}

@end