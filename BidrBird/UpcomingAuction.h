//
//  UpcomginAuction.h
//  BidrBird
//
//  Created by Zachary Glazer on 3/7/15.
//  Copyright (c) 2015 Zachary Glazer. All rights reserved.
//

#ifndef BidrBird_UpcomingAuction_h
#define BidrBird_UpcomingAuction_h

#import <UIKit/UIKit.h>
#import "Auction.h"

@interface UpcomingAuction : Auction {
    @public
    NSMutableDictionary *items;
}

-(id) initWithItems:(NSMutableDictionary*)items name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture minBidInc:(int)minBidInc;

- (NSDictionary*) getItems;

@end

#endif
