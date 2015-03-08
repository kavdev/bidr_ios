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

- (id) initWithWonItems:(NSMutableArray*)wonItems lostItems:(NSMutableArray *)lostItems name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture {
    self->wonItems = wonItems;
    self->lostItems = lostItems;
    self->name = name;
    self->picture = picture;
    self->auctionID = auctionid;
   
   return self;
}

- (NSMutableArray*) getWonItems {
    return self->wonItems;
}

- (NSMutableArray *) getLostItems {
    return  self->lostItems;
}

@end