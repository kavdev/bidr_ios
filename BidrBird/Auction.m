//
//  Auction.m
//  BidrBird
//
//  Created by Zachary Glazer on 3/7/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#import "Auction.h"

@implementation Auction

-(id) initWithName:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture {
    self->name = name;
    self->picture = picture;
    self->auctionID = auctionid;
    
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
