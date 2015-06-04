//
//  Auction.h
//  BidrBird
//
//  Created by Zachary Glazer on 12/2/14.
//  Copyright (c) 2014 Zachary Glazer. All rights reserved.
//

#ifndef BidrBird_CompleteAuction_h
#define BidrBird_CompleteAuction_h

#import <UIKit/UIKit.h>
#import "Auction.h"

@interface CompleteAuction : Auction {
    @public
    NSMutableDictionary *wonItems;
    NSMutableDictionary *lostItems;
}

- (id) initWithWonItems:(NSMutableDictionary*)wonItems lostItems:(NSMutableDictionary *)lostItems name:(NSString*)name auctionID:(NSString *)auctionid picture:(UIImage*)picture minBidInc:(int)minBidInc;

- (NSMutableDictionary *) getWonItems;
- (NSMutableDictionary *) getLostItems;

@end

#endif
