//
//  Auction.m
//  BidrBird
//
//  Created by Zachary Glazer on 3/7/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import "Auction.h"

@implementation Auction

-(id) initWithName:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture  minBidInc:(int)minBidInc {
    self->name = name;
    self->picture = picture;
    self->auctionID = auctionid;
    self->minBidInc =  minBidInc;
    
    return self;
}

- (NSString*) getName {
    return self->name;
}

- (UIImage*) getPicture {
    return self->picture;
}

- (NSString *) getAuctionID {
    return self->auctionID;
}

@end
